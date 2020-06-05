cvars()
{
	// Use public ruleset. But overwrite them below.
	rules\public::cvars();

	// LABEL
	game["p_istr_label_left"] = &"match";

	// MATCH
	setCvar("scr_sd_scorelimit", 11);
	setCvar("scr_sd_roundlimit", 20);

	setCvar("p_ready", true);
	setCvar("p_msg_1", "Be civil.");

	// WEAPONS
	setCvar("p_allow_MG42", false);
	setCvar("p_allow_pistol", true);
	setCvar("p_allow_nades", true);
	setCvar("scr_allow_fg42", false);

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
