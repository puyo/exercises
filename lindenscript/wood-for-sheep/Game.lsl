// ------------------------------------------------------
// constants

integer CHANNEL = 537713;

integer WATER = 1;
integer DESERT = 2;
integer WOOD = 3;
integer SHEEP = 4;
integer ORE = 5;
integer BRICK = 6;
integer WHEAT = 7;
integer PORT_3FOR1 = 102;
integer PORT_WOOD = 103;
integer PORT_SHEEP = 104;
integer PORT_ORE = 105;
integer PORT_BRICK = 106;
integer PORT_WHEAT = 107;

list HEX_INFO;
integer HEX_INFO_LEN;
integer HEX_INFO_ID = 0;
integer HEX_INFO_LINK = 1;
integer HEX_INFO_FACE = 2;
integer HEX_INFO_POSITION = 3;
integer HEX_INFO_ROTATION = 4;
integer HEX_INFO_OFFSETS = 5;
integer HEX_INFO_BASE_TYPE = 6;
integer HEX_INFO_COUNT = 7;

list ROAD_INFO;
integer ROAD_INFO_LEN;
integer ROAD_INFO_ID = 0;
integer ROAD_INFO_LINK = 1;
integer ROAD_INFO_FACE = 2;
integer ROAD_INFO_COUNT = 3;

list TOWN_INFO;
integer TOWN_INFO_LEN;
integer TOWN_INFO_ID = 0;
integer TOWN_INFO_LINK = 1;
integer TOWN_INFO_FACE = 2;
integer TOWN_INFO_COUNT = 3;

integer BASE_LAND = 1;
integer BASE_PORT = 2;
integer BASE_WATER = 3;

float X0 = 0.5;
float Y0 = 0.5;
float XSTEP = 0.075;
float YSTEP = 0.0833;
float ZPOS = 0.01;

list HEX_TEXTURE_OFFSET_LIST;


// ------------------------------------------------------
// variables

list hex_types;
list hex_numbers;

integer listen_handle;
integer num_links;
integer current_player;
list highlighted_towns;

// ------------------------------------------------------
// functions for lists

list list_range(integer min, integer max) {
    list result;
    integer i;
    for (i = min; i < max; ++i) { result += i; }
    return result;
}

list list_range_inclusive(integer min, integer max) {
    list result;
    integer i;
    for (i = min; i <= max; ++i) { result += i; }
    return result;
}

list list_shuffle(list l) {
    return llListRandomize(l, 1);
}

// ------------------------------------------------------
// functions for hexes

integer hex_link(integer i) {
    return llList2Integer(HEX_INFO, HEX_INFO_COUNT * i + HEX_INFO_LINK);
}

integer hex_face(integer i) {
    return llList2Integer(HEX_INFO, HEX_INFO_COUNT * i + HEX_INFO_FACE);
}

vector hex_position(integer i) {
    return llList2Vector(HEX_INFO, HEX_INFO_COUNT * i + HEX_INFO_POSITION);
}

float hex_rotation(integer i) {
    return llList2Float(HEX_INFO, HEX_INFO_COUNT * i + HEX_INFO_ROTATION);
}

vector hex_offsets(integer i) {
    return llList2Vector(HEX_INFO, HEX_INFO_COUNT * i + HEX_INFO_OFFSETS);
}

integer hex_base_type(integer i) {
    return llList2Integer(HEX_INFO, HEX_INFO_COUNT * i + HEX_INFO_BASE_TYPE);
}

integer hex_type(integer i) {
    return llList2Integer(hex_types, i);
}

integer hex_number(integer i) {
    return llList2Integer(hex_numbers, i);
}

string hex_texture(integer type, integer number) {
  string name;

  if (type == WATER) {
      name = "water";
  } else if (type == DESERT) {
      name = "desert";
  } else if (type == WOOD) {
      name = "wood" + (string)number;
  } else if (type == SHEEP) {
      name = "sheep" + (string)number;
  } else if (type == ORE) {
      name = "ore" + (string)number;
  } else if (type == BRICK) {
      name = "brick" + (string)number;
  } else if (type == WHEAT) {
      name = "wheat" + (string)number;
  } else if (type == PORT_3FOR1) {
      name = "port3for1";
  } else if (type == PORT_WOOD) {
      name = "portwood";
  } else if (type == PORT_SHEEP) {
      name = "portsheep";
  } else if (type == PORT_ORE) {
      name = "portore";
  } else if (type == PORT_BRICK) {
      name = "portbrick";
  } else if (type == PORT_WHEAT) {
      name = "portwheat";
  } else {
      name = "unknown";
  }
  return name;
}

list hex_texture_offsets() {
    list result;

    // h scale = 1
    // v scale = 1
    // rotation = 270

    // float w = 149.262;
    // float h = 129.265;
    // float dx = 160.0;
    // float dy = 140.0;
    // float w1 = w / 1024.0;
    // float h1 = h / 1024.0;

    // dx / 1024 * 2 = 0.3125

    float dy = -0.1008;
    float dx = 0.1153;

    result += [
        "sheep2",  <-1 * dx, 0 * dy, 0.0>,
        "sheep3",  <-1 * dx, 1 * dy, 0.0>,
        "sheep4",  <-1 * dx, 2 * dy, 0.0>,
        "sheep5",  <-1 * dx, 3 * dy, 0.0>,
        "sheep6",  <-1 * dx, 4 * dy, 0.0>,
        "sheep8",  <-1 * dx, 5 * dy, 0.0>,
        "sheep9",  <-1 * dx, 6 * dy, 0.0>,
        "sheep10", <-1 * dx, 7 * dy, 0.0>,
        "sheep11", <-1 * dx, 8 * dy, 0.0>,
        "sheep12", <-1 * dx, 9 * dy, 0.0>,

        "wood2",  <0.0, 0 * dy, 0.0>,
        "wood3",  <0.0, 1 * dy, 0.0>,
        "wood4",  <0.0, 2 * dy, 0.0>,
        "wood5",  <0.0, 3 * dy, 0.0>,
        "wood6",  <0.0, 4 * dy, 0.0>,
        "wood8",  <0.0, 5 * dy, 0.0>,
        "wood9",  <0.0, 6 * dy, 0.0>,
        "wood10", <0.0, 7 * dy, 0.0>,
        "wood11", <0.0, 8 * dy, 0.0>,
        "wood12", <0.0, 9 * dy, 0.0>,

        "ore2",  <1 * dx, 0 * dy, 0.0>,
        "ore3",  <1 * dx, 1 * dy, 0.0>,
        "ore4",  <1 * dx, 2 * dy, 0.0>,
        "ore5",  <1 * dx, 3 * dy, 0.0>,
        "ore6",  <1 * dx, 4 * dy, 0.0>,
        "ore8",  <1 * dx, 5 * dy, 0.0>,
        "ore9",  <1 * dx, 6 * dy, 0.0>,
        "ore10", <1 * dx, 7 * dy, 0.0>,
        "ore11", <1 * dx, 8 * dy, 0.0>,
        "ore12", <1 * dx, 9 * dy, 0.0>,

        "brick2",  <2 * dx, 0 * dy, 0.0>,
        "brick3",  <2 * dx, 1 * dy, 0.0>,
        "brick4",  <2 * dx, 2 * dy, 0.0>,
        "brick5",  <2 * dx, 3 * dy, 0.0>,
        "brick6",  <2 * dx, 4 * dy, 0.0>,
        "brick8",  <2 * dx, 5 * dy, 0.0>,
        "brick9",  <2 * dx, 6 * dy, 0.0>,
        "brick10", <2 * dx, 7 * dy, 0.0>,
        "brick11", <2 * dx, 8 * dy, 0.0>,
        "brick12", <2 * dx, 9 * dy, 0.0>,

        "wheat2",  <3 * dx - 1.0, 0 * dy, 0.0>,
        "wheat3",  <3 * dx - 1.0, 1 * dy, 0.0>,
        "wheat4",  <3 * dx - 1.0, 2 * dy, 0.0>,
        "wheat5",  <3 * dx - 1.0, 3 * dy, 0.0>,
        "wheat6",  <3 * dx - 1.0, 4 * dy, 0.0>,
        "wheat8",  <3 * dx - 1.0, 5 * dy, 0.0>,
        "wheat9",  <3 * dx - 1.0, 6 * dy, 0.0>,
        "wheat10", <3 * dx - 1.0, 7 * dy, 0.0>,
        "wheat11", <3 * dx - 1.0, 8 * dy, 0.0>,
        "wheat12", <3 * dx - 1.0, 9 * dy, 0.0>,

        "desert",    <4 * dx - 1.0, 0 * dy, 0.0>,
        "port3for1", <4 * dx - 1.0, 1 * dy, 0.0>,
        "portsheep", <4 * dx - 1.0, 2 * dy, 0.0>,
        "portwood",  <4 * dx - 1.0, 3 * dy, 0.0>,
        "portore",   <4 * dx - 1.0, 4 * dy, 0.0>,
        "portbrick", <4 * dx - 1.0, 5 * dy, 0.0>,
        "portwheat", <4 * dx - 1.0, 6 * dy, 0.0>

    ];

    return result;
}

integer town_link(integer i) {
    return llList2Integer(TOWN_INFO, TOWN_INFO_COUNT * i + TOWN_INFO_LINK);
}

integer town_face(integer i) {
    return llList2Integer(TOWN_INFO, TOWN_INFO_COUNT * i + TOWN_INFO_FACE);
}

integer detected_town_id() {
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

integer road_link(integer i) {
    return llList2Integer(ROAD_INFO, ROAD_INFO_COUNT * i + ROAD_INFO_LINK);
}

integer road_face(integer i) {
    return llList2Integer(ROAD_INFO, ROAD_INFO_COUNT * i + ROAD_INFO_FACE);
}

list hex_info() {
    list result;

    float dx = 0.6685;
    float y0 = 0.1933;
    float dy = 0.0866;
    integer link;

    // column 1
    link = 22;
    result += [0,  link, 1, <X0 - 3*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, -30.0, <0.519,  y0 + 2 * dy, 0.0>, BASE_PORT];
    result += [1,  link, 2, <X0 - 3*XSTEP, Y0 - 0.5*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];
    result += [2,  link, 3, <X0 - 3*XSTEP, Y0 + 0.5*YSTEP, ZPOS>,  30.0, <   dx,  y0 + 3 * dy, 0.0>, BASE_PORT];
    result += [3,  link, 4, <X0 - 3*XSTEP, Y0 + 1.5*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];

    // column 2
    link = 21;
    result += [4,  link, 0, <X0 - 2*XSTEP, Y0 - 2.0*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];
    result += [5,  link, 1, <X0 - 2*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 1 * dy, 0.0>, BASE_LAND];
    result += [6,  link, 2, <X0 - 2*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 2 * dy, 0.0>, BASE_LAND];
    result += [7,  link, 3, <X0 - 2*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 3 * dy, 0.0>, BASE_LAND];
    result += [8,  link, 4, <X0 - 2*XSTEP, Y0 + 2.0*YSTEP, ZPOS>,  30.0, <0.744,  y0 + 2.5 * dy, 0.0>, BASE_PORT];

    // column 3
    link = 23;
    result += [9,  link, 0, <X0 - 1*XSTEP, Y0 - 2.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 0 * dy, 0.0>, BASE_PORT];
    result += [10, link, 1, <X0 - 1*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 1 * dy, 0.0>, BASE_LAND];
    result += [11, link, 2, <X0 - 1*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 2 * dy, 0.0>, BASE_LAND];
    result += [12, link, 3, <X0 - 1*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 3 * dy, 0.0>, BASE_LAND];
    result += [13, link, 4, <X0 - 1*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 4 * dy, 0.0>, BASE_LAND];
    result += [14, link, 5, <X0 - 1*XSTEP, Y0 + 2.5*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];

    // column 4 (centre)
    link = 20;
    result += [15, link, 0, <X0 - 0*XSTEP, Y0 - 3.0*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];
    result += [16, link, 1, <X0 - 0*XSTEP, Y0 - 2.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 1 * dy, 0.0>, BASE_LAND];
    result += [17, link, 2, <X0 - 0*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 2 * dy, 0.0>, BASE_LAND];
    result += [18, link, 3, <X0 - 0*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 3 * dy, 0.0>, BASE_LAND];
    result += [19, link, 4, <X0 - 0*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 4 * dy, 0.0>, BASE_LAND];
    result += [20, link, 5, <X0 - 0*XSTEP, Y0 + 2.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 5 * dy, 0.0>, BASE_LAND];
    result += [21, link, 6, <X0 - 0*XSTEP, Y0 + 3.0*YSTEP, ZPOS>,  90.0, <   dx,  y0 + 0 * dy, 0.0>, BASE_PORT];

    // column 5
    link = 19;
    result += [22, link, 0, <X0 + 1*XSTEP, Y0 - 2.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 0 * dy, 0.0>, BASE_PORT];
    result += [23, link, 1, <X0 + 1*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 1 * dy, 0.0>, BASE_LAND];
    result += [24, link, 2, <X0 + 1*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 2 * dy, 0.0>, BASE_LAND];
    result += [25, link, 3, <X0 + 1*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 3 * dy, 0.0>, BASE_LAND];
    result += [26, link, 4, <X0 + 1*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 4 * dy, 0.0>, BASE_LAND];
    result += [27, link, 5, <X0 + 1*XSTEP, Y0 + 2.5*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];

    // column 6
    link = 18;
    result += [28, link, 0, <X0 + 2*XSTEP, Y0 - 2.0*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];
    result += [29, link, 1, <X0 + 2*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 1 * dy, 0.0>, BASE_LAND];
    result += [30, link, 2, <X0 + 2*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 2 * dy, 0.0>, BASE_LAND];
    result += [31, link, 3, <X0 + 2*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, -90.0, <   dx,  y0 + 3 * dy, 0.0>, BASE_LAND];
    result += [32, link, 4, <X0 + 2*XSTEP, Y0 + 2.0*YSTEP, ZPOS>, 150.0, <0.593,  y0 + 2.5 * dy, 0.0>, BASE_PORT];

    // column 7
    link = 17;
    result += [33, link, 1, <X0 + 3*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, 210.0, <0.820,  y0 + 2 * dy, 0.0>, BASE_PORT];
    result += [34, link, 2, <X0 + 3*XSTEP, Y0 - 0.5*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];
    result += [35, link, 3, <X0 + 3*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, 150.0, <   dx,  y0 + 3 * dy, 0.0>, BASE_PORT];
    result += [36, link, 4, <X0 + 3*XSTEP, Y0 + 1.5*YSTEP, ZPOS>,   0.0, ZERO_VECTOR,                BASE_WATER];

    return result;
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

hexes_shuffle() {
    integer i;
    integer land_i;
    integer port_i;
    integer num_i;
    integer base_type;
    integer land_type;
    integer number;
    list land_numbers = list_shuffle([2,3,3,4,4,5,5,6,6,8,8,9,9,10,10,11,11,12]);

    list land_types = [];
    for (i = 0; i < 1; ++i) { land_types += [DESERT]; }
    for (i = 0; i < 4; ++i) { land_types += [SHEEP]; }
    for (i = 0; i < 3; ++i) { land_types += [BRICK]; }
    for (i = 0; i < 4; ++i) { land_types += [WOOD]; }
    for (i = 0; i < 4; ++i) { land_types += [WHEAT]; }
    for (i = 0; i < 3; ++i) { land_types += [ORE]; }
    land_types = list_shuffle(land_types);

    list port_types = [];
    for (i = 0; i < 4; ++i) port_types += [PORT_3FOR1];
    port_types += [PORT_SHEEP];
    port_types += [PORT_BRICK];
    port_types += [PORT_WOOD];
    port_types += [PORT_WHEAT];
    port_types += [PORT_ORE];
    port_types = list_shuffle(port_types);

    land_i = 0;
    num_i = 0;
    for (i = 0; i < HEX_INFO_LEN; ++i) {
        base_type = hex_base_type(i);
        if (base_type == BASE_LAND) {
            land_type = llList2Integer(land_types, land_i);
            hex_types += land_type;
            ++land_i;

            if (land_type == DESERT) {
                hex_numbers += 0;
            } else {
                number = llList2Integer(land_numbers, num_i);
                hex_numbers += number;
                ++num_i;
            }
        } else if (base_type == BASE_PORT) {
            hex_types += llList2Integer(port_types, port_i);
            hex_numbers += 0;
            ++port_i;
        } else {
            hex_types += WATER;
            hex_numbers += 0;
        }
    }

    llOwnerSay("Shuffled hexes");
}

init_hex_prims() {
    integer i;
    integer n;
    integer t;
    string texture;
    vector repeats;
    vector offsets;
    vector pos;
    float rot;
    integer link;
    integer last_link;
    integer face;
    list args;

    args = [];
    last_link = hex_link(0);

    repeats = <0.5, 0.5, 0.0>;

    for (i = 0; i < HEX_INFO_LEN; ++i) {
        link = hex_link(i);

        if (last_link != link) {
            llSetLinkPrimitiveParamsFast(last_link, args);
            last_link = link;
            args = [];
        }

        face = hex_face(i);

        if (hex_base_type(i) == BASE_WATER) {
            args += [
                PRIM_COLOR, face, <0.651, 0.949, 0.941>, 1.0,
                PRIM_TEXTURE, face, TEXTURE_BLANK, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0
            ];
        } else {
            t = hex_type(i);
            n = hex_number(i);
            texture = hex_texture(t, n);

            //llOwnerSay("Setting hex " + (string)i + " to type " + (string)t + " num " + (string)n + "(" + texture + ")");

            integer offset_index = llListFindList(HEX_TEXTURE_OFFSET_LIST, [texture]);
            if (offset_index >= 0) {
                offsets = llList2Vector(HEX_TEXTURE_OFFSET_LIST, offset_index + 1);
            }

            rot = hex_rotation(i) * DEG_TO_RAD;
            offsets += hex_offsets(i);
            
            args += [
                PRIM_TEXGEN, face, PRIM_TEXGEN_PLANAR,
                PRIM_COLOR, face, <1.0, 1.0, 1.0>, 1.0,
                PRIM_TEXTURE, face, "hexes", repeats, offsets, rot
            ];
        }
    }
    llSetLinkPrimitiveParamsFast(link, args);
}

init_road_prims(list ids, vector colour, string texture) {
    integer i;
    integer last_link;
    integer link;
    integer face;
    list args;
    integer len;
    integer id;
    
    last_link = town_link(0);
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

init_town_prims(list ids, vector colour, string texture) {
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

game_start_new() {
    hexes_shuffle();
    init_hex_prims();
    init_town_prims(list_range(0, TOWN_INFO_LEN), <1.0, 1.0, 1.0>, TEXTURE_TRANSPARENT);
    init_road_prims(list_range(0, ROAD_INFO_LEN), <1.0, 1.0, 1.0>, TEXTURE_TRANSPARENT);
}

list calc_valid_towns() {
    return list_range(0, 30);
}

// ------------------------------------------------------
// states

default {
    state_entry() {
        llOwnerSay("------------------------");
        llOwnerSay("Game: default");

        HEX_INFO = hex_info();
        HEX_INFO_LEN = llGetListLength(HEX_INFO) / HEX_INFO_COUNT;

        ROAD_INFO = road_info();
        ROAD_INFO_LEN = llGetListLength(ROAD_INFO) / ROAD_INFO_COUNT;

        TOWN_INFO = town_info();
        TOWN_INFO_LEN = llGetListLength(TOWN_INFO) / TOWN_INFO_COUNT;

        HEX_TEXTURE_OFFSET_LIST = hex_texture_offsets();

        listen_handle = llListen(CHANNEL, "", "", "");

        state off;
    }
}

state off {
    state_entry() {
        llOwnerSay("Game: off");

        // game_start_new();

        state build_town;
    }

    touch_start(integer num) {
        key toucher = llDetectedKey(0);
        list options = ["New game", "Build town", "Build road"];
        llDialog(toucher, "Welcome to Wood for Sheep", options, CHANNEL);
    }

    // llDialog callback
    listen(integer channel, string name, key id, string message) {
        if (message == "New game") {
            state starting;
        } else if (message == "Build town") {
            current_player = 0;
            state build_town;
        }
    }
}

state build_town {
    state_entry() {
        llOwnerSay("Game: build_town");

        highlighted_towns = calc_valid_towns();
        init_town_prims(highlighted_towns, <1.0, 1.0, 0.0>, TEXTURE_BLANK);
    }

    touch_start(integer num) {
        integer id = detected_town_id();
        if (llListFindList(highlighted_towns, [id]) >= 0) {
            init_town_prims([id], <1.0, 0.0, 0.0>, TEXTURE_BLANK);
        }
    }
}

state starting {
    state_entry() {
        llOwnerSay("Game: starting");
    }
}

state stopping {
    state_entry() {
        llOwnerSay("Game: stopping");
        state off;
    }
}

state ready {
    listen(integer channel, string name, key id, string message) {
        if (message = "off") {
            state stopping;
        }
    }
}

/*
TODO:
- [x] textures for hexes and ports
- [x] list of hex land and port positions (37)
- [x] lay out hexes
- [x] hex meshes (37 positions) - 7 prims currently but could be 5 prims with work
- [x] town meshes (54 positions) - 7 prims
- [ ] city meshes (54 positions) - 7 prims
- [x] road meshes (72 positions) - 9 prims
- [ ] thief prim - 1 prim
- minimum: 5 + 7 + 7 + 9 + 1 = 29
- [ ] list of links between roads
- [ ] list of links between town positions and hex positions
- [ ] list of links between town positions and ports
- [ ] list of pieces on the board - what, where, who owns it
- [ ] state off
  - remove all prims, reset all variables
- [ ] state setup_questions
  - [ ] ask for num players
  - [ ] choose a player to start randomly
  - [ ] make list of setup states to move through
- [x] state setup_land
  - [x] shuffle hexes and lay them out
  - [ ] shuffle hex numbers and lay them out
- [ ] state player_setup
  - [ ] let player place a town
  - [ ] let player place a road
- [ ] state place_piece
  - args: player, piece prim, list of valid positions + orientations (2 vectors?), callback once position is chosen
  - click on a road in front of you to pick it up
  - click on road positions to tentatively place your road there and get feedback about validity
  - click confirm
  - call callback to update game state
*/
