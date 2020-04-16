LeagueRules()
{
	// Logo
	game["leaguestring"] = &"^7ClanBase Rifles Mode";

	
	/*========================================================*/
	/* ============== Match Setup Options ====================*/
	/*========================================================*/
	setcvar("scr_half_round" , "10");		// Switch AFTER this round.
	setcvar("scr_half_score" , "0");		// Switch AFTER this score.
	setcvar("scr_end_round" , "20");		// End Map AFTER this round.
	setcvar("scr_end_score" , "0");		// End Map AFTER this total score.
	setcvar("scr_end_half2score" , "0");	// End Map AFTER this 2nd-half score.
	setcvar("scr_count_draws", "0");		// Re-play rounds that end in a draw
	setcvar("g_ot", "0");					// overtime off/on
	setcvar("scr_afs_time", "1.2");			// Anti fast shoot interval time (s)

	//OT Settings
	setcvar("g_ot_active", "0");			// NEVER OT in this mode


	/* S&D STOCK Settings */
	setcvar("scr_sd_scorelimit", "0");			// Score limit per map
	setcvar("scr_sd_roundlimit", "0");			// Round limit per map
	setcvar("scr_sd_roundlength", "1.5");			// Time length of each round
	setcvar("scr_sd_timelimit", "0");			// Time limit per map

	
	// Grace/Strat Period
	setcvar("scr_sd_graceperiod", "3");		// Grace Period
	setcvar("scr_strat_time", "0");			//Hold players still during Strat Time?


	// Allow Voting 
	setcvar("g_allowvote" , "0");
	setcvar("g_allowvotetempbanuser" , "0");
	setcvar("g_allowvotetempbanclient" , "0");
	setcvar("g_allowvotekick" , "0");
	setcvar("g_allowvoteclientkick" , "0");
	setcvar("g_allowvotegametype" , "0");
	setcvar("g_allowvotetypemap" , "0");
	setcvar("g_allowvotemap" , "0");
	setcvar("g_allowvotemaprotate" , "0");
	setcvar("g_allowvotemaprestart" , "0");


	// Timeouts
	setcvar("g_timeoutsAllowed", "1");			// number of timeouts per side	
	setcvar("g_timeoutLength", "300000");		// length of timeouts
	setcvar("g_timeoutRecovery", "10000");	// counter before match resumes
	setcvar("g_timeoutBank", "600000");		// timeout bank



	/*========================================================*/
	/* ============== Weapon Setup Options ===================*/
	/*========================================================*/

	//Force Bolt-Action Rifles Only
	setcvar("scr_force_bolt_rifles", "1");


	// Snipers
	setcvar("scr_allow_springfield", "0");
	setcvar("scr_allow_kar98ksniper", "0");
	setcvar("scr_allow_nagantsniper", "0");
	setcvar("scr_allow_fg42", "0");


	//Rifles
	setcvar("scr_allow_enfield", "1");
	setcvar("scr_allow_kar98k", "1");
	setcvar("scr_allow_m1carbine", "0");
	setcvar("scr_allow_m1garand", "1");
	setcvar("scr_allow_nagant", "1");


	//SMGs
	setcvar("scr_allow_mp40", "0");
	setcvar("scr_allow_sten", "0");
	setcvar("scr_allow_thompson", "0");

	setcvar("scr_allow_bar", "0");
	setcvar("scr_allow_bren", "0");
	setcvar("scr_allow_mp44", "0");
	setcvar("scr_allow_ppsh", "0");
	setcvar("scr_allow_stielhandgranate", "0");
	setcvar("scr_allow_rgd-33russianfrag", "0");
	setcvar("scr_allow_mk1britishfrag", "0");
	setcvar("scr_allow_fraggrenade", "0");



	//Rockets
	setcvar("scr_allow_panzerfaust", "0");


	//MG42
	setcvar("scr_allow_MG42", "0");
	setcvar("scr_allow_MG34", "0");


	//Nade Spawn Ammo Settings
	setcvar("scr_rifle_nade_count", "0");
	setcvar("scr_smg_nade_count", "0");
	setcvar("scr_mg_nade_count", "0");
	setcvar("scr_sniper_nade_count", "0");
     setcvar("scr_allow_fraggrenade_mp", "0");
	setcvar("scr_allow_mk1britishfrag_mp", "0");
	setcvar("scr_allow_rgd-33russianfrag_mp", "0");
	setcvar("scr_allow_stielhandgranate_mp", "0");
 

	//Pistols
	setcvar("scr_allow_pistol", "0");



	/*========================================================*/
	/* ================== PAM Options ========================*/
	/*========================================================*/

	/* HUD Items */
	setcvar("sv_scoreboard", "big");			// Use BIG Scoreboard
	setcvar("sv_playersleft", "1");				// players left


	// Timers
	setcvar("g_roundwarmuptime", "5");			// round warmup time

	// Warm-up Mines
	setcvar("sv_warmupmines", "0"); //Leave this on for now. Mines need to be re-worked.

	//Auto Screenshots / Console
	setcvar("g_autoscreenshot", "1");			// turns on autoscreenshot
	setcvar("g_disableClientConsole", "0");		// disable client console


	// PAM Sounds	
	setcvar("sv_pamsounds", "0");		// pamsounds


	/* NOT Likely to ever change */
	setcvar("scr_friendlyfire", "0");	// Friendly fire
	setcvar("scr_drawfriend", "1");		// Draws a team icon over teammates
	setCvar("scr_killcam", "0");		// Kill Cam OFF
	setCvar("scr_teambalance", "0");	// Team Balance OFF
	setcvar("scr_freelook", "0");		// Free Spectate OFF
	setcvar("scr_spectateenemy", "0");	// Spectate Enemy OFF
	setcvar("sv_minPing", "0");			// No Minimum Ping	
	setcvar("sv_maxPing", "0");			// No Maximum Ping
	setcvar("sv_pure", "1");			// SV_Pure is ON
	setcvar("sv_cheats", "0");			// Cheats? Oh no!
	setcvar("g_speed", "190");			// Player Speed
	setcvar("g_gravity", "800");		// Cheats? Oh no!
	setcvar("g_deadchat", "1");			// Dead Speak to Living
	setcvar("g_maxDroppedWeapons", "16");	// Max weapons allowed laying around
	setcvar("g_weaponrespawn", "5");	// How long before spawned weapons respawn


	/* Do NOT Touch These */
	game["mode"] = "match";
}
