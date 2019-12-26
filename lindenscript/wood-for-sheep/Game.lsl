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
integer TILE_INFO_POSITION = 1;
integer TILE_INFO_ROTATION = 2;
integer TILE_INFO_BASE_TYPE = 3;
integer TILE_INFO_COUNT = 4;

integer BASE_LAND = 1;
integer BASE_PORT = 2;
integer BASE_WATER = 3;

float X0 = 0.5;
float Y0 = 0.5;
float XSTEP = 0.075;
float YSTEP = 0.0833;
float ZPOS = 0.01;

list TILE_INFO;
integer TILE_INFO_LEN;

string TILE_PRIM = "hextile5";

// ------------------------------------------------------
// variables

list tile_types;
list tile_numbers;
list tile_links;

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
    return llList2Integer(tile_links, i);
}

vector tile_position(integer i) {
    return llList2Vector(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_POSITION);
}

float tile_rotation(integer i) {
    return llList2Float(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_ROTATION);
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

list make_tile_list() {
    list result;

    float rot = -90.0;

    // column 1
    result += [0,  <X0 - 3*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, 120 + rot, BASE_PORT];
    result += [1,  <X0 - 3*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, rot, BASE_WATER];
    result += [2,  <X0 - 3*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, 60 + rot, BASE_PORT];
    result += [3,  <X0 - 3*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, rot, BASE_WATER];

    // column 2
    result += [4,  <X0 - 2*XSTEP, Y0 - 2.0*YSTEP, ZPOS>, rot, BASE_WATER];
    result += [5,  <X0 - 2*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [6,  <X0 - 2*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [7,  <X0 - 2*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [8,  <X0 - 2*XSTEP, Y0 + 2.0*YSTEP, ZPOS>, rot, BASE_PORT];

    // column 3
    result += [9,  <X0 - 1*XSTEP, Y0 - 2.5*YSTEP, ZPOS>, -rot, BASE_PORT];
    result += [10, <X0 - 1*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [11, <X0 - 1*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [12, <X0 - 1*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [13, <X0 - 1*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [14, <X0 - 1*XSTEP, Y0 + 2.5*YSTEP, ZPOS>, rot, BASE_WATER];

    // column 4 (centre)
    result += [15, <X0 - 0*XSTEP, Y0 - 3.0*YSTEP, ZPOS>, rot, BASE_WATER];
    result += [16, <X0 - 0*XSTEP, Y0 - 2.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [17, <X0 - 0*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [18, <X0 - 0*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [19, <X0 - 0*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [20, <X0 - 0*XSTEP, Y0 + 2.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [21, <X0 - 0*XSTEP, Y0 + 3.0*YSTEP, ZPOS>, rot, BASE_PORT];

    // column 5
    result += [22, <X0 + 1*XSTEP, Y0 - 2.5*YSTEP, ZPOS>, -rot, BASE_PORT];
    result += [23, <X0 + 1*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [24, <X0 + 1*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [25, <X0 + 1*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [26, <X0 + 1*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [27, <X0 + 1*XSTEP, Y0 + 2.5*YSTEP, ZPOS>, rot, BASE_WATER];

    // column 6
    result += [28, <X0 + 2*XSTEP, Y0 - 2.0*YSTEP, ZPOS>, rot, BASE_WATER];
    result += [29, <X0 + 2*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [30, <X0 + 2*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [31, <X0 + 2*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [32, <X0 + 2*XSTEP, Y0 + 2.0*YSTEP, ZPOS>, rot, BASE_PORT];

    // column 7
    result += [33, <X0 + 3*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, -120 + rot, BASE_PORT];
    result += [34, <X0 + 3*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, rot, BASE_WATER];
    result += [35, <X0 + 3*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, -60 + rot, BASE_PORT];
    result += [36, <X0 + 3*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, rot, BASE_WATER];

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

            if (land_type != DESERT) {
                tile_numbers += llList2Integer(land_numbers, num_i);
                ++num_i;
            }
        } else if (base_type == BASE_PORT) {
            tile_types += llList2Integer(port_types, port_i);
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
    float rotation_in_radians;
    rotation rot;
    integer link;
    list args;

    for (i = 0; i < TILE_INFO_LEN; ++i) {
        link = tile_link(i);
        if (link < 2) {
            llOwnerSay("Warning: Tile " + (string)i + " has link number " + (string)link);
        } else {
            t = tile_type(i);
            n = tile_number(i);
            texture = tile_texture(t, n);
            repeats = <1.0, 1.0, 0.0> * 4.9;
            offsets = ZERO_VECTOR;
            pos = llGetPos() + tile_position(i) - <0.5, 0.5, 0.0>;
            rot = llEuler2Rot(<0.0, 0.0, tile_rotation(i)> * DEG_TO_RAD);
            llOwnerSay("Setting up prim link number " + (string)link + " to " + texture);

            args = [
                PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_NONE, 0,
                PRIM_POSITION, pos,
                PRIM_ROTATION, rot
            ];

            if (texture == "water") {
                args += [
                    PRIM_COLOR, ALL_SIDES, <0.078, 0.078, 0.722>, 1.0,
                    PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0
                ];
            } else {
                args += [
                    PRIM_COLOR, 2, <0.078, 0.078, 0.722>, 1.0,
                    PRIM_TEXTURE, 2, TEXTURE_BLANK, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0,

                    PRIM_TEXGEN, 1, PRIM_TEXGEN_PLANAR,
                    PRIM_COLOR, 1, <1.0, 1.0, 1.0>, 1.0,
                    PRIM_TEXTURE, 1, texture, repeats, offsets, -90.0 * DEG_TO_RAD
                ];
            }

            llSetLinkPrimitiveParamsFast(link, args);
            // llSleep(1.0);
        }
    }
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

        integer i;
        tile_links = [];
        for (i = 0; i < TILE_INFO_LEN; ++i) { tile_links += -1; }

        num_links = TILE_INFO_LEN;
        llMessageLinked(LINK_ALL_OTHERS, 0, "whatindex", "");
    }

    touch_start(integer num) {
        key toucher = llDetectedKey(0);
        list options = ["Start Game"];
        if (toucher == llGetOwner()) {
            options += ["Rebuild"];
        }
        llDialog(toucher, "Welcome to Wood for Sheep", options, CHANNEL);
    }

    link_message(integer link, integer num, string msg, key _id) {
        if (msg == "index") {
            llOwnerSay("Game: Tile " + (string)num + " is link number " + (string)link);
            tile_links = llListReplaceList(tile_links, [link], num, num);

            num_links--;
            if (num_links == 0) {
                llOwnerSay("Game: DONE indexing tiles"); // + llDumpList2String(tile_links, ", "));
                init_new_game();
                state off;
            }
        }
    }

    // llDialog callback
    listen(integer channel, string name, key id, string message) {
        if (message == "Rebuild") {
            llRequestPermissions(llGetOwner(), PERMISSION_CHANGE_LINKS);
        } else if (message == "Start Game") {
            state starting;
        }
    }

    // llRequestPermissions callback
    run_time_permissions(integer perms) {
        state setup_tiles;
    }
}

state setup_tiles {
    state_entry() {
        integer i;
        key id;
        vector pos;
        rotation rot = llEuler2Rot(<0.0, 0.0, tile_rotation(i)> * DEG_TO_RAD);
        vector vel;

        llOwnerSay("Game: setting up tiles");

        // destroy all pieces first
        llBreakAllLinks();

        num_links = TILE_INFO_LEN;
        vel = ZERO_VECTOR;
        for (i = 0; i < TILE_INFO_LEN; ++i) {
            pos = llGetPos() + tile_position(i) - <0.5, 0.5, 0.0>;
            llRezObject(TILE_PRIM, pos, vel, rot, i);
            llSleep(1.0);
        }
    }

    object_rez(key id) {
        llCreateLink(id, TRUE);

        llOwnerSay("Game: Linking tiles: " + (string)num_links + " left");
        num_links--;
        if (num_links == 0) {
            llOwnerSay("Game: DONE linking tiles");
            state off;
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
- [x] textures for tiles esp ports so we can tell what is going on
- [x] list of tile positions
- [x] list of port positions
- [ ] list of town positions
- [ ] list of town positions
- [ ] list of road positions
- [ ] list of links between roads
- [ ] list of links between town positions and tile positions
- [ ] list of links between town positions and ports
- [ ] list of pieces on the board - what, where, who owns it
- [ ] road placeholder prim
- [ ] road prim
- [ ] town/city placeholder prim
- [ ] town prim
- [ ] city prim
- [ ] thief prim
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
