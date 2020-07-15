check()
{
	if (level.p_sniper_limit == 0) {
		return;
	}

	// Possibly wait for player to disconnect who might have had a sniper.
	wait 0;

	snipers["allies"] = 0;
	snipers["axis"] = 0;

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (!isDefined(players[i].pers["weapon"])) {
			continue;
		}

		w = [];
		// Check the selected weapon.
		w[0] = players[i].pers["weapon"];
		// Check the currently held weapons.
		w[1] = players[i] getWeaponSlotWeapon("primary");
		w[2] = players[i] getWeaponSlotWeapon("primaryb");
		// If players took a sniper, then count that as sniper too.
		if (isDefined(players[i].pers["weapon1"])) {
			w[w.size] = players[i].pers["weapon1"];
			w[w.size] = players[i].pers["weapon2"];
		}
		for (j = 0; j < w.size; j++) {
			if (w[j] == "kar98k_sniper_mp" || w[j] == "mosin_nagant_sniper_mp" || w[j] == "springfield_mp" ) {
				snipers[players[i].pers["team"]]++;
				break;
			}
		}
	}

	if (snipers["allies"] >= level.p_sniper_limit) {
		setCvar("scr_allow_springfield", false);
		setCvar("ui_allow_springfield", false);
		makeCvarServerInfo("ui_allow_springfield", false);

		setCvar("scr_allow_nagantsniper", false);
		setCvar("ui_allow_nagantsniper", false);
		makeCvarServerInfo("ui_allow_nagantsniper", false);
	} else {
		setCvar("scr_allow_springfield", true);
		setCvar("ui_allow_springfield", true);
		makeCvarServerInfo("ui_allow_springfield", true);

		setCvar("scr_allow_nagantsniper", true);
		setCvar("ui_allow_nagantsniper", true);
		makeCvarServerInfo("ui_allow_nagantsniper", true);
	}

	if (snipers["axis"] >= level.p_sniper_limit) {
		setCvar("scr_allow_kar98ksniper", false);
		setCvar("ui_allow_kar98ksniper", false);
		makeCvarServerInfo("ui_allow_kar98ksniper", false);
	} else {
		setCvar("scr_allow_kar98ksniper", true);
		setCvar("ui_allow_kar98ksniper", true);
		makeCvarServerInfo("ui_allow_kar98ksniper", true);
	}
}
