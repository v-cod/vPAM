// This File has various PAM ulitities

//The below lines should be updated each new release:
Get_Stock_PK3()
{
	// List all Allowed PK3 file names HERE separated by a space.  DO NOT include '.pk3'
	level.stockPK3 = "pakb paka pak9 pak8 pak6 pak5 pak4 pak3 pak2 pak1 pak0 z_svr_pam_dlogics wawa_3dAim";
}

// Compares Known PAM Modes to catch mistakes, needs to be updated if new pam modes are included
Check_PAM_Modes(pammode)
{
	gametype = getcvar("g_gametype");

	if (gametype == "sd")
	{
		switch (pammode)
		{
		case "wrs":
		case "dlogics_matchmod":
		case "dlogics_nightmod":
		case "cb_rifles":
		case "cb_2v2":
		case "pub":
			return 1;

		default:
			return 0;
		}
	}

	iprintln("^1Gametype ^3" + gametype + " ^1 not supported by PAM");
	return 0;
}


// **********************************************************************
// Should not need to change anything below here!
// **********************************************************************

//Searches for unknown PK3 files for use with all gametype competition modes
NonstockPK3Check()
{
	Get_Stock_PK3();

	level.serverPK3 = [];
	level.serverPK3 = getCvar("sv_pakNames");
	
	foundCount = 0;
	level.PK3check = [];
	level.PK3check[0] = "none";

	foundPK3 = splitArray(level.serverPK3, " ", "", true);
	for (i=0; i < foundPK3.size ; i++)
	{
		found = findStr(foundPK3[i], level.stockPK3, "anywhere");
		if (found != -1)
			continue;
		else
		{
			foundCount++;
			level.PK3check[foundCount] = foundPK3[i];
		}
	}
}


CheckPK3files()
{
	level.serverPK3 = [];
	level.serverPK3 = getCvar("sv_pakNames");
	self iprintln("^2Server PK3 Files:");
	self iprintln("^2" + level.serverPK3);

	// Print Unknown PK3 Files
	if (level.PK3check.size > 1)
	{
		self iprintln("^1Unknown PK3 files:");
		for (index = 1;index < level.PK3check.size; index++ )
		{
			self iprintln("^1" + level.PK3check[index]);
			wait .05;
		}
	}
	self iprintln("^8.");
	self iprintln("^8.");
	self iprintln("^8.");
	self iprintln("^8.");
	self iprintln("^2Server PK3 Files in console");
	if (level.PK3check.size > 1)
	{
			self iprintln("^1Warning: Unknown PK3 Files listed in console");
	}
}

Prevent_Map_Change()
{
	mapname = getcvar("mapname");
	setcvar("sv_mapRotationCurrent" , mapname);
}

PAMRestartMap()
{
	Prevent_Map_Change();

	pammode = getcvar("pam_mode");
	iprintlnbold("^7PAM mode changed to ^9" + pammode);
	iprintlnbold("^7Please wait^4.");

	wait 3;
	exitLevel(false);

}

CheckValidTeam(temp_team)
{
	switch (temp_team)
	{
		case "american":
		case "british":
		case "russian":
		case "":
			return true;

		default:
			return false;
	}
}

StartPAMUO(reason)
{
	mapname = getcvar("mapname");
	mapname = "map " + mapname;
	if (mapname == "map mp_carentan")
		mapname = "map mp_dawnville";
	else
		mapname = "map mp_carentan";

	setcvar("sv_maprotationcurrent", mapname);

	if (reason == "enable")
	{
		iprintlnbold("^7PAM enabled^4!");
		iprintlnbold("^7Please wait^4.");
		wait 3;
	}
	else if (reason == "modechange")
	{
		pammode = getcvar("pam_mode");
		iprintlnbold("^7PAM mode Changed to ^9" + pammode);
		iprintlnbold("^7Please wait^4.");
		wait 5;
	}
	else if (reason == "cvar")
	{
		iprintlnbold("^7PAM has detected a CVAR change that");
		iprintlnbold("^9REQUIRES ^7the map to change");
		iprintlnbold("^7Please wait^4.");
		wait 5;
	}

	exitLevel(false);
}

StopPAMUO()
{
	mapname = getcvar("mapname");
	mapname = "map " + mapname;
	if (mapname == "map mp_carentan")
		mapname = "map mp_dawnville";
	else
		mapname = "map mp_carentan";

	setcvar("sv_maprotationcurrent", mapname);

	iprintlnbold("^7PAM Disabled^4!");
	iprintlnbold("^7Please wait^4.");
	wait 3;

	exitLevel(false);
}


Team_Override(temp_allies)
{
	// Prevent new randomizations if we are not on the SAME map & gametype
	if( getcvar("mapname") == getcvar("pam_oldmap") && getcvar("g_gametype") == getcvar("pam_oldgt") )
	{
		game["allies"] = getcvar("pam_oldallies");
		game[game["allies"] + "_soldiertype"] 	= getcvar("pam_oldsoldiertype");
		game[game["allies"] + "_soldiervariation"]= getcvar("pam_oldsoldiervariation");
		
		return;
	}

	wintermap = false;
	if(isdefined(game["german_soldiervariation"]) && game["german_soldiervariation"] == "winter")
		wintermap = true;

	switch (temp_allies)
	{
		case "american":
			game["allies"] = "american";
			game["american_soldiertype"] = "airborne";
			if (wintermap)
				game["american_soldiervariation"] = "winter";
			else
				game["american_soldiervariation"] = "normal";
		break;

		
		case "british":
			game["allies"] = "british";
			if(wintermap)
			{
				game["british_soldiertype"] = "commando";
				game["british_soldiervariation"] = "winter";
			}
			else
			{
				switch(randomInt(2))
				{
					case 0:
						game["british_soldiertype"] = "airborne";
						game["british_soldiervariation"] = "normal";
						break;

					default:
						game["british_soldiertype"] = "commando";
						game["british_soldiervariation"] = "normal";
						break;
				}
			}
		break;


		case "russian":
			game["allies"] = "russian";
			if(wintermap)
			{
				switch(randomInt(2))
				{
					case 0:
						game["russian_soldiertype"] = "conscript";
						game["russian_soldiervariation"] = "winter";
						break;

					default:
						game["russian_soldiertype"] = "veteran";
						game["russian_soldiervariation"] = "winter";
						break;
				}
			}
			else
			{
				switch(randomInt(2))
				{
					case 0:
						game["russian_soldiertype"] = "conscript";
						game["russian_soldiervariation"] = "normal";
						break;


					default:
						game["russian_soldiertype"] = "veteran";
						game["russian_soldiervariation"] = "normal";
						break;

				}
			}
		break;

		default:
			break;
	}
}


// CODE BELOW ORIGINALLY FROM CoDAM
splitArray( str, sep, quote, skipEmpty )
{
	if ( !isdefined( str ) || ( str == "" ) )
		return ( [] );

	if ( !isdefined( sep ) || ( sep == "" ) )
		sep = ";";	// Default separator

	if ( !isdefined( quote ) )
		quote = "";

	skipEmpty = isdefined( skipEmpty );

	a = _splitRecur( 0, str, sep, quote, skipEmpty );

	return ( a );
}

_splitRecur( iter, str, sep, quote, skipEmpty )
{
	s = sep[ iter ];

	_a = [];
	_s = "";
	doQuote = false;
	for ( i = 0; i < str.size; i++ )
	{
		ch = str[ i ];
		if ( ch == quote )
		{
			doQuote = !doQuote;

			if ( iter + 1 < sep.size )
				_s += ch;
		}
		else
		if ( ( ch == s ) && !doQuote )
		{
			if ( ( _s != "" ) || !skipEmpty )
			{
				_l = _a.size;

				if ( iter + 1 < sep.size )
				{
					_x = _splitRecur( iter + 1, _s,	sep, quote, skipEmpty );

					if ( ( _x.size > 0 ) || !skipEmpty )
					{
						_a[ _l ][ "str" ] = _s;
						_a[ _l ][ "fields" ] = _x;
					}
				}
				else
					_a[ _l ] = _s;
			}

			_s = "";
		}
		else
			_s += ch;
	}

	if ( _s != "" )
	{
		_l = _a.size;

		if ( iter + 1 < sep.size )
		{
			_x = _splitRecur( iter + 1, _s, sep, quote, skipEmpty );
			if ( _x.size > 0 )
			{
				_a[ _l ][ "str" ] = _s;
				_a[ _l ][ "fields" ] = _x;
			}
		}
		else
			_a[ _l ] = _s;
	}

	return ( _a );
}

findStr( find, str, pos )
{
	if ( !isdefined( find ) || ( find == "" ) || 
		 !isdefined( str ) || 
		 !isdefined( pos ) || 
		 ( find.size > str.size ) )
		return ( -1 );

	fsize = find.size;
	ssize = str.size;

	switch ( pos )
	{
	  case "start": place = 0 ; break;
	  case "end":	place = ssize - fsize; break;
	  default:	place = 0 ; break;
	}

	for ( i = place; i < ssize; i++ )
	{
		if ( i + fsize > ssize )
			break;			// Too late to compare

		// Compare now ...
		for ( j = 0; j < fsize; j++ )
			if ( str[ i + j ] != find[ j ] )
				break;		// No match

		if ( j >= fsize )
			return ( i );		// Found it!

		if ( pos == "start" )
			break;			// Didn't find at start
	}

	return ( -1 );
}

InitClock(clock, time)
{
	clock.x = 590; // 590;
	clock.y = 315; // 380;
	clock.alignX = "center";
	clock.alignY = "middle";
	clock.sort = 9999;
	clock setClock(time, 60, "hudStopwatch", 64, 64); // count down for 5 of 60 seconds, size is 64x64
}

watchPlayerFastShoot()
{
	self endon("spawned");

	while (self.sessionstate == "playing") {
		// Reference clip count.
		a1 = self getWeaponSlotClipAmmo("primary");
		b1 = self getWeaponSlotClipAmmo("primaryb");

		// Wait for clip ammo to change.
		do {
			wait 0.05;

			if (self.sessionstate != "playing") {
				return;
			}

			a2 = self getWeaponSlotClipAmmo("primary");
			b2 = self getWeaponSlotClipAmmo("primaryb");
		} while (a1 == a2 && b1 == b2);

		// Check for reload.
		if (a1 < a2 || b1 < b2) {
			continue;
		}

		a1 = a2;
		b1 = b2;

		wait level.afs_time;

		if (self.sessionstate != "playing") {
			return;
		}

		a2 = self getWeaponSlotClipAmmo("primary");
		b2 = self getWeaponSlotClipAmmo("primaryb");

		if (a2 < a1 || b2 < b1) {
			iPrintLn("^1Fastshoot^7: " + self.name);
		}
	}
}

watchPlayerAimRun()
{
	self endon("spawned");

	while (self.sessionstate == "playing") {
		// Reference clip count.
		a1 = self getWeaponSlotClipAmmo("primary");
		b1 = self getWeaponSlotClipAmmo("primaryb");

		// Wait for clip ammo to change.
		do {
			wait 0.05;

			if (self.sessionstate != "playing") {
				return;
			}

			a2 = self getWeaponSlotClipAmmo("primary");
			b2 = self getWeaponSlotClipAmmo("primaryb");
		} while (a1 == a2 && b1 == b2);

		// If neither clip count was increased, nothing was reloaded.
		if (a2 <= a1 && b2 <= b1) {
			continue;
		}

		// Rough time between clip change and end of reloading animation.
		wait 1;

		// Keep toggling weapon if aim run glitching.
		while (self attackButtonPressed()) {
			self disableWeapon();
			wait 0.05;
			self enableWeapon();
		}
	}
}
