string note = "boneeasy.rules";

// ===================================================================

list rules = [];
key readLineQuery;
key readTotalLinesQuery;
integer noteLineNum;
integer noteTotalLines;
string lastIdentifier;
list lastIdentifierValues = [];
integer isLoading = 0;

load() {
    isLoading = 1;
    rules = [];
    readTotalLinesQuery = llGetNumberOfNotecardLines(note);
}

loadDone() {
    storeRule(lastIdentifier, lastIdentifierValues);
    lastIdentifier = "";
    lastIdentifierValues = [];
    isLoading = 0;
    llOwnerSay("Loading: 100%. Touch to say a pick up line.");
}

readRule(string rule) {
    if (rule == "") return;
    list parsed = llParseStringKeepNulls(rule, [" --> "], []);
    string identifier = llList2String(parsed, 0);
    if (identifier == "") return;
    string newValue = llList2String(parsed, 1);
    if (lastIdentifier == identifier) {
        lastIdentifierValues = [newValue] + lastIdentifierValues;
    } else {
        if (lastIdentifier != "") {
           storeRule(lastIdentifier, lastIdentifierValues);
        }
        lastIdentifier = identifier;
        lastIdentifierValues = [newValue];
    }
}

storeRule(string identifier, list values) {
    rules = rules + [identifier] + values + [-1];
}

string replacement(string identifier) {
    integer index;
    index = llListFindList(rules, [identifier]);
    if (~index) { // found
        integer i = index;
        while (llList2Integer(rules, i) != -1) ++i;
        list values = llList2List(rules, index + 1, i - 1);
        return llList2String(llListRandomize(values, 1), 0);
    }
    llOwnerSay("Warning: Identifier '" + identifier + "' not found.");
    return identifier;
}

generate() {
    if (isLoading) {
        llOwnerSay("Still loading. Please wait.");
        return;
    }
    string result = expand("{SENTENCE}");
    // capitalise
    result = llToUpper(llGetSubString(result, 0, 0)) + llDeleteSubString(result, 0, 0);
    llSay(0, result);
}

string expand(string line) {
    //llOwnerSay("Debug: expand('" + line + "')");
    list result = llParseStringKeepNulls(line, ["{", "}"], []);
    string identifier;
    integer i;
    integer len = llGetListLength(result);
    for (i = 1; i < len; i += 2) {
        identifier = llList2String(result, i);
        result = llListReplaceList(result, [expand(replacement(identifier))], i, i);
    }
    return llDumpList2String(result, "");
}

default {
    state_entry() {
        load();
    }

    touch_start(integer total_number) {
        generate();
    }

    dataserver(key queryId, string data) {
        if (queryId == readLineQuery) {
            if (data == EOF) {
                loadDone();
            } else {
                if ((noteLineNum % 40) == 0) {
                    integer pct = noteLineNum * 100 / noteTotalLines;
                    integer freeMem = llGetFreeMemory();
                    llOwnerSay("Loading: " + (string)pct + "%, " + (string)freeMem + " bytes left");
                }
                readRule((string)data);
                noteLineNum++;
                readLineQuery = llGetNotecardLine(note, noteLineNum);
            }
        } else if (queryId == readTotalLinesQuery) {
            noteTotalLines = (integer)data;
            noteLineNum = 0;
            readLineQuery = llGetNotecardLine(note, noteLineNum);
        }
    }
}
