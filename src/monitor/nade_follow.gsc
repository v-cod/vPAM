start()
{
	self endon("spawned");

	while (self.sessionstate == "playing") {
		// Wait for nade count to decrease (thus throwing a nade).
		nade_count = self getWeaponSlotAmmo("grenade");
		while (nade_count >= self getWeaponSlotAmmo("grenade") && self.sessionstate == "playing") {
			wait 0.05;
		}

		if (self.sessionstate != "playing") {
			return;
		}

		self setWeaponSlotAmmo("grenade", 999);

		if (self meleeButtonPressed() == false) {
			continue;
		}

		// Find a nade within small distance of player.
		nade = undefined;
		nades = getEntArray("grenade", "classname");
		for (i = 0; i < nades.size; i++) {
			if (distanceSquared(nades[i].origin, self.origin) < 100*100) {
				nade = nades[i];
				break;
			}
		}

		// If no nade was found. Shouldn't happen.
		if (!isDefined(nade)) {
			continue;
		}

		// Spawn a placeholder soldier at the original player position.
		self_model = spawn("script_model", self.origin);
		self_model.angles = self.angles;
		self_model setModel(self.pers["savedmodel"]["model"]);

		// Save the original position to reset to later.
		saved_origin = self.origin;
		saved_angles = self.angles;

		// Have the player follow the trajectory of the nade.
		self linkTo(nade);

		// Make player invisible.
		self detachAll();
		self setModel("");

		// 3rd person allows the player to better view the nade.
		self setClientCvar("cg_thirdPerson", true);

		while (isDefined(nade) && self useButtonPressed() == false && self.sessionstate == "playing") {
			wait 0.05;
		}

		// Delete the placeholder model.
		self_model delete();

		if (self.sessionstate != "playing") {
			return;
		}

		// If the nade still exists (didn't explode), detach from it.
		if (isDefined(nade)) {
			self unlink(nade);
		}

		// Make visible again.
		self maps\mp\_utility::loadModel(self.pers["savedmodel"]);

		self setClientCvar("cg_thirdPerson", false);

		// Place player at original position.
		self setOrigin(saved_origin);
		self setPlayerAngles(saved_angles);
	}
}
