set()
{
	if (isDefined(level.drawfriend) && level.drawfriend && self.pers["team"] != "spectator") {
		self.headiconteam = self.pers["team"];
	} else {
		self.headiconteam = "none";
	}

	if (self.sessionstate != "playing" && self.sessionteam != "spectator") {
		self.statusicon = "gfx/hud/hud@status_dead.tga";
		self.headicon = "";
	} else {
		self.statusicon = "";
		if (self.pers["team"] == "allies" || self.pers["team"] == "axis") {
			self.headicon = game["headicon_" + self.pers["team"]];
		}
	}

	// Overwrite ready players with star icons.
	if (level.p_readying && isDefined(self.p_ready) && self.p_ready) {
		self.statusicon = game["_hud_icon_ready"];
		self.headicon = game["_hud_icon_ready"];
		// self.headiconteam = "none"; // Show everyone someone's ready.
	}
}
