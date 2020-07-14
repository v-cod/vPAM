start()
{
	// Allow damage or death yet
	level.p_stratting = true;

	// Freeze all the players.
	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		players[i].maxspeed = 0;
	}

	level waittill("round_started");

	level.p_stratting = false;

	// Unfreeze the players.
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++) { 
		players[i].maxspeed = getCvarInt("g_speed");
	}

	thread maps\mp\gametypes\_teams::sayMoveIn();

	// Attempt to detect false start (lagbinding).
	dist_max = getCvarInt("g_speed") * 1.2; // Fastest possible speed (pistol).
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
			iPrintLn(level.p_prefix + "^1FALSE START^7: " + players[i].name);
			players[i] setOrigin(players[i].p_spawn_origin);
		}
	}
}