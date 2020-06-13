
/**///////////////////////////**/
/**/// ADD RULE FILES HERE ///**/
/**///////////////////////////**/
rules()
{
	// Every 'add' adds the specified rules to the mod.
	// The first part (in quotes) is the name one enters with 'pam_mode'.
	// The second part refers to the rule file without '.gsc' (but ending with '::cvars').
	// The same rule file might be added multiple times to make aliases.

	add("test", rules\_test::cvars);

	add("public", rules\public::cvars);
	add("pub",    rules\public::cvars); // alias

	add("match", rules\match::cvars);

	add("vcodgg_match", rules\vcodgg_match::cvars);
	add("gg_match",     rules\vcodgg_match::cvars); // alias

	add("rifles",     rules\rifles::cvars); // alias
	add("ro",         rules\rifles::cvars); // alias
}

/**///////////////////////////**/
/**///  DO NOT EDIT BELOW  ///**/
/**///////////////////////////**/
add(name, function)
{
	level.p_rules[name] = function;
}
