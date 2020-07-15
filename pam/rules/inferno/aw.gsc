cvars()
{
	// Use aw ruleset. But overwrite them below.
	rules\match_aw::cvars();

	// LABEL
	game["p_istr_label_left"] = &"^9inferno ^7AW";
	game["p_color"] = "^9";

	setCvar("p_msg_1", "Welcome to ^9inferno^7's server");
}
