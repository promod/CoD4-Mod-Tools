#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );

main( model, type )
{
	build_template( "m1a1", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_m1a1_abrams", "vehicle_m1a1_abrams_dmg" );
	build_shoot_shock( "tankblast" );
	build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
	build_exhaust( "distortion/abrams_exhaust" );
	build_deckdust( "dust/abrams_desk_dust" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "exp_armor_vehicle" );
	build_turret( "m1a1_coaxial_mg", "tag_coax_mg", "vehicle_m1a1_abrams_PKT_Coaxial_MG", false );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 900, 1, 1 );
	build_team( "allies" );
	build_mainturret();
	build_compassicon();
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_frontarmor( .33 ); //regens this much of the damage from attacks to the front
}

init_local()
{
}

set_vehicle_anims( positions )
{
	/*
	positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	positions[ 1 ].vehicle_getoutanim = %tigertank_hatch_open;
	*/
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
