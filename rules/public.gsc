cvars()
{
	// Build from the basic ruleset. Overwrite values below.
	rules\basic::cvars();


	// LABEL
	game["leaguestring"] = &"public";


	// MATCH
	setCvar("scr_sd_scorelimit", 7); // Team to reach this score wins.
	setCvar("scr_sd_roundlimit", 12); // Tie match if 6-6.


	// WEAPONS
	setCvar("p_weapons", "opponent"); // Pick weapon from enemy team.
	setCvar("p_allow_pistol", true);
	setCvar("p_allow_nades", false); // No chaos.
	setCvar("p_allow_MG42", true);
	setCvar("scr_allow_fg42", true);


	// STOCK
	setCvar("scr_teambalance", true);
}
