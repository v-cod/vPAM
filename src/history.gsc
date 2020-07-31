// After a map switch (level exit), all modding variables are gone, except for cvars.
// We will use cvars to store identifiers to remember which team had which results previously.
// In this way we can show previous map results to players.

// There are two main methods of identifying teams: player GUIDs and their names.
// Some environments like cracked servers might not support GUIDs, which is why there are two methods used.

// Assigns team number to teams based on historical identifier or newly assign.
assign()
{
	if (isDefined(game["_history_team_1"]) && isDefined(game["_history_team_2"])) {
		iPrintLn("assigned already: team_1: " + game["_history_team_1"]);
		iPrintLn("assigned already: team_2: " + game["_history_team_2"]);
		return;
	}

	t1_id = getCvar("p_history_team_1_id");
	t2_id = getCvar("p_history_team_2_id");

	if (t1_id == "" && t2_id == "") {
		game["_history_team_1"] = "allies";
		game["_history_team_2"] = "axis";
	} else {
		id["allies"] = team_id("allies");
		id["axis"] = team_id("axis");

		al_is_1 = team_id_matches(t1_id, id["allies"]);
		ax_is_1 = team_id_matches(t1_id, id["axis"]);
		al_is_2 = team_id_matches(t2_id, id["allies"]);
		ax_is_2 = team_id_matches(t2_id, id["axis"]);

		// Check for conflicting matches. (E.g. perhaps a full team copied the other teams names.)
		if ((al_is_1 && !ax_is_1) || (!al_is_2 && ax_is_2)) {
			game["_history_team_1"] = "allies";
			game["_history_team_2"] = "axis";
		} else if ((!al_is_1 && ax_is_1) || (al_is_2 && !ax_is_2)) {
			game["_history_team_1"] = "axis";
			game["_history_team_2"] = "allies";
		} else {
			// Conflicting matches. Reset?
			iPrintLn(level._prefix + "^1ERROR RETRIEVING PREVIOUS MAP RESULTS");
		}
	}

	iPrintLn("assign: team_1: " + game["_history_team_1"]);
	iPrintLn("assign: team_2: " + game["_history_team_2"]);

	game["_history_data"] = data_from_cvars();
}

push()
{
	// Set identifiers based on current team assignments.
	setCvar("p_history_team_1_id", team_id(game["_history_team_1"]));
	setCvar("p_history_team_2_id", team_id(game["_history_team_2"]));

	if (game["_history_team_1"] == "allies") {
		team_1_score = game["alliedscore"];
		team_2_score = game["axisscore"];
	} else {
		team_1_score = game["axisscore"];
		team_2_score = game["alliedscore"];
	}

	team_1_scores = getCvar("p_history_team_1_scores");
	team_2_scores = getCvar("p_history_team_2_scores");
	if (team_1_scores == "") {
		setCvar("p_history_team_1_scores", team_1_score);
		setCvar("p_history_team_2_scores", team_2_score);
	} else {
		setCvar("p_history_team_1_scores", team_1_scores + " " + team_1_score);
		setCvar("p_history_team_2_scores", team_2_scores + " " + team_2_score);
	}

	maps = getCvar("p_history_maps");
	if (maps == "") {
		setCvar("p_history_maps", getCvar("mapname"));
	} else {
		setCvar("p_history_maps", maps + " " + getCvar("mapname"));
	}

	iPrintLn("pushed!");
}

swap()
{
	if (!isDefined(game["_history_team_1"])) {
		return;
	}

	team_1 = game["_history_team_1"];
	game["_history_team_1"] = game["_history_team_2"];
	game["_history_team_2"] = team_1;
}

data_from_cvars()
{
	t1 = getCvar("p_history_team_1_scores");
	t2 = getCvar("p_history_team_2_scores");
	maps = getCvar("p_history_maps");

	t1 = util::explode(t1, " ", 0);
	t2 = util::explode(t2, " ", 0);
	maps = util::explode(maps, " ", 0);

	if (t1[0] == "" || t2[0] == "" || maps[0] == "" || t1.size != t2.size || t2.size != maps.size) {
		return undefined;
	}

	// Convert to integers.
	for (i = 0; i < t1.size; i++) {
		t1[i] = (int)t1[i];
		t2[i] = (int)t2[i];
	}

	data["scores"]["team_1"] = t1;
	data["scores"]["team_2"] = t2;

	data["maps"] = maps;

	return data;
}

total_score()
{
	total["allies"] = game["alliedscore"];
	total["axis"] = game["axisscore"];

	if (!isDefined(game["_history_data"]["scores"])) {
		return total;
	}

	for (i = 0; i < game["_history_data"]["scores"]["team_1"].size; i++) {
		total[game["_history_team_1"]] += game["_history_data"]["scores"]["team_1"][i];
		total[game["_history_team_2"]] += game["_history_data"]["scores"]["team_2"][i];
	}

	return total;
}

reset()
{
	game["_history_team_1"] = "allies";
	game["_history_team_2"] = "axis";

	game["_history_data"] = undefined;

	setCvar("p_history_maps", "");

	setCvar("p_history_team_1_scores", "");
	setCvar("p_history_team_2_scores", "");

	setCvar("p_history_team_1_id", "");
	setCvar("p_history_team_2_id", "");
}

team_id(team)
{
	guids = team_id_guids(team);
	if (!isDefined(guids)) {
		guids = "";
	}

	names = team_id_names(team);
	if (!isDefined(names)) {
		names = "";
	}

	return guids + ";" + names;
}

team_id_matches(id_a, id_b)
{
	id_a = util::explode(id_a, ";", 0);
	id_b = util::explode(id_b, ";", 0);

	if (id_a.size != 2 || id_b.size != 2) {
		return false;
	}

	guids_match = false;
	guids_a = id_a[0];
	guids_b = id_b[0];

	names_match = false;
	names_a = id_a[1];
	names_b = id_b[1];

	if (guids_a != "" && guids_b != "") {
		guids_a = util::explode(guids_a, " ", 0);
		guids_b = util::explode(guids_b, " ", 0);
		guids_match = arr_match_half(guids_a, guids_b);
	}

	if (names_a != "" && names_b != "") {
		names_a = util::explode(names_a, " ", 0);
		names_b = util::explode(names_b, " ", 0);
		names_match = arr_match_half(names_a, names_b);
	}

	return names_match + guids_match*2;
}

// Return string with player names like "inferno-Walrus EURO|EXPLODE d`logics.t4n3k".
// Returns undefined if no players.
// Spaces have been stripped from individual names, while the names are separated from eachother by spaces.
team_id_names(team)
{
	names = [];

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) { 
		if (players[i].pers["team"] == team) {
			names[names.size] = players[i].name;
		}
	}

	if (names.size == 0) {
		return undefined;
	}

	names_str = "";
	for (i = 0; i < names.size; i++) {
		if (i == 0) {
			names_str += util::strip_spaces(names[i]);
		} else {
			names_str += " " + util::strip_spaces(names[i]);
		}
	}

	return names_str;
}

// Return string with GUIDs like "2016390 1908573 1937543".
// Returns empty string value if all players have no GUID (0).
// Returns undefined if no players.
team_id_guids(team)
{
	guids = [];
	zeroes = 0;

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) { 
		if (players[i].pers["team"] == team) {
			guid = players[i] getGuid();
			guids[guids.size] = guid;
			if (guid == 0) {
				zeroes++;
			}
		}
	}

	if (guids.size == 0) {
		return undefined;
	}

	// Return special value if all players have GUID 0.
	if (guids.size == zeroes) {
		return "";
	}

	guids_str = "";
	for (i = 0; i < guids.size; i++) {
		if (i == 0) {
			guids_str += guids[i];
		} else {
			guids_str += " " + guids[i];
		}
	}

	return guids_str;
}


// Return true if more than half of either array elements is also in other array.
arr_match_half(arr_a, arr_b)
{
	if (arr_a.size == 0 || arr_b.size == 0) {
		return false;
	}

	matches = 0;
	for (i = 0; i < arr_a.size; i++) {
		for (j = 0; j < arr_b.size; j++) {
			if (arr_a[i] == arr_b[j]) {
				matches++;
			}
		}
	}

	// max(a.size, b.size)
	max_size = arr_a.size;
	if (arr_b.size > max_size) {
		max_size = arr_b.size;
	}

	return matches > (max_size / 2);
}
