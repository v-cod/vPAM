main()
{
	game["pamstring"] = &"^7d^4`^9logics^4.";

    if(!isDefined(game["gamestarted"])) {
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
		game["dolive"] = "0";
		game["halftimeflag"] = "0";
		game["round1alliesscore"] = 0;
		game["round1axisscore"] = 0; 
		game["round2alliesscore"] = 0;
		game["round2axisscore"] = 0;
		game["DoReadyUp"] = false;
		game["checkingmatchstart"] = false;
	}

	level.warmup = 0;	// warmup time reset in case they restart map via menu

	if(getcvar("g_ot") == "")
		setcvar("g_ot", "0");

	if(getcvar("g_ot_active") == "")
		setcvar("g_ot_active", "0");

	if (getcvar( "g_allowtie" ) == "")
		setcvar("g_allowtie", "1");

	if(getCvar("pam_mode") == "")
		setCvar("pam_mode", "pub");

	if(getcvar("g_roundwarmuptime") == "")
		setcvar("g_roundwarmuptime", "5");

	if(getcvar("sv_playersleft") == "")
		setcvar("sv_playersleft", "1");


	/* Set up Level variables */
	level.ffire = getCvarInt("scr_friendlyfire");
	level.pure = getCvarInt("sv_pure");
	level.vote = getCvarInt("g_allowVote");
	level.faust = getcvarint("scr_allow_panzerfaust");
	level.fg42gun = getcvarint("scr_allow_fg42");
	level.league = getcvar("pam_mode");
	level.playersleft = getcvarint("sv_playersleft");
	level.halfround = getcvarint("scr_half_round");
	level.halfscore = getcvarint("scr_half_score");
	level.matchround = getcvarint("scr_end_round");
	level.matchscore1 = getcvarint("scr_end_score");
	level.matchscore2 = getcvarint("scr_end_half2score");
	level.countdraws = getcvarint("scr_count_draws");
	level.overtime = 0;	//Makes sure OT settings get loaded after defaults loaded
	level.ot_count = getcvarint("g_ot_count");
	level.hithalftime = 0;
	level.afs_time = getcvarFloat("scr_afs_time");

	level.instrattime = false;

	// Ready-Up
	level.rdyup = 0;
	level.R_U_Name = [];
	level.R_U_State = [];

	// WEAPON EXPLOIT FIX
	if(!isDefined(game["dropsecondweap"]))
		game["dropsecondweap"] = false;

	level.readyname = [];
	level.readystate = [];
	level.playersready = false;

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
		setcvar("scr_allow_pistol", "1");
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

    //Bomb Plant Announcement
    game["planted"] = &"";
    precacheString(game["planted"]);

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
    game["livemsg"] = &"LIVE!";
    precacheString(game["livemsg"]);

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