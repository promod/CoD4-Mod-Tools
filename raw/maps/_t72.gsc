#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "t72", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_t72_tank", "vehicle_t72_tank_d_body", 3.7 );
	build_deathmodel( "vehicle_t72_tank_low", "vehicle_t72_tank_d_body", 3.7 );
	build_deathmodel( "vehicle_t72_tank_woodland", "vehicle_t72_tank_d_woodland_body", 3.7 );
	build_shoot_shock( "tankblast" );
	build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
//	build_deathfx( <type> , 			<effect> , 				<tag> , 				<sound> , 				<bEffectLooping> 		<delay> , 		<bSoundlooping> , 	<waitDelay> , <stayontag> , <notifyString> )"
//	build_deathfx( "explosions/grenadeexp_default",		 		"tag_engine_left", 		"explo_metal_rand",			undefined,			undefined,		undefined,		0  );
//	build_deathfx( "fire/firelp_large_pm",		 				"tag_engine_left", 		undefined,					undefined,			undefined,		undefined,		0  );
//	build_deathfx( "explosions/tank_ammo_breach",				"tag_deathfx",			undefined,					undefined,			undefined,		undefined,		0 );
	build_deathfx( "explosions/vehicle_explosion_t72", 			"tag_deathfx",			"exp_armor_vehicle",		undefined,			undefined,		undefined,		0 );
	build_deathfx( "fire/firelp_large_pm", 						"tag_deathfx",			"fire_metal_medium",		undefined,			undefined,		true,			0 );


	build_turret( "t72_turret2" , "tag_turret2" , "vehicle_t72_tank_pkt_coaxial_mg" , false );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "allies" );
	build_mainturret();
	build_frontarmor( .33 ); //regens this much of the damage from attacks to the front
}

init_local()
{
}

set_vehicle_anims( positions )
{
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<11;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].getout_delete = true;


	return positions;
}

