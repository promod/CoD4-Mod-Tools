init()
{
	level.coptermodel = "vehicle_cobra_helicopter_fly";
	precacheModel(level.coptermodel);
	
	level.copter_maxaccel = 200;
	level.copter_maxvel = 700;
	level.copter_rotspeed = 90; // degrees per second
	level.copter_accellookahead = 2; // seconds
	
	level.copterCenterOffset = (0,0,72);
	level.copterTargetOffset = (0,0,45);
	
	level.copterexplosion = loadfx("explosions/default_explosion");
	level.copterfinalexplosion = loadfx("explosions/large_vehicle_explosion");
}

getAboveBuildingsLocation(location)
{
	trace = bullettrace(location + (0,0,10000), location, false, undefined);
	startorigin = trace["position"] + (0,0,-514);
	
	zpos = 0;
	
	maxxpos = 13; maxypos = 13;
	for (xpos = 0; xpos < maxxpos; xpos++) {
		for (ypos = 0; ypos < maxypos; ypos++) {
			thisstartorigin = startorigin + ((xpos/(maxxpos-1) - .5) * 1024, (ypos/(maxypos-1) - .5) * 1024, 0);
			thisorigin = bullettrace(thisstartorigin, thisstartorigin + (0,0,-10000), false, undefined);
			zpos += thisorigin["position"][2];
		}
	}
	zpos = zpos / (maxxpos*maxypos);
	
	zpos = zpos + 850;
	
	return (location[0], location[1], zpos);
}

vectorAngle(v1, v2)
{
	dot = vectordot(v1, v2);
	if (dot >= 1)
		return 0;
	else if (dot <= -1)
		return 180;
	return acos(dot);
}
vectorTowardsOtherVector(v1, v2, angle)
{
	dot = vectordot(v1, v2);
	if (dot <= -1)
	{
		return v1; // eh
	}
	v3 = vectornormalize(v2 - vecscale(v1, dot));
	
	return vecscale(v1, cos(angle)) + vecscale(v3, sin(angle));
}
veclength(v)
{
	return distance((0,0,0), v);
}

createCopter(location, team, damagetrig)
{
	location = getAboveBuildingsLocation(location);
	
	scriptorigin = spawn("script_origin", location);
	scriptorigin.angles = vectorToAngles((1, 0, 0));
	
	copter = spawn("script_model", location);
	copter.angles = vectorToAngles((0, 1, 0));
	
	copter linkto(scriptorigin);
	scriptorigin.copter = copter;
	copter setModel(level.coptermodel);
	copter playLoopSound("mp_copter_ambience");
	
	damagetrig.origin = scriptorigin.origin;
	damagetrig thread mylinkto(scriptorigin);
	scriptorigin.damagetrig = damagetrig;
	
	scriptorigin.finalDest = location;
	scriptorigin.finalZDest = location[2];
	scriptorigin.desiredDir = (1,0,0);
	scriptorigin.desiredDirEntity = undefined;
	scriptorigin.desiredDirEntityOffset = (0,0,0);
	scriptorigin.vel = (0,0,0);
	scriptorigin.dontascend = false;

	scriptorigin.health = 2000;
	if (getdvar("scr_copter_health") != "")
		scriptorigin.health = getdvarfloat("scr_copter_health");
	
	scriptorigin.team = team;
	
	scriptorigin thread copterAI();
	scriptorigin thread copterDamage(damagetrig);
	
	return scriptorigin;
}

makeCopterPassive()
{
	self.damagetrig notify("unlink");
	self.damagetrig = undefined;

	self notify("passive");

	self.desiredDirEntity = undefined;
	self.desiredDir = undefined;
}
makeCopterActive(damagetrig)
{
	damagetrig.origin = self.origin;
	damagetrig thread mylinkto(self);
	self.damagetrig = damagetrig;
	
	self thread copterAI();
	self thread copterDamage(damagetrig);
}

mylinkto(obj)
{
	self endon("unlink");
	while(1)
	{
		self.angles = obj.angles;
		self.origin = obj.origin;
		wait .1;
	}
}

setCopterDefenseArea(areaEnt)
{
	self.areaEnt = areaEnt;
	self.areaDescentPoints = [];
	if (isdefined(areaEnt.target)) {
		self.areaDescentPoints = getentarray(areaEnt.target, "targetname");
	}
	for (i = 0; i < self.areaDescentPoints.size; i++)
	{
		self.areaDescentPoints[i].targetEnt = getent(self.areaDescentPoints[i].target, "targetname");
	}
}

copterAI()
{
	self thread copterMove();
	self thread copterShoot();
	
	self endon("death");
	self endon("passive");
	
	flying = true;
	descendingEnt = undefined;
	reachedDescendingEnt = false;
	returningToArea = false;
	
	while(1)
	{
		if (!isdefined(self.areaEnt)) {
			wait(1);
			continue;
		}
		
		players = level.players;
		enemyTargets = [];
		if (self.team != "neutral") {
			for (i = 0; i < players.size; i++) {
				if (isalive(players[i]) && isdefined(players[i].pers["team"]) && players[i].pers["team"] != self.team && !isdefined(players[i].usingObj)) {
					playerorigin = players[i].origin;
					playerorigin = (playerorigin[0], playerorigin[1], self.areaEnt.origin[2]);
					if (distance(playerorigin, self.areaEnt.origin) < self.areaEnt.radius)
						enemyTargets[enemyTargets.size] = players[i];
				}
			}
		}
		
		insideTargets = [];
		outsideTargets = [];
		
		skyheight = bullettrace(self.origin, self.origin + (0,0,10000), false, undefined)["position"][2] - 10;
		
		bestTarget = undefined;
		bestWeight = 0;
		for (i = 0; i < enemyTargets.size; i++) {
			inside = false;
			trace = bulletTrace(enemyTargets[i].origin + (0,0,10), enemyTargets[i].origin + (0,0,10000), false, undefined);
			if (trace["position"][2] >= skyheight)
				// outside.
				outsideTargets[outsideTargets.size] = enemyTargets[i];
			else
				// inside.
				insideTargets[insideTargets.size] = enemyTargets[i];
		}
		
		goToPos = undefined;
		calcedGoToPos = false;
		
		oldDescendingEnt = undefined;
		
		// determine if we should change states
		if (flying) {
			if (outsideTargets.size == 0 && insideTargets.size > 0 && self.areaDescentPoints.size > 0) {
				flying = false;
				
				result = determineBestEnt(insideTargets, self.areaDescentPoints, self.origin);
				descendingEnt = result["descendEnt"];
				if (isdefined(descendingEnt))
					goToPos = result["position"];
				else
					flying = true;
			}
		}
		else {
			oldDescendingEnt = descendingEnt;
			if (insideTargets.size == 0) {
				flying = true;
			}
			else {
				// if we can't get a good target, and there are outside targets, give up and fly
				if (outsideTargets.size > 0) {
					if (!isdefined(descendingEnt))
						flying = true;
					else
					{
						calcedGoToPos = true;
						goToPos = determineBestPos(insideTargets, descendingEnt, self.origin);
						if (!isdefined(goToPos))
							flying = true;
					}
				}
				// determine where to go.
				if (isdefined(descendingEnt)) {
					// we're already descended. try to find a good place to shoot into the door/window from.
					if (!calcedGoToPos)
						goToPos = determineBestPos(insideTargets, descendingEnt, self.origin);
				}
				if (!isdefined(goToPos)) {
					result = determineBestEnt(insideTargets, self.areaDescentPoints, self.origin);
					if (isdefined(result["descendEnt"])) {
						descendingEnt = result["descendEnt"];
						goToPos = result["position"];
						reachedDescendingEnt = false;
					}
					else {
						if (isdefined(descendingEnt)) {
							if (isdefined(self.finalDest))
								goToPos = self.finalDest;
							else
								goToPos = descendingEnt.origin;
						}
						else
							goToPos = undefined;
					}
				}
				// couldn't find a place to descend?
				if (!isdefined(goToPos))
					flying = true;
			}
		}
		
		if (flying)
		{
			// determine best target to shoot outside.

			desireddist = 1024*2.5;
			
			distToArea = distance((self.origin[0], self.origin[1], self.areaEnt.origin[2]), self.areaEnt.origin);
			if (outsideTargets.size == 0 && distToArea > self.areaEnt.radius + desireddist*.25)
				returningToArea = true;
			else if (distToArea < self.areaEnt.radius*.5)
				returningToArea = false;
			if (outsideTargets.size == 0 && !returningToArea)
			{
				// no outside targets? look again for any enemies outside the radius we're defending - just so
				// we don't look stupid when we could be making ourself useful.
				if (self.team != "neutral") {
					for (i = 0; i < players.size; i++) {
						if (isalive(players[i]) && isdefined(players[i].pers["team"]) && players[i].pers["team"] != self.team && !isdefined(players[i].usingObj)) {
							playerorigin = players[i].origin;
							playerorigin = (playerorigin[0], playerorigin[1], self.areaEnt.origin[2]);
							if (distance(players[i].origin, self.areaEnt.origin) > self.areaEnt.radius)
								outsideTargets[outsideTargets.size] = players[i];
						}
					}
				}
			}
			
			best = undefined;
			bestdist = 0;
			for (i = 0; i < outsideTargets.size; i++)
			{
				dist = abs(distance(outsideTargets[i].origin, self.origin) - desireddist);
				if (!isdefined(best) || dist < bestdist) {
					best = outsideTargets[i];
					bestdist = dist;
				}
			}
			
			if (isdefined(best)) {
				// determine best position to go to to get target.
				attackpos = best.origin + level.copterTargetOffset;
				goToPos = determineBestAttackPos(attackpos, self.origin, desireddist);
	
				//iprintln("going to flying attack pos");
	
				self setCopterDest(goToPos, false);
	
				self.desiredDir = vectornormalize(attackpos - goToPos);
				self.desiredDirEntity = best;
				self.desiredDirEntityOffset = level.copterTargetOffset;
				
				wait(1);
			}
			else {
				goToPos = getRandomPos(self.areaEnt.origin, self.areaEnt.radius);
				self setCopterDest(goToPos, false);
				
				//iprintln("going to random pos");
				
				self.desiredDir = undefined;
				self.desiredDirEntity = undefined;
				
				wait(1);
			}
		}
		else
		{
			if (distance(self.origin, descendingEnt.origin) < descendingEnt.radius)
				reachedDescendingEnt = true;

			//iprintln("going to descent pos");

			goDirectly = (isdefined(oldDescendingEnt) && oldDescendingEnt == descendingEnt);
			goDirectly = goDirectly && reachedDescendingEnt;
			
			self.desiredDir = vectornormalize(descendingEnt.targetEnt.origin - (goToPos - level.copterCenterOffset));
			self.desiredDirEntity = descendingEnt.targetEnt;
			self.desiredDirEntityOffset = (0,0,0);
			
			if (goToPos != self.origin) {
				self setCopterDest(goToPos - level.copterCenterOffset, true, goDirectly);
				wait(.3);
			}
			else
				wait(.3);
		}
	}
}

// determines the best position to go to within descendEnt
// from where a target is visible. if no such positions, 
// returns undefined.
determineBestPos(targets, descendEnt, startorigin)
{
	targetpos = descendEnt.targetEnt.origin;
	circleradius = distance(targetpos, descendEnt.origin);
	
	
	bestpoint = undefined;
	bestdist = 0;
	for (i = 0; i < targets.size; i++)
	{
		enemypos = targets[i].origin + level.copterTargetOffset;
		passed = bullettracepassed(enemypos, targetpos, false, undefined);
		if (passed) {
			dir = targetpos - enemypos;
			dir = (dir[0], dir[1], 0);
			isect = vecscale(vectornormalize(dir),circleradius) + targetpos;
			isect = (isect[0], isect[1], descendEnt.origin[2]);
			
			dist = distance(isect, descendEnt.origin);
			if (dist <= descendEnt.radius) {
				dist = distance(isect, startorigin);
				if (!isdefined(bestpoint) || dist < bestdist) {
					bestdist = dist;
					bestpoint = isect;
				}
			}
		}
	}
	return bestpoint;
}
// determines the best entity out of descendEnts to go to
// in order to get at one of targets.
// result["descendEnt"] is the winning entity,
// result["position"] is the position to go to.
determineBestEnt(targets, descendEnts, startorigin)
{
	result = [];
	
	bestpos = undefined;
	bestent = 0;
	bestdist = 0;
	for (i = 0; i < descendEnts.size; i++)
	{
		thispos = determineBestPos(targets, descendEnts[i], startorigin);
		if (isdefined(thispos)) {
			thisdist = distance(thispos, startorigin);
			if (!isdefined(bestpos) || thisdist < bestdist) {
				bestpos = thispos;
				bestent = i;
				bestdist = thisdist;
			}
		}
	}
	
	if (isdefined(bestpos)) {
		result["descendEnt"] = descendEnts[bestent];
		result["position"] = bestpos;
		return result;
	}
	
	result["descendEnt"] = undefined;
	return result;
}

determineBestAttackPos(targetpos, curpos, desireddist)
{
	targetposcopterheight = (targetpos[0], targetpos[1], curpos[2]);
	attackdirx = curpos - targetposcopterheight;
	attackdirx = vectornormalize(attackdirx);
	attackdiry = (0-attackdirx[1], attackdirx[0], 0);
	
	bestpos = undefined;
	bestdist = 0;
	for (i = 0; i < 8; i++) {
		theta = (i/8.0) * 360;
		thisdir = vecscale(attackdirx, cos(theta)) + vecscale(attackdiry, sin(theta));
		traceend = targetposcopterheight + vecscale(thisdir, desireddist);
		
		losexists = bullettracepassed(targetpos, traceend, false, undefined);
		if (losexists) {
			thisdist = distance(traceend, curpos);
			if (!isdefined(bestpos) || thisdist < bestdist) {
				bestpos = traceend;
				bestdist = thisdist;
			}
		}
	}
	
	goToPos = undefined;
	if (isdefined(bestpos)) {
		goToPos = bestpos;
	}
	else {
		dist = distance(targetposcopterheight, curpos);
		if (dist > desireddist)
			goToPos = self.origin + vecscale(vectornormalize(attackdirx), 0-(dist - desireddist));
		else
			goToPos = self.origin;
	}
	return goToPos;
}

getRandomPos(origin, radius)
{
	// no sqrt so have to do this the guess and check way.
	
	pos = origin + ((randomfloat(2)-1)*radius, (randomfloat(2)-1)*radius, 0);
	while(distanceSquared(pos, origin) > radius*radius)
		pos = origin + ((randomfloat(2)-1)*radius, (randomfloat(2)-1)*radius, 0);
	
	return pos;
}

copterShoot()
{
	self endon("death");
	self endon("passive");
	
	cosThreshold = cos(10);
	while(1)
	{
		if (isdefined(self.desiredDirEntity) && isdefined(self.desiredDirEntity.origin)) {
			mypos = self.origin + level.copterCenterOffset;
			enemypos = self.desiredDirEntity.origin + self.desiredDirEntityOffset;
			curdir = anglesToForward(self.angles);
			enemydirraw = enemypos - mypos;
			enemydir = vectornormalize(enemydirraw);
			
			if (vectordot(curdir, enemydir) > cosThreshold)
			{
				canseetarget = bullettracepassed(mypos, enemypos, false, undefined);
				if (!canseetarget && isplayer(self.desiredDirEntity) && isalive(self.desiredDirEntity))
					canseetarget = bullettracepassed(mypos, self.desiredDirEntity getEye(), false, undefined);
				if (canseetarget) {
					// shoot.
					self playSound("mp_copter_shoot");
					numshots = 20;
					for (i = 0; i < numshots; i++)
					{
						mypos = self.origin + level.copterCenterOffset;
						/*if (isdefined(self.desiredDirEntity)) {
							enemypos = self.desiredDirEntity.origin + self.desiredDirEntityOffset;
							enemydirraw = enemypos - mypos;
							enemydir = vectornormalize(enemydirraw);
							dir = enemydir;
						}
						else*/
							dir = anglesToForward(self.angles);

						dir = dir + ((randomfloat(2)-1)*.015, (randomfloat(2)-1)*.015, (randomfloat(2)-1)*.015);
						dir = vectornormalize(dir);
						self myMagicBullet(mypos, dir);
						wait(.075);
					}
					wait(.25);
				}
				//else
					//iprintln("can't see");
			}
			//else
				//iprintln("below cosThreshold: ", vectordot(curdir, enemydir), " < ", cosThreshold);
		}
		//else
			//iprintln("no target");
		wait(.25);
	}
}
myMagicBullet(pos, dir)
{
	damage = 20;
	if (getdvar("scr_copter_damage") != "")
		damage = getdvarint("scr_copter_damage");
	
	// for now just shoot from origin
	trace = bullettrace(pos, pos + vecscale(dir, 10000), true, undefined);
	if (isdefined(trace["entity"]) && isplayer(trace["entity"]) && isalive(trace["entity"])) {
		// hurt entity shot at
		trace["entity"] thread [[level.callbackPlayerDamage]](
			self, // eInflictor The entity that causes the damage.(e.g. a turret)
			self, // eAttacker The entity that is attacking.
			damage, // iDamage Integer specifying the amount of damage done
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			"MOD_RIFLE_BULLET", // sMeansOfDeath Integer specifying the method of death
			"copter", // sWeapon The weapon number of the weapon used to inflict the damage
			self.origin, // vPoint The point the damage is from?
			dir, // vDir The direction of the damage
			"none", // sHitLoc The location of the hit
			0 // psOffsetTime The time offset for the damage
		);
	}
	//line(pos, trace["position"], (1,1,1));
}

setCopterDest(newlocation, descend, dontascend)
{
	self.finalDest = getAboveBuildingsLocation(newlocation);
	if (isdefined(descend) && descend)
		self.finalZDest = newlocation[2];
	else
		self.finalZDest = self.finalDest[2];
		
	self.intransit = true;
	self.dontascend = false;
	if (isdefined(dontascend))
		self.dontascend = dontascend;
}
notifyArrived()
{
	wait .05;
	self notify("arrived");
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

abs(x)
{
	if (x < 0)
		return 0-x;
	return x;
}

copterMove()
{
	self endon("death");
	
	if (isdefined(self.copterMoveRunning))
		return;
	self.copterMoveRunning = true;
	
	self.intransit = false;
	interval = .15;
	zinterp = .1;
	tiltamnt = 0;
	while(1)
	{
		horizDistSquared = distanceSquared((self.origin[0], self.origin[1], 0), (self.finalDest[0], self.finalDest[1], 0));
		
		doneMoving = horizDistSquared < 10*10;
		
		//if (!doneMoving)
		{
			nearDest = (horizDistSquared < 256*256);
			
			self.intransit = true;
			
			desiredZ = 0;
			
			// movement
			movingHorizontally = true;
			movingVertically = false;
			if (self.dontascend)
				movingVertically = true;
			else {
				// if we're not near our horizontal goal position
				if (!nearDest) {
					// get the z position we *want* to have before moving horizontally
					desiredZ = getAboveBuildingsLocation(self.origin)[2];
					movingHorizontally = (abs(self.origin[2] - desiredZ) <= 256); // we're moving horizontally if we're up high enough to do so
					movingVertically = !movingHorizontally; // we're moving vertically if we aren't
				}
				// if we are near our horizontal goal position
				else
					movingVertically = true;
			}
			
			// determine our destination
			if (movingHorizontally) {
				if (movingVertically)
					thisDest = (self.finalDest[0], self.finalDest[1], self.finalZDest);
				else
					thisDest = self.finalDest;
			}
			else {
				assert(movingVertically);
				thisDest = (self.origin[0], self.origin[1], desiredZ);
			}
			
			movevec = thisDest - self.origin;
			
			idealAccel = vecscale(thisDest - (self.origin + vecscale(self.vel, level.copter_accellookahead)), interval);
			vlen = veclength(idealAccel);
			if (vlen > level.copter_maxaccel) {
				idealAccel = vecscale(idealAccel, level.copter_maxaccel / vlen);
			}
			
			self.vel = self.vel + idealAccel;
			vlen = veclength(self.vel);
			if (vlen > level.copter_maxvel) {
				self.vel = vecscale(self.vel, level.copter_maxvel / vlen);
			}
			
			thisDest = self.origin + vecscale(self.vel, interval);
			
			self moveto(thisDest, interval*.999);
			
			speed = veclength(self.vel);
			
			if (isdefined(self.desiredDirEntity) && isdefined(self.desiredDirEntity.origin)) {
				self.destDir = vectornormalize((self.desiredDirEntity.origin + self.desiredDirEntityOffset) - (self.origin + level.copterCenterOffset));
			}
			else if (isdefined(self.desiredDir)) {
				self.destDir = self.desiredDir;
			}
			else if (movingVertically) {
				self.destDir = anglesToForward(self.angles);
				self.destDir = vectornormalize((self.destDir[0], self.destDir[1], 0));
			}
			else {
				tiltamnt = speed / level.copter_maxvel;
				tiltamnt = (tiltamnt - .1) / .9; if (tiltamnt < 0) tiltamnt = 0;

				self.destDir = movevec;
				self.destDir = vectornormalize((self.destDir[0], self.destDir[1], 0)); // remove z component
				tiltamnt = tiltamnt * (1 - (vectorAngle(anglesToForward(self.angles), self.destDir) / 180));
				self.destDir = vectornormalize((self.destDir[0], self.destDir[1], tiltamnt * -.4)); // tilt forward while moving
			}
		}
		/*else {
			if (self.intransit) {
				self.intransit = false;
				self.dontascend = false;
				
				// if we descended to get to this point, we'll be ascending to get out
				if (self.finalZDest != self.finalDest[2])
					self.ascending = true;
				
				self notify("arrived");
			}
			
			if (isdefined(self.desiredDir))
				self.destDir = self.desiredDir;
			else {
				self.destDir = anglesToForward(self.angles);
				self.destDir = vectornormalize((self.destDir[0], self.destDir[1], 0));
			}
		}*/
		
		// rotation
		newdir = self.destDir;
		//line(self.origin + level.copterCenterOffset, self.origin + level.copterCenterOffset + vecscale(self.destDir,10000), (1,0,0));
		if (newdir[2] < -.4) {// *never* look too far down
			newdir = vectornormalize((newdir[0], newdir[1], -.4));
		}
		//line(self.origin + level.copterCenterOffset, self.origin + level.copterCenterOffset + vecscale(newdir,10000), (1,1,0));
		
		copterangles = self.angles;
		copterangles = combineangles(copterangles, (0,90,0));
		olddir = anglesToForward(copterangles);
		
		thisRotSpeed = level.copter_rotspeed;
		//if (movelen < 256)
		//	thisRotSpeed = thisRotSpeed * movelen / 256;
		
		olddir2d = vectornormalize((olddir[0], olddir[1], 0));
		newdir2d = vectornormalize((newdir[0], newdir[1], 0));
		
		angle = vectorAngle(olddir2d, newdir2d);
		angle3d = vectorAngle(olddir, newdir);
		
		if (angle > .001 && thisRotSpeed > .001) {
			thisangle = thisRotSpeed * interval;
			if (thisangle > angle)
				thisangle = angle;
				
			newdir2d = vectorTowardsOtherVector(olddir2d, newdir2d, thisangle);
			oldz = olddir[2]/veclength((olddir[0], olddir[1], 0));
			newz = newdir[2]/veclength((newdir[0], newdir[1], 0));
			interpz = oldz + (newz - oldz) * (thisangle / angle);
			newdir = vectornormalize((newdir2d[0], newdir2d[1], interpz));
			
			copterangles = vectorToAngles(newdir);
			copterangles = combineangles(copterangles, (0,-90,0));
			self rotateto(copterangles, interval*.999);
		}
		else if (angle3d > .001 && thisRotSpeed > .001) {
			// need to rotate vertically
			thisangle = thisRotSpeed * interval;
			if (thisangle > angle3d)
				thisangle = angle3d;
				
			newdir = vectorTowardsOtherVector(olddir, newdir, thisangle);
			newdir = vectornormalize(newdir);
			
			copterangles = vectorToAngles(newdir);
			copterangles = combineangles(copterangles, (0,-90,0));
			self rotateto(copterangles, interval*.999);
		}

		wait interval;
	}
}

copterDamage(damagetrig)
{
	self endon("passive");
	
	while(1)
	{
		damagetrig waittill("damage", amount, attacker);
		
		// disallow friendly fire
		if (isdefined(attacker) && isplayer(attacker) && isdefined(attacker.pers["team"]) && attacker.pers["team"] == self.team)
			continue;
		
		self.health -= amount;
		if (self.health <= 0) {
			self thread copterDie();
			return;
		}
		//iprintln("OW ", amount);
	}
}

copterDie()
{
	self endon("passive");
	
	self notify("death");
	self.dead = true;
	
	self thread copterExplodeFX();
	
	// crash.
	interval = .2;
	rottime = 15;
	self rotateyaw(360 + randomfloat(360), rottime);
	self rotatepitch(360 + randomfloat(360), rottime);
	self rotateroll(360 + randomfloat(360), rottime);
	while(1)
	{
		self.vel = self.vel + vecscale((0,0,-200), interval);
		newpos = self.origin + vecscale(self.vel, interval);
		
		// check for collision with ground
		pathclear = bullettracepassed(self.origin, newpos, false, undefined);
		if (!pathclear)
			break;
		
		self moveto(newpos, interval*.999);
		
		wait (interval);
	}
	
	playfx (level.copterfinalexplosion, self.origin);
	fakeself = spawn("script_origin", self.origin);
	fakeself playsound("mp_copter_explosion");
	self notify("finaldeath");
	
	deleteCopter();
	
	wait(2);
	fakeself delete();
}
deleteCopter()
{
	if (isdefined(self.damagetrig)) {
		self.damagetrig notify("unlink");
		self.damagetrig = undefined;
	}
	self.copter delete();
	self delete();
}
copterExplodeFX()
{
	self endon("finaldeath");

	while(1)
	{
		playfx (level.copterexplosion, self.origin);
		self playsound("mp_copter_explosion");
		wait .5 + randomfloat(1);
	}
}
