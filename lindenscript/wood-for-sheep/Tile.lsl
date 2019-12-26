integer index = -1;

default {
    state_entry()
    {
        llSetRemoteScriptAccessPin(1234);
    }

    on_rez(integer param) {
        index = param;
    }

    changed(integer change) {
        if ((change & CHANGED_LINK) ) {
            if (llGetLinkNumber() == 0) {
                llDie(); // so i die
            }
        }
    }

    link_message(integer source, integer num, string str, key id)
    {
        if (str == "whatindex") {
            llMessageLinked(source, index, "index", "");
        }
    }
}
