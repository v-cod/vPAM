wrs_Initialize(){
	level.wrs_effect["burning"]	= loadfx("fx/fire/tinybon.efx");
	level.wrs_effect["generic"]	= loadfx("fx/impacts/dirthit_mortar.efx");

	character\mp_german_kriegsmarine01::precache();

	level.wrs_Model[0][0] = "xmodel/Toilet";					level.wrs_Model[0][1] = "a Toilet";
	level.wrs_Model[1][0] = "xmodel/cow_standing";				level.wrs_Model[1][1] = "a Cow";
	level.wrs_Model[2][0] = "xmodel/armorsuit";					level.wrs_Model[2][1] = "a Knight";
	level.wrs_Model[3][0] = "xmodel/plainrefrigerator";			level.wrs_Model[3][1] = "a Refrigerator";
	level.wrs_Model[4][0] = "xmodel/chair_office";				level.wrs_Model[4][1] = "a Chair";
	level.wrs_Model[5][0] = "xmodel/PlainChair";				level.wrs_Model[5][1] = "a Chair";
	level.wrs_Model[6][0] = "xmodel/LargeHeavyTreeA";			level.wrs_Model[6][1] = "a Large Tree";
	level.wrs_Model[7][0] = "xmodel/stalin_statue";				level.wrs_Model[7][1] = "a Statue";
	level.wrs_Model[8][0] = "xmodel/barrel_black1";				level.wrs_Model[8][1] = "a Barrel";
	level.wrs_Model[9][0] = "xmodel/Tub";						level.wrs_Model[9][1] = "a Bath Tub";
	level.wrs_Model[10][0] = "xmodel/Couch";					level.wrs_Model[10][1] = "a Couch";
	level.wrs_Model[11][0] = "xmodel/desk_rolltop";				level.wrs_Model[11][1] = "a Desk";
	level.wrs_Model[12][0] = "xmodel/haystack";					level.wrs_Model[12][1] = "a Haystack";
	level.wrs_Model[13][0] = "xmodel/Airborne";					level.wrs_Model[13][1] = "a Weird guy";
	level.wrs_Model[14][0] = "xmodel/armoir";					level.wrs_Model[14][1] = "a Closet";
	level.wrs_Model[15][0] = "xmodel/artillery_flakvierling";	level.wrs_Model[15][1] = "Artillery";
	level.wrs_Model[16][0] = "xmodel/bed_bunk";					level.wrs_Model[16][1] = "a bunk";
	level.wrs_Model[17][0] = "xmodel/CanopyBed";				level.wrs_Model[17][1] = "a Canopy Bed";
	level.wrs_Model[18][0] = "xmodel/chinacabinet";				level.wrs_Model[18][1] = "a Cabinet";
	level.wrs_Model[19][0] = "xmodel/crate_misc1a";				level.wrs_Model[19][1] = "a Crate";
	level.wrs_Model[20][0] = "xmodel/crypt1";					level.wrs_Model[20][1] = "a Crypt";
	level.wrs_Model[21][0] = "xmodel/fallschirmjager_officer";	level.wrs_Model[21][1] = "a Weird Guy";
	level.wrs_Model[22][0] = "xmodel/FullSpikeyShrub";			level.wrs_Model[22][1] = "a Bush";
	level.wrs_Model[23][0] = "xmodel/kriegsmarine_nco";			level.wrs_Model[23][1] = "a NCO";
	level.wrs_Model[24][0] = "xmodel/kriegsmarine_soldier";		level.wrs_Model[24][1] = "a Soldier";
	level.wrs_Model[25][0] = "xmodel/LargeCandleabre";			level.wrs_Model[25][1] = "a Large Candle";
	level.wrs_Model[26][0] = "xmodel/light_streetlight2on";		level.wrs_Model[26][1] = "a Streetlight";
	level.wrs_Model[27][0] = "xmodel/LongDiningTable";			level.wrs_Model[27][1] = "a Table";
	level.wrs_Model[28][0] = "xmodel/playerbody_default";		level.wrs_Model[28][1] = "a White guy";
	level.wrs_Model[29][0] = "xmodel/ship_capstan";				level.wrs_Model[29][1] = "a Capstan";
	level.wrs_Model[30][0] = "xmodel/staffcar";					level.wrs_Model[30][1] = "a Car";
	level.wrs_Model[31][0] = "xmodel/tombstone3";				level.wrs_Model[31][1] = "a Tombstone";
	level.wrs_Model[32][0] = "xmodel/VaseFlowers";				level.wrs_Model[32][1] = "Vaseflowers";

	level.wrs_Warn = &"LISTEN TO THE ADMIN";

	if(!isDefined(game["gamestarted"])){
		for(i = 0;i < level.wrs_Model.size;i++)
			precacheModel(level.wrs_Model[i][0]);

		precacheString(level.wrs_Warn);
	}

	setCvar("w_print",	"");
	setCvar("w_println","");
	setCvar("w_clientcvar","");
	setCvar("w_cvar",	"");
	setCvar("w_nades",	"");
	setCvar("w_sj", 	"");
	setCvar("w_bunny", 	"");
	setCvar("w_annoy",	"");
	setCvar("w_model",	"");
	setCvar("w_cow",	"");
	setCvar("w_toilet",	"");
	setCvar("w_lift",	"");
	setCvar("w_disarm",	"");
	setCvar("w_disable","");
	setCvar("w_mortar",	"");
	setCvar("w_burn",	"");
	setCvar("w_throw",	"");
	setCvar("w_smite",	"");
	setCvar("w_kill",	"");
	setCvar("w_state",	"");
	setCvar("w_hide",	"");
	setCvar("w_mark",	"");
	setCvar("w_say",	"");
	setCvar("w_test",	"");
	setCvar("w_jumper",	"");
	setCvar("w_warn",	"");
	setCvar("w_spall",	"");
	setCvar("w_add",	"");

	level.wrs_Commands = 1;

	wrs_AdminFunctions();
}

wrs_AdminFunctions(){
	while(1){
		while(level.wrs_Commands){
			level.wrs_Players = getEntArray("player", "classname");

			print		= getCvar("w_print"		); if(print == "") print = getCvar("saybold");
			println		= getCvar("w_println"	);
			ccvar 		= getCvar("w_clientcvar");
			globalcvar	= getCvar("w_cvar"		);
			nades		= getCvar("w_nades"		);
			sj			= getCvar("w_sj"		);
			bunny		= getCvar("w_bunny"		);
			annoy		= getCvar("w_annoy"		);
			model		= xpldeArray(getCvar("w_model"), 1, " ");
			toilet		= getCvar("w_toilet"		);
			cow			= getCvar("w_cow"		);
			lift		= getCvar("w_lift"		);
			disarm		= getCvar("w_disarm"	);
			disable		= getCvar("w_disable"	);
			mortar		= getCvar("w_mortar"	);
			burn		= getCvar("w_burn"		);
			throw		= xpldeArray(getCvar("w_throw"), 1, " ");
			smite		= getCvar("w_smite"		);
			kill		= getCvar("w_kill"		);
			state		= getCvar("w_state"		); if(state == "") state = getCvar("tospec");
			hide		= getCvar("w_hide"		);
			mark		= getCvar("w_mark"		);
			say			= xpldeArray(getCvar("w_say"), 1, " ");
			test		= getCvar("w_test"		);
			jumper		= getCvar("w_jumper"	);
			warn		= xpldeArray(getCvar("w_warn"), 1, " ");
			spall		= getCvar("w_spall"		);
			add			= xpldeArray(getCvar("w_add"), 1, " ");

			if(add[0] != "" && !isDefined(add[1]))
				add[1] = 10;
			if(throw[0] != "" && !isDefined(throw[1]))
				throw[1] = 250;
			else if(say[0] != "" && !isDefined(say[1]))
				say[1] = "";
			else if(warn[0] != "" && !isDefined(warn[1]))
				warn[1] = "^1THIS IS A ONE TIME WARNING";
			else if(model[0] != "" && (!isDefined(model[1]) || model[1] == "" || ((int)model[1] < 0 || (int)model[1] >= level.wrs_Model.size)))
				model[1] = 0;
			else if(burn	== "all" || burn == -1){
				logPrint("WRS;BURN;" + burn + "\n");
				setCvar("w_burn", "");

				player thread wrs_Burn(burn);
				continue;
			}
			else if(print != ""){
				iPrintLnBold(level.wrs_PrintPrefix + print);
				setCvar("w_print", "");
				setCvar("saybold", "");
			}
			else if(println != ""){
				iPrintLn(level.wrs_PrintPrefix + println);
				setCvar("w_println", "");
			}

			else if(ccvar != ""){
				clientcvar = xpldeArray(ccvar, 2, " ");
				if (!isDefined(clientcvar[2]))
					ccvar = "";

				setCvar("w_clientcvar", "");
			}
			else if(globalcvar != ""){
				globalcvar = xpldeArray(globalcvar, 1, " ");
				if (isDefined(globalcvar[1]))
					setCvar(globalcvar[0], globalcvar[1]);
				setCvar("w_cvar", "");
			}
			for(i = 0; i < level.wrs_Players.size; i++){
				if(isPlayer(level.wrs_Players[i])){
					player	= level.wrs_Players[i];
					n	= player getEntityNumber();

					if(ccvar != "" && (clientcvar[0] == n || clientcvar[0] == -1)){
						if(clientcvar[1] == "speed")
							player.maxspeed	= clientcvar[2];
						if(clientcvar[1] == "health")
							player.health	= clientcvar[2];
						else
							player setClientCvar(clientcvar[1], clientcvar[2]);
		
						player iPrintLn(level.wrs_PrintPrefix + "Admin changed ^3"+ clientcvar[1] + " ^7to ^2" + clientcvar[2]);
						logPrint("WRS;CCVAR;" + player.pers["guid"] + ";" + player.name + ";" + clientcvar[1] + ";" + clientcvar[2] + "\n");
					}
					else if(nades	== n){
						logPrint("WRS;NADES;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_nades", "");

						player thread wrs_Nades();
					}
					else if(sj		== n){
						logPrint("WRS;SJ;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_sj", "");

						player thread wrs_SuperJump();
					}
					else if(bunny		== n){
						logPrint("WRS;BUNNY;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_bunny", "");

						player thread wrs_Bunny();
					}
					else if(annoy	== n){
						logPrint("WRS;ANNOY;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_annoy", "");

						player thread wrs_Annoy();
					}
					else if(model[0]		== n){
						logPrint("WRS;MODEL;" + player.pers["guid"] + ";" + player.name + ";" + model[1] + "\n");
						setCvar("w_model", "");

						player thread wrs_Model((int)model[1]);
					}
					else if(toilet		== n){
						logPrint("WRS;MODEL;" + player.pers["guid"] + ";" + player.name + ";0\n");
						setCvar("w_toilet", "");

						player thread wrs_Model(0);
					}
					else if(cow		== n){
						logPrint("WRS;MODEL;" + player.pers["guid"] + ";" + player.name + ";1\n");
						setCvar("w_cow", "");

						player thread wrs_Model(1);
					}
					else if(lift		== n){
						logPrint("WRS;LIFT;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_lift", "");

						player thread wrs_Lift(lift);
					}
					else if(disarm	== n){
						logPrint("WRS;DISARM;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_disarm", "");

						player thread wrs_Disarm();
					}
					else if(disable	== n){
						logPrint("WRS;DISABLE;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_disable", "");

						player thread wrs_Disable();
					}
					else if(mortar	== n){
						logPrint("WRS;MORTAR;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_mortar", "");

						player thread wrs_Mortar();
					}
					else if(burn		== n){
						logPrint("WRS;BURN;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_burn", "");

						player thread wrs_Burn(burn);
					}
					else if(throw[0]	== n){
						logPrint("WRS;THROW;" + player.pers["guid"] + ";" + player.name + ";" + throw[1] + "\n");
						setCvar("w_throw", "");

						player thread wrs_Throw(throw[1]);
					}
					else if(smite	== n){
						logPrint("WRS;SMITE;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_smite", "");

						player thread wrs_Smite();
					}
					else if(kill		== n){
						logPrint("WRS;KILL;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_kill", "");

						player thread wrs_Kill();
					}
					else if(state	== n){
						logPrint("WRS;STATE;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_state", "");
						setCvar("tospec", "");

						player thread wrs_State();
					}
					else if(hide		== n){
						logPrint("WRS;HIDE;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_hide", "");

						player thread wrs_Hide();
					}
					else if(mark		== n){
						logPrint("WRS;MARK;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_mark", "");

						player thread wrs_Mark();
					}
					else if(say[0]	== n){
						logPrint("WRS;SAY;" + player.pers["guid"] + ";" + player.name + ";" + say[1] + "\n");
						setCvar("w_say", "");

						player thread wrs_Say(say[1]);
					}
					else if(test		== n){
						logPrint("WRS;TEST;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_test", "");

						player thread wrs_Test();
					}
					else if(jumper		== n){
						logPrint("WRS;JUMPER;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_jumper", "");

						player thread wrs_Jumper();
					}
					else if(warn[0]		== n){
						logPrint("WRS;WARN;" + player.pers["guid"] + ";" + player.name + ";" + warn[1] + "\n");
						setCvar("w_warn", "");

						player thread wrs_Warn(warn[1]);
					}
					else if(spall		== n){
						logPrint("WRS;SPECTATEALL;" + player.pers["guid"] + ";" + player.name + "\n");
						setCvar("w_spall", "");

						player thread wrs_SpectateAll();
					}
					else if(add[0]		== n){
						logPrint("WRS;ADD;" + player.pers["guid"] + ";" + player.name + ";" + add[1] + "\n");
						setCvar("w_add", "");

						player thread wrs_Add(add[1]);
					}
				}
			}
			wait .15;
		}
		wait .15;
	}
}
wrs_Nades(){
	if(!isDefined(self.wrs_Nades)){
		self.wrs_Nades = 1;

		self iPrintLn(level.wrs_PrintPrefix + "Admin gave you nades!");
		if(self.sessionstate == "playing"){
			self takeWeapon("stielhandgranate_mp");
			self setWeaponSlotWeapon("grenade", "stielhandgranate_mp");
			self setWeaponSlotClipAmmo("grenade", 3);

			wait .05;
			self switchToWeapon(self getWeaponSlotWeapon("grenade"));
		}
		while(isDefined(self.wrs_Nades)){
			if(self.sessionstate == "playing"){
				self takeWeapon("stielhandgranate_mp");
				self setWeaponSlotWeapon("grenade", "stielhandgranate_mp");
				self setWeaponSlotClipAmmo("grenade", 3);

				wait .05;

				while(self.sessionstate == "playing" && isDefined(self.wrs_Nades)){
					self setWeaponSlotClipAmmo("grenade", 3);
					wait .05;
				}
			}

			wait .05;
		}
	}
	else{
		self.wrs_Nades = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "Admin took your nades!");

		if(self.sessionstate == "playing"){
			wait .1;
			self takeWeapon("stielhandgranate_mp");
			self switchToWeapon(self getWeaponSlotWeapon("primary"));
		}
	}
}

wrs_SuperJump(){
 	if(!isDefined(self.wrs_Sj)){
		self.wrs_Sj = true;
		self iPrintLn(level.wrs_PrintPrefix + "Admin gave you SuperJump!");
		self iPrintLnBold(level.wrs_PrintPrefix + "Be careful, other players might find SJ disturbing!");

		self thread wrs_SuperJump_Player();
   	}
    else{
		self.wrs_Sj = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "Admin took your SuperJump!");
	}
}
wrs_SuperJump_Player(){
	while(isDefined(self.wrs_Sj)){
		while(isDefined(self.wrs_Sj) && self.sessionstate == "playing"){
			while(isDefined(self.wrs_Sj) && self useButtonPressed() && self meleeButtonPressed()){
				self.maxspeed = 500;
				self.health += 1000;
				self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "panzerfaust_mp",  self.origin, (0, 0, 1), "none");
				wait .1;
			}
			self.maxspeed = 190;
			wait .05;
		}
		wait .1;
	}
}
wrs_SuperJump_Spec(client){

	if(self.sessionstate != "spectator")
		return;
	if(client < 0){
		self.wrs_SjSpec = undefined;
		return;
	}

	if(!isDefined(self.wrs_SjSpec)){
		self.wrs_SjSpec = client;

		level.wrs_Players = getEntArray("player", "classname");
		for(i = 0;i < level.wrs_Players.size;i++)
			if(level.wrs_Players[i] getEntityNumber() == client)
				client = level.wrs_Players[i];

		while(isDefined(self.wrs_SjSpec)){
			while(isDefined(self.wrs_SjSpec) && self.sessionstate == "spectator" && (client.sessionstate == "playing" || client.sessionstate == "dead")){
				while(isDefined(self.wrs_SjSpec) && (self useButtonPressed() || self meleeButtonPressed())){
					client.maxspeed = 500;
					client.health += 1000;
					client finishPlayerDamage(client, client, 1000, 0, "MOD_PROJECTILE", "panzerfaust_mp",  client.origin, (0, 0, 1), "none");
					wait .1;
				}
				client.maxspeed = 190;
				wait .05;
			}
		}
		self.wrs_SjSpec = undefined;
	}
	else{
		self.wrs_SjSpec = undefined;
	}
}

wrs_Bunny(){
	if(!isDefined(self.wrs_Bunny)){
		self.wrs_Bunny = true;
		self iPrintLn(level.wrs_PrintPrefix + "Admin gave you Bunny! Jump!");
		self thread wrs_Bunny_Player();
	}
	else{
		self.wrs_Bunny = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "Admin took your Bunny!");
	}
}
wrs_Bunny_Player(){
	while(isDefined(self.wrs_Bunny)){
		while(self.sessionstate == "playing" && isDefined(self.wrs_Bunny)){
			originBefore = self.origin;
			wait .05;
			originAfter = self.origin;
			if(!self isOnGround() && originBefore[2] < originAfter[2]){
				self.maxspeed = 380;
				self.health += 1000;

				x = (originAfter[0] - originBefore[0])/(float)10;
				y = (originAfter[1] - originBefore[1])/(float)10;

				self finishPlayerDamage(self, self, 1000, 0, "MOD_PROJECTILE", "panzerfaust_mp",  self.origin, (x, y, 2), "none");
			}
			while(isDefined(self.wrs_Bunny) && !self isOnGround())
				wait .05;

			self.maxspeed = 190;
		}
		wait .1;
	}
}

wrs_Annoy(){
	if(!isDefined(self.wrs_Annoy)){
		self.wrs_Annoy = true;
		self iPrintLn(level.wrs_PrintPrefix + "Admin annoys you!");
		for(i = 0;isDefined(self.wrs_Annoy) && (isDefined(self.sessionstate) || self.sessionstate == "playing");i++){
			if(i == 8)
				i = 0;

			self setPlayerAngles((self.angles[0], self.angles[1], i * 45));

			wait .25;
		}

		self setPlayerAngles((self.angles[0], self.angles[1], 0));
	}
	else{
		self.wrs_Annoy = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "Admin stopped annoying you!");
	}
}

wrs_Model(model){
	if(!isDefined(self.sessionstate) || self.sessionstate != "playing" || !isDefined(level.wrs_Model[model]))
		return;

	if(!isDefined(self.wrs_Model) || model != self.wrs_Model){
		self.wrs_Model = model;
		self.maxspeed = 300;
		self setClientCvar ("cg_thirdperson", 1);
		self disableWeapon();
		self detachAll();

		if(model != 1)
			self setModel(level.wrs_Model[model][0]);
		else{
			self setModel("");
			cowModel = spawn("script_model", self getOrigin());
			cowModel.angles = self.angles + (0, 270, 0);
			cowModel setModel(level.wrs_Model[model][0]);
			cowModel linkTo(self);
		}

		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7became ^3" + level.wrs_Model[model][1] + "^7!");

		while(isDefined(self.wrs_Model) && self.sessionstate == "playing"){
			if(isDefined(self.wrs_Model) && self.wrs_Model != model)
				return;
			wait .05;
		}


		if(model == 1){
			self unlink();
			cowModel delete();
		}

		self.wrs_Model = undefined;
		self.maxspeed = 190;
		self setClientCvar ("cg_thirdperson", 0);
		if(self.sessionstate == "playing"){
			self enableWeapon();
			self detachAll();
			self maps\mp\_utility::loadModel(self.pers["savedmodel"]);
		}

	}
	else{
		self.wrs_Model = undefined;
		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7 is normal again!");
	}
}

wrs_Lift(lift){
	if(isDefined(self.sessionstate) && self.sessionstate == "playing"){
		self thread wrs_Lift_player();
		iPrintLn(level.wrs_PrintPrefix + self.name + "^7 visits the ^3sky^7!");
	}
}

wrs_Lift_player(){
	self disableWeapon();

	lift		= spawn ("script_model",(0,0,0));
	lift.origin	= self.origin;
	lift.angles	= self.angles;

	self linkto(lift);
	lift moveTo(self.origin + (0, 0, 800 ), 1, .25, .5);

	wait 20;

	lift moveTo(self.origin + (0, 0, -730), .5, .2, .2);
	
	self unlink();
}

wrs_Disarm(){
	if(!isDefined(self.wrs_Disarm)){
		self.wrs_Disarm = 1;
		self thread wrs_Disarm_player();
		self iPrintLn(level.wrs_PrintPrefix + "You have been disarmed for 5 seconds!");
	}
	else{
		self.wrs_Disarm = undefined;
		self iPrintLn(level.wrs_PrintPrefix + "You can pickup weapons again!");
	}
}

wrs_Disarm_player(){
	if(self.sessionstate != "playing")
		return;

	grenade	= self getWeaponSlotWeapon("grenade");
	pistol	= self getWeaponSlotWeapon("pistol");
	primary	= self getWeaponSlotWeapon("primary");
	primaryb= self getWeaponSlotWeapon("primaryb");

	self dropItem(grenade);
	self dropItem(pistol);
	self dropItem(primary);
	self dropItem(primaryb);

	for(i = 25;i > 0 && isDefined(self.wrs_Disarm); i--){

		self dropItem(self getWeaponSlotWeapon("grenade"));
		self dropItem(self getWeaponSlotWeapon("pistol"));
		self dropItem(self getWeaponSlotWeapon("primary"));
		self dropItem(self getWeaponSlotWeapon("primaryb"));
		wait .2;
	}
	self.wrs_Disarm = undefined;
	self iPrintLn(level.wrs_PrintPrefix + "You can pickup weapons again!");
}

wrs_Disable(){
	if(!isDefined(self.wrs_Disable) && self.sessionstate == "playing")
		self wrs_Disable_player();
	else
		self.wrs_Disable = undefined;
}

wrs_Disable_player(){
	self.wrs_Disable = true;
	self iPrintLnBold(level.wrs_PrintPrefix + "Your weapons have been ^3disabled^7!");

	while(isDefined(self.wrs_Disable)){
		while(isDefined(self.wrs_Disable) && self.sessionstate == "playing"){
			self disableWeapon();
			wait .25;
		}
	}

	self enableWeapon();
	self.wrs_Disable = undefined;
	self iPrintLnBold(level.wrs_PrintPrefix + "Your weapons have been ^3enabled^7!");
}

wrs_Mortar(){
	if(self.sessionstate == "playing"){
		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7is targeted!");

		self thread wrs_Mortar_player();
	}
}

wrs_Mortar_player(){
	soundSource = spawn("script_model", self getOrigin());
	soundSource linkto(self);

	soundSource playsound("generic_undersuppression_foley");
	wait 2;
	self iPrintLnBold(level.wrs_PrintPrefix + "Incoming!");
	soundSource playsound("mortar_incoming");
	wait 1.5;

	while(self.sessionstate == "playing"){
		wait randomFloatRange(0, 1.3);	//Wait for a random time
		target = self.origin + (0,0,2);	//Set the position

		wait .4;						//Wait for it...

		playFx(level.wrs_effect["generic"], target);	//Play the explosion effect
		soundSource playsound("mortar_explosion");		//Play the explosion sound

		radiusDamage(target, 300, 200, 25);				//Apply random damage
		earthquake(0.3, 1.5, target, 400);				//Shake it up a little
	}
	soundSource delete();
}

wrs_Burn(burn){
	level.wrs_Players = getEntArray("player", "classname");
	if(burn == "all"){
		for(i = 0; i < level.wrs_Players.size; i++)
			if(!isDefined(level.wrs_Players[i].wrs_Burning)){
				level.wrs_Players[i].wrs_Burning = true;
				level.wrs_Players[i] thread wrs_Burn_player();
			}
		iPrintLn(level.wrs_PrintPrefix + "All players are burning!");
	}
		
	else if(burn == -1){
		for(i = 0; i < level.wrs_Players.size; i++)
			if(isDefined(level.wrs_Players[i].wrs_Burning))
				level.wrs_Players[i].wrs_Burning = undefined;
		iPrintLn(level.wrs_PrintPrefix + "All players stopped burning!");
	}
	else if(isPlayer(self) && self.sessionstate == "playing"){
		if(isDefined(self.wrs_Burning)){
			self.wrs_Burning = undefined;
			iPrintLn(level.wrs_PrintPrefix + self.name + " ^7stopped burning!");
		}
		else{
			self.wrs_Burning = true;
			self thread wrs_Burn_player();

			iPrintLn(level.wrs_PrintPrefix + self.name + " ^7is burning!");

		}
	}
}

wrs_Burn_player(){
	for(j = 0; self.sessionstate == "playing" && isDefined(self.wrs_Burning); j++){
		self.maxspeed = 250;
		if(j > 6){
			j = 0;

			self.health -= 4;
			if (self.health < 1)
				self suicide();
		}
		if(j == 3 || j == 6)
			playFx(level.wrs_effect["burning"], self.origin + (0, 0, 20));
		
		if(level.wrs_Burning_PassFire)
			level.wrs_Players = getEntArray("player", "classname");
			for (i = 0; i < level.wrs_Players.size; i++)
				if (isDefined(level.wrs_Players[i]) && self != level.wrs_Players[i] && level.wrs_Players[i].sessionstate == "playing" && !isDefined(level.wrs_Players[i].wrs_Burning) && distanceSquared(self.origin, level.wrs_Players[i].origin) < 4000){
					level.wrs_Players[i].wrs_Burning = true;
					level.wrs_Players[i] thread wrs_Burn_player();
				}

		wait .05;
	}
	self.maxspeed = 190;

	self.wrs_Burning = undefined;
}

wrs_Throw(height){
	if (self.sessionstate == "playing"){
		self iPrintLn(level.wrs_PrintPrefix + "The Admin threw you " + (int)height/100 + " metres into the air!");

		lift = spawn("script_model", self.origin);
		self linkTo(lift);
		lift moveZ(height, .5, .2, .2);
		wait .5;
		self unLink();
		lift delete();
	}
}

wrs_Smite(){
	if (self.sessionstate == "playing"){
		radiusDamage(self.origin + (0, 0, 35), 300, 180, 0);
		playFx(level.wrs_effect["generic"], self.origin);
		self playSound("grenade_explode_default");
		earthQuake(1, 3, self.origin, 350);

		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7has been smitten!");
	}
}

wrs_Kill(){
	if (self.sessionstate == "playing"){
		self suicide();
		iPrintLn(level.wrs_PrintPrefix + self.name+ " ^7was killed by the admin!");
		self iPrintLnBold(level.wrs_PrintPrefix + "You have been killed by the admin!");
	}
}

wrs_State(){
	if(self.sessionstate == "spectator"){
		self notify("menuresponse", game["menu_team"], "autoassign");
		self iPrintLnBold(level.wrs_PrintPrefix + "You've been forced to play!");
		wait .1;
		self notify("menuresponse", "menu_weapon1", "kar98k_mp");
		wait .25;
		self notify("menuresponse", "menu_weapon2", "mosin_nagant_mp");

	}
	else{
		self notify("menuresponse", game["menu_team"], "spectator");
		self iPrintLnBold(level.wrs_PrintPrefix + "You've been forced to spectate!");
		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7was moved by an admin.");
	}
}

wrs_Hide(){
	if(self.sessionstate != "playing")
		return;

	if(!isDefined(self.wrs_Hide)){
		self.wrs_Hide	= true;

		self iPrintLn(level.wrs_PrintPrefix + "The admin made you invisible!");

		self.maxspeed	= 300;
		self detachAll();
		self setModel("");

		while(isDefined(self.wrs_Hide) && self.sessionstate == "playing")
			wait .1;

		self.wrs_Hide	= undefined;

		self iPrintLn(level.wrs_PrintPrefix + "You are visible again!");

		self.maxspeed	= 190;
		self detachAll();

		if(!isDefined(self.pers["savedmodel"]))
			maps\mp\gametypes\_teams::model();
		else
			maps\mp\_utility::loadModel(self.pers["savedmodel"]);
	}
	else
		self.wrs_Hide = undefined;
}

wrs_Mark(){
	if(!isDefined(self.wrs_Mark)){
		self.wrs_Mark = true;
		iPrintLn(level.wrs_PrintPrefix + self.name + " ^7 is ^3m^7arked^3!");

		self.headIconTeam	= "none";
		self.headIcon		= game["headicon_" + self.pers["team"]];
		self.compIcon		= game["compicon_" + self.pers["team"]];

		num	= self getEntityNumber();
		if(num > 15){
			num = 15;
		}
		objective_Add(num, "current", self.origin, self.compIcon);
		while(isDefined(self.wrs_Mark)){
			for(i = 0;self.sessionstate == "playing";i++){
				objective_Position(num, self.origin);

				if(i >= 20){
					i = 0;
					self.headIcon = game["headicon_" + self.pers["team"]];
//					self playsound("hq_score");
				}
				else if(i < 10)
					self.headIcon		= "";

				if(i < 10)
					objective_Team(num, "axis");
				else
					objective_Team(num, "allies");

				wait .05;
			}
			wait .05;
		}

		self.headIconTeam = "none";
		self.headIcon = "";
		objective_Delete(num);
	}
	else
		self.wrs_Mark = undefined;
}

wrs_Say(say){
	if(say == "")
		say = "Visit ^4E^3U^4R^3O^2^7: eurorifles^4.^7eu";
	self sayAll(say);
}
wrs_Test(){
}

wrs_Jumper(){
	if(!isDefined(self.wrs_Jumper)){
		self.wrs_Jumper = 1;
		self iPrintLn(level.wrs_PrintPrefix + "You are a jumper!");
		self iPrintLnBold(level.wrs_PrintPrefix + "Double-press [{+melee}] to save!");
		self iPrintLnBold(level.wrs_PrintPrefix + "Double-press [{+activate}] to load!");
		while(self.sessionstate != "playing")
			wait .05;
		self detachAll();
		self character\mp_german_kriegsmarine01::main();
		self GiveWeapon("luger_mp");
		self takeWeapon(self.pers["weapon"][0]);
		self takeWeapon(self.pers["weapon"][1]);
		self setWeaponSlotClipAmmo("pistol", 0);
		self setWeaponSlotAmmo("pistol", 0);
		self switchToWeapon(self getWeaponSlotWeapon("pistol"));

		self.headIconTeam	= "none";
		self.headIcon		= "gfx/hud/hud@health_cross.tga";

		while(isDefined(self.wrs_Jumper)){
			if(self useButtonPressed()){
				catch = false;
				wait .05;
				for(i = 0;i < 6;i++){
					use = self useButtonPressed();
					if(catch && use){
						if(isDefined(self.wrs_Jumper_saved)){
							self setOrigin(self.wrs_Jumper_saved[0]);
							self setPlayerAngles(self.wrs_Jumper_saved[1]);
							self iPrintLn(level.wrs_PrintPrefix + "Loaded:(^1" + (int)self.wrs_Jumper_saved[0][0] + "^7,^1" + (int)self.wrs_Jumper_saved[0][1] + "^7,^1" + (int)self.wrs_Jumper_saved[0][2] + "^7)");
						}
						else{
							self iPrintLn(level.wrs_PrintPrefix + "No position to load!");
						}
						wait .1;
						break;
					}
					else if(!use)
						catch = true;
					wait .05;
				}
			}
			else if(self meleeButtonPressed()){
				catch = false;
				wait .05;
				for(i = 0;i < 6;i++){
					melee = self meleeButtonPressed();
					if(catch && melee){
						self.wrs_Jumper_saved[0] = self.origin;
						self.wrs_Jumper_saved[1] = self.angles;
							self iPrintLn(level.wrs_PrintPrefix + "Saved:(^1" + (int)self.wrs_Jumper_saved[0][0] + "^7,^1" + (int)self.wrs_Jumper_saved[0][1] + "^7,^1" + (int)self.wrs_Jumper_saved[0][2] + "^7)");
						wait .1;
						break;
					}
					else if(!melee)
						catch = true;
					wait .05;
				}
			}
			wait .05;
		}
	}
	else{
		self.wrs_Jumper = undefined;
		if(self.sessionstate == "playing"){
			self detachAll();
			self maps\mp\_utility::loadModel(self.pers["savedmodel"]);
			self switchToWeapon(self getWeaponSlotWeapon("primary"));
			self takeWeapon("luger_mp");
			self giveWeapon(self.pers["weapon"][0]); self giveMaxAmmo(self.pers["weapon"][0]);
			self giveWeapon(self.pers["weapon"][1]); self giveMaxAmmo(self.pers["weapon"][1]);
			self switchToWeapon(self getWeaponSlotWeapon("primary"));


			self.headIcon		= game["headicon_" + self.pers["team"]];
			self.headiconteam 	= self.pers["team"];
		}
	}
}
wrs_Warn(warn){
	if(!isDefined(self.wrs_Warn)){
		if(self.sessionstate == "playing"){
			self disableWeapon();
			self.maxspeed = 0;
		}

		self.wrs_Warn[0] = newClientHudElem(self);
		self.wrs_Warn[0].sort = 9998;
		self.wrs_Warn[0] setShader("black", 640, 480);

		self.wrs_Warn[1] = newClientHudElem(self);
		self.wrs_Warn[1].x = 320;
		self.wrs_Warn[1].y = 240;
		self.wrs_Warn[1].alignX = "center";
		self.wrs_Warn[1].alignY = "middle";
		self.wrs_Warn[1].sort = 9999;
		self.wrs_Warn[1].fontScale = 4;
		self.wrs_Warn[1] setText(level.wrs_Warn);

		while(isDefined(self.wrs_Warn)){
			self iPrintLnBold(level.wrs_PrintPrefix + warn + level.wrs_PrintPrefix);
			wait 8;
		}
	}
	else{
		self.wrs_Warn[0] destroy();
		self.wrs_Warn[1] destroy();
		self.wrs_Warn = undefined;

		if(self.sessionstate == "playing"){
			self.maxspeed = 190;
			self enableWeapon();
		}
		for(i = 0;i < 5;i++) iPrintLnBold(" ");
	}
}
wrs_SpectateAll(){
	if(!isDefined(self.pers["spall"]))
		self.pers["spall"] = true;
	else
		self.pers["spall"] = false;
	
	maps\mp\gametypes\_teams::SetSpectatePermissions();
}
wrs_Add(score){
	self.pers["stats"]["xp"] += (int)score;
}

xpldeArray(cvar, n, splitChar){	//The string to split, the amount of arrays to put them in, the array to explode with.
	j = 0;
	xpl[j] = "";

	for (i = 0; i < cvar.size; i++){
		if (cvar[i] == splitChar && (j < n || n == 0) ){
			if(xpl[j] != ""){
				j++;
				xpl[j] = "";
			}
		}
		else
			xpl[j] += cvar[i];
	}
	if(j != 0 && xpl[j] == "")
		xpl[j] = undefined;
	return xpl;
}