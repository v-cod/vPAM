cvars()
{
	// Use match ruleset. But overwrite them below.
	rules\match::cvars();

	// LABEL
	game["p_istr_label_left"] = &"vCoD.gg Match";

	// MATCH
	setCvar("scr_sd_scorelimit", 0);
	setCvar("scr_sd_roundlimit", 20);

	setCvar("p_msg_1", "Welcome to vCoD.gg match.");
	setCvar("p_msg_2", "I wish you the very best with killing.");
	setCvar("p_msg_3", "Don't whine too much about this mod.");
	setCvar("p_msg_4", "And be happy.");

	// WEAPONS
	setCvar("p_weapons", "mosin_nagant kar98k"); // Rifles only.
	setCvar("p_allow_pistol", false); // Rifles only.
	setCvar("p_allow_nades", false); // Rifles only.
	setCvar("p_allow_MG42", false); // Rifles only.
	setCvar("scr_allow_fg42", false); // Rifles only.

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
