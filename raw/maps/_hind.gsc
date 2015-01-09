#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "hind", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_mi24p_hind_desert" );
	build_deathmodel( "vehicle_mi24p_hind_woodland" );
	build_deathmodel( "vehicle_mi24p_hind_woodland_opened_door" );

	// this doesn't happen very much but it's a nicer cleaner format than the case statement.
	hind_death_fx = [];
	hind_death_fx[ "vehicle_mi24p_hind_desert" ] = "explosions/helicopter_explosion_hind_desert";
	hind_death_fx[ "vehicle_mi24p_hind_woodland" ] = "explosions/helicopter_explosion_hind_woodland";
	hind_death_fx[ "vehicle_mi24p_hind_woodland_opened_door" ] = "explosions/helicopter_explosion_hind_woodland";
	hind_death_fx[ "vehicle_mi24p_hind_chernobyl" ] = "explosions/helicopter_explosion_hind_woodland";

	build_drive( %bh_rotors, undefined, 0 );
	
	build_deathfx( "explosions/grenadeexp_default" , 	"tag_engine_left", 	"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.2, 		true );
	build_deathfx( "explosions/grenadeexp_default" , 	"tail_rotor_jnt", 	"hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.5, 		true );
	build_deathfx( "fire/fire_smoke_trail_L" , 			"tail_rotor_jnt", 	"hind_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
	build_deathfx( "explosions/aerial_explosion" , 		"tag_engine_right", "hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
	build_deathfx( "explosions/aerial_explosion" , 		"tag_deathfx", 		"hind_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		4.0 );
	build_deathfx( hind_death_fx[ model ], 		 		undefined, 			"hind_helicopter_crash", 			undefined, 			undefined, 		undefined, 		-1, 		undefined, 	"stop_crash_loop_sound" );
	
	build_treadfx();

	build_life( 999, 500, 1500 );
	
	build_team( "axis" );
	
	build_aianims( ::setanims , ::set_vehicle_anims );
	
	build_attach_models( ::set_attached_models );

	build_unload_groups( ::Unload_Groups );
	build_light( model, "cockpit_blue_cargo01", 	"tag_light_cargo01", 	"misc/aircraft_light_cockpit_red", 		"interior", 	0.0 );
	build_light( model, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue", 		"interior", 	0.1 );
	build_light( model, "white_blink", 			"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 	0.0 );
	build_light( model, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_red_blink", 		"running", 	0.3 );
	build_light( model, "wingtip_green", 			"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 	0.0 );
	build_light( model, "wingtip_red", 			"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 	0.0 );
	
}

init_local()
{
	self.originheightoffset = 144;  //TODO-FIXME: this is ugly.
//	self.fastropeoffset = 760; //blackhawk
	self.fastropeoffset = 792;  //TODO-FIXME: this is ugly.
	//self.delete_on_death = true;
	self.script_badplace = false; //All helicopters dont need to create bad places
	maps\_vehicle::lights_on( "running" );
	//maps\_vehicle::lights_on( "interior" ); 

}

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
	for( i=0;i<9;i++ )
		positions[ i ] = spawnstruct();
		
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

	
	// 1, 2, 4, 5, 8,  6
	positions[ 2 ].idle = %bh_1_idle;
	positions[ 3 ].idle = %bh_2_idle;
	positions[ 4 ].idle = %bh_4_idle;
	positions[ 5 ].idle = %bh_5_idle;
	positions[ 6 ].idle = %bh_8_idle;
	positions[ 7 ].idle = %bh_6_idle;
	positions[ 8 ].idle = %bh_7_idle;
//	positions[ 9 ].idle = %bh_2_idle;

	
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";
	positions[ 2 ].sittag = "tag_detach";
	positions[ 3 ].sittag = "tag_detach";
	positions[ 4 ].sittag = "tag_detach";
	positions[ 5 ].sittag = "tag_detach";
	positions[ 6 ].sittag = "tag_detach";
	positions[ 7 ].sittag = "tag_detach";
	positions[ 8 ].sittag = "tag_detach";
//	positions[ 9 ].sittag = "tag_detach";
	
//	positions[ 0 ].getout = %bh_Pilot_idle;
//	positions[ 1 ].getout = %bh_coPilot_idle;

/*
	positions[ 2 ].getout = %bh_1_begining;
	positions[ 3 ].getout = %bh_2_begining;
	positions[ 4 ].getout = %bh_3_begining;
	positions[ 5 ].getout = %bh_4_begining;
	positions[ 6 ].getout = %bh_5_begining;
	positions[ 7 ].getout = %bh_6_begining;
	positions[ 8 ].getout = %bh_7_begining;
	positions[ 9 ].getout = %bh_2_begining;
*/

	// 1, 2, 4, 5, 8,  6
	positions[ 2 ].getout = %bh_1_drop;
	positions[ 3 ].getout = %bh_2_drop;
	positions[ 4 ].getout = %bh_4_drop;
	positions[ 5 ].getout = %bh_5_drop;
	positions[ 6 ].getout = %bh_8_drop;
	positions[ 7 ].getout = %bh_6_drop;
	positions[ 8 ].getout = %bh_7_drop;
//	positions[ 9 ].getout = %bh_7_drop;

	positions[ 2 ].getoutstance = "crouch";
	positions[ 3 ].getoutstance = "crouch";
	positions[ 4 ].getoutstance = "crouch";
	positions[ 5 ].getoutstance = "crouch";
	positions[ 6 ].getoutstance = "crouch";
	positions[ 7 ].getoutstance = "crouch";
	positions[ 8 ].getoutstance = "crouch";


	positions[ 2 ].ragdoll_getout_death = true;
	positions[ 3 ].ragdoll_getout_death = true;
	positions[ 4 ].ragdoll_getout_death = true;
	positions[ 5 ].ragdoll_getout_death = true;
	positions[ 6 ].ragdoll_getout_death = true;
	positions[ 7 ].ragdoll_getout_death = true;
	positions[ 8 ].ragdoll_getout_death = true;
	
	positions[ 2 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 3 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 4 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 5 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 6 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 7 ].ragdoll_fall_anim = %fastrope_fall;
	positions[ 8 ].ragdoll_fall_anim = %fastrope_fall;

	positions[ 2 ].getoutsnd = "fastrope_loop_npc";
	positions[ 3 ].getoutsnd = "fastrope_loop_npc";
	positions[ 4 ].getoutsnd = "fastrope_loop_npc";
	positions[ 5 ].getoutsnd = "fastrope_loop_npc";
	positions[ 6 ].getoutsnd = "fastrope_loop_npc";
	positions[ 7 ].getoutsnd = "fastrope_loop_npc";
	positions[ 8 ].getoutsnd = "fastrope_loop_npc";
//	positions[ 9 ].getoutsnd = "fastrope_loop_npc";

	
//	positions[ 0 ].getoutloop = %bh_Pilot_idle;
//	positions[ 1 ].getoutloop = %bh_coPilot_idle;

/*
	positions[ 2 ].getoutloop = %bh_fastrope_loop;
	positions[ 3 ].getoutloop = %bh_fastrope_loop;
	positions[ 4 ].getoutloop = %bh_fastrope_loop;
	positions[ 5 ].getoutloop = %bh_fastrope_loop;
	positions[ 6 ].getoutloop = %bh_fastrope_loop;
	positions[ 7 ].getoutloop = %bh_fastrope_loop;
	positions[ 8 ].getoutloop = %bh_fastrope_loop;
	positions[ 9 ].getoutloop = %bh_fastrope_loop;
*/
	positions[ 2 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 3 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 4 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 5 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 6 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 7 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 8 ].getoutloopsnd = "fastrope_loop_npc";
//	positions[ 9 ].getoutloopsnd = "fastrope_loop_npc";
	
//	positions[ 0 ].getoutland = %bh_Pilot_idle;
//	positions[ 1 ].getoutland = %bh_coPilot_idle;
/*
	positions[ 2 ].getoutland = %bh_fastrope_land;
	positions[ 3 ].getoutland = %bh_fastrope_land;
	positions[ 4 ].getoutland = %bh_fastrope_land;
	positions[ 5 ].getoutland = %bh_fastrope_land;
	positions[ 6 ].getoutland = %bh_fastrope_land;
	positions[ 7 ].getoutland = %bh_fastrope_land;
	positions[ 8 ].getoutland = %bh_fastrope_land;
	positions[ 9 ].getoutland = %bh_fastrope_land;
*/	
	
//	positions[ 0 ].getoutrig = "TAG_FastRope_LE";
//	positions[ 1 ].getoutrig = "TAG_FastRope_LE";

	// 1, 2, 4, 5, 6, & 8


	positions[ 2 ].getoutrig = "TAG_FastRope_RI"; //1
	positions[ 3 ].getoutrig = "TAG_FastRope_RI";	//2
	positions[ 4 ].getoutrig = "TAG_FastRope_LE";	//4
	positions[ 5 ].getoutrig = "TAG_FastRope_LE";	//5
	positions[ 6 ].getoutrig = "TAG_FastRope_RI"; //8
	positions[ 7 ].getoutrig = "TAG_FastRope_LE"; //6
	positions[ 8 ].getoutrig = "TAG_FastRope_RI"; //7
//	positions[ 9 ].getoutrig = "TAG_FastRope_RI";
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
	unload_groups[ "right" ][ unload_groups[ "right" ].size ] = 8;

	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 2;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 3;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 4;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 5;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 6;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 7;
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 8;

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
