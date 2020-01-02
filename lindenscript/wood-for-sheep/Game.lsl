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

integer TILE_INFO_ID = 0;
integer TILE_INFO_LINK = 1;
integer TILE_INFO_FACE = 2;
integer TILE_INFO_POSITION = 3;
integer TILE_INFO_ROTATION = 4;
integer TILE_INFO_OFFSETS = 5;
integer TILE_INFO_BASE_TYPE = 6;
integer TILE_INFO_COUNT = 7;

integer BASE_LAND = 1;
integer BASE_PORT = 2;
integer BASE_WATER = 3;

float X0 = 0.5;
float Y0 = 0.5;
float XSTEP = 0.075;
float YSTEP = 0.0833;
float ZPOS = 0.01;

list TILE_TEXTURE_OFFSET_LIST;
list TILE_INFO;
integer TILE_INFO_LEN;

// ------------------------------------------------------
// variables

list tile_types;
list tile_numbers;

integer listen_handle;
integer num_links;
key current_player;

// ------------------------------------------------------
// functions

list make_road_list() {
    list result;

    return result;
}

integer tile_link(integer i) {
    return llList2Integer(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_LINK);
}

integer tile_face(integer i) {
    return llList2Integer(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_FACE);
}

vector tile_position(integer i) {
    return llList2Vector(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_POSITION);
}

float tile_rotation(integer i) {
    return llList2Float(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_ROTATION);
}

vector tile_offsets(integer i) {
    return llList2Vector(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_OFFSETS);
}

integer tile_base_type(integer i) {
    return llList2Integer(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_BASE_TYPE);
}

integer tile_type(integer i) {
    return llList2Integer(tile_types, i);
}

integer tile_number(integer i) {
    return llList2Integer(tile_numbers, i);
}

list make_texture_offsets() {
    list result;

    // h scale = 1
    // v scale = 1
    // rotation = 270

    result += [
        "desert",    <-0.54,  0.000, 0.0>,
        "port3for1", <-0.54, -0.100, 0.0>,
        "portsheep", <-0.54, -0.200, 0.0>,
        "portwood",  <-0.54, -0.300, 0.0>,
        "portore",   <-0.54, -0.400, 0.0>,
        "portbrick", <-0.54, -0.502, 0.0>,
        "portwheat", <-0.54, -0.605, 0.0>
    ];

    result += [
        "sheep2",  <-0.115,  0.0, 0.0>,
        "sheep3",  <-0.115, -0.10, 0.0>,
        "sheep4",  <-0.115, -0.20, 0.0>,
        "sheep5",  <-0.115, -0.30, 0.0>,
        "sheep6",  <-0.115, -0.40, 0.0>,
        "sheep8",  <-0.115, -0.502, 0.0>,
        "sheep9",  <-0.115, -0.605, 0.0>,
        "sheep10", <-0.115, -0.706, 0.0>,
        "sheep11", <-0.115, -0.808, 0.0>,
        "sheep12", <-0.115, -0.910, 0.0>
    ];

    result += [
        "wood2",  <0.0,  0.000, 0.0>,
        "wood3",  <0.0, -0.100, 0.0>,
        "wood4",  <0.0, -0.200, 0.0>,
        "wood5",  <0.0, -0.300, 0.0>,
        "wood6",  <0.0, -0.400, 0.0>,
        "wood8",  <0.0, -0.502, 0.0>,
        "wood9",  <0.0, -0.605, 0.0>,
        "wood10", <0.0, -0.706, 0.0>,
        "wood11", <0.0, -0.808, 0.0>,
        "wood12", <0.0, -0.910, 0.0>
    ];

    result += [
        "ore2",  <0.115,  0.000, 0.0>,
        "ore3",  <0.115, -0.100, 0.0>,
        "ore4",  <0.115, -0.200, 0.0>,
        "ore5",  <0.115, -0.300, 0.0>,
        "ore6",  <0.115, -0.400, 0.0>,
        "ore8",  <0.115, -0.502, 0.0>,
        "ore9",  <0.115, -0.605, 0.0>,
        "ore10", <0.115, -0.706, 0.0>,
        "ore11", <0.115, -0.808, 0.0>,
        "ore12", <0.115, -0.910, 0.0>
    ];

    result += [
        "brick2",  <2 * 0.115,  0.000, 0.0>,
        "brick3",  <2 * 0.115, -0.100, 0.0>,
        "brick4",  <2 * 0.115, -0.200, 0.0>,
        "brick5",  <2 * 0.115, -0.300, 0.0>,
        "brick6",  <2 * 0.115, -0.400, 0.0>,
        "brick8",  <2 * 0.115, -0.502, 0.0>,
        "brick9",  <2 * 0.115, -0.605, 0.0>,
        "brick10", <2 * 0.115, -0.706, 0.0>,
        "brick11", <2 * 0.115, -0.808, 0.0>,
        "brick12", <2 * 0.115, -0.910, 0.0>
    ];

    result += [
        "wheat2",  <-0.655,  0.000, 0.0>,
        "wheat3",  <-0.655, -0.100, 0.0>,
        "wheat4",  <-0.655, -0.200, 0.0>,
        "wheat5",  <-0.655, -0.300, 0.0>,
        "wheat6",  <-0.655, -0.400, 0.0>,
        "wheat8",  <-0.655, -0.502, 0.0>,
        "wheat9",  <-0.655, -0.605, 0.0>,
        "wheat10", <-0.655, -0.706, 0.0>,
        "wheat11", <-0.655, -0.808, 0.0>,
        "wheat12", <-0.655, -0.910, 0.0>
    ];

    return result;
}

list make_tile_list() {
    list result;

    // column 1
    result += [0,  13, 1, <X0 - 3*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, -30.0, <0.52,  0.37, 0.0>, BASE_PORT];
    result += [1,  13, 2, <X0 - 3*XSTEP, Y0 - 0.5*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];
    result += [2,  13, 3, <X0 - 3*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, -30.0, <0.67,  0.45, 0.0>, BASE_PORT];
    result += [3,  13, 4, <X0 - 3*XSTEP, Y0 + 1.5*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];

    // column 2
    result += [4,  12, 0, <X0 - 2*XSTEP, Y0 - 2.0*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];
    result += [5,  12, 1, <X0 - 2*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, -90.0, <0.67,  0.28, 0.0>, BASE_LAND];
    result += [6,  12, 2, <X0 - 2*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, -90.0, <0.67,  0.365, 0.0>, BASE_LAND];
    result += [7,  12, 3, <X0 - 2*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, -90.0, <0.67,  0.45, 0.0>, BASE_LAND];
    result += [8,  12, 4, <X0 - 2*XSTEP, Y0 + 2.0*YSTEP, ZPOS>,  90.0, <0.67,  0.37, 0.0>, BASE_PORT];

    // column 3
    result += [9,  14, 0, <X0 - 1*XSTEP, Y0 - 2.5*YSTEP, ZPOS>, -90.0, <0.67,  0.19, 0.0>, BASE_PORT];
    result += [10, 14, 1, <X0 - 1*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, -90.0, <0.67,  0.28, 0.0>, BASE_LAND];
    result += [11, 14, 2, <X0 - 1*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, -90.0, <0.67,  0.365, 0.0>, BASE_LAND];
    result += [12, 14, 3, <X0 - 1*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, -90.0, <0.67,  0.45, 0.0>, BASE_LAND];
    result += [13, 14, 4, <X0 - 1*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, -90.0, <0.67,  0.54, 0.0>, BASE_LAND];
    result += [14, 14, 5, <X0 - 1*XSTEP, Y0 + 2.5*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];

    // column 4 (centre)
    result += [15, 11, 0, <X0 - 0*XSTEP, Y0 - 3.0*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];
    result += [16, 11, 1, <X0 - 0*XSTEP, Y0 - 2.0*YSTEP, ZPOS>, -90.0, <0.67,  0.28, 0.0>, BASE_LAND];
    result += [17, 11, 2, <X0 - 0*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, -90.0, <0.67,  0.365, 0.0>, BASE_LAND];
    result += [18, 11, 3, <X0 - 0*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, -90.0, <0.67,  0.45, 0.0>, BASE_LAND];
    result += [19, 11, 4, <X0 - 0*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, -90.0, <0.67,  0.54, 0.0>, BASE_LAND];
    result += [20, 11, 5, <X0 - 0*XSTEP, Y0 + 2.0*YSTEP, ZPOS>, -90.0, <0.67,  0.625, 0.0>, BASE_LAND];
    result += [21, 11, 6, <X0 - 0*XSTEP, Y0 + 3.0*YSTEP, ZPOS>,  90.0, <0.67,  0.19, 0.0>, BASE_PORT];

    // column 5
    result += [22, 10, 0, <X0 + 1*XSTEP, Y0 - 2.5*YSTEP, ZPOS>, -90.0, <0.67,  0.19, 0.0>, BASE_PORT];
    result += [23, 10, 1, <X0 + 1*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, -90.0, <0.67,  0.28, 0.0>, BASE_LAND];
    result += [24, 10, 2, <X0 + 1*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, -90.0, <0.67,  0.365, 0.0>, BASE_LAND];
    result += [25, 10, 3, <X0 + 1*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, -90.0, <0.67,  0.45, 0.0>, BASE_LAND];
    result += [26, 10, 4, <X0 + 1*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, -90.0, <0.67,  0.54, 0.0>, BASE_LAND];
    result += [27, 10, 5, <X0 + 1*XSTEP, Y0 + 2.5*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];
 
    // column 6
    result += [28,  9, 0, <X0 + 2*XSTEP, Y0 - 2.0*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];
    result += [29,  9, 1, <X0 + 2*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, -90.0, <0.67,  0.28, 0.0>, BASE_LAND];
    result += [30,  9, 2, <X0 + 2*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, -90.0, <0.67,  0.365, 0.0>, BASE_LAND];
    result += [31,  9, 3, <X0 + 2*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, -90.0, <0.67,  0.45, 0.0>, BASE_LAND];
    result += [32,  9, 4, <X0 + 2*XSTEP, Y0 + 2.0*YSTEP, ZPOS>,  90.0, <0.67,  0.37, 0.0>, BASE_PORT];

    // column 7
    result += [33,  8, 1, <X0 + 3*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, 210.0, <0.82,  0.365, 0.0>, BASE_PORT];
    result += [34,  8, 2, <X0 + 3*XSTEP, Y0 - 0.5*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];
    result += [35,  8, 3, <X0 + 3*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, 210.0, <0.67,  0.45, 0.0>, BASE_PORT];
    result += [36,  8, 4, <X0 + 3*XSTEP, Y0 + 1.5*YSTEP, ZPOS>,   0.0, <0.00,  0.00, 0.0>, BASE_WATER];

    return result;
}

list shuffled_list(list l) {
    return llListRandomize(l, 1);
}

string tile_texture(integer type, integer number) {
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

init_tiles() {
    integer i;
    integer land_i;
    integer port_i;
    integer num_i;
    integer base_type;
    integer land_type;
    integer number;
    list land_numbers = shuffled_list([2,3,3,4,4,5,5,6,6,8,8,9,9,10,10,11,11,12]);

    list land_types = [];
    for (i = 0; i < 1; ++i) { land_types += [DESERT]; }
    for (i = 0; i < 4; ++i) { land_types += [SHEEP]; }
    for (i = 0; i < 3; ++i) { land_types += [BRICK]; }
    for (i = 0; i < 4; ++i) { land_types += [WOOD]; }
    for (i = 0; i < 4; ++i) { land_types += [WHEAT]; }
    for (i = 0; i < 3; ++i) { land_types += [ORE]; }
    land_types = shuffled_list(land_types);

    list port_types = [];
    for (i = 0; i < 4; ++i) port_types += [PORT_3FOR1];
    port_types += [PORT_SHEEP];
    port_types += [PORT_BRICK];
    port_types += [PORT_WOOD];
    port_types += [PORT_WHEAT];
    port_types += [PORT_ORE];
    port_types = shuffled_list(port_types);

    land_i = 0;
    num_i = 0;
    for (i = 0; i < TILE_INFO_LEN; ++i) {
        base_type = tile_base_type(i);
        if (base_type == BASE_LAND) {
            land_type = llList2Integer(land_types, land_i);
            tile_types += land_type;
            ++land_i;

            if (land_type == DESERT) {
                tile_numbers += 0;
            } else {
                number = llList2Integer(land_numbers, num_i);
                tile_numbers += number;
                ++num_i;
            }
        } else if (base_type == BASE_PORT) {
            tile_types += llList2Integer(port_types, port_i);
            tile_numbers += 0;
            ++port_i;
        } else {
            tile_types += WATER;
            tile_numbers += 0;
        }
    }

    llOwnerSay("Shuffled tiles");
}

init_tile_prims() {
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
    last_link = tile_link(0);

    repeats = <0.5, 0.5, 0.0>;

    for (i = 0; i < TILE_INFO_LEN; ++i) {
        link = tile_link(i);

        if (last_link != link) {
            llSetLinkPrimitiveParamsFast(last_link, args);
            last_link = link;
            args = [];
        }

        face = tile_face(i);

        if (tile_base_type(i) == BASE_WATER) {
            args += [
                PRIM_COLOR, face, <0.651, 0.949, 0.941>, 1.0,
                PRIM_TEXTURE, face, TEXTURE_BLANK, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0
            ];
        } else {
            t = tile_type(i);
            n = tile_number(i);
            texture = tile_texture(t, n);

            //llOwnerSay("Setting tile " + (string)i + " to type " + (string)t + " num " + (string)n + "(" + texture + ")");

            integer offset_index = llListFindList(TILE_TEXTURE_OFFSET_LIST, [texture]);
            if (offset_index >= 0) {
                offsets = llList2Vector(TILE_TEXTURE_OFFSET_LIST, offset_index + 1);
            }

            rot = tile_rotation(i) * DEG_TO_RAD;
            offsets += tile_offsets(i);
            
            args += [
                PRIM_TEXGEN, face, PRIM_TEXGEN_PLANAR,
                PRIM_COLOR, face, <1.0, 1.0, 1.0>, 1.0,
                PRIM_TEXTURE, face, "tiles", repeats, offsets, rot
            ];
        }
    }
    llSetLinkPrimitiveParamsFast(link, args);
}

init_new_game() {
    init_tiles();
    init_tile_prims();
}

// ------------------------------------------------------
// states

default {
    state_entry() {
        llOwnerSay("------------------------");
        llOwnerSay("Game: default");
        state off;
    }
}

state off {
    state_entry() {
        listen_handle = llListen(CHANNEL, "", "", "");
        llOwnerSay("Game: off");

        TILE_INFO = make_tile_list();
        TILE_INFO_LEN = llGetListLength(TILE_INFO) / TILE_INFO_COUNT;

        TILE_TEXTURE_OFFSET_LIST = make_texture_offsets();

        init_new_game();
    }

    touch_start(integer num) {
        key toucher = llDetectedKey(0);
        list options = ["New game"];
        if (toucher == llGetOwner()) {
            options += ["Unpack pieces"];
        }
        llDialog(toucher, "Welcome to Wood for Sheep", options, CHANNEL);
    }

    // llDialog callback
    listen(integer channel, string name, key id, string message) {
        if (message == "Unpack pieces") {
            llRequestPermissions(llGetOwner(), PERMISSION_CHANGE_LINKS);
        } else if (message == "New game") {
            state starting;
        }
    }

    // llRequestPermissions callback
    run_time_permissions(integer perms) {
        llWhisper(0, "To be implemented.");
        state off;
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
- [x] textures for tiles and ports
- [x] list of tile + port positions (37)
- [x] lay out tiles
- [ ] tile meshes (37 positions) - 7 prims currently but could be 5 prims with work
- [ ] town meshes (54 positions) - 7 prims
- [ ] city meshes (54 positions) - 7 prims
- [ ] road meshes (72 positions) - 9 prims
- [ ] thief prim - 1 prim
- minimum: 5 + 7 + 7 + 9 + 1 = 29
- [ ] list of links between roads
- [ ] list of links between town positions and tile positions
- [ ] list of links between town positions and ports
- [ ] list of pieces on the board - what, where, who owns it
- [ ] state off
  - remove all prims, reset all variables
- [ ] state setup_questions
  - [ ] ask for num players
  - [ ] choose a player to start randomly
  - [ ] make list of setup states to move through
- [x] state setup_land
  - [x] shuffle tiles and lay them out
  - [ ] shuffle tile numbers and lay them out
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
