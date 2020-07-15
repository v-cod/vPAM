cvars()
{
	// Use match ruleset. But overwrite them below.
	rules\match::cvars();

	// LABEL
	game["p_istr_label_left"] = &"match - all weapons";

	// WEAPONS
	setCvar("p_weapons", "default");
	setCvar("p_allow_pistol", true);
	setCvar("p_allow_nades", true);
	setCvar("p_allow_MG42", true);
	setCvar("scr_allow_fg42", false);

	setCvar("p_sniper_limit", 1);
	setCvar("p_allow_drop", true);
	setCvar("p_allow_drop_sniper", false);

	setCvar("p_nades_rifle", 2);
	setCvar("p_nades_smg", 1);
	setCvar("p_nades_mg", 1);
	setCvar("p_nades_sniper", 1);

	// STRAT
	setCvar("p_strat", 8);
	setCvar("scr_sd_graceperiod", 0);

	// STOCK
	setCvar("scr_friendlyfire", 1);
}
