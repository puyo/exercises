// ROADS

list ROAD_INFO;
integer ROAD_INFO_LEN;
integer ROAD_INFO_ID = 0;
integer ROAD_INFO_LINK = 1;
integer ROAD_INFO_FACE = 2;
integer ROAD_INFO_COUNT = 3;

prim_roads_set(list ids, vector colour, string texture) {
    integer i;
    integer last_link;
    integer link;
    integer face;
    list args;
    integer len;
    integer id;
    
    last_link = road_link(0);
    args = [];
    len = llGetListLength(ids);

    for (i = 0; i < len; ++i) {
        id = llList2Integer(ids, i);
        link = road_link(id);

        if (last_link != link) {
            llSetLinkPrimitiveParamsFast(last_link, args);
            last_link = link;
            args = [];
        }

        face = road_face(id);
        args += [
            PRIM_COLOR, face, colour, 1.0,
            PRIM_TEXTURE, face, texture, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0
        ];
    }
    llSetLinkPrimitiveParamsFast(link, args);
}

list road_info() {
    list result;

    integer link;

    // id, link, face, town1, town2, road1, road2, road3, road4

    link = 1;
    result += [ 0, link, 0];
    result += [ 1, link, 1];
    result += [ 2, link, 2];
    result += [ 3, link, 3];
    result += [ 4, link, 4];
    result += [ 5, link, 5];
    result += [ 6, link, 6];
    result += [ 7, link, 7];

    link = 9;
    result += [ 8, link, 0];
    result += [ 9, link, 1];
    result += [10, link, 2];
    result += [11, link, 3];
    result += [12, link, 4];
    result += [13, link, 5];
    result += [14, link, 6];
    result += [15, link, 7];

    link = 8;
    result += [16, link, 0];
    result += [17, link, 1];
    result += [18, link, 2];
    result += [19, link, 3];
    result += [20, link, 4];
    result += [21, link, 5];
    result += [22, link, 6];
    result += [23, link, 7];

    link = 6;
    result += [24, link, 0];
    result += [25, link, 1];
    result += [26, link, 2];
    result += [27, link, 3];
    result += [28, link, 4];
    result += [29, link, 5];
    result += [30, link, 6];
    result += [31, link, 7];

    link = 5;
    result += [32, link, 0];
    result += [33, link, 1];
    result += [34, link, 2];
    result += [35, link, 3];
    result += [36, link, 4];
    result += [37, link, 5];
    result += [38, link, 6];
    result += [39, link, 7];

    link = 3;
    result += [40, link, 0];
    result += [41, link, 1];
    result += [42, link, 2];
    result += [43, link, 3];
    result += [44, link, 4];
    result += [45, link, 5];
    result += [46, link, 6];
    result += [47, link, 7];

    link = 2;
    result += [48, link, 0];
    result += [49, link, 1];
    result += [50, link, 2];
    result += [51, link, 3];
    result += [52, link, 4];
    result += [53, link, 5];
    result += [54, link, 6];
    result += [55, link, 7];

    link = 7;
    result += [56, link, 0];
    result += [57, link, 1];
    result += [58, link, 2];
    result += [59, link, 3];
    result += [60, link, 4];
    result += [61, link, 5];
    result += [62, link, 6];
    result += [63, link, 7];

    link = 4;
    result += [64, link, 0];
    result += [65, link, 1];
    result += [66, link, 2];
    result += [67, link, 3];
    result += [68, link, 4];
    result += [69, link, 5];
    result += [70, link, 6];
    result += [71, link, 7];

    return result;
}

integer road_link(integer i) {
    return llList2Integer(ROAD_INFO, ROAD_INFO_COUNT * i + ROAD_INFO_LINK);
}

integer road_face(integer i) {
    return llList2Integer(ROAD_INFO, ROAD_INFO_COUNT * i + ROAD_INFO_FACE);
}

list list_range(integer min, integer max) {
    list result;
    integer i;
    for (i = min; i < max; ++i) { result += i; }
    return result;
}

default
{
    state_entry()
    {
        ROAD_INFO = road_info();
        ROAD_INFO_LEN = llGetListLength(ROAD_INFO) / ROAD_INFO_COUNT;
    }

    link_message(integer sender, integer num, string msg, key id) {
        if (msg == "roads_blank") {
            prim_roads_set(list_range(0, ROAD_INFO_LEN), <1.0, 1.0, 1.0>, TEXTURE_TRANSPARENT);
        }
    }
}

