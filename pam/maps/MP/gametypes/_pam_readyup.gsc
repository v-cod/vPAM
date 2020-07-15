start_readying()
{
	level.p_readying = true;
	level.p_readied = false;

	_hud_readying_create();
	_hud_readying_count_create();

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		players[i] thread monitor_player();
	}
}

stop_readying()
{
	if (level.p_readying == false) {
		return;
	}
	level.p_readying = false;
	level.p_readied = true;

	_hud_readying_destroy();
	_hud_readying_count_destroy();

	iPrintLn(level._prefix + "All players are ^2ready^7. Starting match.");

	if (game["roundsplayed"] == 0) {
		announcement(&"SD_MATCHSTARTING");
	} else {
		announcement(&"SD_MATCHRESUMING");
	}

	level notify("kill_endround");
	level.roundended = false;
	level thread maps\mp\gametypes\sd::endRound("reset");
}

update()
{
	if (level.p_readying == false) {
		return;
	}

	wait 0; // Wait for possible disconnect of player.

	n = 0;

	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++) {
		n += players[i].p_ready;
	}

	// level.p_readying_count_3 setValue(players.size - n);
	level._hud_ready_players setValue(players.size - n);
	// level._hud_ready_players_total setValue();

	 if (n == players.size) {
		if (players.size < 2) {
			iPrintLn(level._prefix + "^1At least 2 players needed.");
			return;
		}

		thread stop_readying();
	}
}

monitor_player()
{
	// Wait for this player to spawn.
	wait 0;

	if (isDefined(self.p_readying) && self.p_readying) {
		return;
	}
	self.p_readying = true;
	self.p_ready = false;

	self thread _player_information();
	icon::set();

	readyhud = newClientHudElem(self);
	readyhud.x = 320;
	readyhud.y = 384;
	readyhud.alignX = "center";
	readyhud.alignY = "middle";
	readyhud.fontScale = 1.5;
	readyhud setText(game["_ISTR_PRESS_USE_TO_READY"]);

	update();

	while (true) {
		// Wait for use button press.
		while (self useButtonPressed() == false && level.p_readying) {
			wait .05;
		}

		if (!level.p_readying) {
			break;
		}

		// Toggle ready boolean.
		self.p_ready = !self.p_ready;

		if (self.p_ready) {
			iprintln(level._prefix + self.name + "^7 is ^2ready");

			// // Change players hud to indicate player not ready
			readyhud.fontScale = 0.7;
			readyhud setText(game["_ISTR_PRESS_USE_TO_UNDO_READY"]);
			
		} else {
			iprintln(level._prefix + self.name + "^7 is ^1not ready");

			// // Change players hud to indicate player not ready
			readyhud.fontScale = 1.5;
			readyhud setText(game["_ISTR_PRESS_USE_TO_READY"]);
		}

		icon::set(); // This sets status/head icon.
		update();

		// Wait for use button release.
		while (self useButtonPressed() == true && level.p_readying) {
			wait .05;
		}

		if (!level.p_readying) {
			break;
		}

		wait .5; // Prevent spamming.
	}

	if(isdefined(readyhud))
		readyhud destroy();
	if(isdefined(status))
		status destroy();
}

_player_information()
{
	if (isDefined(self.pers["p_informed"]) && self.pers["p_informed"] == true) {
		return;
	}
	self.pers["p_informed"] = true;

	while (self.sessionstate != "playing") {
		wait 0.2;
	}

	if (game["p_half"] == 1) {
		cvar_prefix = "p_msg_";
	} else {
		cvar_prefix = "p_msg_halftime_";
	}

	print_checksums();

	for (i = 1; getCvar(cvar_prefix + i) != ""; i++) {
		self iPrintLnBold(getCvar(cvar_prefix + i));
		
		wait 1.5;
	}

	self iPrintLnBold("^7Press " + game["p_color"] + "[{+activate}] ^7to ready-up" + game["p_color"] + ".");
}

print_checksums()
{
	sums = getCvar("sv_paks");
	paks = getCvar("sv_pakNames");

	sums = util::explode(sums, " ", 0);
	paks = util::explode(paks, " ", 0);

	self iPrintLn(level._prefix + "Server mods (and checksums)");

	for (i = 0; i < sums.size; i++) {
		if (paks[i].size == 4 && paks[i][0] == "p" && paks[i][1] == "a" && paks[i][2] == "k") {
			continue;
		}

		self iPrintLn(level._prefix + paks[i] + " (" + game["p_color"] + sums[i] + "^7)");
	}
}

_hud_readying_create()
{
	if (isDefined(level.p_hud_readying)) {
		return;
	}

	level.p_hud_readying = newHudElem();
	level.p_hud_readying.x = 320;
	level.p_hud_readying.y = 460;
	level.p_hud_readying.alignX = "center";
	level.p_hud_readying.alignY = "middle";
	level.p_hud_readying.font = "bigfixed";
	level.p_hud_readying.color = (1, 0, 0);
	level.p_hud_readying setText(game["_ISTR_READYING"]);
}

_hud_readying_destroy()
{
	if (isDefined(level.p_hud_readying)) {
		level.p_hud_readying destroy();
	}
}

_hud_readying_count_create()
{
	if (isDefined(level._hud_ready_players)) {
		return;
	}
	
	level._hud_ready_players = newHudElem();
	level._hud_ready_players.alpha = 0;
	level._hud_ready_players.x = 320;
	level._hud_ready_players.y = 352;
	level._hud_ready_players.alignX = "center";
	level._hud_ready_players.fontScale = 1.3;
	level._hud_ready_players.label = game["_ISTR_WAITING_FOR_PLAYERS"];
}
_hud_readying_count_destroy()
{
	if (isDefined(level._hud_ready_players)) {
		level._hud_ready_players destroy();
	}
}
