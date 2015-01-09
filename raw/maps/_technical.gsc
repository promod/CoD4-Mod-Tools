#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "technical", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_pickup_technical", "vehicle_pickup_technical_destroyed", 3 );
	build_turret( "50cal_turret_technical", "tag_50cal", "weapon_pickup_technical_mg50cal", true, undefined, undefined, undefined, 2.9 );
	
	
	build_drive( %technical_driving_idle_forward, %technical_driving_idle_backward, 10 );

	//	build_deathfx( effect, 									tag, 					sound, 				bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "fire/firelp_med_pm",						"tag_fx_tank",			"smallfire",		undefined,			undefined,		true,			0 );
	build_deathfx( "explosions/ammo_cookoff",					"tag_fx_bed",			undefined,			undefined,			undefined,		undefined,		0.5 );
//	build_deathfx( "explosions/ammo_cookoff",					"tag_fx_bed",			undefined,			undefined,			undefined,		undefined,		1 );
	build_deathfx( "explosions/Vehicle_Explosion_Pickuptruck",	"tag_deathfx",			"car_explode",		undefined,			undefined,		undefined,		2.9 );
	build_deathfx( "fire/firelp_small_pm_a",					"tag_fx_tire_right_r",	"smallfire",		undefined,			undefined,		true,			3 );
	build_deathfx( "fire/firelp_med_pm",						"tag_fx_cab",			"fire_metal_medium",undefined,			undefined,		true,			3.01 );
	build_deathfx( "fire/firelp_small_pm_a",					"tag_engine_left",		"smallfire",		undefined,			undefined,		true,			3.01 );

	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::Unload_Groups );
	
	build_light( model, "headlight_truck_left", 		"tag_headlight_left", 		"misc/car_headlight_truck_L", 		"headlights" );
	build_light( model, "headlight_truck_right", 		"tag_headlight_right", 		"misc/car_headlight_truck_R", 		"headlights" );
	build_light( model, "parkinglight_truck_left_f",	"tag_parkinglight_left_f", 	"misc/car_parkinglight_truck_LF", 	"headlights" );
	build_light( model, "parkinglight_truck_right_f", 	"tag_parkinglight_right_f", "misc/car_parkinglight_truck_RF",	"headlights" );
	build_light( model, "taillight_truck_right",	 	"tag_taillight_right", 		"misc/car_taillight_truck_R", 		"headlights" );
	build_light( model, "taillight_truck_left",		 	"tag_taillight_left", 		"misc/car_taillight_truck_L", 		"headlights" );

	build_light( model, "brakelight_truck_right", 		"tag_taillight_right", 		"misc/car_brakelight_truck_R", 		"brakelights" );
	build_light( model, "brakelight_truck_left", 		"tag_taillight_left", 		"misc/car_brakelight_truck_L", 		"brakelights" );
	
	build_death_badplace( .5, 3, 512, 700, "axis","allies" );
	build_death_jolt( 2.9 );
	
	//"Name: build_radiusdamage( <offset> , <range> , <maxdamage> , <mindamage> , <bKillplayer> )"
	build_radiusdamage( ( 0, 0, 53 ), 512, 300, 20, true, 2.9 );
}

set_vehicle_anims( positions )
{
	return positions;
}

init_local()
{
//	maps\_vehicle::lights_on( "headlights" );
//	maps\_vehicle::lights_on( "brakelights" );

}

#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<3;i++ )
		positions[ i ] = spawnstruct();
/*
rough pass

technical_driver_duck
technical_driver_idle
technical_driver_climb_out


technical_passenger_duck
technical_passenger_idle


technical_passenger_climb_out
technical_turret_aim_2
technical_turret_aim_8
technical_turret_death
technical_turret_jam
technical_turret_turn_L
technical_turret_turn_R
door_technical_driver_climb_out
door_technical_passenger_climb_out
*/
//	positions[ 0 ].getout_delete = true;

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_gunner";
	positions[ 2 ].sittag = "tag_passenger";

	positions[ 0 ].idle[ 0 ] = %technical_driver_idle;
	positions[ 0 ].idle[ 1 ] = %technical_driver_duck;
	positions[ 0 ].idleoccurrence[ 0 ] = 1000;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;
	
	positions[ 0 ].death = %technical_driver_fallout;
	positions[ 2 ].death = %technical_passenger_fallout;

	positions[ 0 ].unload_ondeath = .9;
	positions[ 1 ].unload_ondeath = .9;  //doesn't have unload but lets other parts know not to delete him.
	positions[ 2 ].unload_ondeath = .9;
	
/*  no anim for machine gun guy just yet
	positions[ 1 ].idle[ 0 ] = %technical_driver_idle;
	positions[ 1 ].idle[ 1 ] = %technical_driver_duck;
	positions[ 1 ].idleoccurrence[ 0 ] = 1000;
	positions[ 1 ].idleoccurrence[ 1 ] = 100;
*/	
	positions[ 2 ].idle[ 0 ] = %technical_passenger_idle;
	positions[ 2 ].idle[ 1 ] = %technical_passenger_duck;
	positions[ 2 ].idleoccurrence[ 0 ] = 1000;
	positions[ 2 ].idleoccurrence[ 1 ] = 100;

	positions[ 0 ].getout = %technical_driver_climb_out;
//	positions[ 1 ].getout = %humvee_passenger_out_L;
	positions[ 2 ].getout = %technical_passenger_climb_out;

	//positions[ 0 ].getin = %humvee_driver_climb_idle;
	//positions[ 1 ].getin = %humvee_passenger_in_L;
	//positions[ 2 ].getin = %humvee_passenger_in_R;
	
//	positions[ 1 ].deathscript = ::deleteme;
	
//	positions[ 0 ].explosion_death = %death_explosion_left11;
//	positions[ 1 ].explosion_death = %death_explosion_back13;
//	positions[ 2 ].explosion_death = %death_explosion_right13;
//
//	positions[ 0 ].explosion_death_offset = (0,0,-24);
//	positions[ 1 ].explosion_death_offset = (-16,0,-24);
//	positions[ 2 ].explosion_death_offset = (0,0,-24);
//		
//	positions[ 0 ].explosion_death_ragdollfraction = .3;
//	positions[ 1 ].explosion_death_ragdollfraction = .3;
//	positions[ 2 ].explosion_death_ragdollfraction = .3;

	positions[ 1 ].mgturret = 0; // which of the turrets is this guy going to use

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "passenger_and_gunner" ] = [];
	unload_groups[ "all" ] = [];

	group = "passenger_and_gunner";
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;

	group = "passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
	
}
