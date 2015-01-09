#include common_scripts\utility;
#include maps\_utility;
#include maps\_weather;

main()
{
	level.truecolor = getMapSunLight();
	level.orgsuncolor = [];
	if(level.jumpto == "start" )
	{
		level.orgsuncolor[0] = 0.0;
		level.orgsuncolor[1] = 0.0;
		level.orgsuncolor[2] = 0.0;
	}
	else
		level.orgsuncolor = getMapSunLight();
	
	flag_init("cargoship_lighting_off");
	
	//sinking sequence fx
	level._effect["sinking_explosion"]					= loadfx ("explosions/cobrapilot_vehicle_explosion"); 
	
	level._effect["sinking_leak_large"]					= loadfx ("misc/cargoship_sinking_leak_large"); 
	level._effect["event_waterleak"]					= loadfx ("misc/cargoship_sinking_leak_med"); 
	level._effect["event_steamleak"]					= loadfx ("misc/cargoship_sinking_steam_leak");
	level._effect["event_sparks"]						= loadfx ("explosions/sparks_d");
	level._effect["sparks_runner"]						= loadfx ("explosions/sparks_runner"); 
	
	level._effect["sinking_waterlevel_center"]			= loadfx ("misc/cargoship_water_noise");
	level._effect["sinking_waterlevel_edge"]			= loadfx ("misc/cargoship_water_noise");
	
	level._effect["escape_waternoise"]					= loadfx ("weather/rain_noise");
	level._effect["escape_waternoise_ud"]				= loadfx ("weather/rain_noise_ud");
	level._effect["escape_waterdrips"]					= loadfx ("misc/cgoshp_drips_a");
	level._effect["escape_water_drip_stairs"]			= loadfx ("misc/water_drip_stairs");
	level._effect["escape_water_gush_stairs"]			= loadfx ("misc/water_gush_stairs");
	level._effect["escape_caustics"]					= loadfx ("misc/caustics");

	//random
	level._effect["vodka_bottle"]						= loadfx ("props/vodka_bottle"); 
	level._effect["coffee_mug"]							= loadfx ("misc/coffee_mug_cargoship"); 
	
	level._effect["cargo_vl_red_thin"]					= loadfx ("misc/cargo_vl_red_thin"); 
	level._effect["cargo_vl_white"]						= loadfx ("misc/cargo_vl_white"); 
	level._effect["cargo_vl_white_soft"]				= loadfx ("misc/cargo_vl_white_soft");
	level._effect["cargo_vl_white_eql"]					= loadfx ("misc/cargo_vl_white_eql");
	level._effect["cargo_vl_white_eql_flare"]			= loadfx ("misc/cargo_vl_white_eql_flare");
	level._effect["cargo_vl_red_lrg"]					= loadfx ("misc/cargo_vl_red_lrg");	
	level._effect["cargo_steam"]						= loadfx ("smoke/cargo_steam");

	//fx for helicopter
	level._effect["heli_spotlight"]						= loadfx ("misc/spotlight_medium_cargoship"); 
	level._effect["spotlight_dlight"]					= loadfx ("misc/spotlight_dlight"); 
	level._effect["cigar_glow"]							= loadfx ("fire/cigar_glow");
	level._effect["cigar_glow_puff"]					= loadfx ("fire/cigar_glow_puff");	
	level._effect["cigar_smoke_puff"]					= loadfx ("smoke/cigarsmoke_puff");
	level._effect["cigar_exhale"]						= loadfx ("smoke/cigarsmoke_exhale");
	level._effect["heli_minigun_shells"]				= loadfx ("shellejects/20mm_cargoship");
	
	//fx for heli interior/exterior lights
	level._effect["aircraft_light_cockpit_red"]			= loadfx ("misc/aircraft_light_cockpit_red_powerfull");
	level._effect["aircraft_light_cockpit_blue"]		= loadfx ("misc/aircraft_light_cockpit_blue");
	level._effect["aircraft_light_red_blink"]			= loadfx ("misc/aircraft_light_red_blink");
	level._effect["aircraft_light_white_blink"]			= loadfx ("misc/aircraft_light_white_blink");
	level._effect["aircraft_light_wingtip_green"]		= loadfx ("misc/aircraft_light_wingtip_green");
	level._effect["aircraft_light_wingtip_red"]			= loadfx ("misc/aircraft_light_wingtip_red");
	 
	//lights
	level._effect["cgoshp_lights_cr"]			= loadfx ("misc/cgoshp_lights_cr");
	level._effect["cgoshp_lights_flr"]			= loadfx ("misc/cgoshp_lights_flr"); 
	level._effect["flashlight"]					= loadfx ("misc/flashlight_cargoship");
 
	//ambient fx
	level._effect["watersplash"]				= loadfx ("misc/cargoship_splash");
	level._effect["cgo_ship_puddle_small"]		= loadfx ("distortion/cgo_ship_puddle_small");
	level._effect["cgo_ship_puddle_large"]		= loadfx ("distortion/cgo_ship_puddle_large");
	level._effect["cgoshp_drips"]			 	= loadfx ("misc/cgoshp_drips");
	level._effect["cgoshp_drips_a"]			 	= loadfx ("misc/cgoshp_drips_a");
	level._effect["rain_noise"]					= loadfx ("weather/rain_noise");
	level._effect["rain_noise_ud"]				= loadfx ("weather/rain_noise_ud");
	level._effect["fire_med_nosmoke"]			= loadfx ("fire/tank_fire_engine");
	level._effect["watersplash_small"]			= loadfx ("misc/watersplash_small");
	level._effect["water_gush"]					= loadfx ("misc/water_gush");
	level._effect["steam"]						= loadfx ("impacts/pipe_steam");

	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("metal",		loadfx ("impacts/footstep_water_dark"));

	// Rain
	level._effect["rain_heavy_mist_heli_hack"]	= loadfx ("weather/rain_heavy_mist_heli_hack");
	level._effect["rain_drops_fastrope"]		= loadfx ("weather/rain_drops_fastrope");

	level._effect["rain_heavy_cloudtype"]		= loadfx ("weather/rain_heavy_cloudtype");
	if( getdvarint( "r_zFeather" ) )
	{
		level._effect["rain_10"]	= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_9"]		= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_8"]		= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_7"]		= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_6"]		= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_5"]		= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_4"]		= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_3"]		= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_2"]		= loadfx ("weather/rain_heavy_mist");
		level._effect["rain_1"]		= loadfx ("weather/rain_heavy_mist");	
		level._effect["rain_0"]		= loadfx ("weather/rain_heavy_mist");
	}
	else
	{
		level._effect["rain_10"]	= loadfx ("misc/blank");
		level._effect["rain_9"]		= loadfx ("misc/blank");
		level._effect["rain_8"]		= loadfx ("misc/blank");
		level._effect["rain_7"]		= loadfx ("misc/blank");
		level._effect["rain_6"]		= loadfx ("misc/blank");
		level._effect["rain_5"]		= loadfx ("misc/blank");
		level._effect["rain_4"]		= loadfx ("misc/blank");
		level._effect["rain_3"]		= loadfx ("misc/blank");
		level._effect["rain_2"]		= loadfx ("misc/blank");
		level._effect["rain_1"]		= loadfx ("misc/blank");	
		level._effect["rain_0"]		= loadfx ("misc/blank");
	}
	
	
	//Explosions
//	level._effect["barrelExp"]	= loadfx ("props/barrelExp");

	
	thread rainControl(); // level specific rain settings.
	thread playerWeather(); // make the actual rain effect generate around the player
	
	// Thunder & Lightning
	level._effect["lightning"]				= loadfx ("weather/lightning");
	level._effect["lightning_bolt"]			= loadfx ("weather/lightning_bolt");
	level._effect["lightning_bolt_lrg"]		= loadfx ("weather/lightning_bolt_lrg");


	addLightningExploder(10); // these exploders make lightning flashes in the sky
	addLightningExploder(11);
	addLightningExploder(12);
	level.nextLightning = gettime() + 1;//10000 + randomfloat(4000); // sets when the first lightning of the level will go off
	
	//ambient fx

	thread treadfx_override();
	thread init_exploders();
	thread rampupsun();
}

treadfx_override()
{

	maps\_treadfx::setvehiclefx( "blackhawk", "brick" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "bark" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "carpet" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "cloth" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "concrete" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "dirt" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "flesh" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "foliage" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "glass" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "grass" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "gravel" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "ice" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "metal" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "mud" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "paper" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "plaster" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "rock" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "sand" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "snow" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "water" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "wood" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "asphalt" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "ceramic" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "plastic" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "rubber" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "cushion" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "fruit" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "painted metal" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "default" ,"treadfx/heli_dust_cargoship" );
	maps\_treadfx::setvehiclefx( "blackhawk", "none" ,"treadfx/heli_dust_cargoship" );

	maps\_treadfx::setvehiclefx( "seaknight", "brick" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "bark" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "carpet" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "cloth" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "concrete" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "dirt" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "flesh" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "foliage" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "glass" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "grass" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "gravel" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "ice" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "metal" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "mud" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "paper" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "plaster" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "rock" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "sand" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "snow" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "water" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "wood" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "asphalt" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "ceramic" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "plastic" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "rubber" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "cushion" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "fruit" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "painted metal" ,"treadfx/heli_dust_cargoship" );
 	maps\_treadfx::setvehiclefx( "seaknight", "default" ,"treadfx/heli_dust_cargoship" );
	maps\_treadfx::setvehiclefx( "seaknight", "none" ,"treadfx/heli_dust_cargoship" );


}


rainControl()
{
	// controls the temperment of the weather
	rainInit("hard"); // "none" "light" or "hard"
	
	if( level.jumpto == "start" )
		wait 40;
	
	thread lightning(::normal, ::flash); // starts up a lightning process with the level specific fog settings

}

rampupsun()
{
	color = level.truecolor;

	time = 10;
	
	range = [];
	range[0] = color[0] - level.orgsuncolor[0];
	range[1] = color[1] - level.orgsuncolor[1];
	range[2] = color[2] - level.orgsuncolor[2];
	
	passes = time * 5;
	
	interval = [];
	interval[0] = range[0] / (passes);
	interval[1] = range[1] / (passes);
	interval[2] = range[2] / (passes);
	
	wait 12;

	while(passes)
	{
		setsunlight( level.orgsuncolor[0], level.orgsuncolor[1], level.orgsuncolor[2] );
		level.orgsuncolor[0] += interval[0];
		level.orgsuncolor[1] += interval[1];
		level.orgsuncolor[2] += interval[2];
		wait .2;
		passes--;
	}
}

normal()
{
	level.sea_foam hide();
  
    resetSunLight();
	    
    level.fogvalue["near"] = 100;
	level.fogvalue["half"] = 4000;
    setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 0.1);

    setsunlight( level.orgsuncolor[0], level.orgsuncolor[1], level.orgsuncolor[2] );
    
    flag_set("cargoship_lighting_off"); 
    
    if( flag( "cargohold_fx" ) )
    {
		level.sea_black hide();
		level.sea_foam hide();
		return;
	}	
    level.sea_black show();
}

show_water()
{
	level.fogvalue["near"] = 100;
	level.fogvalue["half"] = 7000;
    setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 0.1);	
	
	if( flag( "cargohold_fx" ) )
    {
		level.sea_black hide();
		level.sea_foam hide();
		return;
	}	
	
	level.sea_foam show();
	level.sea_black hide();
}

init_exploders()
{
	waittillframeend;
	/********************************************************************************/
	/*              			 HEY ROBERT	  						*/
	/*																				*/
	/*	You're wondering wtf this is...by putting the exploder into this array, 	*/
	/*	we can call it dynamically based on the boat tilt and player position		*/
	/*																				*/
	/********************************************************************************/
	level._waves_exploders = getfxarraybyID( "watersplash" );

	// various lightning sky effects around the level
	/********************************************************************************/
	/*              			 HEY ROBERT	  						*/
	/*																				*/
	/*	You're wondering wtf this is...by putting the exploder into this array, 	*/
	/*	we can change it's origin relative to the world position					*/
	/*																				*/
	/********************************************************************************/
	level._lighting_exploders = getfxarraybyID( "lightning" );
	
	for(i=0; i< level._lighting_exploders.size; i++)
		level._lighting_exploders[i].v["cargoship_origin"] = level._lighting_exploders[i].v["origin"]; 
	
}

update_exploders()
{
	for(i=0; i< level._lighting_exploders.size; i++)
		level._lighting_exploders[i].v["origin"] = level._sea_org localtoworldcoords(level._lighting_exploders[i].v["cargoship_origin"]);
}

flash(flshmin, flshmax, strmin, strmax, dir)
{		
	level notify("CS_lighting_flash");
	level endon("CS_lighting_flash");
	if(level.createFX_enabled)
		return;
	
	if( flag("cargohold_fx") )
	{
		normal();
		return;
	}
	add = undefined;
	
	if(isdefined(dir))
		add = dir;
	else
		add = ( (randomfloatrange(20, 30) * -1), (randomfloatrange(20, 25)), 0 );
   
		min = 1;
		max = 4;
		
		if(isdefined(flshmin))
    		min = flshmin;
    	if(isdefined(flshmax) && flshmax < max)
    		max = flshmax;
		
   	num = randomintrange(min, max);
   
  		min = 0;
    	max = 3;
 
    	if(isdefined(strmin))
    		min = strmin;
    	if(isdefined(strmax) && strmax < max)
    		max = strmax;
    		
    for(i=0; i<num; i++)
    { 
    	type = randomintrange(min, max);
	    switch(type)
	    {
	    	case 0:{
	    		wait (0.05);
			    flag_clear("cargoship_lighting_off");
			    
			    update_exploders();
			    setSunLight( 1, 1, 1.2 );
			   	show_water();
			    
			    angle = level.new_lite_settings + add;
			    vec = anglestoforward( angle );
			    setSunDirection( vec );
			    wait (0.05);
			    
			    update_exploders();
			    setSunLight( 2, 2, 2.5 );
			    angle = level.new_lite_settings + add;
			    vec = anglestoforward( angle );
			    setSunDirection( vec );
			 
	    		}break;  	
	    		
	    	case 1:{
	    		wait (0.05);
			    flag_clear("cargoship_lighting_off");
	    		
	    		update_exploders();
	    		setSunLight( 1, 1, 1.2 );
	    		show_water();
	    		
	    		angle = level.new_lite_settings + add;
	    		vec = anglestoforward( angle );
			    setSunDirection( vec );
			    wait (0.05);
			  
			  	update_exploders();
			    setSunLight( 2, 2, 2.5 );
			    angle = level.new_lite_settings + add;
			    vec = anglestoforward( angle );
			    setSunDirection( vec );
			   	wait (0.05);
			    
			    update_exploders();
			    setSunLight( 3, 3, 3.7 );
			    angle = level.new_lite_settings + add;
			    vec = anglestoforward( angle );
			    setSunDirection( vec );
			  
	    		}break;
	    	
	    	case 2:{
	    		wait (0.05);
			    flag_clear("cargoship_lighting_off");
	    		
	    		update_exploders();
	    		setSunLight( 1, 1, 1.2 );
	    		show_water();
	    		
	    		angle = level.new_lite_settings + add;
				vec = anglestoforward( angle );
			    setSunDirection( vec );
			    wait (0.05);
			  
			  	update_exploders();
			    setSunLight( 2, 2, 2.5 );
			    angle = level.new_lite_settings + add;
			    vec = anglestoforward( angle );
			    setSunDirection( vec );
			   	wait (0.05);
			    
			    update_exploders();
			    setSunLight( 3, 3, 3.7 );
			    angle = level.new_lite_settings + add;
			    vec = anglestoforward( angle );
			    setSunDirection( vec );
			    wait (0.05);
			    
			    update_exploders();
			    setSunLight( 4, 4, 5 );
			    angle = level.new_lite_settings + add;
			    vec = anglestoforward( angle );
			    setSunDirection( vec );
			  
	    		}break;
	    }
	    wait randomfloatrange(0.05, 0.1);
   		normal();
    }
    normal();
}

