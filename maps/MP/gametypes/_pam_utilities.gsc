watchPlayerFastShoot()
{
	self endon("spawned");

	while (self.sessionstate == "playing") {
		// Reference clip count.
		a1 = self getWeaponSlotClipAmmo("primary");
		b1 = self getWeaponSlotClipAmmo("primaryb");

		// Wait for clip ammo to change.
		do {
			wait 0.05;

			if (self.sessionstate != "playing") {
				return;
			}

			a2 = self getWeaponSlotClipAmmo("primary");
			b2 = self getWeaponSlotClipAmmo("primaryb");
		} while (a1 == a2 && b1 == b2);

		// Check for reload.
		if (a1 < a2 || b1 < b2) {
			continue;
		}

		a1 = a2;
		b1 = b2;

		wait level.p_afs_time;

		if (self.sessionstate != "playing") {
			return;
		}

		a2 = self getWeaponSlotClipAmmo("primary");
		b2 = self getWeaponSlotClipAmmo("primaryb");

		if (a2 < a1 || b2 < b1) {
			iPrintLn(level.p_prefix +  "^1FASTSHOOT^7: " + self.name);
		}
	}
}

watchPlayerAimRun()
{
	self endon("spawned");

	while (self.sessionstate == "playing") {
		// Reference clip count.
		a1 = self getWeaponSlotClipAmmo("primary");
		b1 = self getWeaponSlotClipAmmo("primaryb");

		// Wait for clip ammo to change.
		do {
			wait 0.05;

			if (self.sessionstate != "playing") {
				return;
			}

			a2 = self getWeaponSlotClipAmmo("primary");
			b2 = self getWeaponSlotClipAmmo("primaryb");
		} while (a1 == a2 && b1 == b2);

		// If neither clip count was increased, nothing was reloaded.
		if (a2 <= a1 && b2 <= b1) {
			continue;
		}

		// Rough time between clip change and end of reloading animation.
		wait 1;

		// Keep toggling weapon if aim run glitching.
		while (self attackButtonPressed()) {
			self disableWeapon();
			wait 0.05;
			self enableWeapon();
		}
	}
}
