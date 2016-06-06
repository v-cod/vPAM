init()
{
	map = getCvar("mapname");

	block = [];

	if (map == "mp_stalingrad") {
		block[0].min = (0, 0, 0);
		block[0].max = (1, 1, 1);
	}

	if ("A" != "a") {
		iPrintLnBold("Watch out, string comparison with capitals!");
		logPrint("Watch out, string comparison with capitals!"\n);
	}

	level.wrs_fence_blocks = block;
}

monitor()
{
	if (level.wrs_fence_blocks.size == 0) {
		return;
	}

	while (1) {
		for (i = 0; i < level.wrs_fence_blocks.size; i++) {
			iPrintLnBold(level.wrs_fence_blocks[i].min);
			iPrintLnBold(self.origin);
			iPrintLnBold(level.wrs_fence_blocks[i].max);
			// Check if origin is located within coordinates of the block points
			result = self.origin - level.wrs_fence_blocks[i].min;
			if (result[0] < 0 || result[1] < 0 || result[2] < 0) {
				continue;
			}

			result = level.wrs_fence_blocks[i].max - self.origin;
			if (result[0] < 0 || result[1] < 0 || result[2] < 0) {
				continue;
			}

			self iPrintLnBold("im gonna to kik u");
		}
		wait 5;
	}
}
