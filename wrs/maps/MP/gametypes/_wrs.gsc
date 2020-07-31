/**
 * @todo  Show gametypes when voting if they are not all the same
 * @todo  Detect spawn campers on attacking side, and AFK/inactive on the defending side (SD)
 * @todo  Make local functions more uniform and starting with underscores
 * @todo  Clean up statistics code with their maintain routines
 * @todo  Clean up unused variables and routines (estimating 10% irrelevant code)
 * @todo  FIX: Players joining during leaderboard/voting get scoreboard, which can take up to 25 seconds
 */

start()
{
	init();

	maps\mp\gametypes\_wrs_admin::init();

	if (game["_labels"]) {
		hud\labels::create(undefined, undefined, level._label_bl, level._label_br);
	}
	if (game["_hud_alive"]) {
		hud\alive::create();
	}
	if (level.wrs_feed) {
		thread _message_feed();
	}

	thread _monitor();
	thread maps\mp\gametypes\_wrs_admin::monitor();
}

init()
{
	level._label_bl  = &"^4E^3U^4R^3O ^2RIFLES";
	level._label_br = &"eurorifles.clanwebsite.com";

	level.wrs_hud_stats_text["score"]     =     &"Score: ";
	level.wrs_hud_stats_text["bashes"]    =    &"Bashes: ";
	level.wrs_hud_stats_text["furthest"]  =  &"Furthest: ";
	level.wrs_hud_stats_text["spreecur"]  = &"Killspree: ";
	level.wrs_hud_stats_text["spreemax"]  = &"^3/^7 ";
	level.wrs_hud_stats_text["headshots"] = &"Headshots: ";

	level._prefix = "^4|^3|^4|^3|^7 ";

	level.wrs_stats_records = [];

	level._nade_count_rifle = 3;
	level._nade_count_smg = 2;
	level._nade_count_mg = 2;
	level._nade_count_sniper = 1;

	level._jumper = getCvar("g_gametype") == "jump";

	// Other level variables that can be set with scr_wrs_ cvars
	_update_variables();

	if (!isDefined(game["gamestarted"])) {
		monitor\sprint::precache(); // Health bar.

		// Weapon choice mechanism.
		// 0 for default.
		// 1 for picking a secondary weapon, optionally from specified allies.
		// 2 for fixed, pre-selected weapons.
		game["_weapons"] = 0;
		s = _get_cvar("scr_wrs_weapon", game["allies"], 0, 0, "string");
		if (s == "opponent") {
			game["_weapons"] = 1;
		} else if (s == "american" || s == "british" || s == "russian") {
			game["_weapons"] = 1;
			game["menu_weapon_allies"] = "weapon_" + s;
		} else if (s != "" && s != "0" && s != "default") {
			game["_weapons"] = 2;
			game["_weapons_arr"] = util::explode(s, " ", 0);
			for (i = 0; i < game["_weapons_arr"].size; i++) {
				game["_weapons_arr"][i] += "_mp";
			}
		}
		menu_weapon::precache();

		game["_hud_alive"] = !!getCvarInt("scr_wrs_alive");
		game["_hud_hit_blip"] = true;
		hud::precache();

		game["_vote_map"] = getCvarInt("scr_wrs_mapvote");
		game["_vote_sprint"] = !!getCvarInt("scr_wrs_vote_sprint");
		vote\main::precache();
		if (game["_vote_map"]) {
			vote\map::precache();
		}
		if (game["_vote_sprint"]) {
			vote\sprint::precache();
		}

		game["_labels"] = !!getCvarInt("scr_wrs_labels");
		if (game["_labels"]) {
			// Static labels
			precacheString(level._label_bl);
			precacheString(level._label_br);
		}

		hud\scoreboard::precache();
		precacheString(&"MPSCRIPT_THE_GAME_IS_A_TIE");
		precacheString(&"MPSCRIPT_ALLIES_WIN");
		precacheString(&"MPSCRIPT_AXIS_WIN");
		precacheString(&"SD_MATCHSTARTING");
		precacheString(&"SD_MATCHRESUMING");
		precacheString(&"MPSCRIPT_STARTING_NEW_ROUND");

		// Clock during round switch
		precacheShader("hudStopwatch");
		precacheShader("hudStopwatchNeedle");

		// Statistics
		precacheString(level.wrs_hud_stats_text["score"]);
		precacheString(level.wrs_hud_stats_text["bashes"]);
		precacheString(level.wrs_hud_stats_text["furthest"]);
		precacheString(level.wrs_hud_stats_text["spreecur"]);
		precacheString(level.wrs_hud_stats_text["spreemax"]);
		precacheString(level.wrs_hud_stats_text["headshots"]);
	}

	if (!level.wrs_mg42) {
		maps\mp\gametypes\_teams::deletePlacedEntity("misc_mg42");
	}
}

_monitor()
{
	while (1) {
		if (game["_hud_alive"]) {
			hud\alive::update();
		}
		_update_variables();

		wait 1;
	}
}
_update_variables()
{
	level._sprint              = _get_cvar("scr_wrs_sprint",             60,   0,  300, "int");
	level._sprint_time         = _get_cvar("scr_wrs_sprint_time",         5,   1,  100, "int");
	level._sprint_time_recover = _get_cvar("scr_wrs_sprint_time_recover", 6,   1,  100, "int");

	level._anti_fastshoot = _get_cvar("scr_wrs_afs",          2,   0,   2, "int");
	level._anti_aimrun = true;
	level._anti_speeding = false;
	level._allow_drop = false;

	level._afk_to_spec = true;
	level._fence = !!getCvarInt("scr_wrs_fence");
	level.wrs_mg42         = _get_cvar("scr_wrs_mg42",         0,   0,   1, "int");
	level._allow_pistol = _get_cvar("scr_wrs_pistol",       0,   0,   1, "int");
	level._allow_nades = _get_cvar("scr_wrs_nades",        0,   0,   1, "int");

	level.wrs_stats        = _get_cvar("scr_wrs_stats",        1,   0,   1, "int");

	level.wrs_1s1k         = _get_cvar("scr_wrs_1s1k",         1,   0,   1, "int");

	level.wrs_drop_primary = _get_cvar("scr_wrs_drop_primary", 1,   0,   2, "int");
	level.wrs_drop_health  = _get_cvar("scr_wrs_drop_health",  1,   0,   2, "int");

	level.wrs_feed             = _get_cvar("scr_wrs_feed",         1,  30, 600, "int");

	level.wrs_admins         = _get_cvar("sys_admins",        [], 0, 0, "array");
	level.wrs_admins_enabled = _get_cvar("sys_admins_enabled", 1, 0, 1, "int");
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
			self.wrs_hud_stats["spreemax"].x          = 88;
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
		level.wrs_stats_records[stat] = self;
		return;
	}

	if (self.pers["stats"][stat] > level.wrs_stats_records[stat].pers["stats"][stat]) {
		level.wrs_stats_records[stat].wrs_hud_stats[stat].color = (1,1,1);
		self.wrs_hud_stats[stat].color                          = (0,0,1);

		level.wrs_stats_records[stat] = self;
	}
}

_message_feed()
{
	while (level.wrs_feed) {
		for (i = 1; i < 10; i++) {
			if (getCvar("scr_wrs_feed_" + i) != "") {
				iPrintLn(level._prefix + getCvar("scr_wrs_feed_" + i));
				wait level.wrs_feed - 0.05;
			}
			wait 0.05;
		}
	}
}


/* EXTEND STOCK EVENTS */
wrs_PlayerConnect()
{
	if (level.wrs_stats) {
		_hud_stats_create();
	}

	if (_strip_colors(util::strip_spaces(self.name)) == ""
	    || self.name == "Unknown Soldier"
	    || self.name == "UnnamedPlayer"
	    || _substr(self.name, 0, 11) == "^1Free Porn"
	    || _substr(self.name, 0, 5 ) == "I LUV"
	    || _substr(self.name, 0, 27) == "I wear ^6ladies ^7underwear"
	) {
		self setClientCvar("name", "^4E^3U^4R^3O^2 GUEST^7 #" + randomInt(1000));
	}

	// harbor_jump fix for crash (darn you, megazor, ugly scripter)
	self.isJumper = false;

	if (level.wrs_admins_enabled && _in_array(self getGuid(), level.wrs_admins)) {
		self setClientCvar("rconpassword", getCvar("rconpassword"));
		self thread maps\mp\gametypes\_wrs_admin::_spall();
	}

	// Below this are one-time inits (not every round for SD)
	if (isDefined(self.pers["team"])) {
		return;
	}

	self.pers["stats"]["score"]     = 0;
	self.pers["stats"]["bashes"]    = 0;
	self.pers["stats"]["furthest"]  = 0;
	self.pers["stats"]["spreecur"]  = 0;
	self.pers["stats"]["spreemax"]  = 0;
	self.pers["stats"]["headshots"] = 0;

	self setClientCvar("rate", 25000);
	// self setClientCvar("cl_maxpackets", 100);
	self setClientCvar("snaps", 40);
	// self setClientCvar("cl_allowdownload", 1);
}
wrs_PlayerDisconnect()
{
	// Change map to Harbor if server is empty.
	if (getEntArray("player", "classname").size <= 1) {
		setCvar("sv_maprotationcurrent", "gametype " + level.gametype + " map mp_harbor");
		exitLevel(false);
	}
}
wrs_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	if (isDefined(self._jumper)) {
		self.health += iDamage;
		self iPrintLn(level._prefix + "Damage: ^1" + iDamage + "^7.");
		return iDamage;
	}


	if (isPlayer(eAttacker) && self != eAttacker) {
		if (isDefined(eAttacker.wrs_jumper)) {
			eAttacker iPrintLn(level._prefix + self.name + " ^7is a ^1jumper^7 and can't be killed!");
			return 0;
		}

		if (level.gametype == "bash") {
			if(    sMeansOfDeath == "MOD_PISTOL_BULLET"
				|| sMeansOfDeath == "MOD_RIFLE_BULLET"
				|| sMeansOfDeath == "MOD_HEAD_SHOT"){
				return 0;
			} else if (sMeansOfDeath == "MOD_MELEE") {
				return 100;
			}
		} else {
			if(level.wrs_1s1k && (sMeansOfDeath == "MOD_RIFLE_BULLET" || sMeansOfDeath == "MOD_MELEE")) {
				return 100;
			}
		}
	}

	return iDamage;
}
wrs_FriendlyFire(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	if (isDefined(eAttacker.wrs_tk)) {
		return 100;
	}

	return 0;
}
wrs_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self notify("killed");

	if (isPlayer(attacker) && attacker != self) { //He got killed by a player
		attacker.pers["stats"]["score"] = attacker.score;

		// Raise the spree
		attacker.pers["stats"]["spreecur"]++;
		if (attacker.pers["stats"]["spreecur"] > attacker.pers["stats"]["spreemax"]) {
			attacker.pers["stats"]["spreemax"] = attacker.pers["stats"]["spreecur"];
		}

		if (level.gametype == "bash") {
			if (attacker.pers["stats"]["spreecur"] % 5 == 0 && attacker.pers["stats"]["spreecur"] != 5) {
				attacker.score += 10000 + ((attacker.pers["stats"]["spreecur"] - 10) / 5 * 50000);
				iPrintLnBold(attacker.name + " ^7is owning with a " + attacker.pers["stats"]["spreecur"] + " killstreak!");
			}
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

		attacker thread hud\hit_blip::show();

		if (level.wrs_stats) {
			attacker _stats_update();
		}
	}

	for (i = 0; i < level.wrs_drop_health; i++) {
		self maps\mp\gametypes\dm::dropHealth();
	}
	if (level.wrs_drop_primary) {
		self dropItem(self getcurrentweapon());
	}

	if (level.gametype == "bash" && self.pers["stats"]["spreecur"] >= 10) {
		if (isPlayer(attacker) && attacker != self) {
			iPrintLnBold(attacker.name + " ^7killed " + self.name + " ^7and finished his " + self.pers["stats"]["spreecur"] + " killstreak!");
		} else {
			iPrintLnBold(self.name + " ^7killed himself and ended his " + self.pers["stats"]["spreecur"] + " killstreak!");
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
	equipment::take_or_set(self.pers["weapon"]);

	if (level.wrs_stats) {
		self thread _stats_update();
	}

	thread monitor::start();

	if (isDefined(self.pers["spall"])) {
		self thread maps\mp\gametypes\_wrs_admin::_spall();
	}
}

end_map(text, playername) {
	cleanUp(true);

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		player = players[i];

		player closeMenu();
		player [[level.fnc_spawnSpectator]]();

		player setClientCvar("g_scriptMainMenu", "main");
		if (isDefined(text)) {
			if (isDefined(playername)) {
				player setClientCvar("cg_objectiveText", text, playername);
			} else {
				player setClientCvar("cg_objectiveText", text);
			}
		}

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

	// Sprint voting.
	if (game["_vote_sprint"] > 0) {
		choice = vote\sprint::vote(10);
		if (choice == 0) {
			setCvar("scr_wrs_sprint", 0);
		} else {
			setCvar("scr_wrs_sprint", 60);
		}
	}

	// Map voting.
	if (game["_vote_map"] > 0) {
		map = vote\map::vote(10, game["_vote_map"]);

		setCvar("sv_maprotationcurrent", "gametype " + level.gametype + " map " + map);
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

	for (i = 0; i < 5; i++) iPrintLnBold(" "); // Clear out possible messages

	iPrintLnBold(level._prefix + " LEADERBOARDS " + level._prefix);
	wait 0.5;
	iPrintLnBold(winner["score"][1]);
	wait 0.10;
	iPrintLnBold(winner["bashes"][1]);
	wait 0.20;
	iPrintLnBold(winner["headshots"][1]);
	wait 0.30;
	iPrintLnBold(winner["furthest"][1]);
	wait 0.40;
	iPrintLnBold(winner["spreemax"][1]);
	wait 8;
}



cleanUp(everything) {
	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {

		/*if (isDefined(players[i].wrs_hud_sprint))
			players[i].wrs_hud_sprint destroy();
		if (isDefined(players[i].wrs_hud_sprint_back))
			players[i].wrs_hud_sprint_bg destroy();*/

		if (everything) {
			if (isDefined(players[i].wrs_hud_stats)) {
				players[i] _hud_stats_destroy();
			}
		}
	}
}


//Miscellaneous functions
_strip_colors(str)
{
	str_dull = "";

	for (i = 0; i < str.size; i++) {
		if (str[i] == "^" && i + 1 < str.size) {
			switch (str[i + 1]) {
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
					i++;
					continue;
				default:
					break;
			}
		}
		str_dull += str[i];
	}

	return str_dull;
}
_in_array(value, array)
{
	for (i = 0; i < array.size; i++) {
		if (array[i] == value) {
			return true;
		}
	}

	return false;
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
		return util::explode(getCvar(cvar), " ", 0);
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
