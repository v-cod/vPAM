cvars()
{
	// Build from the default ruleset. Overwrite values below.
	rules\default::cvars();


	// LABEL
	game["p_istr_label_left"] = &"public";


	// MATCH
	setCvar("scr_sd_scorelimit", 11); // First to 11.
	setCvar("scr_sd_roundlimit", 20); // Tie match if 10-10.

	setCvar("p_bombtimer", true);


	// WEAPONS
	setCvar("p_weapons", "opponent"); // Pick weapon from enemy team.
	setCvar("p_allow_pistol", true);
	setCvar("p_allow_nades", false); // No chaos.
	setCvar("p_allow_MG42", true);
	setCvar("scr_allow_fg42", true);

	// STOCK
	setCvar("scr_teambalance", true);
}
