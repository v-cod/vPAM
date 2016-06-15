main()
{
	game["allies"] = "british";
	game["axis"] = "german";
	
	game["british_soldiertype"] = "commando";
	game["british_soldiervariation"] = "normal";
	game["german_soldiertype"] = "waffen";
	game["german_soldiervariation"] = "normal";
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	
	game["layoutimage"] = "wawa_10daim";

	thread wawa_SpawnWeapons();
}

wawa_SpawnWeapons()
{
	for(i = 0; i < level.weaponName.size; i++)
		weapons[i] = getEntArray(level.weaponName[i], "classname");

	for(j = 0; j < weapons.size; i++)
	{
		for(i = 0; i < weapons[j].size; i++)
			weapons[j][i] delete();
	wait .05;
	}

	for(i = 0; i < 3; i++)
		if(isDefined(level.weapons[i]))
		{
			level.weapons[i] delete();
			level.weapons[i] = undefined;
		}

	for(i = 0; i < 3; i++)
	{
		level.weapons[i] = spawn(level.weaponName[i], level.weaponPlaces[i]);
		if(i == 0)
			level.weapons[i].angles = (0, 270, 0);
	}
}