#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, no_death )
{
	build_template( "blackhawk", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_blackhawk" );
	build_deathmodel( "vehicle_blackhawk_low" );
	build_deathmodel( "vehicle_blackhawk_low_thermal" );
	build_deathmodel( "vehicle_blackhawk_hero_sas_night" );
	
	build_drive( %bh_rotors, undefined, 0 );
	
	if ( !isdefined( no_death ) )
	{
		blackhawk_death_fx = [];
		blackhawk_death_fx[ "vehicle_blackhawk" ] 					= "explosions/helicopter_explosion";
		blackhawk_death_fx[ "vehicle_blackhawk_sas_night" ] 		= "explosions/helicopter_explosion";
		blackhawk_death_fx[ "vehicle_blackhawk_hero_sas_night" ] 	= "explosions/helicopter_explosion";
		blackhawk_death_fx[ "vehicle_blackhawk_hero" ] 				= "explosions/helicopter_explosion";
		blackhawk_death_fx[ "vehicle_blackhawk_low" ]				= "explosions/large_vehicle_explosion";
		blackhawk_death_fx[ "vehicle_blackhawk_low_thermal" ] 		= "explosions/large_vehicle_explosion";
	
		build_deathfx( "explosions/grenadeexp_default" , 		"tag_engine_left", 		"blackhawk_helicopter_hit", 			undefined, 			undefined, 		undefined, 		0.2, 		true );
		build_deathfx( "explosions/grenadeexp_default" , 		"elevator_jnt", 		"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.5, 		true );
		build_deathfx( "fire/fire_smoke_trail_L" , 				"elevator_jnt", 		"blackhawk_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
		build_deathfx( "explosions/aerial_explosion" , 			"tag_engine_right", 	"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
		build_deathfx( "explosions/aerial_explosion" , 			"tag_deathfx", 			"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		4.0 );
		build_deathfx( blackhawk_death_fx[ model ], 			undefined, 				"blackhawk_helicopter_crash", 			undefined, 			undefined, 		undefined, 		-1, 		undefined, 	"stop_crash_loop_sound" );
	}
	
	build_treadfx();

	build_life( 999, 500, 1500 );

	build_team( "allies" );
	
	build_aianims( ::setanims , ::set_vehicle_anims );
	
	build_attach_models( ::set_attached_models );

	build_unload_groups( ::Unload_Groups );

	build_light( model, "cockpit_blue_cargo01", 	"tag_light_cargo01", 	"misc/aircraft_light_cockpit_red", 		"interior", 	0.0 );
	build_light( model, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue", 		"interior", 	0.0 );
	build_light( model, "white_blink", 			"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 	0.0 );
	build_light( model, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_white_blink", 		"running", 	0.3 );
	build_light( model, "wingtip_green", 			"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 	0.0 );
	build_light( model, "wingtip_red", 			"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 	0.0 );

}

init_local()
{
	self.originheightoffset = distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );  //TODO-FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.fastropeoffset = 762; //TODO-FIXME: this is ugly. If only there were a getanimendorigin() command
	
	self.script_badplace = false; //All helicopters dont need to create bad places
	//maps\_vehicle::lights_on( "running" );
	//maps\_vehicle::lights_on( "interior" ); 
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
//	positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	
	for( i=0;i<positions.size;i++ )
		positions[ i ].vehicle_getoutanim = %bh_idle;

	return positions;
}

#using_animtree( "fastrope" );

setplayer_anims( positions )
{
	positions[ 3 ].player_idle = %bh_player_idle;
	positions[ 3 ].player_getout_sound = "fastrope_start_plr";
	positions[ 3 ].player_getout_sound_loop = "fastrope_loop_plr";
	positions[ 3 ].player_getout_sound_end = "fastrope_end_plr";

	positions[ 3 ].player_getout = %bh_player_drop;
	positions[ 3 ].player_animtree = #animtree;
	
	return positions;
}

#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<8;i++ )
		positions[ i ] = spawnstruct();
		
	positions[ 0 ].idle = %bh_Pilot_idle;
	positions[ 1 ].idle = %bh_coPilot_idle;
	
	// 1, 2, 4, 5, 8,  6
	positions[ 2 ].idle = %bh_1_idle;
	positions[ 3 ].idle = %bh_2_idle;
	positions[ 4 ].idle = %bh_4_idle;
	positions[ 5 ].idle = %bh_5_idle;
	positions[ 6 ].idle = %bh_8_idle;
	positions[ 7 ].idle = %bh_6_idle;

	
	positions[ 0 ].sittag = "tag_detach";
	positions[ 1 ].sittag = "tag_detach";
	positions[ 2 ].sittag = "tag_detach";
	positions[ 3 ].sittag = "tag_detach";
	positions[ 4 ].sittag = "tag_detach";
	positions[ 5 ].sittag = "tag_detach";
	positions[ 6 ].sittag = "tag_detach";
	positions[ 7 ].sittag = "tag_detach";


	// 1, 2, 4, 5, 8,  6
	positions[ 2 ].getout = %bh_1_drop;
	positions[ 3 ].getout = %bh_2_drop;
	positions[ 4 ].getout = %bh_4_drop;
	positions[ 5 ].getout = %bh_5_drop;
	positions[ 6 ].getout = %bh_8_drop;
	positions[ 7 ].getout = %bh_6_drop;

	positions[ 2 ].getoutstance = "crouch";
	positions[ 3 ].getoutstance = "crouch";
	positions[ 4 ].getoutstance = "crouch";
	positions[ 5 ].getoutstance = "crouch";
	positions[ 6 ].getoutstance = "crouch";
	positions[ 7 ].getoutstance = "crouch";


	positions[ 2 ].ragdoll_getout_death = true;
	positions[ 3 ].ragdoll_getout_death = true;
	positions[ 4 ].ragdoll_getout_death = true;
	positions[ 5 ].ragdoll_getout_death = true;
	positions[ 6 ].ragdoll_getout_death = true;
	positions[ 7 ].ragdoll_getout_death = true;
	
	positions[ 2 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 3 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 4 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 5 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 6 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 7 ].ragdoll_fall_anim = %fastrope_fall;

	positions[ 2 ].getoutsnd = "fastrope_loop_npc";
	positions[ 3 ].getoutsnd = "fastrope_loop_npc";
	positions[ 4 ].getoutsnd = "fastrope_loop_npc";
	positions[ 5 ].getoutsnd = "fastrope_loop_npc";
	positions[ 6 ].getoutsnd = "fastrope_loop_npc";
	positions[ 7 ].getoutsnd = "fastrope_loop_npc";

	positions[ 2 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 3 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 4 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 5 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 6 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 7 ].getoutloopsnd = "fastrope_loop_npc";
	
	// 1, 2, 4, 5, 6, & 8
	positions[ 2 ].getoutrig = "TAG_FastRope_RI"; //1 %bh_1_drop
	positions[ 3 ].getoutrig = "TAG_FastRope_RI";	//2 %bh_2_drop
	positions[ 4 ].getoutrig = "TAG_FastRope_LE";	//4 %bh_4_drop
	positions[ 5 ].getoutrig = "TAG_FastRope_LE";	//5 %bh_5_drop
	positions[ 6 ].getoutrig = "TAG_FastRope_RI"; //8 %bh_8_drop
	positions[ 7 ].getoutrig = "TAG_FastRope_LE"; //6 %bh_6_drop

	return setplayer_anims( positions );                           
}                                             



//WIP.. posible to unload different sets of people wirh vehicle notify( "unload", set ); sets defined here.
unload_groups()
{
	unload_groups = [];
	unload_groups[ "left" ] = [];
	unload_groups[ "right" ] = [];
	unload_groups[ "both" ] = [];

	unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 4;
	unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 5;
	unload_groups[ "left" ][ unload_groups[ "left" ].size ] = 7;

	unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 2;
	unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 3;
	unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 6;

	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 2;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 3;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 4;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 5;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 6;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 7;

	unload_groups[ "default" ] = unload_groups[ "both" ];
	
	return unload_groups;
	
}


set_attached_models()
{
	array = [];
	array[ "TAG_FastRope_LE" ] = spawnstruct();
	array[ "TAG_FastRope_LE" ].model = "rope_test";
	array[ "TAG_FastRope_LE" ].tag = "TAG_FastRope_LE";
	array[ "TAG_FastRope_LE" ].idleanim = %bh_rope_idle_le;
	array[ "TAG_FastRope_LE" ].dropanim = %bh_rope_drop_le;

	array[ "TAG_FastRope_RI" ] = spawnstruct();
	array[ "TAG_FastRope_RI" ].model = "rope_test_ri";
	array[ "TAG_FastRope_RI" ].tag = "TAG_FastRope_RI";
	array[ "TAG_FastRope_RI" ].idleanim = %bh_rope_idle_ri;
	array[ "TAG_FastRope_RI" ].dropanim = %bh_rope_drop_ri;
	
	strings = getarraykeys( array );
	
	for( i=0;i<strings.size;i++ )
	{
			precachemodel( array[ strings[ i ] ].model );
	}

	return array;
}
