// Slow down a speeding player.
start()
{
	self endon("spawned");

	// Walking forward, while rapidly moving left and right, causes a player to speed up significantly.
	// Speed increases of up to +15% have been observed with this technique.
	// Probably similar to strafe jumping and wall running (up to +22% speed increase).
	//
	// This algorithm checks the speed of a player in overlapping (every T) timeframes (TF). It will allow speeding
	// if a player came off the ground in that timeframe to ignore strafe jumping and ladder boosting. It will also
	// attempt to ignore wall runners by using a tracer to check if there's a wall next to them.

	// TODO: Weapons other than bolt.

	// Measure F times within TF seconds, thus with T in between.
	TF = 1.2; // Timeframe to measure speed in.
	T = 0.4; // Interval period.
	F = 3; // Frequency (TF/T).

	speed_limit["stand"] = getCvarInt("g_speed") * level._anti_speeding * 1.15; // speed + error margin + weapon scale speed
	speed_limit["crouch"] = speed_limit["stand"] * 0.65; // crouch factor
	speed_limit["prone"] = speed_limit["stand"] * 0.15; // prone factor

	speed_limit_sq = speed_limit["stand"]*speed_limit["stand"] * TF*TF;

	// A flag that will be set on a stance change or if player goes off ground.
	self.p_speeding_reset = false;
	thread _watch_events();

	// Circular buffer for frames.
	frame = [];

	for (i = 0; self.sessionstate == "playing"; i++) {
		if (i >= F) {
			i = 0;
		}

		if (self.p_speeding_reset) {
			self.p_speeding_reset = false;

			stance = self getStance();
			speed_limit_sq = speed_limit[stance]*speed_limit[stance] * TF*TF;

			frame = [];
			wait T;
			continue;
		}
		
		frame_new = (self.origin[0], self.origin[1], self.angles[1]); // Store yaw in Z axis!!

		if (isDefined(frame[i])) {
			speed_sq = distanceSquared((frame[i][0], frame[i][1], 0), (frame_new[0], frame_new[1], 0));
		} else {
			speed_sq = 0;
		}

		if (speed_sq > speed_limit_sq) {
			// Ignore wall running. This is done only by now, because bullet tracing might be too CPU intensive for
			// every single measurement.
			if (self _is_next_to_wall()) {
				frame = [];
				wait T;
				continue;
			}

			// Check wall running retrospectively.
			wall_run = false;
			for (j = 0; j < F; j++) {
				if (_is_next_to_wall((frame[j][0], frame[j][1], 0), (0, frame[j][2], 0))) {
					wall_run = true;
					break;
				}
			}
			if (wall_run) {
				frame = [];
				wait T;
				continue;
			}

			// Attempt to slow the player down depending on speed.
			factor = speed_limit_sq / speed_sq * 0.9;
			factor *= factor;

			ups = distance((frame[i][0], frame[i][1], 0), (frame_new[0], frame_new[1], 0)) / TF;
			iPrintLn(level.p_prefix + "^1SPEEDING ^7(" + (int)(ups) + " u/s): " + self.name);
			self thread _slow_down(factor, TF);
		}

		frame[i] = frame_new;

		wait T;
	}
}

// Set a flag if stance chances or player goes off the ground.
_watch_events()
{
	stance = self getStance();

	while (self.sessionstate == "playing") {
		stance_new = self getStance();

		if (stance != stance_new || self isOnGround() == false) {
			self.p_speeding_reset = true;
		}

		stance = stance_new;
		wait 0.05;
	}
}

_slow_down(factor, time)
{
	self notify("p_slow_down");
	self endon("p_slow_down");

	self.maxspeed = getCvarInt("g_speed") * factor;
	wait time;
	self.maxspeed = getCvarInt("g_speed");
}

// Test if touching a wall on the player's sides. Does not optimally detect models.
_is_next_to_wall(origin, angles)
{
	// Allow origin and angles to be passed in as parameters. Otherwise get from self.
	if (!isDefined(origin)) {
		origin = self.origin;
		angles = self.angles;
	}

	vr = anglesToRight(angles);
	vf = anglesToForward(angles);
	
	// Measure left and right of the player's feet, just above the ground where an obstacle might be encountered.
	p = (origin[0], origin[1], origin[2] + 16);
	// A wall will be at 15 units of distance. 22 is to include margin if a player looks to or away a little from a wall.
	pl = (p[0] - vr[0]*22, p[1] - vr[1]*22, p[2]);
	pr = (p[0] + vr[0]*22, p[1] + vr[1]*22, p[2]);
	
	// Measure from front and back of the player.
	pf = (p[0] - vf[0]*22, p[1] - vf[1]*22, p[2]);
	pb = (p[0] + vf[0]*22, p[1] + vf[1]*22, p[2]);

	if (bulletTrace(p, pl, false, undefined)["fraction"] < 1 ||
		bulletTrace(p, pr, false, undefined)["fraction"] < 1 ||
		bulletTrace(p, pf, false, undefined)["fraction"] < 1 ||
		bulletTrace(p, pb, false, undefined)["fraction"] < 1){
		return true;
	}

	// If there is no low obstacle, measure from near ground up to detect other kinds of walls (e.g. fence with open
	// bottom) next to the player.
	plt = (pl[0], pl[1], pl[2] + 64);
	prt = (pr[0], pr[1], pr[2] + 64);
	pft = (pf[0], pf[1], pf[2] + 64);
	pbt = (pb[0], pb[1], pb[2] + 64);

	if (bulletTrace(pl, plt, false, undefined)["fraction"] < 1 ||
		bulletTrace(pr, prt, false, undefined)["fraction"] < 1 ||
		bulletTrace(pf, pft, false, undefined)["fraction"] < 1 ||
		bulletTrace(pb, pbt, false, undefined)["fraction"] < 1){
		return true;
	}

	return false;
}