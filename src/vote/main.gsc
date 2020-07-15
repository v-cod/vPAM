_local()
{
	var["entry_height"] = 24;
	var["border_width"] = 2;

	return var;
}

precache()
{
	precacheShader("white");
	precacheShader("black");

	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
}

// Generic helper function to setup voting from istrings.
vote(seconds, header_istring, istrings)
{
	for (i = 0; i < istrings.size; i++) {
		level._vote_count[i] = 0;
	}

	_hud_vote_create(header_istring, istrings, seconds);

	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++) {
		players[i] thread _monitor_player();
	}

	wait seconds;

	level notify("_vote_end");
	_hud_vote_destroy();
	wait 0;

	// Default winner is 0.
	winner = 0;
	highest = level._vote_count[winner];
	// Find higher count.
	for(i = 1; i < level._vote_count.size; i++) {
		if (level._vote_count[i] > highest) {
			winner = i;
			highest = level._vote_count[winner];
		}
	}
	return winner;
}

_monitor_player()
{
	level endon("_vote_end");

	var = _local();
	eh = var["entry_height"];
	bw = var["border_width"];

	self._vote_hud_indicator = newClientHudElem(self);
	self._vote_hud_indicator.x = level._vote_x + bw;
	self._vote_hud_indicator.y = -128;
	self._vote_hud_indicator.sort= 9998;
	self._vote_hud_indicator.alpha = 0.3;
	self._vote_hud_indicator.color = (0, 0, 1);
	self._vote_hud_indicator setShader("white", level._vote_width - 2*bw, eh);

	vote = -1;
	while (true) {
		if (self attackButtonPressed()) {
			// Cancel vote if applicable.
			if (vote != -1) {
				level._vote_count[vote]--;
				level._vote_hud_count[vote] setValue(level._vote_count[vote]);
			}

			// Change vote.
			vote++;
			if (vote > level._vote_count.size - 1) {
				vote = 0;
			}

			// Apply vote.
			level._vote_count[vote]++;
			level._vote_hud_count[vote] setValue(level._vote_count[vote]);

			self._vote_hud_indicator.y = level._vote_y + bw + eh + vote*eh;
			self playLocalSound("hq_score");

			while(self attackButtonPressed()) {
				wait .05;
			}
		}

		wait .05;
	}
}

_hud_vote_create(header_istring, istrings, seconds)
{
	level._vote_width = 200;
	level._vote_height = 27 + istrings.size * 24;

	level._vote_x = 320 - level._vote_width/2;
	level._vote_y = -64 + 240 - level._vote_height/2;

	if (isDefined(level._vote_hud_cont)) {
		return;
	}

	var = _local();
	eh = var["entry_height"];
	bw = var["border_width"];

	// Container.
	level._vote_hud_cont = newHudElem();
	level._vote_hud_cont.archived = false;
	level._vote_hud_cont.alpha = .75;
	level._vote_hud_cont.x = level._vote_x;
	level._vote_hud_cont.y = level._vote_y;
	level._vote_hud_cont.sort = 9000;
	level._vote_hud_cont.color = (0,0,0);
	level._vote_hud_cont setShader("black", level._vote_width, level._vote_height);

	// Header.
	level._vote_hud_header = newHudElem();
	level._vote_hud_header.archived = false;
	level._vote_hud_header.alpha = .25;
	level._vote_hud_header.x = level._vote_x + bw;
	level._vote_hud_header.y = level._vote_y + bw;
	level._vote_hud_header.sort = 9001;
	level._vote_hud_header setShader("white", level._vote_width - 2*bw, eh);

	// Header text.
	level._vote_hud_header_text = newHudElem();
	level._vote_hud_header_text.archived = false;
	level._vote_hud_header_text.alignX = "center";
	level._vote_hud_header_text.alignY = "middle";
	level._vote_hud_header_text.x = level._vote_x + level._vote_width/2;
	level._vote_hud_header_text.y = level._vote_y + bw + eh/2;
	level._vote_hud_header_text.sort = 9998;
	level._vote_hud_header_text.label = header_istring;
	level._vote_hud_header_text.fontscale = 1.2;

	// Votables container.
	level._vote_hud_votables = newHudElem();
	level._vote_hud_votables.archived = false;
	level._vote_hud_votables.alpha = .125;
	level._vote_hud_votables.x = level._vote_x + bw;
	level._vote_hud_votables.y = level._vote_y + bw + eh;
	level._vote_hud_votables.sort = 9001;
	level._vote_hud_votables setShader("white", level._vote_width - 2*bw, level._vote_height - 2*bw - eh);

	// Votables.
	for (i = 0; i < istrings.size; i++) {
		// Left column.
		level._vote_hud_entry[i] = newHudElem();
		level._vote_hud_entry[i].archived = false;
		level._vote_hud_entry[i].x = level._vote_x + 3*bw;
		level._vote_hud_entry[i].y = level._vote_y + bw + eh + (i * eh);
		level._vote_hud_entry[i].sort = 9998;
		level._vote_hud_entry[i].fontScale = 1.5;
		level._vote_hud_entry[i] setText(istrings[i]);

		// Right column.
		level._vote_hud_count[i] = newHudElem();
		level._vote_hud_count[i].archived = false;
		level._vote_hud_count[i].alignX = "right";
		level._vote_hud_count[i].x = level._vote_x + level._vote_width - 3*bw;
		level._vote_hud_count[i].y = level._vote_y + bw + eh + (i * eh);
		level._vote_hud_count[i].sort = 9998;
		level._vote_hud_count[i].fontScale = 1.5;
		level._vote_hud_count[i] setValue(0);
	}

	// Clock.
	level._vote_hud_clock = newHudElem();
	level._vote_hud_clock.archived = false;
	level._vote_hud_clock.x = level._vote_x + level._vote_width/2;
	level._vote_hud_clock.y = level._vote_y - 3;
	level._vote_hud_clock.alignX = "center";
	level._vote_hud_clock.alignY = "middle";
	level._vote_hud_clock.sort = 9999;
	level._vote_hud_clock setClock(seconds, 60, "hudStopwatch", 64, 64);
}

_hud_vote_destroy()
{
	if (isDefined(level._vote_hud_cont))
		level._vote_hud_cont destroy();
	if (isDefined(level._vote_hud_header))
		level._vote_hud_header destroy();
	if (isDefined(level._vote_hud_header_text))
		level._vote_hud_header_text destroy();
	if (isDefined(level._vote_hud_votables))
		level._vote_hud_votables destroy();
	if (isDefined(level._vote_hud_clock))
		level._vote_hud_clock destroy();
	for(i = 0; i < level._vote_hud_entry.size; i++) {
		if (isDefined(level._vote_hud_entry[i])) {
			level._vote_hud_entry[i] destroy();
			level._vote_hud_count[i] destroy();
		}
	}

	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++) {
		if (isDefined(players[i]._vote_hud_indicator)) {
			players[i]._vote_hud_indicator destroy();
		}
	}
}
