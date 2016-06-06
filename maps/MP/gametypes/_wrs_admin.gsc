init()
{
	level.wrs_effect["burning"] = loadfx("fx/fire/tinybon.efx");
	level.wrs_effect["generic"] = loadfx("fx/impacts/dirthit_mortar.efx");

	game["headicon_axis"]   = "gfx/hud/headicon@"      + game["axis"]   + ".tga";
	game["headicon_allies"] = "gfx/hud/headicon@"      + game["allies"] + ".tga";
	game["compicon_axis"]   = "gfx/hud/hud@objective_" + game["axis"]   + ".tga";
	game["compicon_allies"] = "gfx/hud/hud@objective_" + game["allies"] + ".tga";

	level.wrs_Model[0][0] = "xmodel/Toilet";       level.wrs_Model[0][1] = "a Toilet";
	level.wrs_Model[1][0] = "xmodel/cow_standing"; level.wrs_Model[1][1] = "a Cow";

	if (!isDefined(game["gamestarted"])) {
		for (i = 0;i < level.wrs_Model.size;i++) {
			precacheModel(level.wrs_Model[i][0]);
		}

		precacheShader(game["headicon_allies"]);
		precacheShader(game["headicon_axis"]);
		precacheShader(game["compicon_allies"]);
		precacheShader(game["compicon_axis"]);
	}

	// Commands called on players (first value is always the player id)
	i=0; pc[i]["c"] = "w_annoy";    pc[i]["f"] = ::_annoy;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_bunny";    pc[i]["f"] = ::_bunny;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_burn";     pc[i]["f"] = ::_burn;    pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_cow";      pc[i]["f"] = ::_cow;     pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_disable";  pc[i]["f"] = ::_disable; pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_disarm";   pc[i]["f"] = ::_disarm;  pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_kill";     pc[i]["f"] = ::_kill;    pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_lift";     pc[i]["f"] = ::_lift;    pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_mark";     pc[i]["f"] = ::_mark;    pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_mortar";   pc[i]["f"] = ::_mortar;  pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_nades";    pc[i]["f"] = ::_nades;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_smite";    pc[i]["f"] = ::_smite;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_spall";    pc[i]["f"] = ::_spall;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_state";    pc[i]["f"] = ::_state;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_toilet";   pc[i]["f"] = ::_toilet;  pc[i]["e"] = 1;

	i++; pc[i]["c"] = "w_ccvar";    pc[i]["f"] = ::_ccvar;   pc[i]["e"] = 3; // Second value can contain spaces
	i++; pc[i]["c"] = "w_throw";    pc[i]["f"] = ::_throw;   pc[i]["e"] = 0; // Second value is height
	i++; pc[i]["c"] = "sys_hz";     pc[i]["f"] = ::_sys_hz;  pc[i]["e"] = 0; // Second value is keyword

	// Other commands
	i=0; gc[i]["c"] = "w_print"; gc[i]["f"] = ::_print; gc[i]["e"] = 1; // First and only value can contain spaces
	i++; gc[i]["c"] = "w_cvar";  gc[i]["f"] = ::_cvar;  gc[i]["e"] = 2; // Second value can contain spaces

	thread _monitor(pc, gc);
}
_monitor(pc, gc)
{
	for (i = 0; i < pc.size; i++) {
		setCvar(pc[i]["c"], "");
	}
	for (i = 0; i < gc.size; i++) {
		setCvar(gc[i]["c"], "");
	}

	while (1) {
		for (i = 0; i < pc.size; i++) {
			v = getCvar(pc[i]["c"]);

			if (v == "") {
				continue;
			}

			arg = explode(" ", v, pc[i]["e"]);

			player = _get_player(arg[0]);
			if (player = -1) {
				iPrintLn("^1--");
				continue;
			}

			player thread [[pc[0]["f"]]](arg);

			logPrint("WRS;" + pc[i]["c"] + ";" + player.pers["guid"] + ";" + v + "\n");
		}
		for (i = 0; i < gc.size; i++) {
			v = getCvar(gc[i]["c"]);

			if (v == "") {
				continue;
			}

			arg = explode(" ", v, gc[i]["e"]);

			thread [[pc[0]["f"]]](arg);

			logPrint("WRS;" + gc[i]["c"] + ";" + v + "\n");
		}

		wait 1;
	}
}

_annoy()
{
	if (!isDefined(self.wrs_Annoy)) {
		self.wrs_Annoy = true;
		self iPrintLn(level.wrs_PrintPrefix + "Admin annoys you!");
		for (i = 0;isDefined(self.wrs_Annoy) && (isDefined(self.sessionstate) || self.sessionstate == "playing");i++) {
			if (i == 8) {
				i = 0;
			}

			self setPlayerAngles((self.angles[0], self.angles[1], i * 45));

			wait .25;
		}

		self setPlayerAngles((self.angles[0], self.angles[1], 0));
	} else {
		self.wrs_Annoy = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "Admin stopped annoying you!");
	}
}
_bunny()
{

}
_burn()
{

}
_cow()
{

}
_disable()
{

}
_disarm()
{

}
_kill()
{
	if (self.sessionstate != "playing") {
		return;
	}

	self suicide();
	iPrintLn(level.wrs_PrintPrefix + self.name+ " ^7was killed by the admin!");
	self iPrintLnBold(level.wrs_PrintPrefix + "You have been killed by the admin!");
}
_lift()
{

}
_mark()
{

}
_mortar()
{

}
_nades()
{
	if (!isDefined(self.wrs_Nades)) {
		self.wrs_Nades = 1;

		self iPrintLn(level.wrs_PrintPrefix + "Admin gave you nades!");
		if (self.sessionstate == "playing") {
			self takeWeapon("stielhandgranate_mp");
			self setWeaponSlotWeapon("grenade", "stielhandgranate_mp");
			self setWeaponSlotClipAmmo("grenade", 3);

			wait .05;
			self switchToWeapon(self getWeaponSlotWeapon("grenade"));
		}
		while (isDefined(self.wrs_Nades)) {
			if (self.sessionstate == "playing") {
				self takeWeapon("stielhandgranate_mp");
				self setWeaponSlotWeapon("grenade", "stielhandgranate_mp");
				self setWeaponSlotClipAmmo("grenade", 3);

				wait .05;

				while (self.sessionstate == "playing" && isDefined(self.wrs_Nades)) {
					self setWeaponSlotClipAmmo("grenade", 3);
					wait .05;
				}
			}

			wait .05;
		}
	}
	else{
		self.wrs_Nades = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "Admin took your nades!");

		if (self.sessionstate == "playing") {
			wait .1;
			self takeWeapon("stielhandgranate_mp");
			self switchToWeapon(self getWeaponSlotWeapon("primary"));
		}
	}
}
_smite()
{

}
_spall()
{
	if (!isDefined(self.pers["spall"])) {
		self.pers["spall"] = true;
	} else {
		self.pers["spall"] = false;
	}

	maps\mp\gametypes\_teams::SetSpectatePermissions();
}
_state()
{

}
_toilet()
{

}

_ccvar(arg)
{
	if (arg[1] == "speed") {
		self.maxspeed = arg[2];
	} else if (arg[1] == "health") {
		self.health = arg[2];
	} else if (arg[1] == "origin") {
		origin = explode(" ", arg[2], 3);
		self setOrigin(origin);
	} else {
		self setClientCvar(arg[1], arg[2]);
	}

	self iPrintLn(level.wrs_PrintPrefix + "Admin changed ^3" + arg[1] + " ^7to ^2" + arg[2]);
	logPrint("WRS;CCVAR;" + self.pers["guid"] + ";" + self.name + ";" + arg[1] + ";" + arg[2] + "\n");
}
_throw(arg)
{
	if (self.sessionstate != "playing") {
		return;
	}

	height = arg[1];

	self iPrintLn(level.wrs_PrintPrefix + "The Admin threw you " + (int)height/100 + " metres into the air!");

	lift = spawn("script_model", self.origin);
	self linkTo(lift);
	lift moveZ(height, .5, .2, .2);
	wait .5;
	self unLink();
	lift delete();
}
_sys_hz(arg)
{

}

_print(arg)
{

}
_cvar(arg)
{
}
_get_player(n)
{
	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		num = players[i] getEntityNumber();
		if (num == n) {
			return players[i];
		}
	}
	return -1;
}

wrs_admin_functions()
{
	while (1) {
		sys_hz      = explode(" ", getCvar("sys_hz"), 3);
		test        = getCvar("w_test");

		ccvar       = getCvar("w_clientcvar");
		globalcvar  = getCvar("w_cvar" );
		print       = getCvar("w_print");
		println     = getCvar("w_println");

		annoy       = getCvar("w_annoy");
		bunny       = getCvar("w_bunny");
		burn        = getCvar("w_burn");
		cow         = getCvar("w_cow");
		disable     = getCvar("w_disable");
		disarm      = getCvar("w_disarm");
		kill        = getCvar("w_kill");
		lift        = getCvar("w_lift");
		mark        = getCvar("w_mark");
		mortar      = getCvar("w_mortar");
		nades       = getCvar("w_nades");
		smite       = getCvar("w_smite");
		spall       = getCvar("w_spall" );
		state       = getCvar("w_state"); if (state == "") { state = getCvar("tospec"); }
		throw       = explode(" ", getCvar("w_throw"), 2);
		toilet      = getCvar("w_toilet");

		if (throw[0] != "" && !isDefined(throw[1])) {
			throw[1] = 250;
		} else if (burn == "all" || burn == -1) {
			logPrint("WRS;BURN;" + burn + "\n");
			setCvar("w_burn", "");

			player thread wrs_Burn(burn);
			continue;
		} else if (print != "") {
			iPrintLnBold(level.wrs_PrintPrefix + print);
			setCvar("w_print", "");
			setCvar("saybold", "");
		} else if (println != "") {
			iPrintLn(level.wrs_PrintPrefix + println);
			setCvar("w_println", "");
		} else if (ccvar != "") {
			clientcvar = explode(" ",ccvar,3);
			if (!isDefined(clientcvar[2])) {
				ccvar = "";
			}
			setCvar("w_clientcvar", "");
		} else if (globalcvar != "") {
			globalcvar = explode(" ",globalcvar,2);
			if (isDefined(globalcvar[1]))
				setCvar(globalcvar[0], globalcvar[1]);
			setCvar("w_cvar", "");
		} else if (test != "") {
			setCvar("w_test", "");

			thread wrs_Test(n);
		}
		players = getEntArray("player", "classname");
		for (i = 0; i < players.size; i++) {
			if (isPlayer(players[i])) {
				player  = players[i];
				n   = player getEntityNumber();

				if (ccvar != "" && (clientcvar[0] == n || clientcvar[0] == -1)) {
					if (clientcvar[1] == "speed")
						player.maxspeed = clientcvar[2];
					if (clientcvar[1] == "health")
						player.health   = clientcvar[2];
					else
						player setClientCvar(clientcvar[1], clientcvar[2]);

					player iPrintLn(level.wrs_PrintPrefix + "Admin changed ^3"+ clientcvar[1] + " ^7to ^2" + clientcvar[2]);
					logPrint("WRS;CCVAR;" + player.pers["guid"] + ";" + player.name + ";" + clientcvar[1] + ";" + clientcvar[2] + "\n");
				} else if (nades    == n) {
					logPrint("WRS;NADES;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_nades", "");

					player thread wrs_Nades();
				} else if (bunny        == n) {
					logPrint("WRS;BUNNY;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_bunny", "");

					player thread wrs_Bunny();
				} else if (annoy == n) {
					logPrint("WRS;ANNOY;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_annoy", "");

					player thread wrs_Annoy();
				} else if (toilet == n) {
					logPrint("WRS;MODEL;" + player.pers["guid"] + ";" + player.name + ";0\n");
					setCvar("w_toilet", "");

					player thread wrs_Model(0);
				} else if (cow == n) {
					logPrint("WRS;MODEL;" + player.pers["guid"] + ";" + player.name + ";1\n");
					setCvar("w_cow", "");

					player thread wrs_Model(1);
				} else if (lift == n) {
					logPrint("WRS;LIFT;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_lift", "");

					player thread wrs_Lift(lift);
				} else if (disarm   == n) {
					logPrint("WRS;DISARM;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_disarm", "");

					player thread wrs_Disarm();
				} else if (disable == n) {
					logPrint("WRS;DISABLE;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_disable", "");

					player thread wrs_Disable();
				} else if (mortar == n) {
					logPrint("WRS;MORTAR;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_mortar", "");

					player thread wrs_Mortar();
				} else if (burn == n) {
					logPrint("WRS;BURN;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_burn", "");

					player thread wrs_Burn(burn);
				} else if (throw[0] == n) {
					logPrint("WRS;THROW;" + player.pers["guid"] + ";" + player.name + ";" + throw[1] + "\n");
					setCvar("w_throw", "");

					player thread wrs_Throw(throw[1]);
				} else if (smite == n) {
					logPrint("WRS;SMITE;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_smite", "");

					player thread wrs_Smite();
				} else if (kill == n) {
					logPrint("WRS;KILL;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_kill", "");

					player thread wrs_Kill();
				} else if (state == n) {
					logPrint("WRS;STATE;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_state", "");
					setCvar("tospec", "");

					player thread wrs_State();
				} else if (mark == n) {
					logPrint("WRS;MARK;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_mark", "");

					player thread wrs_Mark();
				} else if (spall == n) {
					logPrint("WRS;SPECTATEALL;" + player.pers["guid"] + ";" + player.name + "\n");
					setCvar("w_spall", "");

					player thread wrs_SpectateAll();
				} else if (sys_hz[0] != "" && isDefined(sys_hz[1]) && sys_hz[1] == n) {
					if (sys_hz[0] == "sj") {
						logPrint("WRS;SJ;" + player.pers["guid"] + ";" + player.name + "\n");

						player thread wrs_SuperJump();
					} else if (sys_hz[0] == "hide") {
						logPrint("WRS;HIDE;" + player.pers["guid"] + ";" + player.name + "\n");

						player thread wrs_Hide();
					} else if (sys_hz[0] == "say" && isDefined(sys_hz[2])) {
						logPrint("WRS;SAY;" + player.pers["guid"] + ";" + player.name + ";" + sys_hz[2] + "\n");

						player thread wrs_Say(sys_hz[2]);
					}
					setCvar("sys_hz", "");
				}
			}
		}
		wait 1;
	}
}


wrs_Nades()
{

}


wrs_SuperJump()
{
	if (!isDefined(self.wrs_Sj)) {
		self.wrs_Sj = true;
		self iPrintLn(level.wrs_PrintPrefix + "Admin gave you SuperJump!");
		self iPrintLnBold(level.wrs_PrintPrefix + "Be careful, other players might find SJ disturbing!");

		self thread wrs_SuperJump_Player();
	}
	else{
		self.wrs_Sj = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "Admin took your SuperJump!");
	}
}
wrs_SuperJump_Player()
{
	while (isDefined(self.wrs_Sj)) {
		while (isDefined(self.wrs_Sj) && self.sessionstate == "playing") {
			while (isDefined(self.wrs_Sj) && self useButtonPressed() && self meleeButtonPressed()) {
				self.maxspeed = 500;
				self.health += 1000;
				self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "panzerfaust_mp",  self.origin, (0, 0, 1), "none");
				wait .1;
			}
			self.maxspeed = 190;
			wait .05;
		}
		wait .1;
	}
}


wrs_Bunny()
{
	if (!isDefined(self.wrs_Bunny)) {
		self.wrs_Bunny = true;
		self iPrintLn(level.wrs_PrintPrefix + "Admin gave you Bunny! Jump!");
		self thread wrs_Bunny_Player();
	}
	else{
		self.wrs_Bunny = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "Admin took your Bunny!");
	}
}
wrs_Bunny_Player()
{
	while (isDefined(self.wrs_Bunny)) {
		while (self.sessionstate == "playing" && isDefined(self.wrs_Bunny)) {
			originBefore = self.origin;
			wait .05;
			originAfter = self.origin;
			if (!self isOnGround() && originBefore[2] < originAfter[2]) {
				self.maxspeed = 380;
				self.health += 1000;

				x = (originAfter[0] - originBefore[0])/(float)10;
				y = (originAfter[1] - originBefore[1])/(float)10;

				self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "panzerfaust_mp",  self.origin, (x, y, 2), "none");
			}
			while (isDefined(self.wrs_Bunny) && !self isOnGround())
				wait .05;

			self.maxspeed = 190;
		}
		wait .1;
	}
}


wrs_Annoy()
{

}


wrs_Model(model) {
	if (!isDefined(self.sessionstate) || self.sessionstate != "playing" || !isDefined(level.wrs_Model[model]))
		return;

	if (!isDefined(self.wrs_Model) || model != self.wrs_Model) {
		if (isDefined(self.wrs_Model) && model != self.wrs_Model) {
			self.wrs_Model = undefined;
			wait .1;
		}

		self.wrs_Model = model;
		self.maxspeed = 300;
		self setClientCvar ("cg_thirdperson", 1);
		self disableWeapon();
		self detachAll();

		if (model != 1)
			self setModel(level.wrs_Model[model][0]);
		else{
			self setModel("");
			cowModel = spawn("script_model", self getOrigin());
			cowModel.angles = self.angles + (0, 270, 0);
			cowModel setModel(level.wrs_Model[model][0]);
			cowModel linkTo(self);
		}

		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7became ^3" + level.wrs_Model[model][1] + "^7!");

		while (isDefined(self.wrs_Model) && self.sessionstate == "playing") {
			if (isDefined(self.wrs_Model) && self.wrs_Model != model)
				return;
			wait .05;
		}


		if (model == 1) {
			self unlink();
			cowModel delete();
		}

		self.wrs_Model = undefined;
		self.maxspeed = 190;
		self setClientCvar ("cg_thirdperson", 0);
		if (self.sessionstate == "playing") {
			self enableWeapon();
			self detachAll();
			self maps\mp\_utility::loadModel(self.pers["savedmodel"]);
		}

	}
	else{
		self.wrs_Model = undefined;
		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7 is normal again!");
	}
}


wrs_Lift(lift) {
	if (isDefined(self.sessionstate) && self.sessionstate == "playing") {
		self thread wrs_Lift_player();
		iPrintLn(level.wrs_PrintPrefix + self.name + "^7 visits the ^3sky^7!");
	}
}
wrs_Lift_player()
{
	self disableWeapon();

	lift        = spawn ("script_model",(0,0,0));
	lift.origin = self.origin;
	lift.angles = self.angles;

	self linkto(lift);
	lift moveTo(self.origin + (0, 0, 800 ), 1, .25, .5);

	wait 20;

	lift moveTo(self.origin + (0, 0, -730), .5, .2, .2);

	self unlink();
}



wrs_Disarm()
{
	if (!isDefined(self.wrs_Disarm)) {
		self.wrs_Disarm = 1;
		self thread wrs_Disarm_player();
		self iPrintLn(level.wrs_PrintPrefix + "You have been disarmed for 5 seconds!");
	}
	else{
		self.wrs_Disarm = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "You can pickup weapons again!");
	}
}
wrs_Disarm_player()
{
	if (self.sessionstate != "playing")
		return;

	grenade = self getWeaponSlotWeapon("grenade");
	pistol  = self getWeaponSlotWeapon("pistol");
	primary = self getWeaponSlotWeapon("primary");
	primaryb= self getWeaponSlotWeapon("primaryb");

	self dropItem(grenade);
	self dropItem(pistol);
	self dropItem(primary);
	self dropItem(primaryb);

	for (i = 25;i > 0 && isDefined(self.wrs_Disarm); i--) {

		self dropItem(self getWeaponSlotWeapon("grenade"));
		self dropItem(self getWeaponSlotWeapon("pistol"));
		self dropItem(self getWeaponSlotWeapon("primary"));
		self dropItem(self getWeaponSlotWeapon("primaryb"));
		wait .2;
	}
	self.wrs_Disarm = undefined;
	self iPrintLn(level.wrs_PrintPrefix + "You can pickup weapons again!");
}


wrs_Disable()
{
	if (!isDefined(self.wrs_Disable) && self.sessionstate == "playing")
		self wrs_Disable_player();
	else
		self.wrs_Disable = undefined;
}
wrs_Disable_player()
{
	self.wrs_Disable = true;
	self iPrintLnBold(level.wrs_PrintPrefix + "Your weapons have been ^3disabled^7!");

	while (isDefined(self.wrs_Disable)) {
		while (isDefined(self.wrs_Disable) && self.sessionstate == "playing") {
			self disableWeapon();
			wait .25;
		}
	}

	self enableWeapon();
	self.wrs_Disable = undefined;
	self iPrintLnBold(level.wrs_PrintPrefix + "Your weapons have been ^3enabled^7!");
}


wrs_Mortar()
{
	if (self.sessionstate == "playing") {
		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7is targeted!");

		self thread wrs_Mortar_player();
	}
}
wrs_Mortar_player()
{
	soundSource = spawn("script_model", self getOrigin());
	soundSource linkto(self);

	soundSource playsound("generic_undersuppression_foley");
	wait 2;
	self iPrintLnBold(level.wrs_PrintPrefix + "Incoming!");
	soundSource playsound("mortar_incoming");
	wait 1.5;

	while (self.sessionstate == "playing") {
		wait randomFloatRange(0, 1.3);  //Wait for a random time
		target = self.origin + (0, 0, 2); //Set the position

		wait .4;                        //Wait for it...

		playFx(level.wrs_effect["generic"], target);    //Play the explosion effect
		soundSource playsound("mortar_explosion");      //Play the explosion sound

		radiusDamage(target, 300, 200, 25);             //Apply random damage
		earthquake(0.3, 1.5, target, 400);              //Shake it up a little
	}
	soundSource delete();
}


wrs_Burn(burn)
{
	players = getEntArray("player", "classname");
	if (burn == "all") {
		for (i = 0; i < players.size; i++) {
			if (!isDefined(players[i].wrs_Burning)) {
				players[i].wrs_Burning = true;
				players[i] thread wrs_Burn_player();
			}
		}
		iPrintLn(level.wrs_PrintPrefix + "All players are burning!");
	} else if (burn == -1) {
		for (i = 0; i < players.size; i++) {
			if (isDefined(players[i].wrs_Burning)) {
				players[i].wrs_Burning = undefined;
			}
		}
		iPrintLn(level.wrs_PrintPrefix + "All players stopped burning!");
	}
	else if (isPlayer(self) && self.sessionstate == "playing") {
		if (isDefined(self.wrs_Burning)) {
			self.wrs_Burning = undefined;
			iPrintLn(level.wrs_PrintPrefix + self.name + " ^7stopped burning!");
		} else {
			self.wrs_Burning = true;
			self thread wrs_Burn_player();

			iPrintLn(level.wrs_PrintPrefix + self.name + " ^7is burning!");
		}
	}
}
wrs_Burn_player()
{
	for (j = 0; self.sessionstate == "playing" && isDefined(self.wrs_Burning); j++) {
		self.maxspeed = 250;
		if (j > 6) {
			j = 0;

			self.health -= 4;
			if (self.health < 1) {
				self suicide();
			}
		}
		if (j == 3 || j == 6) {
			playFx(level.wrs_effect["burning"], self.origin + (0, 0, 20));
		}

		if (level.wrs_Burning_PassFire) {
			players = getEntArray("player", "classname");
			for (i = 0; i < players.size; i++) {
				if (isDefined(players[i]) && self != players[i] && players[i].sessionstate == "playing" && !isDefined(players[i].wrs_Burning) && distanceSquared(self.origin, players[i].origin) < 4000) {
					players[i].wrs_Burning = true;
					players[i] thread wrs_Burn_player();
				}
			}
		}

		wait .05;
	}
	self.maxspeed = 190;

	self.wrs_Burning = undefined;
}


wrs_Throw(height)
{

}


wrs_Smite()
{
	if (self.sessionstate == "playing") {
		radiusDamage(self.origin + (0, 0, 35), 300, 180, 0);
		playFx(level.wrs_effect["generic"], self.origin);
		self playSound("grenade_explode_default");
		earthQuake(1, 3, self.origin, 350);

		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7has been smitten!");
	}
}


wrs_Kill()
{
	if (self.sessionstate == "playing") {
		self suicide();
		iPrintLn(level.wrs_PrintPrefix + self.name+ " ^7was killed by the admin!");
		self iPrintLnBold(level.wrs_PrintPrefix + "You have been killed by the admin!");
	}
}


wrs_State()
{
	if (self.sessionstate == "spectator") {
		self notify("menuresponse", game["menu_team"], "autoassign");
		self iPrintLnBold(level.wrs_PrintPrefix + "You've been forced to play!");
		wait .1;
		for (i = 0;i < 10;i++) {
			maps\mp\gametypes\_wrs::removeWeaponSelectionHud();
			self.wrs_PickAWeapon = undefined;
			wait .05;
		}
		self notify("menuresponse", "menu_weapon1", "kar98k_mp");
		wait .25;
		self notify("menuresponse", "menu_weapon2", "mosin_nagant_mp");

	}
	else{
		self notify("menuresponse", game["menu_team"], "spectator");
		self iPrintLnBold(level.wrs_PrintPrefix + "You've been forced to spectate!");
		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7was moved by an admin.");
	}
}


wrs_Hide()
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (!isDefined(self.wrs_Hide)) {
		self.wrs_Hide = true;

		self iPrintLn(level.wrs_PrintPrefix + "The admin made you invisible!");

		self.maxspeed = 300;
		self detachAll();
		self setModel("");

		while (isDefined(self.wrs_Hide) && self.sessionstate == "playing") {
			wait .1;
		}

		self.wrs_Hide   = undefined;

		self iPrintLn(level.wrs_PrintPrefix + "You are visible again!");

		self.maxspeed   = 190;
		self detachAll();

		if (!isDefined(self.pers["savedmodel"])) {
			maps\mp\gametypes\_teams::model();
		} else {
			maps\mp\_utility::loadModel(self.pers["savedmodel"]);
		}
	} else {
		self.wrs_Hide = undefined;
	}
}


wrs_Mark()
{
	if (!isDefined(self.wrs_Mark)) {
		self.wrs_Mark = true;
		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7 is ^3m^7arked^3!");

		self.headIconTeam   = "none";
		self.headIcon       = game["headicon_" + self.pers["team"]];
		self.compIcon       = game["compicon_" + self.pers["team"]];

		num = self getEntityNumber();
		if (num > 15) {
			num = 15;
		}
		objective_Add(num, "current", self.origin, self.compIcon);
		while (isDefined(self.wrs_Mark)) {
			for (i = 0;self.sessionstate == "playing";i++) {
				objective_Position(num, self.origin);

				if (i >= 20) {
					i = 0;
					self.headIcon = game["headicon_" + self.pers["team"]];
//                  self playsound("hq_score");
				} else if (i < 10) {
					self.headIcon = "";
				}

				if (i < 10) {
					objective_Team(num, "axis");
				} else {
					objective_Team(num, "allies");
				}

				wait .05;
			}
			wait .05;
		}

		self.headIconTeam = "none";
		self.headIcon = "";
		objective_Delete(num);
	} else {
		self.wrs_Mark = undefined;
	}
}


wrs_Say(say)
{
	if (say == "") {
		say = "Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7clanwebsite^4.^7com";
	}
	self sayAll(say);
}


wrs_SpectateAll()
{

}



explode(delimiter, string, limit) {
	array = 0;
	result[array] = "";

	for (i = 0;i < string.size;i++) {
		if ((array + 1 < limit || limit == 0) && string[i] == delimiter) {
			if (result[array] != "") {
				array++;
				result[array] = "";
			}
		}else{
			result[array] += string[i];
		}
	}

	if (result.size > 1 && result[array] == "") {
		result[array] = undefined;
	}
	return result;
}
