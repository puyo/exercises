default {
    state_entry() {
        llownersay("tile " + (string)llgetlinknumber() + " default state entry.");
    }

    changed(integer change) {
        llownersay("tile " + (string)llgetlinknumber() + " state changed: " + (string)change);
        if (change & changed_link && llgetlinknumber() == 0) 
            lldie(); // so i die        
    }

    link_message(integer sender, integer num, string str, key id) {
        llownersay("tile " + (string)llgetlinknumber() + " received query " + str);
        // list re_list;
        // if (str == "query") {
        //     llownersay("tile " + (string)llgetlinknumber() + " received query.");
        //     llownersay(llgetkey());
        //     llownersay(llgetlinkkey(llgetlinknumber()));
        // } else {
        //     re_list = llparsestring2list(str, ["|"], [""]);     
        //     type = lllist2integer(re_list, 0);
        //     number = lllist2integer(re_list, 1);
        // }
    }

    touch_start(integer total_number) {
        llownersay("tile " + (string)llgetlinknumber() + " touched");
    }
}
