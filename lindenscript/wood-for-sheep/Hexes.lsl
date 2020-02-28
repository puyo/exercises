// HEXES

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

integer BASE_LAND = 1;
integer BASE_PORT = 2;
integer BASE_WATER = 3;

list HEX_TEXTURE_OFFSET_LIST;

float X0 = 0.5;
float Y0 = 0.5;
float XSTEP = 0.075;
float YSTEP = 0.0833;
float ZPOS = 0.01;

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

// functions for hexes

prim_hexes_set(list hex_types, list hex_numbers) {
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
    integer b;

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

        b = hex_base_type(i);

        if (b == BASE_WATER) {
            args += [
                PRIM_COLOR, face, <0.651, 0.949, 0.941>, 1.0,
                PRIM_TEXTURE, face, TEXTURE_BLANK, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0
            ];
        } else {
            t = llList2Integer(hex_types, i);
            n = llList2Integer(hex_numbers, i);
            texture = hex_texture(t, n);

            // llOwnerSay("Setting hex " + (string)i + " to type " + (string)t + " num " + (string)n + " (" + texture + ")");

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

hexes_shuffle() {
    integer i;
    integer land_i;
    integer port_i;
    integer num_i;
    integer base_type;
    integer land_type;
    integer number;
    list land_numbers = llListRandomize([2,3,3,4,4,5,5,6,6,8,8,9,9,10,10,11,11,12], 1);

    list land_types = [];
    for (i = 0; i < 1; ++i) { land_types += [DESERT]; }
    for (i = 0; i < 4; ++i) { land_types += [SHEEP]; }
    for (i = 0; i < 3; ++i) { land_types += [BRICK]; }
    for (i = 0; i < 4; ++i) { land_types += [WOOD]; }
    for (i = 0; i < 4; ++i) { land_types += [WHEAT]; }
    for (i = 0; i < 3; ++i) { land_types += [ORE]; }
    land_types = llListRandomize(land_types, 1);

    list port_types = [];
    for (i = 0; i < 4; ++i) port_types += [PORT_3FOR1];
    port_types += [PORT_SHEEP];
    port_types += [PORT_BRICK];
    port_types += [PORT_WOOD];
    port_types += [PORT_WHEAT];
    port_types += [PORT_ORE];
    port_types = llListRandomize(port_types, 1);

    list hex_numbers = [];
    list hex_types = [];
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

    llMessageLinked(LINK_THIS, 0, "state_set_hex_types", llList2CSV(hex_types));
    llMessageLinked(LINK_THIS, 0, "state_set_hex_numbers", llList2CSV(hex_numbers));

    prim_hexes_set(hex_types, hex_numbers);

    llOwnerSay("Shuffled hexes");
}

default {
    state_entry() {
        HEX_INFO = hex_info();
        HEX_INFO_LEN = llGetListLength(HEX_INFO) / HEX_INFO_COUNT;

        HEX_TEXTURE_OFFSET_LIST = hex_texture_offsets();
    }


    link_message(integer sender, integer num, string msg, key id) {
        if (msg == "hexes_shuffle") {
            hexes_shuffle();
        }
    }
}
