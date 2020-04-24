
/**///////////////////////////**/
/**/// ADD RULE FILES HERE ///**/
/**///////////////////////////**/
rules()
{
	// Every 'add' adds the specified rules to the mod.
	// The first part (in quotes) is the name one enters with 'pam_mode'.
	// The second part refers to the rule file without '.gsc' (but ending with '::cvars').
	// The same rule file might be added multiple times to make aliases.

	add("pub",    rules\wrs::cvars);
	add("public", rules\wrs::cvars); // alias

	add("wrs",    rules\wrs::cvars);
	add("walrus", rules\wrs::cvars);
}

/**///////////////////////////**/
/**///  DO NOT EDIT BELOW  ///**/
/**///////////////////////////**/
add(name, function)
{
	level.p_rules[name] = function;
}
