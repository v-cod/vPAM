// TODO: For non-team gametypes too.

_local()
{
	var["allies"] = &"ALLIES LEFT: ";
	var["axis"] = &"AXIS LEFT: ";

	return var;
}

precache()
{
	local = _local();

	precacheString(local["allies"]);
	precacheString(local["axis"]);
}

create()
{
	if (isDefined(level._hud_alive)) {
		return;
	}

	local = _local();

	level._hud_alive["allies"] = newHudElem();
	level._hud_alive["allies"].x = 392;
	level._hud_alive["allies"].y = 454;
	level._hud_alive["allies"].fontScale = .75;
	level._hud_alive["allies"].label = local["allies"];

	level._hud_alive["allies_value"] = newHudElem();
	level._hud_alive["allies_value"].x = 464;
	level._hud_alive["allies_value"].y = 454;
	level._hud_alive["allies_value"].alignX = "right";
	level._hud_alive["allies_value"].fontScale = .75;
	level._hud_alive["allies_value"] setValue(0);

	level._hud_alive["axis"] = newHudElem();
	level._hud_alive["axis"].x = 392;
	level._hud_alive["axis"].y = 464;
	level._hud_alive["axis"].fontScale = .75;
	level._hud_alive["axis"].label = local["axis"];

	level._hud_alive["axis_value"] = newHudElem();
	level._hud_alive["axis_value"].x = 464;
	level._hud_alive["axis_value"].y = 464;
	level._hud_alive["axis_value"].alignX = "right";
	level._hud_alive["axis_value"].fontScale = .75;
	level._hud_alive["axis_value"] setValue(0);
}

update()
{
	// Assure existence of HUD elements.
	create();

	allies = 0;
	axis = 0;

	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++) {
		if (players[i].sessionstate != "playing") {
			continue;
		}

		if (players[i].pers["team"] == "allies") {
			allies++;
		} else if (players[i].pers["team"] == "axis") {
			axis++;
		}
	}

	level._hud_alive["allies_value"] setValue(allies);
	level._hud_alive["axis_value"] setValue(axis);
}
