cvars()
{
	// Use rifles ruleset. But overwrite them below.
	rules\match_rifles::cvars();

	// LABEL
	game["p_istr_label_left"] = &"^9inferno ^7Rifles";
	game["p_color"] = "^9";

	setCvar("p_msg_1", "Welcome to ^9inferno^7's server");

	// STRAT
	setCvar("p_strat", 5);
	setCvar("scr_sd_graceperiod", 0);

	// MISC
	setCvar("p_anti_speeding", false);
}
