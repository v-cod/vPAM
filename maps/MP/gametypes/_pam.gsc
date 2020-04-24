main()
{
	game["pamstring"] = &"^7d^4`^9logics^4.";

	if (!isDefined(game["gamestarted"])) {
		precache();

		ruleset = getCvar("pam_mode");

		switch(ruleset)
		{
		case "wrs":
			thread maps\mp\gametypes\rules\_wrs_rules::LeagueRules();
			break;
		case "dlogics_matchmod":
			thread maps\mp\gametypes\rules\_dlogics_matchmod_rules::LeagueRules();
			break;
		case "dlogics_nightmod":
			thread maps\mp\gametypes\rules\_dlogics_nightmod_rules::LeagueRules();
			break;
		case "cb_rifles":
			thread maps\mp\gametypes\rules\_cb_rifles_rules::LeagueRules();
			break;
		case "cb_2v2":
			thread maps\mp\gametypes\rules\_cb_2v2oc_rules::LeagueRules();
			break;
		case "pub":
			thread maps\mp\gametypes\rules\_public_rules::LeagueRules();
			break;

		default:
			thread maps\mp\gametypes\rules\_public_rules::LeagueRules();
			setCvar("pam_mode", "pub");
			break;
		}

		if(!isDefined(game["mode"]))
			game["mode"] = "match";
    }

    level.gametype = getCvar("g_gametype");

	if(!isDefined(game["halftimeflag"])) {
		game["halftimeflag"] = 0;
		game["round1alliesscore"] = 0;
		game["round1axisscore"] = 0; 
		game["round2alliesscore"] = 0;
		game["round2axisscore"] = 0;
		game["checkingmatchstart"] = false;
	}

	if(getCvar("pam_mode") == "")
		setCvar("pam_mode", "pub");

	if(getcvar("g_roundwarmuptime") == "")
		setcvar("g_roundwarmuptime", "5");

	if(getcvar("sv_playersleft") == "")
		setcvar("sv_playersleft", "1");


	/* Set up Level variables */
	level.league = getcvar("pam_mode");
	level.playersleft = getcvarint("sv_playersleft");
	level.countdraws = getcvarint("scr_count_draws");
	level.hithalftime = 0;
	level.afs_time = getcvarFloat("scr_afs_time");

	level.instrattime = false;

	// Ready up phase before half start.
	level.p_readying = false;

	level.allow_mg42 = getCvar("scr_allow_mg42");
	if(level.allow_mg42 == "")
		level.allow_mg42 = "1";
	setCvar("scr_allow_mg42", level.allow_mg42);
	setCvar("ui_allow_mg42", level.allow_mg42);
	makeCvarServerInfo("ui_allow_mg42", level.allow_mg42);
	if(level.allow_mg42 != "1") {
		maps\mp\gametypes\_teams::deletePlacedEntity("misc_mg42");
	}

	if (getcvar("scr_allow_pistol") == "") {
		setcvar("scr_allow_pistol", "0");
	}

	if (getcvar("scr_allow_nades") == "") {
		setcvar("scr_allow_nades", "0");
	}

	// Fix _teams.gsc bug removing wrong entity.
	if(level.allow_kar98ksniper != "1") {
		maps\mp\gametypes\_teams::deletePlacedEntity("mpweapon_kar98k_scoped");
	}
}

precache()
{
    precacheString(game["pamstring"]);

    // Logo
    if (!isdefined(game["leaguestring"]))
        game["leaguestring"] = &"Unknown Pam_Mode Error";
    precacheString(game["leaguestring"]);

    // Team Win Hud Elements
    game["team1win"] = &"Team 1 Wins!";
    precacheString(game["team1win"]);
    game["team2win"] = &"Team 2 Wins!";
    precacheString(game["team2win"]);
    game["dsptie"] = &"Its a TIE!";
    precacheString(game["dsptie"]);
    game["matchover"] = &"Match Over";
    precacheString(game["matchover"]);

    game["halftime"] = &"Halftime";
    precacheString(game["halftime"]);

    //Round Starting Display
    game["round"] = &"Round";
    precacheString(game["round"]);
    game["starting"] = &"Starting";
    precacheString(game["starting"]);

    // Time Expired Announcement
    game["timeexp"] = &"Time Expired";
    precacheString(game["timeexp"]);

    // Strat Time Announcement
    game["strattime"] = &"Strat Time";
    precacheString(game["strattime"]);

    //Teams Swithcing Announcement
    game["switching"] = &"Team Auto-Switch";
    precacheString(game["switching"]);	
    game["switching2"] = &"Please wait";
    precacheString(game["switching2"]);

    game["startingin"] = &"Starting In";
    precacheString(game["startingin"]);		
    game["matchstarting"] = &"Match Starting In";
    precacheString(game["matchstarting"]);	
    game["matchresuming"] = &"Match Resuming In";
    precacheString(game["matchresuming"]);	
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
    game["startingin"] = &"Starting In";
    precacheString(game["startingin"]);		
    game["matchstarting"] = &"Match Starting In";
    precacheString(game["matchstarting"]);

    game["matchresuming"] = &"Match Resuming In";
    precacheString(game["matchresuming"]);

    // Scoreboard Text
    game["dspteam1"] = &"TEAM 1";
    precacheString(game["dspteam1"]);
    game["dspteam2"] = &"TEAM 2";
    precacheString(game["dspteam2"]);
    game["scorebd"] = &"Scoreboard";
    precacheString(game["scorebd"]);
    game["dspaxisscore"] = &"AXIS SCORE";
    precacheString(game["dspaxisscore"]);		
    game["dspalliesscore"] = &"ALLIES SCORE";
    precacheString(game["dspalliesscore"]);
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

// cvar(cvar, def, min, max, type)
// {
// 	if (getCvar(cvar) == "") {
// 		return def;
// 	}

// 	switch (type) {
// 	case "int":
// 		v = getCvarInt(cvar);
// 		break;
// 	case "float":
// 		v = getCvarFloat(cvar);
// 		break;
// 	case "array":
// 		return maps\mp\gametypes\_wrs_admin::explode(" ", getCvar(cvar), 0);
// 	case "string":
// 	default:
// 		return getCvar(cvar);
// 	}

// 	if (type == "int" || type == "float") {
// 		if (v > max) {
// 			v = max;
// 		} else if (v < min) {
// 			v = min;
// 		}
// 	}
// 	return v;
// }

