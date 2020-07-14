take_or_set(primary_weapon)
{
	if (!level.p_allow_pistol) {
		self takeWeapon(self getWeaponSlotWeapon("pistol"));
		self takeWeapon(self getWeaponSlotWeapon("pistol"));
	}

	if (!level.p_allow_nades) {
		self takeWeapon(self getWeaponSlotWeapon("grenade"));
	} else {
		n = self _get_nade_count(primary_weapon);
		if (n > 0) {
			self setWeaponSlotClipAmmo("grenade", n);
		} else {
			self takeWeapon(self getWeaponSlotWeapon("grenade"));
		}
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
