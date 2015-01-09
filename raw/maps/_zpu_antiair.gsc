#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "zpu_antiair", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_zpu4", "vehicle_zpu4_burn" );
	build_deathmodel( "vehicle_zpu4_low", "vehicle_zpu4_burn" );

	zpu_death_fx = [];
	zpu_death_fx[ "vehicle_zpu4" ] = "explosions/vehicle_explosion_bmp";
	zpu_death_fx[ "vehicle_zpu4_low" ] = "explosions/vehicle_explosion_bmp";
	
	build_deathfx( zpu_death_fx[ model ], undefined, "exp_armor_vehicle", undefined, undefined,	undefined, 0 );

	build_mainturret( "tag_flash","tag_flash2","tag_flash1","tag_flash3" );	
	build_radiusdamage( ( 0, 0, 53 ), 512, 300, 20, false );

	build_life( 999, 500, 1500 );
	
	build_team( "axis" );
	build_aianims( ::setanims , ::set_vehicle_anims );
}

init_local()
{
}

set_vehicle_anims( positions )
{
	positions[ 0 ].vehicle_turret_fire = %zpu_gun_fire_a;
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<1;i++ )
		positions[ i ] = spawnstruct();
	
	positions[ 0 ].sittag = "tag_driver";
//	positions[ 0 ].turret_fire = %zpu_gunner_fire_a;
	positions[ 0 ].idle = %zpu_gunner_fire_a;

	return positions;
}

