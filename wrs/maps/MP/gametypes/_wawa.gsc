main()
{
	level._prefix = "^4|^3|^4|^3|^7 ";

	maps\mp\gametypes\_wrs_admin::init();

	level.wrs_hud_label_Left = &"^4E^3U^4R^3O ^2RIFLES";
	level.wrs_hud_label_Right = &"eurorifles.clanwebsite.com";

	thread _labels();

	thread maps\mp\gametypes\_wrs_admin::monitor();
}

_labels()
{
	level.wrs_hud_label_LeftHud = newHudElem();
	level.wrs_hud_label_LeftHud.x = 630;
	level.wrs_hud_label_LeftHud.y = 475;
	level.wrs_hud_label_LeftHud.alignX = "right";
	level.wrs_hud_label_LeftHud.alignY = "middle";
	level.wrs_hud_label_LeftHud.sort = -3;
	level.wrs_hud_label_LeftHud.alpha = 1;
	level.wrs_hud_label_LeftHud.fontScale = 0.7;
	level.wrs_hud_label_LeftHud.archived = false;
	level.wrs_hud_label_LeftHud setText(level.wrs_hud_label_Left);

	level.wrs_hud_label_RightHud = newHudElem();
	level.wrs_hud_label_RightHud.x = 3;
	level.wrs_hud_label_RightHud.alignX = "left";
	level.wrs_hud_label_RightHud.y = 475;
	level.wrs_hud_label_RightHud.alignY = "middle";
	level.wrs_hud_label_RightHud.sort = -3;
	level.wrs_hud_label_RightHud.alpha = 1;
	level.wrs_hud_label_RightHud.fontScale = 0.7;
	level.wrs_hud_label_RightHud.archived = false;
	level.wrs_hud_label_RightHud setText(level.wrs_hud_label_Right);
}

spawnProtectionEmblem(){
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
//	level endon("intermission");

	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
		return undefined;

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
