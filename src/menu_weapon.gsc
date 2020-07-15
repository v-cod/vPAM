precache()
{
	if (game["_weapons"] == 1) {
		precacheMenu(game["menu_weapon_allies"]);

		switch (game["menu_weapon_allies"]) {
		case "weapon_american":
			precacheItem("fraggrenade_mp");
			precacheItem("colt_mp");
			precacheItem("m1carbine_mp");
			precacheItem("m1garand_mp");
			precacheItem("thompson_mp");
			precacheItem("bar_mp");
			precacheItem("springfield_mp");
			break;
		case "weapon_british":
			precacheItem("mk1britishfrag_mp");
			precacheItem("colt_mp");
			precacheItem("enfield_mp");
			precacheItem("sten_mp");
			precacheItem("bren_mp");
			precacheItem("springfield_mp");
			break;
		case "weapon_russian":
			precacheItem("rgd-33russianfrag_mp");
			precacheItem("luger_mp");
			precacheItem("ppsh_mp");
			precacheItem("mosin_nagant_mp");
			precacheItem("mosin_nagant_sniper_mp");
			break;
		}
	} else if (game["_weapons"] == 2) {
		for (i = 0; i < game["_weapons_arr"].size; i++) {
			precacheItem(game["_weapons_arr"][i]);
		}
	}
}

// Weapon procedure allowing second weapon pick.
process(menu, response)
{
	// The menu that is opened for them differs per team
	if (self.pers["team"] == "allies") {
		menu_1 = game["menu_weapon_allies"];
		menu_2 = game["menu_weapon_axis"];
	} else {
		menu_1 = game["menu_weapon_axis"];
		menu_2 = game["menu_weapon_allies"];
	}

	if (game["_weapons"] == 2) {
		self.pers["weapon"] = game["_weapons_arr"][0];
		self.pers["selectedweapon"] = self.pers["weapon"];
		if (game["_weapons_arr"].size > 1) {
			self.pers["weapon_secondary"] = game["_weapons_arr"][1];
		}

		return menu_weapon_proceed();
	}

	// Allow enemy team weapons.
	weapon = self maps\mp\gametypes\_teams::restrict_anyteam(response);
	if (weapon == "restricted") {
		self openMenu(menu);
		return undefined;
	}

	// If this is the first weapon picked, or if it is and second weapon is picked too
	if (menu == menu_1) {
		self.pers["weapon"] = weapon;
		self.pers["selectedweapon"] = weapon;

		self openMenu(menu_2);
		return undefined;
	} else {
		self.pers["weapon_secondary"] = weapon;
	}

	return menu_weapon_proceed();
}

menu_weapon_proceed()
{
	gt = getCvar("g_gametype");
	if (gt == "sd") {
		weapon = self.pers["weapon"];
		self.pers["weapon"] = undefined;
		self.pers["selectedweapon"] = undefined;
		return weapon;
	} else if (gt == "tdm") {
		if (self.sessionstate == "playing") {
			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

			if (maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
			else
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
		} else {
			maps\mp\gametypes\tdm::spawnPlayer();
			if (self.sessionteam != self.pers["team"]) {
				self thread maps\mp\gametypes\tdm::printJoinedTeam(self.pers["team"]);
			}
		}
	} else if (gt == "dm") {
		if (self.sessionstate == "playing") {
			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

			if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
			else
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
		} else {
			maps\mp\gametypes\dm::spawnPlayer();
		}
	} else if (gt == "jump") {
		if (self.sessionstate == "playing") {
			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

			if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
			else
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
		} else {
			// maps\mp\gametypes\jump::spawnPlayer();
		}
	} else if (gt == "hq") {
		if (self.sessionstate == "playing") {
			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

			if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
			else
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
		} else {
			self thread maps\mp\gametypes\hq::respawn();
			self thread maps\mp\gametypes\hq::printJoinedTeam(self.pers["team"]);
		}
	} else {
		// ERROR
	}

	self thread maps\mp\gametypes\_teams::SetSpectatePermissions();
	if (isDefined(self.autobalance_notify))
		self.autobalance_notify destroy();
}
