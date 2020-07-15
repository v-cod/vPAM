_local()
{
	var["header"] = &"Sprint                                 Votes";
	var["options"][0] = &"Disable sprint";
	var["options"][1] = &"Enable sprint";

	return var;
}

precache()
{
	var = _local();
	
	precacheString(var["header"]);
	for (i = 0; i < var["options"].size; i++) {
		precacheString(var["options"][i]);
	}
}

vote(time)
{
	var = _local();

	return vote\main::vote(time, var["header"], var["options"]);
}
