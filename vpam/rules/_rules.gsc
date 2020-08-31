
/**///////////////////////////**/
/**/// ADD RULE FILES HERE ///**/
/**///////////////////////////**/
rules()
{
	// Every 'add' adds the specified rules to the mod.
	// The first part (in quotes) is the name one enters with 'pam_mode'.
	// The second part refers to the rule file without '.gsc' (but ending with '::cvars').
	// A separate 'add_alias' can be used to create multiple names for the same mode.

	add("public", rules\public::cvars);
	add_alias("public", "pub");

	add("match", rules\match::cvars);

	add("match_aw", rules\match_aw::cvars);
	add_alias("match_aw", "aw");

	add("match_rifles", rules\match_rifles::cvars);
	add_alias("match_rifles", "rifles");
	add_alias("match_rifles", "ro");

	add("inferno_aw",     rules\inferno\aw::cvars);
	add("inferno_rifles", rules\inferno\rifles::cvars);

	add("vcodgg_match", rules\vcodgg\match::cvars);
	add_alias("vcodgg_match", "gg_match");

	add("euro_sd", rules\euro\sd::cvars);
}

/**///////////////////////////**/
/**///  DO NOT EDIT BELOW  ///**/
/**///////////////////////////**/
add(name, function)
{
	i = level.p_rules.size;
	level.p_rules[i]["function"] = function;
	level.p_rules[i]["names"] = [];
	level.p_rules[i]["names"][0] = name;
}
add_alias(name, alias)
{
	for (i = 0; i < level.p_rules.size; i++) {
		if (level.p_rules[i]["names"][0] == name) {
			level.p_rules[i]["names"][level.p_rules[i]["names"].size] = alias;
		}
	}
}
