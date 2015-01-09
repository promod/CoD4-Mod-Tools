#include maps\_destructible;
#using_animtree( "vehicles" );

makeType( destructibleType )
{
	//println( destructibleType );
	
	// if it's already been created dont create it again
	infoIndex = getInfoIndex( destructibleType );
	if ( infoIndex >= 0 )
	{
		//println( "### DESTRUCTIBLE ### already created" );
		return infoIndex;
	}
	
	//println( "### DESTRUCTIBLE ### creating" );
	
	switch( destructibleType )
	{
		case "vehicle_80s_sedan1_green":
			vehicle_80s_sedan1( "green" );
			break;
		case "vehicle_80s_sedan1_red":
			vehicle_80s_sedan1( "red" );
			break;
		case "vehicle_80s_sedan1_silv":
			vehicle_80s_sedan1( "silv" );
			break;
		case "vehicle_80s_sedan1_tan":
			vehicle_80s_sedan1( "tan" );
			break;
		case "vehicle_80s_sedan1_yel":
			vehicle_80s_sedan1( "yel" );
			break;
		case "vehicle_80s_sedan1_brn":
			vehicle_80s_sedan1( "brn" );
			break;
		case "vehicle_80s_sedan1_green_side":
			vehicle_80s_sedan1_side( "green" );
			break;
		case "vehicle_80s_sedan1_red_side":
			vehicle_80s_sedan1_side( "red" );
			break;
		case "vehicle_80s_sedan1_silv_side":
			vehicle_80s_sedan1_side( "silv" );
			break;
		case "vehicle_80s_sedan1_tan_side":
			vehicle_80s_sedan1_side( "tan" );
			break;
		case "vehicle_80s_sedan1_yel_side":
			vehicle_80s_sedan1_side( "yel" );
			break;
		case "vehicle_80s_sedan1_brn_side":
			vehicle_80s_sedan1_side( "brn" );
			break;
		case "vehicle_bus_destructible":
			vehicle_bus_destructible();
			break;
		case "vehicle_80s_wagon1_green":
			vehicle_80s_wagon1( "green" );
			break;
		case "vehicle_80s_wagon1_red":
			vehicle_80s_wagon1( "red" );
			break;
		case "vehicle_80s_wagon1_silv":
			vehicle_80s_wagon1( "silv" );
			break;
		case "vehicle_80s_wagon1_tan":
			vehicle_80s_wagon1( "tan" );
			break;
		case "vehicle_80s_wagon1_yel":
			vehicle_80s_wagon1( "yel" );
			break;
		case "vehicle_80s_wagon1_brn":
			vehicle_80s_wagon1( "brn" );
			break;
		case "vehicle_80s_hatch1_green":
			vehicle_80s_hatch1( "green" );
			break;
		case "vehicle_80s_hatch1_red":
			vehicle_80s_hatch1( "red" );
			break;
		case "vehicle_80s_hatch1_silv":
			vehicle_80s_hatch1( "silv" );
			break;
		case "vehicle_80s_hatch1_tan":
			vehicle_80s_hatch1( "tan" );
			break;
		case "vehicle_80s_hatch1_yel":
			vehicle_80s_hatch1( "yel" );
			break;
		case "vehicle_80s_hatch1_brn":
			vehicle_80s_hatch1( "brn" );
			break;
		case "vehicle_80s_hatch2_green":
			vehicle_80s_hatch2( "green" );
			break;
		case "vehicle_80s_hatch2_red":
			vehicle_80s_hatch2( "red" );
			break;
		case "vehicle_80s_hatch2_silv":
			vehicle_80s_hatch2( "silv" );
			break;
		case "vehicle_80s_hatch2_tan":
			vehicle_80s_hatch2( "tan" );
			break;
		case "vehicle_80s_hatch2_yel":
			vehicle_80s_hatch2( "yel" );
			break;
		case "vehicle_80s_hatch2_brn":
			vehicle_80s_hatch2( "brn" );
			break;
		case "vehicle_small_wagon_blue":
			vehicle_small_wagon( "blue" );
			break;
		case "vehicle_small_wagon_green":
			vehicle_small_wagon( "green" );
			break;
		case "vehicle_small_wagon_turq":
			vehicle_small_wagon( "turq" );
			break;
		case "vehicle_small_wagon_white":
			vehicle_small_wagon( "white" );
			break;
		case "vehicle_small_hatch_blue":
			vehicle_small_hatch( "blue" );
			break;
		case "vehicle_small_hatch_green":
			vehicle_small_hatch( "green" );
			break;
		case "vehicle_small_hatch_turq":
			vehicle_small_hatch( "turq" );
			break;
		case "vehicle_small_hatch_white":
			vehicle_small_hatch( "white" );
			break;
		case "vehicle_bm21_cover":
			vehicle_bm21( destructibleType, "_cover", "vehicle_bm21_mobile_cover_dstry" );
			break;
		case "vehicle_bm21_cover_under":
			vehicle_bm21( destructibleType, "_cover_under", "vehicle_bm21_mobile_cover_dstry" );
			break;
		case "vehicle_bm21_mobile_bed":
			vehicle_bm21( destructibleType, "_mobile_bed", "vehicle_bm21_mobile_bed_dstry" );
			break;
		case "vehicle_bm21_bed_under":
			vehicle_bm21( destructibleType, "_bed_under", "vehicle_bm21_mobile_bed_dstry" );
			break;
		case "vehicle_uaz_fabric":
			vehicle_uaz_fabric( destructibleType );
			break;
		case "vehicle_uaz_open":
			vehicle_uaz_open( destructibleType );
			break;
		case "vehicle_uaz_light":
			vehicle_uaz_light( destructibleType );
			break;
		case "vehicle_uaz_hardtop":
			vehicle_uaz_hardtop( destructibleType );
			break;
		case "vehicle_pickup":
			vehicle_pickup( destructibleType );
			break;
		
		// Thermal Variants
		case "vehicle_80s_hatch1_thermal":
			vehicle_80s_hatch1_thermal( "thermal" );
			break;
		case "vehicle_80s_hatch2_thermal":
			vehicle_80s_hatch2_thermal( "thermal" );
			break;
		case "vehicle_80s_sedan1_thermal":
			vehicle_80s_sedan1_thermal( "thermal" );
			break;
		case "vehicle_80s_wagon1_thermal":
			vehicle_80s_wagon1_thermal( "thermal" );
			break;
		case "vehicle_luxurysedan_thermal":
			vehicle_luxurysedan_thermal( "thermal" );
			break;
		case "vehicle_small_hatch_thermal":
			vehicle_small_hatch_thermal( "thermal" );
			break;

		// Low-res Variants
		case "vehicle_80s_hatch1_lowres_brn":
			vehicle_80s_hatch1_lowres( destructibleType, "brn" );
			break;
		case "vehicle_80s_hatch2_lowres_green":
			vehicle_80s_hatch2_lowres( destructibleType, "green" );
			break;
		case "vehicle_small_hatchback_lowres_turq":
			vehicle_small_hatchback_lowres( destructibleType, "turq" );
			break;
		case "vehicle_80s_sedan1_lowres_red":
			vehicle_80s_sedan1_lowres_red( destructibleType);
			break;	
		case "vehicle_80s_sedan1_lowres_green":
			vehicle_80s_sedan1_lowres( destructibleType, "green" );
			break;	
		case "vehicle_80s_wagon1_lowres_silv":
			vehicle_80s_wagon1_lowres( destructibleType, "silv" );
			break;
		case "vehicle_luxurysedan_lowres":
			vehicle_luxurysedan_lowres( destructibleType, undefined );
			break;		
			
		// tanker trucks
		case "vehicle_tanker_truck":
			vehicle_tanker_truck( destructibleType );
			break;		

		// no fire Variants for ambush
		case "vehicle_80s_sedan1_silv_nofire":
			vehicle_80s_sedan1_nofire( "silv" );
			break;
		case "vehicle_80s_sedan1_tan_nofire":
			vehicle_80s_sedan1_nofire( "tan" );
			break;
		case "vehicle_80s_wagon1_red_nofire":
			vehicle_80s_wagon1_nofire( "red" );
			break;


		// Default means invalid type
		default:
			assertMsg( "Destructible object 'destructible_type' key/value of '" + destructibleType + "' is not valid" );
			break;
	}
	
	infoIndex = getInfoIndex( destructibleType );
	assert( infoIndex >= 0 );
	return infoIndex;
}

getInfoIndex( destructibleType )
{
	if ( !isdefined( level.destructible_type ) )
		return -1;
	if ( level.destructible_type.size == 0 )
		return -1;
	
	for( i = 0 ; i < level.destructible_type.size ; i++ )
	{
		if ( destructibleType == level.destructible_type[ i ].v[ "type" ] )
			return i;
	}
	
	// didn't find it in the array, must not exist
	return -1;
}

vehicle_80s_sedan1( color )
{
	//---------------------------------------------------------------------
	// 80's Sedan
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_sedan1_" + color, 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 2.5 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_hood_dam" );
		//Trunk
		tag = "tag_trunk";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_trunk", 1000, undefined, undefined, undefined, 1.0 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_trunk_dam", 2000 );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 2.3 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_sedan1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_80s_sedan1_" + color + "_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_sedan1_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_80s_sedan1_" + color + "_door_RB", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_sedan1_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_80s_sedan1_" + color + "_bumper_B", undefined, undefined, undefined, undefined, undefined, 1.0 );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_sedan1_" + color + "_mirror_L", 10 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_sedan1_" + color + "_mirror_R", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		//destructible_part( tag, model, health, validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion )
}

vehicle_80s_sedan1_side( color )
{
	//---------------------------------------------------------------------
	// 80's Sedan - Layed On Side
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_sedan1_" + color + "_side", 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 2.5 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_hood_dam" );
		//Trunk
		tag = "tag_trunk";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_trunk", 1000, undefined, undefined,  undefined, 1.0 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_trunk_dam", 2000 );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, true );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, true );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_sedan1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_80s_sedan1_" + color + "_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_sedan1_" + color + "_door_RF", undefined, undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_80s_sedan1_" + color + "_door_RB", undefined, undefined, undefined, undefined, undefined, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_sedan1_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_80s_sedan1_" + color + "_bumper_B", undefined, undefined, undefined, undefined, undefined, 1.0 );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_sedan1_" + color + "_mirror_L", 10 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_sedan1_" + color + "_mirror_R", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
}

vehicle_bus_destructible()
{
	//---------------------------------------------------------------------
	// Bus
	//---------------------------------------------------------------------
	destructible_create( "vehicle_bus_destructible" );
		// Glass ( Front Left )
		tag = "tag_window_front_left";
		destructible_part( tag, "vehicle_bus_glass_fl", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_fl_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_front_left", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Front Right )
		tag = "tag_window_front_right";
		destructible_part( tag, "vehicle_bus_glass_fr", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_fr_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_front_right", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Driver Side )
		tag = "tag_window_driver";
		destructible_part( tag, "vehicle_bus_glass_driver", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_driver_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_driver", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back of bus )
		tag = "tag_window_back";
		destructible_part( tag, "vehicle_bus_glass_back", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_back_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_back", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Side )
		tag = "tag_window_side_1";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_1", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Side )
		tag = "tag_window_side_2";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_2", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Side )
		tag = "tag_window_side_3";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_3", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Side )
		tag = "tag_window_side_4";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_4", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Side )
		tag = "tag_window_side_5";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_5", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Side )
		tag = "tag_window_side_6";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_6", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Side )
		tag = "tag_window_side_7";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_7", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Side )
		tag = "tag_window_side_8";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_8", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Side )
		tag = "tag_window_side_9";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_9", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Side )
		tag = "tag_window_side_10";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_10", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Side )
		tag = "tag_window_side_11";
		destructible_part( tag, "vehicle_bus_glass_side", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bus_glass_side_dest", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_window_side_11", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
}

vehicle_80s_wagon1( color )
{
	//---------------------------------------------------------------------
	// 80's wagon
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_wagon1_" + color, 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_hood_dam" );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_80s_wagon1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_80s_wagon1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_80s_wagon1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_80s_wagon1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_wagon1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_80s_wagon1_" + color + "_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_wagon1_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_80s_wagon1_" + color + "_door_RB", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back 2 )
		tag = "tag_glass_left_back2";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LB2", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_LB2_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back2_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back 2 )
		tag = "tag_glass_right_back2";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RB2", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_RB2_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back2_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_LB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_RB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_wagon1_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0, 0.7 );
		destructible_part( "tag_bumper_back", "vehicle_80s_wagon1_" + color + "_bumper_B", undefined, undefined, undefined, undefined, undefined, 0.6 );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_wagon1_" + color + "_mirror_L", 10 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_wagon1_" + color + "_mirror_R", 10 );
			destructible_physics();
}

vehicle_80s_hatch1( color )
{
	//---------------------------------------------------------------------
	// 80's hatchback
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_hatch1_" + color, 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
			destructible_state( tag, "vehicle_80s_hatch1_" + color + "_hood_dam" );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_80s_hatch1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_80s_hatch1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_80s_hatch1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_80s_hatch1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_hatch1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_hatch1_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_hatch1_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch1_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_hatch1_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch1_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_hatch1_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch1_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_hatch1_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch1_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_hatch1_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch1_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_hatch1_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch1_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_hatch1_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_hatch1_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_light_LB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_hatch1_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_hatch1_" + color + "_light_RB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_hatch1_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_hatch1_" + color + "_bumper_F" );
		destructible_part( "tag_bumper_back", "vehicle_80s_hatch1_" + color + "_bumper_B" );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_hatch1_" + color + "_mirror_L", 10 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_hatch1_" + color + "_mirror_R", 10 );
			destructible_physics();
}

vehicle_80s_hatch2( color )
{
	//---------------------------------------------------------------------
	// 80's hatchback 2
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_hatch2_" + color, 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
			destructible_state( tag, "vehicle_80s_hatch2_" + color + "_hood_dam" );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_80s_hatch2_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_80s_hatch2_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_80s_hatch2_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_80s_hatch2_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_hatch2_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_hatch2_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_hatch2_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch2_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_hatch2_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch2_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_hatch2_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch2_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_hatch2_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch2_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_hatch2_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch2_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_hatch2_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_hatch2_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_hatch2_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_hatch2_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_light_LB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_hatch2_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_hatch2_" + color + "_light_RB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_hatch2_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_hatch2_" + color + "_bumper_F" );
		destructible_part( "tag_bumper_back", "vehicle_80s_hatch2_" + color + "_bumper_B" );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_hatch2_" + color + "_mirror_L", 10 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_hatch2_" + color + "_mirror_R", 10 );
			destructible_physics();
}

vehicle_small_wagon( color )
{
	//---------------------------------------------------------------------
	// small wagon
	//---------------------------------------------------------------------
	destructible_create( "vehicle_small_wagon_" + color, 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destructible", 100, "player_only", 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_small_wagon_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
			destructible_state( tag, "vehicle_small_wagon_" + color + "_hood_dam" );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_small_wagon_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_small_wagon_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_small_wagon_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_small_wagon_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_small_wagon_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_small_wagon_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_small_wagon_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_wagon_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_small_wagon_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_wagon_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_small_wagon_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_wagon_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_small_wagon_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_wagon_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_small_wagon_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_wagon_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_small_wagon_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_wagon_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_small_wagon_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_small_wagon_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_light_LB", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_small_wagon_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_small_wagon_" + color + "_light_RB", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_small_wagon_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_small_wagon_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_small_wagon_" + color + "_bumper_B", undefined, undefined, undefined, undefined, 0.5 );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_small_wagon_" + color + "_mirror_L", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_small_wagon_" + color + "_mirror_R", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
}

vehicle_small_hatch( color )
{
	//---------------------------------------------------------------------
	// small hatch
	//---------------------------------------------------------------------
	destructible_create( "vehicle_small_hatch_" + color, 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 15, 0.25, 210, "allies" );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
			destructible_state( tag, "vehicle_small_hatch_" + color + "_hood_dam" );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_small_hatch_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_small_hatch_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_small_hatch_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_small_hatch_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_small_hatch_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_small_hatch_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_small_hatch_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_hatch_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_small_hatch_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_hatch_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_small_hatch_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_hatch_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_small_hatch_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_hatch_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_small_hatch_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_hatch_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_small_hatch_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_small_hatch_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_small_hatch_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_small_hatch_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_light_LB", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_small_hatch_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_small_hatch_" + color + "_light_RB", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_small_hatch_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_small_hatch_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_small_hatch_" + color + "_bumper_B", undefined, undefined, undefined, undefined, 0.5 );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_small_hatch_" + color + "_mirror_L", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_small_hatch_" + color + "_mirror_R", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
}

vehicle_80s_wagon1_thermal( color )
{
	//---------------------------------------------------------------------
	// 80's wagon ( thermal version for ac130 mission )
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_wagon1_" + color, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 800, "player_only", 32, "no_melee" );
				destructible_fx( undefined, "explosions/large_vehicle_explosion_IR" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destroyed" );
}

vehicle_80s_hatch1_thermal( color )
{
	//---------------------------------------------------------------------
	// 80's hatchback ( thermal version for ac130 mission )
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_hatch1_" + color, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destructible", 800, "player_only", 32, "no_melee" );
				destructible_fx( undefined, "explosions/large_vehicle_explosion_IR" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destroyed" );
}

vehicle_80s_hatch2_thermal( color )
{
	//---------------------------------------------------------------------
	// 80's hatchback 2 ( thermal version for ac130 mission )
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_hatch2_" + color, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destructible", 800, "player_only", 32, "no_melee" );
				destructible_fx( undefined, "explosions/large_vehicle_explosion_IR" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destroyed" );
}

vehicle_80s_sedan1_thermal( color )
{
	//---------------------------------------------------------------------
	// 80's sedan 1 ( thermal version for ac130 mission )
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_sedan1_" + color, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 800, "player_only", 32, "no_melee" );
				destructible_fx( undefined, "explosions/large_vehicle_explosion_IR" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destroyed" );
}

vehicle_small_hatch_thermal( color )
{
	//---------------------------------------------------------------------
	// small hatch ( thermal version for ac130 mission )
	//---------------------------------------------------------------------
	destructible_create( "vehicle_small_hatch_" + color, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destructible", 800, "player_only", 32, "no_melee" );
				destructible_fx( undefined, "explosions/large_vehicle_explosion_IR" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_small_hatch_" + color + "_destroyed" );
}

vehicle_luxurysedan_thermal( color )
{
	//---------------------------------------------------------------------
	// Luxury Sedan ( thermal version for ac130 mission )
	//---------------------------------------------------------------------
	destructible_create( "vehicle_luxurysedan_" + color, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_luxurysedan_" + color + "_static", 800, "player_only", 32, "no_melee" );
				destructible_fx( undefined, "explosions/large_vehicle_explosion_IR" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
			destructible_state( undefined, "vehicle_luxurysedan_" + color + "_destroy" );
}

vehicle_80s_hatch1_lowres( destructibleType, color )
{
	//---------------------------------------------------------------------
	// 80's hatchback1 ( lowres version for airlift mission )
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color, 800, "no_ai", 32, "no_melee" );
				destructible_fx( undefined, "explosions/small_vehicle_explosion_airlift" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_80s_hatch1_" + color + "_destroyed" );
}

vehicle_80s_hatch2_lowres( destructibleType, color )
{
	//---------------------------------------------------------------------
	// 80's hatchback2 ( lowres version for airlift mission )
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color, 800, "no_ai", 32, "no_melee" );
				destructible_fx( undefined, "explosions/small_vehicle_explosion_airlift" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_80s_hatch2_" + color + "_destroyed" );
}

vehicle_small_hatchback_lowres( destructibleType, color )
{
	//---------------------------------------------------------------------
	// small_hatchback ( lowres version for airlift mission )
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_small_hatchback_" + color, 800, "no_ai", 32, "no_melee" );
				destructible_fx( undefined, "explosions/small_vehicle_explosion_airlift" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_small_hatchback_d_" + color );
}




vehicle_80s_sedan1_lowres_red( destructibleType )
{
	//---------------------------------------------------------------------
	// 80s_sedan1 RED ( lowres version for airlift mission )
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_sedan1_red_low", 800, "no_ai", 32, "no_melee" );
				destructible_fx( undefined, "explosions/small_vehicle_explosion_airlift" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_80s_sedan1_red_destroyed" );
}

vehicle_80s_sedan1_lowres( destructibleType, color )
{
	//---------------------------------------------------------------------
	// 80s_sedan1 ( lowres version for airlift mission )
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color, 800, "no_ai", 32, "no_melee" );
				destructible_fx( undefined, "explosions/small_vehicle_explosion_airlift" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			
			//need to account for artist's inconsistent naming conventions
			sColorSuffix = undefined;
			if ( color == "green" )
				sColorSuffix = "dest";
			else
				sColorSuffix = "_destroyed";
			
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + sColorSuffix );
}

vehicle_80s_wagon1_lowres( destructibleType, color )
{
	//---------------------------------------------------------------------
	// 80s_sedan1 ( lowres version for airlift mission )
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color, 800, "no_ai", 32, "no_melee" );
				destructible_fx( undefined, "explosions/small_vehicle_explosion_airlift" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destroyed" );
}

vehicle_luxurysedan_lowres( destructibleType, color )
{
	//---------------------------------------------------------------------
	// Luxury Sedan ( lowres version for airlift mission )
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 300, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_luxurysedan", 800, "no_ai", 32, "no_melee" );
				destructible_fx( undefined, "explosions/small_vehicle_explosion_airlift" );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 );
			destructible_state( undefined, "vehicle_luxurysedan_destroy" );
}


vehicle_tanker_truck( destructibleType )
{
	//---------------------------------------------------------------------
	// Tanker truck
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 600, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_tanker_truck_static_low", 800, "no_ai", 32, "no_melee" );
				destructible_fx( undefined, "explosions/tanker_explosion" );
				destructible_sound( "exp_tanker_vehicle" );
				destructible_explode( 4000, 5000, 768, 150, 300 );
			destructible_state( undefined, "vehicle_tanker_truck_d" );
}

vehicle_bm21( destructibleType, additionalstring, basedeathmodel )
{
	assert( isdefined( additionalstring ) );
	destructible_create( "vehicle_bm21"+additionalstring, 1500, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_bm21" + additionalstring + "_destructible", 100, "player_only", 32, "no_melee" );
				destructible_fx( "tag_origin", "explosions/large_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
			destructible_state( undefined, "vehicle_bm21_mobile_bed_dstry");
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_bm21_glass_F", 800, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bm21_glass_F_dam", 800, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_bm21_glass_B", 250, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bm21_glass_B_dam", 400, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_bm21_glass_LF", 250, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bm21_glass_LF_dam", 400, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_bm21_glass_RF", 250, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_bm21_glass_RF_dam", 400, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
			
		// Tires
		//destructible_part( tagName, 				modelName, h				ealth, 	validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion, grenadeImpactDeath )

		destructible_part( "left_wheel_01_jnt", "vehicle_bm21_wheel_LF", 0, undefined, undefined, undefined,undefined);
//			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_bm21_wheel_LF", 0, undefined, undefined, undefined );
//			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_03_jnt", "vehicle_bm21_wheel_LF", 0, undefined, undefined, undefined );
//			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_bm21_wheel_RF", 0, undefined, undefined, undefined, undefined );
//			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_bm21_wheel_RF", 0, undefined, undefined, undefined, undefined);
//			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_03_jnt", "vehicle_bm21_wheel_RF", 0, undefined, undefined, undefined, undefined);
//			destructible_sound( "veh_tire_deflate", "bullet" );

}


vehicle_uaz_fabric( destructibleType )
{
	destructible_create( "vehicle_uaz_fabric", 550, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_uaz_fabric_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_uaz_fabric_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_uaz_fabric_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_uaz_fabric_destructible", 100, "player_only", 32, "no_melee" );
				destructible_fx( "tag_origin", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
			destructible_state( undefined, "vehicle_uaz_fabric_dsr");
		// Tires
//           destructible_part( tagName, modelName,               health, validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion, grenadeImpactDeath )
		destructible_part( "left_wheel_01_jnt", "vehicle_uaz_wheel_LF", 20, undefined, undefined, "no_melee", undefined, undefined);
		destructible_part( "left_wheel_02_jnt", "vehicle_uaz_wheel_LF", 20, undefined, undefined, "no_melee" );
		destructible_part( "right_wheel_01_jnt", "vehicle_uaz_wheel_RF", 20, undefined, undefined, "no_melee", undefined, undefined );
		destructible_part( "right_wheel_02_jnt", "vehicle_uaz_wheel_RF", 20, undefined, undefined, "no_melee" );
		// Doors
		// destructible_part( tagName,         modelName,                  health, validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion, grenadeImpactDeath )
		destructible_part( "tag_door_left_front", "vehicle_uaz_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_uaz_door_RF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_uaz_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_uaz_door_RB", undefined, undefined, undefined, undefined, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_uaz_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_uaz_fabric_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_fabric_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_uaz_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_uaz_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_uaz_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_uaz_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_uaz_light_LF", 99, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_uaz_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_uaz_light_RF", 99, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_uaz_light_RF_dam" );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_uaz_mirror_L", 99 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_uaz_mirror_R", 99 );
			destructible_physics();
}

vehicle_uaz_open( destructibleType )
{
	destructible_create( "vehicle_uaz_open", 550, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_uaz_open_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_uaz_open_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_uaz_open_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_uaz_open_destructible", 100, "player_only", 32, "no_melee" );
				destructible_fx( "tag_origin", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
			destructible_state( undefined, "vehicle_uaz_open_dsr");
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_uaz_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_uaz_wheel_LF", 20, undefined, undefined, "no_melee", undefined );
		destructible_part( "left_wheel_02_jnt", "vehicle_uaz_wheel_LF", 20, undefined, undefined, "no_melee" );
		destructible_part( "right_wheel_01_jnt", "vehicle_uaz_wheel_RF", 20, undefined, undefined, "no_melee", undefined );
		destructible_part( "right_wheel_02_jnt", "vehicle_uaz_wheel_RF", 20, undefined, undefined, "no_melee" );
		// Doors
		//destructible_part( tagName,          modelName,               health, validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion, grenadeImpactDeath )
		destructible_part( "tag_door_left_front", "vehicle_uaz_open_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_uaz_open_door_RF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_uaz_open_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_uaz_open_door_RB", undefined, undefined, undefined, undefined, 1.0 );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_uaz_light_LF", 99, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_uaz_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_uaz_light_RF", 99, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_uaz_light_RF_dam" );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_uaz_mirror_L", 99 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_uaz_mirror_R", 99 );
			destructible_physics();
}

vehicle_uaz_light( destructibleType )
{
	destructible_create( "vehicle_uaz_light", 350, undefined, 32, "no_melee" );
			destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
		destructible_state( undefined, "vehicle_uaz_light_destructible", 200, undefined, 32, "no_melee" );
			destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
		destructible_state( undefined, "vehicle_uaz_light_destructible", 100, undefined, 32, "no_melee" );
			destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
			destructible_sound( "fire_vehicle_flareup_med" );
			destructible_loopsound( "fire_vehicle_med" );
			destructible_healthdrain( 12, 0.2, 210, "allies" );
		destructible_state( undefined, "vehicle_uaz_light_destructible", 300, "player_only", 32, "no_melee" );
			destructible_loopsound( "fire_vehicle_med" );
		destructible_state( undefined, "vehicle_uaz_light_destructible", 100, "player_only", 32, "no_melee" );
			destructible_fx( "tag_origin", "explosions/small_vehicle_explosion", false );
			destructible_sound( "car_explode" );
			destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
		destructible_state( undefined, "vehicle_uaz_light_dsr");
		
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_uaz_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_uaz_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_uaz_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_uaz_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_uaz_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_uaz_wheel_LF", 20, undefined, undefined, "no_melee", undefined );
		destructible_part( "left_wheel_02_jnt", "vehicle_uaz_wheel_LF", 20, undefined, undefined, "no_melee" );
		destructible_part( "right_wheel_01_jnt", "vehicle_uaz_wheel_RF", 20, undefined, undefined, "no_melee", undefined );
		destructible_part( "right_wheel_02_jnt", "vehicle_uaz_wheel_RF", 20, undefined, undefined, "no_melee" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_uaz_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_uaz_door_RF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_uaz_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_uaz_door_RB", undefined, undefined, undefined, undefined, 1.0 );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_uaz_light_LF", 99, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_uaz_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_uaz_light_RF", 99, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_uaz_light_RF_dam" );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_uaz_mirror_L", 99 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_uaz_mirror_R", 99 );
			destructible_physics();
}

vehicle_uaz_hardtop( destructibleType )
{
	destructible_create( "vehicle_uaz_hardtop", 550, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_uaz_hardtop_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_uaz_hardtop_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_uaz_hardtop_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_uaz_hardtop_destructible", 100, "player_only", 32, "no_melee" );
				destructible_fx( "tag_origin", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
			destructible_state( undefined, "vehicle_uaz_hardtop_dsr");
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_uaz_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_uaz_door_RF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_uaz_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_uaz_door_RB", undefined, undefined, undefined, undefined, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_uaz_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_uaz_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_uaz_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_uaz_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_uaz_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_uaz_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back 2)
		tag = "tag_glass_left_back2";
		destructible_part( tag, "vehicle_uaz_glass_LB2", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_LB2_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back2_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back 2 )
		tag = "tag_glass_right_back2";
		destructible_part( tag, "vehicle_uaz_glass_RB2", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_RB2_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back2_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_uaz_wheel_LF", 20, undefined, undefined, "no_melee", undefined );
		destructible_part( "left_wheel_02_jnt", "vehicle_uaz_wheel_LF", 20, undefined, undefined, "no_melee" );
		destructible_part( "right_wheel_01_jnt", "vehicle_uaz_wheel_RF", 20, undefined, undefined, "no_melee", undefined );
		destructible_part( "right_wheel_02_jnt", "vehicle_uaz_wheel_RF", 20, undefined, undefined, "no_melee" );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_uaz_light_LF", 99, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_uaz_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_uaz_light_RF", 99, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_uaz_light_RF_dam" );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_uaz_mirror_L", 99 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_uaz_mirror_R", 99 );
			destructible_physics();
}

vehicle_uaz_open_for_ride( destructibleType )
{
	//---------------------------------------------------------------------
	// small wagon
	//---------------------------------------------------------------------
	destructible_create( "vehicle_uaz_open_for_ride", 550, undefined, 32, "no_melee" );
			destructible_state( undefined, "vehicle_uaz_open_destructible", 100, "player_only", 32, "no_melee" );
				destructible_fx( "tag_origin", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
//			destructible_state( undefined, "vehicle_uaz_open_dsr");
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_uaz_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_uaz_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
}

vehicle_80s_sedan1_nofire( color )
{
	//---------------------------------------------------------------------
	// 80's Sedan nofire remains after explosion
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_sedan1_" + color + "_nofire", 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion_nofire", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_80s_sedan1_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 2.5 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_hood_dam" );
		//Trunk
		tag = "tag_trunk";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_trunk", 1000, undefined, undefined, undefined, 1.0 );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_trunk_dam", 2000 );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_80s_sedan1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_sedan1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_80s_sedan1_" + color + "_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_sedan1_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_80s_sedan1_" + color + "_door_RB", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_sedan1_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_LB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_sedan1_" + color + "_light_RB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_sedan1_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_sedan1_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_80s_sedan1_" + color + "_bumper_B", undefined, undefined, undefined, undefined, undefined, 1.0 );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_sedan1_" + color + "_mirror_L", 10 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_sedan1_" + color + "_mirror_R", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		//destructible_part( tag, model, health, validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion )
}

vehicle_80s_wagon1_nofire( color )
{
	//---------------------------------------------------------------------
	// 80's wagon nofire remains after explosion
	//---------------------------------------------------------------------
	destructible_create( "vehicle_80s_wagon1_" + color + "_nofire", 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion_nofire", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_80s_wagon1_" + color + "_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_hood", 800, undefined, undefined, undefined, 1.0, 1.5 );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_hood_dam" );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_80s_wagon1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_80s_wagon1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_80s_wagon1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_80s_wagon1_" + color + "_wheel_LF", 20, undefined, undefined, "no_melee", undefined, 1.7 );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_80s_wagon1_" + color + "_door_LF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_left_back", "vehicle_80s_wagon1_" + color + "_door_LB", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_80s_wagon1_" + color + "_door_RF", undefined, undefined, undefined, undefined, 1.0 );
		destructible_part( "tag_door_right_back", "vehicle_80s_wagon1_" + color + "_door_RB", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back 2 )
		tag = "tag_glass_left_back2";
		destructible_part( tag, "vehicle_80s_wagon1_glass_LB2", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_LB2_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back2_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back 2 )
		tag = "tag_glass_right_back2";
		destructible_part( tag, "vehicle_80s_wagon1_glass_RB2", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_80s_wagon1_glass_RB2_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back2_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_light_RF_dam" );
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_LB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_80s_wagon1_" + color + "_light_RB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_80s_wagon1_" + color + "_light_RB_dam" );
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_80s_wagon1_" + color + "_bumper_F", undefined, undefined, undefined, undefined, 1.0, 0.7 );
		destructible_part( "tag_bumper_back", "vehicle_80s_wagon1_" + color + "_bumper_B", undefined, undefined, undefined, undefined, undefined, 0.6 );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_80s_wagon1_" + color + "_mirror_L", 10 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_80s_wagon1_" + color + "_mirror_R", 10 );
			destructible_physics();
}

vehicle_pickup( destructibleType )
{
	//---------------------------------------------------------------------
	// White Pickup Truck
	//---------------------------------------------------------------------
	destructible_create( destructibleType, 300, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_whitesmoke", 0.4 );
			destructible_state( undefined, "vehicle_pickup_destructible", 200, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke", 0.4 );
			destructible_state( undefined, "vehicle_pickup_destructible", 100, undefined, 32, "no_melee" );
				destructible_loopfx( "tag_hood_fx", "smoke/car_damage_blacksmoke_fire", 0.4 );
				destructible_sound( "fire_vehicle_flareup_med" );
				destructible_loopsound( "fire_vehicle_med" );
				destructible_healthdrain( 12, 0.2, 210, "allies" );
			destructible_state( undefined, "vehicle_pickup_destructible", 300, "player_only", 32, "no_melee" );
				destructible_loopsound( "fire_vehicle_med" );
			destructible_state( undefined, "vehicle_pickup_destructible", 400, undefined, 32, "no_melee" );
				destructible_fx( "tag_death_fx", "explosions/small_vehicle_explosion", false );
				destructible_sound( "car_explode" );
				destructible_explode( 4000, 5000, 200, 150, 300 ); 	// force_min, force_max, range, mindamage, maxdamage
				destructible_anim( %vehicle_80s_sedan1_destroy, #animtree, "setanimknob" );
			destructible_state( undefined, "vehicle_pickup_destroyed", undefined, 32, "no_melee" );
		// Hood
		tag = "tag_hood";
		destructible_part( tag, "vehicle_pickup_hood", 800, undefined, undefined, undefined, 1.0, 2.5 );
			destructible_state( tag, "vehicle_pickup_hood" );
		// Tires
		destructible_part( "left_wheel_01_jnt", "vehicle_pickup_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "left_wheel_02_jnt", "vehicle_pickup_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_LB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_01_jnt", "vehicle_pickup_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RF, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		destructible_part( "right_wheel_02_jnt", "vehicle_pickup_wheel_LF", 20, undefined, undefined, "no_melee" );
			destructible_anim( %vehicle_80s_sedan1_flattire_RB, #animtree, "setanim" );
			destructible_sound( "veh_tire_deflate", "bullet" );
		// Doors
		destructible_part( "tag_door_left_front", "vehicle_pickup_door_LF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_door_right_front", "vehicle_pickup_door_RF", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		// Glass ( Front )
		tag = "tag_glass_front";
		destructible_part( tag, "vehicle_pickup_glass_F", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_pickup_glass_F_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_front_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Back )
		tag = "tag_glass_back";
		destructible_part( tag, "vehicle_pickup_glass_B", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_pickup_glass_B_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_back_fx", "props/car_glass_large" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Front )
		tag = "tag_glass_left_front";
		destructible_part( tag, "vehicle_pickup_glass_LF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_pickup_glass_LF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Front )
		tag = "tag_glass_right_front";
		destructible_part( tag, "vehicle_pickup_glass_RF", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_pickup_glass_RF_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_front_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Left Back )
		tag = "tag_glass_left_back";
		destructible_part( tag, "vehicle_pickup_glass_LB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_pickup_glass_LB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_left_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Glass ( Right Back )
		tag = "tag_glass_right_back";
		destructible_part( tag, "vehicle_pickup_glass_RB", 10, undefined, undefined, undefined, undefined, undefined, true );
			destructible_state( tag, "vehicle_pickup_glass_RB_dam", 200, undefined, undefined, undefined, true );
			destructible_fx( "tag_glass_right_back_fx", "props/car_glass_med" );
			destructible_sound( "veh_glass_break_large" );
			destructible_state( undefined );
		// Head Light ( Left )
		tag = "tag_light_left_front";
		destructible_part( tag, "vehicle_pickup_light_LF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_pickup_light_LF_dam" );
		// Head Light ( Right )
		tag = "tag_light_right_front";
		destructible_part( tag, "vehicle_pickup_light_RF", 10, undefined, undefined, undefined, 0.5 );
			destructible_fx( tag, "props/car_glass_headlight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_pickup_light_RF_dam" );
		/*
		// Tail Light ( Left )
		tag = "tag_light_left_back";
		destructible_part( tag, "vehicle_pickup_light_LB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_pickup_light_LB_dam" );
		// Tail Light ( Right )
		tag = "tag_light_right_back";
		destructible_part( tag, "vehicle_pickup_light_RB", 10 );
			destructible_fx( tag, "props/car_glass_brakelight" );
			destructible_sound( "veh_glass_break_small" );
			destructible_state( tag, "vehicle_pickup_light_RB_dam" );
		*/
		// Bumpers
		destructible_part( "tag_bumper_front", "vehicle_pickup_bumper_F", undefined, undefined, undefined, undefined, 1.0, 1.0 );
		destructible_part( "tag_bumper_back", "vehicle_pickup_bumper_B", undefined, undefined, undefined, undefined, undefined, 1.0 );
		// Side Mirrors
		destructible_part( "tag_mirror_left", "vehicle_pickup_mirror_L", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
		destructible_part( "tag_mirror_right", "vehicle_pickup_mirror_R", 10, undefined, undefined, undefined, undefined, 1.0 );
			destructible_physics();
}
