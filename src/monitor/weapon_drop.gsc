start()
{
	self endon("spawned");

	while (self.sessionstate == "playing") {
		ticks = 0;

		while (
			self.sessionstate == "playing" && self useButtonPressed() &&
			// Prevent interference with bomb planting.
			!isDefined(self.progressbar) &&
			self getCurrentWeapon() == self getWeaponSlotWeapon("primaryb")
		) {
			ticks++;

			if (ticks > 32) {
				if (level._allow_drop_sniper == false) {
					switch (self getCurrentWeapon()) {
					case "kar98k_sniper_mp":
					case "mosin_nagant_sniper_mp":
					case "springfield_mp":
						ticks = 0;
						iPrintLn(level._prefix +  "^1Snipers can not be dropped.");
						wait 0.05;
						continue;
					}
				}

				self dropItem(self getCurrentWeapon());
			}

			wait .05;
		}

		wait .25;
	}
}
