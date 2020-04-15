PAM_Ready_UP()
{
	wait 0;

	level.rdyup = 1;
	level.warmup = 0;
	level.playersready = false;
	if (!isdefined(game["firstreadyupdone"]) )
		game["firstreadyupdone"] = 0;

	// Ready-Up Mode HUD
	level.waiting = newHudElem();
	level.waiting.alignX = "center";
	level.waiting.alignY = "middle";
	level.waiting.color = (1, 0, 0);
	level.waiting.x = 320;
	level.waiting.y = 390;
	level.waiting.fontScale = 1.5;
	level.waiting setText(game["waiting"]);

	setClientNameMode("manual_change");
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player.pers["killer"] = false;

		lpselfnum = player getEntityNumber();
		player.statusicon = "";
		level.R_U_Name[lpselfnum] = player.name;
		level.R_U_State[lpselfnum] = "notready";
		player.R_U_Looping = 0;

		player thread readyup(lpselfnum);
	}

	Waiting_On_Players(); //used to be its own thread, now we wait in there until its finished

	if(isdefined(level.waiting))
		level.waiting destroy();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.statusicon = "";
	}

	setClientNameMode("auto_change");
	game["dolive"] = 1;
	level.rdyup = 0;
	level.warmup = 1;
	game["firstreadyupdone"] = 1;
}

Waiting_On_Players()
{
	wait 0;
	wait_on_timer = 0;

	level.waitingon = newHudElem(self);
	level.waitingon.x = 575;
	level.waitingon.y = 40;
	level.waitingon.alignX = "center";
	level.waitingon.alignY = "middle";
	level.waitingon.fontScale = 1.1;
	level.waitingon.color = (.8, 1, 1);
	level.waitingon setText(game["waitingon"]);

	level.playerstext = newHudElem(self);
	level.playerstext.x = 575;
	level.playerstext.y = 80;
	level.playerstext.alignX = "center";
	level.playerstext.alignY = "middle";
	level.playerstext.fontScale = 1.1;
	level.playerstext.color = (.8, 1, 1);
	level.playerstext setText(game["playerstext"]);

	level.notreadyhud = newHudElem(self);
	level.notreadyhud.x = 575;
	level.notreadyhud.y = 60;
	level.notreadyhud.alignX = "center";
	level.notreadyhud.alignY = "middle";
	level.notreadyhud.fontScale = 1.2;
	level.notreadyhud.color = (.98, .98, .60);

	// print out players not ready every 13 seconds and maintain Player Not Ready count
	//wait_on_timer = 0;
	while(!level.playersready)
	{
		notready = 0;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			lpselfnum = player getEntityNumber();
			if (level.R_U_State[lpselfnum] == "notready")
			{
				notready++;
				//if (wait_on_timer == 13)
				//	iprintlnbold("Waiting for " + level.R_U_Name[lpselfnum]);
			}
		}

		level.notreadyhud setValue(notready);

		// increment waitready and wait a second before running through script again
		//if (wait_on_timer == 13)
		//	wait_on_timer = 0;

		//wait_on_timer++;
		wait 1;
	}

	if(isdefined(level.notreadyhud))
		level.notreadyhud destroy();
	if(isdefined(level.waitingon))
		level.waitingon destroy();
	if(isdefined(level.playerstext))
		level.playerstext destroy();
}

readyup(entity)
{
	wait .5; // Required or the "respawn" notify could happen before it's waittill has begun


	//ClanBase Warning
	if(game["halftimeflag"] == "0")
		self ClanBase_Warning();
	else
		self ClanBase_Warning2();


	//Announce what Team the player is on
	if ( (self.pers["team"] == "axis" && game["firstreadyupdone"]  == 0) || (self.pers["team"] == "allies" && game["firstreadyupdone"] != 0) )
		self iprintlnbold("^7You are on team ^41^7.");
	else
		self iprintlnbold("^7You are on team ^42^7.");
	
	self iprintlnbold("^7Hit the ^9USE ^7key to begin^4.");

	// PK3 Checker **Put it here so it shows up after weapon is selected**
	maps\mp\gametypes\_pam_utilities::CheckPK3files();

	status = newClientHudElem(self);
	status.x = 575;
	status.y = 120;
	status.alignX = "center";
	status.alignY = "middle";
	status.fontScale = 1.1;
	status.color = (.8, 1, 1);
	status setText(game["status"]);

	readyhud = newClientHudElem(self);
	readyhud.x = 575;
	readyhud.y = 135;
	readyhud.alignX = "center";
	readyhud.alignY = "middle";
	readyhud.fontScale = 1.2;
	readyhud.color = (1, .66, .66);
	readyhud setText(game["notready"]);

	playername = level.R_U_Name[entity];

	while(!level.playersready)
	{
		self.R_U_Looping = 1;

		if(self useButtonPressed() == true)
		{
			if (level.R_U_State[entity] == "notready")
			{
				level.R_U_State[entity] = "ready";
				self.statusicon = game["headicon_carrier"];
				iprintln(playername + "^7 is ^2ready");
				logPrint(playername + ";" + " is Ready Logfile;" + "\n");

				// change players hud to indicate player not ready
				readyhud.color = (.73, .99, .73);
				readyhud setText(game["ready"]);

				wait 1;
				thread Check_All_Ready();

			}
			else if (level.R_U_State[entity] == "ready")
			{
				level.R_U_State[entity] = "notready";
				self.statusicon = "";
				iprintln(playername + "^7 is ^1not ready");
				logPrint(playername + ";" + " is Not Ready Logfile;" + "\n");

				// change players hud to indicate player not ready
				readyhud.color = (1, .84, .84);
				readyhud setText(game["notready"]);
				wait 1;
			}
			while (self useButtonPressed() == true)
				wait .05;
		}
		else
			wait .1;

		if (level.R_U_State[entity] == "disconnected")
		{
			self.R_U_Looping = 0;
			level.R_U_Name[entity] = "disconnected";
			return;
		}
	}

	if(isdefined(readyhud))
		readyhud destroy();
	if(isdefined(status))
		status destroy();
}

Check_All_Ready()
{
	wait .1;
	checkready = true;

	// Check to see if all players are looping
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		lpselfnum = player getEntityNumber();

		if (!isdefined(player.R_U_Looping) )
		{
			level.R_U_Name[lpselfnum] = self.name;
			level.R_U_State[lpselfnum] = "notready";
			player.R_U_Looping = 0;
		}
			
		if (player.R_U_Looping == 0)
		{
			player thread maps\mp\gametypes\_pam_readyup::readyup(lpselfnum);
			return;
		}

		//Player is looping, now see if he is ready
		if (level.R_U_State[lpselfnum] == "notready")
			checkready = false;
	}

	// See if we checkready is still true
	if (checkready == true)
		level.playersready = true;
}


ClanBase_Warning()
{
	mode = getcvar("pam_mode");
	switch (mode)
	{
	case "dlogics_matchmod":
	case "dlogics_nightmod":
	case "cb_rifles":
	case "cb_2v2":
		x = 1;
		break;

	default:
		x = 0;
		break;
	}
	if (x)
	{
		self iprintlnbold("^7Welcome to the d^4`^9logics^4. ^7warserver^4!");
		self iprintlnbold("^7d^4`^9logics^4. ^7PAM by inflexZ^4!");
		wait 2.8;
		self iprintlnbold("^7No hacking ^4~ ^7glitching ^4~ ^7tweaking^4!");
		self iprintlnbold("^7Good luck and have fun^4!");
		wait 3.8;
	}
}

ClanBase_Warning2()
{
	mode = getcvar("pam_mode");
	switch (mode)
	{
	case "dlogics_matchmod":
	case "dlogics_nightmod":
	case "cb_rifles":
	case "cb_2v2":
		x = 1;
		break;

	default:
		x = 0;
		break;
	}
	if (x)
	{
		self iprintlnbold("^7d^4`^9logics^4. ^7PAM by inflexZ^4!");
		self iprintlnbold("^7Hit the ^9USE ^7key to begin the second half^4!");
		wait 3.8;
	}
}



