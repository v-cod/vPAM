init()
{
	level.wrs_maps[0][0]  = "mp_bocage";     level.wrs_maps[0][1]  = &"Bocage";     level.wrs_maps[0][2]  = "Bocage";
	level.wrs_maps[1][0]  = "mp_brecourt";   level.wrs_maps[1][1]  = &"Brecourt";   level.wrs_maps[1][2]  = "Brecourt";
	level.wrs_maps[2][0]  = "mp_carentan";   level.wrs_maps[2][1]  = &"Carentan";   level.wrs_maps[2][2]  = "Carentan";
	level.wrs_maps[3][0]  = "mp_chateau";    level.wrs_maps[3][1]  = &"Chateau";    level.wrs_maps[3][2]  = "Chateau";
	level.wrs_maps[4][0]  = "mp_dawnville";  level.wrs_maps[4][1]  = &"Dawnville";  level.wrs_maps[4][2]  = "Dawnville";
	level.wrs_maps[5][0]  = "mp_depot";      level.wrs_maps[5][1]  = &"Depot";      level.wrs_maps[5][2]  = "Depot";
	level.wrs_maps[6][0]  = "mp_harbor";     level.wrs_maps[6][1]  = &"Harbor";     level.wrs_maps[6][2]  = "Harbor";
	level.wrs_maps[7][0]  = "mp_hurtgen";    level.wrs_maps[7][1]  = &"Hurtgen";    level.wrs_maps[7][2]  = "Hurtgen";
	level.wrs_maps[8][0]  = "mp_neuville";   level.wrs_maps[8][1]  = &"Neuville";   level.wrs_maps[8][2]  = "Neuville";
	level.wrs_maps[9][0]  = "mp_pavlov";     level.wrs_maps[9][1]  = &"Pavlov";     level.wrs_maps[9][2]  = "Pavlov";
	level.wrs_maps[10][0] = "mp_powcamp";    level.wrs_maps[10][1] = &"POW Camp";   level.wrs_maps[10][2] = "POW Camp";
	level.wrs_maps[11][0] = "mp_railyard";   level.wrs_maps[11][1] = &"Railyard";   level.wrs_maps[11][2] = "Railyard";
	level.wrs_maps[12][0] = "mp_rocket";     level.wrs_maps[12][1] = &"Rocket";     level.wrs_maps[12][2] = "Rocket";
	level.wrs_maps[13][0] = "mp_ship";       level.wrs_maps[13][1] = &"Ship";       level.wrs_maps[13][2] = "Ship";
	level.wrs_maps[14][0] = "mp_stalingrad"; level.wrs_maps[14][1] = &"Stalingrad"; level.wrs_maps[14][2] = "Stalingrad";
	level.wrs_maps[15][0] = "mp_tigertown";  level.wrs_maps[15][1] = &"Tigertown";  level.wrs_maps[15][2] = "Tigertown";

	level.wrs_hud_mapvote_header = &"Map                                    Votes";

	if (!isDefined(game["gamestarted"])) {
		for (i = 0; i < level.wrs_maps.size; i++) {
			precacheString(level.wrs_maps[i][1]);
		}

		precacheShader("white");
		precacheString(level.wrs_hud_mapvote_header);
	}
}

//These functions handle the mapvoting
start(seconds)
{
	level.wrs_candidate = _mapvote_candidates(level.wrs_mapvoting_amount);

	_create_mapvoting_hud(level.wrs_candidate.size);
	level.wrs_mapvote_hud_timer setClock(seconds, 60, "hudStopwatch", 64, 64);

	players = getEntArray("player", "classname");
	for(i = 0; i < players.size; i++) {
		players[i] thread _monitor_player_mapvote();
	}

	wait seconds;                   //Let people vote for seconds
	level.wrs_mapvoting_end = true; //Put on true, so people can't vote.
	winner = _mapvote_winner();

	removeMapVotingHud();

	iPrintLnBold("^4Next Map^7: ^3" + level.wrs_candidate[winner]["title"]);    //Count votes and print it
	setCvar("sv_maprotationcurrent", "gametype "+level.gametype+" map " + level.wrs_candidate[winner]["name"]);

	wait 3;
}
_mapvote_winner()
{
	winner = 0;
	votes  = 0;
	for(i = 0;i < level.wrs_candidate.size;i++){
		if(level.wrs_candidate[i]["votes"] > votes){
			votes = level.wrs_candidate[i]["votes"];
			winner = i;
		}
	}
	return winner;
}
_monitor_player_mapvote()
{
	self.wrs_mapvote_hud_indicator       = newClientHudElem(self);
	self.wrs_mapvote_hud_indicator.x     = level.wrs_mapvote_x + 4;
	self.wrs_mapvote_hud_indicator.y     = level.wrs_mapvote_y + 24;
	self.wrs_mapvote_hud_indicator.sort  = 9998;
	self.wrs_mapvote_hud_indicator.alpha = 0;
	self.wrs_mapvote_hud_indicator.color = (0, 0, 1);
	self.wrs_mapvote_hud_indicator setShader("white", level.wrs_mapvote_width - 8, 24);

	cndts    = level.wrs_mapvoting_amount - 1;
	mapVote  = -1;
	lastVote = -1;

	while(!isDefined(level.wrs_mapvoting_end)){
		if(self attackButtonPressed()){
			if(!self.wrs_mapvote_hud_indicator.alpha)
				self.wrs_mapvote_hud_indicator.alpha = 0.3;

			mapVote++;
			if(mapVote > cndts)
				mapVote = 0;

			/////////////// SAME AS ABOVE
			if(lastVote != -1){
				level.wrs_candidate[lastVote]["votes"]--;
				level.wrs_mapvote_hud_map_votes[lastVote] setValue(level.wrs_candidate[lastVote]["votes"]);
			}
			level.wrs_candidate[mapVote]["votes"]++;
			level.wrs_mapvote_hud_map_votes[mapVote] setValue(level.wrs_candidate[mapVote]["votes"]);
			lastVote = mapVote;
			///////////////

			self.wrs_mapvote_hud_indicator.y = level.wrs_mapvote_y + 24 + mapVote * 24;
			self playLocalSound("hq_score");

			while(self attackButtonPressed())
				wait .05;
		}
		else if(self meleeButtonPressed()){
			if(!self.wrs_mapvote_hud_indicator.alpha)
				self.wrs_mapvote_hud_indicator.alpha = 0.3;

			mapVote--;
			if(mapVote < 0)
				mapVote = cndts;

			/////////////// SAME AS ABOVE
			if(lastVote != -1){
				level.wrs_candidate[lastVote]["votes"]--;
				level.wrs_mapvote_hud_map_votes[lastVote] setValue(level.wrs_candidate[lastVote]["votes"]);
			}
			level.wrs_candidate[mapVote]["votes"]++;
			level.wrs_mapvote_hud_map_votes[mapVote] setValue(level.wrs_candidate[mapVote]["votes"]);
			lastVote = mapVote;
			///////////////

			self.wrs_mapvote_hud_indicator.y = level.wrs_mapvote_y + 24 + mapVote * 24;
			self playLocalSound("hq_score");

			while(self meleeButtonPressed())
				wait .05;
		}

		wait .05;
	}

	if(isDefined(self.wrs_mapvote_hud_indicator))
		self.wrs_mapvote_hud_indicator destroy();
}
_mapvote_candidates(cndts)
{
	rotation = getCvar("sv_maprotation");
	if(rotation == ""){
		if(level.wrs_maps.size < cndts)
			cndts = level.wrs_maps.size;

		for(i = 0;i < cndts;i++){
			candidate[i]["name"]    = level.wrs_maps[i][0];
			candidate[i]["iString"] = level.wrs_maps[i][1];
			candidate[i]["title"]   = level.wrs_maps[i][2];
			candidate[i]["votes"]   = 0;
		}
	}
	else{
		rotation = maps\mp\gametypes\_wrs_admin::explode(" ", rotation, 0);  //Get all words from sv_maprotation.
		maps = [];
		current = getCvar("mapname");
		for(i = 0;i < rotation.size;i++){
			if(maps\mp\gametypes\_wrs::substr(rotation[i],0,3) == "mp_" && rotation[i] != current){
				maps[maps.size] = rotation[i];
			}
		}
		if(cndts > maps.size){
			cndts = maps.size;
		}
		index = 0;
		cndt = [];
		candidate = [];
		while (1) {
			rnd = randomInt(maps.size);
			if (!maps\mp\gametypes\_wrs::in_array(maps[rnd],cndt)) {
				cndt[index] = maps[rnd];
				candidate[index]["name"]    = cndt[index];
				candidate[index]["iString"] = getMapIString(cndt[index]);
				candidate[index]["title"]   = getMapTitle(cndt[index]);
				candidate[index]["votes"]   = 0;
				index++;
			}
			if (index >= cndts) {
				break;
			}
		}
		return candidate;
	}

	return candidate;
}
_create_mapvoting_hud(cndts)
{
	level.wrs_mapvote_width = 200;
	level.wrs_mapvote_height =27 + cndts*24;

	level.wrs_mapvote_x = 320 - level.wrs_mapvote_width/2;
	level.wrs_mapvote_y = -64 + 240 - level.wrs_mapvote_height/2;

	if (isDefined(level.wrs_mapvote_hud_bg))
		return;
	//CONTAINER
	level.wrs_mapvote_hud_bg = newHudElem();
	level.wrs_mapvote_hud_bg.archived = false;
	level.wrs_mapvote_hud_bg.alpha = .7;
	level.wrs_mapvote_hud_bg.x = level.wrs_mapvote_x;
	level.wrs_mapvote_hud_bg.y = level.wrs_mapvote_y;
	level.wrs_mapvote_hud_bg.sort = 9000;
	level.wrs_mapvote_hud_bg.color = (0,0,0);
	level.wrs_mapvote_hud_bg setShader("white", level.wrs_mapvote_width, level.wrs_mapvote_height);
	//TITLE CONTAINER
	level.wrs_mapvote_hud_cont = newHudElem();
	level.wrs_mapvote_hud_cont.archived = false;
	level.wrs_mapvote_hud_cont.alpha = .3;
	level.wrs_mapvote_hud_cont.x = level.wrs_mapvote_x + 3;
	level.wrs_mapvote_hud_cont.y = level.wrs_mapvote_y + 3;
	level.wrs_mapvote_hud_cont.sort = 9001;
	level.wrs_mapvote_hud_cont setShader("white", level.wrs_mapvote_width - 6, 21);
	//TITLE TEXT
	level.wrs_mapvote_hud_cont_text = newHudElem();
	level.wrs_mapvote_hud_cont_text.archived = false;
	level.wrs_mapvote_hud_cont_text.alignX = "center";
	level.wrs_mapvote_hud_cont_text.x = level.wrs_mapvote_x + level.wrs_mapvote_width/2;
	level.wrs_mapvote_hud_cont_text.y = level.wrs_mapvote_y + 5;
	level.wrs_mapvote_hud_cont_text.sort = 9998;
	level.wrs_mapvote_hud_cont_text.label = level.wrs_hud_mapvote_header;
	level.wrs_mapvote_hud_cont_text.fontscale = 1.2;
	//LEFT CONTAINER LINE
	level.wrs_mapvote_hud_LL = newHudElem();
	level.wrs_mapvote_hud_LL.archived = false;
	level.wrs_mapvote_hud_LL.alpha = .3;
	level.wrs_mapvote_hud_LL.x = level.wrs_mapvote_x + 3;
	level.wrs_mapvote_hud_LL.y = level.wrs_mapvote_y + 24;
	level.wrs_mapvote_hud_LL.sort = 9001;
	level.wrs_mapvote_hud_LL setShader("white", 1, level.wrs_mapvote_height - 28);
	//RIGHT CONTAINER LINE
	level.wrs_mapvote_hud_RL = newHudElem();
	level.wrs_mapvote_hud_RL.archived = false;
	level.wrs_mapvote_hud_RL.alpha = .3;
	level.wrs_mapvote_hud_RL.x = level.wrs_mapvote_x + (level.wrs_mapvote_width - 4);
	level.wrs_mapvote_hud_RL.y = level.wrs_mapvote_y + 24;
	level.wrs_mapvote_hud_RL.sort = 9001;
	level.wrs_mapvote_hud_RL setShader("white", 1, level.wrs_mapvote_height - 28);
	//UNDER CONTAINER LINE
	level.wrs_mapvote_hud_UL = newHudElem();
	level.wrs_mapvote_hud_UL.archived = false;
	level.wrs_mapvote_hud_UL.alpha = .3;
	level.wrs_mapvote_hud_UL.x = level.wrs_mapvote_x + 3;
	level.wrs_mapvote_hud_UL.y = level.wrs_mapvote_y + (level.wrs_mapvote_height - 3);
	level.wrs_mapvote_hud_UL.alignY = "bottom";
	level.wrs_mapvote_hud_UL.sort = 9001;
	level.wrs_mapvote_hud_UL setShader("white", level.wrs_mapvote_width - 6, 1);
	//MAPS
	for(i = 0; i < cndts; i++){
		level.wrs_mapvote_hud_map[i] = newHudElem();
		level.wrs_mapvote_hud_map[i].archived = false;
		level.wrs_mapvote_hud_map[i].x = level.wrs_mapvote_x + 8;
		level.wrs_mapvote_hud_map[i].y = level.wrs_mapvote_y + 24 + (i * 24);
		level.wrs_mapvote_hud_map[i].sort = 9998;
		level.wrs_mapvote_hud_map[i].fontScale = 1.5;
		level.wrs_mapvote_hud_map[i] setText(level.wrs_candidate[i]["iString"]);

		level.wrs_mapvote_hud_map_votes[i] = newHudElem();
		level.wrs_mapvote_hud_map_votes[i].archived = false;
		level.wrs_mapvote_hud_map_votes[i].alignX = "right";
		level.wrs_mapvote_hud_map_votes[i].x = level.wrs_mapvote_x + level.wrs_mapvote_Width - 8;
		level.wrs_mapvote_hud_map_votes[i].y = level.wrs_mapvote_y + 24 + (i * 24);
		level.wrs_mapvote_hud_map_votes[i].sort = 9998;
		level.wrs_mapvote_hud_map_votes[i].fontScale = 1.5;
		level.wrs_mapvote_hud_map_votes[i] setValue(0);
	}

	level.wrs_mapvote_hud_timer = newHudElem();
	level.wrs_mapvote_hud_timer.archived = false;
	level.wrs_mapvote_hud_timer.x = level.wrs_mapvote_x + level.wrs_mapvote_Width/2;
	level.wrs_mapvote_hud_timer.y = level.wrs_mapvote_y - 3;
	level.wrs_mapvote_hud_timer.alignX = "center";
	level.wrs_mapvote_hud_timer.alignY = "middle";
	level.wrs_mapvote_hud_timer.sort = 9999;
}
removeMapVotingHud()
{
	for(i = 0;i < level.wrs_mapvote_hud_map.size;i++)
		if(isDefined(level.wrs_mapvote_hud_map[i])){
			level.wrs_mapvote_hud_map[i] fadeOverTime(1);
			level.wrs_mapvote_hud_map[i].alpha = 0;
			level.wrs_mapvote_hud_map_votes[i] fadeOverTime(1);
			level.wrs_mapvote_hud_map_votes[i].alpha = 0;
		}

	if(isDefined(level.wrs_mapvote_hud_bg)){
		level.wrs_mapvote_hud_bg fadeOverTime(1);
		level.wrs_mapvote_hud_bg.alpha = 0;
	}
	if(isDefined(level.wrs_mapvote_hud_cont)){
		level.wrs_mapvote_hud_cont fadeOverTime(1);
		level.wrs_mapvote_hud_cont.alpha = 0;
	}
	if(isDefined(level.wrs_mapvote_hud_cont_text)){
		level.wrs_mapvote_hud_cont_text fadeOverTime(1);
		level.wrs_mapvote_hud_cont_text.alpha = 0;
	}
	if(isDefined(level.wrs_mapvote_hud_LL)){
		level.wrs_mapvote_hud_LL fadeOverTime(1);
		level.wrs_mapvote_hud_LL.alpha = 0;
	}
	if(isDefined(level.wrs_mapvote_hud_RL)){
		level.wrs_mapvote_hud_RL fadeOverTime(1);
		level.wrs_mapvote_hud_RL.alpha = 0;
	}
	if(isDefined(level.wrs_mapvote_hud_UL)){
		level.wrs_mapvote_hud_UL fadeOverTime(1);
		level.wrs_mapvote_hud_UL.alpha = 0;
	}
	if(isDefined(level.wrs_mapvote_hud_timer)){
		level.wrs_mapvote_hud_timer fadeOverTime(1);
		level.wrs_mapvote_hud_timer.alpha = 0;
	}

	wait 1;

	if(isDefined(level.wrs_mapvote_hud_bg))
		level.wrs_mapvote_hud_bg destroy();
	if(isDefined(level.wrs_mapvote_hud_cont))
		level.wrs_mapvote_hud_cont destroy();
	if(isDefined(level.wrs_mapvote_hud_cont_text))
		level.wrs_mapvote_hud_cont_text destroy();
	if(isDefined(level.wrs_mapvote_hud_LL))
		level.wrs_mapvote_hud_LL destroy();
	if(isDefined(level.wrs_mapvote_hud_RL))
		level.wrs_mapvote_hud_RL destroy();
	if(isDefined(level.wrs_mapvote_hud_UL))
		level.wrs_mapvote_hud_UL destroy();
	if(isDefined(level.wrs_mapvote_hud_timer))
		level.wrs_mapvote_hud_timer destroy();
	for(i = 0;i < level.wrs_mapvote_hud_map.size;i++)
		if(isDefined(level.wrs_mapvote_hud_map[i])){
			level.wrs_mapvote_hud_map[i] destroy();
			level.wrs_mapvote_hud_map_votes[i] destroy();
		}
}


getMapIString(name)
{
	for(i = 0;i < level.wrs_maps.size;i++){
		if(level.wrs_maps[i][0] == name){
			return level.wrs_maps[i][1];
		}
	}

	return 0;
}
getMapTitle(name)
{
	title = 0;
	for(i = 0;i < level.wrs_maps.size;i++)
		if(level.wrs_maps[i][0] == name){
			title = level.wrs_maps[i][2];
			break;
		}

	return title;
}
