_monitor()
{
	self iPrintLn(level.wrs_print_prefix + "Save: double press [{+melee}]");
	self iPrintLn(level.wrs_print_prefix + "Load: double press [{+activate}]");

	self thread _monitor_nades();
	self thread _monitor_load();
	self thread _monitor_save();
}
_monitor_nades()
{
	grenade = self getWeaponSlotWeapon("grenade");
	while (self.sessionstate == "playing") {
		self setWeaponSlotClipAmmo("grenade", 3);

		wait 1;
	}
}


_monitor_load()
{
	while (self.sessionstate == "playing") {
		while (!self useButtonPressed() && self.sessionstate == "playing") {
			wait .05;
		}
		while (self useButtonPressed() && self.sessionstate == "playing") {
			wait .05;
		}
		ticks = 6;

		while (!self useButtonPressed() && self.sessionstate == "playing") {
			ticks--;
			if (ticks == 0) {
				break;
			}
			wait .05;
		}

		if (ticks > 0 && self.sessionstate == "playing") {
			if (isDefined(self.wrs_jumper_save)) {
				self setOrigin(self.wrs_jumper_save["origin"]);
				self setPlayerAngles(self.wrs_jumper_save["angles"]);
				self iPrintLn(level.wrs_print_prefix + "Position loaded.");
			}
		}
	}
}
_monitor_save()
{
	while (self.sessionstate == "playing") {
		while (!self meleeButtonPressed() && self.sessionstate == "playing") {
			wait .05;
		}
		while (self meleeButtonPressed() && self.sessionstate == "playing") {
			wait .05;
		}

		ticks = 6;

		while (!self meleeButtonPressed() && self.sessionstate == "playing") {
			ticks--;
			if (ticks == 0) {
				break;
			}
			wait .05;
		}

		if (ticks > 0 && self.sessionstate == "playing") {
			self.wrs_jumper_save = [];
			self.wrs_jumper_save["origin"] = self.origin;
			self.wrs_jumper_save["angles"] = self.angles;

			self iPrintLn(level.wrs_print_prefix + "Position saved.");
		}
	}
}
