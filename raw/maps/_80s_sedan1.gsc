#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree ("vehicles");
main(model,type)
{
	build_template( "80s_sedan1", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_80s_sedan1_brn" , "vehicle_80s_sedan1_brn_destroyed" );
	build_deathmodel( "vehicle_80s_sedan1_green" , "vehicle_80s_sedan1_green_destroyed" );
	build_deathmodel( "vehicle_80s_sedan1_red" , "vehicle_80s_sedan1_red_destroyed" );
	build_deathmodel( "vehicle_80s_sedan1_silv" , "vehicle_80s_sedan1_silv_destroyed" );
	build_deathmodel( "vehicle_80s_sedan1_tan" , "vehicle_80s_sedan1_tan_destroyed" );
	build_deathmodel( "vehicle_80s_sedan1_yel" , "vehicle_80s_sedan1_yel_destroyed" );
	
//	vehicle_80s_sedan1_brn_destructible
	build_destructible( "vehicle_80s_sedan1_brn_destructible" , "vehicle_80s_sedan1_brn" );
	build_destructible( "vehicle_80s_sedan1_green_destructible" , "vehicle_80s_sedan1_green" );
	build_destructible( "vehicle_80s_sedan1_red_destructible" , "vehicle_80s_sedan1_red" );
	build_destructible( "vehicle_80s_sedan1_silv_destructible" , "vehicle_80s_sedan1_silv" );
	build_destructible( "vehicle_80s_sedan1_tan_destructible" , "vehicle_80s_sedan1_tan" );
	build_destructible( "vehicle_80s_sedan1_yel_destructible" , "vehicle_80s_sedan1_yel" );
	build_drive( %technical_driving_idle_forward, %technical_driving_idle_backward, 10 );
	
	build_treadfx();
	build_life ( 999, 500, 1500 );
	build_team( "allies");
	build_aianims( ::setanims , ::set_vehicle_anims );
}

init_local()
{
	
}

set_vehicle_anims(positions)
{
	return positions;
}


#using_animtree ("generic_human");

setanims()
{
	positions = [];

	for( i=0;i<1;i++ )
		positions[ i ] = spawnstruct();
	positions[ 0 ].sittag = "tag_driver";
	positions[ 0 ].idle= %luxurysedan_driver_idle;

	return positions;
}

