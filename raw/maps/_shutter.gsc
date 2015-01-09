#include maps\_utility;
#include common_scripts\utility;

main()
{
	if (!isdefined (level.windStrength))
		level.windStrength = 0.2;
	
	
	//WIND SETTINGS
	//-------------
	level.animRate["awning"] = 1.0;
	level.animRate["palm"] = 1.0;
	level.animWeightMin = (level.windStrength - 0.5);
	level.animWeightMax = (level.windStrength + 0.2);
	//clamp values
	if (level.animWeightMin < 0.1)
		level.animWeightMin = 0.1;
	if (level.animWeightMax > 1.0)
		level.animWeightMax = 1.0;
	//-------------
	//-------------
	
	
	
	level.inc = 0;
	awningAnims();
	palmTree_anims();
	
	array_levelthread (getentarray("wire","targetname"), ::wireWander);
	array_levelthread (getentarray("awning","targetname"), ::awningWander);
	array_levelthread (getentarray("palm","targetname"), ::palmTrees);

	leftShutters = getentarray ("shutter_left","targetname");
	addShutters = getentarray ("shutter_right_open","targetname");
	for (i=0;i<addShutters.size;i++)
		leftShutters[leftShutters.size] = addShutters[i];
	addShutters = getentarray ("shutter_left_closed","targetname");
	for (i=0;i<addShutters.size;i++)
		leftShutters[leftShutters.size] = addShutters[i];
		
	for (i=0;i<leftShutters.size;i++)
	{
		shutter = leftShutters[i];
		shutter rotateto((shutter.angles[0], shutter.angles[1] + 180, shutter.angles[2]), 0.1);
	}
	wait (0.2);

	for (i=0;i<leftShutters.size;i++)
		leftShutters[i].startYaw = leftShutters[i].angles[1];

	rightShutters = getentarray ("shutter_right","targetname");
	addShutters = getentarray ("shutter_left_open","targetname");
	for (i=0;i<addShutters.size;i++)
		rightShutters[rightShutters.size] = addShutters[i];
	addShutters = getentarray ("shutter_right_closed","targetname");
	for (i=0;i<addShutters.size;i++)
		rightShutters[rightShutters.size] = addShutters[i];
	
	for (i=0;i<rightShutters.size;i++)
		rightShutters[i].startYaw = rightShutters[i].angles[1];

	addShutters = undefined;	

	windDirection = "left";
	for (;;)
	{
		array_levelthread (leftShutters, ::shutterWanderLeft, windDirection);
		array_levelthread (rightShutters, ::shutterWanderRight, windDirection);
		level waittill ("wind blows", windDirection);
	}
}

windController()
{
	for (;;)
	{
		windDirection = "left";
		if (randomint(100) > 50)
			windDirection = "right";
		level notify ("wind blows", windDirection);
		wait (2 + randomfloat(10));
	}
}

shutterWanderLeft(shutter, windDirection)
{
//	println ("shutter angles ", shutter.angles[1]);
//	assert (shutter.angles[1] >= shutter.startYaw);
//	assert (shutter.angles[1] < shutter.startYaw + 180);
	
//	println ("Wind + ", level.inc);
	level.inc++;
	level endon ("wind blows");

	newYaw = shutter.startYaw;
	if (windDirection == "left")
		newYaw += 179.9;
			
	newTime = 0.2;
	shutter rotateto((shutter.angles[0], newYaw, shutter.angles[2]), newTime);
	wait (newTime + 0.1);
	
	shutter thread shutterSound();
	
	for (;;)
	{
		shutter notify ("shutterSound");
		rot = randomint(80);
		if (randomint(100) > 50)
			rot *= -1;
			
		newYaw = shutter.angles[1] + rot;
		altYaw = shutter.angles[1] + (rot*-1);
		if ((newYaw < shutter.startYaw) || (newYaw > shutter.startYaw + 179))
		{
			newYaw = altYaw;
		}
			
		dif = abs(shutter.angles[1] - newYaw);
		
		newTime = dif*0.02 + randomfloat(2);
		if (newTime < 0.3)
			newTime = 0.3;
//		println ("startyaw " + shutter.startyaw + " newyaw " + newYaw);
		
//		assert (newYaw >= shutter.startYaw);
//		assert (newYaw < shutter.startYaw + 179);
		
		shutter rotateto((shutter.angles[0], newYaw, shutter.angles[2]), newTime, newTime * 0.5, newTime * 0.5);
		wait (newTime);
	}
}


shutterWanderRight(shutter, windDirection)
{
//	println ("shutter angles ", shutter.angles[1]);
//	assert (shutter.angles[1] >= shutter.startYaw);
//	assert (shutter.angles[1] < shutter.startYaw + 180);
	
//	println ("Wind + ", level.inc);
	level.inc++;
	level endon ("wind blows");

	newYaw = shutter.startYaw;
	if (windDirection == "left")
		newYaw += 179.9;
			
	newTime = 0.2;
	shutter rotateto((shutter.angles[0], newYaw, shutter.angles[2]), newTime);
	wait (newTime + 0.1);
	shutter thread shutterSound();
	
	for (;;)
	{
		shutter notify ("shutterSound");
		rot = randomint(80);
		if (randomint(100) > 50)
			rot *= -1;
			
		newYaw = shutter.angles[1] + rot;
		altYaw = shutter.angles[1] + (rot*-1);
		if ((newYaw < shutter.startYaw) || (newYaw > shutter.startYaw + 179))
		{
			newYaw = altYaw;
		}
			
		dif = abs(shutter.angles[1] - newYaw);
		
		newTime = dif*0.02 + randomfloat(2);
		if (newTime < 0.3)
			newTime = 0.3;
//		println ("startyaw " + shutter.startyaw + " newyaw " + newYaw);
		
//		assert (newYaw >= shutter.startYaw);
//		assert (newYaw < shutter.startYaw + 179);
		
		shutter rotateto((shutter.angles[0], newYaw, shutter.angles[2]), newTime, newTime * 0.5, newTime * 0.5);
		wait (newTime);
	}
}

shutterSound()
{
	for (;;)
	{
		self waittill ("shutterSound");
		self playsound ("shutter_move","sounddone");
		self waittill ("sounddone");
		wait (randomfloat(2));
	}
}

wireWander (wire)
{
	origins = getentarray (wire.target,"targetname");
	org1 = origins[0].origin;
	org2 = origins[1].origin;
	
	angles = vectortoangles (org1 - org2);
	ent = spawn ("script_model",(0,0,0));
	ent.origin = vectorScale(org1, 0.5) + vectorScale(org2, 0.5);
//	ent setmodel ("temp");
	ent.angles = angles;
	wire linkto (ent);
	rottimer = 2;
	rotrange = 0.9;
	dist = 4 + randomfloat(2);
	ent rotateroll(dist*0.5,0.2);
	wait (0.2);
	for (;;)
	{
		rottime = rottimer + randomfloat (rotRange) - (rotRange * 0.5);
		ent rotateroll(dist,rottime, rottime*0.5, rottime*0.5);
		wait (rottime);
		ent rotateroll(dist * -1,rottime, rottime*0.5, rottime*0.5);
		wait (rottime);
	}
}

#using_animtree("desert_props");
awningAnims()
{
/*
	level.scr_anim["2x4 awning"]["wind"][0]			= (%awning_2x4_wind_medium);
	level.scr_anim["2x4 awning"]["wind"][1]			= (%awning_2x4_wind_still);
	
	level.scr_anim["2x5 awning"]["wind"][0]			= (%awning_2x4_wind_medium);
	level.scr_anim["2x5 awning"]["wind"][1]			= (%awning_2x4_wind_still);
	
	level.scr_anim["5x11 awning"]["wind"][0]		= (%awning_5x11_wind_medium);
	level.scr_anim["5x11 awning"]["wind"][1]		= (%awning_5x11_wind_still);
	
	level.scr_anim["desert awning"]["wind"][0]		= (%awning_desert_market_medium);
	level.scr_anim["desert awning"]["wind"][1]		= (%awning_desert_market_still);
*/
}

awningWander(ent)
{
/*
	ent useAnimTree( #animtree );
	
	switch (ent.model)
	{
		case "awning_2x4_1":
		case "awning_2x4_2":
		case "awning_2x4_3":
		case "awning_2x4_4":
		case "awning_2x4_5":
			ent.animname = "2x4 awning";
			break;
		case "awning_2x5_1":
		case "awning_2x5_2":
			ent.animname = "2x5 awning";
			break;
		case "awning_2-5x11":
			ent.animname = "5x11 awning";
			break;
		case "awning_desert_market_small":
		case "awning_desert_market_medium1":
		case "awning_desert_market_medium2":
		case "awning_desert_market_large":
		case "awning_desert_market_large2":
			ent.animname = "desert awning";
			break;
	}
	
	if (!isdefined (ent.animname))
		return;
	
	wait randomfloat(2);
	
	for (;;)
	{
		fWeight = (level.animWeightMin + randomfloat((level.animWeightMax - level.animWeightMin)) );
		fLength = 4;
		
		//setanim(anim, goalWeight, goalTime, rate)
		ent setanim(level.scr_anim[ent.animname]["wind"][0], fWeight, fLength, level.animRate["awning"]);
		ent setanim(level.scr_anim[ent.animname]["wind"][1], 1 - fWeight, fLength, level.animRate["awning"]);
		wait (1 + randomfloat(3));
	}
*/
}

#using_animtree("animated_props");
palmTree_anims()
{
	return;

/*	
	level.scr_anim["tree_desertpalm01"]["wind"][0]			= (%tree_desertpalm01_strongwind);
	level.scr_anim["tree_desertpalm01"]["wind"][1]			= (%tree_desertpalm01_still);
	
	level.scr_anim["tree_desertpalm02"]["wind"][0]			= (%tree_desertpalm02_strongwind);
	level.scr_anim["tree_desertpalm02"]["wind"][1]			= (%tree_desertpalm02_still);
	
	level.scr_anim["tree_desertpalm03"]["wind"][0]			= (%tree_desertpalm03_strongwind);
	level.scr_anim["tree_desertpalm03"]["wind"][1]			= (%tree_desertpalm03_still);
*/
}

palmTrees(ent)
{
	ent useAnimTree( #animtree );
	
	switch (ent.model)
	{
		case "tree_desertpalm01":
			ent.animname = "tree_desertpalm01";
			break;
		case "tree_desertpalm02":
			ent.animname = "tree_desertpalm02";
			break;
		case "tree_desertpalm03":
			ent.animname = "tree_desertpalm03";
			break;
	}
	
	
	
	
	if (!isdefined (ent.animname))
		return;
	
	wait randomfloat(2);
	
	for (;;)
	{
		fWeight = (level.animWeightMin + randomfloat((level.animWeightMax - level.animWeightMin)) );
		fLength = 4;
		
		//setanim(anim, goalWeight, goalTime, rate)
		ent setanim(level.scr_anim[ent.animname]["wind"][0], fWeight, fLength, level.animRate["palm"]);
		ent setanim(level.scr_anim[ent.animname]["wind"][1], 1 - fWeight, fLength, level.animRate["palm"]);
		wait (1 + randomfloat(3));
	}
	
	
	//palm[0] thread maps\_anim::anim_loop(palm, "wind", undefined, "stop palm anim");
}