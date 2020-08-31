cvars()
{
	// Use default ruleset. But overwrite them below.
	rules\default::cvars();

	// LABEL
	game["p_istr_label_left"] = &"match";

	// MATCH
	setCvar("scr_sd_scorelimit", 0);
	setCvar("scr_sd_roundlimit", 20);

	setCvar("p_ready", true);
	setCvar("p_msg_1", "");

	// WEAPONS
	setCvar("p_weapons", "default");
	setCvar("p_allow_pistol", true);
	setCvar("p_allow_nades", true);
	setCvar("p_allow_MG42", true);
	setCvar("scr_allow_fg42", false);
	setCvar("scr_allow_panzerfaust", false);

	setCvar("p_sniper_limit", 1);
	setCvar("p_allow_drop", true);
	setCvar("p_allow_drop_sniper", false);

	// STRAT
	setCvar("p_strat", 5);
	setCvar("scr_sd_graceperiod", 0);

	// TIMEOUTS
	setcvar("g_timeoutsAllowed", true);
	setcvar("g_timeoutLength",  300000);
	setcvar("g_timeoutRecovery", 10000);
	setcvar("g_timeoutBank",    600000);

	// STOCK
	setCvar("scr_teambalance", false);
	setCvar("scr_killcam", false);
	setCvar("scr_friendlyfire", 1);
}
