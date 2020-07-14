start()
{
	if (level._anti_fastshoot || level._anti_aimrun) {
		thread monitor\weapon::start(level._anti_fastshoot, level._anti_aimrun);
	}

	if (level._anti_speeding) {
		thread monitor\speed::start();
	}

	if (level._allow_drop) {
		thread monitor\weapon_drop::start();
	}
}
