LeagueRules()
{
	/* Common Settings - put your pub settings here */
 
	if (getcvar("scr_half_round") == "") 
		setcvar("scr_half_round" , "6");	// Switch AFTER this round. 

	if (getcvar("scr_half_score") == "") 
		setcvar("scr_half_score" , "0");	// Switch AFTER this score. 

	if (getcvar("scr_end_round") == "") 
		setcvar("scr_end_round" , "12"); 	// End Map AFTER this round. 

	if (getcvar("scr_end_score") == "0") 
		setcvar("scr_end_score" , "0");		// End Map AFTER this total score. 

	if (getcvar("scr_end_half2score") == "") 
		setcvar("scr_end_half2score" , "0"); 	// End Map AFTER this 2nd-half score. 

	if (getcvar("scr_count_draws") == "") 
		setcvar("scr_count_draws", "1"); 	// Re-play rounds that end in a draw 

	if (getcvar("scr_force_bolt_rifles") == "") 
		setcvar("scr_force_bolt_rifles", "0");
	setcvar("scr_afs_time", "1.2");			// Anti fast shoot interval time (s)

	if (getcvar("g_roundwarmuptime") == "")
		setcvar("g_roundwarmuptime", "3");

	if(getCvar("sv_playersleft") == "")
		setCvar("sv_playersleft", "1");

	if(getCvar("sv_scoreboard") == "")
		setcvar("sv_scoreboard", "small");

	if (getcvar("scr_rifle_nade_count") == "")
		setcvar("scr_rifle_nade_count", "3");
	if (getcvar("scr_smg_nade_count") == "")
		setcvar("scr_smg_nade_count", "2");
	if (getcvar("scr_mg_nade_count") == "")
		setcvar("scr_mg_nade_count", "2");
	if (getcvar("scr_sniper_nade_count") == "")
		setcvar("scr_sniper_nade_count", "1");

	setcvar("g_autodemo", "0");				// turns off autodemos
	setcvar("g_autoscreenshot", "0");		// turns off autoscreenshot	
	setcvar("g_timeoutsAllowed", "0");		// number of timeouts per side	
	setcvar("g_timeoutLength", "90000");	// length of timeouts
	setcvar("g_timeoutRecovery", "10000");	// counter before match resumes
	setcvar("g_timeoutBank", "180000");		// timeout bank
	setcvar("g_disableClientConsole", "0");	// disable client console
	setcvar("scr_strat_time", "0");			// Changes Grace Period to Hold players still


	//no overtimes in pub mode - so changing to pub mode will get you out of ot mode from a match
	setcvar("g_ot", "0"); 			// no overtime in pub mode
	setcvar("g_allowtie" , "0");	// allow tie after 1st overtime, 0 no ties, 1 allow tie after 1 ot
	setcvar("g_ot_active", "0");	// Make sure we get out of any OT mode we were in when we go to PUB

	/* Do NOT Touch These */
	game["leaguestring"] = &"Pub Mode";
	game["mode"] = "pub";
}
