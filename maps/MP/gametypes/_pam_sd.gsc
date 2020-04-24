// Lines changed compared to original routines prepended with '/**/'

Callback_StartGameType()
{
	// if this is a fresh map start, set nationalities based on cvars, otherwise leave game variable nationalities as set in the level script
	if(!isDefined(game["gamestarted"]))
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

		game["menu_serverinfo"] = "serverinfo_" + getCvar("g_gametype");
		game["menu_team"] = "team_" + game["allies"] + game["axis"];
		game["menu_weapon_allies"] = "weapon_" + game["allies"];
		game["menu_weapon_axis"] = "weapon_" + game["axis"];
		game["menu_viewmap"] = "viewmap";
		game["menu_callvote"] = "callvote";
		game["menu_quickcommands"] = "quickcommands";
		game["menu_quickstatements"] = "quickstatements";
		game["menu_quickresponses"] = "quickresponses";

		precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
		precacheString(&"MPSCRIPT_KILLCAM");
		precacheString(&"SD_MATCHSTARTING");
		precacheString(&"SD_MATCHRESUMING");
		precacheString(&"SD_EXPLOSIVESPLANTED");
		precacheString(&"SD_EXPLOSIVESDEFUSED");
		precacheString(&"SD_ROUNDDRAW");
		precacheString(&"SD_TIMEHASEXPIRED");
		precacheString(&"SD_ALLIEDMISSIONACCOMPLISHED");
		precacheString(&"SD_AXISMISSIONACCOMPLISHED");
		precacheString(&"SD_ALLIESHAVEBEENELIMINATED");
		precacheString(&"SD_AXISHAVEBEENELIMINATED");

		precacheMenu(game["menu_serverinfo"]);
		precacheMenu(game["menu_team"]);
		precacheMenu(game["menu_weapon_allies"]);
		precacheMenu(game["menu_weapon_axis"]);
		precacheMenu(game["menu_viewmap"]);
		precacheMenu(game["menu_callvote"]);
		precacheMenu(game["menu_quickcommands"]);
		precacheMenu(game["menu_quickstatements"]);
		precacheMenu(game["menu_quickresponses"]);

		precacheShader("black");
		precacheShader("white");
		precacheShader("hudScoreboard_mp");
		precacheShader("gfx/hud/hud@mpflag_spectator.tga");
		precacheStatusIcon("gfx/hud/hud@status_dead.tga");
		precacheStatusIcon("gfx/hud/hud@status_connecting.tga");

		precacheShader("ui_mp/assets/hud@plantbomb.tga");
		precacheShader("ui_mp/assets/hud@defusebomb.tga");
		precacheShader("gfx/hud/hud@objectiveA.tga");
		precacheShader("gfx/hud/hud@objectiveA_up.tga");
		precacheShader("gfx/hud/hud@objectiveA_down.tga");
		precacheShader("gfx/hud/hud@objectiveB.tga");
		precacheShader("gfx/hud/hud@objectiveB_up.tga");
		precacheShader("gfx/hud/hud@objectiveB_down.tga");
		precacheShader("gfx/hud/hud@bombplanted.tga");
		precacheShader("gfx/hud/hud@bombplanted_up.tga");
		precacheShader("gfx/hud/hud@bombplanted_down.tga");
		precacheShader("gfx/hud/hud@bombplanted_down.tga");
		precacheModel("xmodel/mp_bomb1_defuse");
		precacheModel("xmodel/mp_bomb1");
		
		maps\mp\gametypes\_teams::precache();
		maps\mp\gametypes\_teams::scoreboard();

		//thread addBotClients();
	}
	
	maps\mp\gametypes\_teams::modeltype();
	maps\mp\gametypes\_teams::initGlobalCvars();
	maps\mp\gametypes\_teams::initWeaponCvars();
	maps\mp\gametypes\_teams::restrictPlacedWeapons();
	thread maps\mp\gametypes\_teams::updateGlobalCvars();
	thread maps\mp\gametypes\_teams::updateWeaponCvars();

/**/// Call main routine for variable setup and precaching.
/**/maps\mp\gametypes\_pam::main();

	game["gamestarted"] = true;
	
	setClientNameMode("manual_change");

/**/// Refer to custom functions.
/**/thread bombzones();
/**/thread startGame();
/**/thread updateGametypeCvars();
	//thread addBotClients();
}

Callback_PlayerConnect()
{
	self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";
	self.pers["teamTime"] = 1000000;

	if(!isDefined(self.pers["team"]))
		iprintln(&"MPSCRIPT_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("J;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");

/**/self.pers["killer"] = false;

/**/self.p_name = self.name;
/**/self.p_ready = false;
/**/self.p_readying = false;

/**/if (level.p_readying == true) {
/**/    self thread maps\mp\gametypes\_pam_readyup::readyup(lpselfnum);
/**/}

	if(game["state"] == "intermission")
	{
		maps\mp\gametypes\sd::spawnIntermission();
		return;
	}
	
	if (getCvar("g_autodemo") == "1")
	{
		self autoDemoStart();
	}
	
	level endon("intermission");
	
	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_weapontab", "1");

		if(self.pers["team"] == "allies")
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

		if(isDefined(self.pers["weapon"]))
/**/		spawnPlayer();
		else
		{
			self.sessionteam = "spectator";

			spawnSpectator();

			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}
	}
	else
	{
		self setClientCvar("g_scriptMainMenu", game["menu_team"]);
		self setClientCvar("ui_weapontab", "0");

		if(!isDefined(self.pers["skipserverinfo"]))
			self openMenu(game["menu_serverinfo"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";

		spawnSpectator();
	}

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

		if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
			case "axis":
			case "autoassign":
				if (level.lockteams)
					break;
/**/			// TODO: Add variable to prevent switch.
/**/			// Prevent players from switching during match.
/**/			if (game["matchstarted"] && true && self.sessionteam != "spectator") {
/**/				// self iPrintLn("Not allowed to switch during match.");
/**/				break;
/**/			}
				if(response == "autoassign")
				{
					numonteam["allies"] = 0;
					numonteam["axis"] = 0;

					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
					{
						player = players[i];
					
						if(!isDefined(player.pers["team"]) || player.pers["team"] == "spectator" || player == self)
							continue;
			
						numonteam[player.pers["team"]]++;
					}
					
					// if teams are equal return the team with the lowest score
					if(numonteam["allies"] == numonteam["axis"])
					{
/**/					if(getTeamScore("allies") == getTeamScore("axis"))
						{
							teams[0] = "allies";
							teams[1] = "axis";
							response = teams[randomInt(2)];
						}
/**/					else if(getTeamScore("allies") < getTeamScore("axis"))
							response = "allies";
						else
							response = "axis";
					}
					else if(numonteam["allies"] < numonteam["axis"])
						response = "allies";
					else
						response = "axis";
					skipbalancecheck = true;
				}
				
				if(response == self.pers["team"] && self.sessionstate == "playing")
					break;
				
				//Check if the teams will become unbalanced when the player goes to this team...
				//------------------------------------------------------------------------------
				if ( (level.teambalance > 0) && (!isdefined (skipbalancecheck)) )
				{
					//Get a count of all players on Axis and Allies
					players = maps\mp\gametypes\_teams::CountPlayers();
					
					if (self.sessionteam != "spectator")
					{
						if (((players[response] + 1) - (players[self.pers["team"]] - 1)) > level.teambalance)
						{
							if (response == "allies")
							{
								if (game["allies"] == "american")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_AMERICAN");
								else if (game["allies"] == "british")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_BRITISH");
								else if (game["allies"] == "russian")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_RUSSIAN");
							}
							else
								self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_GERMAN");
							break;
						}
					}
					else
					{
						if (response == "allies")
							otherteam = "axis";
						else
							otherteam = "allies";
						if (((players[response] + 1) - players[otherteam]) > level.teambalance)
						{
							if (response == "allies")
							{
								if (game["allies"] == "american")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_AMERICAN");
								else if (game["allies"] == "british")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_BRITISH");
								else if (game["allies"] == "russian")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_RUSSIAN");
							}
							else
							{
								if (game["allies"] == "american")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_AMERICAN");
								else if (game["allies"] == "british")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_BRITISH");
								else if (game["allies"] == "russian")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_RUSSIAN");
							}
							break;
						}
					}
				}
				skipbalancecheck = undefined;
				//------------------------------------------------------------------------------
				
				if(response != self.pers["team"] && self.sessionstate == "playing")
					self suicide();
	                        
				self.pers["team"] = response;
				self.pers["teamTime"] = (gettime() / 1000);
				self.pers["weapon"] = undefined;
				self.pers["weapon1"] = undefined;
				self.pers["weapon2"] = undefined;
				self.pers["spawnweapon"] = undefined;
				self.pers["savedmodel"] = undefined;

				// update spectator permissions immediately on change of team
				maps\mp\gametypes\_teams::SetSpectatePermissions();

				self setClientCvar("ui_weapontab", "1");

				if(self.pers["team"] == "allies")
				{
					self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
					self openMenu(game["menu_weapon_allies"]);
				}
				else
				{
					self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
					self openMenu(game["menu_weapon_axis"]);
				}
				break;

			case "spectator":
				if (level.lockteams)
					break;
				if(self.pers["team"] != "spectator")
				{
					if(isAlive(self))
						self suicide();

					self.pers["team"] = "spectator";
					self.pers["teamTime"] = 1000000;
					self.pers["weapon"] = undefined;
					self.pers["weapon1"] = undefined;
					self.pers["weapon2"] = undefined;
					self.pers["spawnweapon"] = undefined;
					self.pers["savedmodel"] = undefined;

					self.sessionteam = "spectator";
					self setClientCvar("g_scriptMainMenu", game["menu_team"]);
					self setClientCvar("ui_weapontab", "0");
					spawnSpectator();
				}
				break;

			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;
			
			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}		
		else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
		{
			if(response == "team")
			{
				self openMenu(game["menu_team"]);
				continue;
			}
			else if(response == "viewmap")
			{
				self openMenu(game["menu_viewmap"]);
				continue;
			}
			else if(response == "callvote")
			{
				self openMenu(game["menu_callvote"]);
				continue;
			}
			
			if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
				continue;

/**/		// TODO: Default weapon procedure.
/**/		menu_weapon(menu, response);
/**/		continue;

			weapon = self maps\mp\gametypes\_teams::restrict(response);

			if(weapon == "restricted")
			{
				self openMenu(menu);
				continue;
			}
			
			self.pers["selectedweapon"] = weapon;

			if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isDefined(self.pers["weapon1"]))
				continue;
				
			if(!game["matchstarted"])
			{
				if(isDefined(self.pers["weapon"]))
				{
			 		self.pers["weapon"] = weapon;
			 		self setWeaponSlotWeapon("primary", weapon);
					self setWeaponSlotAmmo("primary", 999);
					self setWeaponSlotClipAmmo("primary", 999);
					self switchToWeapon(weapon);

/**/				if (getCvarInt("scr_allow_pistol") > 0) {
/**/					maps\mp\gametypes\_teams::givePistol();
/**/				}
/**/				if (getCvarInt("scr_allow_nades") > 0) {
/**/					maps\mp\gametypes\_teams::giveGrenades(self.pers["selectedweapon"]);
/**/				}
				}
				else
				{
					self.pers["weapon"] = weapon;
					self.spawned = undefined;
/**/				spawnPlayer();
					self thread maps\mp\gametypes\sd::printJoinedTeam(self.pers["team"]);
/**/				level checkMatchStart();
				}
			}
			else if(!level.roundstarted && !self.usedweapons)
			{
			 	if(isDefined(self.pers["weapon"]))
			 	{
			 		self.pers["weapon"] = weapon;
			 		self setWeaponSlotWeapon("primary", weapon);
					self setWeaponSlotAmmo("primary", 999);
					self setWeaponSlotClipAmmo("primary", 999);
					self switchToWeapon(weapon);

/**/				if (getCvarInt("scr_allow_pistol") > 0) {
/**/					maps\mp\gametypes\_teams::givePistol();
/**/				}
/**/				if (getCvarInt("scr_allow_nades") > 0) {
/**/					maps\mp\gametypes\_teams::giveGrenades(self.pers["selectedweapon"]);
/**/				}
				}
			 	else
				{			 	
					self.pers["weapon"] = weapon;
					if(!level.exist[self.pers["team"]])
					{
						self.spawned = undefined;
						spawnPlayer();
						self thread maps\mp\gametypes\sd::printJoinedTeam(self.pers["team"]);
/**/					level checkMatchStart();
					}
					else
					{
						spawnPlayer();
						self thread maps\mp\gametypes\sd::printJoinedTeam(self.pers["team"]);
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
/**/				spawnPlayer();
					self thread maps\mp\gametypes\sd::printJoinedTeam(self.pers["team"]);
				}				
				else if(!level.didexist[self.pers["team"]] && !level.roundended)
				{
					self.spawned = undefined;
/**/				spawnPlayer();
					self thread maps\mp\gametypes\sd::printJoinedTeam(self.pers["team"]);
/**/				level checkMatchStart();
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
		}
		else if(menu == game["menu_viewmap"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;
				
			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}
		else if(menu == game["menu_callvote"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;
				
			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "viewmap":
				self openMenu(game["menu_viewmap"]);
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
	
	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	logPrint("Q;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");

	if(game["matchstarted"])
/**/	level thread updateTeamStatus();
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
/**/if(level.p_readying) {
/**/	if (isPlayer(eAttacker) && self != eAttacker)
/**/		eAttacker.pers["killer"] = true;
/**/	
/**/	if (!self.pers["killer"])
/**/		return;
/**/}
/**/
/**/if (level.instrattime)
/**/	return;
/**/
/**/if(level.roundended && !level.p_readying)
/**/	return;

	if(self.sessionteam == "spectator")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

/**/if (isPlayer(eAttacker) && self != eAttacker && eAttacker.pers["team"] != self.pers["team"]) {
/**/	eAttacker thread showhit();
/**/}

/**/// TODO: Configurable damage.
/**/if(sMeansOfDeath == "MOD_RIFLE_BULLET" || sMeansOfDeath == "MOD_MELEE") {
/**/	iDamage = 100;
/**/}

	// check for completely getting out of the damage
	if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		if(isPlayer(eAttacker) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]))
		{
			if(level.friendlyfire == "0")
			{
				return;
			}
			else if(level.friendlyfire == "1")
			{
				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
			}
			else if(level.friendlyfire == "2")
			{
				eAttacker.friendlydamage = true;
		
				iDamage = iDamage * .5;

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker.friendlydamage = undefined;
				
				friendly = true;
			}
			else if(level.friendlyfire == "3")
			{
				eAttacker.friendlydamage = true;

				iDamage = iDamage * .5;

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker.friendlydamage = undefined;
				
				friendly = true;
			}
		}
		else
		{
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;

			self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
		}
	}

	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfguid = self getGuid();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackguid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackguid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		if(isDefined(friendly))
		{  
			lpattacknum = lpselfnum;
			lpattackname = lpselfname;
			lpattackguid = lpselfguid;
		}

		logPrint("D;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("spawned");

/**/if(level.roundended && !level.p_readying)
/**/	return;

	if(self.sessionteam == "spectator")
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	self.sessionstate = "dead";
/**/// self.statusicon = "gfx/hud/hud@status_dead.tga";
/**/if (!level.p_readying || !self.p_ready) {
/**/	self.statusicon = "gfx/hud/hud@status_dead.tga";
/**/}
	self.headicon = "";
	if (!isdefined (self.autobalance))
	{
		self.pers["deaths"]++;
		self.deaths = self.pers["deaths"];
	}

	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	lpselfname = self.name;
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

	attackerNum = -1;

	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;
			if (!isdefined (self.autobalance))
			{
				attacker.pers["score"]--;
				attacker.score = attacker.pers["score"];
			}

			if(isDefined(attacker.friendlydamage))
				clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
			{
				attacker.pers["score"]--;
				attacker.score = attacker.pers["score"];
			}
			else
			{
				attacker.pers["score"]++;
				attacker.score = attacker.pers["score"];
			}
		}
		
		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackerteam = attacker.pers["team"];
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.pers["score"]--;
		self.score = self.pers["score"];

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackerteam = "world";
	}

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Make the player drop his weapon
	if (!isdefined (self.autobalance))
		self dropItem(self getcurrentweapon());

	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	
	if (!isdefined (self.autobalance))
		body = self cloneplayer();
	self.autobalance = undefined;

/**/updateTeamStatus();

	// TODO: Add additional checks that allow killcam when the last player killed wouldn't end the round (bomb is planted)
	if((getCvarInt("scr_killcam") <= 0) || !level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
		doKillcam = false;

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

/**/if (level.p_readying) {
/**/	self thread spawnPlayer();
/**/	return;
/**/}

	if(doKillcam && !level.roundended)
		self thread maps\mp\gametypes\sd::killcam(attackerNum, delay);
	else
	{
		currentorigin = self.origin;
		currentangles = self.angles;

/**/	self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles);
	}
}

spawnPlayer()
{
	self notify("spawned");

	resettimeout();

	self.sessionteam = self.pers["team"];
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

/**/// Allow player to spawn multiple times during warm-up
/**/// if(isDefined(self.spawned))
/**///	return;

/**/if (level.instrattime)
/**/	self.maxspeed = 0;

	self.sessionstate = "playing";
		
	if(self.pers["team"] == "allies")
		spawnpointname = "mp_searchanddestroy_spawn_allied";
	else
		spawnpointname = "mp_searchanddestroy_spawn_axis";

	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	
	self.spawned = true;
/**/if(!level.p_readying || !self.p_ready)
/**/	self.statusicon = "";
/**/// self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	
/**/updateTeamStatus();

	if(!isDefined(self.pers["score"]))
		self.pers["score"] = 0;
	self.score = self.pers["score"];
	
	if(!isDefined(self.pers["deaths"]))
		self.pers["deaths"] = 0;
	self.deaths = self.pers["deaths"];
	
	if(!isDefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);
	
	if(isDefined(self.pers["weapon1"]) && isDefined(self.pers["weapon2"]))
	{
	 	self setWeaponSlotWeapon("primary", self.pers["weapon1"]);
		self setWeaponSlotAmmo("primary", 999);
		self setWeaponSlotClipAmmo("primary", 999);

	 	self setWeaponSlotWeapon("primaryb", self.pers["weapon2"]);
		self setWeaponSlotAmmo("primaryb", 999);
		self setWeaponSlotClipAmmo("primaryb", 999);

		self setSpawnWeapon(self.pers["spawnweapon"]);
	}
	else
	{
		self setWeaponSlotWeapon("primary", self.pers["weapon"]);
		self setWeaponSlotAmmo("primary", 999);
		self setWeaponSlotClipAmmo("primary", 999);
/**/	// Give second weapon if chosen.
/**/	if (isDefined(self.pers["weapon_secondary"])) {
/**/		self setWeaponSlotWeapon("primaryb", self.pers["weapon_secondary"]);
/**/		self setWeaponSlotAmmo("primaryb", 999);
/**/		self setWeaponSlotClipAmmo("primaryb", 999);
/**/	}

		self setSpawnWeapon(self.pers["weapon"]);
	}


/**/if (getcvarint("scr_allow_pistol") > 0) {
/**/	maps\mp\gametypes\_teams::givePistol();
/**/}
/**/if (getcvarint("scr_allow_nades") > 0) {
/**/	maps\mp\gametypes\_teams::giveGrenades(self.pers["selectedweapon"]);
/**/}

	self.usedweapons = false;
	thread maps\mp\gametypes\_teams::watchWeaponUsage();
/**/thread maps\mp\gametypes\_pam_utilities::watchPlayerFastShoot();

	if(self.pers["team"] == game["attackers"])
		self setClientCvar("cg_objectiveText", &"SD_OBJ_ATTACKERS");
	else if(self.pers["team"] == game["defenders"])
		self setClientCvar("cg_objectiveText", &"SD_OBJ_DEFENDERS");
		
	if(level.drawfriend)
	{
		if(self.pers["team"] == "allies")
		{
			self.headicon = game["headicon_allies"];
			self.headiconteam = "allies";
		}
		else
		{
			self.headicon = game["headicon_axis"];
			self.headiconteam = "axis";
		}
	}
}

spawnSpectator(origin, angles)
{
	self notify("spawned");

	resettimeout();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";
		
	maps\mp\gametypes\_teams::SetSpectatePermissions();

	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
 		spawnpointname = "mp_searchanddestroy_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

/**/updateTeamStatus();

	self.usedweapons = false;

	if(game["attackers"] == "allies")
		self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_ALLIESATTACKING");
	else if(game["attackers"] == "axis")
		self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_AXISATTACKING");
}

startGame()
{
	level.starttime = getTime();
	thread startRound();
	
	if ( (level.teambalance > 0) && (!game["BalanceTeamsNextRound"]) )
		level thread maps\mp\gametypes\_teams::TeamBalance_Check_Roundbased();
}

startRound()
{
	level endon("bomb_planted");

/**/// thread maps\mp\gametypes\_teams::sayMoveIn();

	level.clock = newHudElem();
	level.clock.x = 320;
	level.clock.y = 460;
	level.clock.alignX = "center";
	level.clock.alignY = "middle";
	level.clock.font = "bigfixed";
	level.clock setTimer(level.roundlength * 60);
	
	if (getCvar("g_autodemo") == "1")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
		
			player autoDemoStart();
		}
	}

	if(game["matchstarted"])
	{
		level.clock.color = (0, 1, 0);

		if((level.roundlength * 60) > level.graceperiod)
		{
/**/		if (getcvar("scr_strat_time") == "1") {
/**/			level.clock setTimer(level.graceperiod);
/**/			thread Hold_All_Players();
/**/		}

			wait level.graceperiod;
/**/		thread maps\mp\gametypes\_teams::sayMoveIn();

			level notify("round_started");
			level.roundstarted = true;
			level.clock.color = (1, 1, 1);
/**/		if (getcvar("scr_strat_time") == "1") {
/**/			level.clock setTimer(level.roundlength * 60);
/**/		}

			// Players on a team but without a weapon show as dead since they can not get in this round
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if(player.sessionteam != "spectator" && !isDefined(player.pers["weapon"]))
					player.statusicon = "gfx/hud/hud@status_dead.tga";
			}
		
			wait((level.roundlength * 60) - level.graceperiod);
		}
		else
			wait(level.roundlength * 60);
	}
	else	
	{
		level.clock.color = (1, 1, 1);
/**/	// wait(level.roundlength * 60);

/**/	// Pre-match
/**/	level.clock destroy();
/**/	_hud_labels_create();
/**/
/**/	return;
	}
	
	if(level.roundended)
		return;

	if(!level.exist[game["attackers"]] || !level.exist[game["defenders"]])
	{
		announcement(&"SD_TIMEHASEXPIRED");
		level thread endRound("draw");
		return;
	}

	announcement(&"SD_TIMEHASEXPIRED");
	level thread endRound(game["defenders"]);
}

checkMatchStart()
{
	oldvalue["teams"] = level.exist["teams"];
	level.exist["teams"] = false;

	// If teams currently exist
	if(level.exist["allies"] && level.exist["axis"])
		level.exist["teams"] = true;

	// If teams previously did not exist and now they do
	if(!oldvalue["teams"] && level.exist["teams"])
	{
		if(!game["matchstarted"])
		{
/**/		thread _start_ready();
/**/		return;

			announcement(&"SD_MATCHSTARTING");

			level notify("kill_endround");
			level.roundended = false;
			level thread endRound("reset");
		}
		else
		{
			announcement(&"SD_MATCHRESUMING");

			level notify("kill_endround");
			level.roundended = false;
			level thread endRound("draw");
		}

		return;
	}
}

resetScores()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.pers["score"] = 0;
		player.pers["deaths"] = 0;
	}

	game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);
	game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);

/**/game["round1alliesscore"] = 0;
/**/game["round1axisscore"] = 0; 
/**/game["round2alliesscore"] = 0;
/**/game["round2axisscore"] = 0;
}

endRound(roundwinner)
{
	level endon("kill_endround");

	if(level.roundended)
		return;
	level.roundended = true;

	// End bombzone threads and remove related hud elements and objectives
	level notify("round_ended");

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if (getCvar("g_autodemo") == "1")
			player autoDemoStop();
		
		if(isDefined(player.planticon))
			player.planticon destroy();

		if(isDefined(player.defuseicon))
			player.defuseicon destroy();

		if(isDefined(player.progressbackground))
			player.progressbackground destroy();

		if(isDefined(player.progressbar))
			player.progressbar destroy();

		player unlink();
		player enableWeapon();
	}

	objective_delete(0);
	objective_delete(1);

	if(roundwinner == "allies")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_allies_win");
	}
	else if(roundwinner == "axis")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_axis_win");
	}
	else if(roundwinner == "draw")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_round_draw");
	}

	iPrintLn("end round, wait 5 seconds...");
	wait 5;

	winners = "";
	losers = "";

	if(roundwinner == "allies")
	{
		game["alliedscore"]++;
		setTeamScore("allies", game["alliedscore"]);
		
/**/	if (game["halftimeflag"] == "1") {
/**/		game["round2alliesscore"]++;
/**/	} else if(game["matchstarted"]) {
/**/		game["round1alliesscore"]++;
/**/	}

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
		}
		logPrint("W;allies" + winners + "\n");
		logPrint("L;axis" + losers + "\n");
	}
	else if(roundwinner == "axis")
	{
		game["axisscore"]++;
		setTeamScore("axis", game["axisscore"]);

/**/	if (game["halftimeflag"] == "1") {
/**/		game["round2axisscore"]++;
/**/	} else if(game["matchstarted"]) {
/**/		game["round1axisscore"]++;
/**/	}

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
		}
		logPrint("W;axis" + winners + "\n");
		logPrint("L;allies" + losers + "\n");
	}

	if(game["matchstarted"])
	{
		checkScoreLimit();
/**/	// game["roundsplayed"]++;
/**/	if (roundwinner != "draw" || level.countdraws == 1) {
/**/		game["roundsplayed"]++;
/**/	}
		checkRoundLimit();
	}

	if(!game["matchstarted"] && roundwinner == "reset")
	{
		game["matchstarted"] = true;
		thread resetScores();
		game["roundsplayed"] = 0;
	}

	game["timepassed"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;

	checkTimeLimit();

/**/if (level.hithalftime)
/**/	return;

	if(level.mapended)
		return;
	level.mapended = true;

	// for all living players store their weapons
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			primary = player getWeaponSlotWeapon("primary");
			primaryb = player getWeaponSlotWeapon("primaryb");

			// If a menu selection was made
			if(isDefined(player.oldweapon))
			{
				// If a new weapon has since been picked up (this fails when a player picks up a weapon the same as his original)
				if(player.oldweapon != primary && player.oldweapon != primaryb && primary != "none")
				{
					player.pers["weapon1"] = primary;
					player.pers["weapon2"] = primaryb;
					player.pers["spawnweapon"] = player getCurrentWeapon();
				} // If the player's menu chosen weapon is the same as what is in the primaryb slot, swap the slots
				else if(player.pers["weapon"] == primaryb)
				{
					player.pers["weapon1"] = primaryb;
					player.pers["weapon2"] = primary;
					player.pers["spawnweapon"] = player.pers["weapon1"];
				} // Give them the weapon they chose from the menu
				else
				{
					player.pers["weapon1"] = player.pers["weapon"];
					player.pers["weapon2"] = primaryb;
					player.pers["spawnweapon"] = player.pers["weapon1"];
				}
			} // No menu choice was ever made, so keep their weapons and spawn them with what they're holding, unless it's a pistol or grenade
			else
			{
				if(primary == "none")
					player.pers["weapon1"] = player.pers["weapon"];
				else
					player.pers["weapon1"] = primary;
					
				player.pers["weapon2"] = primaryb;

				spawnweapon = player getCurrentWeapon();
				if ( (spawnweapon == "none") && (isdefined (primary)) ) 
					spawnweapon = primary;
				
				if(!maps\mp\gametypes\_teams::isPistolOrGrenade(spawnweapon))
					player.pers["spawnweapon"] = spawnweapon;
				else
					player.pers["spawnweapon"] = player.pers["weapon1"];
			}
		}
	}

	if ( (level.teambalance > 0) && (game["BalanceTeamsNextRound"]) )
	{
		level.lockteams = true;
		level thread maps\mp\gametypes\_teams::TeamBalance();
		level waittill ("Teams Balanced");
		wait 4;
	}

/**/if (getCvarInt("g_roundwarmuptime") != 0 && level.hithalftime == 0) {
/**/	_hud_labels_create();
/**/
/**/	Create_HUD_Scoreboard();
/**/
/**/	warmup = getCvarInt("g_roundwarmuptime");
/**/	Create_HUD_NextRound(warmup);
/**/
/**/	/* Remove match countdown text */
/**/	
/**/	_hud_labels_destroy();
/**/
/**/	Destroy_HUD_Scoreboard();
/**/
/**/	Destroy_HUD_NextRound();
/**/}

	map_restart(true);
}

endMap()
{
	game["state"] = "intermission";
	level notify("intermission");
	
	if(isdefined(level.bombmodel))
		level.bombmodel stopLoopSound();

	if(game["alliedscore"] == game["axisscore"])
		text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
	else if(game["alliedscore"] > game["axisscore"])
		text = &"MPSCRIPT_ALLIES_WIN";
	else
		text = &"MPSCRIPT_AXIS_WIN";

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player closeMenu();
		player setClientCvar("g_scriptMainMenu", "main");
		player setClientCvar("cg_objectiveText", text);
		player maps\mp\gametypes\sd::spawnIntermission();
	}

	wait 1;

	if (getCvar("g_autoscreenshot") == "1")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
		
			player autoScreenshot();
		}
	}

	wait 9;
	exitLevel(false);
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;
	
	if(game["timepassed"] < level.timelimit)
		return;
	
	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
/**/level thread endMap();
}

checkScoreLimit()
{
	if(level.scorelimit <= 0)
		return;
	
	if(game["alliedscore"] < level.scorelimit && game["axisscore"] < level.scorelimit)
		return;

/**/Create_HUD_Matchover();
/**/
/**/Create_HUD_TeamWin();
/**/
/**/_hud_labels_create();
/**/		
/**/Create_HUD_Scoreboard();
/**/
/**/wait 10;
/**/
/**/_hud_labels_destroy();
/**/
/**/Destroy_HUD_Scoreboard();
/**/
/**/Destroy_HUD_TeamWin();
/**/
/**/if(isdefined(level.matchover))
/**/	level.matchover destroy();

	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
	level thread endMap();
}

checkRoundLimit()
{
/**//*  Is it a round-base halftime? */
/**/if (level.halfround != 0  && game["halftimeflag"] == "0")
/**/{
/**/	if(game["roundsplayed"] >= level.halfround)
/**/	{ 
/**/		_half_time();
/**/		return;
/**/	}
/**/}
/**/
/**//*  End of Map Roundlimit! */
/**/if (level.matchround != 0)
/**/{
/**/	if (game["roundsplayed"] >= level.matchround)
/**/	{
/**/		Create_HUD_Matchover();
/**/
/**/		Create_HUD_TeamWin();
/**/
/**/		_hud_labels_create();
/**/			
/**/		Create_HUD_Scoreboard();
/**/
/**/		wait 10;
/**/
/**/		_hud_labels_destroy();
/**/
/**/		Destroy_HUD_Scoreboard();
/**/
/**/		Destroy_HUD_TeamWin();
/**/
/**/		if(isdefined(level.matchover))
/**/			level.matchover destroy();
/**/
/**/		if(level.mapended)
/**/			return;
/**/		level.mapended = true;
/**/
/**/		endMap();
/**/	}
/**/}
}

updateGametypeCvars()
{
/**/level endon("PAMRestart");
/**/enabling = 0;

	for(;;)
	{
		league = getCvar("pam_mode");
		if(league != level.league && !enabling)
		{
			ValidPamMode = maps\mp\gametypes\_pam_utilities::Check_PAM_Modes(league);
			if (ValidPamMode)
			{
				wait .1;
				thread maps\mp\gametypes\_pam_utilities::PAMRestartMap();
				level notify("PAMRestart");
			}
			else
			{
				iprintln("^3PAM Mode has been changed to ^1" + league);
				iprintln("^1" + league + " ^3mode is not valid!");
				iprintln("^3map_restart will return you to pub mode");
			}
			level.league = league;
		}

		playersleft = getcvarint("sv_playersleft");
		if (playersleft != level.playersleft)
		{
			level.playersleft = playersleft;
			if (playersleft == 1)
				iprintln("^3Players Left Display Turned ^2ON");
			else
				iprintln("^3Players Left Display Turned ^1OFF");
		}

		matchround = getCvarInt("scr_end_round");
		if (matchround != level.matchround)
		{
			level.matchround = matchround;
			level.halfround = matchround / 2;
			iprintln("^3scr_end_round ^7has been changed to ^3" + matchround);
		}

		matchscore = getCvarInt("scr_end_score");
		if (matchscore != level.matchscore1)
		{
			level.matchscore1 = matchscore;
			iprintln("^3scr_end_score ^7has been changed to ^3" + matchscore);
		}

		countdraws = getCvarInt("scr_count_draws");
		if (countdraws != level.countdraws)
		{
			level.countdraws = countdraws;
			iprintln("^3scr_count_draws ^7has been changed to ^3" + countdraws);
			if (countdraws == 1)
				iprintln("Round Draws will not be replayed");
			else
				iprintln("Round Draws will be replayed");
		}

		roundlength = getCvarFloat("scr_sd_roundlength");
		if(roundlength > 10)
			setCvar("scr_sd_roundlength", "10");
		if (roundlength != level.roundlength)
		{
			level.roundlength = getCvarFloat("scr_sd_roundlength");
			iprintln("ROUNDLENGTH has been changed to ^5" + roundlength);
		}

		graceperiod = getCvarFloat("scr_sd_graceperiod");
		if(graceperiod > 60)
			setCvar("scr_sd_graceperiod", "60");

		drawfriend = getCvarFloat("scr_drawfriend");
		if(level.drawfriend != drawfriend)
		{
			level.drawfriend = drawfriend;
			
			if(level.drawfriend)
			{
				iprintln("^3Draw Friend has been turned ^2ON!");
				// for all living players, show the appropriate headicon
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
					{
						if(player.pers["team"] == "allies")
						{
							player.headicon = game["headicon_allies"];
							player.headiconteam = "allies";
						}
						else
						{
							player.headicon = game["headicon_axis"];
							player.headiconteam = "axis";
						}
					}
				}
			}
			else
			{
				iprintln("^3Draw Friend has been turned ^1OFF!");
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
						player.headicon = "";
				}
			}
		}

		killcam = getCvarInt("scr_killcam");
		if (level.killcam != killcam)
		{
			level.killcam = getCvarInt("scr_killcam");
			if(level.killcam >= 1)
			{
				setarchive(true);
				iprintln("^3Kill Cam ^2ON!");
			}
			else
			{
				setarchive(false);
				iprintln("^3Kill Cam ^1OFF!");
			}
		}
		
		freelook = getCvarInt("scr_freelook");
		if (level.allowfreelook != freelook)
		{
			level.allowfreelook = getCvarInt("scr_freelook");
			level maps\mp\gametypes\_teams::UpdateSpectatePermissions();
			if (freelook == 0)
				iprintln("^3FREELOOK has been turned ^1OFF!");
			else
				iprintln("^3FREELOOK has been turned ^2ON!");
		}
		
		enemyspectate = getCvarInt("scr_spectateenemy");
		if (level.allowenemyspectate != enemyspectate)
		{
			level.allowenemyspectate = getCvarInt("scr_spectateenemy");
			level maps\mp\gametypes\_teams::UpdateSpectatePermissions();
			if (enemyspectate == 0)
				iprintln("^3Spectate Enemies has been turned ^1OFF!");
			else
				iprintln("^3Spectate Enemies has been turned ^2ON!");
		}
		
		teambalance = getCvarInt("scr_teambalance");
		if (level.teambalance != teambalance)
		{
			level.teambalance = getCvarInt("scr_teambalance");
			if (level.teambalance > 0)
			{
				iprintln("^3TEAMBALANCE has been turned ^2ON!");
				level thread maps\mp\gametypes\_teams::TeamBalance_Check_Roundbased();
			}
			else
				iprintln("^3TEAMBALANCE has been turned ^1OFF!");
		}

		afs_time = getcvarFloat("scr_afs_time");
		if (afs_time != level.afs_time)
		{
			level.afs_time = afs_time;
			iprintln("^3scr_afs_time ^7has been changed to ^3" + afs_time);
		}

		wait 1;
	}
}

updateTeamStatus()
{
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute
	
	resettimeout();
	
	oldvalue["allies"] = level.exist["allies"];
	oldvalue["axis"] = level.exist["axis"];
	level.exist["allies"] = 0;
	level.exist["axis"] = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			level.exist[player.pers["team"]]++;
	}

/**/if(getcvar("sv_playersleft") == "1") {	
/**/	_hud_alive_update();
/**/}

	if(level.exist["allies"])
		level.didexist["allies"] = true;
	if(level.exist["axis"])
		level.didexist["axis"] = true;

/**/if(level.p_readying)
/**/	return;

	if(level.roundended)
		return;

	if(oldvalue["allies"] && !level.exist["allies"] && oldvalue["axis"] && !level.exist["axis"])
	{
		if(!level.bombplanted)
		{
			announcement(&"SD_ROUNDDRAW");
			level thread endRound("draw");
			return;
		}

		if(game["attackers"] == "allies")
		{
			announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
			level thread endRound("allies");
			return;
		}

		announcement(&"SD_AXISMISSIONACCOMPLISHED");
		level thread endRound("axis");
		return;
	}

	if(oldvalue["allies"] && !level.exist["allies"])
	{
		// no bomb planted, axis win
		if(!level.bombplanted)
		{
			announcement(&"SD_ALLIESHAVEBEENELIMINATED");
			level thread endRound("axis");
			return;
		}

		if(game["attackers"] == "allies")
			return;
		
		// allies just died and axis have planted the bomb
		if(level.exist["axis"])
		{
			announcement(&"SD_ALLIESHAVEBEENELIMINATED");
			level thread endRound("axis");
/**/		level.bombmodel stopLoopSound();
/**/		level.bombmodel delete();
/**/		if(isdefined(level.clock))
/**/			level.clock destroy();
			return;
		}

		announcement(&"SD_AXISMISSIONACCOMPLISHED");
		level thread endRound("axis");
/**/	level.bombmodel stopLoopSound();
/**/	level.bombmodel delete();
/**/	if(isdefined(level.clock))
/**/		level.clock destroy();
		return;
	}
	
	if(oldvalue["axis"] && !level.exist["axis"])
	{
		// no bomb planted, allies win
		if(!level.bombplanted)
		{
			announcement(&"SD_AXISHAVEBEENELIMINATED");
			level thread endRound("allies");
			return;
 		}
 		
 		if(game["attackers"] == "axis")
			return;
		
		// axis just died and allies have planted the bomb
		if(level.exist["allies"])
		{
			announcement(&"SD_AXISHAVEBEENELIMINATED");
			level thread endRound("allies");
/**/		level.bombmodel stopLoopSound();
/**/		level.bombmodel delete();
/**/		if(isdefined(level.clock))
/**/			level.clock destroy();
			return;
		}
		
		announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
		level thread endRound("allies");
		return;
	}	
}

bombzones()
{
	level.barsize = 288;
	level.planttime = 5;		// seconds to plant a bomb
	level.defusetime = 10;		// seconds to defuse a bomb

	bombtrigger = getent("bombtrigger", "targetname");
	bombtrigger maps\mp\_utility::triggerOff();

	bombzone_A = getent("bombzone_A", "targetname");
	bombzone_B = getent("bombzone_B", "targetname");
/**/if (game["matchstarted"]) {
/**/	bombzone_A thread bombzone_think(bombzone_B);
/**/	bombzone_B thread bombzone_think(bombzone_A);
/**/}
	wait 1;	// TEMP: without this one of the objective icon is the default. Carl says we're overflowing something.
	objective_add(0, "current", bombzone_A.origin, "gfx/hud/hud@objectiveA.tga");
	objective_add(1, "current", bombzone_B.origin, "gfx/hud/hud@objectiveB.tga");
}

bombzone_think(bombzone_other)
{
	level endon("round_ended");

	level.barincrement = (level.barsize / (20.0 * level.planttime));
	
	for(;;)
	{
		self waittill("trigger", other);

		if(isDefined(bombzone_other.planting))
		{
			if(isDefined(other.planticon))
				other.planticon destroy();

			continue;
		}
		
		if(isPlayer(other) && (other.pers["team"] == game["attackers"]) && other isOnGround())
		{
			if(!isDefined(other.planticon))
			{
				other.planticon = newClientHudElem(other);				
				other.planticon.alignX = "center";
				other.planticon.alignY = "middle";
				other.planticon.x = 320;
				other.planticon.y = 345;
				other.planticon setShader("ui_mp/assets/hud@plantbomb.tga", 64, 64);			
			}
			
			while(other istouching(self) && isAlive(other) && other useButtonPressed())
			{
				other notify("kill_check_bombzone");
				
				self.planting = true;

				if(!isDefined(other.progressbackground))
				{
					other.progressbackground = newClientHudElem(other);				
					other.progressbackground.alignX = "center";
					other.progressbackground.alignY = "middle";
					other.progressbackground.x = 320;
					other.progressbackground.y = 385;
					other.progressbackground.alpha = 0.5;
				}
				other.progressbackground setShader("black", (level.barsize + 4), 12);		

				if(!isDefined(other.progressbar))
				{
					other.progressbar = newClientHudElem(other);				
					other.progressbar.alignX = "left";
					other.progressbar.alignY = "middle";
					other.progressbar.x = (320 - (level.barsize / 2.0));
					other.progressbar.y = 385;
				}
				other.progressbar setShader("white", 0, 8);
				other.progressbar scaleOverTime(level.planttime, level.barsize, 8);

				other playsound("MP_bomb_plant");
				other linkTo(self);
				other disableWeapon();

				self.progresstime = 0;
				while(isAlive(other) && other useButtonPressed() && (self.progresstime < level.planttime))
				{
					self.progresstime += 0.05;
					wait 0.05;
				}
	
				if(isDefined(other.progressbackground))
					other.progressbackground destroy();
				if(isDefined(other.progressbar))
					other.progressbar destroy();

				if(self.progresstime >= level.planttime)
				{
					if(isDefined(other.planticon))
						other.planticon destroy();

					other enableWeapon();

					level.bombexploder = self.script_noteworthy;
					
					bombzone_A = getent("bombzone_A", "targetname");
					bombzone_B = getent("bombzone_B", "targetname");
					bombzone_A delete();
					bombzone_B delete();
					objective_delete(0);
					objective_delete(1);
	
					plant = other maps\mp\_utility::getPlant();
					
					level.bombmodel = spawn("script_model", plant.origin);
					level.bombmodel.angles = plant.angles;
					level.bombmodel setmodel("xmodel/mp_bomb1_defuse");
					level.bombmodel playSound("Explo_plant_no_tick");
					
					bombtrigger = getent("bombtrigger", "targetname");
					bombtrigger.origin = level.bombmodel.origin;

					objective_add(0, "current", bombtrigger.origin, "gfx/hud/hud@bombplanted.tga");
		
					level.bombplanted = true;
					
					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["attackers"] + ";" + other.name + ";" + "bomb_plant" + "\n");
					
/**/				// hide announcement.
/**/				// announcement(&"SD_EXPLOSIVESPLANTED");
										
					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
						players[i] playLocalSound("MP_announcer_bomb_planted");
					
					bombtrigger thread bomb_think();
					bombtrigger thread bomb_countdown();
					
					level notify("bomb_planted");
					level.clock destroy();

/**/				level.clock = newHudElem();
/**/				level.clock.x = 320;
/**/				level.clock.y = 460;
/**/				level.clock.alignX = "center";
/**/				level.clock.alignY = "middle";
/**/				level.clock.font = "bigfixed";
/**/				level.clock setTimer(59);

					return;	//TEMP, script should stop after the wait .05
				}
				else
				{
					other unlink();
					other enableWeapon();
				}
				
				wait .05;
			}
			
			self.planting = undefined;
			other thread check_bombzone(self);
		}
	}
}

check_bombzone(trigger)
{
	self notify("kill_check_bombzone");
	self endon("kill_check_bombzone");
	level endon("round_ended");

	while(isDefined(trigger) && !isDefined(trigger.planting) && self istouching(trigger) && isAlive(self))
		wait 0.05;

	if(isDefined(self.planticon))
		self.planticon destroy();
}

bomb_countdown()
{
	self endon("bomb_defused");
	level endon("intermission");
	
	level.bombmodel playLoopSound("bomb_tick");
	
/**/// countdowntime = 60;

/**/// wait countdowntime;
/**/// Fade from yellow to red
/**/for(i = 0; i < 50; i++)
/**/{
/**/	if(isdefined(level.clock))
/**/		level.clock.color = (1, 1 - i*0.02, 0);
/**/	wait 1;
/**/}
/**/
/**/wait 10;

	// bomb timer is up
	objective_delete(0);
	
	level.bombexploded = true;
	self notify("bomb_exploded");

	// trigger exploder if it exists
	if(isDefined(level.bombexploder))
		maps\mp\_utility::exploder(level.bombexploder);

	// explode bomb
	origin = self getorigin();
	range = 500;
	maxdamage = 2000;
	mindamage = 1000;
		
	self delete(); // delete the defuse trigger
	level.bombmodel stopLoopSound();
	level.bombmodel delete();

	playfx(level._effect["bombexplosion"], origin);
	radiusDamage(origin, range, maxdamage, mindamage);
	
	level thread endRound(game["attackers"]);
}

bomb_think()
{
	self endon("bomb_exploded");
	level.barincrement = (level.barsize / (20.0 * level.defusetime));

	for(;;)
	{
		self waittill("trigger", other);
		
		// check for having been triggered by a valid player
		if(isPlayer(other) && (other.pers["team"] == game["defenders"]) && other isOnGround())
		{
			if(!isDefined(other.defuseicon))
			{
				other.defuseicon = newClientHudElem(other);				
				other.defuseicon.alignX = "center";
				other.defuseicon.alignY = "middle";
				other.defuseicon.x = 320;
				other.defuseicon.y = 345;
				other.defuseicon setShader("ui_mp/assets/hud@defusebomb.tga", 64, 64);			
			}
			
			while(other islookingat(self) && distance(other.origin, self.origin) < 64 && isAlive(other) && other useButtonPressed())
			{
				other notify("kill_check_bomb");

				if(!isDefined(other.progressbackground))
				{
					other.progressbackground = newClientHudElem(other);				
					other.progressbackground.alignX = "center";
					other.progressbackground.alignY = "middle";
					other.progressbackground.x = 320;
					other.progressbackground.y = 385;
					other.progressbackground.alpha = 0.5;
				}
				other.progressbackground setShader("black", (level.barsize + 4), 12);		

				if(!isDefined(other.progressbar))
				{
					other.progressbar = newClientHudElem(other);				
					other.progressbar.alignX = "left";
					other.progressbar.alignY = "middle";
					other.progressbar.x = (320 - (level.barsize / 2.0));
					other.progressbar.y = 385;
				}
				other.progressbar setShader("white", 0, 8);			
				other.progressbar scaleOverTime(level.defusetime, level.barsize, 8);

				other playsound("MP_bomb_defuse");
				other linkTo(self);
				other disableWeapon();

				self.progresstime = 0;
				while(isAlive(other) && other useButtonPressed() && (self.progresstime < level.defusetime))
				{
					self.progresstime += 0.05;
					wait 0.05;
				}

				if(isDefined(other.progressbackground))
					other.progressbackground destroy();
				if(isDefined(other.progressbar))
					other.progressbar destroy();

				if(self.progresstime >= level.defusetime)
				{
					if(isDefined(other.defuseicon))
						other.defuseicon destroy();

					objective_delete(0);

					self notify("bomb_defused");
					level.bombmodel setmodel("xmodel/mp_bomb1");
					level.bombmodel stopLoopSound();
/**/				if(isdefined(level.clock))
/**/					level.clock destroy();

					announcement(&"SD_EXPLOSIVESDEFUSED");
					
					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["defenders"] + ";" + other.name + ";" + "bomb_defuse" + "\n");
					
					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
					{
						players[i] playLocalSound("MP_announcer_bomb_defused");
					}
					level thread endRound(game["defenders"]);
					return;	//TEMP, script should stop after the wait .05
				}
				else
				{
					other unlink();
					other enableWeapon();
				}
				
				wait .05;
			}

			self.defusing = undefined;
/**/		other thread maps\mp\gametypes\sd::check_bomb(self);
		}
	}
}


_hud_labels_create()
{
	if (isDefined(level.p_hud_labels_right)) {
		return;
	}

	level.p_hud_labels_right = newHudElem();
	level.p_hud_labels_right.x = 575;
	level.p_hud_labels_right.y = 10;
	level.p_hud_labels_right.alignX = "center";
	level.p_hud_labels_right.alignY = "middle";
	level.p_hud_labels_right.fontScale = 1;
	level.p_hud_labels_right.color = (1, 1, 1);
	level.p_hud_labels_right setText(game["pamstring"]);

	level.p_hud_labels_left = newHudElem();
	level.p_hud_labels_left.x = 10;
	level.p_hud_labels_left.y = 10;
	level.p_hud_labels_left.alignX = "left";
	level.p_hud_labels_left.alignY = "middle";
	level.p_hud_labels_left.fontScale = 1;
	level.p_hud_labels_left.color = (1, 1, 1);
	level.p_hud_labels_left setText(game["leaguestring"]);
}

_hud_labels_destroy()
{
	if (isDefined(level.p_hud_labels_left)) {
		level.p_hud_labels_left destroy();
	}
	if (isDefined(level.p_hud_labels_right)) {
		level.p_hud_labels_right destroy();
	}
	if (isDefined(level.p_hud_labels_overtime_mode)) {
		level.p_hud_labels_overtime_mode destroy();
	}
}

Create_HUD_Scoreboard()
{	// Set up Scorboard Vertical Positioning
	// CHANGE ONLY SCOREBOARDY
	scoreboardy = 197;
	teamsy = scoreboardy + 15;
	half1y = scoreboardy + 28;
	half2y = scoreboardy + 45;
	matchy = scoreboardy + 65;


	// Display TEAMS
	level.scorebd = newHudElem();
	level.scorebd.x = 575;
	level.scorebd.y = scoreboardy;
	level.scorebd.alignX = "center";
	level.scorebd.alignY = "middle";
	level.scorebd.fontScale = 1;
	level.scorebd.color = (.99, .99, .75);
	level.scorebd setText(game["scorebd"]);

	level.team1 = newHudElem();
	level.team1.x = 535;
	level.team1.y = teamsy;
	level.team1.alignX = "center";
	level.team1.alignY = "middle";
	level.team1.fontScale = .75;
	level.team1.color = (.73, .99, .73);
	level.team1 setText(game["dspteam1"]);

	level.team2 = newHudElem();
	level.team2.x = 615;
	level.team2.y = teamsy;
	level.team2.alignX = "center";
	level.team2.alignY = "middle";
	level.team2.fontScale = .75;
	level.team2.color = (.85, .99, .99);
	level.team2 setText(game["dspteam2"]);

	// First Half Score Display
	level.firhalfscore = newHudElem();
	level.firhalfscore.x = 575;
	level.firhalfscore.y = half1y;
	level.firhalfscore.alignX = "center";
	level.firhalfscore.alignY = "middle";
	level.firhalfscore.fontScale = .75;
	level.firhalfscore.color = (.99, .99, .75);
	level.firhalfscore setText(game["1sthalf"]);

	level.firhalfaxisscorenum = newHudElem();
	level.firhalfaxisscorenum.x = 532;
	level.firhalfaxisscorenum.y = half1y;
	level.firhalfaxisscorenum.alignX = "center";
	level.firhalfaxisscorenum.alignY = "middle";
	level.firhalfaxisscorenum.fontScale = .75;
	level.firhalfaxisscorenum.color = (.73, .99, .75);
	level.firhalfaxisscorenum setValue(game["round1axisscore"]);

	level.firhalfalliesscorenum = newHudElem();
	level.firhalfalliesscorenum.x = 618;
	level.firhalfalliesscorenum.y = half1y;
	level.firhalfalliesscorenum.alignX = "center";
	level.firhalfalliesscorenum.alignY = "middle";
	level.firhalfalliesscorenum.fontScale = .75;
	level.firhalfalliesscorenum.color = (.85, .99, .99);
	level.firhalfalliesscorenum setValue(game["round1alliesscore"]);

	// Second Half Score Display
	level.sechalfscore = newHudElem();
	level.sechalfscore.x = 575;
	level.sechalfscore.y = half2y;
	level.sechalfscore.alignX = "center";
	level.sechalfscore.alignY = "middle";
	level.sechalfscore.fontScale = .75;
	level.sechalfscore.color = (.99, .99, .75);
	level.sechalfscore setText(game["2ndhalf"]);
			
	level.sechalfaxisscorenum = newHudElem();
	level.sechalfaxisscorenum.x = 618;
	level.sechalfaxisscorenum.y = half2y;
	level.sechalfaxisscorenum.alignX = "center";
	level.sechalfaxisscorenum.alignY = "middle";
	level.sechalfaxisscorenum.fontScale = .75;
	level.sechalfaxisscorenum.color = (.85, .99, .99);
	level.sechalfaxisscorenum setValue(game["round2axisscore"]);

	level.sechalfalliesscorenum = newHudElem();
	level.sechalfalliesscorenum.x = 532;
	level.sechalfalliesscorenum.y = half2y;
	level.sechalfalliesscorenum.alignX = "center";
	level.sechalfalliesscorenum.alignY = "middle";
	level.sechalfalliesscorenum.fontScale = .75;
	level.sechalfalliesscorenum.color = (.73, .99, .75);
	level.sechalfalliesscorenum setValue(game["round2alliesscore"]);
			
	// Match Score Display
	level.matchscore = newHudElem();
	level.matchscore.x = 575;
	level.matchscore.y = matchy;
	level.matchscore.alignX = "center";
	level.matchscore.alignY = "middle";
	level.matchscore.fontScale = .8;
	level.matchscore.color = (.99, .99, .75);
	level.matchscore setText(game["matchscore2"]);

	level.matchaxisscorenum = newHudElem();
	if(game["halftimeflag"] == "1")
	{
		level.matchaxisscorenum.x = 618;
		level.matchaxisscorenum.color = (.85, .99, .99);
	}
	else
	{
		level.matchaxisscorenum.x = 532;
		level.matchaxisscorenum.color = (.73, .99, .75);
	}
	level.matchaxisscorenum.y = matchy;
	level.matchaxisscorenum.alignX = "center";
	level.matchaxisscorenum.alignY = "middle";
	level.matchaxisscorenum.fontScale = 1;
	level.matchaxisscorenum setValue(game["axisscore"]);

	level.matchalliesscorenum = newHudElem();
	if(game["halftimeflag"] == "1")
	{
		level.matchalliesscorenum.x = 535;
		level.matchalliesscorenum.color = (.73, .99, .75);
	}
	else
	{
		level.matchalliesscorenum.x = 618;
		level.matchalliesscorenum.color = (.85, .99, .99);
	}
	level.matchalliesscorenum.y = matchy;
	level.matchalliesscorenum.alignX = "center";
	level.matchalliesscorenum.alignY = "middle";
	level.matchalliesscorenum.fontScale = 1;
	level.matchalliesscorenum setValue(game["alliedscore"]);
}

Destroy_HUD_Scoreboard()
{
	if(isdefined(level.scorebd))
		level.scorebd destroy();
	if(isdefined(level.team1))
		level.team1 destroy();
	if(isdefined(level.team2))
		level.team2 destroy();

	if(isdefined(level.firhalfscore))
		level.firhalfscore destroy();
	if(isdefined(level.firhalfaxisscore))
		level.firhalfaxisscore destroy();
	if(isdefined(level.firhalfalliesscore))
		level.firhalfalliesscore destroy();
	if(isdefined(level.firhalfaxisscorenum))
		level.firhalfaxisscorenum destroy();
	if(isdefined(level.firhalfalliesscorenum))
		level.firhalfalliesscorenum destroy();

	if(isdefined(level.sechalfscore))
		level.sechalfscore destroy();
	if(isdefined(level.sechalfaxisscore))
		level.sechalfaxisscore destroy();
	if(isdefined(level.sechalfalliesscore))
		level.sechalfalliesscore destroy();
	if(isdefined(level.sechalfaxisscorenum))
		level.sechalfaxisscorenum destroy();
	if(isdefined(level.sechalfalliesscorenum))
		level.sechalfalliesscorenum destroy();

	if(isdefined(level.matchscore))
		level.matchscore destroy();
	if(isdefined(level.matchaxisscorenum))
		level.matchaxisscorenum destroy();
	if(isdefined(level.matchalliesscorenum))
		level.matchalliesscorenum destroy();

}

Create_HUD_NextRound(time)
{
	if ( time < 3 )
		time = 3;

	level.round = newHudElem();
	level.round.x = 540;
	level.round.y = 295;
	level.round.alignX = "center";
	level.round.alignY = "middle";
	level.round.fontScale = 1;
	level.round.color = (1, 1, 0);
	level.round setText(game["round"]);		
		
	level.roundnum = newHudElem();
	level.roundnum.x = 540;
	level.roundnum.y = 315;
	level.roundnum.alignX = "center";
	level.roundnum.alignY = "middle";
	level.roundnum.fontScale = 1;
	level.roundnum.color = (1, 1, 0);
	round = game["roundsplayed"] + 1;
	level.roundnum setValue(round);

	level.starting = newHudElem();
	level.starting.x = 540;
	level.starting.y = 335;
	level.starting.alignX = "center";
	level.starting.alignY = "middle";
	level.starting.fontScale = 1;
	level.starting.color = (1, 1, 0);
	level.starting setText(game["starting"]);

	// Give all players a count-down stopwatch
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++) {
		player = players[i];
		
		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player thread stopwatch_start(time);
	}
	
	iPrintLn("next round HUD, wait " + time + " seconds...");
	wait (time);

	if(isdefined(level.round))
		level.round destroy();
	if(isdefined(level.roundnum))
		level.roundnum destroy();
	if(isdefined(level.starting))
		level.starting destroy();
}

Destroy_HUD_NextRound()
{
	if(isdefined(level.round))
		level.round destroy();
	if(isdefined(level.roundnum))
		level.roundnum destroy();
	if(isdefined(level.startingin))
		level.startingin destroy();
}


Create_HUD_TeamWin()
{
	level.teamwin = newHudElem();
	level.teamwin.x = 575;
	level.teamwin.y = 155;
	level.teamwin.alignX = "center";
	level.teamwin.alignY = "middle";
	level.teamwin.fontScale = 1.1;

	if (game["axisscore"] == game["alliedscore"])
	{
		level.teamwin.color = (1, 1, 0);
		level.teamwin setText(game["dsptie"]);
	}
	else if (game["axisscore"] > game["alliedscore"] && game["halftimeflag"] == "1")
	{
		level.teamwin.color = (.85, .99, .99);
		level.teamwin setText(game["team2win"]);
	}
	else if (game["axisscore"] < game["alliedscore"] && game["halftimeflag"] == "0")
	{
		level.teamwin.color = (.85, .99, .99);
		level.teamwin setText(game["team2win"]);
	}
	else
	{
		level.teamwin.color = (.73, .99, .75);
		level.teamwin setText(game["team1win"]);
	}
}

Destroy_HUD_TeamWin()
{
	if(isdefined(level.teamwin))
		level.teamwin destroy();
}

_start_ready()
{
	if (level.p_readying) {
		return;
	}

	maps\mp\gametypes\_pam_readyup::PAM_Ready_UP();

	_hud_ready_create(game["halftimeflag"] + 1);
	wait 5;
	_hud_ready_destroy();

	//Starting Round 1 Clock
	time = getCvarInt("g_roundwarmuptime");
	if (time < 1) {
		time = 1;
	}

	_hud_roundstart_create(game["halftimeflag"] + 1, time);

	wait time;

	_hud_roundstart_destroy();

	level notify("kill_endround");
	level.roundended = false;
	level thread endRound("reset");
}

stopwatch_start(time)
{
	if(isDefined(self.stopwatch))
		self.stopwatch destroy();
		
	self.stopwatch = newClientHudElem(self);
	maps\mp\gametypes\_pam_utilities::InitClock(self.stopwatch, time);
	self.stopwatch.archived = false;

	wait (time);

	if(isDefined(self.stopwatch)) 
		self.stopwatch destroy();
}

_hud_ready_create(next_half)
{
	level.p_hud_ready = newHudElem();
	level.p_hud_ready.x = 320;
	level.p_hud_ready.y = 390;
	level.p_hud_ready.alignX = "center";
	level.p_hud_ready.alignY = "middle";
	level.p_hud_ready.fontScale = 1.5;
	level.p_hud_ready.color = (0, 1, 0);
	level.p_hud_ready setText(game["allready"]);
		
	level.p_hud_ready_next_half = newHudElem();
	level.p_hud_ready_next_half.x = 320;
	level.p_hud_ready_next_half.y = 370;
	level.p_hud_ready_next_half.alignX = "center";
	level.p_hud_ready_next_half.alignY = "middle";
	level.p_hud_ready_next_half.fontScale = 1.5;
	level.p_hud_ready_next_half.color = (0, 1, 0);

	if (next_half == 1) {
		level.p_hud_ready_next_half setText(game["start1sthalf"]);
	} else {
		level.p_hud_ready_next_half setText(game["start2ndhalf"]);
	}
}

_hud_ready_destroy()
{
	if (isDefined(level.p_hud_ready)) {
		level.p_hud_ready destroy();
	}
	if (isDefined(level.p_hud_ready_next_half)) {
		level.p_hud_ready_next_half destroy();
	}
}

_hud_roundstart_create(half, time)
{
	level.hud_round = newHudElem();
	level.hud_round.x = 540;
	level.hud_round.y = 295;
	level.hud_round.alignX = "center";
	level.hud_round.alignY = "middle";
	level.hud_round.fontScale = 1;
	level.hud_round.color = (1, 1, 0);
	if (half == 1)
		level.hud_round setText(game["first"]);	
	else
		level.hud_round setText(game["second"]);	
		
	level.roundnum = newHudElem();
	level.roundnum.x = 540;
	level.roundnum.y = 315;
	level.roundnum.alignX = "center";
	level.roundnum.alignY = "middle";
	level.roundnum.fontScale = 1;
	level.roundnum.color = (1, 1, 0);
	level.roundnum setText(game["half"]);

	level.starting = newHudElem();
	level.starting.x = 540;
	level.starting.y = 335;
	level.starting.alignX = "center";
	level.starting.alignY = "middle";
	level.starting.fontScale = 1;
	level.starting.color = (1, 1, 0);
	level.starting setText(game["starting"]);

	level.p_hud_stopwatch = newHudElem();
	level.p_hud_stopwatch.x = 590;
	level.p_hud_stopwatch.y = 315;
	level.p_hud_stopwatch.alignX = "center";
	level.p_hud_stopwatch.alignY = "middle";
	level.p_hud_stopwatch.sort = 9999;
	level.p_hud_stopwatch.archived = false;
	level.p_hud_stopwatch setClock(time, 60, "hudStopwatch", 64, 64);
}

_hud_roundstart_destroy()
{
	if(isdefined(level.hud_round))
		level.hud_round destroy();
	if(isdefined(level.roundnum))
		level.roundnum destroy();
	if(isdefined(level.starting))
		level.starting destroy();
	if(isdefined(level.p_hud_stopwatch))
		level.p_hud_stopwatch destroy();
}

_half_time()
{
	level.hithalftime = 1;

	_hud_labels_create();

	// Display scores.
	level.halftime = newHudElem();
	level.halftime.x = 575;
	level.halftime.y = 175;
	level.halftime.alignX = "center";
	level.halftime.alignY = "middle";
	level.halftime.fontScale = 1.5;
	level.halftime.color = (1, 1, 0);
	level.halftime setText(game["halftime"]);
	
	Create_HUD_Scoreboard();
	
	wait 1;

	Create_HUD_TeamSwap();

	/* Remove match countdown text */

	wait 7;
		
	Destroy_HUD_TeamSwap();

	game["halftimeflag"] = 1;

	// Switch team scores.
	axisscore = game["axisscore"];
	alliedscore = game["alliedscore"];
	game["axisscore"] = alliedscore;
	setTeamScore("axis", game["axisscore"]);
	game["alliedscore"] = axisscore;
	setTeamScore("allies", game["alliedscore"]);

	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++) { 
		player = players[i];

		if (isDefined(player.pers["team"])) {
			if (player.pers["team"] == "axis") {
				player.pers["team"] = "allies";
			} else if (player.pers["team"] == "allies") {
				player.pers["team"] = "axis";
			}
		}

		player.pers["weapon"] = undefined;
		player.pers["weapon1"] = undefined;
		player.pers["weapon2"] = undefined;
		player.pers["spawnweapon"] = undefined;
		player.pers["savedmodel"] = undefined;
		player.pers["selectedweapon"] = undefined;
		player.sessionstate = "spectator";
		player.spectatorclient = -1;
		player.archivetime = 0;

		player unlink();
		player enableWeapon();
		
		//Respawn with new weapons
		player thread Halftimespawn();
	}

	_start_ready();

	// Get rid of warmup weapons.
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++) { 
		player = players[i];

		if (!isDefined(player.pers["selectedweapon"]) )
			player.pers["selectedweapon"] = undefined;
		player.pers["weapon1"] = undefined;
		player.pers["weapon2"] = undefined;
		player.pers["weapon"] = player.pers["selectedweapon"];
		player.pers["spawnweapon"] = player.pers["selectedweapon"];

		player unlink();
	}

	_hud_labels_destroy();

	map_restart(true);

	return;
}

HalftimeSpawn()
{
	if (self.pers["team"] == "spectator")
		return;

	myteam = self.pers["team"];

	self closeMenu();

	if(isDefined(self.pers["weapon"]))
		spawnPlayer();
	else
	{
		//self.sessionteam = "spectator";

		spawnSpectator();

		if(self.pers["team"] == "allies")
		{
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
			self openMenu(game["menu_weapon_allies"]);
		}
		else
		{
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
			self openMenu(game["menu_weapon_axis"]);
		}
	}

	while (!isdefined(self.pers["weapon"]) )
	{
		if(self.pers["team"] != myteam && self.pers["team"] != "spectator")
		{
			self.pers["team"] = myteam;
			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}

		if (self.pers["team"] == "spectator")
			return;

		wait .1;
	}

	if (isdefined(self.pers["weapon"]) )
		spawnPlayer();
}

Create_HUD_TeamSwap()
{
	level.switching = newHudElem();
	level.switching.x = 575;
	level.switching.y = 280;
	level.switching.alignX = "center";
	level.switching.alignY = "middle";
	level.switching.fontScale = 1;
	level.switching.color = (1, 1, 0);
	level.switching setText(game["switching"]);

	level.switching2 = newHudElem();
	level.switching2.x = 575;
	level.switching2.y = 300;
	level.switching2.alignX = "center";
	level.switching2.alignY = "middle";
	level.switching2.fontScale = 1;
	level.switching2.color = (1, 1, 0);
	level.switching2 setText(game["switching2"]);
}

Destroy_HUD_TeamSwap()
{
	if(isdefined(level.switching))
		level.switching destroy();
	if(isdefined(level.switching2))
		level.switching2 destroy();
}

Create_HUD_Matchover()
{
	level.matchover = newHudElem();
	level.matchover.x = 575;
	level.matchover.y = 175;
	level.matchover.alignX = "center";
	level.matchover.alignY = "middle";
	level.matchover.fontScale = 1;
	level.matchover.color = (1, 1, 0);
	level.matchover setText(game["matchover"]);
}

Hold_All_Players()
{
	// Allow damage or death yet
	level.instrattime = true;

	wait .5;

	// Strat Time HUD
	level.strattime = newHudElem();
	level.strattime.x = 320;
	level.strattime.y = 440;
	level.strattime.alignX = "center";
	level.strattime.alignY = "middle";
	level.strattime.fontScale = 2;
	level.strattime.color = (0, 1, 0);
	level.strattime setText(game["strattime"]);

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player.maxspeed = 0;
	}

	while (!level.roundstarted)
	{
		wait .2;
	}

	if(isdefined(level.strattime))
		level.strattime destroy();

	level.instrattime = false;

	thread maps\mp\gametypes\_teams::sayMoveIn();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{ 
		player = players[i];

		player.maxspeed = getcvar("g_speed");
	}
}

showhit()
{
	if(isDefined(self.p_hitblip)) {
		self.p_hitblip destroy();
	}

	self.p_hitblip = newClientHudElem(self);
	self.p_hitblip.alignX = "center";
	self.p_hitblip.alignY = "middle";
	self.p_hitblip.x = 320;
	self.p_hitblip.y = 240;
	self.p_hitblip.alpha = 0.5;
	self.p_hitblip setShader("gfx/hud/hud@fire_ready.tga", 32, 32);
	self.p_hitblip scaleOverTime(0.15, 64, 64);

	wait 0.15;

	if(isDefined(self.p_hitblip)) {
		self.p_hitblip destroy();
	}
}

// Weapon procedure allowing second weapon pick.
menu_weapon(menu, response) {
	// Allow enemy team weapons.
	weapon = self maps\mp\gametypes\_teams::restrict_anyteam(response);
	if (weapon == "restricted") {
		self openMenu(menu);
		return;
	}

	// The menu that is opened for them differs per team
	if (self.pers["team"] == "allies") {
		menu_1 = game["menu_weapon_allies"];
		menu_2 = game["menu_weapon_axis"];
	} else {
		menu_1 = game["menu_weapon_axis"];
		menu_2 = game["menu_weapon_allies"];
	}

	// If this is the first weapon picked, or if it is and second weapon is picked too
	if (menu == menu_1) {
		self.pers["weapon"] = weapon;
		self.pers["selectedweapon"] = weapon;

		self openMenu(menu_2);
		return;
	} else {
		self.pers["weapon_secondary"] = weapon;
	}

	if (!game["matchstarted"] || !level.roundstarted) {
		if (self.sessionstate == "playing") {
			self setWeaponSlotWeapon("primary", self.pers["weapon"]);
			self setWeaponSlotAmmo("primary", 999);
			self setWeaponSlotClipAmmo("primary", 999);

			self setWeaponSlotWeapon("primaryb", self.pers["weapon_secondary"]);
			self setWeaponSlotAmmo("primaryb", 999);
			self setWeaponSlotClipAmmo("primaryb", 999);

			self switchToWeapon(self.pers["weapon"]);
		} else {
			spawnPlayer();
			self thread maps\mp\gametypes\sd::printJoinedTeam(self.pers["team"]);
			level checkMatchStart();
		}
	} else {
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
			spawnPlayer();
			self thread maps\mp\gametypes\sd::printJoinedTeam(self.pers["team"]);
		} else if (!level.didexist[self.pers["team"]] && !level.roundended) {
			self.spawned = undefined;
			spawnPlayer();
			self thread maps\mp\gametypes\sd::printJoinedTeam(self.pers["team"]);
			level checkMatchStart();
		} else {
			weaponname = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon"]);
			weaponname2 = maps\mp\gametypes\_teams::getWeaponName(self.pers["weapon_secondary"]);

			if (self.pers["team"] == "allies") {
				if (maps\mp\gametypes\_teams::useAn(self.pers["weapon"])) {
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname);
				} else {
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname);
				}
				if (maps\mp\gametypes\_teams::useAn(self.pers["weapon2"])) {
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname2);
				} else {
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname2);
				}
			} else if (self.pers["team"] == "axis") {
				if (maps\mp\gametypes\_teams::useAn(self.pers["weapon"])) {
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND", weaponname);
				} else {
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND", weaponname);
				}
				if (maps\mp\gametypes\_teams::useAn(self.pers["weapon2"])) {
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND", weaponname2);
				} else {
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND", weaponname2);
				}
			}
		}
	}

	self thread maps\mp\gametypes\_teams::SetSpectatePermissions();
	if (isDefined(self.autobalance_notify))
		self.autobalance_notify destroy();
}

_hud_alive_create()
{
	if (isDefined(level.p_hud_alive_allies)) {
		return;
	}

	level.p_hud_alive_allies = newHudElem();
	level.p_hud_alive_allies.x = 384;
	level.p_hud_alive_allies.y = 454;
	level.p_hud_alive_allies.fontScale = .75;
	level.p_hud_alive_allies setText(game["dspalliesleft"]);

	level.p_hud_alive_allies_val = newHudElem();
	level.p_hud_alive_allies_val.x = 456;
	level.p_hud_alive_allies_val.y = 454;
	level.p_hud_alive_allies_val.alignX = "right";
	level.p_hud_alive_allies_val.fontScale = .75;

	level.p_hud_alive_axis = newHudElem();
	level.p_hud_alive_axis.x = 384;
	level.p_hud_alive_axis.y = 464;
	level.p_hud_alive_axis.fontScale = .75;
	level.p_hud_alive_axis setText(game["dspaxisleft"]);
		
	level.p_hud_alive_axis_val = newHudElem();
	level.p_hud_alive_axis_val.x = 456;
	level.p_hud_alive_axis_val.y = 464;
	level.p_hud_alive_axis_val.alignX = "right";
	level.p_hud_alive_axis_val.fontScale = .75;
}

_hud_alive_destroy()
{
	if (isDefined(level.p_hud_alive_allies)) {
		level.p_hud_alive_allies destroy();
	}
	if (isDefined(level.p_hud_alive_axis)) {
		level.p_hud_alive_axis destroy();
	}
}

_hud_alive_update()
{
	_hud_alive_create();

	level.p_hud_alive_allies_val setValue(level.exist["allies"]);
	level.p_hud_alive_axis_val setValue(level.exist["axis"]);
}
