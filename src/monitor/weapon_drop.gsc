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
				self dropItem(self getCurrentWeapon());
			}

			wait .05;
		}

		wait .25;
	}
}
