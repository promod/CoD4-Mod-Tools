#include maps\mp\_utility;
#using_animtree("ac130");
init()
{
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	ac130Origin = (0,0,0);
	
	if ( miniMapOrigins.size )
	{
		ac130Origin = (miniMapOrigins[0].origin + miniMapOrigins[1].origin);
		vector_scale( ac130Origin, 0.5 );
	}
	
	level.ac130 = spawn( "script_model", ac130Origin );
	level.ac130 setModel( "c130_zoomrig" );
	level.ac130.angles = (0,75,0);
	
	level.ac130 hide();
	
	precacheShader("ac130_overlay_25mm");
	precacheShader("ac130_overlay_40mm");
	
	precacheShader("ac130_overlay_grain");
	
	precacheItem("ac130_25mm_mp");
	precacheItem("ac130_40mm_mp");
	
	precacheRumble("ac130_25mm_fire");
	precacheRumble("ac130_40mm_fire");
	
//	precacheShellShock("ac130");
	
	level.gunReady["ac130_25mm"] = true;
	level.gunReady["ac130_40mm"] = true;
	
	level.ac130_rotationSpeed = 150;

	thread rotatePlane( "on" );
}


ac130_attachPlayer( player )
{
	if ( isDefined( level.ac130Player ) )
		return;
		
	player = self;
	level.ac130Player = self;
	
	level.ac130Player takeAllWeapons();
	level.ac130Player giveWeapon( "ac130_40mm_mp" );
	level.ac130Player switchToWeapon( "ac130_40mm_mp" );

	level.ac130Player thread overlay();
	level.ac130Player thread attachPlayer();
	
	thread changeWeapons();
//	thread sounds();

}


overlay()
{
	level.ac130_overlay = newClientHudElem( self );
	level.ac130_overlay.x = 0;
	level.ac130_overlay.y = 0;
	level.ac130_overlay.alignX = "center";
	level.ac130_overlay.alignY = "middle";
	level.ac130_overlay.horzAlign = "center";
	level.ac130_overlay.vertAlign = "middle";
	level.ac130_overlay.foreground = true;
	level.ac130_overlay setshader ("ac130_overlay_105mm", 640, 480);
	
	grain = newClientHudElem( self );
	grain.x = 0;
	grain.y = 0;
	grain.alignX = "left";
	grain.alignY = "top";
	grain.horzAlign = "fullscreen";
	grain.vertAlign = "fullscreen";
	grain.foreground = true;
	grain setshader ("ac130_overlay_grain", 640, 480);
	grain.alpha = 0.5;
//	thread ac130ShellShock();
}


ac130ShellShock()
{
	for (;;)
	{
		duration = 60;
		level.ac130Player shellshock( "ac130", duration );
		wait duration;
	}
}


rotatePlane(toggle)
{
	level notify("stop_rotatePlane_thread");
	level endon("stop_rotatePlane_thread");
	
	if (toggle == "on")
	{
		for (;;)
		{
			level.ac130 rotateyaw( 360, level.ac130_rotationSpeed );
			wait level.ac130_rotationSpeed;
		}
	}
	else if (toggle == "off")
	{
		level.ac130 rotateyaw( level.ac130.angles[2], 0.05 );
	}
}


attachPlayer()
{
	//playerlinktodelta( <linkto entity>, <tag>, <viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
//	level.player playerLinkToDelta (level.ac130, "tag_player", 1.0, 50, 50, 18, 20);
	self linkTo( level.ac130, "tag_player", (1500,0,1000), (0,0,0) );
}


changeWeapons()
{
	weapon = [];
	
	weapon[0] = spawnstruct();
	weapon[0].overlay = "ac130_overlay_40mm";
	weapon[0].fov = "25";
	weapon[0].name = "40mm";
	weapon[0].sound = "ac130_40mm_fire";
	weapon[0].weapon = "ac130_40mm_mp";
	
	weapon[1] = spawnstruct();
	weapon[1].overlay = "ac130_overlay_25mm";
	weapon[1].fov = "10";
	weapon[1].name = "25mm";
	weapon[1].sound = "ac130_25mm_fire";
	weapon[1].weapon = "ac130_25mm_mp";
	
	currentWeapon = 0;
	level.currentWeapon = weapon[currentWeapon].name;
	thread fire_screenShake();
	
	for(;;)
	{
		while( !level.ac130Player useButtonPressed() )
			wait 0.05;
		
		currentWeapon++;
		if (currentWeapon >= weapon.size)
			currentWeapon = 0;
		level.currentWeapon = weapon[currentWeapon].name;
		
		level.ac130_overlay setShader (weapon[currentWeapon].overlay, 640, 480);
		level.ac130Player setClientDvar( "cg_fov", weapon[currentWeapon].fov );
		level.ac130Player takeAllWeapons();
		level.ac130Player giveWeapon( weapon[currentWeapon].weapon );
		level.ac130Player switchToWeapon( weapon[currentWeapon].weapon );
		
		while( level.ac130Player useButtonPressed() )
			wait 0.05;
	}
}

sounds()
{
	level.ac130Player playLoopSound( "ac130_ambient" );
	
	for (;;)
	{
		wait 2;
		level.ac130Player playLocalSound( "ac130_radio_1" );
		
		wait 3;
		level.ac130Player playLocalSound( "ac130_radio_2" );
		
		wait 1.5;
		level.ac130Player playLocalSound( "ac130_radio_3" );
		
		wait 8;
		level.ac130Player playLocalSound( "ac130_radio_4" );
		
		wait 8;
		level.ac130Player playLocalSound( "ac130_radio_5" );
		
		wait 10;
	}
}

fire_screenShake()
{
	/*
	for (;;)
	{
		while(!level.player attackbuttonpressed())
			wait 0.05;
		
		if (level.currentWeapon == "105mm")
		{
			wait 0.3;
			earthquake (0.1, 1, level.player.origin, 1000);
			wait 1;
		}
		
		while(level.player attackbuttonpressed())
			wait 0.05;
	}
	*/
}

gunReload(weaponName, reloadTime)
{
	level notify ("reloading " + weaponName);
	level endon ("reloading " + weaponName);
	
	level.gunReady[weaponName] = false;
	wait (reloadTime);
	level.gunReady[weaponName] = true;
	
//	if (weaponName == "105mm")
//		level.ac130 thread play_sound_on_tag("ac130_gunready","tag_player");
}


