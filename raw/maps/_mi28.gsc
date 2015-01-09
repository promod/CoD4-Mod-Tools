#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "mi28", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_mi-28_flying" );
	build_drive( %mi28_rotors, undefined, 0, 3.0 );
	
//	build_deathfx( "explosions/grenadeexp_default" , 		"tag_engine_rear_left", 		"blackhawk_helicopter_hit", 		undefined, 			undefined, 		undefined, 		0.2, 		true );
//	build_deathfx( "explosions/grenadeexp_default" , 		"main_rotor_jnt", 		"blackhawk_helicopter_hit", 		undefined, 			undefined, 		undefined, 		0.5, 		true );
	build_deathfx( "fire/fire_smoke_trail_L" , 				"main_rotor_jnt", 		"havoc_helicopter_dying_loop", 	true, 				0.05, 			true, 			0.5, 		true );
//	build_deathfx( "explosions/aerial_explosion" , 			"tag_engine_rear_right", 	"blackhawk_helicopter_hit", 		undefined, 			undefined, 		undefined, 		2.5, 		true );
//	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_mainturret();
	build_aianims( ::setanims , ::set_vehicle_anims );
	
	build_light( model, "wingtip_green", 		"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 		0.1 );
	build_light( model, "wingtip_red", 			"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 		0.0 );
	build_light( model, "white_blink", 			"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 		0.0 );
	build_light( model, "white_blink_tail", 	"tag_light_tail", 		"misc/aircraft_light_red_blink", 		"running", 		0.4 );
}

init_local()
{
//	self.delete_on_death = true;
	self.script_badplace = false;// All helicopters dont need to create bad places
	self.script_light_toggle = true;
	maps\_vehicle::lights_on( "running" );
}

set_vehicle_anims( positions )
{
	return positions;
}

#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	for ( i = 0;i < 2;i++ )
		positions[ i ] = spawnstruct();
		
	positions[ 0 ].sittag = "tag_pilot";
	positions[ 1 ].sittag = "tag_gunner";

	positions[ 0 ].idle[ 0 ] = %helicopter_pilot1_idle;
	positions[ 0 ].idle[ 1 ] = %helicopter_pilot1_twitch_clickpannel;
	positions[ 0 ].idle[ 2 ] = %helicopter_pilot1_twitch_lookback;
	positions[ 0 ].idle[ 3 ] = %helicopter_pilot1_twitch_lookoutside;
	positions[ 0 ].idleoccurrence[ 0 ] = 500;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;	
	positions[ 0 ].idleoccurrence[ 2 ] = 100;	
	positions[ 0 ].idleoccurrence[ 3 ] = 100;	

	positions[ 1 ].idle[ 0 ] = %helicopter_pilot2_idle;
	positions[ 1 ].idle[ 1 ] = %helicopter_pilot2_twitch_clickpannel;
	positions[ 1 ].idle[ 2 ] = %helicopter_pilot2_twitch_lookoutside;
	positions[ 1 ].idle[ 3 ] = %helicopter_pilot2_twitch_radio;
	positions[ 1 ].idleoccurrence[ 0 ] = 450;
	positions[ 1 ].idleoccurrence[ 1 ] = 100;	
	positions[ 1 ].idleoccurrence[ 2 ] = 100;	
	positions[ 1 ].idleoccurrence[ 3 ] = 100;	
	
	positions[ 0 ].bHasGunWhileRiding = false;	
	positions[ 1 ].bHasGunWhileRiding = false;	


	return positions;
	
// add generic helicopter pilot anims
// - helicopter_pilot1_idle
// - helicopter_pilot1_twitch_clickpannel
// - helicopter_pilot1_twitch_lookback
// - helicopter_pilot1_twitch_lookoutside
// - helicopter_pilot2_idle
// - helicopter_pilot2_twitch_clickpannel
// - helicopter_pilot2_twitch_lookoutside
// - helicopter_pilot2_twitch_radio
// - adjust mi17 / mi24 / mi28 / cobra tag for new anims	

}