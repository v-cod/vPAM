start()
{
	if (level._jumper) {
		thread monitor\jumper::start();
	}
	
	if (level._afk_to_spec || level._fence) {
		thread monitor\position::start(level._afk_to_spec, level._fence);
	}

	if (level._anti_fastshoot || level._anti_aimrun) {
		thread monitor\weapon::start(level._anti_fastshoot, level._anti_aimrun);
	}

	if (level._anti_speeding) {
		thread monitor\speed::start();
	}

	if (level._sprint) {
		thread monitor\sprint::start(level._sprint, level._sprint_time, level._sprint_time_recover);
	}

	if (level._allow_drop) {
		thread monitor\weapon_drop::start();
	}
}
