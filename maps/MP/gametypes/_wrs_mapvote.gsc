//These functions handle the mapvoting
wrs_MapVote(seconds)
{
	level.wrs_Candidate = MapVotingCandidates(level.wrs_MapVoting_amount);

	createMapVotingHud(level.wrs_Candidate.size);
	level.wrs_MapVote_hud_timer setClock(seconds, 60, "hudStopwatch", 64, 64);

	level.wrs_Players = getEntArray("player", "classname");
	for(i = 0; i < level.wrs_Players.size; i++) {
		level.wrs_Players[i] thread MapVotingPlayer();
	}

	wait seconds;                   //Let people vote for seconds
	level.wrs_MapVoting_end = true; //Put on true, so people can't vote.
	winner = MapVoteWinner();

	removeMapVotingHud();

	iPrintLnBold("^4Next Map^7: ^3" + level.wrs_Candidate[winner]["title"]);    //Count votes and print it
	setCvar("sv_maprotationcurrent", "gametype "+level.gametype+" map " + level.wrs_Candidate[winner]["name"]);

	wait 3;
}
MapVoteWinner()
{
	winner = 0;
	votes  = 0;
	for(i = 0;i < level.wrs_Candidate.size;i++){
		if(level.wrs_Candidate[i]["votes"] > votes){
			votes = level.wrs_Candidate[i]["votes"];
			winner = i;
		}
	}
	return winner;
}
MapVotingPlayer()
{
	self.wrs_MapVote_hud_Indicator       = newClientHudElem(self);
	self.wrs_MapVote_hud_Indicator.x     = level.wrs_MapVote_x + 4;
	self.wrs_MapVote_hud_Indicator.y     = level.wrs_MapVote_y + 24;
	self.wrs_MapVote_hud_Indicator.sort  = 9998;
	self.wrs_MapVote_hud_Indicator.alpha = 0;
	self.wrs_MapVote_hud_Indicator.color = (0, 0, 1);
	self.wrs_MapVote_hud_Indicator setShader("white", level.wrs_MapVote_width - 8, 24);

	cndts    = level.wrs_MapVoting_amount - 1;
	mapVote  = -1;
	lastVote = -1;

	while(!isDefined(level.wrs_MapVoting_end)){
		if(self attackButtonPressed()){
			if(!self.wrs_MapVote_hud_Indicator.alpha)
				self.wrs_MapVote_hud_Indicator.alpha = 0.3;

			mapVote++;
			if(mapVote > cndts)
				mapVote = 0;

			/////////////// SAME AS ABOVE
			if(lastVote != -1){
				level.wrs_Candidate[lastVote]["votes"]--;
				level.wrs_MapVote_hud_map_votes[lastVote] setValue(level.wrs_Candidate[lastVote]["votes"]);
			}
			level.wrs_Candidate[mapVote]["votes"]++;
			level.wrs_MapVote_hud_map_votes[mapVote] setValue(level.wrs_Candidate[mapVote]["votes"]);
			lastVote = mapVote;
			///////////////

			self.wrs_MapVote_hud_Indicator.y = level.wrs_MapVote_y + 24 + mapVote * 24;
			self playLocalSound("hq_score");

			while(self attackButtonPressed())
				wait .05;
		}
		else if(self meleeButtonPressed()){
			if(!self.wrs_MapVote_hud_Indicator.alpha)
				self.wrs_MapVote_hud_Indicator.alpha = 0.3;

			mapVote--;
			if(mapVote < 0)
				mapVote = cndts;

			/////////////// SAME AS ABOVE
			if(lastVote != -1){
				level.wrs_Candidate[lastVote]["votes"]--;
				level.wrs_MapVote_hud_map_votes[lastVote] setValue(level.wrs_Candidate[lastVote]["votes"]);
			}
			level.wrs_Candidate[mapVote]["votes"]++;
			level.wrs_MapVote_hud_map_votes[mapVote] setValue(level.wrs_Candidate[mapVote]["votes"]);
			lastVote = mapVote;
			///////////////

			self.wrs_MapVote_hud_Indicator.y = level.wrs_MapVote_y + 24 + mapVote * 24;
			self playLocalSound("hq_score");

			while(self meleeButtonPressed())
				wait .05;
		}

		wait .05;
	}

	if(isDefined(self.wrs_MapVote_hud_Indicator))
		self.wrs_MapVote_hud_Indicator destroy();
}
MapVotingCandidates(cndts)
{
	rotation = getCvar("sv_maprotation");
	if(rotation == ""){
		if(level.wrs_MapVote_Maps.size < cndts)
			cndts = level.wrs_MapVote_Maps.size;

		for(i = 0;i < cndts;i++){
			candidate[i]["name"]    = level.wrs_MapVote_Maps[i][0];
			candidate[i]["iString"] = level.wrs_MapVote_Maps[i][1];
			candidate[i]["title"]   = level.wrs_MapVote_Maps[i][2];
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
createMapVotingHud(cndts)
{
	level.wrs_MapVote_width = 200;
	level.wrs_MapVote_height =27 + cndts*24;

	level.wrs_MapVote_x = 320 - level.wrs_MapVote_width/2;
	level.wrs_MapVote_y = -64 + 240 - level.wrs_MapVote_height/2;

	if (isDefined(level.wrs_MapVote_hud_bg))
		return;
	//CONTAINER
	level.wrs_MapVote_hud_bg = newHudElem();
	level.wrs_MapVote_hud_bg.archived = false;
	level.wrs_MapVote_hud_bg.alpha = .7;
	level.wrs_MapVote_hud_bg.x = level.wrs_MapVote_x;
	level.wrs_MapVote_hud_bg.y = level.wrs_MapVote_y;
	level.wrs_MapVote_hud_bg.sort = 9000;
	level.wrs_MapVote_hud_bg.color = (0,0,0);
	level.wrs_MapVote_hud_bg setShader("white", level.wrs_MapVote_width, level.wrs_MapVote_height);
	//TITLE CONTAINER
	level.wrs_MapVote_hud_Cont = newHudElem();
	level.wrs_MapVote_hud_Cont.archived = false;
	level.wrs_MapVote_hud_Cont.alpha = .3;
	level.wrs_MapVote_hud_Cont.x = level.wrs_MapVote_x + 3;
	level.wrs_MapVote_hud_Cont.y = level.wrs_MapVote_y + 3;
	level.wrs_MapVote_hud_Cont.sort = 9001;
	level.wrs_MapVote_hud_Cont setShader("white", level.wrs_MapVote_width - 6, 21);
	//TITLE TEXT
	level.wrs_MapVote_hud_ContText = newHudElem();
	level.wrs_MapVote_hud_ContText.archived = false;
	level.wrs_MapVote_hud_ContText.alignX = "center";
	level.wrs_MapVote_hud_ContText.x = level.wrs_MapVote_x + level.wrs_MapVote_width/2;
	level.wrs_MapVote_hud_ContText.y = level.wrs_MapVote_y + 5;
	level.wrs_MapVote_hud_ContText.sort = 9998;
	level.wrs_MapVote_hud_ContText.label = level.wrs_MapVote_hud_Title;
	level.wrs_MapVote_hud_ContText.fontscale = 1.2;
	//LEFT CONTAINER LINE
	level.wrs_MapVote_hud_LL = newHudElem();
	level.wrs_MapVote_hud_LL.archived = false;
	level.wrs_MapVote_hud_LL.alpha = .3;
	level.wrs_MapVote_hud_LL.x = level.wrs_MapVote_x + 3;
	level.wrs_MapVote_hud_LL.y = level.wrs_MapVote_y + 24;
	level.wrs_MapVote_hud_LL.sort = 9001;
	level.wrs_MapVote_hud_LL setShader("white", 1, level.wrs_MapVote_height - 28);
	//RIGHT CONTAINER LINE
	level.wrs_MapVote_hud_RL = newHudElem();
	level.wrs_MapVote_hud_RL.archived = false;
	level.wrs_MapVote_hud_RL.alpha = .3;
	level.wrs_MapVote_hud_RL.x = level.wrs_MapVote_x + (level.wrs_MapVote_width - 4);
	level.wrs_MapVote_hud_RL.y = level.wrs_MapVote_y + 24;
	level.wrs_MapVote_hud_RL.sort = 9001;
	level.wrs_MapVote_hud_RL setShader("white", 1, level.wrs_MapVote_height - 28);
	//UNDER CONTAINER LINE
	level.wrs_MapVote_hud_UL = newHudElem();
	level.wrs_MapVote_hud_UL.archived = false;
	level.wrs_MapVote_hud_UL.alpha = .3;
	level.wrs_MapVote_hud_UL.x = level.wrs_MapVote_x + 3;
	level.wrs_MapVote_hud_UL.y = level.wrs_MapVote_y + (level.wrs_MapVote_height - 3);
	level.wrs_MapVote_hud_UL.alignY = "bottom";
	level.wrs_MapVote_hud_UL.sort = 9001;
	level.wrs_MapVote_hud_UL setShader("white", level.wrs_MapVote_width - 6, 1);
	//MAPS
	for(i = 0; i < cndts; i++){
		level.wrs_MapVote_hud_map[i] = newHudElem();
		level.wrs_MapVote_hud_map[i].archived = false;
		level.wrs_MapVote_hud_map[i].x = level.wrs_MapVote_x + 8;
		level.wrs_MapVote_hud_map[i].y = level.wrs_MapVote_y + 24 + (i * 24);
		level.wrs_MapVote_hud_map[i].sort = 9998;
		level.wrs_MapVote_hud_map[i].fontScale = 1.5;
		level.wrs_MapVote_hud_map[i] setText(level.wrs_Candidate[i]["iString"]);

		level.wrs_MapVote_hud_map_votes[i] = newHudElem();
		level.wrs_MapVote_hud_map_votes[i].archived = false;
		level.wrs_MapVote_hud_map_votes[i].alignX = "right";
		level.wrs_MapVote_hud_map_votes[i].x = level.wrs_MapVote_x + level.wrs_MapVote_Width - 8;
		level.wrs_MapVote_hud_map_votes[i].y = level.wrs_MapVote_y + 24 + (i * 24);
		level.wrs_MapVote_hud_map_votes[i].sort = 9998;
		level.wrs_MapVote_hud_map_votes[i].fontScale = 1.5;
		level.wrs_MapVote_hud_map_votes[i] setValue(0);
	}

	level.wrs_MapVote_hud_timer = newHudElem();
	level.wrs_MapVote_hud_timer.archived = false;
	level.wrs_MapVote_hud_timer.x = level.wrs_MapVote_x + level.wrs_MapVote_Width/2;
	level.wrs_MapVote_hud_timer.y = level.wrs_MapVote_y - 3;
	level.wrs_MapVote_hud_timer.alignX = "center";
	level.wrs_MapVote_hud_timer.alignY = "middle";
	level.wrs_MapVote_hud_timer.sort = 9999;
}
removeMapVotingHud()
{
	for(i = 0;i < level.wrs_MapVote_hud_map.size;i++)
		if(isDefined(level.wrs_MapVote_hud_map[i])){
			level.wrs_MapVote_hud_map[i] fadeOverTime(1);
			level.wrs_MapVote_hud_map[i].alpha = 0;
			level.wrs_MapVote_hud_map_votes[i] fadeOverTime(1);
			level.wrs_MapVote_hud_map_votes[i].alpha = 0;
		}

	if(isDefined(level.wrs_MapVote_hud_bg)){
		level.wrs_MapVote_hud_bg fadeOverTime(1);
		level.wrs_MapVote_hud_bg.alpha = 0;
	}
	if(isDefined(level.wrs_MapVote_hud_Cont)){
		level.wrs_MapVote_hud_Cont fadeOverTime(1);
		level.wrs_MapVote_hud_Cont.alpha = 0;
	}
	if(isDefined(level.wrs_MapVote_hud_ContText)){
		level.wrs_MapVote_hud_ContText fadeOverTime(1);
		level.wrs_MapVote_hud_ContText.alpha = 0;
	}
	if(isDefined(level.wrs_MapVote_hud_LL)){
		level.wrs_MapVote_hud_LL fadeOverTime(1);
		level.wrs_MapVote_hud_LL.alpha = 0;
	}
	if(isDefined(level.wrs_MapVote_hud_RL)){
		level.wrs_MapVote_hud_RL fadeOverTime(1);
		level.wrs_MapVote_hud_RL.alpha = 0;
	}
	if(isDefined(level.wrs_MapVote_hud_UL)){
		level.wrs_MapVote_hud_UL fadeOverTime(1);
		level.wrs_MapVote_hud_UL.alpha = 0;
	}
	if(isDefined(level.wrs_MapVote_hud_timer)){
		level.wrs_MapVote_hud_timer fadeOverTime(1);
		level.wrs_MapVote_hud_timer.alpha = 0;
	}

	wait 1;

	if(isDefined(level.wrs_MapVote_hud_bg))
		level.wrs_MapVote_hud_bg destroy();
	if(isDefined(level.wrs_MapVote_hud_Cont))
		level.wrs_MapVote_hud_Cont destroy();
	if(isDefined(level.wrs_MapVote_hud_ContText))
		level.wrs_MapVote_hud_ContText destroy();
	if(isDefined(level.wrs_MapVote_hud_LL))
		level.wrs_MapVote_hud_LL destroy();
	if(isDefined(level.wrs_MapVote_hud_RL))
		level.wrs_MapVote_hud_RL destroy();
	if(isDefined(level.wrs_MapVote_hud_UL))
		level.wrs_MapVote_hud_UL destroy();
	if(isDefined(level.wrs_MapVote_hud_timer))
		level.wrs_MapVote_hud_timer destroy();
	for(i = 0;i < level.wrs_MapVote_hud_map.size;i++)
		if(isDefined(level.wrs_MapVote_hud_map[i])){
			level.wrs_MapVote_hud_map[i] destroy();
			level.wrs_MapVote_hud_map_votes[i] destroy();
		}
}


getMapIString(name)
{
	for(i = 0;i < level.wrs_MapVote_Maps.size;i++){
		if(level.wrs_MapVote_Maps[i][0] == name){
			return level.wrs_MapVote_Maps[i][1];
		}
	}

	return 0;
}
getMapTitle(name)
{
	title = 0;
	for(i = 0;i < level.wrs_MapVote_Maps.size;i++)
		if(level.wrs_MapVote_Maps[i][0] == name){
			title = level.wrs_MapVote_Maps[i][2];
			break;
		}

	return title;
}
