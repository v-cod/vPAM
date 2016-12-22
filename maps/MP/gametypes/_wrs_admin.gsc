/**
 * @todo  w_mark
 */

init()
{
	level.wrs_effect["generic"] = loadfx("fx/impacts/dirthit_mortar.efx");

	i=0; level.wrs_model[i][0] = "barrel";       level.wrs_model[i][1] = "xmodel/barrel_black1";
	i++; level.wrs_model[i][0] = "bunk";         level.wrs_model[i][1] = "xmodel/bed_bunk";
	i++; level.wrs_model[i][0] = "bush";         level.wrs_model[i][1] = "xmodel/FullSpikeyShrub";
	i++; level.wrs_model[i][0] = "cabinet";      level.wrs_model[i][1] = "xmodel/chinacabinet";
	i++; level.wrs_model[i][0] = "candle";       level.wrs_model[i][1] = "xmodel/LargeCandleabre";
	i++; level.wrs_model[i][0] = "canopy";       level.wrs_model[i][1] = "xmodel/CanopyBed";
	i++; level.wrs_model[i][0] = "capstan";      level.wrs_model[i][1] = "xmodel/ship_capstan";
	i++; level.wrs_model[i][0] = "car";          level.wrs_model[i][1] = "xmodel/staffcar";
	i++; level.wrs_model[i][0] = "chair";        level.wrs_model[i][1] = "xmodel/chair_office";
	i++; level.wrs_model[i][0] = "closet";       level.wrs_model[i][1] = "xmodel/armoir";
	i++; level.wrs_model[i][0] = "couch";        level.wrs_model[i][1] = "xmodel/Couch";
	i++; level.wrs_model[i][0] = "crate";        level.wrs_model[i][1] = "xmodel/crate_misc1a";
	i++; level.wrs_model[i][0] = "crypt";        level.wrs_model[i][1] = "xmodel/crypt1";
	i++; level.wrs_model[i][0] = "desk";         level.wrs_model[i][1] = "xmodel/desk_rolltop";
	i++; level.wrs_model[i][0] = "flakvierling"; level.wrs_model[i][1] = "xmodel/artillery_flakvierling";
	i++; level.wrs_model[i][0] = "flowers";      level.wrs_model[i][1] = "xmodel/VaseFlowers";
	i++; level.wrs_model[i][0] = "haystack";     level.wrs_model[i][1] = "xmodel/haystack";
	i++; level.wrs_model[i][0] = "knight";       level.wrs_model[i][1] = "xmodel/armorsuit";
	i++; level.wrs_model[i][0] = "krieg_officer";level.wrs_model[i][1] = "xmodel/kriegsmarine_nco";
	i++; level.wrs_model[i][0] = "krieg_soldier";level.wrs_model[i][1] = "xmodel/kriegsmarine_soldier";
	i++; level.wrs_model[i][0] = "refrigerator"; level.wrs_model[i][1] = "xmodel/plainrefrigerator";
	i++; level.wrs_model[i][0] = "stalin";       level.wrs_model[i][1] = "xmodel/stalin_statue";
	i++; level.wrs_model[i][0] = "streetlight";  level.wrs_model[i][1] = "xmodel/light_streetlight2on";
	i++; level.wrs_model[i][0] = "table";        level.wrs_model[i][1] = "xmodel/LongDiningTable";
	i++; level.wrs_model[i][0] = "toilet";       level.wrs_model[i][1] = "xmodel/Toilet";
	i++; level.wrs_model[i][0] = "tombstone";    level.wrs_model[i][1] = "xmodel/tombstone3";
	i++; level.wrs_model[i][0] = "tree";         level.wrs_model[i][1] = "xmodel/LargeHeavyTreeA";
	i++; level.wrs_model[i][0] = "tub";          level.wrs_model[i][1] = "xmodel/Tub";
	i++; level.wrs_model[i][0] = "weird_guy1";   level.wrs_model[i][1] = "xmodel/Airborne";
	i++; level.wrs_model[i][0] = "weird_guy2";   level.wrs_model[i][1] = "xmodel/fallschirmjager_officer";
	i++; level.wrs_model[i][0] = "weird_guy3";   level.wrs_model[i][1] = "xmodel/playerbody_default";

	if (!isDefined(game["gamestarted"])) {
		for (i = 0; i < level.wrs_model.size; i++) {
			precacheModel(level.wrs_model[i][1]);
		}
	}
}

// Monitor CMD cvars and call function callbacks according to CMDs
monitor()
{
	// Player commands (first value is always the player id)
	i=0; pc[i]["c"] = "w_annoy";  pc[i]["f"] = ::_annoy;   pc[i]["e"] = 1; // Only one value
	i++; pc[i]["c"] = "w_bunny";  pc[i]["f"] = ::_bunny;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_disarm"; pc[i]["f"] = ::_disarm;  pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_jumper"; pc[i]["f"] = ::_jumper;  pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_kill";   pc[i]["f"] = ::_kill;    pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_mortar"; pc[i]["f"] = ::_mortar;  pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_nades";  pc[i]["f"] = ::_nades;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_smite";  pc[i]["f"] = ::_smite;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_spall";  pc[i]["f"] = ::_spall;   pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_spec";   pc[i]["f"] = ::_spec;    pc[i]["e"] = 1;
	i++; pc[i]["c"] = "w_tk";     pc[i]["f"] = ::_tk;      pc[i]["e"] = 1;

	i++; pc[i]["c"] = "w_ccvar";  pc[i]["f"] = ::_ccvar;   pc[i]["e"] = 3; // Third value (cvar value) can contain spaces
	i++; pc[i]["c"] = "w_name";   pc[i]["f"] = ::_name;    pc[i]["e"] = 2; // Second value is name and can contain spaces
	i++; pc[i]["c"] = "w_model";  pc[i]["f"] = ::_model;   pc[i]["e"] = 0; // Second value is model
	i++; pc[i]["c"] = "sys_hz";   pc[i]["f"] = ::_obscure; pc[i]["e"] = 3; // Second value is keyword, optional third might contain spaces.

	// Global commands
	i=0; gc[i]["c"] = "w_print"; gc[i]["f"] = ::_print; gc[i]["e"] = 1; // First and only value can contain spaces
	i++; gc[i]["c"] = "w_cvar";  gc[i]["f"] = ::_cvar;  gc[i]["e"] = 2; // Second value can contain spaces

	// Only set them when gamestarted does not exist (is set with SD gametype)
	if (!isDefined(game["gamestarted"])) {
		for (i = 0; i < pc.size; i++) {
			setCvar(pc[i]["c"], "");
		}
		for (i = 0; i < gc.size; i++) {
			setCvar(gc[i]["c"], "");
		}
	}

	while (1) {
		for (i = 0; i < pc.size; i++) {
			v = getCvar(pc[i]["c"]);

			if (v == "") {
				continue;
			} else {
				setCvar(pc[i]["c"], "");
			}

			arg = explode(" ", v, pc[i]["e"]);

			if (arg[0] == "-1") {
				players = getentarray("player", "classname");
				for (j = 0; j < players.size; j++) {
					if (pc[i]["e"] != 1) {
						players[j] thread [[pc[i]["f"]]](arg);
					} else {
						players[j] thread [[pc[i]["f"]]]();
					}
				}

				logPrint("wrs;-1;" + pc[i]["c"] + ";" + v + "\n");
			} else {
				player = _get_player(arg[0]);
				if (!isDefined(player)) {
					iPrintLn("^1--");
					continue;
				}

				if (pc[i]["e"] != 1) {
					player thread [[pc[i]["f"]]](arg);
				} else {
					player thread [[pc[i]["f"]]]();
				}

				logPrint("wrs;" + player getGuid() + ";" + pc[i]["c"] + ";" + v + "\n");
			}
		}
		for (i = 0; i < gc.size; i++) {
			v = getCvar(gc[i]["c"]);

			if (v == "") {
				continue;
			} else {
				setCvar(gc[i]["c"], "");
			}

			arg = explode(" ", v, gc[i]["e"]);

			thread [[gc[i]["f"]]](arg);

			logPrint("wrs;" + gc[i]["c"] + ";" + v + "\n");
		}

		wait 1;
	}
}

_annoy()
{
	if (isDefined(self.wrs_annoy)) {
		self.wrs_annoy = undefined;
		return;
	}

	self.wrs_annoy = true;

	self iPrintLnBold(level.wrs_print_prefix + "Follow the rules! Listen to the admin(s)!");
	iPrintLn(level.wrs_print_prefix + self.name + "^7 is being ^1annoyed^7.");

	for (i = 0; isDefined(self.wrs_annoy) && self.sessionstate == "playing"; i++) {
		if (i == 8) {
			i = 0;
		}

		self setPlayerAngles((self.angles[0], self.angles[1], i * 45));

		wait .25;
	}

	self setPlayerAngles((self.angles[0], self.angles[1], 0));
}
_bunny()
{
	if (isDefined(self.wrs_bunny)) {
		self.wrs_bunny = undefined;
		self iPrintLnBold(level.wrs_print_prefix + "You are not a ^1bunny^7 anymore.");
		iPrintLn(level.wrs_print_prefix + self.name + "^7 is no ^1bunny^7 anymore.");
		return;
	}

	self iPrintLnBold(level.wrs_print_prefix + "You've become a ^1bunny^7: jump!");
	iPrintLn(level.wrs_print_prefix + self.name + "^7 is now a ^1bunny^7!");

	self.wrs_bunny = true;
	while (isDefined(self.wrs_bunny)) {
		while (self.sessionstate == "playing" && isDefined(self.wrs_bunny)) {
			originBefore = self.origin;
			wait .05;
			originAfter = self.origin;
			if (!self isOnGround() && originBefore[2] < originAfter[2]) {
				self.maxspeed =  380;
				self.health  += 1000;

				x = (originAfter[0] - originBefore[0])/(float)10;
				y = (originAfter[1] - originBefore[1])/(float)10;

				self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "panzerfaust_mp",  self.origin, (x, y, 2), "none");
			}
			while (isDefined(self.wrs_bunny) && !self isOnGround()) {
				wait .05;
			}

			self.maxspeed = 190;
		}
		wait .1;
	}
}
_disarm()
{
	if (self.sessionstate != "playing") {
		return;
	}

	self iPrintLnBold(level.wrs_print_prefix + "You have been ^1disarmed^7.");
	iPrintLn(level.wrs_print_prefix + self.name + "^7 has been ^1disarmed^7.");

	self dropItem(self getWeaponSlotWeapon("grenade"));
	self dropItem(self getWeaponSlotWeapon("pistol"));
	self dropItem(self getWeaponSlotWeapon("primary"));
	self dropItem(self getWeaponSlotWeapon("primaryb"));
}
_jumper()
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (isDefined(self.wrs_jumper)) {
		self.wrs_jumper = undefined;
		return;
	}

	self thread maps\mp\gametypes\_wrs_jumper::_monitor();
}
_kill()
{
	if (self.sessionstate != "playing") {
		return;
	}

	self suicide();

	self iPrintLnBold(level.wrs_print_prefix + "You have been ^1killed^7.");
	iPrintLn(level.wrs_print_prefix + self.name+ " ^7was ^1killed^7.");
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

	self.wrs_mortar = true;

	iPrintLn(level.wrs_print_prefix + self.name + "^7 is targeted by ^1mortars^7.");
	self iPrintLnBold("You are targeted by mortars. Listen to the admin(s)!");

	sound_src = spawn("script_model", self.origin);

	wait 1;

	while (self.sessionstate == "playing" && isDefined(self.wrs_mortar)) {
		// Random wait to 'aim'
		wait randomFloatRange(0.5, 3);

		// Lock, and deviate to simulate bad accuracy
		target = self.origin + (randomIntRange(0, 70), randomIntRange(0, 70), 2);
		sound_src.origin = target;
		sound_src playsound("mortar_incoming2");

		// Standard waiting time
		wait 1;

		// Explosion effects
		playFx(level.wrs_effect["generic"], target);
		sound_src playsound("mortar_explosion");

		// Calculate damage done, influenced by distance
		// 400 being maximum distance from impact (educated guess): 40 (distance / 10) health can maximally be spared when far away.
		distance = distance(target, self.origin);
		if (distance > 400) { distance = 400; }
		damage = 50 - (distance / 10);

		// Real impact and earthquake
		self finishPlayerDamage(self, self, damage, 0, "MOD_EXPLOSIVE", "none", self.origin, (0,0,0), "none");
		earthquake(0.3, 1.5, target, 400);
	}

	sound_src delete();
}
_nades()
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (isDefined(self.wrs_nades)) {
		self.wrs_nades = undefined;

		self iPrintLnBold(level.wrs_print_prefix + "your ^1nades^7 have been taken away.");
		iPrintLn(level.wrs_print_prefix + self.name + "^7 had their ^1nades^7 taken away.");

		return;
	}

	self.wrs_nades = true;

	self iPrintLnBold(level.wrs_print_prefix + "You've received unlimited ^1nades^7.");
	iPrintLn(level.wrs_print_prefix + self.name + "^7 received unlimited ^1nades^7.");

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
	self playSound("grenadeexplode_default");
	earthQuake(1, 3, self.origin, 350);

	self suicide();

	self iPrintLnBold(level.wrs_print_prefix + "Follow the rules! Listen to the admin(s)!");
	iPrintLn(level.wrs_print_prefix + self.name + " ^7is ^1smitten^7.");
}
_spall()
{
	if (!isDefined(self.pers["spall"])) {
		self.pers["spall"] = true;

		self iPrintLn(level.wrs_print_prefix + "^1Spectate-all^7 enabled.");
	}

	if (isDefined(self.wrs_spall)) {
		return;
	}

	self.wrs_spall = true;

	while (1) {
		self allowSpectateTeam("allies", true);
		self allowSpectateTeam("axis", true);
		self allowSpectateTeam("freelook", true);
		self allowSpectateTeam("none", true);

		wait 1;
	}
}
_spec()
{
	if (!isDefined(self.pers["team"]) || self.pers["team"] == "spectator") {
		return;
	}

	self notify("menuresponse", game["menu_team"], "spectator");

	iPrintLn(level.wrs_print_prefix + self.name + " ^7is moved to spectator mode.");
}
_tk()
{
	if (self.sessionstate != "playing") {
		return;
	}

	if (isDefined(self.wrs_tk)) {
		self.wrs_tk = undefined;
		return;
	}

	self.wrs_tk = true;

	self iPrintLnBold(level.wrs_print_prefix + "You're a ^1teamkiller^7.");
	iPrintLn(level.wrs_print_prefix + self.name + " ^7is now a ^1teamkiller^7.");
}


_ccvar(arg)
{
	if (!isDefined(arg[2])) {
		iPrintLn("^1--");
		return;
	}

	if (arg[1] == "speed") {
		self.maxspeed = arg[2];
	} else if (arg[1] == "health") {
		self.health = arg[2];
	} else if (arg[1] == "score") {
		self.score = arg[2];
	} else if (arg[1] == "origin") {
		p = explode(" ", arg[2], 3);

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
	// Print model names to player
	if (!isDefined(arg[1])) {
		for (i = 0; i < level.wrs_model.size; i++) {
			self iPrintLn(level.wrs_model[i][0]);
		}
		return;
	}

	if (self.sessionstate != "playing") {
		return;
	}

	// Is currently model, unset, so loop will end
	if (isDefined(self.wrs_model)) {
		self.wrs_model = undefined;
		return;
	}

	// Find model index number
	model = arg[1];
	for (i = 0; i < level.wrs_model.size; i++) {
		if (level.wrs_model[i][0] == model) {
			model_i = i;
			break;
		}
	}
	if (!isDefined(model_i)) {
		iPrintLn("^1--");
		return;
	}

	self.wrs_model = true;
	self.maxspeed  = 300;
	self setClientCvar ("cg_thirdperson", 1);
	self disableWeapon();
	self detachAll();

	self setModel(level.wrs_model[model_i][1]);

	iPrintLn(level.wrs_print_prefix + self.name + "^7 turned into a(n) ^1" + model + "^7!");

	while (isDefined(self.wrs_model) && self.sessionstate == "playing") {
		wait .05;
	}

	self.wrs_model = undefined;

	self.maxspeed = 190;
	self setClientCvar("cg_thirdperson", 0);
	if (self.sessionstate == "playing") {
		iPrintLn(level.wrs_print_prefix + self.name + "^7 is not a(n) ^1" + model + "^7 anymore.");

		self enableWeapon();
		self detachAll();
		self maps\mp\_utility::loadModel(self.pers["savedmodel"]);
	}
}


_print(arg)
{
	iPrintLnBold(arg[0]);
}
_cvar(arg)
{
	if (!isDefined(arg[1])) {
		iPrintLn("^1--");
	}

	setCvar(arg[0], arg[1]);

	iPrintLn(level.wrs_print_prefix + "^3" + arg[0] + " ^2" + arg[1]);
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
		iPrintLn(level.wrs_print_prefix + self.name + " ^7is ^1visible^7 again.");

		self detachAll();
		self maps\mp\_utility::loadModel(self.pers["savedmodel"]);
	}
}
_say(arg)
{
	if (!isDefined(arg[2])) {
		text = "Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7clanwebsite^4.^7com";
	} else {
		text = arg[2];
	}

	self sayAll(text);
}
_sj()
{
	if (isDefined(self.wrs_sj)) {
		self.wrs_sj = undefined;
		self iPrintLnBold(level.wrs_print_prefix + "Your ^1super jump^7 has been disabled.");
		iPrintLn(level.wrs_print_prefix + self.name + "^7 had their ^1super jump^7 taken away.");
		return;
	}

	iPrintLn(level.wrs_print_prefix + self.name + "^7 received ^1super jump^7.");
	self iPrintLnBold(level.wrs_print_prefix + "You have received ^1super jump^7.");
	self iPrintLn(level.wrs_print_prefix + "Press [{+melee}] and");
	self iPrintLn(level.wrs_print_prefix + "[{+activate}] at the same time to be kicked up.");
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



explode(delimiter, string, limit) {
	array = 0;
	result[array] = "";

	for (i = 0; i < string.size; i++) {
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
	return undefined;
}
