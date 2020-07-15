precache()
{
	if (game["_hud_alive"]) {
		hud\alive::precache();
	}

	if (game["_hud_hit_blip"]) {
		hud\hit_blip::precache();
	}
}
