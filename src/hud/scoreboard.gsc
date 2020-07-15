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
	
	var["spectator"]["banner"] = "gfx/hud/hud@mpflag_spectator.tga";

	return var;
}


precache()
{
	var = _local();

	precacheString(&"Total K&D");

	precacheString(var["allies"]["name"]);
	precacheString(var["axis"]["name"]);

	precacheShader(var["allies"]["banner"]);
	precacheShader(var["axis"]["banner"]);
}

kd_sum()
{
	score["allies"]["score"] = 0;
	score["allies"]["deaths"] = 0;
	score["axis"]["score"] = 0;
	score["axis"]["deaths"] = 0;

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (players[i].pers["team"] == "allies" || players[i].pers["team"] == "axis") {
			if (isDefined(players[i].pers["score"])) {
				score[players[i].pers["team"]]["score"] += players[i].pers["score"];
			}
			if (isDefined(players[i].pers["deaths"])) {
				score[players[i].pers["team"]]["deaths"] += players[i].pers["deaths"];
			}
		}
	}

	return score;
}

create(header_text, header_time)
{
	if (isDefined(level._hud_sb_background)) {
		destroy_();
	}

	total["allies"] = game["alliedscore"];
	total["axis"] = game["axisscore"];

	x = 520;
	y = 120;
	y_top = y;

	if (isDefined(header_text)) {
		level._hud_sb_header = newHudElem();
		level._hud_sb_header.sort = 1;
		level._hud_sb_header.x = x + 2;
		level._hud_sb_header.y = y + 6;
		level._hud_sb_header.alignY = "middle";
		level._hud_sb_header.color = (1, 1, 0);
		level._hud_sb_header.fontScale = 0.60;
		level._hud_sb_header setText(header_text);
		
		if (isDefined(header_time)) {
			level._hud_sb_header_value = newHudElem();
			level._hud_sb_header_value.sort = 1;
			level._hud_sb_header_value.x = 640 - 2;
			level._hud_sb_header_value.y = y + 6;
			level._hud_sb_header_value.alignX = "right";
			level._hud_sb_header_value.alignY = "middle";
			level._hud_sb_header_value.color = (1, 1, 0);
			level._hud_sb_header_value.fontScale = 0.75;
			level._hud_sb_header_value setTimer(header_time);
		}

		y += 16;
	}


	var = _local();
	scores = kd_sum();

	// Draw best scoring team first (above the first).
	if (total["allies"] > total["axis"]) {
		t1 = "allies";
		t2 = "axis";
	} else {
		t1 = "axis";
		t2 = "allies";
	}
	y = draw_team(t1, x, y, var[t1]["banner"], var[t1]["name"], var[t1]["color"], total[t1], scores[t1]["score"], scores[t1]["deaths"]);
	y_pointer[t1] = y - 12; // To place the selector at the right place.
	y += 4; // Add little space before next banner.
	y = draw_team(t2, x, y, var[t2]["banner"], var[t2]["name"], var[t2]["color"], total[t2], scores[t2]["score"], scores[t2]["deaths"]);
	y_pointer[t2] = y - 12; // To place the selector at the right place.

	// Container.
	level._hud_sb_background = newHudElem();
	level._hud_sb_background.alpha = .75;
	level._hud_sb_background.sort = -1;
	level._hud_sb_background.x = x - 2;
	level._hud_sb_background.y = y_top - 2;
	level._hud_sb_background.color = (0, 0, 0);
	level._hud_sb_background setShader("black", 640 - x + 2, y - y_top + 4);

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

draw_team(id, x, y, shader, text, color, team_score, kills, deaths)
{
	level._hud_sb_team[id]["banner"] = newHudElem();
	level._hud_sb_team[id]["banner"] setShader(shader, 256, 16);
	level._hud_sb_team[id]["banner"].sort = 0;
	level._hud_sb_team[id]["banner"].x = x;
	level._hud_sb_team[id]["banner"].y = y;

	level._hud_sb_team[id]["banner_text"] = newHudElem();
	level._hud_sb_team[id]["banner_text"].sort = 1;
	level._hud_sb_team[id]["banner_text"].x = x + 8;
	level._hud_sb_team[id]["banner_text"].y = y - 1;
	level._hud_sb_team[id]["banner_text"].color = color;
	level._hud_sb_team[id]["banner_text"] setText(text);

	level._hud_sb_team[id]["banner_score"] = newHudElem();
	level._hud_sb_team[id]["banner_score"].sort = 1;
	level._hud_sb_team[id]["banner_score"].x = x + 96;
	level._hud_sb_team[id]["banner_score"].y = y - 1;
	level._hud_sb_team[id]["banner_score"].alignX = "right";
	level._hud_sb_team[id]["banner_score"].color = color;
	level._hud_sb_team[id]["banner_score"] setValue(team_score);

	y += 12;

	level._hud_sb_team[id]["info_text"] = newHudElem();
	level._hud_sb_team[id]["info_text"].sort = 1;
	level._hud_sb_team[id]["info_text"].x = x + 16;
	level._hud_sb_team[id]["info_text"].y = y;
	level._hud_sb_team[id]["info_text"].fontScale = 0.75;
	level._hud_sb_team[id]["info_text"] setText(&"Total K&D");

	level._hud_sb_team[id]["info_score"] = newHudElem();
	level._hud_sb_team[id]["info_score"].sort = 1;
	level._hud_sb_team[id]["info_score"].x = x + 96;
	level._hud_sb_team[id]["info_score"].y = y ;
	level._hud_sb_team[id]["info_score"].alignX = "right";
	level._hud_sb_team[id]["info_score"].fontScale = 0.75;
	level._hud_sb_team[id]["info_score"] setValue(kills);

	level._hud_sb_team[id]["info_deaths"] = newHudElem();
	level._hud_sb_team[id]["info_deaths"].sort = 1;
	level._hud_sb_team[id]["info_deaths"].x = 640 - 2;
	level._hud_sb_team[id]["info_deaths"].y = y ;
	level._hud_sb_team[id]["info_deaths"].alignX = "right";
	level._hud_sb_team[id]["info_deaths"].fontScale = 0.75;
	level._hud_sb_team[id]["info_deaths"] setValue(deaths);

	y += 12;
	return y;
}

destroy_()
{
	level notify("_hud_sb_destroy");

	if (isDefined(level._hud_sb_header)) {
		level._hud_sb_header destroy();
	}
	if (isDefined(level._hud_sb_header_value)) {
		level._hud_sb_header_value destroy();
	}
	if (isDefined(level._hud_sb_background)) {
		level._hud_sb_background destroy();
	}

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (isDefined(players[i]._hud_sb_pointer)) {
			players[i]._hud_sb_pointer destroy();
		}
	}

	ids = [];
	ids[0] = "allies";
	ids[1] = "axis";
	for (i = 0; i < ids.size; i++) {
		if (isDefined(level._hud_sb_team[ids[i]]["banner"])) {
			level._hud_sb_team[ids[i]]["banner"] destroy();
		}
		if (isDefined(level._hud_sb_team[ids[i]]["banner_text"])) {
			level._hud_sb_team[ids[i]]["banner_text"] destroy();
		}
		if (isDefined(level._hud_sb_team[ids[i]]["banner_score"])) {
			level._hud_sb_team[ids[i]]["banner_score"] destroy();
		}
		if (isDefined(level._hud_sb_team[ids[i]]["info_text"])) {
			level._hud_sb_team[ids[i]]["info_text"] destroy();
		}
		if (isDefined(level._hud_sb_team[ids[i]]["info_score"])) {
			level._hud_sb_team[ids[i]]["info_score"] destroy();
		}
		if (isDefined(level._hud_sb_team[ids[i]]["info_deaths"])) {
			level._hud_sb_team[ids[i]]["info_deaths"] destroy();
		}
	}
}
