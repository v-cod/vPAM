main()
{
	level.p_rules = [];
	rules\_rules::rules();

	if (!isDefined(game["gamestarted"])) {

		ruleset = getCvar("pam_mode");

		if (!isDefined(level.p_rules[ruleset])) {
			ruleset = "pub";
			setCvar("pam_mode", ruleset);
		}

		[[level.p_rules[ruleset]]]();
	}

	thread _watch_pam_mode();

	level.p_color = game["p_color"];
	level.p_prefix = "PAM " + level.p_color + "# ^7";

	// Require prematch ready-up phase.
	level.p_ready = !!getCvarInt("p_ready");
	// Currently in ready-up phase.
	level.p_readying = false;
	// Ready-up phase succeeded.
	level.p_readied = false;

	// Freeze players during grace period.
	level.p_strat = !!getCvarInt("p_strat");
	// Currently in strat time.
	level.p_stratting = false;

	// Overtime phase on tie.
	level.p_overtime = !!getCvarInt("p_overtime_on_tie");
	// Rounds played per overtime. (MUST be even.)
	level.p_overtime_roundlimit = getCvarInt("p_overtime_roundlimit");
	level.p_overtime_scorelimit = level.p_overtime_roundlimit / 2 + 1;

	// Only allow melee damage.
	level.p_bash = !!getCvarInt("p_bash");

	level.p_replay_draw = !!getCvarInt("p_replay_draw");
	level.p_hud_alive = !!getCvarInt("p_hud_alive");

	level.p_anti_aimrun = !!getCvarInt("p_anti_aimrun");
	level.p_anti_fastshoot = getCvarFloat("p_anti_fastshoot");
	level.p_anti_speeding = getCvarFloat("p_anti_speeding");

	level.p_round_restart_delay = getCvarInt("p_round_restart_delay");

	level.p_allow_pistol = !!getCvarInt("p_allow_pistol");
	level.p_allow_nades = !!getCvarInt("p_allow_nades");

	// Weapon choice mechanism.
	// 0 for default.
	// 1 for picking a secondary weapon, optionally from specified allies.
	// 2 for fixed, pre-selected weapons.
	level.p_weapons = 0;
	s = getCvar("p_weapons");
	if (s == "opponent") {
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
		_precache();

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

		// Current or next half.
		game["p_half"] = 1;

		// Current or next overtime.
		game["p_overtime"] = 0;

		game["round1alliesscore"] = 0;
		game["round1axisscore"] = 0; 
		game["round2alliesscore"] = 0;
		game["round2axisscore"] = 0;
	}

	// Ready up phase before match start.
	if (!game["matchstarted"] && level.p_ready) {
		maps\mp\gametypes\_pam_readyup::start_readying();
	}

	if(!getCvarInt("p_allow_mg42")) {
		maps\mp\gametypes\_teams::deletePlacedEntity("misc_mg42");
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
	if (!isDefined(game["p_istr_label_left"])) {
		game["p_istr_label_left"] = &"^1unknown";
	}

	if (!isDefined(game["p_istr_label_right"])) {
		game["p_istr_label_right"] = &"vPAM";
	}

	precacheString(game["p_istr_label_left"]);
	precacheString(game["p_istr_label_right"]);

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
	game["p_hud_half_1"] = &"First";
	precacheString(game["p_hud_half_1"]);
	game["p_hud_half_2"] = &"Second";
	precacheString(game["p_hud_half_2"]);
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
}

_watch_pam_mode()
{
	m = getCvar("pam_mode");

	while (true) {
		while (m == getCvar("pam_mode")) {
			wait 1;
		}
		
		m_new = getCvar("pam_mode");
		if (!isDefined(level.p_rules[m_new])) {
			iPrintLn(level.p_prefix +  "^1Unknown mode: ^7" + m_new);

			setCvar("pam_mode", m);
			continue;
		}

		setCvar("sv_maprotationcurrent", "map " + getCvar("mapname"));
		exitLevel(false);
		return;
	}
}
