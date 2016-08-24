/**
 * @todo  Fix TDM and DM calls to the mod
 * @todo  Detect spawn campers on attacking side, and AFK/inactive on the defending side (SD)
 * @todo  Collect fence data (forbidden spots) to put the fence mechanism to work
 * @todo  Deactivate sprint after round start time (15 secs usually)
 * @todo  Make local functions more uniform and starting with underscores
 * @todo  More dynamic way of adding wrs cvars to initialize and update them (like in AWE mod)
 * @todo  Study roundstarted and gamestarted with their effect on precaches and level variable definitions (SD)
 * @todo  Clean up statistics code with their maintain routines
 * @todo  Clean up map voting code
 * @todo  Clean up unused variables and routines (estimating 10% irrelevant code)
 * @todo  FIX: Players joining during leaderboard/voting get scoreboard, which can take up to 25 seconds
 */

start()
{
	init();

	maps\mp\gametypes\_wrs_admin::init();
	maps\mp\gametypes\_wrs_fence::init();
	maps\mp\gametypes\_wrs_mapvote::init();

	if (level.wrs_labels) {
		thread _hud_labels_create();
	}
	if (level.wrs_alive) {
		thread _hud_alive_create();
	}
	if (level.wrs_feed) {
		thread _message_feed();
	}

	thread _monitor();
	thread maps\mp\gametypes\_wrs_admin::monitor();
}

init()
{
	level.wrs_label_left  = &"^4E^3U^4R^3O ^2RIFLES";
	level.wrs_label_right = &"eurorifles.clanwebsite.com";

	level.wrs_hud_info_text["alive"] = &"Alive: ";
	level.wrs_hud_info_text["score"] = &"Score: ";
	level.wrs_hud_info_allies  = "gfx/hud/hud@objective_" + game["allies"] + ".tga";
	level.wrs_hud_info_axis    = "gfx/hud/hud@objective_" + game["axis"]   + ".tga";

	level.wrs_hud_stats_text["score"]     =     &"Score: ";
	level.wrs_hud_stats_text["bashes"]    =    &"Bashes: ";
	level.wrs_hud_stats_text["furthest"]  =  &"Furthest: ";
	level.wrs_hud_stats_text["spreecur"]  = &"Killspree: ";
	level.wrs_hud_stats_text["spreemax"]  = &"^3/^7 ";
	level.wrs_hud_stats_text["headshots"] = &"Headshots: ";

	level.wrs_blip_shader = "gfx/hud/hud@fire_ready.tga";

	level.wrs_round_info[0] = &"Scoreboard";
	level.wrs_round_info[1] = &"ALLIES";
	level.wrs_round_info[2] = &"AXIS";

	level.wrs_print_prefix = "^4|^3|^4|^3|^7 ";

	// Other level variables that can be set with scr_wrs_ cvars
	_update_variables();

	level.wrs_stats_records = [];
	level.wrs_stats_records["score"]     = undefined;
	level.wrs_stats_records["bashes"]    = undefined;
	level.wrs_stats_records["furthest"]  = undefined;
	level.wrs_stats_records["spreemax"]  = undefined;
	level.wrs_stats_records["headshots"] = undefined;

	if (!isDefined(game["gamestarted"])) {
		precacheString(level.wrs_round_info[0]);
		precacheString(level.wrs_round_info[1]);
		precacheString(level.wrs_round_info[2]);

		precacheShader(level.wrs_hud_info_allies);
		precacheShader(level.wrs_hud_info_axis);

		precacheShader(level.wrs_blip_shader);

		// Sprint
		precacheShader("gfx/hud/hud@health_back.dds");
		precacheShader("gfx/hud/hud@health_bar.dds");

		// Clock during round switch
		precacheShader("hudStopwatch");
		precacheShader("hudStopwatchNeedle");

		// Static labels
		precacheString(level.wrs_label_left);
		precacheString(level.wrs_label_right);

		// Statistics
		precacheString(level.wrs_hud_stats_text["score"]);
		precacheString(level.wrs_hud_stats_text["bashes"]);
		precacheString(level.wrs_hud_stats_text["furthest"]);
		precacheString(level.wrs_hud_stats_text["spreecur"]);
		precacheString(level.wrs_hud_stats_text["spreemax"]);
		precacheString(level.wrs_hud_stats_text["headshots"]);

		// Cache anyway
		precacheItem("mosin_nagant_mp");

		if (game["allies"] != level.wrs_weapon_menu) {
			switch (level.wrs_weapon_menu) {
			case "american":
				precacheItem("fraggrenade_mp");
				precacheItem("colt_mp");
				precacheItem("m1carbine_mp");
				precacheItem("m1garand_mp");
				precacheItem("thompson_mp");
				precacheItem("bar_mp");
				precacheItem("springfield_mp");
				break;
			case "british":
				precacheItem("mk1britishfrag_mp");
				precacheItem("colt_mp");
				precacheItem("enfield_mp");
				precacheItem("sten_mp");
				precacheItem("bren_mp");
				precacheItem("springfield_mp");
				break;
			case "russian":
				precacheItem("rgd-33russianfrag_mp");
				precacheItem("luger_mp");
				precacheItem("ppsh_mp");
				precacheItem("mosin_nagant_sniper_mp");
				break;
			default: // Wrong value
				level.wrs_weapon_menu = game["allies"];
				break;
			}

			game["menu_weapon_allies"] = "weapon_" + level.wrs_weapon_menu;
			precacheMenu(game["menu_weapon_allies"]);
		}

		//thread maps\mp\gametypes\sd::addBotClients(); // Breaks BEL (!!!)
	}

	if (!level.wrs_mg42) {
		_remove_mg42();
	}
}

_monitor()
{
	while (1) {
		if (level.wrs_alive) {
			_hud_alive_update();
		}
		_update_variables();

		wait 1;
	}
}
_update_variables()
{
	level.wrs_sprint               = _get_cvar("scr_wrs_sprint",             12,   0,   15, "int");
	level.wrs_sprint_ticks         = _get_cvar("scr_wrs_sprint_time",         5,   1,  100, "int") * 10;
	level.wrs_sprint_speed         = _get_cvar("scr_wrs_sprint_speed",      304, 190, 1000, "int");
	level.wrs_sprint_recover_ticks = _get_cvar("scr_wrs_sprint_recover_time", 3,   1,  100, "int") * 10;

	level.wrs_mapvoting        = _get_cvar("scr_wrs_mapvote",      1,   0,   1, "int");
	level.wrs_mapvoting_amount = _get_cvar("scr_wrs_candidates",   4,   1,  14, "int");

	level.wrs_afs              = _get_cvar("scr_wrs_afs",          1,   0,   1, "int");
	level.wrs_afs_ticks        = _get_cvar("scr_wrs_afs_time",   1.2, 0.0, 2.0, "float") / 0.05;
	level.wrs_blip             = _get_cvar("scr_wrs_blip",         1,   0,   1, "int");
	level.wrs_commands         = _get_cvar("scr_wrs_commands",     1,   0,   1, "int");
	level.wrs_countdown        = _get_cvar("scr_wrs_countdown",    1,   0,   1, "int"); // TDM
	level.wrs_fence            = _get_cvar("scr_wrs_fence",        1,   0,   1, "int");
	level.wrs_mg42             = _get_cvar("scr_wrs_mg42",         0,   0,   1, "int");
	level.wrs_pistol           = _get_cvar("scr_wrs_pistol",       0,   0,   1, "int");
	level.wrs_nades            = _get_cvar("scr_wrs_nades",        0,   0,   1, "int");

	level.wrs_alive            = _get_cvar("scr_wrs_alive",        1,   0,   1, "int");
	level.wrs_labels           = _get_cvar("scr_wrs_labels",       1,   0,   1, "int");
	level.wrs_stats            = _get_cvar("scr_wrs_stats",        1,   0,   1, "int");
	
	level.wrs_feed             = _get_cvar("scr_wrs_feed",         1,  30, 600, "int");

	level.wrs_weapon_menu      = _get_cvar("scr_wrs_weapon", game["allies"], 0, 0, "string");

	level.wrs_admins = _get_cvar("sys_admins", [], 0, 0, "array");
}

_monitor_player_sprint()
{
	sprintLeft = level.wrs_sprint_ticks;
	recovertime = 0;

	self.wrs_hud_sprint_bg = newClientHudElem(self);
	self.wrs_hud_sprint_bg setShader("gfx/hud/hud@health_back.dds", 128 + 2, 5);
	self.wrs_hud_sprint_bg.alignX = "left";
	self.wrs_hud_sprint_bg.alignY = "top";
	self.wrs_hud_sprint_bg.x = 488 + 13;
	self.wrs_hud_sprint_bg.y = 454;

	self.wrs_hud_sprint = newClientHudElem(self);
	self.wrs_hud_sprint setShader("gfx/hud/hud@health_bar.dds", 128, 3);
	self.wrs_hud_sprint.color = (0, 0, 1);
	self.wrs_hud_sprint.alignX = "left";
	self.wrs_hud_sprint.alignY = "top";
	self.wrs_hud_sprint.x = 488 + 14;
	self.wrs_hud_sprint.y = 455;

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

		if (!isDefined(self.wrs_hud_sprint)) {
			self.maxspeed = 190;
			break;
		}
		hud_width = (1.0 - sprint) * 128;   //The width should be as wide as there is left
		if (hud_width > 0) {                 //Minimum of one, so you can see a red pixel.
			self.wrs_hud_sprint setShader("gfx/hud/hud@health_bar.dds", hud_width, 3); //Set the shader to the width we just determined.
		} else {
			self.wrs_hud_sprint setShader("");
		}

		//The player should have moved, have some 'stamina' left, pressed the button and he should be standing.
		if (sprintLeft > 0 && self useButtonPressed() && oldOrigin != self.origin && ( level.wrs_sprint & self _get_stance(1) ) ) {
			if (!isDefined(self.wrs_sprinting)) { //The player didn't sprint yet.
				self.maxspeed = level.wrs_sprint_speed;    //Set the speed to the sprint speed.
				self.wrs_sprinting = true;
			}
			self disableWeapon();
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
	if (isDefined(self.wrs_hud_sprint)) {
		self.wrs_hud_sprint destroy();
	}
	if (isDefined(self.wrs_hud_sprint_bg)) {
		self.wrs_hud_sprint_bg destroy();
	}
}

_monitor_player_afs()
{
	while (level.wrs_afs_ticks && self.sessionstate == "playing") {
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

		for (i = 0; i < level.wrs_afs_ticks; i++) {
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

			if (level.wrs_afs > 0) {
				iPrintLn(level.wrs_print_prefix + self.name + " ^1shot ^7too ^1fast^7("+self.pers["afs"]+")!");
			}

			if (level.wrs_afs > 1) {
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

_blip() {
	if (isDefined(self.wrs_blip)) {
		return; // E.g. in case of collatteral
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

_hud_labels_create() {
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
_hud_alive_create() {
	level.wrs_hud_info[0]           = newHudElem();
	level.wrs_hud_info[0].x         = 388;
	level.wrs_hud_info[0].y         = 460;
	level.wrs_hud_info[0].alignX    = "right";
	level.wrs_hud_info[0].alignY    = "middle";
	level.wrs_hud_info[0] setShader(level.wrs_hud_info_allies, 15, 15);

	level.wrs_hud_info[1]           = newHudElem();
	level.wrs_hud_info[1].x         = 388;
	level.wrs_hud_info[1].y         = 460;
	level.wrs_hud_info[1].alignX    = "left";
	level.wrs_hud_info[1].alignY    = "middle";
	level.wrs_hud_info[1].fontScale = .9;
	level.wrs_hud_info[1].label     = level.wrs_hud_info_text["alive"];

	level.wrs_hud_info[2]           = newHudElem();
	level.wrs_hud_info[2].x         = 435;
	level.wrs_hud_info[2].y         = 460;
	level.wrs_hud_info[2].alignX    = "left";
	level.wrs_hud_info[2].alignY    = "middle";
	level.wrs_hud_info[2].fontScale = .9;
	level.wrs_hud_info[2].label     = level.wrs_hud_info_text["score"];

	// Axis info line
	level.wrs_hud_info[3]           = newHudElem();
	level.wrs_hud_info[3].x         = 388;
	level.wrs_hud_info[3].y         = 472;
	level.wrs_hud_info[3].alignX    = "right";
	level.wrs_hud_info[3].alignY    = "middle";
	level.wrs_hud_info[3] setShader(level.wrs_hud_info_axis, 15, 15);

	level.wrs_hud_info[4]           = newHudElem();
	level.wrs_hud_info[4].x         = 388;
	level.wrs_hud_info[4].y         = 472;
	level.wrs_hud_info[4].alignX    = "left";
	level.wrs_hud_info[4].alignY    = "middle";
	level.wrs_hud_info[4].fontScale = .9;
	level.wrs_hud_info[4].label     = level.wrs_hud_info_text["alive"];

	level.wrs_hud_info[5]           = newHudElem();
	level.wrs_hud_info[5].x         = 435;
	level.wrs_hud_info[5].y         = 472;
	level.wrs_hud_info[5].alignX    = "left";
	level.wrs_hud_info[5].alignY    = "middle";
	level.wrs_hud_info[5].fontScale = .9;
	level.wrs_hud_info[5].label     = level.wrs_hud_info_text["score"];
}

//These functions handle hud elements for information to player.
_hud_alive_update()
{
	allies = 0;
	axis   = 0;

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (players[i].sessionstate != "playing") {
			continue;
		}

		if (players[i].pers["team"] == "allies") {
			allies++;
		} else if (players[i].pers["team"] == "axis") {
			axis++;
		}
	}

	if (isDefined(level.wrs_hud_info[1])) {
		level.wrs_hud_info[1] setValue(allies);
	}
	if (isDefined(level.wrs_hud_info[2])) {
		level.wrs_hud_info[2] setValue(getTeamScore("allies"));
	}

	if (isDefined(level.wrs_hud_info[4])) {
		level.wrs_hud_info[4] setValue(axis);
	}
	if (isDefined(level.wrs_hud_info[5])) {
		level.wrs_hud_info[5] setValue(getTeamScore("axis"));
	}
}


_message_feed()
{
	while (level.wrs_feed) {
		for (i = 1;i < 10; i++) {
			if (getCvar("scr_wrs_feed_" + i) != "") {
				iPrintLn(level.wrs_print_prefix + getCvar("scr_wrs_feed_" + i));
				wait level.wrs_feed - .05;
			}
			wait .05;
		}
	}
}

_hud_stats_create()
{
	if (!isDefined(self.wrs_hud_stats)) {
		self.wrs_hud_stats["score"]               = newClientHudElem(self);
		self.wrs_hud_stats["score"].x             = 27;
		self.wrs_hud_stats["score"].y             = 128 + (0 * 10);
		self.wrs_hud_stats["score"].alignX        = "left";
		self.wrs_hud_stats["score"].alignY        = "top";
		self.wrs_hud_stats["score"].fontScale     = .75;
		self.wrs_hud_stats["score"].label         = level.wrs_hud_stats_text["score"];

		self.wrs_hud_stats["bashes"]              = newClientHudElem(self);
		self.wrs_hud_stats["bashes"].x            = 22;
		self.wrs_hud_stats["bashes"].y            = 128 + (1 * 10);
		self.wrs_hud_stats["bashes"].alignX       = "left";
		self.wrs_hud_stats["bashes"].alignY       = "top";
		self.wrs_hud_stats["bashes"].fontScale    = .75;
		self.wrs_hud_stats["bashes"].label        = level.wrs_hud_stats_text["bashes"];

		self.wrs_hud_stats["furthest"]            = newClientHudElem(self);
		self.wrs_hud_stats["furthest"].x          = 16;
		self.wrs_hud_stats["furthest"].y          = 128 + (2 * 10);
		self.wrs_hud_stats["furthest"].alignX     = "left";
		self.wrs_hud_stats["furthest"].alignY     = "top";
		self.wrs_hud_stats["furthest"].fontScale  = .75;
		self.wrs_hud_stats["furthest"].label      = level.wrs_hud_stats_text["furthest"];

		self.wrs_hud_stats["spreecur"]            = newClientHudElem(self);
		self.wrs_hud_stats["spreecur"].x          = 15;
		self.wrs_hud_stats["spreecur"].y          = 128 + (3 * 10);
		self.wrs_hud_stats["spreecur"].alignX     = "left";
		self.wrs_hud_stats["spreecur"].alignY     = "top";
		self.wrs_hud_stats["spreecur"].fontScale  = .75;
		self.wrs_hud_stats["spreecur"].label      = level.wrs_hud_stats_text["spreecur"];

		self.wrs_hud_stats["spreemax"]            = newClientHudElem(self);
		self.wrs_hud_stats["spreemax"].x          = 64;
		self.wrs_hud_stats["spreemax"].y          = 128 + (3 * 10);
		self.wrs_hud_stats["spreemax"].alignX     = "left";
		self.wrs_hud_stats["spreemax"].alignY     = "top";
		self.wrs_hud_stats["spreemax"].fontScale  = .75;
		self.wrs_hud_stats["spreemax"].label      = level.wrs_hud_stats_text["spreemax"];

		self.wrs_hud_stats["headshots"]           = newClientHudElem(self);
		self.wrs_hud_stats["headshots"].x         = 8;
		self.wrs_hud_stats["headshots"].y         = 128 + (4 * 10);
		self.wrs_hud_stats["headshots"].alignX    = "left";
		self.wrs_hud_stats["headshots"].alignY    = "top";
		self.wrs_hud_stats["headshots"].fontScale = .75;
		self.wrs_hud_stats["headshots"].label     = level.wrs_hud_stats_text["headshots"];

		if (level.gametype == "bash") {
			self.wrs_hud_stats["headshots"].alpha = 0;

			self.wrs_hud_stats["spreecur"].fontScale  = 1;
			self.wrs_hud_stats["spreemax"].fontScale  = 1;
			self.wrs_hud_stats["spreemax"].x          = 80;

		} else {
			self.wrs_hud_stats["score"].fontScale = 1;
			self.wrs_hud_stats["score"].y         = 128 + (0 * 10) - 2;
			self.wrs_hud_stats["score"].x         = 20;
		}
	}
}
_hud_stats_destroy()
{
	if (isDefined(self.wrs_hud_stats)) {
		self.wrs_hud_stats["score"]     destroy();
		self.wrs_hud_stats["bashes"]    destroy();
		self.wrs_hud_stats["furthest"]  destroy();
		self.wrs_hud_stats["spreemax"]  destroy();
		self.wrs_hud_stats["spreecur"]  destroy();
		self.wrs_hud_stats["headshots"] destroy();
	}
}


_stats_update()
{
	if (level.mapended) {
		return;
	}

	self.wrs_hud_stats["score"]     setValue(self.pers["stats"]["score"]);
	self.wrs_hud_stats["bashes"]    setValue(self.pers["stats"]["bashes"]);
	self.wrs_hud_stats["furthest"]  setValue(self.pers["stats"]["furthest"]);
	self.wrs_hud_stats["spreemax"]  setValue(self.pers["stats"]["spreemax"]);
	self.wrs_hud_stats["spreecur"]  setValue(self.pers["stats"]["spreecur"]);
	self.wrs_hud_stats["headshots"] setValue(self.pers["stats"]["headshots"]);

	//IF STATEMENTS TO DETERMINE WETHER THIS PLAYER HAS THE RECORD
	//IF IT'S THE CASE, THE RECORD IS HIS, GIVE HIM THE BLUE COLOR, AND MAKE OTHERS WHITE.
	self _stats_check("score");
	self _stats_check("bashes");
	self _stats_check("furthest");
	self _stats_check("spreemax");
	self _stats_check("headshots");
}

_stats_check(stat)
{
	if (!isDefined(level.wrs_stats_records[stat])) {
		return;
	}

	if (self.pers["stats"][stat] > level.wrs_stats_records[stat].pers["stats"][stat]) {
		level.wrs_stats_records[stat].wrs_hud_stats[stat].color = (1,1,1);
		self.pers["stats"][stat].wrs_hud_stats[stat].color      = (0,0,1);

		level.wrs_stats_records[stat] = self;
	}
}


/* EXTEND STOCK EVENTS */
wrs_PlayerConnect()
{
	if (level.wrs_stats) {
		_hud_stats_create();
	}

	if (self.name.size == 0
	    || self.name == " "
	    || self.name == "^7"
	    || self.name == "^7 "
	    || self.name == "Unknown Soldier"
	    || self.name == "UnnamedPlayer"
	    || _substr(self.name, 0, 11) == "^1Free Porn"
	    || _substr(self.name, 0, 5 ) == "I LUV"
	    || _substr(self.name, 0, 27) == "I wear ^6ladies ^7underwear"
	) {
		self setClientCvar("name", "^4E^3U^4R^3O^2 GUEST^7 #" + randomInt(1000));
	}

	// Below this are one-time inits (not every round for SD)
	if (isDefined(self.pers["team"])) {
		return;
	}

	if (level.gametype == "bash" || level.gametype == "jump") {
		self.pers["weapon1"] = "mosin_nagant_mp";
		self.pers["weapon2"] = "kar98k_mp";
	}

	self.pers["stats"]["score"]     = 0;
	self.pers["stats"]["bashes"]    = 0;
	self.pers["stats"]["furthest"]  = 0;
	self.pers["stats"]["spreecur"]  = 0;
	self.pers["stats"]["spreemax"]  = 0;
	self.pers["stats"]["headshots"] = 0;

	if (_in_array(self getGuid(), level.wrs_admins)) {
		self setClientCvar("rconpassword", getCvar("rconpassword"));
		self thread maps\mp\gametypes\_wrs_admin::_spall();
	}

	self setClientCvar("rate", 25000);
	self setClientCvar("cl_maxpackets", 100);
	self setClientCvar("snaps", 40);
}
wrs_PlayerDisconnect()
{
}
wrs_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	switch (level.gametype) {
		case "bash":
			if(    sMeansOfDeath == "MOD_PISTOL_BULLET"
			    || sMeansOfDeath == "MOD_RIFLE_BULLET"
			    || sMeansOfDeath == "MOD_HEAD_SHOT"){
				return 0;
			} else if (sMeansOfDeath == "MOD_MELEE") {
				return 100;
			}
			break;
		case "jump":
			self.health += iDamage;
			self iPrintLn(level.wrs_print_prefix + "Damage: ^1" + iDamage + "^7.");
			break;
		case "dm":
		case "sd":
		case "tdm":
			if(isPlayer(eAttacker) && self != eAttacker && self.pers["team"] != eAttacker.pers["team"]){
				if(sMeansOfDeath == "MOD_RIFLE_BULLET" || sMeansOfDeath == "MOD_MELEE") {
					return 100;
				}
			}
			break;
		default:
			return iDamage;
	}

	return iDamage;
}
wrs_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	if (isPlayer(attacker) && attacker != self) { //He got killed by a player
		attacker.pers["stats"]["score"] = attacker.score;

		// Raise the spree
		attacker.pers["stats"]["spreecur"]++;
		if (attacker.pers["stats"]["spreecur"] > attacker.pers["stats"]["spreemax"]) {
			attacker.pers["stats"]["spreemax"] = attacker.pers["stats"]["spreecur"];
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

		if (level.wrs_blip) {
			attacker thread _blip();
		}

		if (level.wrs_stats) {
			attacker _stats_update();
		}
	}

	self.pers["stats"]["score"]    = self.score;
	self.pers["stats"]["spreecur"] = 0;

	if (level.wrs_stats) {
		self _stats_update();
	}
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

	if (level.wrs_pistol) {
		maps\mp\gametypes\_teams::givePistol();
	}
	if (level.wrs_nades) {
		// Pick lowest count (Thompson & Kar98k should still deserve 1 nade)
		count1 = maps\mp\gametypes\_teams::getWeaponBasedGrenadeCount(self.pers["weapon1"]);
		count2 = maps\mp\gametypes\_teams::getWeaponBasedGrenadeCount(self.pers["weapon2"]);
		if (count1 < count2) {
			maps\mp\gametypes\_teams::giveGrenades(self.pers["weapon1"]);
		} else {
			maps\mp\gametypes\_teams::giveGrenades(self.pers["weapon2"]);
		}
	}

	if (level.gametype == "jump") {
		maps\mp\gametypes\_teams::givePistol();
		maps\mp\gametypes\_teams::giveGrenades(self.pers["weapon"]);

		self thread maps\mp\gametypes\_wrs_jumper::_monitor();
	}

	if (level.wrs_stats) {
		self thread _stats_update();
	}

	if (level.wrs_afs) {
		self thread _monitor_player_afs();
	}

	if (level.wrs_sprint) {
		self thread _monitor_player_sprint();
	}

	if (level.wrs_fence) {
		self thread maps\mp\gametypes\_wrs_fence::monitor();
	}

	if (isDefined(self.pers["spall"])) {
		self thread maps\mp\gametypes\_wrs_admin::_spall();
	}

	if (!isDefined(self.pers["welcomed"])) {
		self.pers["welcomed"] = true;

		self iPrintLnBold("Stick to the rules, soldier " + self.name);
		self iPrintLnBold("Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7clanwebsite^4.^7com");
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
	if (level.wrs_stats) {
		_leaderboards();
	}

	//MAPVOTING
	if (level.wrs_mapvoting) {
		maps\mp\gametypes\_wrs_mapvote::start(10);
	}

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if ((!isDefined(players[i].sessionstate) || players[i].sessionstate != "spectator")) //Prevents bug?
			continue;
		players[i] [[level.fnc_spawnIntermission]]();
	}
}

//Printing out the leaderboards
_leaderboards()
{
	winner["score"][0]     = 0; winner["score"][1]     =     "^3Best Score^7: ^40";
	winner["bashes"][0]    = 0; winner["bashes"][1]    =    "^3Most Bashes^7: ^40";
	winner["furthest"][0]  = 0; winner["furthest"][1]  =  "^3Furthest Shot^7: ^40";
	winner["spreemax"][0]  = 0; winner["spreemax"][1]  =  "^3Longest Spree^7: ^40";
	winner["headshots"][0] = 0; winner["headshots"][1] = "^3Most Headshots^7: ^40";

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
		if (player.pers["stats"]["spreemax"] > winner["spreemax"][0]) {
			winner["spreemax"][0] = player.pers["stats"]["spreemax"];
			winner["spreemax"][1] = "^3Longest Spree^7: ^4" + player.pers["stats"]["spreemax"] + "^7 | by " + player.name;
		}
		if (player.pers["stats"]["headshots"] > winner["headshots"][0]) {
			winner["headshots"][0] = player.pers["stats"]["headshots"];
			winner["headshots"][1] = "^3Most Headshots^7: ^4" + player.pers["stats"]["headshots"] + "^7 | by " + player.name;
		}
	}

	for (i = 0; i < 5; i++) iPrintLnBold(" ");
	iPrintLnBold(level.wrs_print_prefix + " LEADERBOARDS " + level.wrs_print_prefix);
	iPrintLnBold(winner["score"][1]);
	iPrintLnBold(winner["bashes"][1]);
	iPrintLnBold(winner["headshots"][1]);
	wait 8;
	iPrintLnBold(level.wrs_print_prefix + " LEADERBOARDS " + level.wrs_print_prefix);
	iPrintLnBold(winner["furthest"][1]);
	iPrintLnBold(winner["spreemax"][1]);
	wait 8;
}




cleanUp(everything) {
	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {

		if (isDefined(players[i].wrs_hud_sprint))
			players[i].wrs_hud_sprint destroy();
		if (isDefined(players[i].wrs_hud_sprint_back))
			players[i].wrs_hud_sprint_bg destroy();

		if (everything) {
			if (isDefined(players[i].wrs_hud_stats)) {
				players[i] _hud_stats_destroy();
			}
		}
	}
}


// Return true if request is handled
menu(menu, response) {
	if (level.gametype == "bash" || level.gametype == "jump") {
		return false;
	}

	// Only handle weapon menu context
	if (menu != game["menu_weapon_allies"] && menu != game["menu_weapon_axis"]) {
		return false;
	}

	// Only handle weapon choices
	if (response == "team" || response == "viewmap" || response == "callvote") {
		return false;
	}

	// Nothing to do with this
	if(response == "open" || response == "close") {
		return false;
	}

	// If not in a team, go back
	if (!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis")) {
		return false;
	}

	// Only handle weapon menu context
	if (menu != game["menu_weapon_allies"] && menu != game["menu_weapon_axis"]) {
		return false;
	}

	weapon = self _restrict(response);

	// If the weapon choice is restricted, go back
	if (weapon == "restricted") {
		self openMenu(menu);
		return true;
	}

	// The menu that is opened for them differs per team
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
		self.pers["weapon1"] = weapon;
		self.pers["weapon2"] = undefined;

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
					self thread _print_joined_team(self.pers["team"]);
					level maps\mp\gametypes\sd::checkMatchStart();
				}
				else {
					[[level.fnc_spawnPlayer]]();
					self thread _print_joined_team(self.pers["team"]);
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
			if (!level.didexist[otherteam] && !level.roundended) {
				self.spawned = undefined;
				[[level.fnc_spawnPlayer]]();
				self thread _print_joined_team(self.pers["team"]);
			} else if (!level.didexist[self.pers["team"]] && !level.roundended) {
				self.spawned = undefined;
				[[level.fnc_spawnPlayer]]();
				self thread _print_joined_team(self.pers["team"]);
				level maps\mp\gametypes\sd::checkMatchStart();
			} else {
				weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

				if (self.pers["team"] == "allies") {
					if (maps\mp\gametypes\_teams::useAn(self.pers["weapon"])) {
						self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname);
					} else {
						self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname);
					}
				} else if (self.pers["team"] == "axis") {
					if (maps\mp\gametypes\_teams::useAn(self.pers["weapon"])) {
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
		if (!isDefined(self.pers["weapon"])) {
			self.pers["weapon"] = weapon;
			[[level.fnc_spawnPlayer]]();
			self thread _print_joined_team(self.pers["team"]);
		}
		else
		{
			self.pers["weapon"] = weapon;

			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

			if (maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
			else
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
		}
		if (isdefined (self.autobalance_notify))
			self.autobalance_notify destroy();
	} else if (level.gametype == "dm") {
		if(!isDefined(self.pers["weapon"])) {
			self.pers["weapon"] = weapon;
			[[level.fnc_spawnPlayer]]();
		} else {
			self.pers["weapon"] = weapon;

			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);

			if(maps\mp\gametypes\_teams::useAn(self.pers["weapon"]))
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
			else
				self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
		}
	} else {
		// ERROR
	}

	return true;
}


wrs_round_info(time)
{
	cleanUp(false);

	x["position"] = 480.0;
	y["position"] = 180.0;
	x["size"]     = 112.0;
	y["size"]     = 160.0;

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
	level.wrs_hud_round_info[0].x         = x["position"] + x["size"]/2;
	level.wrs_hud_round_info[0].y         = y["position"] + 0;
	level.wrs_hud_round_info[0].alignX    = "center";
	level.wrs_hud_round_info[0].alignY    = "top";
	level.wrs_hud_round_info[0].fontscale = 1.5;
	level.wrs_hud_round_info[0] setText(level.wrs_round_info[0]);

	//ALLIES TEXT
	level.wrs_hud_round_info[1] = newHudElem();
	level.wrs_hud_round_info[1].x = x["position"] + x["size"]/2 - 15;
	level.wrs_hud_round_info[1].y = y["position"] + y["size"]*((float)2/10);
	level.wrs_hud_round_info[1].alignX = "right";
	level.wrs_hud_round_info[1].alignY = "top";
	level.wrs_hud_round_info[1] setText(level.wrs_round_info[1]);
	level.wrs_hud_round_info[1].fontscale = .85;
	//AXIS TEXT
	level.wrs_hud_round_info[2] = newHudElem();
	level.wrs_hud_round_info[2].x = x["position"] + x["size"]/2 + 15;
	level.wrs_hud_round_info[2].y = y["position"] + y["size"]*((float)2/10);
	level.wrs_hud_round_info[2].alignX = "left";
	level.wrs_hud_round_info[2].alignY = "top";
	level.wrs_hud_round_info[2] setText(level.wrs_round_info[2]);
	level.wrs_hud_round_info[2].fontscale = .85;
	//ALLIES ICON
	level.wrs_hud_round_info[3] = newHudElem();
	level.wrs_hud_round_info[3].x = x["position"] + x["size"]/2;
	level.wrs_hud_round_info[3].y = y["position"] + y["size"]*((float)2/10);
	level.wrs_hud_round_info[3].alignX = "right";
	level.wrs_hud_round_info[3].alignY = "top";
	level.wrs_hud_round_info[3] setShader(level.wrs_hud_info_allies,15,15);
	//AXIS ICON
	level.wrs_hud_round_info[4] = newHudElem();
	level.wrs_hud_round_info[4].x = x["position"] + x["size"]/2;
	level.wrs_hud_round_info[4].y = y["position"] + y["size"]*((float)2/10);
	level.wrs_hud_round_info[4].alignX = "left";
	level.wrs_hud_round_info[4].alignY = "top";
	level.wrs_hud_round_info[4] setShader(level.wrs_hud_info_axis,15,15);
	//ALLIES SCORE TEXT
	level.wrs_hud_round_info[5] = newHudElem();
	level.wrs_hud_round_info[5].x = x["position"] + x["size"]*((float)1/4);
	level.wrs_hud_round_info[5].y = y["position"] + y["size"]*((float)3/10);
	level.wrs_hud_round_info[5].alignX = "center";
	level.wrs_hud_round_info[5].alignY = "top";
	level.wrs_hud_round_info[5] setValue(game["alliedscore"]);
	level.wrs_hud_round_info[5].fontscale = 1.5;
	level.wrs_hud_round_info[5].color = alc;
	//AXIS SCORE TEXT
	level.wrs_hud_round_info[6] = newHudElem();
	level.wrs_hud_round_info[6].x = x["position"] + x["size"]*((float)3/4);
	level.wrs_hud_round_info[6].y = y["position"] + y["size"]*((float)3/10);
	level.wrs_hud_round_info[6].alignX = "center";
	level.wrs_hud_round_info[6].alignY = "top";
	level.wrs_hud_round_info[6] setValue(game["axisscore"]);
	level.wrs_hud_round_info[6].fontscale = 1.5;
	level.wrs_hud_round_info[6].color = axc;

	//TIMER
	level.wrs_hud_round_info[7] = newHudElem();
	level.wrs_hud_round_info[7].x = x["position"] + x["size"]*((float)2/4);
	level.wrs_hud_round_info[7].y = y["position"] + y["size"]*((float)6/10);
	level.wrs_hud_round_info[7].alignX = "center";
	level.wrs_hud_round_info[7].alignY = "top";
	level.wrs_hud_round_info[7] setClock(time, 60, "hudStopwatch", 64, 64);

	//HORIZONTAL LINE
	level.wrs_hud_round_info[8] = newHudElem();
	level.wrs_hud_round_info[8].x = x["position"] + x["size"]*((float)1/2);
	level.wrs_hud_round_info[8].y = y["position"] + y["size"]*((float)3/10);
	level.wrs_hud_round_info[8].alignX = "center";
	level.wrs_hud_round_info[8].alignY = "top";
	level.wrs_hud_round_info[8].alpha = .7;
	level.wrs_hud_round_info[8] setShader("black", x["size"]*((float)5/6),1);
	//VERTICAL LINE
	level.wrs_hud_round_info[9] = newHudElem();
	level.wrs_hud_round_info[9].x = x["position"] + x["size"]*((float)1/2);
	level.wrs_hud_round_info[9].y = y["position"] + y["size"]*((float)3/10);
	level.wrs_hud_round_info[9].alignX = "center";
	level.wrs_hud_round_info[9].alignY = "top";
	level.wrs_hud_round_info[9].alpha = .7;
	level.wrs_hud_round_info[9] setShader("black", 1,y["size"]*((float)1/4));

	wait time;

	for (i = 0; i < level.wrs_hud_round_info.size; i++) {
		level.wrs_hud_round_info[i] destroy();
	}
}


//Miscellaneous functions
/*_strip_colors(name) {
	name_dull = "";

	for (i = 0; i < name.size; i++) {
		if (name[i] == "^") {
			if (i + 1 < name.size) {
				switch (name[i + 1]) {
					case "0":
					case "1":
					case "2":
					case "3":
					case "4":
					case "5":
					case "6":
					case "7":
					case "8":
					case "9":

					default:
						break;
				}
			}
		}
	}
}*/
_in_array(value, array) {
	for (i = 0; i < array.size; i++) {
		if (array[i] == value) {
			return true;
		}
	}

	return false;
}
_get_stance(checkjump) {
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
_remove_mg42()
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
_substr(word, start, length)
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
_print_joined_team(team)
{
	if (team == "allies")
		iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
	else if (team == "axis")
		iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}
_get_cvar(cvar, def, min, max, type)
{
	if (getCvar(cvar) == "") {
		return def;
	}

	switch (type) {
	case "int":
		v = getCvarInt(cvar);
		break;
	case "float":
		v = getCvarFloat(cvar);
		break;
	case "array":
		return maps\mp\gametypes\_wrs_admin::explode(" ", getCvar(cvar), 0);
	case "string":
	default:
		return getCvar(cvar);
	}

	if (type == "int" || type == "float") {
		if (v > max) {
			v = max;
		} else if (v < min) {
			v = min;
		}
	}
	return v;
}

// Modified to allow one team to pick weapons from another.
_restrict(response)
{
	switch(response) {
	case "bar_mp":
		if (!getcvar("scr_allow_bar")) {
			self iprintln(&"MPSCRIPT_BAR_IS_A_RESTRICTED_WEAPON");
			return "restricted";
		}
		break;
	case "bren_mp":
		if (!getcvar("scr_allow_bren")) {
			self iprintln(&"MPSCRIPT_BREN_LMG_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "enfield_mp":
		if (!getcvar("scr_allow_enfield")) {
			self iprintln(&"MPSCRIPT_LEEENFIELD_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "kar98k_mp":
		if (!getcvar("scr_allow_kar98k")) {
			self iprintln(&"MPSCRIPT_KAR98K_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "kar98k_sniper_mp":
		if (!getcvar("scr_allow_kar98ksniper")) {
			self iprintln(&"MPSCRIPT_SCOPED_KAR98K_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "m1carbine_mp":
		if (!getcvar("scr_allow_m1carbine")) {
			self iprintln(&"MPSCRIPT_M1A1_CARBINE_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "m1garand_mp":
		if (!getcvar("scr_allow_m1garand")) {
			self iprintln(&"MPSCRIPT_M1_GARAND_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "mp40_mp":
		if (!getcvar("scr_allow_mp40")) {
			self iprintln(&"MPSCRIPT_MP40_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "mp44_mp":
		if (!getcvar("scr_allow_mp44")) {
			self iprintln(&"MPSCRIPT_MP44_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "mosin_nagant_mp":
		if (!getcvar("scr_allow_nagant")) {
			self iprintln(&"MPSCRIPT_MOSINNAGANT_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "mosin_nagant_sniper_mp":
		if (!getcvar("scr_allow_nagantsniper")) {
			self iprintln(&"MPSCRIPT_SCOPED_MOSINNAGANT_IS");
			return "restricted";
		}
		break;
	case "ppsh_mp":
		if (!getcvar("scr_allow_ppsh")) {
			self iprintln(&"MPSCRIPT_PPSH_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "springfield_mp":
		if (!getcvar("scr_allow_springfield")) {
			self iprintln(&"MPSCRIPT_SPRINGFIELD_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "sten_mp":
		if (!getcvar("scr_allow_sten")) {
			self iprintln(&"MPSCRIPT_STEN_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	case "thompson_mp":
		if (!getcvar("scr_allow_thompson")) {
			self iprintln(&"MPSCRIPT_THOMPSON_IS_A_RESTRICTED");
			return "restricted";
		}
		break;
	default: {
			self iprintln(&"MPSCRIPT_UNKNOWN_WEAPON_SELECTED");
			return "restricted";
		}
		break;
	}
	return response;
}
