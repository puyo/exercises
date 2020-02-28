// GAME CONTROLLER

// ------------------------------------------------------
// constants

integer CHANNEL = 537713;
integer listen_handle;

integer town_clicked() {
    integer face = llDetectedTouchFace(0);
    integer link = llDetectedLinkNumber(0);
    integer i;
    // for (i = 0; i < TOWN_INFO_LEN; ++i) {
    //     if (town_link(i) == link && town_face(i) == face) {
    //         return i;
    //     }
    // }
    return -1;
}

// ------------------------------------------------------
// states

default {
    state_entry() {
        llOwnerSay("------------------------");
        llOwnerSay("Game: default");

        listen_handle = llListen(CHANNEL, "", "", "");

        state off;
    }
}

state off {
    state_entry() {
        llOwnerSay("Game: off");
        llMessageLinked(LINK_THIS, 4, "state_start_new", "");
    }

    touch_start(integer num) {
        key toucher = llDetectedKey(0);
        list options = ["New game", "Build town", "Build road"];
        llDialog(toucher, "Welcome to Wood for Sheep", options, CHANNEL);
    }

    // llDialog callback
    listen(integer channel, string name, key id, string message) {
        if (message == "Start game (4 players)") {
            llMessageLinked(LINK_THIS, 4, "state_start_new", "");
        }
    }
}

// state build_town {
//     state_entry() {
//         llOwnerSay("Game: build_town");

//         highlighted_towns = game_get_valid_towns();
//         prim_towns_set(highlighted_towns, <1.0, 1.0, 0.0>, TEXTURE_BLANK);
//     }

//     touch_start(integer num) {
//         integer face = llDetectedTouchFace(0);
//         integer link = llDetectedLinkNumber(0);
//         integer id = town_clicked();
//         if (llListFindList(highlighted_towns, [id]) >= 0) {
//             prim_towns_set([id], <1.0, 0.0, 0.0>, TEXTURE_BLANK);
//         }
//     }
// }


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

