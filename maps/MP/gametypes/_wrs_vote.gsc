init()
{
	level.wrs_maps[0][0]  = "mp_bocage";     level.wrs_maps[0][1]  = &"Bocage";     level.wrs_maps[0][2]  = "Bocage";
	level.wrs_maps[1][0]  = "mp_brecourt";   level.wrs_maps[1][1]  = &"Brecourt";   level.wrs_maps[1][2]  = "Brecourt";
	level.wrs_maps[2][0]  = "mp_carentan";   level.wrs_maps[2][1]  = &"Carentan";   level.wrs_maps[2][2]  = "Carentan";
	level.wrs_maps[3][0]  = "mp_chateau";    level.wrs_maps[3][1]  = &"Chateau";    level.wrs_maps[3][2]  = "Chateau";
	level.wrs_maps[4][0]  = "mp_dawnville";  level.wrs_maps[4][1]  = &"Dawnville";  level.wrs_maps[4][2]  = "Dawnville";
	level.wrs_maps[5][0]  = "mp_depot";      level.wrs_maps[5][1]  = &"Depot";      level.wrs_maps[5][2]  = "Depot";
	level.wrs_maps[6][0]  = "mp_harbor";     level.wrs_maps[6][1]  = &"Harbor";     level.wrs_maps[6][2]  = "Harbor";
	level.wrs_maps[7][0]  = "mp_hurtgen";    level.wrs_maps[7][1]  = &"Hurtgen";    level.wrs_maps[7][2]  = "Hurtgen";
	level.wrs_maps[8][0]  = "mp_neuville";   level.wrs_maps[8][1]  = &"Neuville";   level.wrs_maps[8][2]  = "Neuville";
	level.wrs_maps[9][0]  = "mp_pavlov";     level.wrs_maps[9][1]  = &"Pavlov";     level.wrs_maps[9][2]  = "Pavlov";
	level.wrs_maps[10][0] = "mp_powcamp";    level.wrs_maps[10][1] = &"POW Camp";   level.wrs_maps[10][2] = "POW Camp";
	level.wrs_maps[11][0] = "mp_railyard";   level.wrs_maps[11][1] = &"Railyard";   level.wrs_maps[11][2] = "Railyard";
	level.wrs_maps[12][0] = "mp_rocket";     level.wrs_maps[12][1] = &"Rocket";     level.wrs_maps[12][2] = "Rocket";
	level.wrs_maps[13][0] = "mp_ship";       level.wrs_maps[13][1] = &"Ship";       level.wrs_maps[13][2] = "Ship";
	level.wrs_maps[14][0] = "mp_stalingrad"; level.wrs_maps[14][1] = &"Stalingrad"; level.wrs_maps[14][2] = "Stalingrad";
	level.wrs_maps[15][0] = "mp_tigertown";  level.wrs_maps[15][1] = &"Tigertown";  level.wrs_maps[15][2] = "Tigertown";
	level.wrs_maps[16][0] = "german_town";   level.wrs_maps[16][1] = &"German Town";level.wrs_maps[16][2] = "German Town";
	level.wrs_maps[17][0] = "mp_stanjel";    level.wrs_maps[17][1] = &"Stanjel";    level.wrs_maps[17][2] = "Stanjel";
	level.wrs_maps[18][0] = "mp_priory";     level.wrs_maps[18][1] = &"Priory";     level.wrs_maps[18][2] = "Priory";
	level.wrs_maps[19][0] = "mp_cassino";    level.wrs_maps[19][1] = &"Cassino";    level.wrs_maps[19][2] = "Cassino";
	level.wrs_maps[20][0] = "mp_uo_harbor";  level.wrs_maps[20][1] = &"UO Harbor";  level.wrs_maps[20][2] = "UO Harbor";
	level.wrs_maps[21][0] = "mp_vacant";     level.wrs_maps[21][1] = &"Vacant";     level.wrs_maps[21][2] = "Vacant";
 
	level.wrs_vote_hud_header_istring = &"Map                                    Votes";
	level.wrs_vote_hud_entry_height = 24;
	level.wrs_vote_hud_border_width = 2;

	if (!isDefined(game["gamestarted"])) {
		for (i = 0; i < level.wrs_maps.size; i++) {
			precacheString(level.wrs_maps[i][1]);
		}

		precacheShader("white");
		precacheShader("black");
		precacheString(level.wrs_vote_hud_header_istring);
	}
}

start(max_maps, seconds)
{
	// All votable maps.
	pool = _get_valid_maps();
	// If too many maps: randomly pick from all votable maps.
	pool = _select_random(pool, max_maps);

	istrings = [];
	for (i = 0; i < pool.size; i++) {
		istrings[i] = level.wrs_maps[pool[i]][1];
		level.wrs_vote_count[i] = 0;
	}

	_hud_vote_create(istrings);
	level.wrs_vote_hud_clock setClock(seconds, 60, "hudStopwatch", 64, 64);

	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++) {
		players[i] thread _monitor_player();
	}

	wait seconds;

	level notify("wrs_vote_end");
	_hud_vote_destroy();

	// Default winner is 0.
	winner = 0;
	highest = level.wrs_vote_count[winner];
	// Find higher count.
	for(i = 1; i < level.wrs_vote_count.size; i++) {
		if (level.wrs_vote_count[i] > highest) {
			winner = i;
			highest = level.wrs_vote_count[winner];
		}
	}

	logPrint("wrs;MAPVOTE;" + players.size + ";" + level.wrs_maps[pool[winner]][0] + "\n");

	iPrintLnBold("^4Next Map^7: ^3" + level.wrs_maps[pool[winner]][2]);
	setCvar("sv_maprotationcurrent", "gametype " + level.gametype + " map " + level.wrs_maps[pool[winner]][0]);
}

_monitor_player()
{
	// Aliases.
	eh = level.wrs_vote_hud_entry_height;
	bw = level.wrs_vote_hud_border_width;

	self.wrs_vote_hud_indicator = newClientHudElem(self);
	self.wrs_vote_hud_indicator.x = level.wrs_vote_x + bw;
	self.wrs_vote_hud_indicator.y = -128;
	self.wrs_vote_hud_indicator.sort= 9998;
	self.wrs_vote_hud_indicator.alpha = 0.3;
	self.wrs_vote_hud_indicator.color = (0, 0, 1);
	self.wrs_vote_hud_indicator setShader("white", level.wrs_vote_width - 2*bw, eh);

	self thread _monitor_player_vote();

	level waittill("wrs_vote_end");
	self.wrs_vote_hud_indicator destroy();
}

_monitor_player_vote()
{
	// Aliases.
	eh = level.wrs_vote_hud_entry_height;
	bw = level.wrs_vote_hud_border_width;

	level endon("wrs_vote_end");

	vote = -1;
	while (true) {
		if (self attackButtonPressed()) {
			// Cancel vote if applicable.
			if (vote != -1) {
				level.wrs_vote_count[vote]--;
				level.wrs_vote_hud_count[vote] setValue(level.wrs_vote_count[vote]);
			}

			// Change vote.
			vote++;
			if (vote > level.wrs_vote_count.size - 1) {
				vote = 0;
			}

			// Apply vote.
			level.wrs_vote_count[vote]++;
			level.wrs_vote_hud_count[vote] setValue(level.wrs_vote_count[vote]);

			self.wrs_vote_hud_indicator.y = level.wrs_vote_y + bw + eh + vote*eh;
			self playLocalSound("hq_score");

			while(self attackButtonPressed()) {
				wait .05;
			}
		}

		wait .05;
	}
}


// Get array of level.wrs_maps indices that are valid map choices.
// Takes into account thresholds, no Harbor repeat, and only mod-defined maps (level.wrs_maps).
_get_valid_maps()
{
	// scr_wrs_mapplayers must hold pairs of numbers and maps,
	// e.g. "5 mp_carentan 20 mp_rocket",  where the number is the minimum
	// amount of players for this map to be in the pool.
	thresholds = getCvar("scr_wrs_mapplayers");
	thresholds = maps\mp\gametypes\_wrs_admin::explode(" ", thresholds, 0);
	t = [];
	for (i = 0; i < thresholds.size; i += 2) {
		t[thresholds[i + 1]] = (int) thresholds[i];
	}
	thresholds = t;

	rotation = getCvar("sv_maprotation");
	rotation = maps\mp\gametypes\_wrs_admin::explode(" ", rotation, 0);

	psize = getEntArray("player", "classname").size;

	map_is_harbor = getCvar("mapname") == "mp_harbor" || getCvar("mapname") == "mp_uo_harbor";

	// Find level.wrs_maps in rotation and store their index number if below its threshold.
	r = [];
	for (i = 0; i < rotation.size; i++) {
		if (isDefined(thresholds[rotation[i]]) && psize < thresholds[rotation[i]]) {
			continue;
		}

		// Search for the map string in the level.wrs_maps array.
		index = maps\mp\gametypes\_wrs::_find_multi(rotation[i], level.wrs_maps, 0);
		if (index != -1) {
			if (map_is_harbor && (index == 6 || index == 20)) {
				continue;
			}

			r[r.size] = index;
		}
	}
	
	return r;
}

// Randomly select values from an array.
_select_random(arr, s)
{
	if (arr.size <= s) {
		return arr;
	}

	arr_last = arr.size;

	// Set random values to undefined, until size is right.
	while (arr.size > s) {
		// Random number for set of DEFINED values.
		rand = randomInt(arr.size);
		for (i = 0; i < arr_last; i++) {
			if (!isDefined(arr[i])) {
				// Correct the random number to discard UNDEFINED values.
				rand++;
			} else if (rand == i) {
				arr[i] = undefined;
				break;
			}
		}
	}

	new_arr = [];
	for (i = 0; i < arr_last; i++) {
		if (isDefined(arr[i])) {
			new_arr[new_arr.size] = arr[i];
		}
	}

	return new_arr;
}

_hud_vote_create(istrings)
{
	level.wrs_vote_width = 200;
	level.wrs_vote_height = 27 + istrings.size * 24;

	level.wrs_vote_x = 320 - level.wrs_vote_width/2;
	level.wrs_vote_y = -64 + 240 - level.wrs_vote_height/2;

	if (isDefined(level.wrs_vote_hud_cont)) {
		return;
	}

	// Aliases.
	eh = level.wrs_vote_hud_entry_height;
	bw = level.wrs_vote_hud_border_width;

	// Container.
	level.wrs_vote_hud_cont = newHudElem();
	level.wrs_vote_hud_cont.archived = false;
	level.wrs_vote_hud_cont.alpha = .75;
	level.wrs_vote_hud_cont.x = level.wrs_vote_x;
	level.wrs_vote_hud_cont.y = level.wrs_vote_y;
	level.wrs_vote_hud_cont.sort = 9000;
	level.wrs_vote_hud_cont.color = (0,0,0);
	level.wrs_vote_hud_cont setShader("black", level.wrs_vote_width, level.wrs_vote_height);

	// Header.
	level.wrs_vote_hud_header = newHudElem();
	level.wrs_vote_hud_header.archived = false;
	level.wrs_vote_hud_header.alpha = .25;
	level.wrs_vote_hud_header.x = level.wrs_vote_x + bw;
	level.wrs_vote_hud_header.y = level.wrs_vote_y + bw;
	level.wrs_vote_hud_header.sort = 9001;
	level.wrs_vote_hud_header setShader("white", level.wrs_vote_width - 2*bw, eh);

	// Header text.
	level.wrs_vote_hud_header_text = newHudElem();
	level.wrs_vote_hud_header_text.archived = false;
	level.wrs_vote_hud_header_text.alignX = "center";
	level.wrs_vote_hud_header_text.alignY = "middle";
	level.wrs_vote_hud_header_text.x = level.wrs_vote_x + level.wrs_vote_width/2;
	level.wrs_vote_hud_header_text.y = level.wrs_vote_y + bw + eh/2;
	level.wrs_vote_hud_header_text.sort = 9998;
	level.wrs_vote_hud_header_text.label = level.wrs_vote_hud_header_istring;
	level.wrs_vote_hud_header_text.fontscale = 1.2;

	// Votables container.
	level.wrs_vote_hud_votables = newHudElem();
	level.wrs_vote_hud_votables.archived = false;
	level.wrs_vote_hud_votables.alpha = .125;
	level.wrs_vote_hud_votables.x = level.wrs_vote_x + bw;
	level.wrs_vote_hud_votables.y = level.wrs_vote_y + bw + eh;
	level.wrs_vote_hud_votables.sort = 9001;
	level.wrs_vote_hud_votables setShader("white", level.wrs_vote_width - 2*bw, level.wrs_vote_height - 2*bw - eh);

	// Votables.
	for (i = 0; i < istrings.size; i++) {
		// Left header.
		level.wrs_vote_hud_entry[i] = newHudElem();
		level.wrs_vote_hud_entry[i].archived = false;
		level.wrs_vote_hud_entry[i].x = level.wrs_vote_x + 3*bw;
		level.wrs_vote_hud_entry[i].y = level.wrs_vote_y + bw + eh + (i * eh);
		level.wrs_vote_hud_entry[i].sort = 9998;
		level.wrs_vote_hud_entry[i].fontScale = 1.5;
		level.wrs_vote_hud_entry[i] setText(istrings[i]);

		// Right header.
		level.wrs_vote_hud_count[i] = newHudElem();
		level.wrs_vote_hud_count[i].archived = false;
		level.wrs_vote_hud_count[i].alignX = "right";
		level.wrs_vote_hud_count[i].x = level.wrs_vote_x + level.wrs_vote_width - 3*bw;
		level.wrs_vote_hud_count[i].y = level.wrs_vote_y + bw + eh + (i * eh);
		level.wrs_vote_hud_count[i].sort = 9998;
		level.wrs_vote_hud_count[i].fontScale = 1.5;
		level.wrs_vote_hud_count[i] setValue(0);
	}

	// Clock.
	level.wrs_vote_hud_clock = newHudElem();
	level.wrs_vote_hud_clock.archived = false;
	level.wrs_vote_hud_clock.x = level.wrs_vote_x + level.wrs_vote_width/2;
	level.wrs_vote_hud_clock.y = level.wrs_vote_y - 3;
	level.wrs_vote_hud_clock.alignX = "center";
	level.wrs_vote_hud_clock.alignY = "middle";
	level.wrs_vote_hud_clock.sort = 9999;
}

_hud_vote_destroy()
{
	for(i = 0; i < level.wrs_vote_hud_entry.size; i++) {
		if (isDefined(level.wrs_vote_hud_entry[i])) {
			level.wrs_vote_hud_entry[i] fadeOverTime(1);
			level.wrs_vote_hud_entry[i].alpha = 0;
			level.wrs_vote_hud_count[i] fadeOverTime(1);
			level.wrs_vote_hud_count[i].alpha = 0;
		}
	}

	if (isDefined(level.wrs_vote_hud_cont)) {
		level.wrs_vote_hud_cont fadeOverTime(1);
		level.wrs_vote_hud_cont.alpha = 0;
	}
	if (isDefined(level.wrs_vote_hud_header)) {
		level.wrs_vote_hud_header fadeOverTime(1);
		level.wrs_vote_hud_header.alpha = 0;
	}
	if (isDefined(level.wrs_vote_hud_header_text)) {
		level.wrs_vote_hud_header_text fadeOverTime(1);
		level.wrs_vote_hud_header_text.alpha = 0;
	}
	if (isDefined(level.wrs_vote_hud_votables)) {
		level.wrs_vote_hud_votables fadeOverTime(1);
		level.wrs_vote_hud_votables.alpha = 0;
	}
	if (isDefined(level.wrs_vote_hud_RL)) {
		level.wrs_vote_hud_RL fadeOverTime(1);
		level.wrs_vote_hud_RL.alpha = 0;
	}
	if (isDefined(level.wrs_vote_hud_UL)) {
		level.wrs_vote_hud_UL fadeOverTime(1);
		level.wrs_vote_hud_UL.alpha = 0;
	}
	if (isDefined(level.wrs_vote_hud_clock)) {
		level.wrs_vote_hud_clock fadeOverTime(1);
		level.wrs_vote_hud_clock.alpha = 0;
	}

	wait 1;

	if (isDefined(level.wrs_vote_hud_cont))
		level.wrs_vote_hud_cont destroy();
	if (isDefined(level.wrs_vote_hud_header))
		level.wrs_vote_hud_header destroy();
	if (isDefined(level.wrs_vote_hud_header_text))
		level.wrs_vote_hud_header_text destroy();
	if (isDefined(level.wrs_vote_hud_votables))
		level.wrs_vote_hud_votables destroy();
	if (isDefined(level.wrs_vote_hud_clock))
		level.wrs_vote_hud_clock destroy();
	for(i = 0; i < level.wrs_vote_hud_entry.size; i++) {
		if (isDefined(level.wrs_vote_hud_entry[i])) {
			level.wrs_vote_hud_entry[i] destroy();
			level.wrs_vote_hud_count[i] destroy();
		}
	}
}
