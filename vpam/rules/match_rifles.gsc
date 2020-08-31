cvars()
{
	// Use match ruleset. But overwrite them below.
	rules\match::cvars();

	// LABEL
	game["p_istr_label_left"] = &"match - rifles";

	// MATCH
	setCvar("scr_sd_scorelimit", 0);
	setCvar("scr_sd_roundlimit", 20);

	setCvar("p_msg_1", "");

	// STRAT
	setCvar("p_strat", 0);
	setCvar("scr_sd_graceperiod", 3);

	// MISC
	setCvar("p_anti_speeding", 1.06);

	setCvar("p_1s1k_rifle", true);
	setCvar("p_1s1k_bash", true);
	setCvar("p_hitblip", true);

	setCvar("p_bombtimer", true);

	// WEAPONS
	setCvar("p_sniper_limit", false);
	setCvar("p_allow_drop", false);

	setCvar("p_weapons", "mosin_nagant kar98k");

	setCvar("p_allow_pistol", false);
	setCvar("p_allow_nades", false);

	setCvar("p_allow_MG42", false);

	setCvar("scr_allow_bar", false);
	setCvar("scr_allow_bren", false);
	setCvar("scr_allow_enfield", false);
	setCvar("scr_allow_fg42", false);
	setCvar("scr_allow_kar98k", true);
	setCvar("scr_allow_kar98ksniper", false);
	setCvar("scr_allow_m1carbine", false);
	setCvar("scr_allow_m1garand", false);
	setCvar("scr_allow_mp40", false);
	setCvar("scr_allow_mp44", false);
	setCvar("scr_allow_nagant", true);
	setCvar("scr_allow_nagantsniper", false);
	setCvar("scr_allow_panzerfaust", false);
	setCvar("scr_allow_ppsh", false);
	setCvar("scr_allow_springfield", false);
	setCvar("scr_allow_sten", false);
	setCvar("scr_allow_thompson", false);

	// TIMEOUTS
	setcvar("g_timeoutsAllowed", true);
	setcvar("g_timeoutLength",  300000);
	setcvar("g_timeoutRecovery", 10000);
	setcvar("g_timeoutBank",    600000);

	// STOCK
	setCvar("scr_teambalance", false);
	setCvar("scr_friendlyfire", false);
}
