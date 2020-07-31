_local()
{
	// Stock 1.5 maps.
	i=0; var["maps"][i][0] = "mp_bocage";       var["maps"][i][1] = &"Bocage";
	i++; var["maps"][i][0] = "mp_brecourt";     var["maps"][i][1] = &"Brecourt";
	i++; var["maps"][i][0] = "mp_carentan";     var["maps"][i][1] = &"Carentan";
	i++; var["maps"][i][0] = "mp_chateau";      var["maps"][i][1] = &"Chateau";
	i++; var["maps"][i][0] = "mp_dawnville";    var["maps"][i][1] = &"Dawnville";
	i++; var["maps"][i][0] = "mp_depot";        var["maps"][i][1] = &"Depot";
	i++; var["maps"][i][0] = "mp_harbor";       var["maps"][i][1] = &"Harbor";
	i++; var["maps"][i][0] = "mp_hurtgen";      var["maps"][i][1] = &"Hurtgen";
	i++; var["maps"][i][0] = "mp_neuville";     var["maps"][i][1] = &"Neuville";
	i++; var["maps"][i][0] = "mp_pavlov";       var["maps"][i][1] = &"Pavlov";
	i++; var["maps"][i][0] = "mp_powcamp";      var["maps"][i][1] = &"POW Camp";
	i++; var["maps"][i][0] = "mp_railyard";     var["maps"][i][1] = &"Railyard";
	i++; var["maps"][i][0] = "mp_rocket";       var["maps"][i][1] = &"Rocket";
	i++; var["maps"][i][0] = "mp_ship";         var["maps"][i][1] = &"Ship";
	i++; var["maps"][i][0] = "mp_stalingrad";   var["maps"][i][1] = &"Stalingrad";
	i++; var["maps"][i][0] = "mp_tigertown";    var["maps"][i][1] = &"Tigertown";
	// Extra maps.
	i++; var["maps"][i][0] = "german_town";     var["maps"][i][1] = &"German Town";
	i++; var["maps"][i][0] = "mp_stanjel";      var["maps"][i][1] = &"Stanjel";
	i++; var["maps"][i][0] = "mp_priory";       var["maps"][i][1] = &"Priory";
	i++; var["maps"][i][0] = "mp_vacant";       var["maps"][i][1] = &"Vacant";
	// vcoduomappack.pk3
	i++; var["maps"][i][0] = "mp_arnhem";       var["maps"][i][1] = &"Arnhem";
	i++; var["maps"][i][0] = "mp_cassino";      var["maps"][i][1] = &"Cassino";
	i++; var["maps"][i][0] = "mp_peaks";        var["maps"][i][1] = &"Peaks";
	i++; var["maps"][i][0] = "mp_sicily";       var["maps"][i][1] = &"Sicily";
	i++; var["maps"][i][0] = "mp_streets";      var["maps"][i][1] = &"Streets";
	i++; var["maps"][i][0] = "mp_uo_carentan";  var["maps"][i][1] = &"UO Carentan";
	i++; var["maps"][i][0] = "mp_uo_dawnville"; var["maps"][i][1] = &"UO Dawnville";
	i++; var["maps"][i][0] = "mp_uo_depot";     var["maps"][i][1] = &"UO Depot";
	i++; var["maps"][i][0] = "mp_uo_harbor";    var["maps"][i][1] = &"UO Harbor";
	i++; var["maps"][i][0] = "mp_uo_hurtgen";   var["maps"][i][1] = &"UO Hurtgen";
	i++; var["maps"][i][0] = "mp_uo_powcamp";   var["maps"][i][1] = &"UO Powcamp";
	i++; var["maps"][i][0] = "mp_uo_stanjel";   var["maps"][i][1] = &"UO Stanjel";

	var["_hud_vote_map_header"] = &"Map                                    Votes";

	return var;
}

precache()
{
	var = _local();

	for (i = 0; i < var["maps"].size; i++) {
		precacheString(var["maps"][i][1]);
	}

	precacheString(var["_hud_vote_map_header"]);
}

vote(time, max)
{
	var = _local();

	rotation = getCvar("sv_mapRotation");
	rotation = _parse_rotation(rotation);
	rotation = _remove_map(rotation, getCvar("mapname"));
	rotation = _remove_by_minimal_required(rotation);
	rotation = _add_istrings(rotation);
	rotation = _select_random(rotation, max);

	if (rotation.size == 0) {
		return "mp_harbor";
	} else if (rotation.size == 1) {
		return rotation[0]["map"];
	}

	istrings = [];
	for (i = 0; i < rotation.size; i++) {
		istrings[i] = rotation[i]["map_istring"];
	}

	winner_i = vote\main::vote(time, var["_hud_vote_map_header"], istrings);

	return rotation[winner_i]["map"];
}

_add_istrings(rotation)
{
	var = _local(); // TODO: EFFICIENCY!

	rotation_new = [];
	for (i = 0; i < rotation.size; i++) {
		for (j = 0; j < var["maps"].size; j++) {
			if (var["maps"][j][0] == rotation[i]["map"]) {
				rotation[i]["map_istring"] = var["maps"][j][1];
				rotation_new[rotation_new.size] = rotation[i];
				break;
			}
		}
	}

	return rotation_new;
}

mapname_to_istring(mapname)
{
	var = _local(); // TODO: EFFICIENCY!

	for (i = 0; i < var["maps"].size; i++) {
		if (var["maps"][i][0] == mapname) {
			return var["maps"][i][1];
		}
	}

	return undefined;
}

_remove_by_minimal_required(rotation)
{
	player_size = getEntArray("player", "classname").size;
	rotation_new = [];
	for (i = 0; i < rotation.size; i++) {
		if (!isDefined(rotation[i]["min"]) || player_size >= (int)rotation[i]["min"]) {
			rotation_new[rotation_new.size] = rotation[i];
		}
	}

	return rotation_new;
}

// Remove current map from array.
_remove_map(rotation, map)
{
	rotation_new = [];
	for (i = 0; i < rotation.size; i++) {
		if (rotation[i]["map"] != map) {
			rotation_new[rotation_new.size] = rotation[i];
		}
	}

	return rotation_new;
}

// Turns rotation into array of maps (associative array).
_parse_rotation(rotation)
{
	rotation = util::explode(rotation, " ", 0);

	map = [];
	map_i = 0;

	for (i = 0; i < rotation.size; i++) {
		// If there is no next element, then this rotation is broken.
		if (!isDefined(rotation[i + 1])) {
			break;
		}

		if (rotation[i] == "map") {
			map[map_i]["map"] = rotation[i + 1];
			map_i++;
			i++;
		} else {
			map[map_i][rotation[i]] = rotation[i + 1];
			i++;
		}
	}

	return map;
}

// Randomly select values from an array.
_select_random(arr, s)
{
	if (arr.size <= s) {
		return arr;
	}

	arr_last = arr.size;

	// Set random values to undefined, until size is right.
	while (arr.size > s) {
		// Random number for set of DEFINED values.
		rand = randomInt(arr.size);
		for (i = 0; i < arr_last; i++) {
			if (!isDefined(arr[i])) {
				// Correct the random number to discard UNDEFINED values.
				rand++;
			} else if (rand == i) {
				arr[i] = undefined;
				break;
			}
		}
	}

	new_arr = [];
	for (i = 0; i < arr_last; i++) {
		if (isDefined(arr[i])) {
			new_arr[new_arr.size] = arr[i];
		}
	}

	return new_arr;
}
