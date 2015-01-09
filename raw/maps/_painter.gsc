#include common_scripts\utility;
#include maps\_utility;

painter_initvars()
{
	level.bPosedstyle = false;
	level.bOrienttoplayeryrot = false;
	level.spam_density_scale = 16;
	level.spaming_models = false;
	level.spam_model_group = [];
	level.spamed_models = [];
	level.spamed_models_redo = [];
	level.spam_models_flowrate = .1;
	level.spam_model_radius = 31;
	level.spam_maxdist = 1000;
	level.previewmodels = [];
	level.spam_models_isCustomrotation = false;
	level.spam_models_isCustomheight = false;
	level.spam_models_customheight = 0;
	level.spam_model_circlescale_lasttime = 0;
	level.spam_model_circlescale_accumtime = 0;
	level.paintadd = ::add_spammodel;
	hud_init();
	level.player disableweapons();
}

painter_init()
{
	setcurrentgroup( "civilian_cars" );
	playerInit();
}


hud_init()
{
	listsize = 9;
	
	hudelems = [];
	spacer = 15;
	div = int( listsize / 2 );
	org = 240 + div * spacer;
	alphainc = .5 / div;
	alpha = alphainc;
	
	for( i = 0;i < listsize;i ++ )
	{
		hudelems[ i ] = newHudElem();
		hudelems[ i ].location = 0;
		hudelems[ i ].alignX = "center";
		hudelems[ i ].alignY = "middle";
		hudelems[ i ].foreground = 1;
		hudelems[ i ].fontScale = 2;
		hudelems[ i ].sort = 20;
		if( i == div )
			hudelems[ i ].alpha = 1;
		else
			hudelems[ i ].alpha = alpha;
			
		hudelems[ i ].x = 20;
		hudelems[ i ].y = org;
		hudelems[ i ] setText( "hahah" + i );
		
		if( i == div )
			alphainc *= -1;
		
		alpha += alphainc;
	
		org -= spacer;
	}
	
	level.spam_group_hudelems = hudelems;
	
			 // setup "crosshair"
	crossHair = newHudElem();
	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "middle";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 1;
	crossHair.x = 320;
	crossHair.y = 233;
	crossHair setText( "." );
	level.crosshair = crossHair;
}


setcurrentgroup( group )
{
	level.spam_model_current_group = group;
	
	keys = getarraykeys( level.spam_model_group );
	
	index = 0;
	div = int( level.spam_group_hudelems.size / 2 );
	for( i = 0;i < keys.size;i ++ )
		if( keys[ i ] == group )
		{
			index = i;
			break;
		}

	level.spam_group_hudelems[ div ] settext( keys[ index ] );
	
	for( i = 1;i < level.spam_group_hudelems.size - div;i ++ )
	{
			if( index - i < 0 )
			{
				level.spam_group_hudelems[ div + i ] settext( " -- -- " );
				continue;
			}
			level.spam_group_hudelems[ div + i ] settext( keys[ index - i ] );
	}
	
	for( i = 1;i < level.spam_group_hudelems.size - div;i ++ )
	{
			if( index + i > keys.size - 1 )
			{
				level.spam_group_hudelems[ div - i ] settext( " -- -- " );
				continue;
			}
			level.spam_group_hudelems[ div - i ] settext( keys[ index + i ] );
	}
	
	group = getcurrent_groupstruct();


 /* 

		struct = spawnstruct();
		struct.models = [];
		struct.bFacade =  bFacade;
		struct.bTreeOrient =  bTreeOrient;
		struct.density =  density;
		struct.radius =  radius;
		struct.maxdist =  maxdist;
		level.spam_model_group[ group ] = struct;
 */ 	
	level.bOrienttoplayeryrot = group.bOrienttoplayeryrot;
	level.bPosedstyle = group.bPosedstyle;
	level.spam_maxdist = group.maxdist;
	level.spam_model_radius = group.radius;
	level.spam_density_scale = group.density;
	
	
}

setgroup_up()
{
		index = undefined;
		keys = getarraykeys( level.spam_model_group );
		for( i = 0;i < keys.size;i ++ )
			if( keys[ i ] == level.spam_model_current_group )
			{
				index = i + 1;
				break;
			}
		if( index == keys.size )
			return;
		setcurrentgroup( keys[ index ] );
		while( level.player buttonpressed( "BUTTON_Y" ) )
			wait .05;
	
}

setgroup_down()
{
		index = undefined;
		keys = getarraykeys( level.spam_model_group );
		for( i = 0;i < keys.size;i ++ )
			if( keys[ i ] == level.spam_model_current_group )
			{
				index = i - 1;
				break;
			}
		if( index < 0 )
			return;
		setcurrentgroup( keys[ index ] );
		while( level.player buttonpressed( "BUTTON_X" ) )
			wait .05;
}


add_spammodel( group, model, bTreeOrient, bFacade, density, radius, maxdist, offsetheight, bPosedstyle, bOrienttoplayeryrot )
{
	if( !isdefined( bPosedstyle ) )
		bPosedstyle = false;
	if( !isdefined( bOrienttoplayeryrot ) )
		bOrienttoplayeryrot = false;		
		
	if( !isdefined( group ) )
		group = model;
	precachemodel( model );
	if( !isdefined( bTreeOrient ) )
		bTreeOrient = false;
	if( !isdefined( bFacade ) )
		bFacade = false;
	if( !isdefined( density ) )
		density = 32;
	if( !isdefined( radius ) )
		radius = 84;
	if( !isdefined( maxdist ) )
		maxdist = 1000;
	if( !isdefined( level.spam_model_group[ group ] ) )
	{
		struct = spawnstruct();
		struct.models = [];
		struct.bFacade =  bFacade;
		struct.bTreeOrient =  bTreeOrient;
		struct.density =  density;
		struct.radius =  radius;
		struct.maxdist =  maxdist;
		struct.bPosedstyle = bPosedstyle;
		struct.bOrienttoplayeryrot = bOrienttoplayeryrot;
		level.spam_model_group[ group ] = struct;
	}
 // 	level.spam_model_group[ group ] = [];
	level.spam_model_group[ group ].models[ level.spam_model_group[ group ].models.size ] = model;
}


playerInit()
{
 // 	level.player takeAllWeapons();
	 /* 
	{ GPAD_X, K_BUTTON_X }, 
	{ GPAD_A, K_BUTTON_A }, 
	{ GPAD_B, K_BUTTON_B }, 
	{ GPAD_Y, K_BUTTON_Y }, 
	{ GPAD_L_TRIG, K_BUTTON_LTRIG }, 
	{ GPAD_R_TRIG, K_BUTTON_RTRIG }, 
	{ GPAD_L_SHLDR, K_BUTTON_LSHLDR }, 
	{ GPAD_R_SHLDR, K_BUTTON_RSHLDR }, 
	{ GPAD_START, K_BUTTON_START }, 
	{ GPAD_BACK, K_BUTTON_BACK }, 
	{ GPAD_L3, K_BUTTON_LSTICK }, 
	{ GPAD_R3, K_BUTTON_RSTICK }, 
	{ GPAD_UP, K_DPAD_UP }, 
	{ GPAD_DOWN, K_DPAD_DOWN }, 
	{ GPAD_LEFT, K_DPAD_LEFT }, 
	{ GPAD_RIGHT, K_DPAD_RIGHT }
	 */ 
	while( 1 )
	{
		trace = player_view_trace();
		draw_placement_circle( trace );
		if( level.player buttonpressed( "F5" ) )
			dump_models();


		if( level.player buttonpressed( "l" ) )
			pause_toggle( "l" ); // for taking screenshots
		else if( level.player buttonpressed( "ctrl" ) && level.player buttonpressed( "z" ) )
			spam_model_undo(); // crude, doesn't undo erase actions.  Just goes through the last added model
		else if( level.player buttonpressed( "z" ) )
			spam_model_redo();
		else if( level.player buttonpressed( "DPAD_UP" ) )
			customrotation_mode( trace, "DPAD_UP" );
		else if( level.player buttonpressed( "DPAD_DOWN" ) )
			customrotation_mode_off();
		else if( level.player buttonpressed( "DPAD_RIGHT" ) )
			customheight_mode( trace, "DPAD_RIGHT" );
		else if( level.player buttonpressed( "DPAD_LEFT" ) )
			customheight_mode_off();
		else if( level.player buttonpressed( "BUTTON_X" ) )
			setgroup_down();
		else if( level.player buttonpressed( "BUTTON_Y" ) )
			setgroup_up();
		else if( level.player buttonpressed( "BUTTON_LSTICK" ) )
			spam_model_circlescale( trace, -1 );
		else if( level.player buttonpressed( "BUTTON_RSTICK" ) )
			spam_model_circlescale( trace, 1 );
		else if( level.player buttonpressed( "BUTTON_A" ) )
			spam_model_densityscale( trace, -1 );
		else if( level.player buttonpressed( "BUTTON_B" ) )
			spam_model_densityscale( trace, 1 );
		else 
		{
			if( level.player buttonpressed( "BUTTON_LSHLDR" ) )
				spam_model_erase( trace );
			if( level.player buttonpressed( "BUTTON_RSHLDR" ) )
				thread spam_model_place( trace );  // threaded for delay
		}
			
		level notify( "clear_previews" );
		
			
		wait .05;
	}
}


customheight_mode_off()
{
		level.spam_models_isCustomheight = false;
}
customheight_mode( trace, button )
{
	if( trace[ "fraction" ] == 1 )
		return;

	while( level.player buttonpressed( button ) )
		wait .05;
	
	level.spam_models_isCustomheight = true;
	models = [];	
	models = spam_models_atcircle( trace, false, true );	

	inc = 2;
	dir = 1;
	
	origin = trace[ "position" ];
	while( !level.player buttonpressed( button ) )
	{
		height = level.spam_models_customheight;
		if( level.player buttonpressed( "BUTTON_A" ) )
			dir = -1;
		else if( level.player buttonpressed( "BUTTON_B" ) )
			dir = 1;
		else
			dir = 0;
		height += dir * inc;
		if( height == 0 )
			height += dir * inc;
		level.spam_models_customheight = height;
	
		array_thread( models, ::customheight_mode_offsetmodels, trace );
		draw_placement_circle( trace, ( 1, 1, 1 ) );
		
		wait .05;
	}
	array_thread( models, ::deleteme );


	while( level.player buttonpressed( button ) )
		wait .05;
	
}

customheight_mode_offsetmodels( trace )
{
	self.origin = self.orgorg + vector_multiply( trace[ "normal" ], level.spam_models_customheight );
}



customrotation_mode_off()
{
	level.spam_models_isCustomrotation = false;
}

addplayerangle()
{
	
}


customrotation_mode( trace, button )
{
	if( trace[ "fraction" ] == 1 )
		return;

	while( level.player buttonpressed( button ) )
		wait .05;
	
	level.spam_models_isCustomrotation = true;
	level.spam_models_customrotation = level.player getplayerangles();
	models = [];	
	models = spam_models_atcircle( trace, true, true );	
	
	otherangle = 0;
	otherangleinc = 1;
	dir = 0;

	while( !level.player buttonpressed( button ) )
	{
		dir = 0;
		if( level.player buttonpressed( "BUTTON_A" ) )
			dir = -1;
		else if( level.player buttonpressed( "BUTTON_B" ) )
			dir = 1;
		otherangle += dir * otherangleinc;
		if( otherangle > 360 )
			otherangle = 1;
		if( otherangle < 0 )
			otherangle = 359;
		draw_placement_circle( trace, ( 0, 0, 1 ) );
		level.spam_models_customrotation = level.player getplayerangles();
		level.spam_models_customrotation += ( 0, 0, otherangle );
		for( i = 0;i < models.size;i ++ )
			models[ i ].angles = level.spam_models_customrotation;
		wait .05;
	}
	while( level.player buttonpressed( button ) )
		wait .05;
	
	for( i = 0;i < models.size;i ++ )
		models[ i ] thread deleteme();
	
}


deleteme()
{
	self delete();
}


spam_model_clearcondition()
{
	self endon( "death" );
	level waittill( "clear_previews" );
	level.previewmodels = array_remove( level.previewmodels, self );
	self delete();
}

crosshair_fadetopoint()
{
	level notify( "crosshair_fadetopoint" );
	level endon( "crosshair_fadetopoint" );
	wait 2;
	level.crosshair settext( "." );
	
}

spam_model_circlescale( trace, dir )
{
	if( gettime() - level.spam_model_circlescale_lasttime > 60 )
		level.spam_model_circlescale_accumtime = 0;

	level.spam_model_circlescale_accumtime += .05;

	
	if(level.spam_model_circlescale_accumtime < .5)
		inc = 2;
	else
		inc = level.spam_model_circlescale_accumtime/.3;

	radius = level.spam_model_radius;
	radius += dir * inc;
	if( radius > 0 )
		level.spam_model_radius = radius;

	level.spam_model_circlescale_lasttime = gettime();
}

spam_model_densityscale( trace, dir )
{
		 // ghetto hack here.  density scale used for distance on floating model types
		inc = 2;
		scale = level.spam_density_scale;
		scale += dir * inc;
		if( scale > 0 )
			level.spam_density_scale = scale;
		
 // 		array_thread( level.previewmodels, ::deleteme );
			
 // 		level.previewmodels = spam_models_atcircle( trace, false );
		
 // 		array_thread( level.previewmodels, ::spam_model_clearcondition );
		
		level.crosshair settext( level.spam_density_scale );
		thread crosshair_fadetopoint();
}

draw_placement_circle( trace, coloroverride )
{
	if( !isdefined( coloroverride ) )
		coloroverride = ( 0, 1, 0 );
	if( trace[ "fraction" ] == 1 )
		return;
 // 	angles = vectortoangles( anglestoup( vectortoangles( trace[ "normal" ] ) ) );
	angles = vectortoangles( trace[ "normal" ] );
	origin = trace[ "position" ];
	radius = level.spam_model_radius;
 // 	plot_circle( origin, radius, angles, color, circleres );
	plot_circle( origin, radius, angles, coloroverride, 40, level.spam_model_radius );
	
	if( level.spam_models_isCustomrotation )
		draw_axis( origin, level.spam_models_customrotation );
	if( level.spam_models_isCustomheight )
		draw_arrow( origin, origin + vector_multiply( trace[ "normal" ], level.spam_models_customheight ), ( 1, 1, 1 ) );

}

player_view_trace()
{
	maxdist = level.spam_maxdist;
	traceorg = level.player geteye();
	return bullettrace( traceorg, traceorg + vector_multiply( anglestoforward( level.player getplayerangles() ), maxdist ), 0, self );
}

Orienttoplayeryrot()
{

	self devaddyaw( level.player getplayerangles()[ 1 ] - flat_angle( self.angles )[ 1 ] );
 // 	self.angles = ( x, y, z );
}

getcurrent_groupstruct()
{
	return level.spam_model_group[ level.spam_model_current_group ];
}

orient_model()
{
	
	group = getcurrent_groupstruct();
	
	
	 /* 
			struct = spawnstruct();
		struct.models = [];
		struct.bFacade =  bFacade;
		struct.bTreeOrient =  bTreeOrient;
		level.spam_model_group[ group ] = struct;
	
	 */ 
	
	if( level.spam_models_isCustomrotation )
	{
		
		self.angles = level.spam_models_customrotation;
		return;
	}
	
	if( level.bPosedstyle )
		self.angles = level.player getplayerangles();
		
	if( level.bOrienttoplayeryrot )
		self Orienttoplayeryrot();
	
	if( group.bTreeOrient )
		self.angles = flat_angle( self.angles );

	if( ! level.bOrienttoplayeryrot && !level.bPosedstyle )
		self devaddyaw( randomint( 360 ) );
	
	if( group.bFacade )
	{
		self.angles = flat_angle( vectortoangles( self.origin - level.player geteye() ) );
		self devaddyaw( 90 );
		
	}
		
	
 // 	y = self.angles[ 1 ];
 // 	while( y > 360 )
 // 		y -= 360;
 // 	self.angles = ( self.angles[ 0 ], y, self.angles[ 2 ] );
}

spam_model_place( trace )
{
	if( 	level.spaming_models )
		return;
	if( trace[ "fraction" ] == 1  && !level.bPosedstyle )
		return;
	
	level.spaming_models = true;
 // 	spam_model_erase( trace );
	
	
	
	models = spam_models_atcircle( trace, true );
	
	level.spamed_models = array_combine( level.spamed_models, models );
 // 	wait level.spam_models_flowrate;
	
	redo_clear();
	
	level.spaming_models = false;
	
}

getrandom_spammodel()
{
	models = level.spam_model_group[ level.spam_model_current_group ].models;
	return models[ randomint( models.size ) ];
}

spam_models_atcircle( trace, bRandomrotation, bForcedSpam )
{
	if( !isdefined( bForcedSpam ) )
		bForcedSpam = false;
	models = [];
	incdistance = level.spam_density_scale;
	radius = level.spam_model_radius;
	incs = int( radius / incdistance ) * 2;
 // 	startpoint = ( - 1 * ( incs / 2 ) );
	startpoint = 0;	
	traceorg = trace[ "position" ];
	
	angles = vectortoangles( trace[ "normal" ] );
	if( bRandomrotation )
		angles += ( 0, randomfloat( 360 ), 0 );
	xvect = vectornormalize( anglestoright( angles ) );
	yvect = vectornormalize( anglestoup( angles ) );

	startpos = traceorg;
 // 	startpos -= vector_multiply( xvect, radius );
 // 	startpos -= vector_multiply( yvect, radius );
	startpos -= vector_multiply( xvect, radius );
	startpos -= vector_multiply( yvect, radius );
	startpos += vector_multiply( xvect, incdistance );
	startpos += vector_multiply( yvect, incdistance );

	modelpos = startpos;

	 // special for when circle is too small for current density to place anything.  Just place one in the center..
	if( incs == 0 || level.bPosedstyle )
	{
		if( !bForcedSpam )
		if( 	is_too_dense( traceorg ) )
			return models;
		if( !bForcedSpam )
		if( level.spamed_models.size + models.size > 512 )
			return models;
		
 // 		getmodel = level.spam_model_group[ level.spam_model_current_group ][ randomint( level.spam_model_group[ level.spam_model_current_group ].size ) ];

		getmodel = getrandom_spammodel();
		models[ 0 ] = spam_modelattrace( trace, getmodel );
 // 		if( bRandomrotation )
		models[ 0 ] orient_model();
			
		return models;
	}
	
	for( x = startpoint;x < incs;x ++ )
	for( y = startpoint;y < incs;y ++ )
	{
		if( !bForcedSpam )
		if( level.spamed_models.size + models.size > 512 )
			return models;;
		modelpos = startpos;
		modelpos += vector_multiply( xvect, x * incdistance );
		modelpos += vector_multiply( yvect, y * incdistance );
		if( distance( modelpos, traceorg ) > radius )
			continue;
		
		if( !bForcedSpam )
		if( is_too_dense( modelpos ) )
			continue;
		countourtrace = contour_point( modelpos, angles, level.spam_model_radius );
		if( countourtrace[ "fraction" ] == 1 )
			continue;
		getmodel = getrandom_spammodel();
		 // contour_point( origin, angles, height );

		model = spam_modelattrace( countourtrace, getmodel );
 // 		if( bRandomrotation )
		model orient_model();
		models[ models.size ] = model;

	}
	return models;
	
}

is_too_dense( testorg )
{
	 // going backwards will be faster
	for( i = level.spamed_models.size - 1;i >= 0;i -- )
		if( distance( level.spamed_models[ i ].orgorg, testorg ) < ( level.spam_density_scale - 1 ) )
			return true; 
	return false;
}

spam_modelattrace( trace, getmodel )
{
	model = spawn( "script_model", level.player.origin );
	model setmodel( getmodel );
	model notsolid();
	model.origin = trace[ "position" ];
 // 	if( isdefined( orgoverride ) )
 // 		model.origin = orgoverride;
 // 	model.angles = vectortoangles( anglestoup( vectortoangles( trace[ "normal" ] ) ) );
	model.angles = vectortoangles( trace[ "normal" ] );
	model devaddpitch( 90 );
	model.orgorg = model.origin;
	if( level.spam_models_isCustomheight )
		model.origin += vector_multiply( trace[ "normal" ], level.spam_models_Customheight );
	return model;
}

 // distance( level.player geteye(), bullettrace( level.player.origin, level.player.origin + ( 0, 0, -100000 ), 0, level.player )[ "position" ] );

contour_point( origin, angles, height )
{
	offset = height;
	vect = anglestoforward( angles );
	destorg = origin + vector_multiply( vect, offset );
	targetorg = origin + vector_multiply( vect, -1 * offset );
	return bullettrace( destorg, targetorg, 0, level.player );
}

plot_circle( origin, radius, angles, color, circleres, contourdepth )
{
	if( !isdefined( color ) )
		color = ( 0, 1, 0 );
	if( !isdefined( circleres ) )
		circleres = 16;
	hemires = circleres / 2;
	circleinc = 360 / circleres;
	circleres ++ ;
	plotpoints = [];
	rad = 0;
	plotpoints = [];
	rad = 0.000;
	for( i = 0;i < circleres;i ++ )
	{
		baseorg =  origin + vector_multiply( anglestoup( ( angles + ( 0, 0, rad ) ) ), radius );
		point = contour_point( baseorg, angles, level.spam_model_radius );
		if( point[ "fraction" ] != 1 )
			plotpoints[ plotpoints.size ] =  point[ "position" ];
		rad += circleinc;
	}
	plot_points( plotpoints, color[ 0 ], color[ 1 ], color[ 2 ] );
	plotpoints = [];
}

redo_clear()
{
	array_thread( level.spamed_models_redo, ::deleteme );
	level.spamed_models_redo = [];
}

set_redo( script_model )
{
	script_model hide();
	level.spamed_models_redo[ level.spamed_models_redo.size ] = script_model;
}

spam_model_undo()
{
		array = [];
		if( !level.spamed_models.size )
			return;
		set_redo( level.spamed_models[ level.spamed_models.size - 1 ] );
		for( i = 0;i < level.spamed_models.size - 1;i ++ )
			array[ array.size ] = level.spamed_models[ i ];
		level.spamed_models = array;
		while( level.player buttonpressed( "ctrl" ) && level.player buttonpressed( "z" ) )
			wait .05;
}

spam_model_redo()
{
		array = [];
		redomodel = level.spamed_models_redo[ level.spamed_models_redo.size - 1 ];
		if( !isdefined( redomodel ) )
			return;
		redomodel show();
		level.spamed_models[ level.spamed_models.size ] = redomodel;
		for( i = 0;i < level.spamed_models_redo.size - 1;i ++ )
			array[ array.size ] = level.spamed_models_redo[ i ];
		level.spamed_models_redo = array;
		while( level.player buttonpressed( "z" ) )
			wait .05;
}
spam_model_erase( trace )
{
	traceorg = trace[ "position" ];
	keepmodels = [];
	deletemodels = [];
	for( i = 0;i < level.spamed_models.size;i ++ )
	{
		if( distance( level.spamed_models[ i ].orgorg, traceorg ) > level.spam_model_radius )
			keepmodels[ keepmodels.size ] = level.spamed_models[ i ];
		else
			deletemodels[ deletemodels.size ] = level.spamed_models[ i ];
	}
	level.spamed_models = keepmodels;
	
	for( i = 0;i < deletemodels.size;i ++ )
		deletemodels[ i ] delete();
}


dump_models()
{
 /#
	
	fileprint_map_start( level.script + "_modeldump" );

	for( i = 0;i < level.spamed_models.size;i ++ )
	{
		origin = fileprint_radiant_vec( level.spamed_models[ i ].origin );  // convert these vectors to mapfile keypair format
		angles = fileprint_radiant_vec( level.spamed_models[ i ].angles );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "classname", "misc_model" );
			fileprint_map_keypairprint( "model", level.spamed_models[ i ].model );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "angles", angles );
			fileprint_map_keypairprint( "spammed_model", level.spam_model_current_group );
		fileprint_map_entity_end();
	}

	fileprint_end();
#/ 
	array_thread( level.spamed_models, ::deleteme );
	level.spamed_models = [];

}


draw_axis( org, angles )
{
	range = 32;
	forward = anglestoforward( angles );
	forward = vector_multiply( forward, range );
	right = anglestoright( angles );
	right = vector_multiply( right, range );
	up = anglestoup( angles );
	up = vector_multiply( up, range );
	line( org, org + forward, ( 1, 0, 0 ), 1 );
	line( org, org + up, ( 0, 1, 0 ), 1 );
	line( org, org + right, ( 0, 0, 1 ), 1 );
}


pause_toggle( button )
{
	while( level.player buttonpressed( button ) )
		wait .05;
	level.crosshair.alpha = 0;
	array = [];
	for( i = 0;i < level.spam_group_hudelems.size;i ++ )
	{
		array[ i ] = level.spam_group_hudelems[ i ].alpha;
		level.spam_group_hudelems[ i ].alpha = 0;
	}
	
	while( !level.player buttonpressed( button ) )
		wait .05;
	level.crosshair.alpha = 1;
	for( i = 0;i < level.spam_group_hudelems.size;i ++ )
		level.spam_group_hudelems[ i ].alpha = array[ i ];
	while( level.player buttonpressed( button ) )
		wait .05;
	
}

