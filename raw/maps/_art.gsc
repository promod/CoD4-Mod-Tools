// This function should take care of grain and glow settings for each map, plus anything else that artists 
// need to be able to tweak without bothering level designers.
#include maps\_utility;
#include common_scripts\utility;

main()
{
	
	/#
	if ( getDvar( "scr_art_tweak" ) == "" || getDvar( "scr_art_tweak" ) == "0" )
		setDvar( "scr_art_tweak", 0 );
	#/

	if ( getDvar( "scr_dof_enable" ) == "" )
		setsaveddvar( "scr_dof_enable", "1" );
		
	if ( getDvar( "scr_cinematic_autofocus" ) == "" )
		setDvar( "scr_cinematic_autofocus", "1" );
		
	if ( getDvar( "scr_art_visionfile" ) == "" )
		setDvar( "scr_art_visionfile", level.script );
		
	level.dofDefault[ "nearStart" ] = 1;
	level.dofDefault[ "nearEnd" ] = 1;
	level.dofDefault[ "farStart" ] = 500;
	level.dofDefault[ "farEnd" ] = 500;
	level.dofDefault[ "nearBlur" ] = 4.5;
	level.dofDefault[ "farBlur" ] = .05;

	level.curDoF = ( level.dofDefault[ "farStart" ] - level.dofDefault[ "nearEnd" ] ) / 2;
	
	if ( getDvarInt( "scr_dof_enable" ) )
		thread adsDoF();

//	thread tweakart();
	
	if ( !isdefined( level.script ) )
		level.script = tolower( getdvar( "mapname" ) );
	
	// Grain has been cut
	 /* 
	if ( getDvar( "r_grainfilter" ) == "" )
		setdvar( "r_grainfilter", "1" );
	thread grain_filter();
	 */ 	
	
}

grain_filter()
{
// Grain has been cut.
 /* 
	//* * * * * Full screen grain filter * * * * * 
	overlay = undefined;
	precacheShader( "overlay_grain" );
	for ( ;; )
	{
		if ( getdvarfloat( "r_grainfilter" ) > 0 )
		{
			if ( !isdefined( overlay ) )
			{
				overlay = newHudElem();
				overlay.x = 0;
				overlay.y = 0;
				overlay setshader( "overlay_grain", 640, 480 );
				overlay.alignX = "left";
				overlay.alignY = "top";
				overlay.horzAlign = "fullscreen";
				overlay.vertAlign = "fullscreen";
			}
		}
		else
		{
			if ( isdefined( overlay ) )
				overlay destroy();
		}
		if ( isdefined( overlay ) )
			overlay.alpha = level.grainstrength * getdvarfloat( "r_grainfilter" );
		wait 0.05;
	}
 */ 
}



artfxprintln( file, string )
{
	// printing to file is optional now
	if ( file == -1 )
		return;
	fprintln( file, string );
}


// Nate - hack Fixmed and replace with proper script command call once it's fixed.
// assumes " " as the deliiter. I'm not getting fancy.  
// I would really like to go work on jeepride so here's a 
// quick function that works for now untill engineering fixes strtok.

strtok_loc( string, par1 )
{
	stringlist = [];
	indexstring = "";
	for( i = 0 ; i < string.size ; i ++ )
	{
		if(string[ i ] == " ")
		{
			stringlist[stringlist.size] = indexstring;
			indexstring = ""; 
		}
		else
		{
			indexstring = indexstring+string[i];
		}
	}
	if(indexstring.size)
		stringlist[stringlist.size] = indexstring;
	return stringlist;
}


setfogsliders()
{
	//fixme.  replace strtok_loc with strtok if it ever works properly.
	fogall = strtok_loc( getdvar( "g_fogColorReadOnly" ), " " ) ;
	red = fogall[ 0 ];
	green = fogall[ 1 ];
	blue = fogall[ 2 ];
	halfplane = getdvar( "g_fogHalfDistReadOnly" );
	nearplane = getdvar( "g_fogStartDistReadOnly" );
		
	if ( !isdefined( red )
		 || !isdefined( green )
		 || !isdefined( blue )
		 || !isdefined( halfplane )
		 || !isdefined( halfplane )
		 )
	{
		red = 1;
		green = 1;
		blue = 1;
		halfplane = 10000001;
		nearplane = 10000000;
	}
	setdvar("scr_fog_exp_halfplane",halfplane);
	setdvar("scr_fog_nearplane",nearplane);
	setdvar("scr_fog_red",red);
	setdvar("scr_fog_green",green);
	setdvar("scr_fog_blue",blue);
}

tweakart()
{
	 /#
	if ( !isdefined( level.tweakfile ) )
		level.tweakfile = false; 
	
	// blah scriptgen stuff ignore this.
	if ( level.tweakfile && level.bScriptgened )
		script_gen_dump_addline( "maps\\createart\\" + level.script + "_art::main();", level.script + "_art" );// adds to scriptgendump

	// not in DEVGUI
	setdvar( "scr_fog_fraction", "1.0" );
	setdvar( "scr_art_dump", "0" );

	// update the devgui variables to current settings
	setdvar( "scr_dof_nearStart", level.dofDefault[ "nearStart" ] );
	setdvar( "scr_dof_nearEnd", level.dofDefault[ "nearEnd" ] );
	setdvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	setdvar( "scr_dof_farEnd", level.dofDefault[ "farEnd" ] );
	setdvar( "scr_dof_nearBlur", level.dofDefault[ "nearBlur" ] );
	setdvar( "scr_dof_farBlur", level.dofDefault[ "farBlur" ] );	

	// not in DEVGUI
	level.fogfraction = 1.0;
	
	file = undefined;
	filename = undefined;
	
	// set dofvars from < levelname > _art.gsc
	dofvarupdate();
	
	
	for ( ;; )
	{
		while ( getDvarint( "scr_art_tweak" ) == 0 )
		{
			//	assertex( getdvar( "scr_art_dump" ) == "0", "Must Enable Art Tweaks to export _art file." );
			wait .05;
			if(! getDvarint( "scr_art_tweak" ) == 0)
				setfogsliders(); //sets the sliders to whatever the current fog value is
		}
		
		
		if ( getDvarint( "scr_art_tweak_message" ) )
		{
			setDvar( "scr_art_tweak_message", "0" );
			println( "ART TWEAK ENABLED" );
		}
		
		// OLD functions cuts the fog values by a fraction. not in menus
		tweakfog_fraction();
		
		//translate the slider values to script variables

		level.fogexphalfplane = getdvarfloat( "scr_fog_exp_halfplane" );
		level.fognearplane = getdvarfloat( "scr_fog_nearplane" );
		level.fogred = getdvarfloat( "scr_fog_red" );
		level.foggreen = getdvarfloat( "scr_fog_green" );
		level.fogblue = getdvarfloat( "scr_fog_blue" );

		dofvarupdate();
		
		// catch all those cases where a slider can be pushed to a place of conflict
		fovslidercheck();

		dump = dumpsettings();// dumps and returns true if the dump dvar is set
		
		// updates fog to the variables
		
		if ( ! getdvarint( "scr_fog_disable" ) )
			setExpFog( level.fognearplane, level.fogexphalfplane, level.fogred, level.foggreen, level.fogblue, 0 );
		else
			setExpFog( 100000000000, 100000000001, 0, 0, 0, 0 );// couldn't find discreet fog disabling other than to never set it in the first place
			
		level.player setDefaultDepthOfField();
		
		if ( dump )
		{
			println( "Art settings dumped success!" );
			addstring = "maps\\createart\\" + level.script + "_art::main();";
			if ( level.bScriptgened )
			{
				script_gen_dump_addline( addstring, level.script + "_art" );// adds to scriptgendump
				maps\_load::script_gen_dump();// dump scriptgen link
			}
			else
				assertex( level.tweakfile, "remove all art setting in " + level.script + ".gsc and add the following line before _load: " + addstring );
			setdvar( "scr_art_dump", "0" );
 		}
		wait .1;
	}
	#/ 
}         

fovslidercheck()
{
	// catch all those cases where a slider can be pushed to a place of conflict
	if ( level.dofDefault[ "nearStart" ] >= level.dofDefault[ "nearEnd" ] )
	{
		level.dofDefault[ "nearStart" ] = level.dofDefault[ "nearEnd" ] - 1;
		setdvar( "scr_dof_nearStart", level.dofDefault[ "nearStart" ] );
	}
	if ( level.dofDefault[ "nearEnd" ] <= level.dofDefault[ "nearStart" ] )
	{
		level.dofDefault[ "nearEnd" ] = level.dofDefault[ "nearStart" ] + 1;
		setdvar( "scr_dof_nearEnd", level.dofDefault[ "nearEnd" ] );
	}
	if ( level.dofDefault[ "farStart" ] >= level.dofDefault[ "farEnd" ] )
	{
		level.dofDefault[ "farStart" ] = level.dofDefault[ "farEnd" ] - 1;
		setdvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	}
	if ( level.dofDefault[ "farEnd" ] <= level.dofDefault[ "farStart" ] )
	{
		level.dofDefault[ "farEnd" ] = level.dofDefault[ "farStart" ] + 1;
		setdvar( "scr_dof_farEnd", level.dofDefault[ "farEnd" ] );
	}
	if ( level.dofDefault[ "farBlur" ] >= level.dofDefault[ "nearBlur" ] )
	{
		level.dofDefault[ "farBlur" ] = level.dofDefault[ "nearBlur" ] - .1;
		setdvar( "scr_dof_farBlur", level.dofDefault[ "farBlur" ] );
	}
	if ( level.dofDefault[ "farStart" ] <= level.dofDefault[ "nearEnd" ] )
	{
		level.dofDefault[ "farStart" ] = level.dofDefault[ "nearEnd" ] + 1;
		setdvar( "scr_dof_farStart", level.dofDefault[ "farStart" ] );
	}
} 

dumpsettings()
{
	 /#
	if ( getdvar( "scr_art_dump" ) == "0" )
		return false;
	dump = true;
	
	filename = "createart/" + getdvar("scr_art_visionfile") + "_art.gsc";

	////////////////// 

	file = openfile( filename, "write" );

	assertex( file != -1, "File not writeable( maybe you should check it out ): " + filename );
	if ( file == -1 )
		dump = false;
	
	
	artfxprintln( file, "// _createart generated.  modify at your own risk. Changing values should be fine." );
	artfxprintln( file, "main()" );
	artfxprintln( file, "{" );

	artfxprintln( file, "" );
	artfxprintln( file, "\tlevel.tweakfile = true;" );
	artfxprintln( file, " " );

	artfxprintln( file, "\t//* depth of field section * " );
	artfxprintln( file, "" );

	artfxprintln( file, "\tlevel.dofDefault[ \"nearStart\" ] = " + getdvarint( "scr_dof_nearStart" ) + ";" );
	artfxprintln( file, "\tlevel.dofDefault[ \"nearEnd\" ] = " + getdvarint( "scr_dof_nearEnd" ) + ";" );
	artfxprintln( file, "\tlevel.dofDefault[ \"farStart\" ] = " + getdvarint( "scr_dof_farStart" ) + ";" );
	artfxprintln( file, "\tlevel.dofDefault[ \"farEnd\" ] = " + getdvarint( "scr_dof_farEnd" ) + ";" );
	artfxprintln( file, "\tlevel.dofDefault[ \"nearBlur\" ] = " + getdvarfloat( "scr_dof_nearBlur" ) + ";" );
	artfxprintln( file, "\tlevel.dofDefault[ \"farBlur\" ] = " + getdvarfloat( "scr_dof_farBlur" ) + ";" );
	
	
	artfxprintln( file, "\tgetent( \"player\", \"classname\" ) maps\\_art::setdefaultdepthoffield();" );
	
	// vision store variables are a quick and dirty method of storing vision file values to the script so that next time we write everything they don't get interupted

	artfxprintln( file, "" );
	artfxprintln( file, "\t//* Fog section * " );
	artfxprintln( file, "" );

// 	artfxprintln( file, "\tsetdvar( \"scr_fog_exp_halfplane\"" + ", " + "\"" + level.fogexphalfplane + "\"" + " );" );
// 	artfxprintln( file, "\tsetdvar( \"scr_fog_nearplane\"" + ", " + "\"" + level.fognearplane + "\"" + " );" );
// 	artfxprintln( file, "\tsetdvar( \"scr_fog_red\"" + ", " + "\"" + level.fogred + "\"" + " );" );
// 	artfxprintln( file, "\tsetdvar( \"scr_fog_green\"" + ", " + "\"" + level.foggreen + "\"" + " );" );
// 	artfxprintln( file, "\tsetdvar( \"scr_fog_blue\"" + ", " + "\"" + level.fogblue + "\"" + " );" );
	artfxprintln( file, "\tsetdvar( \"scr_fog_disable\"" + ", " + "\"" + getdvarint( "scr_fog_disable" ) + "\"" + " );" );
	
	artfxprintln( file, "" );
	if ( ! getdvarint( "scr_fog_disable" ) )
		artfxprintln( file, "\tsetExpFog( " + level.fognearplane + ", " + level.fogexphalfplane + ", " + level.fogred + ", " + level.foggreen + ", " + level.fogblue + ", 0 );" );

	artfxprintln( file, "\tmaps\\_utility::set_vision_set( \"" + level.script + "\", 0 );" );

	artfxprintln( file, "" );
	artfxprintln( file, "}" );

	saved = closefile( file );
	assertex( ( saved == 1 ), "File not saved( see above message? ): " + filename );
	if ( ! saved )
		dump = false;
	////////////////////////////// 

	visionFilename = "vision/" + getdvar("scr_art_visionfile") + ".vision";
	file = openfile( visionFilename, "write" );

	assertex( ( file != -1 ), "File not writeable( may need checked out of P4 ): " + filename );

	artfxprintln( file, "r_glow                    \"" + getdvar( "r_glowTweakEnable" ) + "\"" );
	artfxprintln( file, "r_glowRadius0             \"" + getdvar( "r_glowTweakRadius0" ) + "\"" );
	artfxprintln( file, "r_glowRadius1             \"" + getdvar( "r_glowTweakRadius1" ) + "\"" );
	artfxprintln( file, "r_glowBloomCutoff         \"" + getdvar( "r_glowTweakBloomCutoff" ) + "\"" );
	artfxprintln( file, "r_glowBloomDesaturation   \"" + getdvar( "r_glowTweakBloomDesaturation" ) + "\"" );
	artfxprintln( file, "r_glowBloomIntensity0     \"" + getdvar( "r_glowTweakBloomIntensity0" ) + "\"" );
	artfxprintln( file, "r_glowBloomIntensity1     \"" + getdvar( "r_glowTweakBloomIntensity1" ) + "\"" );
	artfxprintln( file, "r_glowSkyBleedIntensity0  \"" + getdvar( "r_glowTweakSkyBleedIntensity0" ) + "\"" );
	artfxprintln( file, "r_glowSkyBleedIntensity1  \"" + getdvar( "r_glowTweakSkyBleedIntensity1" ) + "\"" );
	artfxprintln( file, " " );
	artfxprintln( file, "r_filmEnable              \"" + getdvar( "r_filmTweakEnable" ) + "\"" );
	artfxprintln( file, "r_filmContrast            \"" + getdvar( "r_filmTweakContrast" ) + "\"" );
	artfxprintln( file, "r_filmBrightness          \"" + getdvar( "r_filmTweakBrightness" ) + "\"" );
	artfxprintln( file, "r_filmDesaturation        \"" + getdvar( "r_filmTweakDesaturation" ) + "\"" );
	artfxprintln( file, "r_filmInvert              \"" + getdvar( "r_filmTweakInvert" ) + "\"" );
	artfxprintln( file, "r_filmLightTint           \"" + getdvar( "r_filmTweakLightTint" ) + "\"" );
	artfxprintln( file, "r_filmDarkTint            \"" + getdvar( "r_filmTweakDarkTint" ) + "\"" );


	saved = closefile( file );
	assertex( ( saved == 1 ), "File not saved( see above message? ): " + visionFilename );
	if ( dump )
		println( "ART DUMPED SUCCESSFULLY" );
	return dump;
	#/ 
}

tweakfog_fraction()
{
		fogfraction = getdvarfloat( "scr_fog_fraction" );
		if ( fogfraction != level.fogfraction )
			level.fogfraction = fogfraction;
		else
			return;
			
		color = [];
		color[ 0 ] = getdvarfloat( "scr_fog_red" );
		color[ 1 ] = getdvarfloat( "scr_fog_green" );
		color[ 2 ] = getdvarfloat( "scr_fog_blue" );

		setdvar( "scr_fog_fraction", 1 );
		if ( fogfraction < 0 )
		{
			println( "no negative numbers please." );
			return;
		}

		fc = [];
		larger = 1;
		for ( i = 0;i < color.size;i ++ )
		{
			fc[ i ] = fogfraction * color[ i ];
			if ( fc[ i ] > larger )
				larger = fc[ i ];
		}

		if ( larger > 1 )
			for ( i = 0;i < fc.size;i ++ )
				fc[ i ] = fc[ i ] / larger;

		setdvar( "scr_fog_red", fc[ 0 ] );
		setdvar( "scr_fog_green", fc[ 1 ] );
		setdvar( "scr_fog_blue", fc[ 2 ] );

}

cloudlight( sunlight_bright, sunlight_dark, diffuse_high, diffuse_low )
{
	level.sunlight_bright = sunlight_bright;
	level.sunlight_dark = sunlight_dark;
	level.diffuse_high = diffuse_high;
	level.diffuse_low = diffuse_low;

	setdvar( "r_lighttweaksunlight", level.sunlight_dark );
	setdvar( "r_lighttweakdiffusefraction", level.diffuse_low );
	direction = "up";

	for ( ;; )
	{
		sunlight = getdvarFloat( "r_lighttweaksunlight" );
		jitter = scale( 1 + randomint( 21 ) );

		flip = randomint( 2 );
		if ( flip )
			jitter = jitter * - 1;
		
		if ( direction == "up" )
			next_target = sunlight + scale( 30 ) + jitter;
		else
			next_target = sunlight - scale( 30 ) + jitter;
	
		// iprintln( "jitter = ", jitter );
		if ( next_target >= level.sunlight_bright )
		{
			next_target = level.sunlight_bright;
			direction = "down";
		}
		
		if ( next_target <= level.sunlight_dark )
		{
			next_target = level.sunlight_dark;
			direction = "up";
		}

		if ( next_target > sunlight )
			brighten( next_target, ( 3 + randomint( 3 ) ), .05 );
		else
			darken( next_target, ( 3 + randomint( 3 ) ), .05 );
	}
}

brighten( target_sunlight, time, freq )
{
	// iprintln( "Brightening sunlight to ", target_sunlight );
	sunlight = getdvarFloat( "r_lighttweaksunlight" );
	// diffuse = getdvarFloat( "r_lighttweakdiffusefraction" );
	// iprintln( "sunlight = ", sunlight );
	// iprintln( "diffuse = ", diffuse );
		
	totalchange = target_sunlight - sunlight;
	changeamount = totalchange / ( time / freq );
	// iprintln( "totalchange = ", totalchange );
	// iprintln( "changeamount = ", changeamount );
	
	while ( time > 0 )
	{
		time = time - freq;
		
		sunlight = sunlight + changeamount;
		setdvar( "r_lighttweaksunlight", sunlight );
		// iprintln( "^6sunlight = ", sunlight );

		frac = ( sunlight - level.sunlight_dark ) / ( level.sunlight_bright - level.sunlight_dark );
		diffuse = level.diffuse_high + ( level.diffuse_low - level.diffuse_high ) * frac;
		setdvar( "r_lighttweakdiffusefraction", diffuse );
		// iprintln( "^6diffuse = ", diffuse );

		wait freq;
	}
}

darken( target_sunlight, time, freq )
{
	// iprintln( "Darkening sunlight to ", target_sunlight );
	sunlight = getdvarFloat( "r_lighttweaksunlight" );
	// diffuse = getdvarFloat( "r_lighttweakdiffusefraction" );
	// iprintln( "sunlight = ", sunlight );
	// iprintln( "diffuse = ", diffuse );
		
	totalchange = sunlight - target_sunlight;
	changeamount = totalchange / ( time / freq );
	// iprintln( "totalchange = ", totalchange );
	// iprintln( "changeamount = ", changeamount );
	
	while ( time > 0 )
	{
		time = time - freq;
		
		sunlight = sunlight - changeamount;
		setdvar( "r_lighttweaksunlight", sunlight );
		// iprintln( "^6sunlight = ", sunlight );

		frac = ( sunlight - level.sunlight_dark ) / ( level.sunlight_bright - level.sunlight_dark );
		diffuse = level.diffuse_high + ( level.diffuse_low - level.diffuse_high ) * frac;
		setdvar( "r_lighttweakdiffusefraction", diffuse );
		// iprintln( "^6diffuse = ", diffuse );

		wait freq;
	}
}

scale( percent )
{
		frac = percent / 100;
		return( level.sunlight_dark + frac * ( level.sunlight_bright - level.sunlight_dark ) ) - level.sunlight_dark;
}


adsDoF()
{
	level.dof = level.dofDefault;
	art_tweak = false;
	
	for ( ;; )
	{
		wait( 0.05 );

		if ( level.level_specific_dof )
		{
			continue;
		}
		if ( getDvarInt( "scr_cinematic" ) )
		{
			updateCinematicDoF();
			continue;
		}
		
		/# art_tweak = getDvarInt( "scr_art_tweak" ); #/
		
		if ( getDvarInt( "scr_dof_enable" ) && !art_tweak )
		{
			updateDoF();
			continue;
		}

		level.player setDefaultDepthOfField();
	}
}


updateCinematicDoF()
{
	adsFrac = level.player playerADS();
	

	if ( adsFrac == 1 && getDvarInt( "scr_cinematic_autofocus" ) )
	{
		traceDir = vectorNormalize( anglesToForward( level.player getPlayerAngles() ) );
		trace = bulletTrace( level.player getEye(), level.player getEye() + vectorscale( traceDir, 100000 ), true, level.player );
	
		enemies = getAIArray();
		nearEnd = 10000;
		farStart = -1;
		start_origin = level.player getEye();
		start_angles = level.player getPlayerAngles();
		bestDot = 0;
		bestFocalPoint = undefined;
		for ( index = 0; index < enemies.size; index ++ )
		{
			end_origin = enemies[ index ].origin;
			normal = vectorNormalize( end_origin - start_origin );
			forward = anglestoforward( start_angles );
			dot = vectorDot( forward, normal );
	
			if ( dot > bestDot )
			{
				bestDot = dot;
				bestFocalPoint = enemies[ index ].origin;
			}
		}
		
		if ( bestDot < 0.923 )
		{
			scrDoF = distance( start_origin, trace[ "position" ] );
// 			scrDoF = getDvarInt( "scr_cinematic_doffocus" ) * 39;
		}
		else
		{
			scrDoF = distance( start_origin, bestFocalPoint );
		}

		changeDoFValue( "nearStart", 1, 200 );
		changeDoFValue( "nearEnd", scrDoF, 200 );
		changeDoFValue( "farStart", scrDoF + 196, 200 );
		changeDoFValue( "farEnd", ( scrDoF + 196 ) * 2, 200 );
		changeDoFValue( "nearBlur", 6, 0.1 );
		changeDoFValue( "farBlur", 3.6, 0.1 );
	}
	else
	{
		scrDoF = getDvarInt( "scr_cinematic_doffocus" ) * 39;
		
		if ( level.curDoF != scrDoF )
		{
			changeDoFValue( "nearStart", 1, 100 );
			changeDoFValue( "nearEnd", scrDoF, 100 );
			changeDoFValue( "farStart", scrDoF + 196, 100 );
			changeDoFValue( "farEnd", ( scrDoF + 196 ) * 2, 100 );
			changeDoFValue( "nearBlur", 6, 0.1 );
			changeDoFValue( "farBlur", 3.6, 0.1 );
		}
	}

	level.curDoF = ( level.dof[ "farStart" ] - level.dof[ "nearEnd" ] ) / 2;

	level.player setDepthOfField( 
							level.dof[ "nearStart" ], 
							level.dof[ "nearEnd" ], 
							level.dof[ "farStart" ], 
							level.dof[ "farEnd" ], 
							level.dof[ "nearBlur" ], 
							level.dof[ "farBlur" ]
							 );
}


updateDoF()
{
	if ( level.player playerADS() == 0.0 )
	{
		level.player setDefaultDepthOfField();
		return;
	}

	playerEye = level.player getEye();
	playerAngles = level.player getPlayerAngles();
	playerForward = vectorNormalize( anglesToForward( playerAngles ) );
	
	trace = bulletTrace( playerEye, playerEye + vectorscale( playerForward, 8192 ), true, level.player );

	enemies = getAIArray( "axis" );
	nearEnd = 10000;
	farStart = -1;
	
	for ( index = 0; index < enemies.size; index ++ )
	{
		enemyDir = vectorNormalize( enemies[ index ].origin - playerEye );
		
		dot = vectorDot( playerForward, enemyDir );
		if ( dot < 0.923 )// 45 degrees
			continue;

		distFrom = distance( playerEye, enemies[ index ].origin );
		
		if ( distFrom - 30 < nearEnd )
			nearEnd = distFrom - 30;

		if ( distFrom + 30 > farStart )
			farStart = distFrom + 30;
	}

	if ( nearEnd > farStart )
	{
		nearEnd = 256;
		farStart = 2500;
	}
	else
	{
		if ( nearEnd < 50 )
			nearEnd = 50;
		else if ( nearEnd > 512 )
			nearEnd = 512;
		
		if ( farStart > 2500 )
			farStart = 2500;
		else if ( farStart < 1000 )
			farStart = 1000;
	}
	
	traceDist = distance( playerEye, trace[ "position" ] );
	
	if ( nearEnd > traceDist )
		nearEnd = traceDist - 30;
		
	if ( nearEnd < 1 )
		nearEnd = 1;

	if ( farStart < traceDist )
		farSTart = traceDist;

	setDoFTarget( 1, nearEnd, farStart, farStart * 4, 6, 1.8 );
}

setDoFTarget( nearStart, nearEnd, farStart, farEnd, nearBlur, farBlur )
{
	adsFrac = level.player playerADS();
	
	if ( adsFrac == 1 )
	{
		changeDoFValue( "nearStart", nearStart, 50 );
		changeDoFValue( "nearEnd", nearEnd, 50 );
		changeDoFValue( "farStart", farStart, 400 );
		changeDoFValue( "farEnd", farEnd, 400 );
		changeDoFValue( "nearBlur", nearBlur, 0.1 );
		changeDoFValue( "farBlur", farBlur, 0.1 );
	}
	else
	{
		lerpDoFValue( "nearStart", nearStart, adsFrac );
		lerpDoFValue( "nearEnd", nearEnd, adsFrac );
		lerpDoFValue( "farStart", farStart, adsFrac );
		lerpDoFValue( "farEnd", farEnd, adsFrac );
		lerpDoFValue( "nearBlur", nearBlur, adsFrac );
		lerpDoFValue( "farBlur", farBlur, adsFrac );
	}

	level.player setDepthOfField( 
							level.dof[ "nearStart" ], 
							level.dof[ "nearEnd" ], 
							level.dof[ "farStart" ], 
							level.dof[ "farEnd" ], 
							level.dof[ "nearBlur" ], 
							level.dof[ "farBlur" ]
							 );
}

changeDoFValue( valueName, targetValue, maxChange )
{
	if ( level.dof[ valueName ] > targetValue )
	{
		changeVal = ( level.dof[ valueName ] - targetValue ) * 0.5;
		if ( changeVal > maxChange )
			changeVal = maxChange;
		else if ( changeVal < 1 )
			changeVal = 1;
		
		if ( level.dof[ valueName ] - changeVal < targetValue )
			level.dof[ valueName ] = targetValue;
		else
			level.dof[ valueName ] -= changeVal;
	}
	else if ( level.dof[ valueName ] < targetValue )
	{
		changeVal = ( targetValue - level.dof[ valueName ] ) * 0.5;
		if ( changeVal > maxChange )
			changeVal = maxChange;
		else if ( changeVal < 1 )
			changeVal = 1;

		if ( level.dof[ valueName ] + changeVal > targetValue )
			level.dof[ valueName ] = targetValue;
		else
			level.dof[ valueName ] += changeVal;
	}
}

lerpDoFValue( valueName, targetValue, lerpAmount )
{
	level.dof[ valueName ] = level.dofDefault[ valueName ] + ( ( targetValue - level.dofDefault[ valueName ] ) * lerpAmount ) ;	
}

dofvarupdate()
{
		level.dofDefault[ "nearStart" ] = getdvarint( "scr_dof_nearStart" );
		level.dofDefault[ "nearEnd" ] = getdvarint( "scr_dof_nearEnd" );
		level.dofDefault[ "farStart" ] = getdvarint( "scr_dof_farStart" );
		level.dofDefault[ "farEnd" ] = getdvarint( "scr_dof_farEnd" );
		level.dofDefault[ "nearBlur" ] = getdvarfloat( "scr_dof_nearBlur" );
		level.dofDefault[ "farBlur" ] = getdvarfloat( "scr_dof_farBlur" );	
}

setdefaultdepthoffield()
{
		self setDepthOfField( 
								level.dofDefault[ "nearStart" ], 
								level.dofDefault[ "nearEnd" ], 
								level.dofDefault[ "farStart" ], 
								level.dofDefault[ "farEnd" ], 
								level.dofDefault[ "nearBlur" ], 
								level.dofDefault[ "farBlur" ]
								 );
}


isDoFDefault()
{
	if ( level.dofDefault[ "nearStart" ] != getDvarInt( "scr_dof_nearStart" ) )
		return false;

	if ( level.dofDefault[ "nearEnd" ] != getDvarInt( "scr_dof_nearEnd" ) )
		return false;

	if ( level.dofDefault[ "farStart" ] != getDvarInt( "scr_dof_farStart" ) )
		return false;

	if ( level.dofDefault[ "farEnd" ] != getDvarInt( "scr_dof_farEnd" ) )
		return false;

	if ( level.dofDefault[ "nearBlur" ] != getDvarInt( "scr_dof_nearBlur" ) )
		return false;

	if ( level.dofDefault[ "farBlur" ] != getDvarInt( "scr_dof_farBlur" ) )
		return false;
		
	return true;
}


