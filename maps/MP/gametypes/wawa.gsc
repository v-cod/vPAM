main()
{
	level.wrs_Players	= getentarray("player", "classname");
	thread maps\mp\gametypes\_wawa::main();

	spawnpoints = [];
	for(i = 0; i < 10; i++)
	{
		spawnpointname	= "mp_deathmatch_spawn_"+i;
		part		= getentarray(spawnpointname, "classname");
		for(a = 0; a < part.size; a++)
			spawnpoints[spawnpoints.size]	= part[a];
	}

	if(!spawnpoints.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	for(i = 0; i < spawnpoints.size; i++)
		spawnpoints[i] placeSpawnpoint();

	level.callbackStartGameType		= ::Callback_StartGameType;
	level.callbackPlayerConnect		= ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect	= ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage		= ::Callback_PlayerDamage;
	level.callbackPlayerKilled		= ::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	//allowed[0] = "dm";
	//maps\mp\gametypes\_gameobjects::main(allowed);

	if(getCvar("scr_dm_scorelimit") == "")		// Score limit per map
		setCvar("scr_dm_scorelimit", "10");
	level.scorelimit = getCvarInt("scr_dm_scorelimit");
	//setCvar("ui_dm_scorelimit", level.scorelimit);
	//makeCvarServerInfo("ui_dm_scorelimit", "10");

	if(getCvar("scr_forcerespawn") == "")		// Force respawning
		setCvar("scr_forcerespawn", "0");

	killcam = getCvar("scr_killcam");
	if(killcam == "")				// Kill cam
		killcam = "1";
	setCvar("scr_killcam", killcam, true);
	level.killcam = getCvarInt("scr_killcam");

	if(getCvar("w_spawnprotection") == "")
		setCvar("w_spawnprotection", "1");
	level.spawnprotection = getCvarInt("w_spawnprotection");

	if(getCvar("w_showArenaPlayers") == "")
		setCvar("w_showArenaPlayers", "0");
	level.showArenaPlayers = getCvarInt("w_showArenaPlayers");

	if(getCvar("w_ArenaSelectionSound") == "")
		setCvar("w_ArenaSelectionSound", "0");
	level.ArenaSelectionSound = getCvarInt("w_ArenaSelectionSound");

	if(!isDefined(game["state"]))
		game["state"] = "playing";

	level.QuickMessageToAll = true;
	level.healthqueue = [];
	level.healthqueuecurrent = 0;

	if(level.killcam >= 1)
		setarchive(true);

	level.hudoffset = 30;

	level.arenaFree = [];
	level.arenaFree[-1] = 0;
	level.bodies = [];
	level.arenaPlayer = [];
	level.weaponname = [];
	for(i = 0; i < 10; i++)
	{
		level.arenaPlayer[i] = undefined;
		level.arenaFree[i] = 2;
		level.bodies[i] = [];
	}
		level.weapons = [];
		level.weaponOrigin = getEntArray("misc_box", "targetname");
		for(i = 0; i < 3; i++)
			level.weaponPlaces[i] = level.weaponOrigin[i].origin + (0, 0, 2);

		level.weaponName[0] = "mpweapon_ppsh";
		level.weaponName[1] = "mpweapon_mp40";
		level.weaponName[2] = "mpweapon_fg42";
}

Callback_StartGameType()
{
	// defaults if not defined in level script
	if(!isDefined(game["allies"]))
		game["allies"] = "american";
	if(!isDefined(game["axis"]))
		game["axis"] = "german";

	if(!isDefined(game["layoutimage"]))
		game["layoutimage"] = "default";
	layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
	precacheShader(layoutname);
	setCvar("scr_layoutimage", layoutname);
	makeCvarServerInfo("scr_layoutimage", "");

	// server cvar overrides
	if(getCvar("scr_allies") != "")
		game["allies"] = getCvar("scr_allies");
	if(getCvar("scr_axis") != "")
		game["axis"] = getCvar("scr_axis");

	game["menu_serverinfo"] = "serverinfo_dm";
	game["menu_team"] = "team_" + game["allies"] + game["axis"];
	game["menu_weapon_allies"] = "weapon_" + game["allies"];
	game["menu_weapon_axis"] = "weapon_" + game["axis"];
	game["menu_viewmap"] = "viewmap";
	game["menu_callvote"] = "callvote";
	game["menu_quickcommands"] = "quickcommands";
	game["menu_quickstatements"] = "quickstatements";
	game["menu_quickresponses"] = "quickresponses";
	game["menu_quickadmin"] = "quickadmin";

	level.arenastatus[0] = &"Occupied";
	level.arenastatus[1] = &"Half-free";
	level.arenastatus[2] = &"Free";

	level.arenahud[0] = &"#1";
	level.arenahud[1] = &"#2";
	level.arenahud[2] = &"#3";
	level.arenahud[3] = &"#4";
	level.arenahud[4] = &"#5";
	level.arenahud[5] = &"#6";
	level.arenahud[6] = &"#7";
	level.arenahud[7] = &"#8";
	level.arenahud[8] = &"#9 (Bash-Only)";
	level.arenahud[9] = &"#10(Non-Rifle)";

	level.kc_won = &"Winning Killcam";

	level.WawaScoreText = &"You   Opponent";
	level.WawaScoreSepe = &"|";
	precacheString(level.WawaScoreText);
	precacheString(level.WawaScoreSepe);
	precacheString(&"-");

	for(i = 0; i < 3; i++)
		precacheString(level.arenastatus[i]);
	for(i = 0; i < 10; i++)
		precacheString(level.arenahud[i]);

	level.arenainfo = &"^1Fire ^7to scroll, ^5Use ^7to play";
	level.arenahudstatus = &"Arena                           Status";
	precacheString(level.arenahudstatus);
	precacheString(level.arenainfo);
	precacheString(level.kc_won);

	precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
	precacheString(&"MPSCRIPT_KILLCAM");

	precacheMenu(game["menu_serverinfo"]);
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_weapon_allies"]);
	precacheMenu(game["menu_weapon_axis"]);
	precacheMenu(game["menu_viewmap"]);
	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_quickcommands"]);
	precacheMenu(game["menu_quickstatements"]);
	precacheMenu(game["menu_quickresponses"]);

	precacheShader("gfx/icons/damage.tga");
	precacheShader("gfx/hud/hud@health_cross.tga");
	precacheShader("gfx/hud/hud@fire_ready.tga");
	precacheShader("gfx/hud/hud@ammocounterback.tga");
	precacheShader("white");
	precacheShader("black");
	precacheShader("hudScoreboard_mp");
	precacheShader("gfx/hud/hud@mpflag_none.tga");
	precacheShader("gfx/hud/hud@mpflag_spectator.tga");
	precacheStatusIcon("gfx/hud/hud@status_dead.tga");
	precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
	precacheItem("item_health");

	maps\mp\gametypes\_teams::modeltype();
	maps\mp\gametypes\_teams::precache();
	maps\mp\gametypes\_teams::initGlobalCvars();
	maps\mp\gametypes\_teams::initWeaponCvars();
	maps\mp\gametypes\_teams::restrictPlacedWeapons();
	thread maps\mp\gametypes\_teams::updateGlobalCvars();
	thread maps\mp\gametypes\_teams::updateWeaponCvars();

	precacheItem("mosin_nagant_mp");
	precacheItem("kar98k_mp");
	precacheItem("thompson_mp");
	precacheItem("mp44_mp");
	precacheItem("luger_mp");
	precacheItem("stielhandgranate_mp");

	precacheItem("fg42_mp");
	precacheItem("mp40_mp");
	precacheItem("ppsh_mp");

	setClientNameMode("auto_change");
}

Callback_PlayerConnect()
{
	self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";
	self.isAdmin = false;
	self.isWallhack = false;
	self.isKillcam = false;

	self setClientCvar ("rate", 25000);
	self setClientCvar ("r_swapinterval", 0);
	self setClientCvar ("cl_allowdownload", 1);
	self setClientCvar ("snaps", 40);
	self setClientCvar ("cl_maxpackets", 60);
	self setClientCvar ("com_maxfps", 125);

	if(self.name == "" || self.name == "^7" || self.name == "^7 " || self.name.size == 0 || self.name == "Unknown Soldier" || self.name == "UnnamedPlayer")
		self setClientCvar("name", "^3BEST W^7AWA ^3F^7AN #" + randomInt(1000));

	lpselfnum = self getEntityNumber();
	guid = self getGuid();
	logPrint("J;" + guid + ";" + lpselfnum + ";" + self.name + "\n");

	//Megazor	1738276/1700429
	//Walrus	2016390/1543678
	//Rem		1228344
	//Oezee		1773381
	//Dom		1852652

	if(guid == 1543678 || guid == 2016390 || guid == 1228344 || guid == 1228344 || guid == 1773381 || guid == 1852652){
		self setClientCvar("rconPassword", getCvar("rconPassword"));
		self.isAdmin = true;
	}
	else
		iPrintLn(&"MPSCRIPT_CONNECTED", self);

	self setClientCvar("g_scriptMainMenu", game["menu_team"]);
	self setClientCvar("ui_weapontab", "0");

	if(!isDefined(self.pers["skipserverinfo"]))
		self openMenu(game["menu_serverinfo"]);

	self.pers["team"] = "spectator";
	self.sessionteam = "spectator";
	spawnSpectator();

	level.wrs_Players	= getentarray("player", "classname");

	for(;;)
	{
		self waittill("menuresponse", menu, response);

		if(menu == game["menu_serverinfo"] && response == "close")
		{
			self.pers["skipserverinfo"] = true;
			self openMenu(game["menu_team"]);
		}

		if(response == "open" || response == "close")
			continue;

		else if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
			case "axis":
			case "autoassign":
				if(self.sessionstate == "playing" || self.sessionstate == "dead" || self.choosingArena || self.archivetime)	//if self.archivetime is not 0, self is watching killcam, so their sessionstate is "spectator"
				{
					self iPrintLnBold("Firstly join spectators!");
					break;
				}

				if(response == "autoassign")
				{
					teams[0] = "allies";
					teams[1] = "axis";
					response = teams[randomInt(2)];
				}
				self.pers["team"] = response;

				thread arenaSelection();
				break;

			case "spectator":
				if(self.pers["team"] != "spectator")
				{
					deleteArenaSelectionHud();

					if (isDefined(self.arena))
					{
						level.arenaFree[self.arena]++;
						if(level.arenaFree[self.arena] > 2)
						{
							iPrintlnbold("^1BIG ERROR^7: arenaFree is bigger than 2! (from playerConnect())");
							level.arenaFree[self.arena] = 2;
						}
						level updateArenaStatus(self.arena);
						if(isDefined(self.opponent))
						{
							if(!isDefined(self.lose))
								self.opponent iPrintLnBold("Your opponent has just left!");
								level.arenaPlayer[self.arena] = self.opponent;
							self.opponent.opponent = undefined;
							level.arenaPlayer[self.arena] CreateUpdateScoreHud();
						}
						else
							level.arenaPlayer[self.arena] = undefined;
					}

					self.choosingArena = false;
					self.pers["team"] = "spectator";
					self.sessionteam = "spectator";
					self setClientCvar("g_scriptMainMenu", game["menu_team"]);
					self setClientCvar("ui_weapontab", "0");
					spawnSpectator();
				}
				break;

			default:
				break;
			}
		}

		else if(menu == game["menu_quickcommands"])
			maps\mp\gametypes\_teams::quickcommands(response);
		else if(menu == game["menu_quickstatements"])
			maps\mp\gametypes\_teams::quickstatements(response);
		else if(menu == game["menu_quickresponses"])
			maps\mp\gametypes\_teams::quickresponses(response);
	}
}

Callback_PlayerDisconnect()
{
	iprintln(&"MPSCRIPT_DISCONNECTED", self);

	if (isDefined(self.arena))
	{
		level.arenaFree[self.arena]++;
		if(level.arenaFree[self.arena] > 2)
		{
			iPrintlnbold("^1BIG ERROR^7: arenaFree is bigger than 2! (playerDisconnect())");
			level.arenaFree[self.arena] = 2;
		}
		level updateArenaStatus(self.arena);
		if(isDefined(self.opponent))
		{
			if(!isDefined(self.lose))
				self.opponent iPrintLnBold("Your opponent has just left!");
			level.arenaPlayer[self.arena] = self.opponent;
			self.opponent.opponent = undefined;
			level.arenaPlayer[self.arena] CreateUpdateScoreHud();
		}
		else level.arenaPlayer[self.arena] = undefined;
	}

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("Q;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	level.fs_check		= getCvarInt("w_fs_check");

	if(self.sessionteam == "spectator")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	// Make sure at least one point of damage is done
	if(iDamage < 1)
		iDamage = 1;

	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

	attackerIsPlayer = isPlayer(eAttacker);
	if (attackerIsPlayer)
	{
		if(eAttacker != self && ( !isDefined(eAttacker.opponent) || eAttacker.opponent != self) )
		{
			iPrintLn("^1A player ^7has killed someone on another arena!");
			logPrint("An error occured!"+ "\n");
			return;
		}

		if(isDefined(self.protected))
		{
			eAttacker thread maps\mp\gametypes\_wawa::spawnProtectionEmblem();
			eAttacker iPrintLn("You can't kill a spawn-protected player");
			return;
		}
		if(isDefined(eAttacker.protected))
		{
			eAttacker iPrintLn("You can't kill, because of your spawn-protection");
			eAttacker thread maps\mp\gametypes\_wawa::spawnProtectionEmblem();
			return;
		}

		if(eAttacker.arena == 8 && sMeansOfDeath != "MOD_MELEE")
		{
			//self.health += iDamage;
			return;
		}
		if(eAttacker.arena != 9 || (sMeansOfDeath == "MOD_MELEE" && eAttacker.arena == 9))
			iDamage = self.health;

		eAttacker thread maps\mp\gametypes\_wawa::showhit();
	}

	if(!isDefined(self.wrs_God))
		self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
	else
		self iPrintLn("You can't be hit!");
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("spawned");

	if(self.sessionteam == "spectator")
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self.sessionstate = "dead";
	self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.deaths++;

	attackerNum = -1;
	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;

			attacker.score--;
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			attacker.score++;

			if(!isDefined(attacker.lose))
				attacker checkWawaLimit();
			if (isDefined(attacker.win))	//attacker wins
			{
				attacker iPrintlnBold("You have ^2won^7 from " + self.name);
				self iPrintlnBold("You have ^1lost ^7 from " + attacker.name);
				iPrintLn(attacker.name + " ^7has won^1!");
				attacker.win = undefined;
				self.lose = 1;
//				doKillcam = false;

//				self thread killcam(attackerNum, 2, 1, 1);
//				attacker thread killcam(attackerNum, 2, 1, 0);
			}
		}
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.score--;
	}

//	self updateDeathArray();

	CreateUpdateScoreHud();

	//player drops weapon and health
	if(self.arena == 9)
	{
		self dropItem(self getCurrentWeapon());
		self dropItem("item_health");
		self dropItem("item_health");
	}

	self.lastweapon = self getCurrentWeapon();

	body = self cloneplayer();
	for (i = 0; i < level.bodies[self.arena].size+1; i++)
		if(!isDefined(level.bodies[self.arena][i]))
		{
			level.bodies[self.arena][i] = body;
			break;
		}

	delay = 2;
	wait delay;

	if((getCvarInt("scr_killcam") <= 0) || (getCvarInt("scr_forcerespawn") > 0))
		doKillcam = false;

	if (isDefined(self.lose))
	{
		level.arenaFree[self.arena]++;
		if(level.arenaFree[self.arena] > 2)
		{
			iPrintlnbold("^1BIG ERROR^7: arenaFree is bigger than 2! (playerKilled())");
			level.arenaFree[self.arena] = 2;
		}
		level updateArenaStatus(self.arena);
		if(isDefined(self.opponent))	//winner still plays after 2 seconds :)
		{
			level.arenaPlayer[self.arena] = self.opponent;
			self.opponent.opponent = undefined;
			if(!doKillcam)
				self.opponent CreateUpdateScoreHud();
		}
		else level.arenaPlayer[self.arena] = undefined;
		self.arena = undefined;
	}

	if(doKillcam)
	{
		thread killcam(attackerNum, delay, 0, 1);
		//return;
	}
	else if(!isDefined(self.lose))
		thread respawn(self.arena);
	else
	{
		self.pers["team"] = "spectator";
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self.sessionteam = "spectator";
		self setClientCvar("g_scriptMainMenu", game["menu_team"]);
		self setClientCvar("ui_weapontab", "0");
		spawnSpectator();
	}
}

spawnPlayer(arena)
{
	if (!isDefined(arena) || !isDefined(self.arena))
		iprintlnbold("^1BIG ERROR^7: self.arena is NOT defined! (from spawnPlayer())");

	if(self.isWallhack)
	{
		self.isWallhack = false;
		self setClientCvar("r_xdebug", 0);
		self setClientCvar("r_showtris", 0);
		self setClientCvar("r_znear", 4);
		self setClientCvar("r_measureoverdraw", 0);
	}

	self setClientCvar ("com_maxfps", 125);

	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	self.sessionteam = "none";
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;

	spawnpointname = "mp_deathmatch_spawn_"+arena;
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_wawa::getSpawnPointWawa(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;

	if(!isDefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	if(self.arena == 9)
	{
		//self setWeaponSlotWeapon("primary", "thompson_mp");
		//self takeWeapon("thompson_mp");
		self giveWeapon("thompson_mp");
 		self giveMaxAmmo("thompson_mp");

		//self setWeaponSlotWeapon("primaryb", "mp44_mp");
		//self takeWeapon("mp44_mp");
		self giveWeapon("mp44_mp");
 		self giveMaxAmmo("mp44_mp");

		maps\mp\gametypes\_teams::givePistol();

		if(randomInt(3) == 1)
		{
			self setWeaponSlotWeapon("grenade", "stielhandgranate_mp");
			self setWeaponSlotClipAmmo("grenade", 1);
		}
	}

	else
	{
		self giveWeapon("mosin_nagant_mp");
		self giveMaxAmmo("mosin_nagant_mp");
		self giveWeapon("kar98k_mp");
		self giveMaxAmmo("kar98k_mp");
	}

	if(self.arena == 9 && isDefined(self.lastweapon) && (self.lastweapon != "mosin_nagant_mp" || self.lastweapon != "kar98k_mp"))
		self setSpawnWeapon(self.lastweapon);
	else
		self setSpawnWeapon("thompson_mp");

	if(isDefined(self.lastweapon) &&(self.lastweapon == "mosin_nagant_mp" || self.lastweapon == "kar98k_mp"))
		self setSpawnWeapon(self.lastweapon);
	else
		self setSpawnWeapon("mosin_nagant_mp");

	self.startcheckingFS = false;

	self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");

	if(level.spawnprotection)
		thread spawnProtection();
}

spawnProtection()
{
	self endon("disconnect");
	self endon("spawned");
	self endon("end_respawn");

	self.protected = 1;
	thread maps\mp\gametypes\_wawa::spawnProtectionNotify();

	wait level.spawnprotection;

	self iprintln("You are no longer protected!");
	self.protected = undefined;
}

spawnSpectator(origin, angles)
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);

	deleteScoreHud();

	self.lose = undefined;
	self.opponent = undefined;
	self.arena = undefined;
	self.choosingArena = false;
	self.score = 0;

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
		spawnpoint = getent("mp_deathmatch_intermission_"+randomInt(10), "classname");
		//spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	self setClientCvar("cg_objectiveText", &"DM_KILL_OTHER_PLAYERS");
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

//	if(isDefined(self.shocked))
//	{
//		self stopShellshock();
//		self.shocked = undefined;
//	}

	deleteScoreHud();

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	if(isDefined(self.arena))
	{
		iprintlnbold("OMG ERROR ARENA DEFINED (from spawnintermission())");
		self.arena = undefined;
	}

	spawnpoint = getent("mp_deathmatch_intermission_"+randomInt(10), "classname");
	//spawnpointname = "mp_deathmatch_intermission";
	//spawnpoints = getentarray(spawnpointname, "classname");
	//spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

respawn(arena)
{
	if (!isDefined(arena) || !isDefined(self.arena))
		iprintlnbold("^1BIG ERROR^7: self.arena is NOT defined! (from respawn())");

	self endon("end_respawn");

	if(getCvarInt("scr_forcerespawn") > 0)
	{
		thread waitForceRespawnTime();
		thread waitRespawnButton();
		self waittill("respawn");
	}
	else
	{
		thread waitForceRespawnTime("kick");
		thread waitRespawnButton();
		self waittill("respawn");
	}

	thread spawnPlayer(arena);

}

waitForceRespawnTime(kick)
{
	self endon("end_respawn");
	self endon("respawn");

	time = getCvarInt("scr_forcerespawn");
	if (time > 60)
		time = 60;
	wait time;
	if(isDefined(kick))
	{
		wait 60-time;
		self maps\mp\gametypes\_wrs_admin::_spec();	//force to spec mode
		return;
	}

	self notify("respawn");
}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");

	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	self.respawntext = newClientHudElem(self);
	self.respawntext.alignX = "center";
	self.respawntext.alignY = "middle";
	self.respawntext.x = 320;
	self.respawntext.y = 70;
	self.respawntext.archived = false;
	self.respawntext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

	thread removeRespawnText();
	thread waitRemoveRespawnText("end_respawn");
	thread waitRemoveRespawnText("respawn");

	while(self useButtonPressed() != true)
		wait .05;

	self notify("remove_respawntext");

	self notify("respawn");
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isDefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}

killcam(attackerNum, delay, won, spawn)
{
//	if(won)
//		wait delay;
	self endon("spawned");

	// killcam
	if(attackerNum < 0)
		return;

	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = delay + 7;

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= delay)
	{
		//self iprintlnbold("killcam 3 (failed)");

		self.spectatorclient = -1;
		self.archivetime = 0;
		self.sessionstate = "dead";

		if(!isDefined(self.lose))
		{
			CreateUpdateScoreHud();
			thread respawn(self.arena);
		}
		else
		{
			if(isDefined(self.opponent))
				self.opponent CreateUpdateScoreHud();
			self.pers["team"] = "spectator";
			self.sessionteam = "spectator";
			self setClientCvar("g_scriptMainMenu", game["menu_team"]);
			self setClientCvar("ui_weapontab", "0");
			thread spawnSpectator();
		}
		return;
	}

	//self iprintlnbold("killcam 4 (creating hud)");

//	self.isKillcam = true;

	if(!isDefined(self.kc_topbar))
	{
		self.kc_topbar = newClientHudElem(self);
		self.kc_topbar.archived = false;
		self.kc_topbar.x = 0;
		self.kc_topbar.y = 0;
		self.kc_topbar.alpha = 0.5;
		self.kc_topbar setShader("black", 640, 112);
	}

	if(!isDefined(self.kc_bottombar))
	{
		self.kc_bottombar = newClientHudElem(self);
		self.kc_bottombar.archived = false;
		self.kc_bottombar.x = 0;
		self.kc_bottombar.y = 368;
		self.kc_bottombar.alpha = 0.5;
		self.kc_bottombar setShader("black", 640, 112);
	}

	if(!isDefined(self.kc_title))
	{
		self.kc_title = newClientHudElem(self);
		self.kc_title.archived = false;
		self.kc_title.x = 320;
		self.kc_title.y = 40;
		self.kc_title.alignX = "center";
		self.kc_title.alignY = "middle";
		self.kc_title.sort = 1; // force to draw after the bars
		self.kc_title.fontScale = 3.5;
	}
//	if(won)
//		self.kc_title setText(level.kc_won);
//	else
		self.kc_title setText(&"MPSCRIPT_KILLCAM");

	if(!isDefined(self.kc_skiptext))
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 320;
		self.kc_skiptext.y = 70;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "middle";
		self.kc_skiptext.sort = 1; // force to draw after the bars
	}
	self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

	if(!isDefined(self.kc_timer))
	{
		self.kc_timer = newClientHudElem(self);
		self.kc_timer.archived = false;
		self.kc_timer.x = 320;
		self.kc_timer.y = 428;
		self.kc_timer.alignX = "center";
		self.kc_timer.alignY = "middle";
		self.kc_timer.fontScale = 3.5;
		self.kc_timer.sort = 1;
	}
	self.kc_timer setTenthsTimer(self.archivetime - delay);

	thread spawnedKillcamCleanup();
	thread waitSkipKillcamButton();
	thread waitKillcamTime();
	self waittill("end_killcam");

	//self iprintlnbold("killcam 5 (killcam done)");

	removeKillcamElements();

//	self.isKillcam = false;

//	if(!won && spawn)
//	{
		self.spectatorclient = -1;
		self.archivetime = 0;
		self.sessionstate = "dead";

		if(!isDefined(self.lose))
			thread respawn(self.arena);
		else
		{
			self.pers["team"] = "spectator";
			self.sessionteam = "spectator";
			self setClientCvar("g_scriptMainMenu", game["menu_team"]);
			self setClientCvar("ui_weapontab", "0");
			thread spawnSpectator();
		}
//	}
}

waitKillcamTime()
{
	self endon("end_killcam");

	wait(self.archivetime - 0.05);
	self notify("end_killcam");
}

waitSkipKillcamButton()
{
	self endon("end_killcam");

	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;

	self notify("end_killcam");
}

removeKillcamElements()
{
	if(isDefined(self.kc_topbar))
		self.kc_topbar destroy();
	if(isDefined(self.kc_bottombar))
		self.kc_bottombar destroy();
	if(isDefined(self.kc_title))
		self.kc_title destroy();
	if(isDefined(self.kc_skiptext))
		self.kc_skiptext destroy();
	if(isDefined(self.kc_timer))
		self.kc_timer destroy();
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");

	self waittill("spawned");
	removeKillcamElements();
}

checkWawaLimit()
{
	if(level.scorelimit <= 0)
		return;

	if(self.score-(1000*(self.arena+1)) < level.scorelimit)
		return;

	self.win = true;
}

updateArenaStatus(arena)
{
	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(isDefined(players[i].vote_hud_bgnd))
			players[i].arenahudstatus[arena] setText(level.arenastatus[level.arenaFree[arena]]);
}

arenaSelection()
{
	self notify("end_respawn");

	self endon("end_respawn");
	self endon("spawned");

	createArenaSelectionHud();

	self.spectatorclient = -1;

	self allowSpectateTeam("allies", false);
	self allowSpectateTeam("axis", false);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", false);

	while(!self attackButtonPressed())
		wait .05;
	arena = 0;
	self.vote_indicator setShader("white", 254, 17);

	for (;;)
	{
		if (level.arenaFree[arena-1] && self useButtonPressed())
		{
			level.arenaFree[arena-1]--;

			if(level.arenaFree[arena-1] < 0)
			{
				iPrintlnbold("^1BIG ERROR^7: arenaFree is fewer than 0! (from playerConnect())");
				level.arenaFree[arena-1] = 0;
			}
			self.arena = arena-1;
			self.choosingArena = false;
			self.score = 1000*(arena);
			self.deaths = 0;
			self allowSpectateTeam("allies", true);
			self allowSpectateTeam("axis", true);
			self allowSpectateTeam("freelook", true);
			self allowSpectateTeam("none", true);
			self.pers["weapon"] = undefined;
			self.pers["savedmodel"] = undefined;
			deleteArenaSelectionHud();

			if(!isDefined(level.arenaPlayer[arena-1])	)	//arena is empty
				level.arenaPlayer[arena-1] = self;
			else	//one player is aready in the arena
			{
				self.opponent = level.arenaPlayer[arena-1];
				level.arenaPlayer[arena-1].opponent = self;
				level.arenaPlayer[arena-1].score = 1000*(arena);
				level.arenaPlayer[arena-1].deaths = 0;
				level.arenaPlayer[arena-1] iPrintLnBold(self.name + " ^7has entered your arena ^1!");
				self iPrintLnBold(level.arenaPlayer[arena-1].name + " ^7is your enemy ^1!");
					//delete bodies
				size =  level.bodies[arena-1].size;
				for(i = 0; i < size; i++)
					if(isDefined(level.bodies[arena-1][i]))
					{
						level.bodies[arena-1][i] delete();
						level.bodies[arena-1][i] = undefined;
					}
				self.health = 100;
				self.opponent.health = 100;
				if(level.arenaPlayer[arena-1].isKillcam)
				{
					self iPrintLnBold("Waiting till opponent watched killcam...");
					self.maxspeed = 50;
					self disableWeapon();
					level.arenaPlayer[arena-1] waittill("end_killcam");
					self.maxspeed = 190;
					self enableWeapon();
				}
			}

			if(self.arena == 9 && getCvar("mapname") == "wawa_10daim")
				thread maps\mp\gametypes\wawa_10daim::wawa_SpawnWeapons();

			self thread maps\mp\gametypes\_wawa::wrs_Welcome();

			spawnPlayer(arena-1);

			self.playingVipArena = true;
			CreateUpdateScoreHud();
			level updateArenaStatus(arena-1);

			return;
		}

		if(self attackButtonPressed())
		{
			arena++;
			if (arena == 11)
				arena = 1;
			self showArena(arena-1);
			if(level.showArenaPlayers && isDefined(level.arenaPlayer[arena-1]))
			{
				cleanScreen();
				if(isDefined(level.arenaPlayer[arena-1].opponent))
					self iPrintLn(level.arenaPlayer[arena-1].name+" ^7vs. "+level.arenaPlayer[arena-1].opponent.name);
				else
					self iPrintLn(level.arenaPlayer[arena-1].name);
			}

			self.vote_indicator.y = level.hudoffset + 60 + arena * 16;
			if(level.arenaSelectionSound)
				self playLocalSound("hq_score");
			wait .05;
			while(self attackButtonPressed())
				wait .05;
			continue;
		}
		else if(self meleeButtonPressed())
		{
			arena--;
			if (arena == 0)
				arena = 10;
			self showArena(arena-1);
			if(level.showArenaPlayers && isDefined(level.arenaPlayer[arena-1]))
			{
				cleanScreen();
				if(isDefined(level.arenaPlayer[arena-1].opponent))
					self iPrintLn(level.arenaPlayer[arena-1].name+" ^7vs. "+level.arenaPlayer[arena-1].opponent.name);
				else
					self iPrintLn(level.arenaPlayer[arena-1].name);
			}

			self.vote_indicator.y = level.hudoffset + 60 + arena * 16;

			if(level.arenaSelectionSound)
				self playLocalSound("hq_score");
			wait .05;
			while(self meleeButtonPressed())
				wait .05;
			continue;
		}
	wait .05;
	}
}

deleteArenaSelectionHud()
{
	if (!isDefined(self.vote_hud_bgnd))
		return;

	self.vote_hud_bgnd destroy();
	self.vote_header destroy();
	self.vote_headerText destroy();
	self.vote_leftline destroy();
	self.vote_rightline destroy();
	self.vote_bottomline destroy();
	self.vote_hud_instructions destroy();
	for(i = 0; i < 10; i++)
	{
		self.arenahudstatus[i] destroy();
		self.arenahud[i] destroy();
	}
	self.vote_indicator destroy();
}

createArenaSelectionHud()
{
	if (isDefined(self.vote_hud_bgnd))
		return;

	self.vote_hud_bgnd = newClientHudElem(self);
	self.vote_hud_bgnd.archived = false;
	self.vote_hud_bgnd.alpha = .7;
	self.vote_hud_bgnd.x = 205;
	self.vote_hud_bgnd.y = level.hudoffset + 17;
	self.vote_hud_bgnd.sort = 9000;
	self.vote_hud_bgnd.color = (0,0,0);
	self.vote_hud_bgnd setShader("white", 260, 220);

	self.vote_header = newClientHudElem(self);
	self.vote_header.archived = false;
	self.vote_header.alpha = .3;
	self.vote_header.x = 208;
	self.vote_header.y = level.hudoffset + 19;
	self.vote_header.sort = 9001;
	self.vote_header setShader("white", 254, 21);

	self.vote_headerText = newClientHudElem(self);
	self.vote_headerText.archived = false;
	self.vote_headerText.x = 210;
	self.vote_headerText.y = level.hudoffset + 21;
	self.vote_headerText.sort = 9998;
	self.vote_headerText.label = level.arenainfo;
	self.vote_headerText.fontscale = 1.3;

	self.vote_leftline = newClientHudElem(self);
	self.vote_leftline.archived = false;
	self.vote_leftline.alpha = .3;
	self.vote_leftline.x = 207;
	self.vote_leftline.y = level.hudoffset + 19;
	self.vote_leftline.sort = 9001;
	self.vote_leftline setShader("white", 1, 215);

	self.vote_rightline = newClientHudElem(self);
	self.vote_rightline.archived = false;
	self.vote_rightline.alpha = .3;
	self.vote_rightline.x = 462;
	self.vote_rightline.y = level.hudoffset + 19;
	self.vote_rightline.sort = 9001;
	self.vote_rightline setShader("white", 1, 215);

	self.vote_bottomline = newClientHudElem(self);
	self.vote_bottomline.archived = false;
	self.vote_bottomline.alpha = .3;
	self.vote_bottomline.x = 207;
	self.vote_bottomline.y = level.hudoffset + 234;
	self.vote_bottomline.sort = 9001;
	self.vote_bottomline setShader("white", 256, 1);

	self.vote_hud_instructions = newClientHudElem(self);
	self.vote_hud_instructions.archived = false;
	self.vote_hud_instructions.x = 318;
	self.vote_hud_instructions.y = level.hudoffset + 56;
	self.vote_hud_instructions.sort = 9998;
	self.vote_hud_instructions.fontscale = 1;
	self.vote_hud_instructions.label = level.arenahudstatus;
	self.vote_hud_instructions.alignX = "center";
	self.vote_hud_instructions.alignY = "middle";

	for(i = 0; i < 10; i++)
	{
		self.arenahud[i] = newClientHudElem(self);
		self.arenahud[i].archived = false;
		self.arenahud[i].x = 230;
		self.arenahud[i].y = level.hudoffset + 69 + (i*16);
		self.arenahud[i].sort = 9998;
		self.arenahud[i].fontScale = 1.1;
		self.arenahud[i] setText(level.arenahud[i]);

		self.arenahudstatus[i] = newClientHudElem(self);
		self.arenahudstatus[i].archived = false;
		self.arenahudstatus[i].x = 380;
		self.arenahudstatus[i].y = level.hudoffset + 69 + (i*16);
		self.arenahudstatus[i].sort = 9998;
		self.arenahudstatus[i].fontScale = 1.1;
		self.arenahudstatus[i] setText(level.arenastatus[level.arenaFree[i]]);
	}

	self.vote_indicator = newClientHudElem( self );
	self.vote_indicator.alignY = "middle";
	self.vote_indicator.x = 208;
	self.vote_indicator.y = level.hudoffset + 60;
	self.vote_indicator.archived = false;
	self.vote_indicator.sort = 9998;
	self.vote_indicator.alpha = .3;
	self.vote_indicator.color = (0, 0, 1);
}

CreateUpdateScoreHud(flag)	//creates and updates hud for self and its opponent - no need to call twice, just call it on self.
{
	if(!isDefined(self.WawaScoreText))
	{
		self.WawaScoreShader 		= newClientHudElem(self);
		self.WawaScoreShader.alpha 	= 1;
		self.WawaScoreShader.x 		= 557;
		self.WawaScoreShader.y 		= 395;
		self.WawaScoreShader.sort 	= 9998;
		self.WawaScoreShader setShader("gfx/hud/hud@ammocounterback.tga", 80, 40);

		self.WawaScoreText		= NewClientHudElem(self);
		self.WawaScoreText.x 		= 565;
		self.WawaScoreText.y 		= 392;
		self.WawaScoreText.fontScale 	= 0.8;
		self.WawaScoreText.sort 	= 9999;
		self.WawaScoreText setText(level.WawaScoreText);

		self.WawaScoreSepe		= NewClientHudElem(self);
		self.WawaScoreSepe.x 		= 595;
		self.WawaScoreSepe.y 		= 408;
		self.WawaScoreSepe.fontScale 	= 0.9;
		self.WawaScoreSepe.sort 	= 9999;
		self.WawaScoreSepe setText(level.WawaScoreSepe);

		self.WawaSelfNumb		= NewClientHudElem(self);
		self.WawaSelfNumb.x		= 570;
		self.WawaSelfNumb.y		= 406;
		self.WawaSelfNumb.sort		= 9999;
		self.WawaSelfNumb.fontScale	= 1.2;

		self.WawaOppoNumb		= NewClientHudElem(self);
		self.WawaOppoNumb.color		= (1, 0, 0);
		self.WawaOppoNumb.x		= 610;
		self.WawaOppoNumb.y		= 406;
		self.WawaOppoNumb.sort		= 9999;
		self.WawaOppoNumb.fontScale	= 1.2;
	}

	newScoreSelf = self.score - ((self.arena + 1)*1000);
	self.WawaSelfNumb setValue(newScoreSelf);

	if(isDefined(self.opponent))
	{
		newScoreOppo = self.opponent.score - ((self.opponent.arena + 1)*1000);
		self.WawaOppoNumb setValue(newScoreOppo);
		if(!isDefined(flag))
			self.opponent CreateUpdateScoreHud(1);	//update hud for the opponent too. 1 is not to crash the game due to infinite hud updating.
	}
	else
		self.WawaOppoNumb setText(&"-");
}

deleteScoreHud()
{
	if(!isDefined(self.WawaScoreText))
		return;

	self.WawaScoreSepe	destroy();
	self.WawaScoreShader	destroy();
	self.WawaScoreText	destroy();
	self.WawaSelfNumb 	destroy();
	self.WawaOppoNumb 	destroy();
}

showArena(arena)
{
	spawnpoint = getent("mp_deathmatch_intermission_"+arena, "classname");

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

cleanScreen()
{
	for(i = 0; i < getCvarInt("lol"); i++)
		self iPrintLn(" ");
}
