// game["gamestarted"]
// game["matchstarted"]
// game["p_halftimeflag"]

main()
{
	// Require prematch ready-up phase.
	level.p_ready = true;
	// Currently in ready-up phase.
	level.p_readying = false;
	// Ready-up phase succeeded.
	level.p_readied = false;

	// Currently in strat time.
	level.p_stratting = false;

	// Overtime phase on tie.
	level.p_overtime = true;
	// Rounds played per overtime. (MUST be even.)
	level.p_overtime_roundlimit = 4;
	level.p_overtime_scorelimit = level.p_overtime_roundlimit / 2 + 1;

	if (!isDefined(game["gamestarted"])) {
		level.p_rules = [];
		rules\_rules::rules();

		ruleset = getCvar("pam_mode");

		if (isDefined(level.p_rules[ruleset])) {
			[[level.p_rules[ruleset]]]();
		} else {
			maps\mp\gametypes\_callbacksetup::AbortLevel();
			return;
		}

		_precache();
	}

	s = getCvar("p_weapons");
	level.p_weapons = 0;
	if (s == "secondary") {
		level.p_weapons = 1;
	} else if (s == "american" || s == "british" || s == "russian") {
		level.p_weapons = 1;
		game["menu_weapon_allies"] = "weapon_" + s;
	} else if (s != "" && s != "0" && s != "default") {
		level.p_weapons = 2;
		level.p_weapons_arr = explode(s, " ");
		for (i = 0; i < level.p_weapons_arr.size; i++) {
			level.p_weapons_arr[i] += "_mp";
		}
	}
	if (!isDefined(game["gamestarted"])) {
		if (level.p_weapons == 1) {
			precacheMenu(game["menu_weapon_allies"]);
			switch (getCvar("p_weapons")) {
			case "american":
				precacheItem("fraggrenade_mp");
				precacheItem("colt_mp");
				precacheItem("m1carbine_mp");
				precacheItem("m1garand_mp");
				precacheItem("thompson_mp");
				precacheItem("bar_mp");
				precacheItem("springfield_mp");
				break;
			case "british":
				precacheItem("mk1britishfrag_mp");
				precacheItem("colt_mp");
				precacheItem("enfield_mp");
				precacheItem("sten_mp");
				precacheItem("bren_mp");
				precacheItem("springfield_mp");
				break;
			case "russian":
				precacheItem("rgd-33russianfrag_mp");
				precacheItem("luger_mp");
				precacheItem("ppsh_mp");
				precacheItem("mosin_nagant_sniper_mp");
				break;
			}
		} else if (level.p_weapons == 2) {
			for (i = 0; i < level.p_weapons_arr.size; i++) {
				precacheItem(level.p_weapons_arr[i]);
			}
		}
	}

	// Ready up phase before match start.
	if (!game["matchstarted"] && level.p_ready) {
		maps\mp\gametypes\_pam_readyup::start_readying();
	}
	
	if (!isDefined(game["p_overtime"])) {
		// Currently in, or going to, overtime phase.
		game["p_overtime"] = 0;
	}

	if (!isDefined(game["p_halftimeflag"])) {
		game["p_halftimeflag"] = 0;
		game["round1alliesscore"] = 0;
		game["round1axisscore"] = 0; 
		game["round2alliesscore"] = 0;
		game["round2axisscore"] = 0;
	}

	// level.p_mode = "pam_mode";
	
	// // Show amount of alive players per team.
	// level.p_alive = "sv_playersleft";
	// level _register_cvar("alive", "bool", true, "sv_playersleft");
	
	// level.p_draw_rounds = "scr_count_draws";
	// level.p_antifs = "scr_afs_time";
	// level.p_allow_mg42 = "scr_allow_mg42";
	// level.p_allow_pistol = "scr_allow_pistol";
	// level.p_allow_nades = "scr_allow_nades";
	

	if(getCvar("pam_mode") == "")
		setCvar("pam_mode", "pub");

	if(getcvar("p_round_restart_delay") == "")
		setcvar("p_round_restart_delay", "5");

	if(getcvar("sv_playersleft") == "")
		setcvar("sv_playersleft", "1");


	/* Set up Level variables */
	level.league = getcvar("pam_mode");
	level.playersleft = getcvarint("sv_playersleft");
	level.countdraws = getcvarint("scr_count_draws");
	level.hithalftime = 0;
	level.afs_time = getcvarFloat("scr_afs_time");

	if (getcvar("scr_allow_pistol") == "") {
		setcvar("scr_allow_pistol", "0");
	}

	if (getcvar("scr_allow_nades") == "") {
		setcvar("scr_allow_nades", "0");
	}
}
explode(string, delimiter) {
	array = 0;
	result[array] = "";

	for (i = 0; i < string.size; i++) {
		if (string[i] == delimiter) {
			if (result[array] != "") {
				array++;
				result[array] = "";
			}
		} else {
			result[array] += string[i];
		}
	}

	if (result.size > 1 && result[array] == "") {
		result[array] = undefined;
	}
	return result;
}

_precache()
{
	precacheString(game["pamstring"]);

	// Logo
	if (!isdefined(game["leaguestring"]))
		game["leaguestring"] = &"Unknown Pam_Mode Error";
	precacheString(game["leaguestring"]);
	game["overtimemode"] = &"Overtime";
	precacheString(game["overtimemode"]);

	// Team Win Hud Elements
	game["team1win"] = &"Team 1 Wins!";
	precacheString(game["team1win"]);
	game["team2win"] = &"Team 2 Wins!";
	precacheString(game["team2win"]);
	game["dsptie"] = &"Its a TIE!";
	precacheString(game["dsptie"]);
	game["matchover"] = &"Match Over";
	precacheString(game["matchover"]);
	game["overtime"] = &"Going to OverTime";
	precacheString(game["overtime"]);

	game["halftime"] = &"Halftime";
	precacheString(game["halftime"]);

	//Round Starting Display
	game["round"] = &"Round";
	precacheString(game["round"]);
	game["starting"] = &"Starting";
	precacheString(game["starting"]);

	// Strat Time Announcement
	game["strattime"] = &"Strat Time";
	precacheString(game["strattime"]);

	//Teams Swithcing Announcement
	game["switching"] = &"Team Auto-Switch";
	precacheString(game["switching"]);	
	game["switching2"] = &"Please wait";
	precacheString(game["switching2"]);

	game["allready"] = &"All Players are Ready";
	precacheString(game["allready"]);
	game["start2ndhalf"] = &"Starting Second Half!";
	precacheString(game["start2ndhalf"]);
	game["start1sthalf"] = &"Starting the First Half!";
	precacheString(game["start1sthalf"]);

	//Half Starting Display
	game["first"] = &"First";
	precacheString(game["first"]);
	game["second"] = &"Second";
	precacheString(game["second"]);
	game["half"] = &"Half";
	precacheString(game["half"]);
	game["starting"] = &"Starting";
	precacheString(game["starting"]);

	// Ready-Up Plugin Requires:
	game["waiting"] = &"Ready-Up Mode";
	precacheString(game["waiting"]);
	game["waitingon"] = &"Waiting on:";
	precacheString(game["waitingon"]);
	game["playerstext"] = &"Players";
	precacheString(game["playerstext"]);
	game["status"] = &"Your Status";
	precacheString(game["status"]);
	game["ready"] = &"Ready";
	precacheString(game["ready"]);
	game["notready"] = &"Not Ready";
	precacheString(game["notready"]);
	game["headicon_carrier"] = "gfx/hud/headicon@re_objcarrier.tga";
	precacheStatusIcon(game["headicon_carrier"]);

	game["dspaxisleft"] = &"AXIS LEFT:";
	precacheString(game["dspaxisleft"]);		
	game["dspalliesleft"] = &"ALLIES LEFT:";
	precacheString(game["dspalliesleft"]);

	// Players Left Display		
	game["dspaxisleft"] = &"AXIS LEFT:";
	precacheString(game["dspaxisleft"]);		
	game["dspalliesleft"] = &"ALLIES LEFT:";
	precacheString(game["dspalliesleft"]);

	game["round"] = &"Round";
	precacheString(game["round"]);

	// Scoreboard Text
	game["dspteam1"] = &"TEAM 1";
	precacheString(game["dspteam1"]);
	game["dspteam2"] = &"TEAM 2";
	precacheString(game["dspteam2"]);
	game["scorebd"] = &"Scoreboard";
	precacheString(game["scorebd"]);
	game["1sthalf"] = &"1st Half";
	precacheString(game["1sthalf"]);	
	game["2ndhalf"] = &"2nd Half";
	precacheString(game["2ndhalf"]);
	game["matchscore2"] = &"Match";
	precacheString(game["matchscore2"]);

	//Clock
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");

	precacheShader("gfx/hud/hud@fire_ready.tga");
	precacheItem("mosin_nagant_mp");
	precacheItem("kar98k_mp");
}

// _cvar(cvar, type, def)
// {
// 	if (getCvar(cvar) == "") {
// 		return def;
// 	}

// 	switch (type) {
// 	case "bool":
// 		return !!getCvarInt(cvar);
// 	case "int":
// 		return getCvarInt(cvar);
// 	case "float":
// 		return getCvarFloat(cvar);
// 	default:
// 		return getCvar(cvar);
// 	}
// }

// _register_cvar(id, type, cvar)
// {
// 	level.p[id] = _cvar();
// }
