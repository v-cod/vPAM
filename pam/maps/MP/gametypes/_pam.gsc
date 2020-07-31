main()
{
	level.p_rules = [];
	rules\_rules::rules();

	if (!isDefined(game["gamestarted"])) {
		ruleset = getCvar("pam_mode");
		mode = _find_mode(ruleset);

		// Default to pub ruleset.
		if (!isDefined(mode)) {
			ruleset = "pub";
			setCvar("pam_mode", ruleset);
		}

		// Set cvars according to the ruleset.
		[[mode["function"]]]();
	}

	thread _watch_pam_mode();

	level._prefix = "PAM " + game["p_color"] + "# ^7";

	// Require prematch ready-up phase.
	level.p_ready = !!getCvarInt("p_ready");
	// Currently in ready-up phase.
	level.p_readying = false;
	// Ready-up phase succeeded.
	level.p_readied = false;

	// Freeze players during grace period.
	level.p_strat = getCvarInt("p_strat");
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

	level._anti_aimrun = !!getCvarInt("p_anti_aimrun");
	level._anti_fastshoot = !!getCvarInt("p_anti_fastshoot");
	level._anti_speeding = getCvarFloat("p_anti_speeding");

	level._afk_to_spec = false;
	level._fence = true;

	level._sprint = false;
	level._sprint_time = 0;
	level._sprint_time_recover = 0;

	level._jumper = false;

	level.p_round_restart_delay = getCvarInt("p_round_restart_delay");

	level._allow_pistol = !!getCvarInt("p_allow_pistol");
	level._allow_nades = !!getCvarInt("p_allow_nades");

	level.p_1s1k_rifle = !!getCvarInt("p_1s1k_rifle");
	level.p_1s1k_bash = !!getCvarInt("p_1s1k_bash");

	level.p_sniper_limit = getCvarInt("p_sniper_limit");

	level._allow_drop_sniper = !!getCvarInt("p_allow_drop_sniper");
	level._allow_drop = !!getCvarInt("p_allow_drop");

	level._nade_count_rifle = getCvarInt("p_nades_rifle");
	level._nade_count_smg = getCvarInt("p_nades_smg");
	level._nade_count_mg = getCvarInt("p_nades_mg");
	level._nade_count_sniper = getCvarInt("p_nades_sniper");

	level._force_autoscreenshots = !!getCvarInt("p_force_autoscreenshots");
	level._force_autodemo = !!getCvarInt("p_force_autodemo");

	level._bombtimer = !!getCvarInt("p_bombtimer");

	if (!isDefined(game["gamestarted"])) {
		game["_vote_map"] = !!getCvarInt("p_vote_map");
		if (game["_vote_map"]) {
			vote\main::precache();
			vote\map::precache();
		}

		game["_hud_alive"] = !!getCvarInt("p_hud_alive");
		game["_hud_hit_blip"] = !!getCvarInt("p_hitblip");
		hud::precache();

		// Scoreboard strings for SD.
		precacheString(&"MPSCRIPT_STARTING_NEW_ROUND");
		precacheString(&"MPSCRIPT_THE_GAME_IS_A_TIE");
		precacheString(&"MPSCRIPT_ALLIES_WIN");
		precacheString(&"MPSCRIPT_AXIS_WIN");
		hud\scoreboard::precache();

		_precache();

		// Weapon choice mechanism.
		// 0 for default.
		// 1 for picking a secondary weapon, optionally from specified allies.
		// 2 for fixed, pre-selected weapons.
		game["_weapons"] = 0;
		s = getCvar("p_weapons");
		if (s == "opponent") {
			game["_weapons"] = 1;
		} else if (s == "american" || s == "british" || s == "russian") {
			game["_weapons"] = 1;
			game["menu_weapon_allies"] = "weapon_" + s;
		} else if (s != "" && s != "0" && s != "default") {
			game["_weapons"] = 2;
			game["_weapons_arr"] = util::explode(s, " ", 0);
			for (i = 0; i < game["_weapons_arr"].size; i++) {
				game["_weapons_arr"][i] += "_mp";
			}
		}
		menu_weapon::precache();

		// Current or next half.
		game["p_half"] = 1;

		// Current or next overtime.
		game["p_overtime"] = 0;
	}

	if (isDefined(game["matchstarted"]) && game["matchstarted"]) {
		setClientNameMode("manual_change");
	} else {
		setClientNameMode("auto_change");
	}

	if (game["_hud_alive"]) {
		hud\alive::create();
	}

	// Ready up phase before match start.
	if (!game["matchstarted"] && level.p_ready) {
		maps\mp\gametypes\_pam_readyup::start_readying();
	}

	if(!getCvarInt("p_allow_mg42")) {
		maps\mp\gametypes\_teams::deletePlacedEntity("misc_mg42");
	}

	// thread hud\scoreboard::show(undefined, undefined);
}

_precache()
{
	// For respawning during ready-up.
	precacheString(&"Press [{+melee}] to respawn");

	if (!isDefined(game["p_istr_label_left"])) {
		game["p_istr_label_left"] = &"^1unknown";
	}

	if (!isDefined(game["p_istr_label_right"])) {
		game["p_istr_label_right"] = &"vPAM";
	}

	precacheString(game["p_istr_label_left"]);
	precacheString(game["p_istr_label_right"]);

	game["_hud_icon_ready"] = "gfx/hud/headicon@re_objcarrier.tga";
	precacheStatusIcon(game["_hud_icon_ready"]);
	precacheHeadIcon(game["_hud_icon_ready"]);

	game["overtimemode"] = &"Overtime";
	precacheString(game["overtimemode"]);

	game["_hud_halftime"] = &"Halftime";
	precacheString(game["_hud_halftime"]);

	// Ready-Up Plugin Requires:
	game["_ISTR_READYING"] = &"READYING";
	precacheString(game["_ISTR_READYING"]);

	game["_ISTR_STARTING"] = &"STARTING";
	precacheString(game["_ISTR_STARTING"]);

	game["_ISTR_PRESS_USE_TO_READY"] = &"Press [{+activate}] to ^2ready ^7up";
	precacheString(game["_ISTR_PRESS_USE_TO_READY"]);

	game["_ISTR_PRESS_USE_TO_UNDO_READY"] = &"Press [{+activate}] to ^1undo ^7ready up";
	precacheString(game["_ISTR_PRESS_USE_TO_UNDO_READY"]);

	game["_ISTR_WAITING_FOR_PLAYERS"] = &"Waiting on players: ^1";
	precacheString(game["_ISTR_WAITING_FOR_PLAYERS"]);
}

_watch_pam_mode()
{
	m = getCvar("pam_mode");

	while (true) {
		while (m == getCvar("pam_mode")) {
			wait 1;
		}

		m_new = getCvar("pam_mode");
		mode = _find_mode(m_new);

		if (!isDefined(mode)) {
			// Helpful printing of all modes (and their aliases) available.
			if (m_new == "?") {
				iPrintLn(level._prefix + "pam_mode values available" + game["p_color"] + ": ");
				for (i = 0; i < level.p_rules.size; i++) {
					name = level.p_rules[i]["names"][0];

					// Bit of mumbo-jumbo to get comma-separated values.
					aliases = "";
					if (isDefined(level.p_rules[i]["names"][1])) {
						aliases += level.p_rules[i]["names"][1];
					}
					for (j = 2; j < level.p_rules[i]["names"].size; j++) {
						aliases += ", " + level.p_rules[i]["names"][j];
					}
					if (aliases != "") {
						aliases = " (or: " + aliases + ")";
					}

					iPrintLn(level._prefix + name + aliases);
				}
			} else {
				iPrintLn(level._prefix + "^1Unknown mode: ^7" + m_new);
			}

			setCvar("pam_mode", m);
			continue;
		}

		// Set the mode to the primary name if an alias is used.
		if (m_new != mode["names"][0]) {
			setCvar("pam_mode", mode["names"][0]);
		}

		setCvar("sv_maprotationcurrent", "map " + getCvar("mapname"));
		exitLevel(false);
		return;
	}
}

_find_mode(name)
{
	for (i = 0; i < level.p_rules.size; i++) {
		for (j = 0; j < level.p_rules[i]["names"].size; j++) {
			if (level.p_rules[i]["names"][j] == name) {
				return level.p_rules[i];
			}
		}
	}
}

player_disconnected()
{
	wait 0; // Wait for possible disconnect of player.

	players = getEntArray("player", "classname");
	if (players.size > 2) {
		return;
	}

	history::reset();

	if (players.size > 0) {
		return;
	}
	
	exitLevel(false);
}
