start()
{
	init();
	wrs_labels();

	thread wrs_server_messages();

	maps\mp\gametypes\_wrs_admin::init();
	maps\mp\gametypes\_wrs_fence::init();
	maps\mp\gametypes\_wrs_mapvote::init();
}

init()
{
	level.wrs_weapons[0][0] = &"Kar98k";              level.wrs_weapons[0][1] = "kar98k_mp";
	level.wrs_weapons[1][0] = &"Mosin Nagant";        level.wrs_weapons[1][1] = "mosin_nagant_mp";
	level.wrs_weapons[2][0] = &"Kar98k Sniper";       level.wrs_weapons[2][1] = "kar98k_sniper_mp";
	level.wrs_weapons[3][0] = &"Mosin Nagant Sniper"; level.wrs_weapons[3][1] = "mosin_nagant_sniper_mp";
	level.wrs_weapons[4][0] = &"Springfield";         level.wrs_weapons[4][1] = "springfield_mp";
	level.wrs_weapons[5][0] = &"Lee Enfield";         level.wrs_weapons[5][1] = "enfield_mp";

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

	if (!isDefined(game["gamestarted"])) {
		for (i = 0; i < level.wrs_round_info.size; i++) {
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

		precacheString(&"^3/^7");

		for (i = 0; i < level.wrs_weapons.size; i++) {
			precacheString(level.wrs_weapons[i][0]);
			precacheItem(level.wrs_weapons[i][1]);
		}
		for (i = 0; i < level.wrs_hud_stats_text.size; i++) {
			precacheString(level.wrs_hud_stats_text[i]);
		}

		precacheModel("xmodel/german_field_radio");
	}

	//SPRINTING VARIABLES
	sprint = getCvarInt("scr_wrs_sprint");
	if (sprint < 0) sprint = 12;
	level.wrs_sprint = sprint;                              //1 = prone, 2 = crouch, 4 = standing, 8 = in-air/ladder. Add them up (15 = everything, 12 = in-air and standing)

	sprinttime = getCvarInt("scr_wrs_sprinttime");
	if (sprinttime < 1) sprinttime = 5;
	level.wrs_sprintTime = sprinttime * 10;                 //Seconds recovery time.

	sprintspeed = getCvarFloat("scr_wrs_sprintspeed");
	if (sprintspeed < 1) sprintspeed = 60;
	level.wrs_sprintSpeed = 1+ sprintspeed *0.01;           //Speed in percentage when sprinting. 60% = 1.6 * 190 = 304

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
	level.wrs_leaderboards = boards;

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
		level.wrs_Admins = maps\mp\gametypes\_wrs_admin::explode(" ", getCvar("sys_admins"), 0);
	}

	//REMOVE MG42's
	mg42 = getCvarInt("scr_wrs_mg42");
	if (mg42 <= 0) {
		removeMg42();
	}


	level.wrs_stats_records["score"]     = 0;
	level.wrs_stats_records["bashes"]    = 0;
	level.wrs_stats_records["furthest"]  = 0;
	level.wrs_stats_records["spree"]     = 0;
	level.wrs_stats_records["headshots"] = 0;
	level.wrs_stats_records["differ"]    = 0;
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
				if (sprintLeft > 0) {
					recovertime = (int)(recovertime * sprint + 0.5);
				}
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
		if (oldA < newA || oldB < newB) { //Probably reloaded
			continue;
		}

		if (oldA != newA) {
			a = 1;
		} else {
			a = 0;
		}

		if (a) old = self getWeaponSlotClipAmmo("primary");
		else  old = self getWeaponSlotClipAmmo("primaryb");

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

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (!isAlive(players[i]))
			continue;
		if (players[i].pers["team"] == "allies" && players[i].sessionstate == "playing")
			allies++;
		else if (players[i].pers["team"] == "axis" && players[i].sessionstate == "playing")
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
wrs_labels()
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




wrs_stats_maintain()
{
	if (level.mapended) {
		return;
	}
	if (!isDefined(self.wrs_stats_hud)) {
		for (i = 0; i < level.wrs_hud_stats_text.size; i++) {
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
	if (self.pers["stats"][stat] > level.wrs_stats_records[stat]) {
		level.wrs_stats_records[stat] = self.pers["stats"][stat];

		players = getEntArray("player", "classname");
		for (j = 0;j < players.size;j++) {
			if (isDefined(players[j].wrs_stats_hud)) {
				players[j].wrs_stats_hud[stat].color = (1,1,1);
			}
		}

		self.wrs_stats_hud[stat].color = (0,0,1);
	}
}
wrs_stats_maintain_CheckLevStat(stat, element) {
	if (self.pers["stats"][stat] > level.wrs_stats_records[stat]) {
		level.wrs_stats_records[stat] = self.pers["stats"][stat];

//      players = getEntArray("player", "classname");
//      for (j = 0;j < players.size;j++)
//          if (isDefined(players[j].wrs_stats_hud))
//              players[j].wrs_stats_hud[stat][element].color = (1,1,1);

		self.wrs_stats_hud[stat][element].color = (0,0,1);
	}
}
wrs_stats_maintain_CheckSprStat(stat, element) {
	if (self.pers["stats"][stat] > level.wrs_stats_records[stat]) {
		level.wrs_stats_records[stat] = self.pers["stats"][stat];

		players = getEntArray("player", "classname");
		for (j = 0;j < players.size;j++)
			if (isDefined(players[j].wrs_stats_hud))
				players[j].wrs_stats_hud[element].color = (1,1,1);

		self.wrs_stats_hud[element].color = (0,0,1);
	}
}
wrs_stats_maintain_CheckAllStat(stat) {
	record = self;

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		player = players[i];

		if (!isDefined(player.pers) || !isDefined(player.pers["stats"]))
			continue;

		if (player.pers["stats"][stat] > record.pers["stats"][stat]) {
			record = player;
		}
	}
	for (i = 0; i < players.size; i++) {
		player = players[i];

		if (!isDefined(player.pers) || !isDefined(player.pers["stats"]) || !isDefined(player.wrs_stats_hud))
			continue;

		if (record == player && (float)record.pers["stats"][stat] > 0) {
			level.wrs_stats_records[stat] = record.pers["stats"][stat];
			record.wrs_stats_hud[stat].color = (0,0,1);
		}
		else if (isDefined(player.wrs_stats_hud))
			player.wrs_stats_hud[stat].color = (1,1,1);
	}
}




/* EXTEND STOCK EVENTS */
wrs_PlayerConnect()
{
	if (isDefined(self.pers["stats"])) {
		return;
	}
	self.pers["stats"]["score"]     = 0;
	self.pers["stats"]["bashes"]    = 0;
	self.pers["stats"]["furthest"]  = 0;
	self.pers["stats"]["spree"]     = 0; self.pers["spree"] = 0;
	self.pers["stats"]["headshots"] = 0;
	self.pers["stats"]["differ"]    = 0;

	if (self.name == "" || self.name == "^7" || self.name == "^7 " || self.name.size == 0 || self.name == "Unknown Soldier" || self.name == "UnnamedPlayer" ||
	substr(self.name, 0, 11) == "^1Free Porn" ||
	substr(self.name, 0, 5 ) == "I LUV" ||
	substr(self.name, 0, 27) == "I wear ^6ladies ^7underwear")
		self setClientCvar("name", "^4E^3U^4R^3O^2 GUEST^7 #" + randomInt(1000));

	if (in_array(self getGuid(), level.wrs_Admins)) {
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
	if (isPlayer(attacker) && attacker != self) { //He got killed by a player
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
		distance = (int)(distance(attacker.origin, self.origin) * 170 / 68 / 100); // 170/68 is unit to centimeter ratio (estimate)
		if (distance > attacker.pers["stats"]["furthest"]) {
			attacker.pers["stats"]["furthest"] = distance;
		}

		attacker thread wrs_blip();
	}



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
	self setWeaponSlotWeapon("primary", self.pers["weapon1"]);
	self setWeaponSlotAmmo("primary", 999);
	self setWeaponSlotClipAmmo("primary", 999);

	self setWeaponSlotWeapon("primaryb", self.pers["weapon2"]);
	self setWeaponSlotAmmo("primaryb", 999);
	self setWeaponSlotClipAmmo("primaryb", 999);

	self setSpawnWeapon(self.pers["weapon1"]);

	if (!isDefined(self.pers["welcomed"]) || self.pers["welcomed"] == false) {
		self.pers["welcomed"] = true;

		self iPrintLnBold("Stick to the rules, soldier " + self.name);
		self iPrintLnBold("Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7clanwebsite^4.^7com");
	}

	self thread wrs_stats_maintain();

	if (level.wrs_anti_fastshoot) {
		self thread wrs_anti_fastshoot();
	}

	if (level.wrs_sprint) {
		self thread wrs_sprint();
	}

	if (level.wrs_fence) {
		self thread maps\mp\gametypes\_wrs_fence::monitor();
	}
}

wrs_EndMap(text) {
	cleanUp(true);

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		player = players[i];

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
	if (level.wrs_leaderboards) {
		wrs_leaderboards();
	}

	//MAPVOTING
	if (level.wrs_MapVoting) {
		maps\mp\gametypes\_wrs_mapvote::wrs_MapVote(10);
	}

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if ((!isDefined(players[i].sessionstate) || players[i].sessionstate != "spectator")) //Prevents bug?
			continue;
		players[i] [[level.fnc_spawnIntermission]]();
	}
}

//Printing out the leaderboards
wrs_leaderboards()
{
	winner["score"][0]      = 0; winner["score"][1]     = "^3Best Score^7: ^40";
	winner["bashes"][0]     = 0; winner["bashes"][1]    = "^3Most Bashes^7: ^40";
	winner["furthest"][0]   = 0; winner["furthest"][1]  = "^3Furthest Shot^7: ^40";
	winner["spree"][0]      = 0; winner["spree"][1]     = "^3Longest Spree^7: ^40";
	winner["headshots"][0]  = 0; winner["headshots"][1] = "^3Most Headshots^7: ^40";
	winner["differ"][0]     = 0; winner["differ"][1]    = "^3Best Differential^7: ^40";

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		player = players[i];
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




cleanUp(everything) {
	if (isDefined(level.wrs_hud_info)) {
		for (i = 0; i < level.wrs_hud_info.size; i++) {
			if (isDefined(level.wrs_hud_info[i])) {
				level.wrs_hud_info[i] destroy();
			}
		}
	}
	if (isDefined(level.clock))
		level.clock destroy();

	if (everything) {

		for (i = 0; i < level.wrs_stats_hud.size; i++) {
			if (isDefined(level.wrs_stats_hud)) {
				level.wrs_stats_hud[i] destroy();
			}
		}
	}
	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {

		if (isDefined(players[i].wrs_sprintHud))
			players[i].wrs_sprintHud destroy();
		if (isDefined(players[i].wrs_sprintHud_back))
			players[i].wrs_sprintHud_bg destroy();

		if (everything) {
			if (isDefined(players[i].wrs_stats_hud)) {
				players[i].wrs_stats_hud["score"] destroy();
				players[i].wrs_stats_hud["bashes"] destroy();
				players[i].wrs_stats_hud["furthest"] destroy();
				players[i].wrs_stats_hud["spree"] destroy();
				players[i].wrs_stats_hud["spreemax"] destroy();
				players[i].wrs_stats_hud["headshots"] destroy();
				players[i].wrs_stats_hud["differ"] destroy();
			}

			players[i] removeWeaponSelectionHud();
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
					}
				}
			}
		}
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
	level.wrs_hud_round_info[0].x         = x.position + x.size/2;
	level.wrs_hud_round_info[0].y         = y.position + 0;
	level.wrs_hud_round_info[0].alignX    = "center";
	level.wrs_hud_round_info[0].alignY    = "top";
	level.wrs_hud_round_info[0].fontscale = 1.5;
	level.wrs_hud_round_info[0] setText(level.wrs_round_info[0]);

	//ALLIES TEXT
	level.wrs_hud_round_info[1] = newHudElem();
	level.wrs_hud_round_info[1].x = x.position + x.size/2 - 15;
	level.wrs_hud_round_info[1].y = y.position + y.size*((float)2/10);
	level.wrs_hud_round_info[1].alignX = "right";
	level.wrs_hud_round_info[1].alignY = "top";
	level.wrs_hud_round_info[1] setText(level.wrs_round_info[1]);
	level.wrs_hud_round_info[1].fontscale = .85;
	//AXIS TEXT
	level.wrs_hud_round_info[2] = newHudElem();
	level.wrs_hud_round_info[2].x = x.position + x.size/2 + 15;
	level.wrs_hud_round_info[2].y = y.position + y.size*((float)2/10);
	level.wrs_hud_round_info[2].alignX = "left";
	level.wrs_hud_round_info[2].alignY = "top";
	level.wrs_hud_round_info[2] setText(level.wrs_round_info[2]);
	level.wrs_hud_round_info[2].fontscale = .85;
	//ALLIES ICON
	level.wrs_hud_round_info[3] = newHudElem();
	level.wrs_hud_round_info[3].x = x.position + x.size/2;
	level.wrs_hud_round_info[3].y = y.position + y.size*((float)2/10);
	level.wrs_hud_round_info[3].alignX = "right";
	level.wrs_hud_round_info[3].alignY = "top";
	level.wrs_hud_round_info[3] setShader(level.wrs_hud_info_allies,15,15);
	//AXIS ICON
	level.wrs_hud_round_info[4] = newHudElem();
	level.wrs_hud_round_info[4].x = x.position + x.size/2;
	level.wrs_hud_round_info[4].y = y.position + y.size*((float)2/10);
	level.wrs_hud_round_info[4].alignX = "left";
	level.wrs_hud_round_info[4].alignY = "top";
	level.wrs_hud_round_info[4] setShader(level.wrs_hud_info_axis,15,15);
	//ALLIES SCORE TEXT
	level.wrs_hud_round_info[5] = newHudElem();
	level.wrs_hud_round_info[5].x = x.position + x.size*((float)1/4);
	level.wrs_hud_round_info[5].y = y.position + y.size*((float)3/10);
	level.wrs_hud_round_info[5].alignX = "center";
	level.wrs_hud_round_info[5].alignY = "top";
	level.wrs_hud_round_info[5] setValue(game["alliedscore"]);
	level.wrs_hud_round_info[5].fontscale = 1.5;
	level.wrs_hud_round_info[5].color = alc;
	//AXIS SCORE TEXT
	level.wrs_hud_round_info[6] = newHudElem();
	level.wrs_hud_round_info[6].x = x.position + x.size*((float)3/4);
	level.wrs_hud_round_info[6].y = y.position + y.size*((float)3/10);
	level.wrs_hud_round_info[6].alignX = "center";
	level.wrs_hud_round_info[6].alignY = "top";
	level.wrs_hud_round_info[6] setValue(game["axisscore"]);
	level.wrs_hud_round_info[6].fontscale = 1.5;
	level.wrs_hud_round_info[6].color = axc;

	//TIMER
	level.wrs_hud_round_info[7] = newHudElem();
	level.wrs_hud_round_info[7].x = x.position + x.size*((float)2/4);
	level.wrs_hud_round_info[7].y = y.position + y.size*((float)6/10);
	level.wrs_hud_round_info[7].alignX = "center";
	level.wrs_hud_round_info[7].alignY = "top";
	level.wrs_hud_round_info[7] setClock(time, 60, "hudStopwatch", 64, 64);

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
		level.wrs_hud_round_info[i] destroy();
	}
}


//Miscellaneous functions
in_array(value, array) {
	for (i = 0; i < array.size; i++) {
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

	return subword;
}
printJoinedTeam(team)
{
	if(team == "allies")
		iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
	else if(team == "axis")
		iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}
