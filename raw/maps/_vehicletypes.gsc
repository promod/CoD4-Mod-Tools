setup_types( model, type )
{
	level.vehicle_types = [];
	level.vehicle_compass_types = [];
	
	// vehicletype , model
	// assigns vehicletypes to models in the game so we don't have to put vehicletype on everything in radiant
		
	set_type( "80s_wagon1", "vehicle_80s_wagon1_brn_destructible");
	set_type( "80s_wagon1", "vehicle_80s_wagon1_green_destructible");
	set_type( "80s_wagon1", "vehicle_80s_wagon1_red_destructible");
	set_type( "80s_wagon1", "vehicle_80s_wagon1_silv_destructible");
	set_type( "80s_wagon1", "vehicle_80s_wagon1_tan_destructible");
	set_type( "80s_wagon1", "vehicle_80s_wagon1_yel_destructible");
	set_compassType( "80s_wagon1", "automobile" );
	
	set_type( "apache", "vehicle_apache");
	set_type( "apache", "vehicle_apache_dark");
	set_compassType( "apache", "helicopter" );
	
	set_type( "blackhawk", "vehicle_blackhawk");
	set_type( "blackhawk", "vehicle_blackhawk_low");
	set_type( "blackhawk", "vehicle_blackhawk_low_thermal");
	set_compassType( "blackhawk", "helicopter" );
	
	set_type( "bm21", "vehicle_bm21_mobile_dstry");
	set_compassType( "bm21", "automobile" );

	set_type( "bm21_troops", "vehicle_bm21_mobile_bed_destructible");
	set_type( "bm21_troops", "vehicle_bm21_mobile");
	set_type( "bm21_troops", "vehicle_bm21_mobile_bed");
	set_type( "bm21_troops", "vehicle_bm21_mobile_cover_no_bench");
	set_type( "bm21_troops", "vehicle_bm21_mobile_cover");
	set_type( "bm21_troops", "vehicle_bm21_cover_destructible");
	set_type( "bm21_troops", "vehicle_bm21_bed_under_destructible");
	set_type( "bm21_troops", "vehicle_bm21_mobile_bed_destructible");
	set_compassType( "bm21_troops", "automobile" );

	set_type( "bmp", "vehicle_bmp");
	set_type( "bmp", "vehicle_bmp_woodland");
	set_type( "bmp", "vehicle_bmp_woodland_jeepride");
	set_type( "bmp", "vehicle_bmp_woodland_low");
	set_type( "bmp", "vehicle_bmp_desert");
	set_type( "bmp", "vehicle_bmp_thermal");
	set_type( "bmp", "vehicle_bmp_low");
	set_compassType( "bmp", "automobile" );

	set_type( "bradley", "vehicle_bradley");
	set_compassType( "bradley", "tank" );

	set_type( "bus","vehicle_bus_destructable" );                        
	set_compassType( "bus", "automobile" );

	set_type( "camera", "vehicle_camera");
	set_compassType( "camera", "" );
	
	set_type( "cobra", "vehicle_cobra_helicopter");
	set_type( "cobra", "vehicle_cobra_helicopter_fly");
	set_compassType( "cobra", "helicopter" );

	set_type( "80s_hatch1", "vehicle_80s_hatch1_brn_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_green_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_red_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_silv_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_tan_destructible");
	set_type( "80s_hatch1", "vehicle_80s_hatch1_yel_destructible");
	set_compassType( "80s_hatch1", "automobile" );

	set_type( "80s_sedan1", "vehicle_80s_sedan1_brn_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_green_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_red_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_silv_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_tan_destructible");
	set_type( "80s_sedan1", "vehicle_80s_sedan1_yel_destructible");
	set_compassType( "80s_sedan1", "automobile" );
	      
	set_type( "hind", "vehicle_mi24p_hind_desert");
	set_type( "hind", "vehicle_mi24p_hind_woodland");
	set_type( "hind", "vehicle_mi24p_hind_woodland_opened_door");
	set_compassType( "hind", "helicopter" );
        
	set_type( "humvee", "vehicle_humvee_camo");
	set_type( "humvee", "vehicle_humvee_camo_50cal_doors");
	set_type( "humvee", "vehicle_humvee_camo_50cal_nodoors");
	set_compassType( "humvee", "automobile" );
	
	set_type( "luxurysedan", "vehicle_luxurysedan");
	set_type( "luxurysedan", "vehicle_luxurysedan_test");
	set_type( "luxurysedan", "vehicle_luxurysedan_viewmodel");
	set_compassType( "luxurysedan", "automobile" );
	
	set_type( "m1a1", "vehicle_m1a1_abrams");
	set_compassType( "m1a1", "tank" );

	set_type( "mi17", "vehicle_mi17_woodland");
	set_type( "mi17", "vehicle_mi17_woodland_fly");
	set_type( "mi17", "vehicle_mi17_woodland_fly_cheap");
	set_compassType( "mi17", "helicopter" );
	
	set_type( "mig29", "vehicle_mig29_desert");
	set_type( "mig29", "vehicle_av8b_harrier_jet");
	set_compassType( "mig29", "plane" );
	
	set_type( "sa6", "vehicle_sa6_no_missiles_desert");
	set_type( "sa6", "vehicle_sa6_no_missiles_woodland");
	set_compassType( "sa6", "" );

	set_type( "seaknight", "vehicle_ch46e");
	set_compassType( "seaknight", "helicopter" );

	set_type( "seaknight_airlift", "vehicle_ch46e_opened_door");
	set_compassType( "seaknight_airlift", "helicopter" );
	
	set_type( "small_hatchback", "vehicle_small_hatchback_blue");
	set_type( "small_hatchback", "vehicle_small_hatchback_green");
	set_type( "small_hatchback", "vehicle_small_hatchback_turq");
	set_type( "small_hatchback", "vehicle_small_hatchback_white");
	set_type( "small_hatchback", "vehicle_small_hatch_turq_destructible");
	set_type( "small_hatchback", "vehicle_small_hatch_green_destructible");
	set_type( "small_hatchback", "vehicle_small_hatch_turq_destructible");
	set_type( "small_hatchback", "vehicle_small_hatch_white_destructible");
	set_compassType( "small_hatchback", "automobile" );
	                        
	set_type( "small_wagon", "vehicle_small_wagon_white_destructible");
	set_type( "small_wagon", "vehicle_small_wagon_blue_destructible");
	set_type( "small_wagon", "vehicle_small_wagon_green_destructible");
	set_type( "small_wagon", "vehicle_small_wagon_turq_destructible");
	set_type( "small_wagon", "vehicle_small_wagon_white");
	set_type( "small_wagon", "vehicle_small_wagon_blue");
	set_type( "small_wagon", "vehicle_small_wagon_green");
	set_type( "small_wagon", "vehicle_small_wagon_turq");
	set_compassType( "small_wagon", "automobile" );
	                        
	set_type( "tanker", "vehicle_tanker_truck_civ" );                        
	set_compassType( "tanker", "" );
                                                               
	set_type( "truck", "vehicle_pickup_roobars");
	set_type( "truck", "vehicle_pickup_4door");
	set_type( "truck", "vehicle_opfor_truck");
	set_type( "truck", "vehicle_pickup_technical");
	set_compassType( "truck", "automobile" );

	set_type( "uaz", "vehicle_uaz_hardtop_destructible");
	set_type( "uaz", "vehicle_uaz_light_destructible");
	set_type( "uaz", "vehicle_uaz_open_destructible");
	set_type( "uaz", "vehicle_uaz_fabric_destructible");
	set_type( "uaz", "vehicle_uaz_fabric");
	set_type( "uaz", "vehicle_uaz_hardtop");
	set_type( "uaz", "vehicle_uaz_open");
	set_type( "uaz", "vehicle_uaz_open_for_ride" );
	set_compassType( "uaz", "automobile" );

	set_type( "van", "vehicle_uaz_van" );
	set_compassType( "van", "automobile" );
	
	set_type( "zpu_antiair", "vehicle_zpu4" );
	set_type( "zpu_antiair", "vehicle_zpu4_low" );
	set_compassType( "zpu_antiair", "" );
	
	set_type( "mi28", "vehicle_mi-28_flying" );
	set_compassType( "mi28", "plane" );
	
	set_type( "t72", "vehicle_t72_tank_low" );
	set_type( "t72", "vehicle_t72_tank" );
	set_type( "t72", "vehicle_t72_tank_woodland" );
	set_compassType( "t72", "tank" );
	
/*
80s_hatch1
80s_wagon1
apache
blackhawk
blackhawk_mp
bm21
bm21_troops
bmp
bog_mortar
bradley
camera
cobra
cobra_mp
cobra_player
defaultvehicle
defaultvehicle_mp
flare
hind
humvee
humvee50cal
humvee50cal_mp
hvy_truck
luxurysedan
m1a1
mi17
mi17_noai
mig29
pickup
sa6
seaknight
seaknight_airlift
slamraam
t72
technical
truck
uaz
*/
	
	
}

set_type( type, model )
{
	level.vehicle_types[ model ] = type;
}


set_compassType( type, compassType )
{
	level.vehicle_compass_types[type] = compassType;
}


get_type( model )
{
	if( !isdefined( level.vehicle_types[model] ) )
	{
		println( "type doesn't exist for model: "+ model );
		println( "Set it in vehicletypes::setup_types()." );
		assertmsg( "vehicle type for model doesn't exits, see console for info" );
	}
	return level.vehicle_types[ model ];
}


get_compassTypeForVehicleType( type )
{
	if( !isdefined( level.vehicle_compass_types[type] ) )
	{
		println( "Compass-type doesn't exist for type '" + type + "'." );
		println( "Set it in vehicletypes::setup_types()." );
		assertmsg( "Compass-type for model doesn't exits, see console for info" );
	}
	return level.vehicle_compass_types[type];
}


get_compassTypeForModel( model )
{
	type = get_type( model );

	return get_compassTypeForVehicleType( type );
}


is_type( model )
{
	if(isdefined(level.vehicle_types[ model ]))
		return true;
	else
		return false;
}
