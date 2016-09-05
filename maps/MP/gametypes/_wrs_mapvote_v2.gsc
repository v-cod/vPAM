init()
{
    //                           Technical name                           Title name
    i=0; level.wrs_maps[i][0] = "mp_bocage";     level.wrs_maps[i][1] = &"Bocage";
    i++; level.wrs_maps[i][0] = "mp_brecourt";   level.wrs_maps[i][1] = &"Brecourt";
    i++; level.wrs_maps[i][0] = "mp_carentan";   level.wrs_maps[i][1] = &"Carentan";
    i++; level.wrs_maps[i][0] = "mp_chateau";    level.wrs_maps[i][1] = &"Chateau";
    i++; level.wrs_maps[i][0] = "mp_dawnville";  level.wrs_maps[i][1] = &"Dawnville";
    i++; level.wrs_maps[i][0] = "mp_depot";      level.wrs_maps[i][1] = &"Depot";
    i++; level.wrs_maps[i][0] = "mp_harbor";     level.wrs_maps[i][1] = &"Harbor";
    i++; level.wrs_maps[i][0] = "mp_hurtgen";    level.wrs_maps[i][1] = &"Hurtgen";
    i++; level.wrs_maps[i][0] = "mp_neuville";   level.wrs_maps[i][1] = &"Neuville";
    i++; level.wrs_maps[i][0] = "mp_pavlov";     level.wrs_maps[i][1] = &"Pavlov";
    i++; level.wrs_maps[i][0] = "mp_powcamp";    level.wrs_maps[i][1] = &"POW Camp";
    i++; level.wrs_maps[i][0] = "mp_railyard";   level.wrs_maps[i][1] = &"Railyard";
    i++; level.wrs_maps[i][0] = "mp_rocket";     level.wrs_maps[i][1] = &"Rocket";
    i++; level.wrs_maps[i][0] = "mp_ship";       level.wrs_maps[i][1] = &"Ship";
    i++; level.wrs_maps[i][0] = "mp_stalingrad"; level.wrs_maps[i][1] = &"Stalingrad";
    i++; level.wrs_maps[i][0] = "mp_tigertown";  level.wrs_maps[i][1] = &"Tigertown";

    level.wrs_hud_mapvote_header = &"Map                                    Votes";

    if (!isDefined(game["gamestarted"])) {
        for (i = 0; i < level.wrs_maps.size; i++) {
            precacheString(level.wrs_maps[i][1]);
        }

        precacheString(level.wrs_hud_mapvote_header);

        precacheShader("white");
    }
}

start(s)
{
    rotation  = _rotation();
    candiates = _candidates(rotation, level.wrs_mapvote);

    if (!candidates.size) {
        iPrintLn(level.wrs_print_prefix + "No candidates to vote on, skipping vote");
        return;
    }

    _hud_mapvote_create(candidates.size);
    level.wrs_voting = true;

    players = getEntArray("player", "classname");
    for (i = 0; i < players.size; i++) {
        players[i] thread _monitor_player_mapvote();
    }

    wait s;
    level.wrs_voting = false;



    _hud_mapvote_destroy();
}

_monitor_player_mapvote()
{
    _hud_mapvote_indicator_create();

    while (isDefined(level.wrs_voting)) {

    }

    _hud_mapvote_indicator_destroy();
}

_rotation()
{
    str = getCvar("sv_maprotation");
    str = _tolower(str);
    arr = maps\mp\gametypes\_wrs_admin::explode(" ", str, 0);

    if (!arr.size) {
        return [];
    }

    gametype = level.gametype;
    rotation = [];

    for (i = 0; i < arr.size; i++) {
        if (arr[i] == "gametype") {
            i++;
            gametype = arr[i];

            continue;
        } else if (arr[i] == "map") {
            continue;
        }

        map = _find_map(arr[i]);

        if (!isDefined(map)) {
            continue;
        }

        // Do not include current map in rotation pool
        if (arr[i] == getCvar("mapname")) {
            continue;
        }

        j = rotation.size;

        rotation[j]["gametype"] = gametype;
        rotation[j]["map"]      = map;
    }

    return rotation;
}

_candidates(rotation, amount)
{
    if (!rotation.size) {
        return [];
    }

    if (rotation.size <= amount) {
        return rotation;
    }

    candidates = [];
    size       = rotation.size;

    while (1) {
        i = randomInt(size);
        if (!isDefined(rotation[i])) {
            continue;
        }

        candidates[candidates.size] = rotation[i];
        rotation[i] = undefined;
    }

    return candidates;
}

_hud_mapvote_indicator_create()
{
    self.wrs_hud_mapvote_indicator       = newClientHudElem(self);
    self.wrs_hud_mapvote_indicator.x     = level.wrs_mapvote_x + 4;
    self.wrs_hud_mapvote_indicator.y     = level.wrs_mapvote_y + 24;
    self.wrs_hud_mapvote_indicator.sort  = 9998;
    self.wrs_hud_mapvote_indicator.alpha = 0;
    self.wrs_hud_mapvote_indicator.color = (0, 0, 1);
    self.wrs_hud_mapvote_indicator setShader("white", level.wrs_mapvote_width - 8, 24);
}
_hud_mapvote_indicator_destroy()
{
    if(isDefined(self.wrs_hud_mapvote_indicator)) {
        self.wrs_hud_mapvote_indicator destroy();
    }
}

_hud_mapvote_create(cndts)
{
    level.wrs_mapvote_width  = 200;
    level.wrs_mapvote_height = 27 + cndts * 24;

    level.wrs_mapvote_x = 320 - level.wrs_mapvote_width/2;
    level.wrs_mapvote_y = -64 + 240 - level.wrs_mapvote_height/2;

    if (isDefined(level.wrs_hud_mapvote_bg)) {
        return;
    }
    //CONTAINER
    level.wrs_hud_mapvote_bg = newHudElem();
    level.wrs_hud_mapvote_bg.archived = false;
    level.wrs_hud_mapvote_bg.alpha = .7;
    level.wrs_hud_mapvote_bg.x = level.wrs_mapvote_x;
    level.wrs_hud_mapvote_bg.y = level.wrs_mapvote_y;
    level.wrs_hud_mapvote_bg.sort = 9000;
    level.wrs_hud_mapvote_bg.color = (0,0,0);
    level.wrs_hud_mapvote_bg setShader("white", level.wrs_mapvote_width, level.wrs_mapvote_height);
    //TITLE CONTAINER
    level.wrs_hud_mapvote_cont = newHudElem();
    level.wrs_hud_mapvote_cont.archived = false;
    level.wrs_hud_mapvote_cont.alpha = .3;
    level.wrs_hud_mapvote_cont.x = level.wrs_mapvote_x + 3;
    level.wrs_hud_mapvote_cont.y = level.wrs_mapvote_y + 3;
    level.wrs_hud_mapvote_cont.sort = 9001;
    level.wrs_hud_mapvote_cont setShader("white", level.wrs_mapvote_width - 6, 21);
    //TITLE TEXT
    level.wrs_hud_mapvote_cont_text = newHudElem();
    level.wrs_hud_mapvote_cont_text.archived = false;
    level.wrs_hud_mapvote_cont_text.alignX = "center";
    level.wrs_hud_mapvote_cont_text.x = level.wrs_mapvote_x + level.wrs_mapvote_width/2;
    level.wrs_hud_mapvote_cont_text.y = level.wrs_mapvote_y + 5;
    level.wrs_hud_mapvote_cont_text.sort = 9998;
    level.wrs_hud_mapvote_cont_text.label = level.wrs_hud_mapvote_header;
    level.wrs_hud_mapvote_cont_text.fontscale = 1.2;
    //LEFT CONTAINER LINE
    level.wrs_hud_mapvote_LL = newHudElem();
    level.wrs_hud_mapvote_LL.archived = false;
    level.wrs_hud_mapvote_LL.alpha = .3;
    level.wrs_hud_mapvote_LL.x = level.wrs_mapvote_x + 3;
    level.wrs_hud_mapvote_LL.y = level.wrs_mapvote_y + 24;
    level.wrs_hud_mapvote_LL.sort = 9001;
    level.wrs_hud_mapvote_LL setShader("white", 1, level.wrs_mapvote_height - 28);
    //RIGHT CONTAINER LINE
    level.wrs_hud_mapvote_RL = newHudElem();
    level.wrs_hud_mapvote_RL.archived = false;
    level.wrs_hud_mapvote_RL.alpha = .3;
    level.wrs_hud_mapvote_RL.x = level.wrs_mapvote_x + (level.wrs_mapvote_width - 4);
    level.wrs_hud_mapvote_RL.y = level.wrs_mapvote_y + 24;
    level.wrs_hud_mapvote_RL.sort = 9001;
    level.wrs_hud_mapvote_RL setShader("white", 1, level.wrs_mapvote_height - 28);
    //UNDER CONTAINER LINE
    level.wrs_hud_mapvote_UL = newHudElem();
    level.wrs_hud_mapvote_UL.archived = false;
    level.wrs_hud_mapvote_UL.alpha = .3;
    level.wrs_hud_mapvote_UL.x = level.wrs_mapvote_x + 3;
    level.wrs_hud_mapvote_UL.y = level.wrs_mapvote_y + (level.wrs_mapvote_height - 3);
    level.wrs_hud_mapvote_UL.alignY = "bottom";
    level.wrs_hud_mapvote_UL.sort = 9001;
    level.wrs_hud_mapvote_UL setShader("white", level.wrs_mapvote_width - 6, 1);
    //MAPS
    for(i = 0; i < cndts; i++) {
        level.wrs_hud_mapvote_map[i] = newHudElem();
        level.wrs_hud_mapvote_map[i].archived = false;
        level.wrs_hud_mapvote_map[i].x = level.wrs_mapvote_x + 8;
        level.wrs_hud_mapvote_map[i].y = level.wrs_mapvote_y + 24 + (i * 24);
        level.wrs_hud_mapvote_map[i].sort = 9998;
        level.wrs_hud_mapvote_map[i].fontScale = 1.5;
        level.wrs_hud_mapvote_map[i] setText(level.wrs_candidate[i]["iString"]);

        level.wrs_hud_mapvote_map_votes[i] = newHudElem();
        level.wrs_hud_mapvote_map_votes[i].archived = false;
        level.wrs_hud_mapvote_map_votes[i].alignX = "right";
        level.wrs_hud_mapvote_map_votes[i].x = level.wrs_mapvote_x + level.wrs_mapvote_Width - 8;
        level.wrs_hud_mapvote_map_votes[i].y = level.wrs_mapvote_y + 24 + (i * 24);
        level.wrs_hud_mapvote_map_votes[i].sort = 9998;
        level.wrs_hud_mapvote_map_votes[i].fontScale = 1.5;
        level.wrs_hud_mapvote_map_votes[i] setValue(0);
    }

    level.wrs_hud_mapvote_timer = newHudElem();
    level.wrs_hud_mapvote_timer.archived = false;
    level.wrs_hud_mapvote_timer.x = level.wrs_mapvote_x + level.wrs_mapvote_Width/2;
    level.wrs_hud_mapvote_timer.y = level.wrs_mapvote_y - 3;
    level.wrs_hud_mapvote_timer.alignX = "center";
    level.wrs_hud_mapvote_timer.alignY = "middle";
    level.wrs_hud_mapvote_timer.sort = 9999;
}
_hud_mapvote_destroy()
{
    for(i = 0; i < level.wrs_hud_mapvote_map.size; i++) {
        if (isDefined(level.wrs_hud_mapvote_map[i])) {
            level.wrs_hud_mapvote_map[i] fadeOverTime(1);
            level.wrs_hud_mapvote_map[i].alpha = 0;
            level.wrs_hud_mapvote_map_votes[i] fadeOverTime(1);
            level.wrs_hud_mapvote_map_votes[i].alpha = 0;
        }
    }

    if (isDefined(level.wrs_hud_mapvote_bg)) {
        level.wrs_hud_mapvote_bg fadeOverTime(1);
        level.wrs_hud_mapvote_bg.alpha = 0;
    }
    if (isDefined(level.wrs_hud_mapvote_cont)) {
        level.wrs_hud_mapvote_cont fadeOverTime(1);
        level.wrs_hud_mapvote_cont.alpha = 0;
    }
    if (isDefined(level.wrs_hud_mapvote_cont_text)) {
        level.wrs_hud_mapvote_cont_text fadeOverTime(1);
        level.wrs_hud_mapvote_cont_text.alpha = 0;
    }
    if (isDefined(level.wrs_hud_mapvote_LL)) {
        level.wrs_hud_mapvote_LL fadeOverTime(1);
        level.wrs_hud_mapvote_LL.alpha = 0;
    }
    if (isDefined(level.wrs_hud_mapvote_RL)) {
        level.wrs_hud_mapvote_RL fadeOverTime(1);
        level.wrs_hud_mapvote_RL.alpha = 0;
    }
    if (isDefined(level.wrs_hud_mapvote_UL)) {
        level.wrs_hud_mapvote_UL fadeOverTime(1);
        level.wrs_hud_mapvote_UL.alpha = 0;
    }
    if (isDefined(level.wrs_hud_mapvote_timer)) {
        level.wrs_hud_mapvote_timer fadeOverTime(1);
        level.wrs_hud_mapvote_timer.alpha = 0;
    }

    wait 1;

    if (isDefined(level.wrs_hud_mapvote_bg)) {
        level.wrs_hud_mapvote_bg destroy();
    }
    if (isDefined(level.wrs_hud_mapvote_cont)) {
        level.wrs_hud_mapvote_cont destroy();
    }
    if (isDefined(level.wrs_hud_mapvote_cont_text)) {
        level.wrs_hud_mapvote_cont_text destroy();
    }
    if (isDefined(level.wrs_hud_mapvote_LL)) {
        level.wrs_hud_mapvote_LL destroy();
    }
    if (isDefined(level.wrs_hud_mapvote_RL)) {
        level.wrs_hud_mapvote_RL destroy();
    }
    if (isDefined(level.wrs_hud_mapvote_UL)) {
        level.wrs_hud_mapvote_UL destroy();
    }
    if (isDefined(level.wrs_hud_mapvote_timer)) {
        level.wrs_hud_mapvote_timer destroy();
    }
    for(i = 0; i < level.wrs_hud_mapvote_map.size; i++) {
        if (isDefined(level.wrs_hud_mapvote_map[i])) {
            level.wrs_hud_mapvote_map[i] destroy();
            level.wrs_hud_mapvote_map_votes[i] destroy();
        }
    }
}

_tolower(str)
{
    for (i = 0; i < str.size; i++) {
        if (str[i] >= 'A' && str[i] <= 'Z') {
            str[i] -= 'A' - 'a';
        }
    }

    return str;
}

_find_map(str)
{
    for (i = 0; i < level.wrs_maps.size; i++) {
        if (level.wrs_maps[i][0] == str) {
            return level.wrs_maps[i];
        }
    }

    return undefined;
}
