cvars()
{
	// Use rifles ruleset. But overwrite them below.
	rules\rifles::cvars();

	// LABEL
	game["p_istr_label_left"] = &"vcod^4.^3gg ^7matchmod";
	game["p_color"] = "^4";

	// MATCH
	setCvar("scr_sd_scorelimit", 0);
	setCvar("scr_sd_roundlimit", 20);

	setCvar("p_msg_1", "Welcome to the vcod^4.^3gg ^7cupserver^4.");
	setCvar("p_msg_2", "vcod^4.^3gg ^7matchmod enabled^4.");
	setCvar("p_msg_3", " "); // Pause.
	setCvar("p_msg_4", "Please check Veritas AC is working^4: ^7/echo !info^4.");
	setCvar("p_msg_5", "Remember to /record^4, ^7good luck and have fun^4!");
	setCvar("p_msg_6", " "); // Pause.

	setCvar("p_msg_halftime_1", "Please check Veritas AC is working^4: ^7/echo !info^4.");
	setCvar("p_msg_halftime_2", "Ready up to begin the second half^4.");
	setCvar("p_msg_halftime_3", ""); // Pause.

	// STRAT
	setCvar("p_strat", true);
	setCvar("scr_sd_graceperiod", 10);

	// TIMEOUTS
	setcvar("g_timeoutsAllowed", true);
	setcvar("g_timeoutLength",  300000);
	setcvar("g_timeoutRecovery", 10000);
	setcvar("g_timeoutBank",    600000);

	// STOCK
	setCvar("scr_teambalance", false);
}
