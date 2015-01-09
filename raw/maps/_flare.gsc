#include maps\_vehicle_aianim;
#include maps\_utility;
#include maps\_vehicle;
#include common_scripts\utility;

#using_animtree ("vehicles");
main( model, type )
{
	if ( !isdefined( level._effect ) )
		level._effect = [];
	level._effect["flare_runner_intro"]				= loadfx ("misc/flare_start");	
	level._effect["flare_runner"]					= loadfx ("misc/flare");	
	level._effect["flare_runner_fizzout"]			= loadfx ("misc/flare_end");	
	
	build_template( "flare", model, type );
	build_localinit( ::init_local );

	//health, optional_min, optional_max
	build_life ( 9999 );

}

init_local()
{
}
// below is the script for the in game flare effect

merge_suncolor( delay, timer, rgb1, rgb2 )
{
	wait( delay );
	timer = timer*20;
	suncolor = [];
	
	for ( i=0; i < timer; i++ )
	{
		dif = i / timer;
		level.thedif = dif;
		c = [];
		for ( p=0; p < 3; p++ )
		{
			c[ p ] = rgb2[ p ] * dif + rgb1[ p ] * ( 1 - dif );
		}
		
		level.sun_color = ( c[ 0 ], c[ 1 ], c[ 2 ] );
		wait( 0.05 );
	}
}

merge_sunsingledvar( dvar, delay, timer, l1, l2 )
{
//	level notify( dvar + "new_lightmerge" );
//	level endon( dvar + "new_lightmerge" );

	setsaveddvar( dvar, l1 );
	wait( delay );
	timer = timer*20;
	suncolor = [];
	
	/*
	0	i
	1	timer*20
	*/
	for ( i=0; i < timer; i++ )
	{
		dif = i / timer;
		level.thedif = dif;
		ld = l2 * dif + l1 * ( 1 - dif );
		
		setsaveddvar( dvar, ld );
		wait( 0.05 );
	}
	
	setsaveddvar( dvar, l2 );
	
}

merge_sunbrightness( delay, timer, l1, l2 )
{
	wait( delay );
	timer = timer*20;
	suncolor = [];
	for ( i=0; i < timer; i++ )
	{
		dif = i / timer;
		level.thedif = dif;
		ld = l2 * dif + l1 * ( 1 - dif );
		
		level.sun_brightness = ld;
		wait( 0.05 );
	}
	level.sun_brightness = l2;
}


combine_sunlight_and_brightness()
{
	level endon( "stop_combining_sunlight_and_brightness" );
	wait( 0.05 ); // wait for the direction to start lerping
	for ( ;; )
	{
		brightness = level.sun_brightness;
		// add some flicker
		if ( brightness > 1 )
			brightness += randomfloat( 0.2 );
		
		rgb = vector_Multiply( level.sun_color, brightness );
		setSunLight( rgb[ 0 ], rgb[ 1 ], rgb[ 2 ] );
		wait( 0.05 );
	}
}

flare_path()
{
	thread goPath( self );
	flag_wait( "flare_stop_setting_sundir" );
	self delete();		
}

flare_initial_fx()
{
	// initial effect
	model = spawn( "script_model", (0,0,0) );
	model setModel( "tag_origin" );
	model linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	playfxontag( level._effect[ "flare_runner_intro" ], model, "tag_origin" );
	self waittillmatch( "noteworthy", "flare_intro_node" );
	model delete();
}

flare_explodes()
{	
	flag_set( "flare_start_setting_sundir" );
	// flare explodes 
	// the amount of time for the ent to traverse the arc
	level.sun_brightness = 1;
	// merge our various sun values over time
	// first merge in the sun color/light settings
	level.red_suncolor = (0.8,0.4,0.4);
	level.original_suncolor = getMapSunLight();
	level.sun_color	= level.original_suncolor;
	thread merge_sunsingledvar( "sm_sunSampleSizeNear", 0, 0.25, 			0.25, 1 );

	thread combine_sunlight_and_brightness();
	thread merge_suncolor( 0, 0.25, 			level.original_sunColor, level.red_suncolor );
	thread merge_sunbrightness( 0, 0.25, 		1, 3 );

	model2 = spawn( "script_model", (0,0,0) );
	model2 setModel( "tag_origin" );
	model2 linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	playfxontag( level._effect[ "flare_runner" ], model2, "tag_origin" );
	self waittillmatch( "noteworthy", "flare_fade_node" );
	
//	wait( 1 );
	model2 delete();
}

flare_burns_out()
{
	// flare begins to phyzl out
	model3 = spawn( "script_model", (0,0,0) );
	model3 setModel( "tag_origin" );
	model3 linkto( self, "tag_origin", (0,0,0), (0,0,0) );
	playfxontag( level._effect[ "flare_runner_fizzout" ], model3, "tag_origin" );
	//wait( 0.3 );
	

	// brightness goes down then up
	thread merge_sunsingledvar( "sm_sunSampleSizeNear", 0, 1,			1, 0.25 );
	thread merge_sunbrightness( 0, 1, 		3, 0 );
	thread merge_suncolor( 0, 1, 	level.red_suncolor, level.original_suncolor);
	thread merge_sunbrightness( 1, 1, 	0, 1 );

	model3 delete();
	thread volume_down( 1 );
	wait( 1 );
	flag_set( "flare_stop_setting_sundir" );
	resetSunDirection();
	wait( 1 );
	level notify( "stop_combining_sunlight_and_brightness" );
	waittillframeend;

	// make sure it gets set to the price final direction settings, or the lightmaps will be broken
	resetSunLight();

	flag_set( "flare_complete" );
}

flare_fx()
{
	flare_initial_fx();
	flare_explodes();
	flare_burns_out();
}

flag_flare( msg )
{
	if ( !isdefined( level.flag[ msg ] ) )
	{
		flag_init( msg );
		return;
	}
}

flare_from_targetname( targetname )
{

	flare = spawn_vehicle_from_targetname( targetname );
	
	flag_flare( "flare_in_use" );
	flag_flare( "flare_complete" );
	flag_flare( "flare_stop_setting_sundir" );
	flag_flare( "flare_start_setting_sundir" );

	flag_waitopen( "flare_in_use" );
	flag_set( "flare_in_use" );
	
	resetSunLight();
	resetSunDirection();
	flare thread flare_path();
	flare thread flare_fx();
	
	// get the final point that our relative sun needs to point towards to make it equal the maps sun dir
	sundir = getMapSunDirection();
	angles = sundir;
	vec = vectorscale( angles, -100 );

	flag_wait( "flare_start_setting_sundir" );
	
	sunPointsTo = getent( flare.script_linkto, "script_linkname" ).origin;

	angles = vectortoangles( flare.origin - sunPointsTo );
	oldForward = anglestoforward( angles );
	for ( ;; )
	{
		wait( 0.05 );
		if ( flag( "flare_stop_setting_sundir" ) )
			break;
		angles = vectortoangles( flare.origin - sunPointsTo );
		forward = anglestoforward( angles );
		lerpSunDirection( oldForward, forward, 0.05 );
		oldForward = forward;
	}

	flag_wait( "flare_complete" );
	waittillframeend; // otherwise other things waiting on flare complete wont continue
	flag_clear( "flare_complete" );
	flag_clear( "flare_stop_setting_sundir" );
	flag_clear( "flare_start_setting_sundir" );
	resetSunLight();
	resetSunDirection();
	flag_clear( "flare_in_use" );
}
