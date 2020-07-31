_local()
{
	var["axis"] = [];
	var["axis"]["name"] = &"MPSCRIPT_GERMAN";
	var["axis"]["color"] = (.60, .60, .60);
	var["axis"]["banner"] = "gfx/hud/hud@mpflag_german.tga";

	// Default allied.
	var["allies"] = [];
	var["allies"]["name"] = &"MPSCRIPT_AMERICAN";
	var["allies"]["color"] = (.25, .75, .25);
	var["allies"]["banner"] = "gfx/hud/hud@mpflag_american.tga";

	switch (game["allies"]) {
	case "british":
		var["allies"]["name"] = &"MPSCRIPT_BRITISH";
		var["allies"]["color"] = (.25, .25, .75);
		var["allies"]["banner"] = "gfx/hud/hud@mpflag_british.tga";
		break;
	case "russian":
		var["allies"]["name"] = &"MPSCRIPT_RUSSIAN";
		var["allies"]["color"] = (.75, .25, .25);
		var["allies"]["banner"] = "gfx/hud/hud@mpflag_russian.tga";
		break;
	}

	return var;
}


precache()
{
	var = _local();

	precacheString(&"Total K&D");
	precacheString(&"Current map");
	
	precacheString(&"CGAME_UNKNOWN");

	precacheString(var["allies"]["name"]);
	precacheString(var["axis"]["name"]);

	precacheShader(var["allies"]["banner"]);
	precacheShader(var["axis"]["banner"]);

	vote\map::precache();
}

create(header_text, header_time)
{
	if (isDefined(level._hud_sb)) {
		destroy_();
	}

	level._hud_sb = [];

	x = 520;
	y = 120;
	y_top = y;

	if (isDefined(header_text)) {
		level._hud_sb[0] = newHudElem();
		level._hud_sb[0].sort = 1;
		level._hud_sb[0].x = x + 2;
		level._hud_sb[0].y = y + 6;
		level._hud_sb[0].alignY = "middle";
		level._hud_sb[0].color = (1, 1, 0);
		level._hud_sb[0].fontScale = 0.60;
		level._hud_sb[0] setText(header_text);

		if (isDefined(header_time)) {
			level._hud_sb[1] = newHudElem();
			level._hud_sb[1].sort = 1;
			level._hud_sb[1].x = 640 - 2;
			level._hud_sb[1].y = y + 6;
			level._hud_sb[1].alignX = "right";
			level._hud_sb[1].alignY = "middle";
			level._hud_sb[1].color = (1, 1, 0);
			level._hud_sb[1].fontScale = 0.75;
			level._hud_sb[1] setTimer(header_time);
		}

		y += 16;
	}


	var = _local();

	// To easily reference scores by standard string key.
	score_current["allies"] = game["alliedscore"];
	score_current["axis"] = game["axisscore"];

	if (isDefined(game["_history_data"])) {
		score_total = history::total_score();
	} else {
		score_total["allies"] = score_current["allies"];
		score_total["axis"] = score_current["axis"];
	}

	// Draw best scoring team first (above the first).
	if (score_total["allies"] > score_total["axis"]) {
		t1 = "allies";
		t2 = "axis";
	} else {
		t1 = "axis";
		t2 = "allies";
	}

	// istring to use for current map.
	map_current_istr = vote\map::mapname_to_istring(getCvar("mapname"));
	if (!isDefined(map_current_istr)) {
		map_current_istr = &"CGAME_UNKNOWN";
	}

	// Draw the first team banner.
	y = draw_row(x, y, var[t1]["banner"], var[t1]["color"], var[t1]["name"], score_total[t1], undefined);
	// If we have history, then show a row for each map.
	if (isDefined(game["_history_data"])) {
		team = "team_1";
		if (game["_history_team_1"] != t1) {
			team = "team_2";
		}
		for (i = 0; i < game["_history_data"]["scores"][team].size; i++) {
			map_istr = vote\map::mapname_to_istring(game["_history_data"]["maps"][i]);
			if (!isDefined(map_istr)) {
				map_istr = &"CGAME_UNKNOWN";
			}
			
			y = draw_row(x, y, undefined, undefined, map_istr, game["_history_data"]["scores"][team][i], undefined);
		}
	}
	y = draw_row(x, y, undefined, undefined, map_current_istr, score_current[t1], undefined);
	y_pointer[t1] = y - 12; // To place the selector at the right place.
	y += 4; // Add little space before next banner.

	y = draw_row(x, y, var[t2]["banner"], var[t2]["color"], var[t2]["name"], score_total[t2], undefined);
	if (isDefined(game["_history_data"])) {
		team = "team_1";
		if (game["_history_team_1"] != t2) {
			team = "team_2";
		}
		for (i = 0; i < game["_history_data"]["scores"][team].size; i++) {
			map_istr = vote\map::mapname_to_istring(game["_history_data"]["maps"][i]);
			if (!isDefined(map_istr)) {
				map_istr = &"CGAME_UNKNOWN";
			}
			
			y = draw_row(x, y, undefined, undefined, map_istr, game["_history_data"]["scores"][team][i], undefined);
		}
	}
	y = draw_row(x, y, undefined, undefined, map_current_istr, score_current[t2], undefined);
	y_pointer[t2] = y - 12; // To place the selector at the right place.
	y += 4; // Add little space before next banner.

	// Container.
	i = level._hud_sb.size;
	level._hud_sb[i] = newHudElem();
	level._hud_sb[i].alpha = .75;
	level._hud_sb[i].sort = -1;
	level._hud_sb[i].x = x - 2;
	level._hud_sb[i].y = y_top - 2;
	level._hud_sb[i].color = (0, 0, 0);
	level._hud_sb[i] setShader("black", 640 - x + 2, y - y_top + 4);

	level thread draw_selectors(x, y_pointer, var);
}

draw_selectors(x, y_pointer, var)
{
	level endon("_hud_sb_destroy");

	while (true) {
		// Place selector.
		players = getEntArray("player", "classname");

		for (i = 0; i < players.size; i++) {
			if (isDefined(players[i]._hud_sb_pointer)) {
				players[i]._hud_sb_pointer destroy();
			}

			if (players[i].pers["team"] == "allies" || players[i].pers["team"] == "axis") {
				players[i]._hud_sb_pointer = newClientHudElem(players[i]);
				players[i]._hud_sb_pointer.alpha = .25;
				players[i]._hud_sb_pointer.x = x;
				players[i]._hud_sb_pointer.y = y_pointer[players[i].pers["team"]];
				players[i]._hud_sb_pointer.color = var[players[i].pers["team"]]["color"];
				players[i]._hud_sb_pointer setShader("white", 640 - x, 10);
			}
		}

		wait .5;
	}
}

draw_row(x, y, shader, color, text, value_1, value_2)
{
	font_scale = 0.75;
	if (!isDefined(color)) {
		color = (1, 1, 1);
	}

	i = level._hud_sb.size;

	if (isDefined(shader)) {
		font_scale = 1;
		level._hud_sb[i] = newHudElem();
		level._hud_sb[i] setShader(shader, 256, 16);
		level._hud_sb[i].sort = 0;
		level._hud_sb[i].x = x;
		level._hud_sb[i].y = y;
		level._hud_sb[i].fontScale = font_scale;
		i++;
	}

	if (isDefined(text)) {
		level._hud_sb[i] = newHudElem();
		level._hud_sb[i].sort = 1;
		level._hud_sb[i].x = x + 8;
		level._hud_sb[i].y = y - 1;
		level._hud_sb[i].fontScale = font_scale;
		level._hud_sb[i].color = color;
		level._hud_sb[i] setText(text);
		i++;
	}

	if (isDefined(value_1)) {
		level._hud_sb[i] = newHudElem();
		level._hud_sb[i].sort = 1;
		level._hud_sb[i].x = x + 96;
		level._hud_sb[i].y = y - 1;
		level._hud_sb[i].alignX = "right";
		level._hud_sb[i].fontScale = font_scale;
		level._hud_sb[i].color = color;
		level._hud_sb[i] setValue(value_1);
		i++;
	}

	if (isDefined(value_2)) {
		level._hud_sb[i] = newHudElem();
		level._hud_sb[i].sort = 1;
		level._hud_sb[i].x = 640 - 2;
		level._hud_sb[i].y = y ;
		level._hud_sb[i].alignX = "right";
		level._hud_sb[i].fontScale = font_scale;
		level._hud_sb[i].color = color;
		level._hud_sb[i] setValue(value_2);
		i++;
	}

	if (font_scale >= 1) {
		y += 16;
	} else {
		y += 12;
	}

	return y;
}

destroy_()
{
	level notify("_hud_sb_destroy");

	if (isDefined(level._hud_sb)) {
		for (i = 0; i < level._hud_sb.size; i++) {
			if (isDefined(level._hud_sb[i])) {
				level._hud_sb[i] destroy();
				level._hud_sb[i] = ""; // TODO: Needed?
			}
		}
	}

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (isDefined(players[i]._hud_sb_pointer)) {
			players[i]._hud_sb_pointer destroy();
		}
	}
}
