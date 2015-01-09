#include common_scripts\utility;
#include maps\_utility;
#include maps\_weather;

main()
{
	
	flag_init("cargoship_lighting_off");

	level._effect["griggs_brains"] 				= loadfx("impacts/flesh_hit_head_fatal_exit");
	//Ambient FX
	level._effect[ "cloud_bank_far" ]			= loadfx( "weather/jeepride_cloud_bank_far" );
	level._effect[ "hawks" ]					= loadfx( "misc/hawks" );
	level._effect[ "birds" ]					= loadfx( "misc/birds_icbm_runner" ); 	
	level._effect[ "mist_icbm" ]				= loadfx( "weather/mist_icbm" );	
	level._effect[ "exp_wall" ]					= loadfx( "props/wallExp_concrete" );

	//Moment FX	 
	level._effect[ "tunnel_column" ]			= loadfx( "props/jeepride_pillars" );
	level._effect[ "tunnel_brace" ]				= loadfx( "props/jeepride_brace" );
	
// I need to blank these out for when I do mymapents	
//	level._effect[ "tunnel_column" ]			= loadfx( "misc/blank" );
//	level._effect[ "tunnel_brace" ]				= loadfx( "misc/blank" );
	
	level._effect[ "tunnelspark" ] 				= loadfx( "misc/jeepride_tunnel_sparks" );
	level._effect[ "tunnelspark_dl" ] 			= loadfx( "misc/jeepride_tunnel_sparks" );
	level._effect[ "tanker_sparker" ] 			= loadfx( "misc/jeepride_tanker_sparks" );


	level.flare_fx[ "hind" ] 					= loadfx( "misc/flares_cobra" );
	level._effect[ "tire_deflate" ]				= loadfx( "impacts/jeepride_tire_shot" ); 	

	level._effect[ "truck_busts_pillar" ]						= loadfx( "explosions/wall_explosion_draft" );
	level._effect[ "truck_crash_flame_spectacular" ]			= loadfx( "misc/blank" );
	level._effect[ "truck_crash_flame_spectacular_arial" ]		= loadfx( "misc/blank" );
	level._effect[ "truck_splash" ] 							= loadfx( "explosions/mortarExp_water" );

	level._effect[ "cliff_explode" ]							= loadfx( "misc/blank" );
	level._effect[ "cliff_explode_jeepride" ] 					= loadfx( "explosions/cliff_explode_jeepride" );
	level._effect[ "tanker_explosion" ] 						= loadfx( "explosions/tanker_explosion" );
	level._effect[ "tanker_explosion_groundfire" ]				= loadfx( "explosions/tanker_explosion_groundfire" );
	                                                                                             
//	level._effect[ "bridge_tanker_explode" ] 						= loadfx( "explosions/tanker_explosion" );
	level._effect[ "bridge_tanker_explode" ]							= loadfx( "misc/blank" );
//	level._effect[ "bridge_tanker_flames" ]				= loadfx( "explosions/tanker_explosion_groundfire" );
	level._effect[ "bridge_tanker_flames" ]							= loadfx( "misc/blank" );
	
	                                                                                             
	level._effect[ "rpg_trail" ]				= loadfx( "smoke/smoke_geotrail_rpg" );
	level._effect[ "rpg_flash" ]				= loadfx( "muzzleflashes/at4_flash" );
	level._effect[ "rpg_explode" ]				= loadfx( "explosions/default_explosion" );
	
	level._effect[ "rocket_trail" ]				= loadfx( "smoke/smoke_geotrail_rocket_jeepride" );
	
	level._effect[ "player_explode" ]			= loadfx( "explosions/default_explosion" );

	level._effect[ "bridge_segment" ] 			= loadfx( "explosions/jeepride_bridge_explosion_seg" );
	level._effect[ "bridge_segment_sounder" ] 	= loadfx( "explosions/jeepride_bridge_explosion_seg_s" );
//	level._effect[ "bridge_segment" ]			= loadfx( "misc/blank" );
//	level._effect[ "bridge_segment_sounder" ]			= loadfx( "misc/blank" );
	
	
	level._effect[ "bridge_chunks" ] 			= loadfx( "misc/jeepride_chunk_thrower" );
	level._effect[ "bridge_chunks2" ] 			= loadfx( "misc/jeepride_chunk_thrower2" );
	level._effect[ "bridge_hubcaps" ] 			= loadfx( "misc/jeepride_hubcap_thrower" );
	
	level._effect[ "bridge_tanker_fire" ] 		= loadfx( "fire/jeepride_tanker_fire" );
	level._effect[ "bridge_tire_fire" ] 		= loadfx( "fire/tire_fire_med" );
	level._effect[ "bridge_amb_smoke" ] 		= loadfx( "smoke/amb_smoke_blend" );

	// I placed a bunch of emitters between the player and the heli to act as a frame of reference for motion
	level._effect[ "bridge_floaty_stuff" ] 			= loadfx( "smoke/amb_ash" );

	level._effect[ "bridge_amb_ash" ] 			= loadfx( "smoke/amb_ash" );

	
	if( getdvar( "consoleGame" ) != "true" && getdvarint("drew_notes") < 3 )
	{
		level._effect[ "bridge_crack_smoke" ] 		= loadfx( "misc/blank" );
		level._effect[ "bridge_sidesmoke" ] 		= loadfx( "misc/blank" );
	}
	else
	{
		level._effect[ "bridge_crack_smoke" ] 		= loadfx( "smoke/jeepride_crack_smoke" );
		level._effect[ "bridge_sidesmoke" ] 		= loadfx( "smoke/jeepride_bridge_sidesmoke" );
	}

	level._effect["griggs_pistol"] 				= loadfx("muzzleflashes/desert_eagle_flash_wv");
	level._effect["griggs_saw"] 				= loadfx("muzzleflashes/saw_flash_wv");

	level._effect["bloodpool"] 				= loadfx("impacts/deathfx_bloodpool");
	
	level._effect["smoke_blind"] = loadfx("test/jeepride_smokeblind");
	level._effect["bridge_crash_smoke"] = loadfx("test/jeepride_smokeblind");
	
	// bleh.  don't see any script commands to do this so I'm just plopping the data from impacts here so I can play impact fx without actually shooting a bullet for the end sequence.. mad hax.
	level._ak_impacts = []; 
	level._ak_impacts["concrete"] = loadfx( "impacts/large_concrete_1");
	level._ak_impacts["dirt"] = loadfx( "impacts/large_dirt_1");
	level._ak_impacts["glass"] = loadfx( "impacts/large_glass");
	level._ak_impacts["grass"] = loadfx( "impacts/small_grass");
	level._ak_impacts["gravel"] = loadfx( "impacts/large_gravel");
	level._ak_impacts["metal"] = loadfx( "impacts/large_metalhit_1");
	level._ak_impacts["rock"] = loadfx( "impacts/large_rock_1");
	level._ak_impacts["wood"] = loadfx( "impacts/large_woodhit");
	level._ak_impacts["asphalt"] = loadfx( "impacts/large_asphalt");
	level._ak_impacts["rubber"] = loadfx( "impacts/default_hit");
	level._ak_impacts["paintedmetal"] = loadfx( "impacts/large_metal_painted_hit");

	
//	 			   build_deathfx_override( <type> , <effect> , 										<tag> , 	<sound> , 							<bEffectLooping> , 	<delay> , 	<bSoundlooping> ,	<waitDelay> , <stayontag> , <notifyString> )"

	//Hind Deathfx override
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/helicopter_explosion_jeepride" , 	undefined,	"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.1, 		true );
//	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion_large" , 	"tag_ground", 		"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.2, 		true );
//	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion_large" , 	"tail_rotor_jnt", 	"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.5, 		true );
//	maps\_vehicle::build_deathfx_override( "hind",  "fire/fire_smoke_trail_L" , 			"tail_rotor_jnt", 	"hind_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
//	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion_large" , 	undefined, 			"hind_helicopter_crash", 			undefined, 			undefined, 		undefined, 		4.5, 		undefined, 	"stop_crash_loop_sound" );
   
	maps\_vehicle::build_deathfx_override( "bm21_troops", "explosions/small_vehicle_explosion", 	undefined, 				"car_explode", 						undefined, 			undefined, 		undefined, 		0 );
	maps\_vehicle::build_deathfx_override( "bm21_troops", "fire/firelp_med_pm", 					"tag_fx_tire_right_r", 	"smallfire", 						undefined, 			undefined, 		true, 			0 );
	maps\_vehicle::build_deathfx_override( "bm21_troops", "fire/firelp_med_pm", 					"tag_fx_cab", 			"smallfire", 						undefined, 			undefined, 		true, 			0 );
	
	thread main_post_load();
	
}  
   
main_post_load()
{  
	waittillframeend;
}  
   
jeepride_fxline()
{  
//	comment out this stuff to record effects. 
//	make sure jeepride_fxline_* are checked out so that the game can write to them.
//	also check to see if a new one has been written and add that to P4
//	emitters are setup in these prefab map files they can be fastfiled over
	
//	sparkrig_vehicle_80s_hatch1_brn_destructible.map
//	sparkrig_vehicle_bm21_mobile_bed.map
//	sparkrig_vehicle_luxurysedan_test.map
//	sparkrig_vehicle_pickup_4door.map
//	sparkrig_vehicle_uaz_open.map
//	sparkrig_vehicle_uaz_open_for_ride.map
	
//	maps\jeepride_code::createfxplayers( 8 );
//	
//	numberoffiles = 120;
//	for(i=0;i<numberoffiles;i++)
//	{
//		fx_line_file(i);
//	}
	maps\jeepride_code::dummyfunction();
	maps\scriptgen\jeepride_fxline_0::fxline();
	maps\scriptgen\jeepride_fxline_1::fxline();
	maps\scriptgen\jeepride_fxline_2::fxline();
	maps\scriptgen\jeepride_fxline_3::fxline();
	maps\scriptgen\jeepride_fxline_4::fxline();
	maps\scriptgen\jeepride_fxline_5::fxline();
	maps\scriptgen\jeepride_fxline_6::fxline();
	maps\scriptgen\jeepride_fxline_7::fxline();
	maps\scriptgen\jeepride_fxline_8::fxline();
	maps\scriptgen\jeepride_fxline_9::fxline();
//	maps\scriptgen\jeepride_fxline_10::fxline();
//	maps\scriptgen\jeepride_fxline_11::fxline();
//	maps\scriptgen\jeepride_fxline_12::fxline();
//	maps\scriptgen\jeepride_fxline_13::fxline();
//	maps\scriptgen\jeepride_fxline_14::fxline();
	
}

//fx_line_file( file )
//{
//	filename = "maps/scriptgen/jeepride_fxline_"+file+".csv";
//	linecount = 50;
//	for ( i = 0; i < 50; i++ )
//	{
//		time = tablelookup( filename, 0, i, 1 );
//		orgx = tablelookup( filename, 0, i, 2 );
//		orgy = tablelookup( filename, 0, i, 3 );
//		orgz = tablelookup( filename, 0, i, 4 );
//		origin = (orgx,orgy,orgz);
//		angx = tablelookup( filename, 0, i, 5 );
//		angy = tablelookup( filename, 0, i, 6 );
//		angz = tablelookup( filename, 0, i, 7 );
//		angles = (angx,angy,angz);
//		effectID = tablelookup( filename, 0, i, 8 );
//		fx_wait_set( time, origin, angles, effectID );
//	}
//}


apply_ghettotag( model,tag )
{
	if( !isdefined( tag ) )
		tag = "tag_body";
	if( !isdefined( model ) )
		model = self.model;
	if ( !isdefined( level.ghettotag ) || !isdefined( level.ghettotag[ model ] ) )
		return;
	self.ghettotags = [];
	ghettotags = level.ghettotag[ model ];
	for ( i = 0 ; i < ghettotags.size ; i ++ )
	{
		model = spawn( "script_model", self.origin );
		model setmodel( "axis" );
		model linkto( self, tag, ghettotags[ i ].origin, ghettotags[ i ].angles );
		model notsolid();
		self.ghettotags[ self.ghettotags.size ] = model;// todo create special string value of these.
	}
	lastorg = self.origin;
	wait .05;
	timeout_timer = gettime()+1000;
	
	while ( isdefined( self ) )
	{	
		// tag body because sometimes they animate away from the origin
		if( get_dummy() gettagorigin ( tag ) != lastorg )
		{
			for ( i = 0 ; i < self.ghettotags.size ; i ++ )
			{
				org1 = self.ghettotags[ i ].origin;
				org2 = self.ghettotags[ i ].origin + vector_multiply( anglestoup( self.ghettotags[ i ].angles ), 8 );  //project up 8 units
				trace = bullettrace( org1, org2, false, self ); 
				//there are other things that trace gets like surface types objects that we can change the reaction to here.
				if ( trace[ "fraction" ] < 1 && ! trace_isjunk( trace ) )
					playfxontag_record( getspark(), self.ghettotags[ i ], "polySurface1" );
			}
			timeout_timer = gettime()+1000;
		}

		lastorg = get_dummy() gettagorigin (tag);
		wait .05;
		if( gettime() > timeout_timer )
			return;
	}
}

get_dummy()
{
	if( !isdefined(self.modeldummyon) )
		return self;
	if ( self.modeldummyon )
		return self.modeldummy;
	else
		return self;
}

getspark()
{
	// this is really simple right now, 3 dynamic light sparks exists per frame, 
	//I may have disabled that part in the actual effect asignment above because 
	//I didn't like the light coming off.  You should inject your own logic here.
	//  IE: you could pass in the trace and return different effects id's based on different surface types.

	if ( level.sparksclaimed > 3 )
		return "tunnelspark" ;
	else
	{
		thread claimspark();
		return "tunnelspark_dl" ;
	}
}

claimspark()
{
	level.sparksclaimed ++ ;
	wait .05;
	level.sparksclaimed -- ;
}

trace_isjunk( trace )
{
	// check simply makes everything that's a script_model not spark against the vehicle.
	if ( isdefined( trace[ "entity" ] ) )
		if ( trace[ "entity" ].classname == "script_model" )
			return true;// I don't have any cases that I'm aware of where I want it to spark on a script model
	return false;
}

playfx_write_all( recorded )
{
	//this is where the effects get written to scripts
	 /#
	index = level.fxplay_writeindex;
	level.fxplay_writeindex ++ ;// have to write multiple files out as the sparkfile grows and variables need to be cleared;
	file = "scriptgen/" + level.script + "_fxline_" + index + ".gsc";
	file = fileprint_start( file );
	fileprint_chk( level.fileprint, "#include maps\\jeepride_code;" );
	fileprint_chk( level.fileprint, "fxline()" );
	fileprint_chk( level.fileprint, "{" );
	if ( !index )
		fileprint_chk( level.fileprint, "createfxplayers( 8 );" );
	delay = [];
	origin = [];
	angles = [];
	effectID = [];
	
	dupeinc = 0;
		
	for ( i = 0 ; i < recorded.size ; i ++ )
	{

		delay[dupeinc] = recorded[ i ].delay;
		origin[dupeinc] = recorded[ i ].origin;
		angles[dupeinc] = recorded[ i ].angles;
		effectID[dupeinc] = recorded[ i ].effectID;
		dupeinc++;
		if(dupeinc == 2)
		{
			fileprint_chk( level.fileprint, "fx_wait_set( " + delay[0] + ", " + origin[0] + ", " + angles[0] + ", \"" + effectid[0] + "\", " + delay[1] + ", " + origin[1] + ", " + angles[1] + ", \"" + effectid[1] + "\" );" );
			delay = [];
			origin = [];
			angles = [];
			effectID = [];
			dupeinc = 0;
		}

		
	}
	fileprint_chk( level.fileprint, "}" );
	fileprint_end();
	#/ 
}


playfx_write_all_CSV_STYLE( recorded )
{
	//this is where the effects get written to scripts
	 /#
	index = level.fxplay_writeindex;
	level.fxplay_writeindex ++ ;// have to write multiple files out as the sparkfile grows and variables need to be cleared;
	file = "scriptgen/" + level.script + "_fxline_" + index + ".csv";
	file = fileprint_start( file );
	for ( i = 0; i < recorded.size; i++ )
		fileprint_chk( level.fileprint, i+","+recorded[ i ].delay+"," + csv_vec( recorded[ i ].origin ) + csv_vec( recorded[ i ].angles ) + recorded[ i ].effectid );
	fileprint_end();
	#/ 
}
csv_vec( vec )
{
	string = "";
	for ( i = 0; i < 3; i++ )
		string+= ( vec[i]+"," );
	return string;
}

playfxontag_record( strFXid, object, tag )
{
	playfxontag( level._effect[ strFXid ], object, "polySurface1" );
	struct = spawnstruct();
	struct.effectid = strFXid;
	struct.origin = object.origin;
	struct.angles = object.angles;
	struct.delay = gettime();
	if ( level.recorded_fx.size > 500 )
	{
		thread playfx_write_all( level.recorded_fx );// dump a new file to keep variable count from overflowing.. pain in the neck blah
		level.recorded_fx = [];
	}
	else
	{
		level.recorded_fx[ level.recorded_fx.size ] = struct;
		level.recorded_fx_timer = gettime();	
	}
}

