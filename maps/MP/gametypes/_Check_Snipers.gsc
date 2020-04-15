CheckSnipersScript()
{
	//check weapon limits
	sniperlimit = getcvarint("sv_SniperLimit");
	if (sniperlimit < 1 || sniperlimit == 99)
		sniperlimit = 99;
	else 
		limitsnipers = true;

	alliedSniperLimit = sniperlimit;
	axisSniperLimit = sniperlimit;
	ialliedSniperCount = 0;
	iaxisSniperCount = 0;

	smglimit = getcvarint("sv_SMGLimit");
	if (smglimit < 1 || smglimit == 99)
		smglimit = 99;
	else
		limitsmgs = true;
	alliedSMGLimit = smglimit;
	axisSMGLimit = smglimit;
	ialliedSMGCount = 0;
	iaxisSMGCount = 0;

	mglimit = getcvarint("sv_MGLimit");
	if (mglimit < 1 || mglimit == 99)
		mglimit = 99;
	else
		limitmgs = true;
	alliedMGLimit = mglimit;
	axisMGLimit = mglimit;
	ialliedMGCount = 0;
	iaxisMGCount = 0;

	inoWeaponCheck = 0;

	//get weapon counts
	lplayers = getentarray("player", "classname");
	for(i = 0; i < lplayers.size; i++)
	{
		lplayer = lplayers[i];
		take_away_weap = 0;

		weapon = lplayer getWeaponSlotWeapon("primary");

		if(!isdefined(weapon))
		{
			inoWeaponCheck = inoWeaponCheck + 1;
			setcvar("scr_noWeaponCheck", inoWeaponCheck);
		}
		else
		{
			switch (weapon)
			{
				case "springfield_mp":
				case "mosin_nagant_sniper_mp":
					if(lplayer.pers["team"] == "allies")
					{
						ialliedSniperCount = ialliedSniperCount + 1;
						if (ialliedSniperCount > alliedSniperLimit)
						{
							take_away_weap = 1;
							ialliedSniperCount--;
						}
					}
					break;

				case "thompson_mp":
				case "thompson_semi_mp":
				case "sten_mp":
				case "ppsh_mp":
				case "ppsh_semi_mp":
				case "sten_silenced_mp":
					if(lplayer.pers["team"] == "allies")
					{
						ialliedMGCount = ialliedMGCount + 1;
						if (ialliedSMGCount > alliedSMGLimit)
						{
							take_away_weap = 1;
							ialliedSMGCount--;
						}
					}
					break;
				
				case "bren_mp":
				case "bar_mp":
				case "bar_slow_mp":
					if(lplayer.pers["team"] == "allies")
					{
						ialliedMGCount = ialliedMGCount + 1;
						if (ialliedMGCount > alliedMGLimit)
						{
							take_away_weap = 1;
							ialliedMGCount--;
						}
					}
					break;
				
				case "kar98k_sniper_mp":
					if(lplayer.pers["team"] == "axis")
					{
						iaxisSniperCount = iaxisSniperCount + 1;
						if (iaxisSniperCount > axisSniperLimit)
						{
							take_away_weap = 1;
							iaxisSniperCount--;
						}
					}
					break;
				
				case "mp40_mp":
					if(lplayer.pers["team"] == "axis")
					{
						iaxisSMGCount = iaxisSMGCount + 1;
						if (iaxisSMGCount > axisSMGLimit)
						{
							take_away_weap = 1;
							iaxisSMGCount--;
						}
					}
					break;
				
				case "mp44_mp":
				case "mp44_semi_mp":
					if(lplayer.pers["team"] == "axis")
					{
						iaxisMGCount = iaxisMGCount + 1;
						if (iaxisMGCount > axisMGLimit)
						{
							take_away_weap = 1;
							iaxisMGCount--;
						}
					}
					break;
				
				default:
					inoWeaponCheck = inoWeaponCheck + 1;
					setcvar("scr_noWeaponCheck", inoWeaponCheck);
					break;	
			}


			// Take Away the Weapon if Needed
			if (take_away_weap)
			{
				lplayer.pers["weapon"] = undefined;
				lplayer.pers["weapon1"] = undefined;
				lplayer.pers["weapon2"] = undefined;
				lplayer.pers["spawnweapon"] = undefined;

				if(lplayer.pers["team"] == "allies")
				{
					lplayer setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
					lplayer openMenu(game["menu_weapon_allies"]);
				}
				else if (lplayer.pers["team"] == "axis")
				{
					lplayer setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
					lplayer openMenu(game["menu_weapon_axis"]);
				}
			}
		}
	}

	//Limit Snipers
	if (isdefined(limitsnipers))
	{
		if(ialliedSniperCount < alliedSniperLimit)
		{ 
			//turn on sniper weapon select
			setcvar("scr_allow_springfield", "1");
			setcvar("scr_allow_nagantsniper", "1");
		}
		else
		{
			//turn off sniper weapon select
			setcvar("scr_allow_springfield", "0");
			setcvar("scr_allow_nagantsniper", "0");	
		}

		if(iaxisSniperCount < axisSniperLimit)
		{ 
			//turn on sniper weapon select
			setcvar("scr_allow_kar98ksniper", "1");
		}
		else
		{
			//turn off sniper weapon select
			setcvar("scr_allow_kar98ksniper", "0");	
		}
	}

	//Limit SMGs
	if (isdefined(limitsmgs))
	{
		if(ialliedSMGCount < alliedSMGLimit)
		{ 
			//turn on SMG weapon select
			setcvar("scr_allow_thompson", "1");
			setcvar("scr_allow_sten", "1");
			setcvar("scr_allow_ppsh", "1");
		}
		else
		{
			//turn off SMG weapon select
			setcvar("scr_allow_thompson", "0");
			setcvar("scr_allow_sten", "0");
			setcvar("scr_allow_ppsh", "0");	
		}

		if(iaxisSMGCount < axisSMGLimit)
		{ 
			//turn on SMG weapon select
			setcvar("scr_allow_MP40", "1");
		}
		else
		{
			//turn off SMG weapon select
			setcvar("scr_allow_MP40", "0");	
		}
	}

	// Limit MGs
	if (isdefined(limitmgs))
	{
		if(ialliedMGCount < alliedMGLimit)
		{ 
			//turn on MG weapon select
			setcvar("scr_allow_bren", "1");
			setcvar("scr_allow_bar", "1");
		}
		else
		{
			//turn off MG weapon select
			setcvar("scr_allow_bren", "0");
			setcvar("scr_allow_bar", "0");
		}

		if(iaxisMGCount < axisMGLimit)
		{ 
			//turn on MG weapon select
			setcvar("scr_allow_MP44", "1");
		}
		else
		{
			//turn off MG weapon select
			setcvar("scr_allow_MP44", "0");
		}
	}
}

NoDropWeapon()
{
	if (getcvar("sv_noDropSniper") == "")
		setcvar("sv_noDropSniper", "0");
	noDropSniper = getcvarint("sv_noDropSniper");

	if (isdefined(self.pers["weapon"]) )
	{
		switch (self.pers["weapon"])
		{
			case "springfield_mp":
			case "kar98k_sniper_mp":
			case "mosin_nagant_sniper_mp":
				if (noDropSniper)
					return;
				break;
		}
		
		self dropItem(self getcurrentweapon());
	}
}