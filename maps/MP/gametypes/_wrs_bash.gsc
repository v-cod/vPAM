_monitor()
{
	sprintLeft = level.wrs_sprint_ticks;
	recovertime = 0;

	self.wrs_sprintHud_bg = newClientHudElem(self);
	self.wrs_sprintHud_bg setShader("gfx/hud/hud@health_back.dds", 128 + 2, 5);
	self.wrs_sprintHud_bg.alignX = "left";
	self.wrs_sprintHud_bg.alignY = "top";
	self.wrs_sprintHud_bg.x = 488 + 13;
	self.wrs_sprintHud_bg.y = 454;

	self.wrs_sprintHud = newClientHudElem(self);
	self.wrs_sprintHud setShader("gfx/hud/hud@health_bar.dds", 128, 3);
	self.wrs_sprintHud.color = (0, 0, 1);
	self.wrs_sprintHud.alignX = "left";
	self.wrs_sprintHud.alignY = "top";
	self.wrs_sprintHud.x = 488 + 14;
	self.wrs_sprintHud.y = 455;

	// Prevent sprint glitch on SD
	while (self.sessionstate == "playing" && self attackButtonPressed() == true) {
		wait .05;
	}

	while (self.sessionstate == "playing") {
		oldOrigin = self.origin;
		wait .1;
		if (self.sessionstate != "playing") {
			break;
		}

		//The amount of sprint left, a float from 0 to 1
		sprint = (float)(level.wrs_sprint_ticks - sprintLeft) / level.wrs_sprint_ticks;

		if (!isDefined(self.wrs_sprintHud)) {
			self.maxspeed = 190;
			break;
		}
		hud_width = (1.0 - sprint) * 128;   //The width should be as wide as there is left
		if (hud_width > 0) {                 //Minimum of one, so you can see a red pixel.
			self.wrs_sprintHud setShader("gfx/hud/hud@health_bar.dds", hud_width, 3); //Set the shader to the width we just determined.
		} else {
			self.wrs_sprintHud setShader("");
		}

		//The player should have moved, have some 'stamina' left, pressed the button and he should be standing.
		if (sprintLeft > 0 && self useButtonPressed() && oldOrigin != self.origin && ( level.wrs_sprint & self _get_stance(1) ) ) {
			if (!isDefined(self.wrs_sprinting)) { //The player didn't sprint yet.
				self.maxspeed = level.wrs_sprint_speed;    //Set the speed to the sprint speed.
				self.wrs_sprinting = true;
			}
			self disableWeapon();   //Some people found a way to have their weapon enabled why sprinting, maybe this prevents that?
			sprintLeft--;
		}
		else{   //He didn't do shit
			if (isDefined(self.wrs_sprinting)) {
				self.maxspeed = 190;
				self enableWeapon();
				self.wrs_sprinting = undefined;
				recovertime = level.wrs_sprint_recover_ticks;
				if (sprintLeft > 0) {
					recovertime = (int)(recovertime * sprint + 0.5);
				}
			}
			if (sprintLeft < (level.wrs_sprint_ticks) && !self useButtonPressed()) {
				if (recovertime > 0) {
					recovertime--;
				} else {
					sprintLeft++;
				}
			}
		}
	}
	if (isDefined(self.wrs_sprintHud)) {
		self.wrs_sprintHud destroy();
	}
	if (isDefined(self.wrs_sprintHud_bg)) {
		self.wrs_sprintHud_bg destroy();
	}
}
