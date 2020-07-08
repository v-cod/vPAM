_monitor()
{
	self.wrs_jumper = true;

	self.wrs_jumper_save["origin"] = (0, 0, 0);
	self.wrs_jumper_save["angles"] = (0, 0, 0);

	self iPrintLn(level.wrs_print_prefix + "Save: double press [{+melee}]");
	self iPrintLn(level.wrs_print_prefix + "Load: double press [{+activate}]");

	self thread _monitor_nades();
	self thread _monitor_load();
	self thread _monitor_save();
}

_monitor_nades()
{
	grenade = self getWeaponSlotWeapon("grenade");
	while (self.sessionstate == "playing" && isDefined(self.wrs_jumper)) {
		self setWeaponSlotClipAmmo("grenade", 3);

		wait 1;
	}
}


_monitor_load()
{
	while (self.sessionstate == "playing" && isDefined(self.wrs_jumper)) {
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
			if (!isDefined(self.wrs_jumper_save) || self.wrs_jumper_save["origin"] == (0, 0, 0)) {
				self iPrintLn(level.wrs_print_prefix + "No position saved yet.");
				continue;
			}

			self setOrigin(self.wrs_jumper_save["origin"]);
			self setPlayerAngles(self.wrs_jumper_save["angles"]);

			self iPrintLn(level.wrs_print_prefix + "Position loaded.");
		}
	}
}
_monitor_save()
{
	while (self.sessionstate == "playing" && isDefined(self.wrs_jumper)) {
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
			self.wrs_jumper_save["origin"] = self.origin;
			self.wrs_jumper_save["angles"] = self.angles;

			self iPrintLn(level.wrs_print_prefix + "Position saved. (" + self.wrs_jumper_save["origin"][0] + "," + self.wrs_jumper_save["origin"][1] + "," + self.wrs_jumper_save["origin"][2] + ")");
		}
	}
}
