minefields()
{
	minefields = getentarray("minefield", "targetname");
	if (minefields.size > 0)
	{
		level._effect["mine_explosion"] = loadfx ("fx/impacts/newimps/minefield.efx");
	}
	
	for(i = 0; i < minefields.size; i++)
	{
		minefields[i] thread minefield_think();
	}	
}

minefield_think()
{
	// WRS
	if (isDefined(self.squaredradius)) {
		self thread minefield_trigger();
	}
	
	while (1)
	{
		self waittill ("trigger",other);
		
		if(isPlayer(other))
			other thread minefield_kill(self);
	}
}

// WRS
minefield_trigger()
{
	while (true) {
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++) {
			if (distanceSquared(players[i].origin, self.origin) < self.squaredradius) {
				self notify("trigger", players[i]);
			}
		}
		wait .5;
	}
}

minefield_kill(trigger)
{
	if(isDefined(self.flag))
		return;
		
	self.flag = true;
	self playsound ("minefield_click");

	wait(.5);
	wait(randomFloat(.5));

	// WRS
	if(self istouching(trigger) || (isDefined(trigger.squaredradius) && distanceSquared(self.origin, trigger.origin) < trigger.squaredradius))
	{
		origin = self getorigin();
		org = self.origin;
		range = 4;
		maxdamage = 2000;
		mindamage = 50;
		
		playfx ( level._effect["mine_explosion"], origin);
		radiusDamage(origin, range, maxdamage, mindamage);
		level thread playSoundinSpace ("explo_mine", org);
	}
	self.flag = undefined;
}

playSoundinSpace (alias, origin)
{
	org = spawn ("script_model",origin);
	wait 0.05;
	org playsound (alias);
	wait 6;
	org delete();
}