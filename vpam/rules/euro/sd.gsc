cvars()
{
	// Use public ruleset. But overwrite them below.
	rules\match_rifles::cvars();

	// LABEL
	game["p_istr_label_left"] = &"^4E^3U^4R^3O ^1S&D";
	game["p_color"] = "^4";

	// MATCH
	setCvar("scr_sd_scorelimit", 10); // First to 10.
	setCvar("scr_sd_roundlimit", 0);

	setCvar("p_ready", false);

	// WEAPONS
	setCvar("p_weapons", "russian");
	setCvar("scr_allow_enfield", true);
	setCvar("scr_allow_kar98k", true);
	setCvar("scr_allow_kar98ksniper", true);
	setCvar("scr_allow_nagant", true);
	setCvar("scr_allow_nagantsniper", true);
	setCvar("scr_allow_springfield", true);

	// STRAT
	setCvar("p_strat", 0); // Disable.
	setCvar("scr_sd_graceperiod", 15); // Default.

	// TIMEOUTS
	setcvar("g_timeoutsAllowed", false); // Disable.

	// STOCK
	setCvar("scr_teambalance", 1);
	setCvar("scr_killcam", true);
	setCvar("scr_friendlyfire", false);
}
