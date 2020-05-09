start_readying()
{
	level.p_readying = true;
	level.p_readied = false;

	_hud_readying_create();
	_hud_readying_count_create();
	update();

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

	_hud_ready_create(game["p_halftimeflag"] + 1);
	iPrintLn("players ready, wait 5 seconds...");
	wait 5;
	_hud_ready_destroy();

	if (game["roundsplayed"] == 0) {
		announcement(&"SD_MATCHSTARTING");
	} else {
		announcement(&"SD_MATCHRESUMING");
	}

	level notify("kill_endround");
	level.roundended = false;
	level thread maps\mp\gametypes\_pam_sd::endRound("reset");
}

update()
{
	if (level.p_readying == false) {
		return;
	}

	n = 0;

	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++) {
		n = n + players[i].p_ready;
	}

	level.p_readying_count_3 setValue(players.size - n);

	if (players.size < 2) {
		iPrintLn("Two or more players needed to begin.");
	} else if (n == players.size) {
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

	self.statusicon = "";

	self thread _player_information();

	status = newClientHudElem(self);
	status.x = 575;
	status.y = 120;
	status.alignX = "center";
	status.alignY = "middle";
	status.fontScale = 1.1;
	status.color = (.8, 1, 1);
	status setText(game["status"]);

	readyhud = newClientHudElem(self);
	readyhud.x = 575;
	readyhud.y = 135;
	readyhud.alignX = "center";
	readyhud.alignY = "middle";
	readyhud.fontScale = 1.2;
	readyhud.color = (1, .66, .66);
	readyhud setText(game["notready"]);
	
	update();

	for (;;) {
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
			self.statusicon = game["headicon_carrier"];
			iprintln(self.p_name + "^7 is ^2ready");

			// Change players hud to indicate player not ready
			readyhud.color = (.73, .99, .73);
			readyhud setText(game["ready"]);
		} else {
			self.statusicon = "";
			iprintln(self.p_name + "^7 is ^1not ready");

			// Change players hud to indicate player not ready
			readyhud.color = (1, .84, .84);
			readyhud setText(game["notready"]);
		}

		update();

		// Wait for use button release.
		while (self useButtonPressed() == true && level.p_readying) {
			wait .05;
		}
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

	for (i = 1; getCvar("p_msg_" + i) != ""; i++) {
		self iPrintLnBold(getCvar("p_msg_" + i));
		
		wait 1.5;
	}

	self iPrintLnBold("^7Hit the ^9[{+activate}] ^7key to begin^4.");
}

_hud_readying_create()
{
	if (isDefined(level.p_hud_readying)) {
		return;
	}

	level.p_hud_readying = newHudElem();
	level.p_hud_readying.alignX = "center";
	level.p_hud_readying.alignY = "middle";
	level.p_hud_readying.color = (1, 0, 0);
	level.p_hud_readying.x = 320;
	level.p_hud_readying.y = 390;
	level.p_hud_readying.fontScale = 1.5;
	level.p_hud_readying setText(game["waiting"]);
}

_hud_readying_destroy()
{
	if (isDefined(level.p_hud_readying)) {
		level.p_hud_readying destroy();
	}
}

_hud_readying_count_create()
{
	if (isDefined(level.p_readying_count_1)) {
		return;
	}
	
	level.p_readying_count_1 = newHudElem(self);
	level.p_readying_count_1.x = 575;
	level.p_readying_count_1.y = 40;
	level.p_readying_count_1.alignX = "center";
	level.p_readying_count_1.alignY = "middle";
	level.p_readying_count_1.fontScale = 1.1;
	level.p_readying_count_1.color = (.8, 1, 1);
	level.p_readying_count_1 setText(game["waitingon"]);

	level.p_readying_count_2 = newHudElem(self);
	level.p_readying_count_2.x = 575;
	level.p_readying_count_2.y = 80;
	level.p_readying_count_2.alignX = "center";
	level.p_readying_count_2.alignY = "middle";
	level.p_readying_count_2.fontScale = 1.1;
	level.p_readying_count_2.color = (.8, 1, 1);
	level.p_readying_count_2 setText(game["playerstext"]);

	level.p_readying_count_3 = newHudElem(self);
	level.p_readying_count_3.x = 575;
	level.p_readying_count_3.y = 60;
	level.p_readying_count_3.alignX = "center";
	level.p_readying_count_3.alignY = "middle";
	level.p_readying_count_3.fontScale = 1.2;
	level.p_readying_count_3.color = (.98, .98, .60);
}
_hud_readying_count_destroy()
{
	if (isDefined(level.p_readying_count_1)) {
		level.p_readying_count_1 destroy();
	}
	if (isDefined(level.p_readying_count_2)) {
		level.p_readying_count_2 destroy();
	}
	if (isDefined(level.p_readying_count_3)) {
		level.p_readying_count_3 destroy();
	}
}

_hud_ready_create(next_half)
{
	level.p_hud_ready = newHudElem();
	level.p_hud_ready.x = 320;
	level.p_hud_ready.y = 390;
	level.p_hud_ready.alignX = "center";
	level.p_hud_ready.alignY = "middle";
	level.p_hud_ready.fontScale = 1.5;
	level.p_hud_ready.color = (0, 1, 0);
	level.p_hud_ready setText(game["allready"]);
		
	level.p_hud_ready_next_half = newHudElem();
	level.p_hud_ready_next_half.x = 320;
	level.p_hud_ready_next_half.y = 370;
	level.p_hud_ready_next_half.alignX = "center";
	level.p_hud_ready_next_half.alignY = "middle";
	level.p_hud_ready_next_half.fontScale = 1.5;
	level.p_hud_ready_next_half.color = (0, 1, 0);

	if (next_half == 1) {
		level.p_hud_ready_next_half setText(game["start1sthalf"]);
	} else {
		level.p_hud_ready_next_half setText(game["start2ndhalf"]);
	}
}
_hud_ready_destroy()
{
	if (isDefined(level.p_hud_ready)) {
		level.p_hud_ready destroy();
	}
	if (isDefined(level.p_hud_ready_next_half)) {
		level.p_hud_ready_next_half destroy();
	}
}
