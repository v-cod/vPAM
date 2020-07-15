insert_spawns_if_not_supported()
{
	mapname = getCvar("mapname"); 
	
	if (mapname == "mp_ship") {
		bombtrigger = spawn("script_origin", (10000, 64, -64));
		bombtrigger.targetname = "bombtrigger";
		bombtrigger.squaredradius = 64 * 64;

		bombzone_A = spawn("script_origin", (3540, 64, 830));
		bombzone_A.targetname = "bombzone_A";
		bombzone_A.squaredradius = 128 * 128;

		bombzone_B = spawn("script_origin", (4160, 664, 55));
		bombzone_B.targetname = "bombzone_B";
		bombzone_B.squaredradius = 128 * 128;

		al = (7100, -500, -64);
		ax = (1050, 300, -64);
		for (x = 0; x < 5; x++) {
			for (y = 0; y < 5; y++) {
				offset = (x * 50, y * 50, 0);
				spawn("mp_searchanddestroy_spawn_allied", (al[0], al[1], al[2]) + offset);
				spawn("mp_searchanddestroy_spawn_axis", (ax[0], ax[1], ax[2]) + offset);
			}
		}
		// Angles appear not be preserved by setting them to spawn() return entity.
		spawnpoints = getEntArray("mp_searchanddestroy_spawn_allied", "classname");
		for(i = 0; i < spawnpoints.size; i++) {
			spawnpoints[i].angles = (0, 180, 0);
		}
	} else if (mapname == "mp_chateau") {
		bombtrigger = spawn("script_origin", (10000, 64, -64));
		bombtrigger.targetname = "bombtrigger";
		bombtrigger.squaredradius = 64 * 64;

		bombzone_A = spawn("script_origin", (880, 1800, 168));
		bombzone_A.targetname = "bombzone_A";
		bombzone_A.squaredradius = 64 * 64;

		bombzone_B = spawn("script_origin", (1550, 640, 144));
		bombzone_B.targetname = "bombzone_B";
		bombzone_B.squaredradius = 160 * 160;

		spawn("mp_searchanddestroy_intermission", (-1134, 272, 532));
		// Angles appear not be preserved by setting them to spawn() return entity.
		spawnpoints = getEntArray("mp_searchanddestroy_intermission", "classname");
		for(i = 0; i < spawnpoints.size; i++) {
			spawnpoints[i].angles = (0, 45, 0);
		}

		al = (-1075, 360, 112);
		ax = (1800, 320, 144);
		for (x = 0; x < 5; x++) {
			for (y = 0; y < 5; y++) {
				offset = (x * 50, y * 50, 0);
				spawn("mp_searchanddestroy_spawn_allied", (al[0], al[1], al[2]) + offset);
				spawn("mp_searchanddestroy_spawn_axis", (ax[0], ax[1], ax[2]) + offset);
			}
		}
		// Angles appear not be preserved by setting them to spawn() return entity.
		spawnpoints = getEntArray("mp_searchanddestroy_spawn_axis", "classname");
		for(i = 0; i < spawnpoints.size; i++) {
			spawnpoints[i].angles = (0, 180, 0);
		}
	}
}

bomb_or_zone_trigger()
{
	wait 1; // Skip possible notification that would immediately end this routine.

	level endon("bomb_defused");
	level endon("bomb_planted");

	while (true) {
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++) {
			if (players[i].sessionstate != "playing") {
				continue;
			}

			if (distanceSquared(players[i].origin, self.origin) < self.squaredradius) {
				self notify("trigger", players[i]);
			}
		}
		wait .2;
	}
}
