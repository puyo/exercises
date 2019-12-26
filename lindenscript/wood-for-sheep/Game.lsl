// Wood for Sheep (C) 2019 Foxie Moxie

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

// ------------------------------------------------------
// variables

list land_types;
list land_numbers;
list port_types;

integer listen_handle;
integer num_links;
key current_player;

// ------------------------------------------------------
// functions

list make_road_list() {
    list result;

    return result;
}

vector tile_position(integer i) {
    return llList2Vector(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_POSITION);
}

rotation tile_rotation(integer i) {
    return llList2Rot(TILE_INFO, TILE_INFO_COUNT * i + TILE_INFO_ROTATION);
}

list make_tile_list() {
    list result;

    rotation rot = llEuler2Rot(<0.0, 0.0, 90.0>*DEG_TO_RAD);

    // column 1
    result += [0,  <X0 - 3*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, rot, BASE_PORT];
    result += [1,  <X0 - 3*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, rot, BASE_WATER];
    result += [2,  <X0 - 3*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, rot, BASE_PORT];
    result += [3,  <X0 - 3*XSTEP, Y0 + 1.5*YSTEP, ZPOS>, rot, BASE_WATER];

    // column 2
    result += [4,  <X0 - 2*XSTEP, Y0 - 2.0*YSTEP, ZPOS>, rot, BASE_WATER];
    result += [5,  <X0 - 2*XSTEP, Y0 - 1.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [6,  <X0 - 2*XSTEP, Y0 + 0.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [7,  <X0 - 2*XSTEP, Y0 + 1.0*YSTEP, ZPOS>, rot, BASE_LAND];
    result += [8,  <X0 - 2*XSTEP, Y0 + 2.0*YSTEP, ZPOS>, rot, BASE_PORT];

    // column 3
    result += [9,  <X0 - 1*XSTEP, Y0 - 2.5*YSTEP, ZPOS>, rot, BASE_PORT];
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
    result += [22, <X0 + 1*XSTEP, Y0 - 2.5*YSTEP, ZPOS>, rot, BASE_PORT];
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
    result += [33, <X0 + 3*XSTEP, Y0 - 1.5*YSTEP, ZPOS>, rot, BASE_PORT];
    result += [34, <X0 + 3*XSTEP, Y0 - 0.5*YSTEP, ZPOS>, rot, BASE_WATER];
    result += [35, <X0 + 3*XSTEP, Y0 + 0.5*YSTEP, ZPOS>, rot, BASE_PORT];
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

destroy_pieces() {
    llBreakAllLinks();
}

init_land_type_list() {
    land_types = [];
    integer i;
    for(i = 0; i < 1; ++i) { land_types += [DESERT]; }
    for(i = 0; i < 4; ++i) { land_types += [SHEEP]; }
    for(i = 0; i < 3; ++i) { land_types += [BRICK]; }
    for(i = 0; i < 4; ++i) { land_types += [WOOD]; }
    for(i = 0; i < 4; ++i) { land_types += [WHEAT]; }
    for(i = 0; i < 3; ++i) { land_types += [ORE]; }
    land_types = shuffled_list(land_types);

    llOwnerSay("Initialized " + (string)llGetListLength(land_types) + " land types");
}

init_land_number_list() {
    land_numbers = [];
    // list numbers = shuffled_list([2,3,3,4,4,5,5,6,6,8,8,9,9,10,10,11,11,12]);
    list numbers = [2,3,3,4,4,5,5,6,6,8,8,9,9,10,10,11,11,12];
    integer len = llGetListLength(land_types);
    integer i;
    integer type_i = 0;
    integer t;
    for(i = 0; i < len; ++i) {
        t = llList2Integer(land_types, i);
        if (t == DESERT) {
            land_numbers += 0;
        } else {
            land_numbers += llList2Integer(numbers, type_i);
            type_i++;
        }
    }
    llOwnerSay("Initialized " + (string)llGetListLength(land_numbers) + " land numbers");
}

init_port_type_list() {
    port_types = [];
    integer i;
    for(i = 0; i < 4; ++i) port_types += [PORT_3FOR1];
    port_types += [PORT_SHEEP];
    port_types += [PORT_BRICK];
    port_types += [PORT_WOOD];
    port_types += [PORT_WHEAT];
    port_types += [PORT_ORE];
    port_types = shuffled_list(port_types);
}

init_textures() {
    integer len = llGetListLength(land_types);
    integer i;
    integer n;
    integer t;
    for (i = 0; i < len; ++i) {
        t = llList2Integer(land_types, i);
        n = llList2Integer(land_numbers, i);
        string texture = tile_texture(t, n);
        vector repeats = <4.75, 4.75, 0.0>;
        vector offsets = ZERO_VECTOR;
        float rotation_in_radians = 90.0 * DEG_TO_RAD;
        integer link = 2 + i;
        integer face = 1;
        llSetLinkPrimitiveParams(
            link,
            [
                PRIM_TEXTURE, ALL_SIDES, TEXTURE_BLANK, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0
            ]
        );
        llSetLinkPrimitiveParamsFast(
            link,
            [
                PRIM_ALPHA_MODE, face, PRIM_ALPHA_MODE_NONE, 0,
                PRIM_COLOR, face, <1.0, 1.0, 1.0>, 1.0,
                PRIM_TEXTURE, face, texture, repeats, offsets, rotation_in_radians,
                PRIM_TEXGEN, face, PRIM_TEXGEN_PLANAR
            ]
        );
 
    }
}

init_new_game() {
    init_land_type_list();
    init_land_number_list();
    init_port_type_list();
    init_textures();
}

// ------------------------------------------------------
// states

default {
    state_entry() {
        llOwnerSay("------------------------");
        llOwnerSay("Game: default");

        // llOwnerSay(llGetKey());
        // llMessageLinked(2, 0, "query", "");
        // llMessageLinked(3, 0, "query", "");

        TILE_INFO = make_tile_list();
        TILE_INFO_LEN = llGetListLength(TILE_INFO) / TILE_INFO_COUNT;

        init_new_game();

        state off;
    }
}

state off {
    state_entry() {
        listen_handle = llListen(CHANNEL, "", "", "");
        llOwnerSay("Game: off");
    }

    touch_start(integer num) {
        key toucher = llDetectedKey(0);
        list options = ["Start Game"];
        if (toucher == llGetOwner()) {
            options += ["Rebuild"];
        }
        llDialog(toucher, "Welcome to Wood for Sheep", options, CHANNEL);
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
        destroy_pieces();
        init_land_type_list();
        init_port_type_list();
        state setup_tiles;
    }
}

state setup_tiles {
    state_entry() {
        llOwnerSay("Game: setting up tiles");
        string tile_prim = "hextile4";

        key id = llGetInventoryKey(tile_prim);
        llRemoteLoadScriptPin(id, "Tile Script", 1234, TRUE, 0);

        integer i;
        num_links = TILE_INFO_LEN;
        for (i = 0; i < TILE_INFO_LEN; ++i) {
            vector pos = llGetPos() + tile_position(i) - <0.5, 0.5, 0.0>;
            rotation rot = tile_rotation(i);
            vector vel = ZERO_VECTOR;
            llRezObject(tile_prim, pos, vel, rot, 0);
        }
    }

    object_rez(key id) {
        llCreateLink(id, TRUE);
        llOwnerSay("Game: setting up tiles: " + (string)num_links + " left");
        num_links--;
        if (num_links == 0) {
            llOwnerSay("Game: DONE setting up tiles");
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
