// STATE

integer TOWN = 1;
integer ROAD = 2;
integer CASTLE = 3;

// ------------------------------------------------------
// variables

list hex_types;
list hex_numbers;

list player1_property;
list player2_property;
list player3_property;
list player4_property;
list player1_resources;
list player2_resources;
list player3_resources;
list player4_resources;

list highlighted_towns;

integer num_links;
integer num_players;
integer current_player;

integer hex_type(integer i) {
    return llList2Integer(hex_types, i);
}

integer hex_number(integer i) {
    return llList2Integer(hex_numbers, i);
}

list player_property(integer player) {
    if (player == 0) {
        return player1_property;
    } else if (player == 1) {
        return player2_property;
    } else if (player == 2) {
        return player3_property;
    } else {
        return player4_property;
    }
}

list player_add_town(integer player, integer id) {
    list property = player_property(player);
    property += [TOWN, id];
    return property;
}

vector player_colour(integer player) {
    if (player == 0) {
        return <1.0, 0.0, 0.0>;
    } else if (player == 1) {
        return <0.0, 0.0, 1.0>;
    } else if (player == 2) {
        return <1.0, 0.5, 0.0>;
    } else {
        return <1.0, 1.0, 1.0>;
    }
}

// ------------------------------------------------------
// functions for game

list game_get_valid_towns() {
    return list_range(0, 30); // TODO
}

list game_get_valid_towns_initial() {
    return list_range(0, 30); // TODO: remove existing town ids + their adjacent towns
}

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

default {
    link_message(integer sender, integer num, string msg, key id) {
        if (msg == "state_start_new") {
            llOwnerSay("Starting new game...");
            num_players = num;
            current_player = 0;

            player1_property = [];
            player2_property = [];
            player3_property = [];
            player4_property = [];
            player1_resources = [];
            player2_resources = [];
            player3_resources = [];
            player4_resources = [];

            llMessageLinked(LINK_THIS, 0, "hexes_shuffle", "");
            llMessageLinked(LINK_THIS, 0, "towns_blank", "");
            llMessageLinked(LINK_THIS, 0, "roads_blank", "");

            // prim_towns_set(list_range(0, 54), <1.0, 1.0, 1.0>, TEXTURE_TRANSPARENT);
            // prim_roads_set(list_range(0, 72), <1.0, 1.0, 1.0>, TEXTURE_TRANSPARENT);
        } else if (msg == "state_set_hex_types") {
            hex_types = llCSV2List(id);
        } else if (msg == "state_set_hex_numbers") {
            hex_numbers = llCSV2List(id);
        } else if (msg == "state_update_prims") {
        }
    }
}

// state place_town_and_road {
//     state_entry() {
//         llOwnerSay("Game: place_town_and_road for player " + (string)current_player);

//         highlighted_towns = game_get_valid_towns_initial();
//         prim_towns_set(highlighted_towns, <1.0, 1.0, 0.0>, TEXTURE_BLANK);
//     }

//     touch_start(integer num) {
//         integer face = llDetectedTouchFace(0);
//         integer link = llDetectedLinkNumber(0);
//         integer id = town_clicked();

//         if (llListFindList(highlighted_towns, [id]) >= 0) {
//             highlighted_towns = [];
//             player_add_town(current_player, id);
//             prim_towns_set([id], player_colour(current_player), TEXTURE_BLANK);
//         }
//     }
// }

// state starting {
//     state_entry() {
//         llOwnerSay("Game: starting");
//     }
// }

// state stopping {
//     state_entry() {
//         llOwnerSay("Game: stopping");
//         state off;
//     }
// }

// state ready {
//     listen(integer channel, string name, key id, string message) {
//         if (message = "off") {
//             state stopping;
//         }
//     }
// }


