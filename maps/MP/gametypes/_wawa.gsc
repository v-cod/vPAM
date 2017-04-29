main(){
	level.wrs_print_prefix = "^4|^3|^4|^3|^7 ";

	maps\mp\gametypes\_wrs_admin::init();

	level.wrs_PrintPrefix = "";

	level.wrs_LabelLeft  = &"^4E^3U^4R^3O ^2RIFLES";
	level.wrs_LabelRight = &"eurorifles.clanwebsite.com";

	thread wrs_Labels();
	thread wrs_ServerMessages();

	if(getCvar("w_fs_check") == ""			)
		setCvar	("w_fs_check",1			);
	level.fs_check	= getCvarInt("w_fs_check"	);

	thread maps\mp\gametypes\_wrs_admin::monitor();
}

wrs_Labels(){
	level.wrs_LabelLeftHud = newHudElem();
	level.wrs_LabelLeftHud.x = 630;
	level.wrs_LabelLeftHud.y = 475;
	level.wrs_LabelLeftHud.alignX = "right";
	level.wrs_LabelLeftHud.alignY = "middle";
	level.wrs_LabelLeftHud.sort = -3;
	level.wrs_LabelLeftHud.alpha = 1;
	level.wrs_LabelLeftHud.fontScale = 0.7;
	level.wrs_LabelLeftHud.archived = false;
	level.wrs_LabelLeftHud setText(level.wrs_LabelLeft);

	level.wrs_LabelRightHud = newHudElem();
	level.wrs_LabelRightHud.x = 3;
	level.wrs_LabelRightHud.alignX = "left";
	level.wrs_LabelRightHud.y = 475;
	level.wrs_LabelRightHud.alignY = "middle";
	level.wrs_LabelRightHud.sort = -3;
	level.wrs_LabelRightHud.alpha = 1;
	level.wrs_LabelRightHud.fontScale = 0.7;
	level.wrs_LabelRightHud.archived = false;
	level.wrs_LabelRightHud setText(level.wrs_LabelRight);
}
wrs_ServerMessages(){
	while(true){
		for(j = 0;j < 8;j++){
			for(i = 1;i < 10;i++){
				if(getCvar("scr_wrs_msg_" + i) != ""){
					iPrintLn(level.wrs_PrintPrefix + getCvar("scr_wrs_msg_" + i));
					wait 30.0 - .05;
				}
				wait .05;
			}
		}
	}
}

wrs_Welcome(){
	if(!isDefined(self.welcomed))
		self.welcomed = false;

	if(self.welcomed == false){
		self iPrintLnBold("Stick to the rules, soldier " + self.name);
		self iPrintLnBold("Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7eu");

		self.welcomed = true;
	}
}

wrs_Messages(){
	while(1){
		while(!getCvarInt("w_WalrusMessageWait"))
			wait 5;

		for(i = 0; i < 6; i++){
			message = getCvar("w_WalrusMessage"+i);

			if(message != ""){
				iPrintLn(message);
				wait getCvarInt("w_WalrusMessageWait");
			}
		}
	}
}


wrs_AFS(){
	while(self.sessionstate == "playing"){
		oldA = self getWeaponSlotClipAmmo("primary");	//Get the clipammo
		oldB = self getWeaponSlotClipAmmo("primaryb");

		newA = oldA;									//Put it in variable to compare later
		newB = oldB;

		while(self.sessionstate == "playing" && oldA == newA && oldB == newB){	//While he's playing and while bullets didn't change
			newA = self getWeaponSlotClipAmmo("primary");
			newB = self getWeaponSlotClipAmmo("primaryb");
			wait .05;
		}
		if(oldA < newA || oldB < newB)	//Probably reloaded
			continue;

		if(oldA != newA)a = 1;
		else 			a = 0;

		if(a) old = self getWeaponSlotClipAmmo("primary");
		else  old = self getWeaponSlotClipAmmo("primaryb");

		for(i = 0;i < 24;i++){
			if(self.sessionstate != "playing")
				return;
			wait .05;
		}

		if(a) new = self getWeaponSlotClipAmmo("primary");
		else  new = self getWeaponSlotClipAmmo("primaryb");

		if(self.sessionstate == "playing" && old > new){
			if(!isDefined(self.pers["afs"]))
				self.pers["afs"] = 0;
			self.pers["afs"]++;
			logPrint("WRS;FASTSHOOT;" + self.name + ";" + self getGuid() + ";\n");
			if(level.wrs_AFS > 0)
				iPrintLn(level.wrs_PrintPrefix + self.name + " ^1shot ^7too ^1fast^7("+self.pers["afs"]+")!");
			if(level.wrs_AFS > 1){
				if(self.pers["afs"] < 4)
					self iPrintLn(level.wrs_PrintPrefix + "^1Fastshoot Warning: " + self.pers["afs"]);
				else if(self.pers["afs"] < 7){
					self iPrintLn(level.wrs_PrintPrefix + "^1Fastshoot Warning: " + self.pers["afs"] + " ^7|^1Score Decreased!");
					self.score--;
				}
				else{
					self iPrintLn(level.wrs_PrintPrefix + "^1Fastshoot Warning: ^1" + self.pers["afs"] + " ^7|^1Score Decreased & Suicide!");
					self.score--;
					self suicide();
				}
			}
		}
	}
}

showhit(){
	self notify("wawa_showhit");
	self endon("wawa_showhit");
	self endon("spawned");

	if(isDefined(self.wawa_hitblip))
		self.wawa_hitblip destroy();

	self.wawa_hitblip = newClientHudElem(self);
	self.wawa_hitblip.alignX = "center";
	self.wawa_hitblip.alignY = "middle";
	self.wawa_hitblip.x = 320;
	self.wawa_hitblip.y = 240;
	self.wawa_hitblip.alpha = .5;
	self.wawa_hitblip setShader("gfx/hud/hud@fire_ready.tga", 32, 32);
	self.wawa_hitblip scaleOverTime(.15, 64, 64);

	wait .15;

	if(isDefined(self.wawa_hitblip))
		self.wawa_hitblip destroy();
}

spawnProtectionEmblem(){
	thread wrs_AFS();

	self notify("wawa_showhit");
	self endon("wawa_showhit");
	self endon("spawned");

	if(isDefined(self.wawa_protemb))
		self.wawa_protemb destroy();

	self.wawa_protemb = newClientHudElem(self);
	self.wawa_protemb.alignX = "center";
	self.wawa_protemb.alignY = "middle";
	self.wawa_protemb.x = 320;
	self.wawa_protemb.y = 240;
	self.wawa_protemb.alpha = .5;
	self.wawa_protemb setShader("gfx/hud/hud@health_cross.tga", 32, 32);
	self.wawa_protemb scaleOverTime(.15, 64, 64);

	wait .15;

	if(isDefined(self.wawa_protemb))
		self.wawa_protemb destroy();
}

spawnProtectionNotify(){
	if(isDefined(self.protnot))
		self.protnot destroy();

	self.protnot = newClientHudElem(self);
	self.protnot.x = 520;
	self.protnot.y = 410;
	self.protnot.alpha = 0.65;
	self.protnot.alignX = "center";
	self.protnot.alignY = "middle";
	self.protnot setShader("gfx/hud/hud@health_cross.tga",40,40);

	wait level.spawnprotection;

	if(isDefined(self.protnot))
		self.protnot destroy();
}

getSpawnPointWawa(spawnpoints){
	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints)){
		iprintlnbold("spawnpoints undefined, lol");
		return undefined;
	}

	if (isDefined(self.opponent))
		opponent = self.opponent;

	// Spawn away from players if they exist, otherwise spawn at a random spawnpoint
	if(isdefined(opponent)){
		//iprintlnbold("opponent defined, lol");
//		println("====================================");

		j = 0;
		for(i = 0; i < spawnpoints.size; i++){
			// Throw out bad spots
			if(positionWouldTelefrag(spawnpoints[i].origin)){
//				println("Throwing out WouldTelefrag ", spawnpoints[i].origin);
				continue;
			}

			if(isdefined(self.lastspawnpoint) && self.lastspawnpoint == spawnpoints[i]){
//				println("Throwing out last spawnpoint ", spawnpoints[i].origin);
//				println("self.lastspawnpoint.origin: ", self.lastspawnpoint.origin);
				continue;
			}

			filteredspawnpoints[j] = spawnpoints[i];
			j++;
		}

		// if no good spawnpoint, need to failsafe
		if (!isdefined(filteredspawnpoints))
			return maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		for(i = 0; i < filteredspawnpoints.size; i++){
			shortest = 1000000;
			//for(j = 0; j < aliveplayers.size; j++)
			//{
				current = distanceSquared(filteredspawnpoints[i].origin, opponent.origin);
//				println("Current distance ", current);

				if (current < shortest){
//					println("^4Old shortest: ", shortest, " ^4New shortest: ", current);
					shortest = current;
				}
			//}

			filteredspawnpoints[i].spawnscore = shortest + 1;
//			println("^2Spawnscore: ", filteredspawnpoints[i].spawnscore);
		}

		// TODO: Throw out spawnpoints with negative scores

		newsize = filteredspawnpoints.size / 3;
		if(newsize < 1)
			newsize = 1;

		total = 0;
		bestscore = 0;

		// Find the top 3rd
		for(i = 0; i < newsize; i++){
			for(j = 0; j < filteredspawnpoints.size; j++){
				current = filteredspawnpoints[j].spawnscore;
//				println("Current distance ", current);

				if (current > bestscore)
					bestscore = current;
			}

			for(j = 0; j < filteredspawnpoints.size; j++){
				if(filteredspawnpoints[j].spawnscore == bestscore){
//					println("^3Adding to newarray: ", bestscore);
					newarray[i]["spawnpoint"] = filteredspawnpoints[j];
					newarray[i]["spawnscore"] = filteredspawnpoints[j].spawnscore;
					filteredspawnpoints[j].spawnscore = 0;
					bestscore = 0;

//					println("^6Old total: ", total, "^6 New total: ", (total + newarray[i]["spawnscore"]), "^6 Added: ", newarray[i]["spawnscore"]);
					total = total + newarray[i]["spawnscore"];

					break;
				}
			}
		}

		randnum = randomInt(total);
//		println("^3Random Number: ", randnum, " ^3Between 0 and ", total);

		for(i = 0; i < newarray.size; i++){
			randnum = randnum - newarray[i]["spawnscore"];
			spawnpoint = newarray[i]["spawnpoint"];

//			println("^2Subtracted: ", newarray[i]["spawnscore"], "^2 Left: ", randnum);

			if(randnum < 0)
				break;
		}

		self.lastspawnpoint = spawnpoint;
		return spawnpoint;
	}
	else{
		//iprintlnbold("opponent undefined");
		return maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	}
}
