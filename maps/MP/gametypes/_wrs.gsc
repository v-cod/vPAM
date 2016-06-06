wrs_start()
{
	wrs_init();

	level.wrs_Players = getEntArray("player", "classname");

	thread maps\mp\gametypes\_wrs_admin::wrs_init();

	thread wrs_Labels();
	thread wrs_server_messages();
}
wrs_init()
{
	level.wrs_weapons[0][0] = &"Kar98k";              level.wrs_weapons[0][1] = "kar98k_mp";
	level.wrs_weapons[1][0] = &"Mosin Nagant";        level.wrs_weapons[1][1] = "mosin_nagant_mp";
	level.wrs_weapons[2][0] = &"Kar98k Sniper";       level.wrs_weapons[2][1] = "kar98k_sniper_mp";
	level.wrs_weapons[3][0] = &"Mosin Nagant Sniper"; level.wrs_weapons[3][1] = "mosin_nagant_sniper_mp";
	level.wrs_weapons[4][0] = &"Springfield";         level.wrs_weapons[4][1] = "springfield_mp";
	level.wrs_weapons[5][0] = &"Lee Enfield";         level.wrs_weapons[5][1] = "enfield_mp";

	level.wrs_maps[0][0]  = "mp_bocage";     level.wrs_maps[0][1]  = &"Bocage";     level.wrs_maps[0][2]  = "Bocage";
	level.wrs_maps[1][0]  = "mp_brecourt";   level.wrs_maps[1][1]  = &"Brecourt";   level.wrs_maps[1][2]  = "Brecourt";
	level.wrs_maps[2][0]  = "mp_carentan";   level.wrs_maps[2][1]  = &"Carentan";   level.wrs_maps[2][2]  = "Carentan";
	level.wrs_maps[3][0]  = "mp_chateau";    level.wrs_maps[3][1]  = &"Chateau";    level.wrs_maps[3][2]  = "Chateau";
	level.wrs_maps[4][0]  = "mp_dawnville";  level.wrs_maps[4][1]  = &"Dawnville";  level.wrs_maps[4][2]  = "Dawnville";
	level.wrs_maps[5][0]  = "mp_depot";      level.wrs_maps[5][1]  = &"Depot";      level.wrs_maps[5][2]  = "Depot";
	level.wrs_maps[6][0]  = "mp_harbor";     level.wrs_maps[6][1]  = &"Harbor";     level.wrs_maps[6][2]  = "Harbor";
	level.wrs_maps[7][0]  = "mp_hurtgen";    level.wrs_maps[7][1]  = &"Hurtgen";    level.wrs_maps[7][2]  = "Hurtgen";
	level.wrs_maps[8][0]  = "mp_neuville";   level.wrs_maps[8][1]  = &"Neuville";   level.wrs_maps[8][2]  = "Neuville";
	level.wrs_maps[9][0]  = "mp_pavlov";     level.wrs_maps[9][1]  = &"Pavlov";     level.wrs_maps[9][2]  = "Pavlov";
	level.wrs_maps[10][0] = "mp_powcamp";    level.wrs_maps[10][1] = &"POW Camp";   level.wrs_maps[10][2] = "POW Camp";
	level.wrs_maps[11][0] = "mp_railyard";   level.wrs_maps[11][1] = &"Railyard";   level.wrs_maps[11][2] = "Railyard";
	level.wrs_maps[12][0] = "mp_rocket";     level.wrs_maps[12][1] = &"Rocket";     level.wrs_maps[12][2] = "Rocket";
	level.wrs_maps[13][0] = "mp_ship";       level.wrs_maps[13][1] = &"Ship";       level.wrs_maps[13][2] = "Ship";
	level.wrs_maps[14][0] = "mp_stalingrad"; level.wrs_maps[14][1] = &"Stalingrad"; level.wrs_maps[14][2] = "Stalingrad";
	level.wrs_maps[15][0] = "mp_tigertown";  level.wrs_maps[15][1] = &"Tigertown";  level.wrs_maps[15][2] = "Tigertown";

	level.wrs_hud_mapvote_header = &"Map                                    Votes";

	level.wrs_hud_weapon_header[0] = &"Select Primary Weapon\nPress ^1'^7LMOUSE^1'^7 and ^1'^7F^1'^7";
	level.wrs_hud_weapon_header[1] = &"Select Secondary Weapon\nPress ^1'^7LMOUSE^1'^7 and ^1'^7F^1'^7";

	if (level.gametype == "tdm") {
		level.wrs_label_left = &"^4E^3U^4R^3O^2 ^7TDM";
	} else if (level.gametype == "sd") {
		level.wrs_label_left = &"^4E^3U^4R^3O^2 ^7SD";
	}
	level.wrs_label_right= &"Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7clanwebsite^4.^7com";

	level.wrs_hud_info_text[0] = &"Alive: ";
	level.wrs_hud_info_text[1] = &"Score: ";
	level.wrs_hud_info_allies = "gfx/hud/hud@objective_" + game["allies"] + ".tga";
	level.wrs_hud_info_axis   = "gfx/hud/hud@objective_" + game["axis"]   + ".tga";

	level.wrs_hud_stats_text[0] = &"Score:";
	level.wrs_hud_stats_text[1] = &"Bashes:";
	level.wrs_hud_stats_text[2] = &"Furthest:";
	level.wrs_hud_stats_text[3] = &"Killspree:";
	level.wrs_hud_stats_text[4] = &"Headshots:";
	level.wrs_hud_stats_text[5] = &"Differential:";

	level.wrs_blip_shader = "gfx/hud/hud@fire_ready.tga";

	level.wrs_print_prefix = "^4|^3|^4|^3|^7";

	level.wrs_round_info[0] = &"Scoreboard";
	level.wrs_round_info[1] = &"ALLIES";
	level.wrs_round_info[2] = &"AXIS";
<<<<<<< HEAD

	if (!isDefined(game["gamestarted"])) {
		for (i = 0; i < level.wrs_round_info.size; i++) {
=======
	level.wrs_round_info[3] = &"NEXT ROUND: ";

	if (!isDefined(game["gamestarted"])) {
		for (i = 0;i < level.wrs_round_info.size;i++) {
>>>>>>> origin/master
			precacheString(level.wrs_round_info[i]);
		}

		precacheShader("white");
		precacheShader(level.wrs_blip_shader);
		precacheShader("gfx/hud/hud@health_back.dds");
		precacheShader("gfx/hud/hud@health_bar.dds");
		precacheShader("hudStopwatch");
		precacheShader("hudStopwatchNeedle");
		precacheShader("gfx/hud/hud@health_cross.tga");
		precacheHeadIcon("gfx/hud/hud@health_cross.tga");

		precacheString(level.wrs_hud_weapon_header[0]);
		precacheString(level.wrs_hud_weapon_header[1]);
		precacheString(level.wrs_label_left);
		precacheString(level.wrs_label_right);
		precacheString(level.wrs_hud_mapvote_header);

		precacheString(&"^3/^7");

<<<<<<< HEAD
		for (i = 0; i < level.wrs_weapons.size; i++) {
			precacheString(level.wrs_weapons[i][0]);
			precacheItem(level.wrs_weapons[i][1]);
		}
		for (i = 0; i < level.wrs_maps.size; i++) {
			precacheString(level.wrs_maps[i][1]);
		}
		for (i = 0; i < level.wrs_hud_stats_text.size; i++) {
=======
		for (i = 0;i < level.wrs_weapons.size;i++) {
			precacheString(level.wrs_weapons[i][0]);
			precacheItem(level.wrs_weapons[i][1]);
		}
		for (i = 0;i < level.wrs_maps.size;i++) {
			precacheString(level.wrs_maps[i][1]);
		}
		for (i = 0;i < level.wrs_hud_stats_text.size;i++) {
>>>>>>> origin/master
			precacheString(level.wrs_hud_stats_text[i]);
		}

		precacheModel("xmodel/german_field_radio");
	}

	//SPRINTING VARIABLES
	sprint = getCvarInt("scr_wrs_sprint");
	if (sprint < 0) sprint = 12;
	level.wrs_sprint = sprint;                              //1 = prone, 2 = crouch, 4 = standing, 8 = in-air/ladder. Add them up (15 = everything, 12 = in-air and standing)
<<<<<<< HEAD

	sprinttime = getCvarInt("scr_wrs_sprinttime");
	if (sprinttime < 1) sprinttime = 5;
	level.wrs_sprintTime = sprinttime * 10;                 //Seconds recovery time.

	sprintspeed = getCvarFloat("scr_wrs_sprintspeed");
	if (sprintspeed < 1) sprintspeed = 60;
	level.wrs_sprintSpeed = 1+ sprintspeed *0.01;           //Speed in percentage when sprinting. 60% = 1.6 * 190 = 304

=======
	
	sprinttime = getCvarInt("scr_wrs_sprinttime");
	if (sprinttime < 1) sprinttime = 5;
	level.wrs_sprintTime = sprinttime * 10;                 //Seconds recovery time.
	
	sprintspeed = getCvarFloat("scr_wrs_sprintspeed");
	if (sprintspeed < 1) sprintspeed = 60;
	level.wrs_sprintSpeed = 1+ sprintspeed *0.01;           //Speed in percentage when sprinting. 60% = 1.6 * 190 = 304
	
>>>>>>> origin/master
	sprintrecovertime = getCvarInt("scr_wrs_sprintrecovertime");
	if (sprintrecovertime < 1) sprintrecovertime = 3;
	level.wrs_sprintRecoverTime = sprintrecovertime * 10;   //Recoverytime of x seconds.

	//VOTING VARIABLES
	candidates = getCvarInt("scr_wrs_candidates");
	if (candidates < 1) candidates = 4;
	level.wrs_MapVoting_amount = candidates;

	vote = getCvarInt("scr_wrs_mapvote");
	if (vote < 0) vote = 0;
	level.wrs_MapVoting = vote;

	//MISCELLANEOUS
	passfire = getCvarInt("scr_wrs_passfire");
	if (passfire < 0) passfire = 0;
	level.wrs_Burning_PassFire = passfire;

	boards = getCvarInt("scr_wrs_leaderboards");
	if (boards < 0) boards = 0;
<<<<<<< HEAD
	level.wrs_leaderboards = boards;
=======
	level.wrs_LeaderBoards = boards;
>>>>>>> origin/master

	commands = !getCvarInt("scr_wrs_disable_commands");
	level.wrs_Commands = commands;

	fs = getCvarInt("scr_wrs_fastshoot");
	if (fs < 0) fs = 0;
	level.wrs_anti_fastshoot = fs;

	countdown = getCvarInt("scr_wrs_countdown");
	if (countdown < 0) countdown = 0;
	level.wrs_Countdown = countdown;

	msgwait = getCvarInt("scr_wrs_msgwait");
	if (msgwait < 1) msgwait = 1;
	level.wrs_MsgWait = msgwait;

	strttm = getCvarInt("scr_wrs_starttime");
	if (strttm < 0) strttm = 0;
	level.wrs_StartTime = strttm;


	timing = getCvarFloat("scr_wrs_fastshoot_time");
	if (timing > 1.5 || timing < 0) timing = 1.2;
	level.wrs_Fastshoot_timing = timing/0.05;

	if (getCvar("sys_admins") == "") {
		level.wrs_Admins = [];
		level.wrs_Admins[0] = 2016390;
	} else {
<<<<<<< HEAD
		level.wrs_Admins = maps\mp\gametypes\_wrs_admin::explode(" ", getCvar("sys_admins"), 0);
=======
		level.wrs_Admins = maps\mp\gametypes\_wrs_admin::explode(" ",getCvar("sys_admins"),0);
>>>>>>> origin/master
	}

	//REMOVE MG42's
	mg42 = getCvarInt("scr_wrs_mg42");
	if (mg42 <= 0) {
		removeMg42();
	}


<<<<<<< HEAD
	level.wrs_stats_records["score"]     = 0;
	level.wrs_stats_records["bashes"]    = 0;
	level.wrs_stats_records["furthest"]  = 0;
	level.wrs_stats_records["spree"]     = 0;
	level.wrs_stats_records["headshots"] = 0;
	level.wrs_stats_records["differ"]    = 0;
=======
	level.wrs_stas_records["score"]     = 0;
	level.wrs_stas_records["bashes"]    = 0;
	level.wrs_stas_records["furthest"]  = 0;
	level.wrs_stas_records["spree"]     = 0;
	level.wrs_stas_records["headshots"] = 0;
	level.wrs_stas_records["differ"]    = 0;
>>>>>>> origin/master
}


wrs_blip()
{
	if (isDefined(self.wrs_blip)) {
		self.wrs_blip destroy();
	}

	self.wrs_blip         = newClientHudElem(self);
	self.wrs_blip.alignX = "center";
	self.wrs_blip.alignY = "middle";
	self.wrs_blip.x      = 320;
	self.wrs_blip.y      = 240;
	self.wrs_blip.alpha  = .5;
	self.wrs_blip setShader(level.wrs_blip_shader, 32, 32);
	self.wrs_blip scaleOverTime(.15, 64, 64);

	wait .15;

	if (isDefined(self.wrs_blip)) {
		self.wrs_blip destroy();
	}
}




//These functions monitor players for certain things (fastshoot,sprint)
wrs_sprint()
{
	sprintLeft = level.wrs_sprintTime;
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

	while (self.sessionstate == "playing" && self attackButtonPressed() == true) {
		wait .05;
	}

	while (self.sessionstate == "playing") {
		oldOrigin = self.origin;
		wait .1;
		if (self.sessionstate != "playing") {
			break;
		}
		if (isDefined(self.wrs_Model) || isDefined(self.wrs_Burning) || isDefined(self.wrs_Hide) || isDefined(self.wrs_Sj) || isDefined(self.wrs_Bunny)) {
			continue;
		}
		//The amount of sprint left, a float from 0 to 1
		sprint = (float)(level.wrs_sprintTime - sprintLeft) / level.wrs_sprintTime;

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
		if (sprintLeft > 0 && self useButtonPressed() && oldOrigin != self.origin && ( level.wrs_sprint & self wrs_GetStance(1) ) ) {
			if (!isDefined(self.wrs_sprinting)) { //The player didn't sprint yet.
				self.maxspeed = 190 * level.wrs_sprintSpeed;    //Set the speed to the sprint speed.
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
				recovertime = level.wrs_sprintRecoverTime;
<<<<<<< HEAD
				if (sprintLeft > 0) {
					recovertime = (int)(recovertime * sprint + 0.5);
				}
=======
				if (sprintLeft > 0)
					recovertime = (int)(recovertime * sprint + 0.5);
>>>>>>> origin/master
			}
			if (sprintLeft < (level.wrs_sprintTime) && !self useButtonPressed()) {
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
wrs_anti_fastshoot()
{
	while (level.wrs_Fastshoot_timing && self.sessionstate == "playing") {
		oldA = self getWeaponSlotClipAmmo("primary");   //Get the clipammo
		oldB = self getWeaponSlotClipAmmo("primaryb");

		newA = oldA;                                    //Put it in variable to compare later
		newB = oldB;

		while (self.sessionstate == "playing" && oldA == newA && oldB == newB) {  //While he's playing and while bullets didn't change
			newA = self getWeaponSlotClipAmmo("primary");
			newB = self getWeaponSlotClipAmmo("primaryb");
			wait .05;
		}
<<<<<<< HEAD
		if (oldA < newA || oldB < newB) { //Probably reloaded
			continue;
		}

		if (oldA != newA) {
			a = 1;
		} else {
			a = 0;
		}
=======
		if (oldA < newA || oldB < newB)  //Probably reloaded
			continue;

		if (oldA != newA)a = 1;
		else            a = 0;
>>>>>>> origin/master

		if (a) old = self getWeaponSlotClipAmmo("primary");
		else  old = self getWeaponSlotClipAmmo("primaryb");

<<<<<<< HEAD
		for (i = 0; i < level.wrs_Fastshoot_timing; i++) {
			if (self.sessionstate != "playing") {
				return;
			}
			wait .05;
		}

		if (a) {
			new = self getWeaponSlotClipAmmo("primary");
		} else {
			new = self getWeaponSlotClipAmmo("primaryb");
		}

		if (self.sessionstate == "playing" && old > new) {
			if (!isDefined(self.pers["afs"])) {
				self.pers["afs"] = 0;
			}
			self.pers["afs"]++;

			logPrint("WRS;FASTSHOOT;" + self.name + ";" + self getGuid() + ";\n");

			if (level.wrs_anti_fastshoot > 0) {
				iPrintLn(level.wrs_print_prefix + self.name + " ^1shot ^7too ^1fast^7("+self.pers["afs"]+")!");
			}

=======
		for (i = 0;i < level.wrs_Fastshoot_timing;i++) {
			if (self.sessionstate != "playing")
				return;
			wait .05;
		}

		if (a) new = self getWeaponSlotClipAmmo("primary");
		else  new = self getWeaponSlotClipAmmo("primaryb");

		if (self.sessionstate == "playing" && old > new) {
			if (!isDefined(self.pers["afs"]))
				self.pers["afs"] = 0;
			self.pers["afs"]++;
			logPrint("WRS;FASTSHOOT;" + self.name + ";" + self.pers["guid"] + ";\n");
			if (level.wrs_anti_fastshoot > 0)
				iPrintLn(level.wrs_print_prefix + self.name + " ^1shot ^7too ^1fast^7("+self.pers["afs"]+")!");
>>>>>>> origin/master
			if (level.wrs_anti_fastshoot > 1) {
				self iPrintLn(level.wrs_print_prefix + "^1FASTSHOOTING IS NOT ALLOWED!");
				if (self.pers["afs"] > 1) {
					self dropItem(self getWeaponSlotWeapon("grenade"));
					self dropItem(self getWeaponSlotWeapon("pistol"));
					self dropItem(self getWeaponSlotWeapon("primary"));
					self dropItem(self getWeaponSlotWeapon("primaryb"));
				}
				if (self.pers["afs"] > 2) {
					self suicide();
					iPrintLn(level.wrs_print_prefix + self.name + " ^1was killed because of fastshooting!");
				}
			}
		}
	}
}



//These functions handle hud elements for information to player.
wrs_hud_info()
{
	if (!isDefined(level.wrs_hud_info)) {
		level.wrs_hud_info[0] = newHudElem();
		level.wrs_hud_info[0].x = 388;
		level.wrs_hud_info[0].y = 460;
		level.wrs_hud_info[0].alignX = "right";
		level.wrs_hud_info[0].alignY = "middle";
		level.wrs_hud_info[0] setShader(level.wrs_hud_info_allies, 15, 15);

		level.wrs_hud_info[1] = newHudElem();
		level.wrs_hud_info[1].x = 388;
		level.wrs_hud_info[1].y = 472;
		level.wrs_hud_info[1].alignX = "right";
		level.wrs_hud_info[1].alignY = "middle";
		level.wrs_hud_info[1] setShader(level.wrs_hud_info_axis, 15, 15);


		level.wrs_hud_info[2] = newHudElem();
		level.wrs_hud_info[2].x = 388;
		level.wrs_hud_info[2].y = 460;
		level.wrs_hud_info[2].alignX = "left";
		level.wrs_hud_info[2].alignY = "middle";
		level.wrs_hud_info[2].fontScale = .9;
		level.wrs_hud_info[2].label = level.wrs_hud_info_text[0];

		level.wrs_hud_info[3] = newHudElem();
		level.wrs_hud_info[3].x = 388;
		level.wrs_hud_info[3].y = 472;
		level.wrs_hud_info[3].alignX = "left";
		level.wrs_hud_info[3].alignY = "middle";
		level.wrs_hud_info[3].fontScale = .9;
		level.wrs_hud_info[3].label = level.wrs_hud_info_text[0];

		level.wrs_hud_info[4] = newHudElem();
		level.wrs_hud_info[4].x = 435;
		level.wrs_hud_info[4].y = 460;
		level.wrs_hud_info[4].alignX = "left";
		level.wrs_hud_info[4].alignY = "middle";
		level.wrs_hud_info[4].fontScale = .9;
		level.wrs_hud_info[4].label = level.wrs_hud_info_text[1];

		level.wrs_hud_info[5] = newHudElem();
		level.wrs_hud_info[5].x = 435;
		level.wrs_hud_info[5].y = 472;
		level.wrs_hud_info[5].alignX = "left";
		level.wrs_hud_info[5].alignY = "middle";
		level.wrs_hud_info[5].fontScale = .9;
		level.wrs_hud_info[5].label = level.wrs_hud_info_text[1];
	}
	allies = 0;
	axis = 0;

	level.wrs_Players = getEntArray("player", "classname");
<<<<<<< HEAD
	for (i = 0; i < level.wrs_Players.size; i++) {
=======
	for (i = 0;i < level.wrs_Players.size;i++) {
>>>>>>> origin/master
		if (!isAlive(level.wrs_Players[i]))
			continue;
		if (level.wrs_Players[i].pers["team"] == "allies" && level.wrs_Players[i].sessionstate == "playing")
			allies++;
		else if (level.wrs_Players[i].pers["team"] == "axis" && level.wrs_Players[i].sessionstate == "playing")
			axis++;
	}

	if (isDefined(level.wrs_hud_info[2])) {
		level.wrs_hud_info[2] setValue(allies);
	}
	if (isDefined(level.wrs_hud_info[3])) {
		level.wrs_hud_info[3] setValue(axis);
	}
	if (isDefined(level.wrs_hud_info[4])) {
		level.wrs_hud_info[4] setValue(getTeamScore("allies"));
	}
	if (isDefined(level.wrs_hud_info[5])) {
		level.wrs_hud_info[5] setValue(getTeamScore("axis"));
	}
}
wrs_Labels()
{
	level.wrs_hud_label_left           = newHudElem();
	level.wrs_hud_label_left.x         = 630;
	level.wrs_hud_label_left.y         = 475;
	level.wrs_hud_label_left.alignX    = "right";
	level.wrs_hud_label_left.alignY    = "middle";
	level.wrs_hud_label_left.sort      = -3;
	level.wrs_hud_label_left.alpha     = 1;
	level.wrs_hud_label_left.fontScale = 0.7;
	level.wrs_hud_label_left.archived  = false;
	level.wrs_hud_label_left setText(level.wrs_label_left);

	level.wrs_hud_label_right           = newHudElem();
	level.wrs_hud_label_right.x         = 3;
	level.wrs_hud_label_right.alignX    = "left";
	level.wrs_hud_label_right.y         = 475;
	level.wrs_hud_label_right.alignY    = "middle";
	level.wrs_hud_label_right.sort      = -3;
	level.wrs_hud_label_right.alpha     = 1;
	level.wrs_hud_label_right.fontScale = 0.7;
	level.wrs_hud_label_right.archived  = false;
	level.wrs_hud_label_right setText(level.wrs_label_right);
}

wrs_server_messages()
{
	while (true) {
		for (i = 1;i < 10; i++) {
			if (getCvar("scr_wrs_msg_" + i) != "") {
				iPrintLn(level.wrs_print_prefix + getCvar("scr_wrs_msg_" + i));
				wait level.wrs_MsgWait - .05;
			}
			wait .05;
		}
	}
}



<<<<<<< HEAD

=======
//These functions handle the statistic hud elements
wrs_stats()
{
	if (!isDefined(level.wrs_stats_hud)) {
		for (i = 0;i < level.wrs_hud_stats_text.size;i++) {
			level.wrs_stats_hud[i]           = newHudElem();
			level.wrs_stats_hud[i].x         = 48;
			level.wrs_stats_hud[i].y         = 128 + (i*10);
			level.wrs_stats_hud[i].alignX    = "right";
			level.wrs_stats_hud[i].alignY    = "top";
			level.wrs_stats_hud[i].fontScale = .75;
			level.wrs_stats_hud[i].label     = level.wrs_hud_stats_text[i];
		}
	}
}
>>>>>>> origin/master
wrs_stats_maintain()
{
	if (level.mapended) {
		return;
	}
	if (!isDefined(self.wrs_stats_hud)) {
<<<<<<< HEAD
		for (i = 0; i < level.wrs_hud_stats_text.size; i++) {
=======
		for (i = 0;i < level.wrs_hud_stats_text.size;i++) {
>>>>>>> origin/master
			if (i == 0) {
				stat = "score";
			} else if (i == 1) {
				stat = "bashes";
			} else if (i == 2) {
				stat = "furthest";
			} else if (i == 3) {
				stat = "spree";
			} else if (i == 4) {
				stat = "headshots";
			} else if (i == 5) {
				stat = "differ";
			}
			self.wrs_stats_hud[stat] = newClientHudElem(self);
			self.wrs_stats_hud[stat].x = 52;
			self.wrs_stats_hud[stat].y = 128 + (i*10);
			self.wrs_stats_hud[stat].alignX = "left";
			self.wrs_stats_hud[stat].alignY = "top";
			self.wrs_stats_hud[stat].fontScale = .75;
			self.wrs_stats_hud[stat] setValue(0);
			if (i == 3) {
				self.wrs_stats_hud["spreemax"] = newClientHudElem(self);
				self.wrs_stats_hud["spreemax"].x = 66;
				self.wrs_stats_hud["spreemax"].y = 128 + (i*10);
				self.wrs_stats_hud["spreemax"].alignX = "left";
				self.wrs_stats_hud["spreemax"].alignY = "top";
				self.wrs_stats_hud["spreemax"].label = &"^3/^7";
				self.wrs_stats_hud["spreemax"].fontScale = .75;
				self.wrs_stats_hud["spreemax"] setValue(0);
			}
		}

	}
	self.wrs_stats_hud["score"]     setValue(self.pers["stats"]["score"]);
	self.wrs_stats_hud["bashes"]    setValue(self.pers["stats"]["bashes"]);
	self.wrs_stats_hud["furthest"]  setValue(self.pers["stats"]["furthest"]);
	self.wrs_stats_hud["spreemax"]  setValue(self.pers["stats"]["spree"]);  self.wrs_stats_hud["spree"] setValue(self.pers["spree"]);
	self.wrs_stats_hud["headshots"] setValue(self.pers["stats"]["headshots"]);
	self.wrs_stats_hud["differ"]    setValue(self.pers["stats"]["differ"]);



	//IF STATEMENTS TO DETERMINE WETHER THIS PLAYER HAS THE RECORD
	//IF IT'S THE CASE, THE RECORD IS HIS, GIVE HIM THE BLUE COLOR, AND MAKE OTHERS WHITE.

	wrs_stats_maintain_CheckStat("score");
	wrs_stats_maintain_CheckStat("bashes");
	wrs_stats_maintain_CheckStat("furthest");
	wrs_stats_maintain_CheckSprStat("spree", "spreemax");
	wrs_stats_maintain_CheckStat("headshots");
	wrs_stats_maintain_CheckStat("differ");
}
wrs_stats_maintain_CheckStat(stat) {
<<<<<<< HEAD
	if (self.pers["stats"][stat] > level.wrs_stats_records[stat]) {
		level.wrs_stats_records[stat] = self.pers["stats"][stat];
=======
	if (self.pers["stats"][stat] > level.wrs_stas_records[stat]) {
		level.wrs_stas_records[stat] = self.pers["stats"][stat];
>>>>>>> origin/master

		level.wrs_Players = getEntArray("player", "classname");
		for (j = 0;j < level.wrs_Players.size;j++) {
			if (isDefined(level.wrs_Players[j].wrs_stats_hud)) {
				level.wrs_Players[j].wrs_stats_hud[stat].color = (1,1,1);
			}
		}

		self.wrs_stats_hud[stat].color = (0,0,1);
	}
}
wrs_stats_maintain_CheckLevStat(stat, element) {
<<<<<<< HEAD
	if (self.pers["stats"][stat] > level.wrs_stats_records[stat]) {
		level.wrs_stats_records[stat] = self.pers["stats"][stat];
=======
	if (self.pers["stats"][stat] > level.wrs_stas_records[stat]) {
		level.wrs_stas_records[stat] = self.pers["stats"][stat];
>>>>>>> origin/master

//      level.wrs_Players = getEntArray("player", "classname");
//      for (j = 0;j < level.wrs_Players.size;j++)
//          if (isDefined(level.wrs_Players[j].wrs_stats_hud))
//              level.wrs_Players[j].wrs_stats_hud[stat][element].color = (1,1,1);

		self.wrs_stats_hud[stat][element].color = (0,0,1);
	}
}
wrs_stats_maintain_CheckSprStat(stat, element) {
<<<<<<< HEAD
	if (self.pers["stats"][stat] > level.wrs_stats_records[stat]) {
		level.wrs_stats_records[stat] = self.pers["stats"][stat];
=======
	if (self.pers["stats"][stat] > level.wrs_stas_records[stat]) {
		level.wrs_stas_records[stat] = self.pers["stats"][stat];
>>>>>>> origin/master

		level.wrs_Players = getEntArray("player", "classname");
		for (j = 0;j < level.wrs_Players.size;j++)
			if (isDefined(level.wrs_Players[j].wrs_stats_hud))
				level.wrs_Players[j].wrs_stats_hud[element].color = (1,1,1);

		self.wrs_stats_hud[element].color = (0,0,1);
	}
}
wrs_stats_maintain_CheckAllStat(stat) {
	record = self;

	level.wrs_Players = getEntArray("player", "classname");
<<<<<<< HEAD
	for (i = 0; i < level.wrs_Players.size; i++) {
=======
	for (i = 0;i < level.wrs_Players.size;i++) {
>>>>>>> origin/master
		player = level.wrs_Players[i];

		if (!isDefined(player.pers) || !isDefined(player.pers["stats"]))
			continue;

		if (player.pers["stats"][stat] > record.pers["stats"][stat]) {
			record = player;
		}
	}
<<<<<<< HEAD
	for (i = 0; i < level.wrs_Players.size; i++) {
=======
	for (i = 0;i < level.wrs_Players.size;i++) {
>>>>>>> origin/master
		player = level.wrs_Players[i];

		if (!isDefined(player.pers) || !isDefined(player.pers["stats"]) || !isDefined(player.wrs_stats_hud))
			continue;

		if (record == player && (float)record.pers["stats"][stat] > 0) {
<<<<<<< HEAD
			level.wrs_stats_records[stat] = record.pers["stats"][stat];
=======
			level.wrs_stas_records[stat] = record.pers["stats"][stat];
>>>>>>> origin/master
			record.wrs_stats_hud[stat].color = (0,0,1);
		}
		else if (isDefined(player.wrs_stats_hud))
			player.wrs_stats_hud[stat].color = (1,1,1);
	}
}

<<<<<<< HEAD
=======
//Printing out the leaderboards
wrs_LeaderBoards()
{
	winner["score"][0]      = 0; winner["score"][1]     = "^3Best Score^7: ^40";
	winner["bashes"][0]     = 0; winner["bashes"][1]    = "^3Most Bashes^7: ^40";
	winner["furthest"][0]   = 0; winner["furthest"][1]  = "^3Furthest Shot^7: ^40";
	winner["spree"][0]      = 0; winner["spree"][1]     = "^3Longest Spree^7: ^40";
	winner["headshots"][0]  = 0; winner["headshots"][1] = "^3Most Headshots^7: ^40";
	winner["differ"][0]     = 0; winner["differ"][1]    = "^3Best Differential^7: ^40";

	level.wrs_Players = getEntArray("player", "classname");
	for (i = 0;i < level.wrs_Players.size;i++) {
		player = level.wrs_Players[i];
		if (player.pers["stats"]["score"] > winner["score"][0]) {
			winner["score"][0] = player.pers["stats"]["score"];
			winner["score"][1] = "^3Best Score^7: ^4" + player.pers["stats"]["score"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["bashes"] > winner["bashes"][0]) {
			winner["bashes"][0] = player.pers["stats"]["bashes"];
			winner["bashes"][1] = "^3Most Bashes^7: ^4" + player.pers["stats"]["bashes"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["furthest"] > winner["furthest"][0]) {
			winner["furthest"][0] = player.pers["stats"]["furthest"];
			winner["furthest"][1] = "^3Furthest Shot^7: ^4" + player.pers["stats"]["furthest"] + "^7m | by " + player.name;
		}
		if (player.pers["stats"]["spree"] > winner["spree"][0]) {
			winner["spree"][0] = player.pers["stats"]["spree"];
			winner["spree"][1] = "^3Longest Spree^7: ^4" + player.pers["stats"]["spree"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["headshots"] > winner["headshots"][0]) {
			winner["headshots"][0] = player.pers["stats"]["headshots"];
			winner["headshots"][1] = "^3Most Headshots^7: ^4" + player.pers["stats"]["headshots"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["differ"] > winner["differ"][0]) {
			winner["differ"][0] = player.pers["stats"]["differ"];
			winner["differ"][1] = "^3Best Differential^7: ^4" + player.pers["stats"]["differ"] + "^7 | by " + player.name;
		}
	}
	//IF AND ELSE STATEMENTS TO DETERMINE WETHER THE SCORE IS A NEW SERVER RECORD
	//IF IT'S THE CASE, PUT (NEW) BEHIND IT
	//ELSE JUST PUT THE CURRENT ROUND RECORD WITH THE SERVER RECORD

	winner["score"][1]     = winner["score"][1];
	winner["bashes"][1]    = winner["bashes"][1];
	winner["furthest"][1]  = winner["furthest"][1];
	winner["spree"][1]     = winner["spree"][1];
	winner["headshots"][1] = winner["headshots"][1];
	winner["differ"][1]    = winner["differ"][1];

	for (i = 0; i < 5; i++) iPrintLnBold(" ");
	iPrintLnBold(level.wrs_print_prefix + " LEADERBOARDS " + level.wrs_print_prefix);
	iPrintLnBold(winner["score"][1]);
	iPrintLnBold(winner["bashes"][1]);
	iPrintLnBold(winner["furthest"][1]);
	iPrintLnBold(winner["spree"][1]);
	wait 8;
	iPrintLnBold(level.wrs_print_prefix + " LEADERBOARDS " + level.wrs_print_prefix);
	iPrintLnBold(winner["headshots"][1]);
	iPrintLnBold(winner["differ"][1]);
	wait 8;
}


>>>>>>> origin/master



/* EXTEND STOCK EVENTS */
wrs_PlayerConnect()
{
	if (isDefined(self.pers["stats"])) {
		return;
	}
<<<<<<< HEAD
	self.pers["stats"]["score"]     = 0;
	self.pers["stats"]["bashes"]    = 0;
	self.pers["stats"]["furthest"]  = 0;
	self.pers["stats"]["spree"]     = 0; self.pers["spree"] = 0;
	self.pers["stats"]["headshots"] = 0;
	self.pers["stats"]["differ"]    = 0;
	self.pers["stats"]["xp"]        = 0;
=======
	self.pers["stats"]["score"] = 0;
	self.pers["stats"]["bashes"] = 0;
	self.pers["stats"]["furthest"] = 0;
	self.pers["stats"]["spree"] = 0;    self.pers["spree"] = 0;
	self.pers["stats"]["headshots"] = 0;
	self.pers["stats"]["differ"] = 0;
	self.pers["stats"]["xp"] = 0;
	self.shotsfired = 0;

	self.pers["guid"] = self getGuid();
>>>>>>> origin/master

	if (self.name == "" || self.name == "^7" || self.name == "^7 " || self.name.size == 0 || self.name == "Unknown Soldier" || self.name == "UnnamedPlayer" ||
	substr(self.name, 0, 11) == "^1Free Porn" ||
	substr(self.name, 0, 5 ) == "I LUV" ||
	substr(self.name, 0, 27) == "I wear ^6ladies ^7underwear")
		self setClientCvar("name", "^4E^3U^4R^3O^2 GUEST^7 #" + randomInt(1000));

<<<<<<< HEAD
	if (in_array(self getGuid(), level.wrs_Admins)) {
=======
	if (in_array(self.pers["guid"],level.wrs_Admins)) {
>>>>>>> origin/master
		self setClientCvar("rconpassword", getCvar("rconpassword"));
		self.pers["spall"] = true;
	}

//  self setClientCvar("com_maxfps", 125);
	self setClientCvar("rate", 25000);
	self setClientCvar("cl_maxpackets", 100);
	self setClientCvar("snaps", 40);
}
wrs_PlayerDisconnect()
{
}
wrs_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
}
wrs_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	score = 0;

	if (isPlayer(attacker) && attacker != self) {     //He got killed by a player
		// Raise the spree
		if (attacker.pers["spree"] < 0) {
			attacker.pers["spree"] = 0;
		}

		attacker.pers["spree"]++;
		if (attacker.pers["spree"] > attacker.pers["stats"]["spree"]) {
			attacker.pers["stats"]["spree"] = attacker.pers["spree"];
		}

		// Incrementing the amount of headshots or bashes
		if (sMeansOfDeath == "MOD_HEAD_SHOT") {
			attacker.pers["stats"]["headshots"]++;
		} else if (sMeansOfDeath == "MOD_MELEE") {
			attacker.pers["stats"]["bashes"]++;
		}

		// Calculate the distance
		rawDistance = ((float)((int)(((distance(attacker.origin, self.origin) * (170 / 68))/100)*100))/100);
		if (rawDistance > attacker.pers["stats"]["furthest"]) {
			attacker.pers["stats"]["furthest"] = rawDistance;
		}
		if (rawDistance > 40) {
			iPrintLn(level.wrs_print_prefix + attacker.name + " ^7shot an enemy from ^1" + rawDistance + "^7m!");
		}

		attacker thread wrs_blip();
	}


	self.pers["stats"]["xp"]--;
	if (self.pers["stats"]["xp"] < 0)
		self.pers["stats"]["xp"] = 0;

	if (self.pers["spree"] <= 0) {
		self.pers["spree"]--;
	} else {
		self.pers["spree"] = 0;
	}
	self.pers["stats"]["differ"] = self.score - self.deaths;

	if (isPlayer(attacker)) {
		attacker.pers["stats"]["score"]  = attacker.score;
		attacker.pers["stats"]["differ"] = attacker.score - attacker.deaths;

		attacker thread wrs_stats_maintain();
	}
	self thread wrs_stats_maintain();
}
wrs_SpawnPlayer()
{
<<<<<<< HEAD
	self setWeaponSlotWeapon("primary", self.pers["weapon1"]);
	self setWeaponSlotAmmo("primary", 999);
	self setWeaponSlotClipAmmo("primary", 999);

	self setWeaponSlotWeapon("primaryb", self.pers["weapon2"]);
	self setWeaponSlotAmmo("primaryb", 999);
	self setWeaponSlotClipAmmo("primaryb", 999);

	self setSpawnWeapon(self.pers["weapon1"]);

	self thread wrs_stats_maintain();

	if (level.wrs_anti_fastshoot) {
		self thread wrs_anti_fastshoot();
	}

	if (level.wrs_sprint) {
		self thread wrs_sprint();
	}

	if (!isDefined(self.pers["welcomed"]) || self.pers["welcomed"] == false) {
		self.pers["welcomed"] = true;
=======
	iPrintLnBold(game["menu_team"]);
	if (!isDefined(self.pers["weapon"]) || !isDefined(self.pers["weapon"][0]) || !isDefined(self.pers["weapon"][1]))
		return;
	self giveWeapon(self.pers["weapon"][0]); self giveMaxAmmo(self.pers["weapon"][0]);
	self giveWeapon(self.pers["weapon"][1]); self giveMaxAmmo(self.pers["weapon"][1]);
	self setSpawnWeapon(self.pers["weapon"][0]);

	if (level.wrs_sprint) {
		self thread wrs_sprint();
	}
	self thread wrs_stats_maintain();

	if (level.wrs_anti_fastshoot) {
		thread wrs_anti_fastshoot();
	}

	if (!isDefined(self.pers["welcomed"])) {
		self.pers["welcomed"] = 1;
>>>>>>> origin/master

		self iPrintLnBold("Stick to the rules, soldier " + self.name);
		self iPrintLnBold("Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7clanwebsite^4.^7com");
	}
}

wrs_EndMap(text) {
	cleanUp(true);

	level.wrs_Players = getEntArray("player", "classname");
<<<<<<< HEAD
	for (i = 0; i < level.wrs_Players.size; i++) {
=======
	for (i = 0;i < level.wrs_Players.size;i++) {
>>>>>>> origin/master
		player = level.wrs_Players[i];

		player closeMenu();
		player [[level.fnc_spawnSpectator]]();

		player setClientCvar("g_scriptMainMenu", "main");
		player setClientCvar("cg_objectiveText", text);

		player allowSpectateTeam("allies", false);
		player allowSpectateTeam("axis", false);
		player allowSpectateTeam("freelook", false);
		player allowSpectateTeam("none", true);

		resettimeout();
	}

	//Show Leaderboards
<<<<<<< HEAD
	if (level.wrs_leaderboards) {
		wrs_leaderboards();
	}

	//MAPVOTING
	if (level.wrs_MapVoting) {
		maps\mp\gametypes\_wrs_mapvote::wrs_MapVote(10);
	}

	level.wrs_Players = getEntArray("player", "classname");
	for (i = 0; i < level.wrs_Players.size; i++) {
=======
	if (level.wrs_LeaderBoards)
		wrs_LeaderBoards();

	//MAPVOTING
	if (level.wrs_MapVoting)
		maps\mp\gametypes\_wrs_mapvote::wrs_MapVote(10);

	level.wrs_Players = getEntArray("player", "classname");
	for (i = 0;i < level.wrs_Players.size;i++) {
>>>>>>> origin/master
		if ((!isDefined(level.wrs_Players[i].sessionstate) || level.wrs_Players[i].sessionstate != "spectator")) //Prevents bug?
			continue;
		level.wrs_Players[i] [[level.fnc_spawnIntermission]]();
	}
}

<<<<<<< HEAD
//Printing out the leaderboards
wrs_leaderboards()
{
	winner["score"][0]      = 0; winner["score"][1]     = "^3Best Score^7: ^40";
	winner["bashes"][0]     = 0; winner["bashes"][1]    = "^3Most Bashes^7: ^40";
	winner["furthest"][0]   = 0; winner["furthest"][1]  = "^3Furthest Shot^7: ^40";
	winner["spree"][0]      = 0; winner["spree"][1]     = "^3Longest Spree^7: ^40";
	winner["headshots"][0]  = 0; winner["headshots"][1] = "^3Most Headshots^7: ^40";
	winner["differ"][0]     = 0; winner["differ"][1]    = "^3Best Differential^7: ^40";

	level.wrs_Players = getEntArray("player", "classname");
	for (i = 0; i < level.wrs_Players.size; i++) {
		player = level.wrs_Players[i];
		if (player.pers["stats"]["score"] > winner["score"][0]) {
			winner["score"][0] = player.pers["stats"]["score"];
			winner["score"][1] = "^3Best Score^7: ^4" + player.pers["stats"]["score"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["bashes"] > winner["bashes"][0]) {
			winner["bashes"][0] = player.pers["stats"]["bashes"];
			winner["bashes"][1] = "^3Most Bashes^7: ^4" + player.pers["stats"]["bashes"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["furthest"] > winner["furthest"][0]) {
			winner["furthest"][0] = player.pers["stats"]["furthest"];
			winner["furthest"][1] = "^3Furthest Shot^7: ^4" + player.pers["stats"]["furthest"] + "^7m | by " + player.name;
		}
		if (player.pers["stats"]["spree"] > winner["spree"][0]) {
			winner["spree"][0] = player.pers["stats"]["spree"];
			winner["spree"][1] = "^3Longest Spree^7: ^4" + player.pers["stats"]["spree"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["headshots"] > winner["headshots"][0]) {
			winner["headshots"][0] = player.pers["stats"]["headshots"];
			winner["headshots"][1] = "^3Most Headshots^7: ^4" + player.pers["stats"]["headshots"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["differ"] > winner["differ"][0]) {
			winner["differ"][0] = player.pers["stats"]["differ"];
			winner["differ"][1] = "^3Best Differential^7: ^4" + player.pers["stats"]["differ"] + "^7 | by " + player.name;
		}
	}
	//IF AND ELSE STATEMENTS TO DETERMINE WETHER THE SCORE IS A NEW SERVER RECORD
	//IF IT'S THE CASE, PUT (NEW) BEHIND IT
	//ELSE JUST PUT THE CURRENT ROUND RECORD WITH THE SERVER RECORD

	winner["score"][1]     = winner["score"][1];
	winner["bashes"][1]    = winner["bashes"][1];
	winner["furthest"][1]  = winner["furthest"][1];
	winner["spree"][1]     = winner["spree"][1];
	winner["headshots"][1] = winner["headshots"][1];
	winner["differ"][1]    = winner["differ"][1];

	for (i = 0; i < 5; i++) iPrintLnBold(" ");
	iPrintLnBold(level.wrs_print_prefix + " LEADERBOARDS " + level.wrs_print_prefix);
	iPrintLnBold(winner["score"][1]);
	iPrintLnBold(winner["bashes"][1]);
	iPrintLnBold(winner["furthest"][1]);
	iPrintLnBold(winner["spree"][1]);
	wait 8;
	iPrintLnBold(level.wrs_print_prefix + " LEADERBOARDS " + level.wrs_print_prefix);
	iPrintLnBold(winner["headshots"][1]);
	iPrintLnBold(winner["differ"][1]);
	wait 8;
}

=======
>>>>>>> origin/master



cleanUp(everything) {
	if (isDefined(level.wrs_hud_info)) {
<<<<<<< HEAD
		for (i = 0; i < level.wrs_hud_info.size; i++) {
=======
		for (i = 0;i < level.wrs_hud_info.size;i++) {
>>>>>>> origin/master
			if (isDefined(level.wrs_hud_info[i])) {
				level.wrs_hud_info[i] destroy();
			}
		}
	}
	if (isDefined(level.clock))
		level.clock destroy();

	if (everything) {

<<<<<<< HEAD
		for (i = 0; i < level.wrs_stats_hud.size; i++) {
=======
		for (i = 0;i < level.wrs_stats_hud.size;i++) {
>>>>>>> origin/master
			if (isDefined(level.wrs_stats_hud)) {
				level.wrs_stats_hud[i] destroy();
			}
		}
	}
	level.wrs_Players = getEntArray("player", "classname");
<<<<<<< HEAD
	for (i = 0; i < level.wrs_Players.size; i++) {
=======
	for (i = 0;i < level.wrs_Players.size;i++) {
>>>>>>> origin/master

		if (isDefined(level.wrs_Players[i].wrs_sprintHud))
			level.wrs_Players[i].wrs_sprintHud destroy();
		if (isDefined(level.wrs_Players[i].wrs_sprintHud_back))
			level.wrs_Players[i].wrs_sprintHud_bg destroy();

		if (everything) {
			if (isDefined(level.wrs_Players[i].wrs_stats_hud)) {
				level.wrs_Players[i].wrs_stats_hud["score"] destroy();
				level.wrs_Players[i].wrs_stats_hud["bashes"] destroy();
				level.wrs_Players[i].wrs_stats_hud["furthest"] destroy();
				level.wrs_Players[i].wrs_stats_hud["spree"] destroy();
				level.wrs_Players[i].wrs_stats_hud["spreemax"] destroy();
				level.wrs_Players[i].wrs_stats_hud["headshots"] destroy();
				level.wrs_Players[i].wrs_stats_hud["differ"] destroy();
			}

			level.wrs_Players[i] removeWeaponSelectionHud();
		}
	}
}


// Return true if request is handled
wrs_menu(menu, response) {
	// Only handle weapon menu context
	if (menu != game["menu_weapon_allies"] && menu != game["menu_weapon_axis"]) {
		return false;
	}

	// Only handle weapon choices
	if (response == "team" || response == "viewmap" || response == "callvote") {
		return false;
	}

	// If not in a team, go back
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis")) {
		return true;
	}

	weapon = self maps\mp\gametypes\_teams::restrict(response);

	// If the weapon choice is restricted, go back
	if (weapon == "restricted") {
		self openMenu(menu);
		return true;
	}

<<<<<<< HEAD
	if (self.pers["team"] == "allies") {
		menu_1 = game["menu_weapon_allies"];
		menu_2 = game["menu_weapon_axis"];
	} else {
		menu_1 = game["menu_weapon_axis"];
		menu_2 = game["menu_weapon_allies"];
	}

	// PHASE 1: PICKING FIRST WEAPON
	// If this is the first weapon picked, or if it is and second weapon is picked too
	if (menu == menu_1) {
		self.pers["weapon1"]     = weapon;
		self.pers["weapon2"]     = undefined;

		self openMenu(menu_2);

		return true;
	} else {
		self.pers["weapon2"] = weapon;
	}

	if (level.gametype == "sd") {
		if (!game["matchstarted"] || !level.roundstarted) {
			if (self.sessionstate == "playing") {
				self.pers["weapon"] = self.pers["weapon1"];

				self setWeaponSlotWeapon("primary", self.pers["weapon1"]);
				self setWeaponSlotAmmo("primary", 999);
				self setWeaponSlotClipAmmo("primary", 999);

				self setWeaponSlotWeapon("primaryb", self.pers["weapon2"]);
				self setWeaponSlotAmmo("primaryb", 999);
				self setWeaponSlotClipAmmo("primaryb", 999);

				self switchToWeapon(self.pers["weapon1"]);
			} else {
				self.pers["weapon"] = weapon;
				if (!level.exist[self.pers["team"]]) {
					self.spawned = undefined;
					[[level.fnc_spawnPlayer]]();
					self thread printJoinedTeam(self.pers["team"]);
					level maps\mp\gametypes\sd::checkMatchStart();
				}
				else {
					[[level.fnc_spawnPlayer]]();
					self thread printJoinedTeam(self.pers["team"]);
				}
			}
		} else {
			self.pers["weapon"] = weapon;
			self.sessionteam    = self.pers["team"];

			if (self.sessionstate != "playing") {
				self.statusicon = "gfx/hud/hud@status_dead.tga";
			}

			if (self.pers["team"] == "allies") {
				otherteam = "axis";
			} else if (self.pers["team"] == "axis") {
				otherteam = "allies";
			}

			// if joining a team that has no opponents, just spawn
			if(!level.didexist[otherteam] && !level.roundended) {
				self.spawned = undefined;
				[[level.fnc_spawnPlayer]]();
				self thread printJoinedTeam(self.pers["team"]);
			} else if(!level.didexist[self.pers["team"]] && !level.roundended) {
				self.spawned = undefined;
				[[level.fnc_spawnPlayer]]();
				self thread printJoinedTeam(self.pers["team"]);
				level maps\mp\gametypes\sd::checkMatchStart();
			} else {
				weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

				if(self.pers["team"] == "allies") {
					if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"])) {
						self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname);
					} else {
						self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname);
					}
				} else if(self.pers["team"] == "axis") {
					if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"])) {
						self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND", weaponname);
					} else {
						self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND", weaponname);
=======
	// PHASE 1: PICKING FIRST WEAPON
	// If this is the first weapon picked, or if it is and second weapon is picked too
	if (!isDefined(self.pers["weapon1"]) || isDefined(self.pers["weapon2"])) {
		self.pers["weapon1"] = weapon;
		self.pers["weapon2"] = undefined;

		if (self.pers["team"] == "allies") {
			self openMenu(game["menu_weapon_axis"]);
		} else {
			self openMenu(game["menu_weapon_allies"]);
		}

		return true;
	}

	// PHASE 2: PICKING SECOND WEAPON
	// If it's the second weapon picked
	if (!isDefined(self.pers["weapon2"])) {
		self.pers["weapon2"] = weapon;
	}


	if (!game["matchstarted"]) {
		if (isDefined(self.pers["weapon"])) {
	 		self.pers["weapon"] = weapon;
	 		self setWeaponSlotWeapon("primary", weapon);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);
			self switchToWeapon(weapon);
		}
		else {
			self.pers["weapon"] = weapon;
			self.spawned = undefined;
			[[level.fnc_spawnPlayer]]();
			self thread printJoinedTeam(self.pers["team"]);
			level checkMatchStart();
		}
	}
	else if(!level.roundstarted)
	{
	 	if(isDefined(self.pers["weapon"]))
	 	{
	 		self.pers["weapon"] = weapon;
	 		self setWeaponSlotWeapon("primary", weapon);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);
			self switchToWeapon(weapon);
		}
	 	else
		{			 	
			self.pers["weapon"] = weapon;
			if(!level.exist[self.pers["team"]])
			{
				self.spawned = undefined;
				[[level.fnc_spawnPlayer]]();
				self thread printJoinedTeam(self.pers["team"]);
				level checkMatchStart();
			}
			else
			{
				[[level.fnc_spawnPlayer]]();
				self thread printJoinedTeam(self.pers["team"]);
			}
		}
	}
	else
	{
		if(isDefined(self.pers["weapon"]))
			self.oldweapon = self.pers["weapon"];

		self.pers["weapon"] = weapon;
		self.sessionteam = self.pers["team"];

		if(self.sessionstate != "playing")
			self.statusicon = "gfx/hud/hud@status_dead.tga";
	
		if(self.pers["team"] == "allies")
			otherteam = "axis";
		else if(self.pers["team"] == "axis")
			otherteam = "allies";
			
		// if joining a team that has no opponents, just spawn
		if(!level.didexist[otherteam] && !level.roundended)
		{
			self.spawned = undefined;
			[[level.fnc_spawnPlayer]]();
			self thread printJoinedTeam(self.pers["team"]);
		}				
		else if(!level.didexist[self.pers["team"]] && !level.roundended)
		{
			self.spawned = undefined;
			[[level.fnc_spawnPlayer]]();
			self thread printJoinedTeam(self.pers["team"]);
			level checkMatchStart();
		}
		else
		{
			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

			if(self.pers["team"] == "allies")
			{
				if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname);
				else
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname);
			}
			else if(self.pers["team"] == "axis")
			{
				if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND", weaponname);
				else
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND", weaponname);
			}
		}
	}
	self thread maps\mp\gametypes\_teams::SetSpectatePermissions();
	if (isdefined (self.autobalance_notify))
		self.autobalance_notify destroy();




	return true;


	if (menu == game["menu_serverinfo"] && response == "close") {
		self.pers["skipserverinfo"] = true;
		self openMenu(game["menu_team"]);
		return;
	}

	if (response == "open" || response == "close") {
		if (isDefined(self.wrs_PickAWeapon)) {
			self.wrs_PickAWeapon = undefined;
			removeWeaponSelectionHud();
			self iPrintLn("You can't play without picking weapons!");
		}
		return;
	}

	if (response == "weapon") {
		self.pers["weapon"] = undefined;
		self thread wrs_PickAWeapon();
		self iPrintLn("Pick weapons before you can play!");
	} else if (response == "viewmap") {
		self openMenu(game["menu_viewmap"]);
	} else if (response == "callvote") {
		self openMenu(game["menu_callvote"]);
	} else {
		if (menu == game["menu_team"]) {
			if ((isDefined(level.lockteams) && level.lockteams) || self.pers["team"] == response) {
				return;
			}
			switch(response) {
			case "allies":
			case "axis":
			case "autoassign":
				if (response == "autoassign") {
					numonteam["allies"] = 0;
					numonteam["axis"] = 0;
					for (i = 0;i < level.wrs_Players.size;i++) {
						player = level.wrs_Players[i];
						if (isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player != self) {
							numonteam[player.pers["team"]]++;
						}
					}
					if (numonteam["allies"] == numonteam["axis"]) {
						if (getTeamScore("allies") == getTeamScore("axis")) {
							if (randomInt(2)) {
								response = "allies";
							} else {
								response = "axis";
							}
						}
						else if (getTeamScore("allies") < getTeamScore("axis")) {
							response = "allies";
						} else {
							response = "axis";
						}
					}
					else if (numonteam["allies"] < numonteam["axis"]) {
						response = "allies";
					} else {
						response = "axis";
					}
					skipbalance = true;
				}
				if (level.teambalance && !isDefined(skipbalance)) {
					skipbalance = undefined;

					numonteam["allies"] = 0;
					numonteam["axis"] = 0;
					for (i = 0;i < level.wrs_Players.size;i++) {
						player = level.wrs_Players[i];
						if (isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player != self) {
							numonteam[player.pers["team"]]++;
						}
					}
					if (response == "allies") {
						otherteam = "axis";
					} else {
						otherteam = "allies";
					}
					if (numonteam[response] > numonteam[otherteam]) {
						if (response == "allies") {
							if (game["allies"] == "american") {
								self iPrintLnBold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_AMERICAN");
							} else if (game["allies"] == "british") {
								self iPrintLnBold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_BRITISH");
							} else if (game["allies"] == "russian") {
								self iPrintLnBold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_RUSSIAN");
							}
						}
						else{
							if (game["allies"] == "american") {
								self iPrintLnBold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_AMERICAN");
							} else if (game["allies"] == "british") {
								self iPrintLnBold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_BRITISH");
							} else if (game["allies"] == "russian") {
								self iPrintLnBold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_RUSSIAN");
							}
						}
						break;
					}
				}
				if (self.sessionstate == "playing" && response != self.pers["team"]) {
					self suicide();
				}

				self.pers["team"] = response;
				self.pers["teamTime"] = (gettime() / 1000);
				self.pers["weapon"] = undefined;
				self.pers["savedmodel"] = undefined;

				maps\mp\gametypes\_teams::SetSpectatePermissions();

				self setClientCvar("ui_weapontab", "1");

				self thread wrs_PickAWeapon();

				if (level.gametype != "sd") {
					iPrintLn(self.name," ^7joined ",self.pers["team"]);
				}

				break;
			case "spectator":
				if (isAlive(self)) {
					self suicide();
				}

				self.pers["team"] = "spectator";
				self.pers["teamTime"] = 1000000;
				self.pers["weapon"] = undefined;
				self.pers["savedmodel"] = undefined;

				self.sessionteam = "spectator";
				self setClientCvar("g_scriptMainMenu", game["menu_team"]);
				self setClientCvar("ui_weapontab", "0");
				[[level.fnc_spawnSpectator]]();
				break;
			}
		} else if (menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"]) {
			if (response != 0) {
				if (!isDefined(self.pers["weapon"])) {
					self.pers["weapon"][0] = response;
					self thread wrs_PickAWeapon();
				} else {
					if (self.pers["weapon"][0] == response) {
						self thread wrs_PickAWeapon();
						self iPrintLn("Weapon already picked!");
						return;
					}
					self.pers["weapon"][1] = response;
					if (level.gametype == "sd") {
						if (!game["matchstarted"]) {
							self.spawned = undefined;
							[[level.fnc_spawnPlayer]]();
							iPrintLn(self.name," ^7joined ",self.pers["team"]);
							level maps\mp\gametypes\sd::checkMatchStart();
						}
						else if (!level.roundstarted) {
							if (!level.exist[self.pers["team"]]) {
								self.spawned = undefined;
								[[level.fnc_spawnPlayer]]();
								iPrintLn(self.name," ^7joined ",self.pers["team"]);
								level maps\mp\gametypes\sd::checkMatchStart();
							}
							else{
								[[level.fnc_spawnPlayer]]();
								iPrintLn(self.name," ^7joined ",self.pers["team"]);
							}
						}
						else{
							self.sessionteam = self.pers["team"];

							if (self.sessionstate != "playing") {
								self.statusicon = "gfx/hud/hud@status_dead.tga";
							}

							if (self.pers["team"] == "allies") {
								otherteam = "axis";
							} else if (self.pers["team"] == "axis") {
								otherteam = "allies";
							}

							// if joining a team that has no opponents, just spawn
							if (!level.didexist[otherteam] && !level.roundended) {
								self.spawned = undefined;
								[[level.fnc_spawnPlayer]]();
								iPrintLn(self.name," ^7joined ",self.pers["team"]);
							}
							else if (!level.didexist[self.pers["team"]] && !level.roundended) {
								self.spawned = undefined;
								[[level.fnc_spawnPlayer]]();
								iPrintLn(self.name," ^7joined ",self.pers["team"]);
								level maps\mp\gametypes\sd::checkMatchStart();
							}
							else{
								self iPrintLn("You will spawn with new weapons");
							}
						}
						self thread maps\mp\gametypes\_teams::SetSpectatePermissions();
						if (isdefined (self.autobalance_notify)) {
							self.autobalance_notify destroy();
						}
					} else {
						if (self.sessionstate != "playing") {
							[[level.fnc_spawnPlayer]]();
						} else {
							self iPrintLn("You will spawn with new weapons");
						}
>>>>>>> origin/master
					}
				}
			}
		}
<<<<<<< HEAD
		self thread maps\mp\gametypes\_teams::SetSpectatePermissions();
		if (isdefined (self.autobalance_notify))
			self.autobalance_notify destroy();
	} else if (level.gametype == "tdm") {
		if(!isDefined(self.pers["weapon"]))
		{
			self.pers["weapon"] = weapon;
			spawnPlayer();
			self thread printJoinedTeam(self.pers["team"]);
		}
		else
		{
			self.pers["weapon"] = weapon;

			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

			if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
			else
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
		}
		if (isdefined (self.autobalance_notify))
			self.autobalance_notify destroy();
	} else {
		// ERROR
	}

	return true;
}


wrs_round_info(time) {
	cleanUp(false);

	x.position = 480.0;
	y.position = 180.0;
	x.size     = 112.0;
	y.size     = 160.0;
=======
		else if (menu == game["menu_quickcommands"])
			maps\mp\gametypes\_teams::quickcommands(response);
		else if (menu == game["menu_quickstatements"])
			maps\mp\gametypes\_teams::quickstatements(response);
		else if (menu == game["menu_quickresponses"])
			maps\mp\gametypes\_teams::quickresponses(response);
	}
}


//WEAPON MENU
wrs_PickAWeapon()
{
	self.wrs_PickAWeapon = true;
	choice = selectWeapon();
	if (isDefined(self.wrs_PickAWeapon)) {
		self notify("menuresponse", game["menu_weapon_allies"], level.wrs_weapons[choice][1]);
		self.wrs_PickAWeapon = false;
	}
}
selectWeapon()
{
	createWeaponSelectionHud();

	weapon = 0;
	self.wrs_WeaponHud_Indicator.y = level.wrs_WeaponHud_y + 44;
	while (1) {
		if (!isDefined(self.wrs_PickAWeapon)) {
			removeWeaponSelectionHud();
			return 0;
		}
		if (self attackButtonPressed()) {
			weapon++;
			if (weapon > 5) {
				weapon = 0;
			}

			self.wrs_WeaponHud_Indicator.y = level.wrs_WeaponHud_y + 44 + weapon * 16;
			self playLocalSound("hq_score");

			while (self attackButtonPressed()) {
				wait .05;
			}
		}
		else if (self meleeButtonPressed()) {
			weapon--;
			if (weapon < 0) {
				weapon = 5;
			}

			self.wrs_WeaponHud_Indicator.y = level.wrs_WeaponHud_y + 44 + weapon * 16;
			self playLocalSound("hq_score");

			while (self meleeButtonPressed()) {
				wait .05;
			}
		}
		else if (self useButtonPressed()) {
			while (self useButtonPressed()) {
				wait .05;
			}

			self playLocalSound("player_out_of_ammo");

			break;
		}
		wait .05;
	}

	removeWeaponSelectionHud();
	return weapon;
}
createWeaponSelectionHud(primary) {
	level.wrs_WeaponHud_width = 200;
	level.wrs_WeaponHud_height =136;

	level.wrs_WeaponHud_x = 320 - level.wrs_WeaponHud_width/2;
	level.wrs_WeaponHud_y = -64 + 240 - level.wrs_WeaponHud_height/2;

	if (isDefined(self.wrs_WeaponHud_bg))
		return;
	//CONTAINER
	self.wrs_WeaponHud_bg = newClientHudElem(self);
	self.wrs_WeaponHud_bg.archived = false;
	self.wrs_WeaponHud_bg.alpha = .7;
	self.wrs_WeaponHud_bg.x = level.wrs_WeaponHud_x;
	self.wrs_WeaponHud_bg.y = level.wrs_WeaponHud_y;
	self.wrs_WeaponHud_bg.sort = 9000;
	self.wrs_WeaponHud_bg.color = (0,0,0);
	self.wrs_WeaponHud_bg setShader("white", level.wrs_WeaponHud_width, level.wrs_WeaponHud_height);
	//TITLE CONTAINER
	self.wrs_WeaponHud_Cont = newClientHudElem(self);
	self.wrs_WeaponHud_Cont.archived = false;
	self.wrs_WeaponHud_Cont.alpha = .3;
	self.wrs_WeaponHud_Cont.x = level.wrs_WeaponHud_x + 3;
	self.wrs_WeaponHud_Cont.y = level.wrs_WeaponHud_y + 2;
	self.wrs_WeaponHud_Cont.sort = 9001;
	self.wrs_WeaponHud_Cont setShader("white", level.wrs_WeaponHud_width - 6, 32);
	//TITLE TEXT
	self.wrs_WeaponHud_ContText = newClientHudElem(self);
	self.wrs_WeaponHud_ContText.archived = false;
	self.wrs_WeaponHud_ContText.alignX = "center";
	self.wrs_WeaponHud_ContText.x = level.wrs_WeaponHud_x + level.wrs_WeaponHud_width/2;
	self.wrs_WeaponHud_ContText.y = level.wrs_WeaponHud_y + 4;
	self.wrs_WeaponHud_ContText.sort = 9998;
	if (!isDefined(self.pers["weapon"])) {
		self.wrs_WeaponHud_ContText.label = level.wrs_hud_weapon_header[0];
	} else {
		self.wrs_WeaponHud_ContText.label = level.wrs_hud_weapon_header[1];
	}
	self.wrs_WeaponHud_ContText.fontscale = 1.2;
	//LEFT CONTAINER LINE
	self.wrs_WeaponHud_LL = newClientHudElem(self);
	self.wrs_WeaponHud_LL.archived = false;
	self.wrs_WeaponHud_LL.alpha = .3;
	self.wrs_WeaponHud_LL.x = level.wrs_WeaponHud_x + 3;
	self.wrs_WeaponHud_LL.y = level.wrs_WeaponHud_y + 34;
	self.wrs_WeaponHud_LL.sort = 9001;
	self.wrs_WeaponHud_LL setShader("white", 1, level.wrs_WeaponHud_height - 37);
	//RIGHT CONTAINER LINE
	self.wrs_WeaponHud_RL = newClientHudElem(self);
	self.wrs_WeaponHud_RL.archived = false;
	self.wrs_WeaponHud_RL.alpha = .3;
	self.wrs_WeaponHud_RL.x = level.wrs_WeaponHud_x + (level.wrs_WeaponHud_width - 4);
	self.wrs_WeaponHud_RL.y = level.wrs_WeaponHud_y + 34;
	self.wrs_WeaponHud_RL.sort = 9001;
	self.wrs_WeaponHud_RL setShader("white", 1, level.wrs_WeaponHud_height - 37);
	//UNDER CONTAINER LINE
	self.wrs_WeaponHud_UL = newClientHudElem(self);
	self.wrs_WeaponHud_UL.archived = false;
	self.wrs_WeaponHud_UL.alpha = .3;
	self.wrs_WeaponHud_UL.x = level.wrs_WeaponHud_x + 3;
	self.wrs_WeaponHud_UL.y = level.wrs_WeaponHud_y + (level.wrs_WeaponHud_height - 3);
	self.wrs_WeaponHud_UL.sort = 9001;
	self.wrs_WeaponHud_UL setShader("white", level.wrs_WeaponHud_width - 6, 1);
	//WEAPONS //LOOP FAILS BECAUSE OF POTENTIAL INFINITE LOOP!
	for (i = 0; i < 6; i++) {
		self.wrs_WeaponHud_Wps[i] = newClientHudElem(self);
		self.wrs_WeaponHud_Wps[i].archived = false;
		self.wrs_WeaponHud_Wps[i].x = level.wrs_WeaponHud_x + 25;
		self.wrs_WeaponHud_Wps[i].y = level.wrs_WeaponHud_y + 36 + (i * 16);
		self.wrs_WeaponHud_Wps[i].sort = 9998;
		self.wrs_WeaponHud_Wps[i].fontScale = 1.1;
		self.wrs_WeaponHud_Wps[i] setText(level.wrs_weapons[i][0]);
		if (isDefined(self.pers["weapon"]) &&
			self.pers["weapon"][0] == level.wrs_weapons[i][1]) {
			self.wrs_WeaponHud_Wps[i].color = (0,0,1);
		}
	}
	//CURRENT VOTE INDICATOR
	self.wrs_WeaponHud_Indicator = newClientHudElem( self );
	self.wrs_WeaponHud_Indicator.alignY = "middle";
	self.wrs_WeaponHud_Indicator.x = level.wrs_WeaponHud_x + 3;
	self.wrs_WeaponHud_Indicator.y = level.wrs_WeaponHud_y + 33;
	self.wrs_WeaponHud_Indicator.archived = false;
	self.wrs_WeaponHud_Indicator.sort = 9998;
	self.wrs_WeaponHud_Indicator.alpha = .3;
	self.wrs_WeaponHud_Indicator.color = (0, 0, 1);
	self.wrs_WeaponHud_Indicator setShader("white", level.wrs_WeaponHud_width - 6, 17);
}
removeWeaponSelectionHud()
{
	if (!isDefined(self.wrs_WeaponHud_bg))
		return;

	self.wrs_WeaponHud_bg       destroy();
	self.wrs_WeaponHud_Cont     destroy();
	self.wrs_WeaponHud_ContText destroy();
	self.wrs_WeaponHud_LL       destroy();
	self.wrs_WeaponHud_RL       destroy();
	self.wrs_WeaponHud_UL       destroy();
	self.wrs_WeaponHud_Indicator    destroy();
	for (i = 0; i < 6; i++) self.wrs_WeaponHud_Wps[i] destroy();
}






wrs_round_info(time) {
	cleanUp(false);

	position["x"] = 480.0;
	position["y"] = 180.0;

	size["x"] = 112.0;
	size["y"] = 160.0;
>>>>>>> origin/master

	if (game["axisscore"] > game["alliedscore"]) {
		alc = (.9,.3,.3);
		axc = (.3,.9,.3);
	} else if (game["axisscore"] < game["alliedscore"]) {
		alc = (.3,.9,.3);
		axc = (.9,.3,.3);
	} else {
		axc = (.3,.3,.3);
		alc = (.3,.3,.3);
	}

	//SCOREBOARD TEXT
	level.wrs_hud_round_info[0]           = newHudElem();
<<<<<<< HEAD
	level.wrs_hud_round_info[0].x         = x.position + x.size/2;
	level.wrs_hud_round_info[0].y         = y.position + 0;
=======
	level.wrs_hud_round_info[0].x         = position["x"] + size["x"]/2;
	level.wrs_hud_round_info[0].y         = position["y"] + 0;
>>>>>>> origin/master
	level.wrs_hud_round_info[0].alignX    = "center";
	level.wrs_hud_round_info[0].alignY    = "top";
	level.wrs_hud_round_info[0].fontscale = 1.5;
	level.wrs_hud_round_info[0] setText(level.wrs_round_info[0]);

	//ALLIES TEXT
	level.wrs_hud_round_info[1] = newHudElem();
<<<<<<< HEAD
	level.wrs_hud_round_info[1].x = x.position + x.size/2 - 15;
	level.wrs_hud_round_info[1].y = y.position + y.size*((float)2/10);
=======
	level.wrs_hud_round_info[1].x = position["x"] + size["x"]/2 - 15;
	level.wrs_hud_round_info[1].y = position["y"] + size["y"]*((float)2/10);
>>>>>>> origin/master
	level.wrs_hud_round_info[1].alignX = "right";
	level.wrs_hud_round_info[1].alignY = "top";
	level.wrs_hud_round_info[1] setText(level.wrs_round_info[1]);
	level.wrs_hud_round_info[1].fontscale = .85;
	//AXIS TEXT
	level.wrs_hud_round_info[2] = newHudElem();
<<<<<<< HEAD
	level.wrs_hud_round_info[2].x = x.position + x.size/2 + 15;
	level.wrs_hud_round_info[2].y = y.position + y.size*((float)2/10);
=======
	level.wrs_hud_round_info[2].x = position["x"] + size["x"]/2 + 15;
	level.wrs_hud_round_info[2].y = position["y"] + size["y"]*((float)2/10);
>>>>>>> origin/master
	level.wrs_hud_round_info[2].alignX = "left";
	level.wrs_hud_round_info[2].alignY = "top";
	level.wrs_hud_round_info[2] setText(level.wrs_round_info[2]);
	level.wrs_hud_round_info[2].fontscale = .85;
	//ALLIES ICON
	level.wrs_hud_round_info[3] = newHudElem();
<<<<<<< HEAD
	level.wrs_hud_round_info[3].x = x.position + x.size/2;
	level.wrs_hud_round_info[3].y = y.position + y.size*((float)2/10);
=======
	level.wrs_hud_round_info[3].x = position["x"] + size["x"]/2;
	level.wrs_hud_round_info[3].y = position["y"] + size["y"]*((float)2/10);
>>>>>>> origin/master
	level.wrs_hud_round_info[3].alignX = "right";
	level.wrs_hud_round_info[3].alignY = "top";
	level.wrs_hud_round_info[3] setShader(level.wrs_hud_info_allies,15,15);
	//AXIS ICON
	level.wrs_hud_round_info[4] = newHudElem();
<<<<<<< HEAD
	level.wrs_hud_round_info[4].x = x.position + x.size/2;
	level.wrs_hud_round_info[4].y = y.position + y.size*((float)2/10);
=======
	level.wrs_hud_round_info[4].x = position["x"] + size["x"]/2;
	level.wrs_hud_round_info[4].y = position["y"] + size["y"]*((float)2/10);
>>>>>>> origin/master
	level.wrs_hud_round_info[4].alignX = "left";
	level.wrs_hud_round_info[4].alignY = "top";
	level.wrs_hud_round_info[4] setShader(level.wrs_hud_info_axis,15,15);
	//ALLIES SCORE TEXT
	level.wrs_hud_round_info[5] = newHudElem();
<<<<<<< HEAD
	level.wrs_hud_round_info[5].x = x.position + x.size*((float)1/4);
	level.wrs_hud_round_info[5].y = y.position + y.size*((float)3/10);
=======
	level.wrs_hud_round_info[5].x = position["x"] + size["x"]*((float)1/4);
	level.wrs_hud_round_info[5].y = position["y"] + size["y"]*((float)3/10);
>>>>>>> origin/master
	level.wrs_hud_round_info[5].alignX = "center";
	level.wrs_hud_round_info[5].alignY = "top";
	level.wrs_hud_round_info[5] setValue(game["alliedscore"]);
	level.wrs_hud_round_info[5].fontscale = 1.5;
	level.wrs_hud_round_info[5].color = alc;
	//AXIS SCORE TEXT
	level.wrs_hud_round_info[6] = newHudElem();
<<<<<<< HEAD
	level.wrs_hud_round_info[6].x = x.position + x.size*((float)3/4);
	level.wrs_hud_round_info[6].y = y.position + y.size*((float)3/10);
=======
	level.wrs_hud_round_info[6].x = position["x"] + size["x"]*((float)3/4);
	level.wrs_hud_round_info[6].y = position["y"] + size["y"]*((float)3/10);
>>>>>>> origin/master
	level.wrs_hud_round_info[6].alignX = "center";
	level.wrs_hud_round_info[6].alignY = "top";
	level.wrs_hud_round_info[6] setValue(game["axisscore"]);
	level.wrs_hud_round_info[6].fontscale = 1.5;
	level.wrs_hud_round_info[6].color = axc;

	//TIMER
	level.wrs_hud_round_info[7] = newHudElem();
<<<<<<< HEAD
	level.wrs_hud_round_info[7].x = x.position + x.size*((float)2/4);
	level.wrs_hud_round_info[7].y = y.position + y.size*((float)6/10);
=======
	level.wrs_hud_round_info[7].x = position["x"] + size["x"]*((float)2/4);
	level.wrs_hud_round_info[7].y = position["y"] + size["y"]*((float)6/10);
>>>>>>> origin/master
	level.wrs_hud_round_info[7].alignX = "center";
	level.wrs_hud_round_info[7].alignY = "top";
	level.wrs_hud_round_info[7] setClock(time, 60, "hudStopwatch", 64, 64);

<<<<<<< HEAD
	//HORIZONTAL LINE
	level.wrs_hud_round_info[8] = newHudElem();
	level.wrs_hud_round_info[8].x = x.position + x.size*((float)1/2);
	level.wrs_hud_round_info[8].y = y.position + y.size*((float)3/10);
	level.wrs_hud_round_info[8].alignX = "center";
	level.wrs_hud_round_info[8].alignY = "top";
	level.wrs_hud_round_info[8].alpha = .7;
	level.wrs_hud_round_info[8] setShader("black", x.size*((float)5/6),1);
	//VERTICAL LINE
	level.wrs_hud_round_info[9] = newHudElem();
	level.wrs_hud_round_info[9].x = x.position + x.size*((float)1/2);
	level.wrs_hud_round_info[9].y = y.position + y.size*((float)3/10);
	level.wrs_hud_round_info[9].alignX = "center";
	level.wrs_hud_round_info[9].alignY = "top";
	level.wrs_hud_round_info[9].alpha = .7;
	level.wrs_hud_round_info[9] setShader("black", 1,y.size*((float)1/4));

	wait time;

	for (i = 0; i < level.wrs_hud_round_info.size; i++) {
=======
	//NEXT ROUND TEXT
	level.wrs_hud_round_info[8] = newHudElem();
	level.wrs_hud_round_info[8].x = position["x"] + size["x"]*((float)1/2);
	level.wrs_hud_round_info[8].y = position["y"] + size["y"];
	level.wrs_hud_round_info[8].alignX = "center";
	level.wrs_hud_round_info[8].alignY = "top";
	level.wrs_hud_round_info[8].color = (.9,.9,.1);
	level.wrs_hud_round_info[8].label = level.wrs_round_info[3];
	level.wrs_hud_round_info[8] setValue(game["alliedscore"] + game["axisscore"] + 1);

	//HORIZONTAL LINE
	level.wrs_hud_round_info[9] = newHudElem();
	level.wrs_hud_round_info[9].x = position["x"] + size["x"]*((float)1/2);
	level.wrs_hud_round_info[9].y = position["y"] + size["y"]*((float)3/10);
	level.wrs_hud_round_info[9].alignX = "center";
	level.wrs_hud_round_info[9].alignY = "top";
	level.wrs_hud_round_info[9].alpha = .7;
	level.wrs_hud_round_info[9] setShader("black", size["x"]*((float)5/6),1);
	//VERTICAL LINE
	level.wrs_hud_round_info[10] = newHudElem();
	level.wrs_hud_round_info[10].x = position["x"] + size["x"]*((float)1/2);
	level.wrs_hud_round_info[10].y = position["y"] + size["y"]*((float)3/10);
	level.wrs_hud_round_info[10].alignX = "center";
	level.wrs_hud_round_info[10].alignY = "top";
	level.wrs_hud_round_info[10].alpha = .7;
	level.wrs_hud_round_info[10] setShader("black", 1,size["y"]*((float)1/4));

	wait time;

	for (i = 0;i < level.wrs_hud_round_info.size;i++) {
>>>>>>> origin/master
		level.wrs_hud_round_info[i] destroy();
	}
}


//Miscellaneous functions
in_array(value, array) {
<<<<<<< HEAD
	for (i = 0; i < array.size; i++) {
=======
	for (i = 0;i < array.size;i++) {
>>>>>>> origin/master
		if (array[i] == value) {
			return true;
		}
	}

	return false;
}
wrs_GetStance(checkjump) {
	//Using bits!
	if (checkjump && !self isOnGround())
		return 8;

	switch(self getStance()) {
		case "stand":
			return 4;
		case "crouch":
			return 2;
		case "prone":
			return 1;
	}
}
removeMg42()
{
	mg42s = getEntArray("misc_mg42","classname");
<<<<<<< HEAD
	for (i = 0; i < mg42s.size; i++) {
		if (isdefined(mg42s[i])) {
			mg42s[i] delete();
		}
	}
	mg42s = getEntArray("misc_turret", "classname");
	for (i = 0; i < mg42s.size; i++) {
		if (isdefined(mg42s[i]) && isdefined(mg42s[i].weaponinfo) && ( mg42s[i].weaponinfo == "mg42_bipod_prone_mp" || mg42s[i].weaponinfo == "mg42_bipod_stand_mp" || mg42s[i].weaponinfo == "mg42_bipod_duck_mp")) {
			mg42s[i] delete();
		}
	}
}
substr(word, start, length)
{
	if (!isDefined(word)) {
		return 0;
	}
	if (!isDefined(length)) {
		length = word.size;
	}
	if (!isDefined(start)) {
		start = 0;
	}

	if (start > word.size) {
		return 0;
	}
	if (start + length > word.size) {
		length = word.size - start;
	}

	subword = "";
	for (i = start;i < length; i++) {
		subword += word[i];
	}
=======
	for (i = 0;i < mg42s.size;i++)
		if (isdefined(mg42s[i]))
			mg42s[i] delete();
	mg42s = getEntArray("misc_turret", "classname");
	for (i = 0;i < mg42s.size;i++)
		if (isdefined(mg42s[i]) && isdefined(mg42s[i].weaponinfo) && ( mg42s[i].weaponinfo == "mg42_bipod_prone_mp" || mg42s[i].weaponinfo == "mg42_bipod_stand_mp" || mg42s[i].weaponinfo == "mg42_bipod_duck_mp"))
			mg42s[i] delete();
}
view_origin()
{
	stance = wrs_GetStance(true);
	switch(stance) {
		case 1:
			return self.origin + (0,0,13);
		case 2:
			return self.origin + (0,0,36);
		case 4:
			return self.origin + (0,0,60);
		case 8:
			return self.origin + (0,0,80);
	}
}
substr(word, start, length) {
	if (!isDefined(word))
		return 0;
	if (!isDefined(length))
		length = word.size;
	if (!isDefined(start))
		start = 0;

	if (start > word.size)
		return 0;
	if (start + length > word.size)
		length = word.size - start;

	subword = "";
	for (i = start;i < length;i++)
		subword += word[i];
>>>>>>> origin/master

	return subword;
}
printJoinedTeam(team)
{
	if(team == "allies")
		iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
	else if(team == "axis")
		iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}
