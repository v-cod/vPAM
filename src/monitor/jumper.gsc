start()
{
	self._jumper = true;

	self._jumper_save["origin"] = (0, 0, 0);
	self._jumper_save["angles"] = (0, 0, 0);

	self iPrintLn(level._prefix + "Save: double press [{+melee}]");
	self iPrintLn(level._prefix + "Load: double press [{+activate}]");

	self thread _monitor_nades();
	self thread _monitor_load();
	self thread _monitor_save();
}

_monitor_nades()
{
	grenade = self getWeaponSlotWeapon("grenade");
	while (self.sessionstate == "playing" && isDefined(self._jumper)) {
		self setWeaponSlotClipAmmo("grenade", 3);

		wait 1;
	}
}


_monitor_load()
{
	while (self.sessionstate == "playing" && isDefined(self._jumper)) {
		while (!self useButtonPressed() && self.sessionstate == "playing") {
			wait .05;
		}
		while (self useButtonPressed() && self.sessionstate == "playing") {
			wait .05;
		}

		for (i = 0; i < 6 && !self useButtonPressed() && self.sessionstate == "playing"; i++) {
			wait .05;
		}

		if (self.sessionstate == "playing" && i < 6) {
			if (!isDefined(self._jumper_save) || self._jumper_save["origin"] == (0, 0, 0)) {
				self iPrintLn(level._prefix + "No position saved yet.");
				continue;
			}

			self setOrigin(self._jumper_save["origin"]);
			self setPlayerAngles(self._jumper_save["angles"]);

			self iPrintLn(level._prefix + "Position loaded.");
		}
	}
}
_monitor_save()
{
	while (self.sessionstate == "playing" && isDefined(self._jumper)) {
		while (!self meleeButtonPressed() && self.sessionstate == "playing") {
			wait .05;
		}
		while (self meleeButtonPressed() && self.sessionstate == "playing") {
			wait .05;
		}

		for (i = 0; i < 6 && !self meleeButtonPressed() && self.sessionstate == "playing"; i++) {
			wait .05;
		}

		if (self.sessionstate == "playing" && i < 6) {
			self._jumper_save["origin"] = self.origin;
			self._jumper_save["angles"] = self.angles;

			self iPrintLn(level._prefix + "Position saved. (" + self._jumper_save["origin"][0] + "," + self._jumper_save["origin"][1] + "," + self._jumper_save["origin"][2] + ")");
		}
	}
}
