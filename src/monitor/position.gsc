_local()
{
	blocks = [];

	switch (getCvar("mapname")) {
	case "mp_stalingrad":
		blocks[0]["min"] = (2048, -216, 168); // Glitch room
		blocks[0]["max"] = (2464,   -8, 292);
		break;
	case "mp_carentan":
		blocks[0]["min"] = (584,  448, 320); // Sniper roof
		blocks[0]["max"] = (1304, 744, 512);
		break;
	default:
		break;
	}

	return blocks;
}

// afk_to_spec: true to kick idling player to spec.
// fence: true to monitor if players are located in certain disallowed blocks.
start(afk_to_spec, fence)
{
	self endon("spawned");

	// Reference point to keep checking if moved from that spot
	origin_spawn = self.origin;
	time = getTime();

	if (afk_to_spec && getCvar("g_gametype") == "sd" && isDefined(game["matchstarted"])) {

		// Wait for round to end, or for player to move or die.
		while (!level.roundended && origin_spawn == self.origin && self.sessionstate == "playing") {
			wait 1;
		}

		if (
			(level.roundended && origin_spawn == self.origin)
			|| (self.sessionstate != "playing" && self.pers["team"] != "spectator")
		) {
			// Should've stood still for at least 30 seconds.
			if (((getTime() - time) / 1000) > 30) {
				self.pers["score"]++; // Otherwise a suicide will end up with -1, but we are benign.
				self notify("menuresponse", game["menu_team"], "spectator");

				iPrintLn(level._prefix + self.name + " ^7is AFK.");

				return;
			}
		}
	}

	if (fence) {
		blocks = _local();
		if (blocks.size == 0) {
			return;
		}

		while (self.sessionstate == "playing") {
			for (i = 0; i < blocks.size; i++) {
				if (!(self _is_in_block(blocks[i]))) {
					continue;
				}

				self _eliminate(blocks[i]);
			}
			wait 2;
		}
	}

}

// Eliminate routine to warn player before killing him
_eliminate(block)
{
	iPrintLn(level._prefix + self.name + " ^7entered an unallowed spot.");
	self iPrintLnBold("This spot is ^1not ^7allowed.");
	i = 5;
	while (self _is_in_block(block)) {
		self iPrintLn(level._prefix + "Killing in " + i + " seconds.");
		i--;
		wait 1;
		if (i <= 0) {
			iPrintLn(level._prefix + self.name + " ^7was killed for entering an unallowed spot.");

			self suicide();
			return;
		}
	}
}

// Check if self.origin is located within coordinates of the block points
_is_in_block(block)
{
	result = self.origin - block["min"];
	if (result[0] < 0 || result[1] < 0 || result[2] < 0) {
		return false;
	}

	result = block["max"] - self.origin;
	if (result[0] < 0 || result[1] < 0 || result[2] < 0) {
		return false;
	}

	return true;
}
