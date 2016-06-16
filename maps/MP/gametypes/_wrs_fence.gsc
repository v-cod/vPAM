init()
{
	block = [];

	switch (getCvar("mapname")) {
	case "mp_stalingrad":
		block[0]["min"] = (2048, -216, 168);
		block[0]["max"] = (2464,   -8, 292);
		break;
	default:
		break;
	}

	level.wrs_fence_blocks = block;
}

monitor()
{
	if (level.wrs_fence_blocks.size == 0) {
		return;
	}

	// If someone did not move until end of round
	origin_spawn = self.origin;
	if (level.gametype == "sd") {
		while (self.sessionstate == "playing" && origin_spawn == self.origin) {
			if (level.roundended) {
				self iPrintLnBold("Inactive");
			}
			wait 1;
		}
	}

	while (self.sessionstate == "playing") {
		for (i = 0; i < level.wrs_fence_blocks.size; i++) {
			if (!(self _is_in_block(level.wrs_fence_blocks[i]))) {
				continue;
			}

			self _eliminate(level.wrs_fence_blocks[i]);
		}
		wait 1;
	}
}

_eliminate(block)
{
	self iPrintLnBold("This spot is ^1not ^7allowed.");
	i = 5;
	while (self _is_in_block(block)) {
		self iPrintLn(i);
		i--;
		wait 1;
		if (i <= 0) {
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
