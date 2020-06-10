watchPlayerFastShoot()
{
	self endon("spawned");

	while (self.sessionstate == "playing") {
		// Reference clip count.
		a1 = self getWeaponSlotClipAmmo("primary");
		b1 = self getWeaponSlotClipAmmo("primaryb");

		// Wait for clip ammo to change.
		do {
			wait 0.05;

			if (self.sessionstate != "playing") {
				return;
			}

			a2 = self getWeaponSlotClipAmmo("primary");
			b2 = self getWeaponSlotClipAmmo("primaryb");
		} while (a1 == a2 && b1 == b2);

		// Check for reload.
		if (a1 < a2 || b1 < b2) {
			continue;
		}

		a1 = a2;
		b1 = b2;

		wait level.p_afs_time;

		if (self.sessionstate != "playing") {
			return;
		}

		a2 = self getWeaponSlotClipAmmo("primary");
		b2 = self getWeaponSlotClipAmmo("primaryb");

		if (a2 < a1 || b2 < b1) {
			iPrintLn(level.p_prefix +  "^1FASTSHOOT^7: " + self.name);
		}
	}
}

watchPlayerAimRun()
{
	self endon("spawned");

	while (self.sessionstate == "playing") {
		// Reference clip count.
		a1 = self getWeaponSlotClipAmmo("primary");
		b1 = self getWeaponSlotClipAmmo("primaryb");

		// Wait for clip ammo to change.
		do {
			wait 0.05;

			if (self.sessionstate != "playing") {
				return;
			}

			a2 = self getWeaponSlotClipAmmo("primary");
			b2 = self getWeaponSlotClipAmmo("primaryb");
		} while (a1 == a2 && b1 == b2);

		// If neither clip count was increased, nothing was reloaded.
		if (a2 <= a1 && b2 <= b1) {
			continue;
		}

		// Rough time between clip change and end of reloading animation.
		wait 1;

		// Keep toggling weapon if aim run glitching.
		while (self attackButtonPressed()) {
			self disableWeapon();
			wait 0.05;
			self enableWeapon();
		}
	}
}

// Slow down a speeding player.
watchPlayerSpeed()
{
	// Walking forward, while rapidly moving left and right, causes a player to speed up significantly.
	// Speed increases of up to +15% have been observed with this technique.
	// Probably similar to strafe jumping and wall running (up to +22% speed increase).
	//
	// This algorithm checks the speed of a player in overlapping (every T) timeframes (TF). It will allow speeding
	// if a player came off the ground in that timeframe to ignore strafe jumping and ladder boosting. It will also
	// attempt to ignore wall runners by using a tracer to check if there's a wall next to their feet.

	// TODO: Crouching (and proning). And weapons other than bolt.

	// Measure F times within TF seconds, thus with T in between.
	TF = 1.2; // Timeframe to measure speed in.
	T = 0.4; // Interval period.
	F = 3; // Frequency (TF/T).

	speed_limit = 225 * TF;
	speed_limit_sq = speed_limit * speed_limit;
	
	frame = [];
	for (i = 0; i < F; i++) {
		frame[i]["origin"] = (self.origin[0], self.origin[1], 0);
		frame[i]["ground"] = true;
	}

	for (i = 0; self.sessionstate == "playing"; i++) {
		if (i >= F) {
			i = 0;
		}

		origin_new = (self.origin[0], self.origin[1], 0);
		ground_new = self isOnGround();

		speed_sq = distanceSquared(frame[i]["origin"], origin_new);

		if (speed_sq > speed_limit_sq) {
			ground_count = 0 + ground_new;
			for (j = 0; j < F; j++) {
				ground_count += frame[j]["ground"];
			}

			if (self is_next_to_wall()) {
				wait TF;
				origin_new = (self.origin[0], self.origin[1], 0);
				for (i = 0; i < F; i++) {
					frame[i]["origin"] = origin_new;
				}
				
				continue;
			}

			if (ground_count > F) {
				iPrintLn(level.p_prefix + "^1SPEEDING ^7(slowing down)");
				self thread slow_down(0.8);

				// Reset frame so this doesn't trigger immediately after.
				for (i = 0; i < F; i++) {
					frame[i]["origin"] = origin_new;
				}
			}
		}

		frame[i]["origin"] = origin_new;
		frame[i]["ground"] = ground_new;

		wait T;
	}
}

slow_down(factor)
{
	self notify("p_slow_down");
	self endon("p_slow_down");

	self.maxspeed = getCvarInt("g_speed") * factor;
	wait 1;
	self.maxspeed = getCvarInt("g_speed");
}

// Test if touching a wall on the player's sides. Does not optimally detect models.
is_next_to_wall()
{
	vr = anglesToRight(self.angles);

	// Measure left and right of the player's feet, just above the ground where an obstacle might be encountered.
	p = (self.origin[0], self.origin[1], self.origin[2] + 16);
	// A wall will be at 15 units of distance. 17 is to include margin if a player looks to or away a little from a wall.
	pl = (p[0] - vr[0]*17, p[1] - vr[1]*17, p[2]);
	pr = (p[0] + vr[0]*17, p[1] + vr[1]*17, p[2]);

	if (bulletTrace(p, pl, false)["fraction"] < 1 ||
		bulletTrace(p, pr, false)["fraction"] < 1) {
		return true;
	}

	// If there is no low obstacle, measure from near ground up to detect other kinds of walls (e.g. fence with open
	// bottom) next to the player.
	plt = (pl[0], pl[1], pl[2] + 64);
	prt = (pr[0], pr[1], pr[2] + 64);

	if (bulletTrace(pl, plt, false)["fraction"] < 1 ||
		bulletTrace(pr, prt, false)["fraction"] < 1) {
		return true;
	}

	return false;
}
