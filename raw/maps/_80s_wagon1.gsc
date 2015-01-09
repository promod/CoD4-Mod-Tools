#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree ("vehicles");
main(model,type)
{
	build_template( "80s_wagon1", model, type );
	build_localinit( ::init_local );
	build_destructible( "vehicle_80s_wagon1_brn_destructible" , "vehicle_80s_wagon1_brn" );
	build_destructible( "vehicle_80s_wagon1_green_destructible" , "vehicle_80s_wagon1_green" );
	build_destructible( "vehicle_80s_wagon1_red_destructible" , "vehicle_80s_wagon1_red" );
	build_destructible( "vehicle_80s_wagon1_silv_destructible" , "vehicle_80s_wagon1_silv" );
	build_destructible( "vehicle_80s_wagon1_tan_destructible" , "vehicle_80s_wagon1_tan" );
	build_destructible( "vehicle_80s_wagon1_yel_destructible" , "vehicle_80s_wagon1_yel" );

	build_drive( %technical_driving_idle_forward, %technical_driving_idle_backward, 10 );

	build_deathfx( "explosions/large_vehicle_explosion",undefined,"explo_metal_rand");
//	build_drive( %technical_driving_idle_forward, %technical_driving_idle_backward, 10 );

//	build_treadfx();
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

setanims ()
{
	positions = [];
	return positions; // no anims yet
/*
	for(i=0;i<4;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "body_animate_jnt";
	positions[1].sittag = "body_animate_jnt";
	positions[2].sittag = "tag_passenger";
	positions[3].sittag = "body_animate_jnt";

	positions[0].idle = %humvee_driver_climb_idle;
	positions[1].idle = %humvee_passenger_idle_L;
	positions[2].idle = %humvee_passenger_idle_R;
	positions[3].idle = %humvee_passenger_idle_R;

	positions[0].getout = %humvee_driver_climb_out;
	positions[1].getout = %humvee_passenger_out_L;
	positions[2].getout = %humvee_passenger_out_R;
	positions[3].getout = %humvee_passenger_out_R;

	positions[0].getin = %humvee_driver_climb_in;
	positions[1].getin = %humvee_passenger_in_L;
	positions[2].getin = %humvee_passenger_in_R;
	positions[3].getin = %humvee_passenger_in_R;

*/
	return positions;
}

