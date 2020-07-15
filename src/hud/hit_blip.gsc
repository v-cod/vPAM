precache()
{
	precacheShader("gfx/hud/hud@fire_ready.tga");
}

show()
{
	if(isDefined(self._hitblip)) {
		self._hitblip destroy();
	}

	self._hitblip = newClientHudElem(self);
	self._hitblip.alignX = "center";
	self._hitblip.alignY = "middle";
	self._hitblip.x = 320;
	self._hitblip.y = 240;
	self._hitblip.alpha = 0.5;
	self._hitblip setShader("gfx/hud/hud@fire_ready.tga", 32, 32);
	self._hitblip scaleOverTime(0.15, 64, 64);

	wait 0.15;

	if(isDefined(self._hitblip)) {
		self._hitblip destroy();
	}
}
