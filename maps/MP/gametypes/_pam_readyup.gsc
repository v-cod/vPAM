PAM_Ready_UP()
{
	level.p_readying = true;

	// Ready-Up Mode HUD
	level.waiting = newHudElem();
	level.waiting.alignX = "center";
	level.waiting.alignY = "middle";
	level.waiting.color = (1, 0, 0);
	level.waiting.x = 320;
	level.waiting.y = 390;
	level.waiting.fontScale = 1.5;
	level.waiting setText(game["waiting"]);

	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++) {
		players[i] thread readyup();
	}

	Waiting_On_Players(); //used to be its own thread, now we wait in there until its finished

	if(isdefined(level.waiting))
		level.waiting destroy();
}

Waiting_On_Players()
{
	level.waitingon = newHudElem(self);
	level.waitingon.x = 575;
	level.waitingon.y = 40;
	level.waitingon.alignX = "center";
	level.waitingon.alignY = "middle";
	level.waitingon.fontScale = 1.1;
	level.waitingon.color = (.8, 1, 1);
	level.waitingon setText(game["waitingon"]);

	level.playerstext = newHudElem(self);
	level.playerstext.x = 575;
	level.playerstext.y = 80;
	level.playerstext.alignX = "center";
	level.playerstext.alignY = "middle";
	level.playerstext.fontScale = 1.1;
	level.playerstext.color = (.8, 1, 1);
	level.playerstext setText(game["playerstext"]);

	level.notreadyhud = newHudElem(self);
	level.notreadyhud.x = 575;
	level.notreadyhud.y = 60;
	level.notreadyhud.alignX = "center";
	level.notreadyhud.alignY = "middle";
	level.notreadyhud.fontScale = 1.2;
	level.notreadyhud.color = (.98, .98, .60);

	// Maintain Player Not Ready count.
	while (level.p_readying) {
		notready = 0;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++) {
			if (!players[i].p_ready) {
				notready++;
			}
		}

		level.notreadyhud setValue(notready);
	
		wait 1;
	}

	if(isdefined(level.notreadyhud))
		level.notreadyhud destroy();
	if(isdefined(level.waitingon))
		level.waitingon destroy();
	if(isdefined(level.playerstext))
		level.playerstext destroy();
}

readyup()
{
	if (self.p_readying) {
		return;
	}
	self.p_readying = true;

	self.statusicon = "";

	// Required or the "respawn" notify could happen before it's waittill has begun
	wait .5;

	self iprintlnbold("^7Hit the ^9[{+activate}] ^7key to begin^4.");

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

	while (level.p_readying) {
		// Wait for use button press.
		while (self useButtonPressed() == false) {
			wait .05;
		}

		// Toggle ready boolean.
		self.p_ready = !self.p_ready;

		if (self.p_ready) {
			self.statusicon = game["headicon_carrier"];
			iprintln(self.p_name + "^7 is ^2ready");

			// Change players hud to indicate player not ready
			readyhud.color = (.73, .99, .73);
			readyhud setText(game["ready"]);

			update_ready();
		} else {
			self.statusicon = "";
			iprintln(self.p_name + "^7 is ^1not ready");

			// Change players hud to indicate player not ready
			readyhud.color = (1, .84, .84);
			readyhud setText(game["notready"]);
		}

		// Wait for use button release.
		while (self useButtonPressed() == true) {
			wait .05;
		}
	}

	if(isdefined(readyhud))
		readyhud destroy();
	if(isdefined(status))
		status destroy();
}

is_level_ready()
{
	if (level.exist["allies"] == 0 || level.exist["axis"] == 0) {
		return false;
	}

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++) {
		if (!players[i].p_ready) {
			return false;
		}
	}

	return true;
}

update_ready()
{
	if (is_level_ready() == true) {
		level.p_readying = false;
	}
}
