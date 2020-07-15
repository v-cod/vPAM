start(time)
{
	level.p_stratting = true;

	// Used to set all players' speed to zero here, but apparently the player
	// entities aren't available here yet. Should be done in spawnPlayer routine.

	// Abuse the existing clock into showing the strat period.
	level.clock setTimer(time);
	level.clock.color = (0, 1, 0);

	wait time;

	level.p_stratting = false;

	// Unfreeze the players.
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++) { 
		players[i].maxspeed = getCvarInt("g_speed");
	}

	thread _detect_false_start();
}

// Attempt to detect false start (lagbinding).
_detect_false_start()
{
	dist_max = getCvarInt("g_speed") * 1.2; // Fastest possible speed (pistol/nade).
	dist_max = dist_max * dist_max; // squared

	// Wait for players to cover distance.
	wait 1;

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (players[i].sessionstate != "playing") {
			continue;
		}

		dist = distanceSquared(players[i].p_spawn_origin, players[i].origin);		
		if (dist > dist_max) {
			iPrintLn(level._prefix + "^1FALSE START^7: " + players[i].name);
			players[i] setOrigin(players[i].p_spawn_origin);
		}
	}
}
