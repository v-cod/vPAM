take_or_set(primary_weapon)
{
	if(isDefined(self.pers["weapon1"]) && isDefined(self.pers["weapon2"])) {
	 	self setWeaponSlotWeapon("primary", self.pers["weapon1"]);
		self setWeaponSlotAmmo("primary", 999);
		self setWeaponSlotClipAmmo("primary", 999);

	 	self setWeaponSlotWeapon("primaryb", self.pers["weapon2"]);
		self setWeaponSlotAmmo("primaryb", 999);
		self setWeaponSlotClipAmmo("primaryb", 999);

		self setSpawnWeapon(self.pers["spawnweapon"]);
	} else {
		self setWeaponSlotWeapon("primary", self.pers["weapon"]);
		self setWeaponSlotAmmo("primary", 999);
		self setWeaponSlotClipAmmo("primary", 999);

		// Give second weapon if chosen.
		if (isDefined(self.pers["weapon_secondary"])) {
			self setWeaponSlotWeapon("primaryb", self.pers["weapon_secondary"]);
			self setWeaponSlotAmmo("primaryb", 999);
			self setWeaponSlotClipAmmo("primaryb", 999);
		}

		self setSpawnWeapon(self.pers["weapon"]);
	}

	self switchToWeapon(self getWeaponSlotWeapon("primary"));

	if (level._allow_pistol) {
		if (self getWeaponSlotWeapon("pistol") == "none") {
			maps\mp\gametypes\_teams::givePistol();
		}
	} else {
		self takeWeapon(self getWeaponSlotWeapon("pistol"));
	}

	if (level._allow_nades) {
		if (self getWeaponSlotWeapon("grenade") == "none") {
			maps\mp\gametypes\_teams::giveGrenades(primary_weapon);
		}

		n = self _get_nade_count(primary_weapon);
		if (n > 0) {
			self setWeaponSlotClipAmmo("grenade", n);
		} else {
			self takeWeapon(self getWeaponSlotWeapon("grenade"));
		}
	} else {
		self takeWeapon(self getWeaponSlotWeapon("grenade"));
	}
}

_get_nade_count(weapon)
{
	switch(weapon)
	{
	case "m1carbine_mp":
	case "m1garand_mp":
	case "enfield_mp":
	case "mosin_nagant_mp":
	case "kar98k_mp":
		return level._nade_count_rifle; // originally 3
	case "thompson_mp":
	case "sten_mp":
	case "ppsh_mp":
	case "mp40_mp":	
		return level._nade_count_smg; // originally 2
	case "bar_mp":
	case "bren_mp":
	case "mp44_mp":
		return level._nade_count_mg; // originally 2
	case "springfield_mp":
	case "mosin_nagant_sniper_mp":
	case "kar98k_sniper_mp":
		return level._nade_count_sniper; // originally 1
	}
}
