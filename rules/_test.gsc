cvars()
{
	// Use match ruleset. But overwrite them below.
	rules\match::cvars();

	// LABEL
	game["p_istr_label_left"] = &"Test";

	// MATCH
	setCvar("scr_sd_scorelimit", 0);
	setCvar("scr_sd_roundlimit", 4);

	setCvar("p_overtime_on_tie", true);
	setCvar("p_overtime_roundlimit", 4);

	setCvar("p_msg_1", "Test match.");

	// WEAPONS
	setCvar("p_weapons", "opponent");
	setCvar("p_allow_pistol", true);
	setCvar("p_allow_nades", true);
	setCvar("p_allow_MG42", true);
	setCvar("scr_allow_fg42", true);

	// STRAT
	setCvar("p_strat", true);
	setCvar("scr_sd_graceperiod", 3);

	// TIMEOUTS
	setcvar("g_timeoutsAllowed", true);
	setcvar("g_timeoutLength",  300000);
	setcvar("g_timeoutRecovery", 10000);
	setcvar("g_timeoutBank",    600000);

	// STOCK
	setCvar("scr_teambalance", false);
}
