#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "bm21_troops", model, type );
	build_localinit( ::init_local );

	build_destructible( "vehicle_bm21_mobile_bed_destructible", "vehicle_bm21_mobile_bed" );
	build_destructible( "vehicle_bm21_bed_under_destructible", "vehicle_bm21_bed_under" );
	build_destructible( "vehicle_bm21_cover_destructible", "vehicle_bm21_cover" );
	build_destructible( "vehicle_bm21_cover_under_destructible", "vehicle_bm21_cover_under" );
	
	build_deathmodel( "vehicle_bm21_mobile", "vehicle_bm21_mobile_dstry" );  
	build_deathmodel( "vehicle_bm21_mobile_cover", "vehicle_bm21_mobile_cover_dstry" );
	build_deathmodel( "vehicle_bm21_mobile_bed", "vehicle_bm21_mobile_bed_dstry" );
	build_deathmodel( "vehicle_bm21_mobile_cover_no_bench", "vehicle_bm21_mobile_cover_dstry" );  
	
//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	
	// 	build_deathfx( effect, 								tag, 					sound, 								bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "explosions/large_vehicle_explosion", 	undefined, 				"car_explode", 						undefined, 			undefined, 		undefined, 		0 );
	build_deathfx( "fire/firelp_med_pm", 					"tag_fx_tire_right_r", 	undefined, 							undefined, 			undefined, 		true, 			0 );
	build_deathfx( "fire/firelp_med_pm", 					"tag_fx_cab", 			"fire_metal_medium", 				undefined, 			undefined, 		undefined, 			0 );
	build_deathfx( "explosions/small_vehicle_explosion", 	"tag_fx_tank", 			"explo_metal_rand", 				undefined, 			undefined, 		undefined, 		2 );

	build_deathquake( 1, 1.6, 500 );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_treadfx();

	build_bulletshield( true );
	
	build_aianims( ::setanims, ::set_vehicle_anims );
	build_unload_groups( ::Unload_Groups );

	build_light( model, "headlight_truck_left", "tag_headlight_left", "misc/lighthaze", 					"headlights" );
	build_light( model, "headlight_truck_right", "tag_headlight_right", "misc/lighthaze", 				"headlights" );
	build_light( model, "headlight_truck_left2", 		"tag_headlight_left", 		"misc/car_headlight_bm21", 		"headlights" );
	build_light( model, "headlight_truck_right2", 		"tag_headlight_right", 		"misc/car_headlight_bm21", 		"headlights" );
	build_light( model, "parkinglight_truck_left_f", 	"tag_parkinglight_left_f", 	"misc/car_parkinglight_bm21", 	"headlights" );
	build_light( model, "parkinglight_truck_right_f", 	"tag_parkinglight_right_f", "misc/car_parkinglight_bm21", 	"headlights" );
	build_light( model, "taillight_truck_right", 	 	"tag_taillight_right", 		"misc/car_taillight_bm21", 		"headlights" );
	build_light( model, "taillight_truck_left", 		 	"tag_taillight_left", 		"misc/car_taillight_bm21", 		"headlights" );

	build_light( model, "brakelight_troops_right", 		"tag_taillight_right", 		"misc/car_taillight_bm21", 		"brakelights" );
	build_light( model, "brakelight_troops_left", 		"tag_taillight_left", 		"misc/car_taillight_bm21", 		"brakelights" );

	build_drive( %bm21_driving_idle_forward, %bm21_driving_idle_backward, 10 );
	
}

init_local()
{
// 	maps\_vehicle::lights_on( "headlights" );
// 	maps\_vehicle::lights_on( "brakelights" );

}


set_vehicle_anims( positions )
{
	
	positions[ 0 ].vehicle_getoutanim = %bm21_driver_climbout_door;
	positions[ 1 ].vehicle_getoutanim = %bm21_passenger_climbout_door;
	positions[ 2 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	positions[ 3 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	positions[ 4 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	positions[ 5 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	positions[ 6 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	positions[ 7 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	positions[ 8 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	positions[ 9 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	
	positions[ 0 ].vehicle_getoutsoundtag = "left_door";
	positions[ 1 ].vehicle_getoutsoundtag = "right_door";
	positions[ 2 ].vehicle_getoutsoundtag = "back_board";
	positions[ 3 ].vehicle_getoutsoundtag = "back_board";
	positions[ 4 ].vehicle_getoutsoundtag = "back_board";
	positions[ 5 ].vehicle_getoutsoundtag = "back_board";
	positions[ 6 ].vehicle_getoutsoundtag = "back_board";
	positions[ 7 ].vehicle_getoutsoundtag = "back_board";
	positions[ 8 ].vehicle_getoutsoundtag = "back_board";
	positions[ 9 ].vehicle_getoutsoundtag = "back_board";
	
//	positions[ 3 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
//	positions[ 4 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
//	positions[ 5 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
//	positions[ 6 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
//	positions[ 7 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
//	positions[ 8 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
//	positions[ 9 ].vehicle_getoutanim = %bm21_guy_climbout_truckdoor;
	
	positions[ 0 ].vehicle_getoutanim_clear = true;
	positions[ 1 ].vehicle_getoutanim_clear = true;
	positions[ 2 ].vehicle_getoutanim_clear = false;
	positions[ 3 ].vehicle_getoutanim_clear = false;
	positions[ 4 ].vehicle_getoutanim_clear = false;
	positions[ 5 ].vehicle_getoutanim_clear = false;
	positions[ 6 ].vehicle_getoutanim_clear = false;
	positions[ 7 ].vehicle_getoutanim_clear = false;
	positions[ 8 ].vehicle_getoutanim_clear = false;
	positions[ 9 ].vehicle_getoutanim_clear = false;

	return positions;
}

#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for ( i = 0;i < 10;i ++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_detach";// RR
	positions[ 3 ].sittag = "tag_detach"; // RR
	positions[ 4 ].sittag = "tag_detach";// RR
	positions[ 5 ].sittag = "tag_detach"; // RR
	positions[ 6 ].sittag = "tag_detach";// RL
	positions[ 7 ].sittag = "tag_detach"; // RL
	positions[ 8 ].sittag = "tag_detach";// RL
	positions[ 9 ].sittag = "tag_detach";// RL

	positions[ 0 ].idle = %bm21_driver_idle;
	positions[ 1 ].idle = %bm21_passenger_idle;
	positions[ 2 ].idle = %bm21_guy1_idle;
	positions[ 3 ].idle = %bm21_guy2_idle;
	positions[ 4 ].idle = %bm21_guy3_idle;
	positions[ 5 ].idle = %bm21_guy4_idle;
	positions[ 6 ].idle = %bm21_guy5_idle;
	positions[ 7 ].idle = %bm21_guy6_idle;
	positions[ 8 ].idle = %bm21_guy7_idle;
	positions[ 9 ].idle = %bm21_guy8_idle;

	positions[ 0 ].getout = %bm21_driver_climbout;
	positions[ 1 ].getout = %bm21_passenger_climbout;
	positions[ 2 ].getout = %bm21_guy1_climbout;
	positions[ 3 ].getout = %bm21_guy2_climbout;
	positions[ 4 ].getout = %bm21_guy3_climbout;
	positions[ 5 ].getout = %bm21_guy4_climbout;
	positions[ 6 ].getout = %bm21_guy5_climbout;
	positions[ 7 ].getout = %bm21_guy6_climbout;
	positions[ 8 ].getout = %bm21_guy7_climbout;
	positions[ 9 ].getout = %bm21_guy8_climbout;
	
	positions[ 2 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 3 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 4 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 6 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 7 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 8 ].getout_secondary = %bm21_guy_climbout_landing;

	positions[ 2 ].explosion_death = %death_explosion_up10;
	positions[ 3 ].explosion_death = %death_explosion_up10;
	positions[ 4 ].explosion_death = %death_explosion_up10;
	positions[ 5 ].explosion_death = %death_explosion_up10;
	positions[ 6 ].explosion_death = %death_explosion_up10;
	positions[ 7 ].explosion_death = %death_explosion_up10;
	positions[ 8 ].explosion_death = %death_explosion_up10;
	positions[ 9 ].explosion_death = %death_explosion_up10;

	return positions;

}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "all" ] = [];

	group = "passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	unload_groups[ group ][ unload_groups[ group ].size ] = 9;

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	unload_groups[ group ][ unload_groups[ group ].size ] = 9;
	
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
}
