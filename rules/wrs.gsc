cvars()
{
	// Labels
	game["leaguestring"] = &"walRus";
	game["pamstring"] = &"^7d^4`^9logics^4.";
	
	/*========================================================*/
	/* ============== Match Setup Options ====================*/
	/*========================================================*/
	setcvar("scr_count_draws", "0");		// Re-play rounds that end in a draw
	setcvar("scr_afs_time", "1.2");			// Anti fast shoot interval time (s)


	setcvar("scr_sd_roundlimit", "2");    // End map after this round.
	setcvar("scr_sd_roundlength", "2.5"); // Time length per round.
	setcvar("scr_sd_scorelimit", "0");    // Score limit per map.
	setcvar("scr_sd_timelimit", "0");     // Time limit per map.

	
	// Grace/Strat Period
	setcvar("scr_sd_graceperiod", "3");		// Grace Period
	setcvar("scr_strat_time", "1");			//Hold players still during Strat Time?


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


	//Snipers
	setcvar("scr_allow_springfield", "1");
	setcvar("scr_allow_kar98ksniper", "1");
	setcvar("scr_allow_nagantsniper", "1");
	setcvar("scr_allow_fg42", "1");


	//Rifles
	setcvar("scr_allow_enfield", "1");
	setcvar("scr_allow_kar98k", "1");
	setcvar("scr_allow_m1carbine", "1");
	setcvar("scr_allow_m1garand", "1");
	setcvar("scr_allow_nagant", "1");


	//SMGs
	setcvar("scr_allow_mp40", "1");
	setcvar("scr_allow_sten", "1");
	setcvar("scr_allow_thompson", "1");

	setcvar("scr_allow_bar", "1");
	setcvar("scr_allow_bren", "1");
	setcvar("scr_allow_mp44", "1");
	setcvar("scr_allow_ppsh", "1");

	//Rockets
	setcvar("scr_allow_panzerfaust", "1");

	//MG42
	setcvar("scr_allow_MG42", "1");
 

	//Pistols
	setcvar("scr_allow_pistol", "0");


	setcvar("sv_playersleft", "1");          // players left
	setcvar("p_round_restart_delay", "5");   // round warmup time
	setcvar("g_disableClientConsole", "0");  // disable client console


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
}
