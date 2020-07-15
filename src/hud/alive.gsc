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

	precacheString(&"GAME_ALLIES");
	precacheString(&"GAME_AXIS");

	precacheShader("gfx/hud/hud@objective_" + game["allies"] + ".tga");
	precacheShader("gfx/hud/hud@objective_" + game["axis"] + ".tga");
}

create()
{
	if (isDefined(level._hud_alive)) {
		return;
	}

	local = _local();

	level._hud_alive["allies"] = newHudElem();
	level._hud_alive["allies"].x = 450;
	level._hud_alive["allies"].y = 466;
	level._hud_alive["allies"].alignX = "center";
	level._hud_alive["allies"].alignY = "middle";
	level._hud_alive["allies"].alpha = .33;
	level._hud_alive["allies"].sort = -1;
	level._hud_alive["allies"] setShader("gfx/hud/hud@objective_" + game["allies"] + ".tga", 24, 24);

	level._hud_alive["allies_value"] = newHudElem();
	level._hud_alive["allies_value"].x = 450;
	level._hud_alive["allies_value"].y = 466 - 1;
	level._hud_alive["allies_value"].alignX = "center";
	level._hud_alive["allies_value"].alignY = "middle";
	level._hud_alive["allies_value"].fontScale = .9;
	level._hud_alive["allies_value"] setValue(14);

	level._hud_alive["axis"] = newHudElem();
	level._hud_alive["axis"].x = 450 + 20;
	level._hud_alive["axis"].y = 466;
	level._hud_alive["axis"].alignX = "center";
	level._hud_alive["axis"].alignY = "middle";
	level._hud_alive["axis"].alpha = .33;
	level._hud_alive["axis"].sort = -1;
	level._hud_alive["axis"] setShader("gfx/hud/hud@objective_" + game["axis"] + ".tga", 24, 24);

	level._hud_alive["axis_value"] = newHudElem();
	level._hud_alive["axis_value"].x = 450 + 20;
	level._hud_alive["axis_value"].y = 466 - 1;
	level._hud_alive["axis_value"].alignX = "center";
	level._hud_alive["axis_value"].alignY = "middle";
	level._hud_alive["axis_value"].fontScale = .9;
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
