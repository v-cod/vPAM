cvars()
{
	// Use rifles ruleset. But overwrite them below.
	rules\rifles::cvars();

	// LABEL
	game["p_istr_label_left"] = &"vCoD.gg Match";
	game["p_color"] = "^4";

	// MATCH
	setCvar("scr_sd_scorelimit", 0);
	setCvar("scr_sd_roundlimit", 20);

	setCvar("p_msg_1", "Welcome to the vcod^4.^3gg ^7cupserver^4.");
	setCvar("p_msg_2", "vcod^4.^3gg matchmod enabled^4.");
	setCvar("p_msg_3", "Please check Veritas is working^4: ^7/echo !info^4.");
	setCvar("p_msg_4", "Remember to /record^4, good luck and have fun^4!");


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
