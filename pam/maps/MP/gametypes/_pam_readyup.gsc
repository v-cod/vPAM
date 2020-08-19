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

	iPrintLn(level._prefix + "All players are ^3ready^7. Starting match.");

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

	// Wait for possible disconnect of player.
	wait 0;

	n = 0;
	players_to_ready = [];

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (players[i].p_ready) {
			n++;
		} else {
			players_to_ready[players_to_ready.size] = players[i];
		}
	}

	level._hud_ready_players[1] setValue(n);
	level._hud_ready_players[3] setValue(players.size - n);

	if (n == players.size) {
		level notify("_readying_inform");

		if (players.size < 2) {
			iPrintLn(level._prefix + "^1At least 2 players needed.");
			return;
		}

		thread stop_readying();
	} else if (n / (float)players.size > 0.75) {
		level thread inform(players_to_ready, players.size);
	}
}

inform(players_to_ready, players_total)
{
	level notify("_readying_inform");
	level endon("_readying_inform");

	for (i = 0; i < players_to_ready.size; i++) {
		players_to_ready[i] thread flash_star_monitor();
	}

	while (true) {
		if (players_to_ready.size == 1) {
			players_to_ready[0] iPrintLnBold("^1ALL PLAYERS HAVE READIED EXCEPT YOU");
		} else {
			for (i = 0; i < players_to_ready.size; i++) {
				players_to_ready[i] iPrintLnBold("Please ^3ready ^7up for the match to start.");
			}
		}

		wait 10;
	}
}

flash_star_monitor()
{
	level endon("_readying_inform");

	while (!self.p_ready) {
		self thread flash_star();

		wait 0.25;
	}
}
flash_star()
{
	alpha = self._hud_readying_star.alpha;

	if (isDefined(self._hud_readying_star) && self._hud_readying_star.color == (1, 0, 0)) {
		self._hud_readying_star.alpha = 0;
	}

	wait 0.1;

	if (isDefined(self._hud_readying_star) && self._hud_readying_star.color == (1, 0, 0)) {
		self._hud_readying_star.alpha = alpha;
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

	self _hud_client_create();

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
			iPrintLn(level._prefix + self.name + "^7 is ^3ready");

			// Change players hud to indicate player ready
			self._hud_readying_star.color = (1, 1, 1);
			self._hud_readying_star.alpha = 0.6;
			self._hud_readying_text.alpha = 0;
			self._hud_readying_star_text setText(&"READY");
		} else {
			iPrintLn(level._prefix + self.name + "^7 is ^1not ready");

			// Change players hud to indicate player not ready
			self._hud_readying_star.color = (1, 0, 0);
			self._hud_readying_star.alpha = 0.15;
			self._hud_readying_text.alpha = 1;
			self._hud_readying_star_text setText(&"NOT READY");
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

		wait 1; // Prevent spamming.
	}

	self _hud_client_destroy();
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
	level.p_hud_readying.color = (1, 1, 0);
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

	level._hud_ready_players = [];

	level._hud_ready_players[0] = newHudElem();
	level._hud_ready_players[0].x = 450;
	level._hud_ready_players[0].y = 466;
	level._hud_ready_players[0].alignX = "center";
	level._hud_ready_players[0].alignY = "middle";
	level._hud_ready_players[0].alpha = .33;
	level._hud_ready_players[0].sort = -1;
	level._hud_ready_players[0] setShader("gfx/hud/headicon@re_objcarrier.tga", 24, 24);

	level._hud_ready_players[1] = newHudElem();
	level._hud_ready_players[1].x = level._hud_ready_players[0].x;
	level._hud_ready_players[1].y = level._hud_ready_players[0].y - 1;
	level._hud_ready_players[1].alignX = "center";
	level._hud_ready_players[1].alignY = "middle";
	level._hud_ready_players[1].fontScale = 0.9;
	level._hud_ready_players[1] setValue(0);

	level._hud_ready_players[2] = newHudElem();
	level._hud_ready_players[2].x = 450 + 20;
	level._hud_ready_players[2].y = 466;
	level._hud_ready_players[2].alignX = "center";
	level._hud_ready_players[2].alignY = "middle";
	level._hud_ready_players[2].alpha = .33;
	level._hud_ready_players[2].sort = -1;
	level._hud_ready_players[2].color = (1, 0, 0);
	level._hud_ready_players[2] setShader("gfx/hud/headicon@re_objcarrier.tga", 24, 24);

	level._hud_ready_players[3] = newHudElem();
	level._hud_ready_players[3].x = level._hud_ready_players[2].x;
	level._hud_ready_players[3].y = level._hud_ready_players[2].y - 1;
	level._hud_ready_players[3].alignX = "center";
	level._hud_ready_players[3].alignY = "middle";
	level._hud_ready_players[3].fontScale = 0.9;
	level._hud_ready_players[3] setValue(0);
}
_hud_readying_count_destroy()
{
	if (isDefined(level._hud_ready_players)) {
		level._hud_ready_players[0] destroy();
		level._hud_ready_players[1] destroy();
		level._hud_ready_players[2] destroy();
		level._hud_ready_players[3] destroy();
	}
}

_hud_client_create()
{
	if (isDefined(self._hud_readying_text)) {
		return;
	}

	self._hud_readying_text = newClientHudElem(self);
	self._hud_readying_text.archived = false;
	self._hud_readying_text.x = 320;
	self._hud_readying_text.y = 88;
	self._hud_readying_text.alignX = "center";
	self._hud_readying_text.alignY = "middle";
	self._hud_readying_text setText(game["_ISTR_PRESS_USE_TO_READY"]);

	self._hud_readying_star = newClientHudElem(self);
	self._hud_readying_star.archived = false;
	self._hud_readying_star.x = 119;
	self._hud_readying_star.y = 400;
	self._hud_readying_star.alignX = "center";
	self._hud_readying_star.alignY = "middle";
	self._hud_readying_star.alpha = 0.15;
	self._hud_readying_star.sort = -1;
	self._hud_readying_star.color = (1, 0, 0);
	self._hud_readying_star setShader("gfx/hud/headicon@re_objcarrier.tga", 48, 48);

	self._hud_readying_star_text = newClientHudElem(self);
	self._hud_readying_star_text.archived = false;
	self._hud_readying_star_text.x = 119;
	self._hud_readying_star_text.y = 396;
	self._hud_readying_star_text.alignX = "center";
	self._hud_readying_star_text.alignY = "middle";
	self._hud_readying_star_text.fontScale = 0.6;
	self._hud_readying_star_text.alpha = 0.8;
	self._hud_readying_star_text.sort = 0;
	self._hud_readying_star_text setText(&"NOT READY");
}

_hud_client_destroy()
{
	if (isDefined(self._hud_readying_text)) {
		self._hud_readying_text destroy();
	}

	if (isDefined(self._hud_readying_star)) {
		self._hud_readying_star destroy();
	}

	if (isDefined(self._hud_readying_star_text)) {
		self._hud_readying_star_text destroy();
	}
}
