// TOWNS

list TOWN_INFO;
integer TOWN_INFO_LEN;
integer TOWN_INFO_ID = 0;
integer TOWN_INFO_LINK = 1;
integer TOWN_INFO_FACE = 2;
integer TOWN_INFO_COUNT = 3;

// ------------------------------------------------------
// functions for towns

towns_set_prims(list ids, vector colour, string texture) {
    integer i;
    integer link;
    integer last_link;
    integer face;
    list args;
    integer len;
    integer id;

    last_link = town_link(0);
    args = [];
    len = llGetListLength(ids);

    for (i = 0; i < len; ++i) {
        id = llList2Integer(ids, i);
        link = town_link(id);

        if (last_link != link) {
            llSetLinkPrimitiveParamsFast(last_link, args);
            last_link = link;
            args = [];
        }

        face = town_face(id);
        args += [
            PRIM_COLOR, face, colour, 1.0,
            PRIM_TEXTURE, face, texture, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0
        ];
    }
    llSetLinkPrimitiveParamsFast(link, args);
}

list town_info() {
    list result;

    integer link;

    // now: id, link, face
    // next: id, link, face, town1_id, town2_id, [town3_id | -1]

    link = 13;
    result += [ 0, link, 0];
    result += [ 1, link, 1];
    result += [ 2, link, 2];
    result += [ 3, link, 3];
    result += [ 4, link, 4];
    result += [ 5, link, 5];
    result += [ 6, link, 6];
    result += [ 7, link, 7];

    link = 16;
    result += [ 8, link, 0];
    result += [ 9, link, 1];
    result += [10, link, 2];
    result += [11, link, 3];
    result += [12, link, 4];
    result += [13, link, 5];
    result += [14, link, 6];
    result += [15, link, 7];

    link = 10;
    result += [16, link, 0];
    result += [17, link, 1];
    result += [18, link, 2];
    result += [19, link, 3];
    result += [20, link, 4];
    result += [21, link, 5];
    result += [22, link, 6];
    result += [23, link, 7];

    link = 12;
    result += [24, link, 0];
    result += [25, link, 1];
    result += [26, link, 2];
    result += [27, link, 3];
    result += [28, link, 4];
    result += [29, link, 5];
    result += [30, link, 6];
    result += [31, link, 7];

    link = 14;
    result += [32, link, 0];
    result += [33, link, 1];
    result += [34, link, 2];
    result += [35, link, 3];
    result += [36, link, 4];
    result += [37, link, 5];
    result += [38, link, 6];
    result += [39, link, 7];

    link = 24;
    result += [40, link, 0];
    result += [41, link, 1];
    result += [42, link, 2];
    result += [43, link, 3];
    result += [44, link, 4];
    result += [45, link, 5];
    result += [46, link, 6];
    result += [47, link, 7];

    link = 11;
    result += [48, link, 0];
    result += [49, link, 1];
    result += [50, link, 2];
    result += [51, link, 3];
    result += [52, link, 4];
    result += [53, link, 5];

    return result;
}

integer town_link(integer i) {
    return llList2Integer(TOWN_INFO, TOWN_INFO_COUNT * i + TOWN_INFO_LINK);
}

integer town_face(integer i) {
    return llList2Integer(TOWN_INFO, TOWN_INFO_COUNT * i + TOWN_INFO_FACE);
}

integer town_clicked() {
    integer face = llDetectedTouchFace(0);
    integer link = llDetectedLinkNumber(0);
    integer i;
    for (i = 0; i < TOWN_INFO_LEN; ++i) {
        if (town_link(i) == link && town_face(i) == face) {
            return i;
        }
    }
    return -1;
}

list list_range(integer min, integer max) {
    list result;
    integer i;
    for (i = min; i < max; ++i) { result += i; }
    return result;
}

default {
    state_entry() {
        TOWN_INFO = town_info();
        TOWN_INFO_LEN = llGetListLength(TOWN_INFO) / TOWN_INFO_COUNT;
    }

    link_message(integer sender, integer num, string msg, key id) {
        if (msg == "towns_blank") {
            towns_set_prims(list_range(0, 54), <1.0, 1.0, 1.0>, TEXTURE_TRANSPARENT);
        }
    }
}
