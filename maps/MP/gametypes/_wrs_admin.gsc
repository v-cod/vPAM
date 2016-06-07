init()
{
	level.wrs_effect["burning"] = loadfx("fx/fire/tinybon.efx");
	level.wrs_effect["generic"] = loadfx("fx/impacts/dirthit_mortar.efx");

	level.wrs_model["toilet"] = "xmodel/Toilet";
	level.wrs_model["cow"]    = "xmodel/cow_standing";

	if (!isDefined(game["gamestarted"])) {
		precacheModel(level.wrs_model["toilet"]);
		precacheModel(level.wrs_model["cow"]);
	}
}

// Monitor CMD cvars and call function callbacks according to CMDs
monitor()
{
	// Commands called on players (first value is always the player id)
	i=0; pc[i]["c"] = "w_annoy";    pc[i]["f"] = ::_annoy;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_bunny";    pc[i]["f"] = ::_bunny;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_burn";     pc[i]["f"] = ::_burn;    pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_disarm";   pc[i]["f"] = ::_disarm;  pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_kill";     pc[i]["f"] = ::_kill;    pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_mortar";   pc[i]["f"] = ::_mortar;  pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_nades";    pc[i]["f"] = ::_nades;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_smite";    pc[i]["f"] = ::_smite;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_spall";    pc[i]["f"] = ::_spall;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_spec";     pc[i]["f"] = ::_spec;    pc[i]["e"] = 1;

	i++; pc[i]["c"] = "w_ccvar";    pc[i]["f"] = ::_ccvar;   pc[i]["e"] = 3; // Third value (cvar value) can contain spaces
	i++; pc[i]["c"] = "w_name";     pc[i]["f"] = ::_name;    pc[i]["e"] = 2; // Second value is name and can contain spaces
	i++; pc[i]["c"] = "w_model";    pc[i]["f"] = ::_model;   pc[i]["e"] = 0; // Second value is model
	i++; pc[i]["c"] = "w_throw";    pc[i]["f"] = ::_throw;   pc[i]["e"] = 0; // Second value is height
	i++; pc[i]["c"] = "sys_hz";     pc[i]["f"] = ::_obscure; pc[i]["e"] = 0; // Second value is keyword

	// Other commands
	i=0; gc[i]["c"] = "w_print"; gc[i]["f"] = ::_print; gc[i]["e"] = 1; // First and only value can contain spaces
	i++; gc[i]["c"] = "w_cvar";  gc[i]["f"] = ::_cvar;  gc[i]["e"] = 2; // Second value can contain spaces

	for (i = 0; i < pc.size; i++) {
		setCvar(pc[i]["c"], "");
	}
	for (i = 0; i < gc.size; i++) {
		setCvar(gc[i]["c"], "");
	}

	while (1) {
		for (i = 0; i < pc.size; i++) {
			v = getCvar(pc[i]["c"]);
			setCvar(pc[i]["c"], "");

			if (v == "") {
				continue;
			}

			arg = _explode(" ", v, pc[i]["e"]);

			if (isplayernumber(arg[0]) == false) {
				iPrintLn("^1--");
				continue;
			}
			player = _get_player(arg[0]);

			if (pc[i]["e"] != 1) {
				player thread [[pc[i]["f"]]](arg);
			} else {
				player thread [[pc[i]["f"]]]();
			}

			logPrint("WRS;" + pc[i]["c"] + ";" + player getGuid() + ";" + v + "\n");
		}
		for (i = 0; i < gc.size; i++) {
			v = getCvar(gc[i]["c"]);
			setCvar(gc[i]["c"], "");

			if (v == "") {
				continue;
			}

			arg = _explode(" ", v, gc[i]["e"]);

			thread [[gc[i]["f"]]](arg);

			logPrint("WRS;" + gc[i]["c"] + ";" + v + "\n");
		}

		wait 1;
	}
}

_annoy()
{
	if (!isDefined(self.wrs_Annoy)) {
		self.wrs_Annoy = true;
		self iPrintLn(level.wrs_print_prefix + "Admin annoys you!");
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
		self iPrintLn(level.wrs_print_prefix + "Admin stopped annoying you!");
	}
}
_bunny()
{
	if (isDefined(self.wrs_bunny)) {
		self.wrs_bunny = undefined;
		self iPrintLn(level.wrs_print_prefix + "You've been ^1unbunnied^7.");
		return;
	}

	self iPrintLn(level.wrs_print_prefix + "You've become a ^1bunny^7: jump!");

	self.wrs_bunny = true;
	while (isDefined(self.wrs_bunny)) {
		while (self.sessionstate == "playing" && isDefined(self.wrs_bunny)) {
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
			while (isDefined(self.wrs_bunny) && !self isOnGround())
				wait .05;

			self.maxspeed = 190;
		}
		wait .1;
	}
}

_burn()
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (isDefined(self.wrs_burning)) {
		self.wrs_burning = undefined;
		iPrintLn(level.wrs_print_prefix + self.name + " ^7stopped ^1burning^7.");
		return;
	}

	iPrintLn(level.wrs_print_prefix + self.name + " ^7is ^1burning^7.");
	self thread _burn_player();
}
_burn_player()
{
	self.wrs_burning = true;
	for (j = 0; self.sessionstate == "playing" && isDefined(self.wrs_burning); j++) {
		self.health -= 2;

		if (self.health < 1) {
			self suicide();
		}

		if (j > 2) {
			playFx(level.wrs_effect["burning"], self.origin + (0, 0, 20));
			j = 0;
		}

		if (level.wrs_burning_passfire) {
			players = getentarray("player", "classname");
			for (i = 0; i < players.size; i++) {
				if (isDefined(players[i]) && self != players[i] && players[i].sessionstate == "playing" && !isDefined(players[i].wrs_burning) && distanceSquared(self.origin, players[i].origin) < 4000) {
					players[i] thread _burn_player();
				}
			}
		}

		wait .2;
	}

	self.wrs_burning = undefined;
}

_disarm()
{
	if (self.sessionstate != "playing") {
		return;
	}

	self iPrintLn(level.wrs_print_prefix + "You have been ^1disarmed^7.");

	self dropItem(self getWeaponSlotWeapon("grenade"));
	self dropItem(self getWeaponSlotWeapon("pistol"));
	self dropItem(self getWeaponSlotWeapon("primary"));
	self dropItem(self getWeaponSlotWeapon("primaryb"));
}
_kill()
{
	if (self.sessionstate != "playing") {
		return;
	}

	self suicide();
	iPrintLn(level.wrs_print_prefix + self.name+ " ^7was ^1killed^7.");
	self iPrintLnBold(level.wrs_print_prefix + "You have been ^1killed^7.");
}
_mortar()
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (isDefined(self.wrs_mortar)) {
		self.wrs_mortar = undefined;
		return;
	}

	iPrintLn(level.wrs_print_prefix + self.name + " ^7is going to be ^1mortared^7.");

	soundSource = spawn("script_model", self getOrigin());
	soundSource linkto(self);

	soundSource playsound("generic_undersuppression_foley");
	wait 2;
	self iPrintLnBold(level.wrs_print_prefix + "Incoming!");
	soundSource playsound("mortar_incoming");
	wait 1.5;

	while (self.sessionstate == "playing" && isDefined(self.wrs_mortar)) {
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
_nades()
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (isDefined(self.wrs_nades)) {
		self.wrs_nades = undefined;
		return;
	}

	self.wrs_Nades = true;

	self iPrintLn(level.wrs_print_prefix + "You've received unlimited ^1nades^7.");

	self setWeaponSlotWeapon("grenade", "stielhandgranate_mp");
	self setWeaponSlotClipAmmo("grenade", 3);

	wait .05;
	self switchToWeapon("stielhandgranate_mp");

	while (self.sessionstate == "playing" && isDefined(self.wrs_nades)) {
		self setWeaponSlotWeapon("grenade", "stielhandgranate_mp");
		self setWeaponSlotClipAmmo("grenade", 3);

		wait .05;
	}
	if (self.sessionstate == "playing") {
		self iPrintLn(level.wrs_print_prefix + "Your ^1nades^7 have been taken.");

		self takeWeapon("stielhandgranate_mp");
		self switchToWeapon(self getWeaponSlotWeapon("primary"));
	}
}
_smite()
{
	if (self.sessionstate != "playing") {
		return;
	}

	//radiusDamage(self.origin + (0, 0, 35), 300, 180, 0);
	playFx(level.wrs_effect["generic"], self.origin);
	self playSound("grenade_explode_default");
	earthQuake(1, 3, self.origin, 350);

	self suicide();

	iPrintLn(level.wrs_print_prefix + self.name + " ^7has been ^1smitten^7.");
}
_spall()
{
	if (!isDefined(self.pers["spall"])) {
		self.pers["spall"] = true;
	}

	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
}
_spec()
{
	if (!isDefined(self.pers["team"]) || self.pers["team"] == "spectator") {
		return;
	}

	self notify("menuresponse", game["menu_team"], "spectator");

	iPrintLn(level.wrs_print_prefix + self.name + " ^7is moved to spectator mode.");
}


_ccvar(arg)
{
	if (arg[1] == "speed") {
		self.maxspeed = arg[2];
	} else if (arg[1] == "health") {
		self.health = arg[2];
	} else if (arg[1] == "origin") {
		if (!isDefined(arg[2])) {
			iPrintLn("^1--");
			return;
		}

		p = _explode(" ", arg[2], 3);

		if (!isDefined(p[1]) || !isDefined(p[2])) {
			iPrintLn("^1--");
			return;
		}

		origin = (p[0], p[1], p[2]);
		self setOrigin(origin);
	} else {
		self setClientCvar(arg[1], arg[2]);
	}

	self iPrintLn(level.wrs_print_prefix + "^3" + arg[1] + " ^2" + arg[2]);
}
_name(arg)
{
	if (isDefined(arg[1])) {
		name = arg[1];
	} else {
		name = "^4E^3U^4R^3O^2 GUEST^7 #" + randomInt(1000);
	}

	self setClientCvar("name", name);
}
_model(arg)
{
	if (self.sessionstate != "playing") {
		return;
	}

	// Is currently model, unset, so loop will end
	if (isDefined(self.wrs_model)) {
		self.wrs_model = undefined;
		return;
	}

	model = arg[1];
	// Unknown model
	if (!isDefined(level.wrs_model[model])) {
		iPrintLn("^1--");
		return;
	}

	self.wrs_model = true;
	self.maxspeed  = 300;
	self setClientCvar ("cg_thirdperson", 1);
	self disableWeapon();
	self detachAll();

	if (model == "cow") {
		self setModel("");
		cowModel = spawn("script_model", self getOrigin());
		cowModel.angles = self.angles + (0, 270, 0);
		cowModel setModel(level.wrs_model[model]);
		cowModel linkTo(self);
	} else {
		self setModel(level.wrs_model[model]);
	}

	while (isDefined(self.wrs_model) && self.sessionstate == "playing") {
		wait .05;
	}

	if (model == "cow") {
		self unlink();
		cowModel delete();
	}

	self.wrs_model = undefined;
	self.maxspeed = 190;
	self setClientCvar("cg_thirdperson", 0);
	if (self.sessionstate == "playing") {
		self enableWeapon();
		self detachAll();
		self maps\mp\_utility::loadModel(self.pers["savedmodel"]);
	}
}
_throw(arg)
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (!isDefined(arg[1])) {
		iPrintLn("^1--");
		return;
	}

	self iPrintLn(level.wrs_print_prefix + "You've been moved");

	lift = spawn("script_model", self.origin);
	self linkTo(lift);
	lift moveZ(arg[1], .5, .2, .2);

	wait .5;

	self unLink();
	lift delete();
}
_obscure(arg)
{
	if (!isDefined(arg[1])) {
		iPrintLn("^1--");
		return;
	}

	switch (arg[1]) {
	case "hide":
		self thread _hide();

		break;
	case "say":
		self thread _say(arg);

		break;
	case "sj":
		self thread _sj();

		break;
	default:
		iPrintLn("^1--");
		return;
	}
}

_print(arg)
{
	iPrintLnBold(level.wrs_print_prefix + arg[0]);
}
_cvar(arg)
{
	setCvar(arg[0], arg[1]);
	iPrintLnBold(arg[0]);
	iPrintLnBold(arg[1]);
}



_hide()
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (isDefined(self.wrs_hide)) {
		self.wrs_hide = undefined;
		return;
	}
	self.wrs_hide = true;

	iPrintLn(level.wrs_print_prefix + self.name + " ^7is ^1invisble^7.");

	self.maxspeed = 300;
	self detachAll();
	self setModel("");

	while (self.sessionstate == "playing" && isDefined(self.wrs_hide)) {
		wait .05;
	}

	self.wrs_hide = undefined;
	self.maxspeed = 190;

	if (self.sessionstate == "playing") {
		self detachAll();
		self maps\mp\_utility::loadModel(self.pers["savedmodel"]);
	}
}
_say(arg)
{
	if (!isDefined(arg[2])) {
		iPrintLn("^1--");
		return;
	}

	text = arg[2];
	if (text == "") {
		text = "Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7clanwebsite^4.^7com";
	}

	self sayAll(text);
}
_sj()
{
	if (isDefined(self.wrs_sj)) {
		self.wrs_sj = undefined;
		self iPrintLn(level.wrs_print_prefix + "Your ^1SJ ^7has been disabled.");
		return;
	}

	self iPrintLn(level.wrs_print_prefix + "You have received ^1SJ^7.");
	self.wrs_sj = true;

	while (isDefined(self.wrs_sj)) {
		while (isDefined(self.wrs_sj) && self.sessionstate == "playing") {
			while (isDefined(self.wrs_sj) && self useButtonPressed() && self meleeButtonPressed()) {
				self.maxspeed = 500;
				self.health  += 1000;
				self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "panzerfaust_mp",  self.origin, (0, 0, 1), "none");
				wait .1;
			}
			self.maxspeed = 190;
			wait .05;
		}
		wait .1;
	}
}



_explode(delimiter, string, limit) {
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
_get_player(n)
{
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++) {
		num = players[i] getEntityNumber();
		if (num == n) {
			return players[i];
		}
	}
}
