#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, no_death )
{
	maps\_mi17_noai::main( model, "mi17", no_death ); // set the stuff in _noai
	build_localinit( ::init_local );

	build_treadfx();

	build_aianims( ::setanims , ::set_vehicle_anims );
	build_attach_models( ::set_attached_models );
	build_unload_groups( ::Unload_Groups );
	// Other settings in _mi17_noai.gsc 
}

init_local()
{
//	self.originheightoffset = 116;  //TODO-FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.originheightoffset = distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );  //TODO-FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.fastropeoffset = 710; //TODO-FIXME: this is ugly. If only there were a getanimendorigin() command
	self.script_badplace = false; //All helicopters dont need to create bad places
	
	maps\_vehicle::lights_on( "running" );
}

set_vehicle_anims( positions )
{
//	positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	
	for( i=0;i<positions.size;i++ )
		positions[ i ].vehicle_getoutanim = %mi17_heli_idle;

	return positions;
}

setplayer_anims( positions )
{
//	positions[ 3 ].player_idle = %bh_player_idle;
//	positions[ 3 ].player_getout_sound = "fastrope_start_plr";
//	positions[ 3 ].player_getout_sound_loop = "fastrope_loop_plr";
//	positions[ 3 ].player_getout_sound_end = "fastrope_end_plr";

//	positions[ 3 ].player_getout = %bh_player_drop;
//	positions[ 3 ].player_animtree = #animtree;
	
	return positions;
}

#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<10;i++ )
		positions[ i ] = spawnstruct();
		
//	positions[ 0 ].idle = %mi17_pilot_idle;
	
	positions[ 1 ].idle = %mi17_1_idle;
	positions[ 2 ].idle = %mi17_2_idle;
	positions[ 3 ].idle = %mi17_3_idle;
	positions[ 4 ].idle = %mi17_4_idle;
	positions[ 5 ].idle = %mi17_5_idle;
	positions[ 6 ].idle = %mi17_6_idle;
	positions[ 7 ].idle = %mi17_7_idle;
	positions[ 8 ].idle = %mi17_8_idle;
	
//	positions[ 9 ].idle = %mi17_copilot_idle;

	positions[ 0 ].idle[ 0 ] = %helicopter_pilot1_idle;
	positions[ 0 ].idle[ 1 ] = %helicopter_pilot1_twitch_clickpannel;
	positions[ 0 ].idle[ 2 ] = %helicopter_pilot1_twitch_lookback;
	positions[ 0 ].idle[ 3 ] = %helicopter_pilot1_twitch_lookoutside;
	positions[ 0 ].idleoccurrence[ 0 ] = 500;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;	
	positions[ 0 ].idleoccurrence[ 2 ] = 100;	
	positions[ 0 ].idleoccurrence[ 3 ] = 100;	
	
	positions[ 0 ].bHasGunWhileRiding = false;	
	positions[ 9 ].bHasGunWhileRiding = false;	
	

	positions[ 9 ].idle[ 0 ] = %helicopter_pilot2_idle;
	positions[ 9 ].idle[ 1 ] = %helicopter_pilot2_twitch_clickpannel;
	positions[ 9 ].idle[ 2 ] = %helicopter_pilot2_twitch_lookoutside;
	positions[ 9 ].idle[ 3 ] = %helicopter_pilot2_twitch_radio;
	positions[ 9 ].idleoccurrence[ 0 ] = 450;
	positions[ 9 ].idleoccurrence[ 1 ] = 100;	
	positions[ 9 ].idleoccurrence[ 2 ] = 100;	
	positions[ 9 ].idleoccurrence[ 3 ] = 100;		
	
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_detach";
	positions[ 2 ].sittag = "tag_detach";
	positions[ 3 ].sittag = "tag_detach";
	positions[ 4 ].sittag = "tag_detach";
	positions[ 5 ].sittag = "tag_detach";
	positions[ 6 ].sittag = "tag_detach";
	positions[ 7 ].sittag = "tag_detach";
	positions[ 8 ].sittag = "tag_detach";
	positions[ 9 ].sittag = "tag_passenger";
	
	positions[ 1 ].getout = %mi17_1_drop;
	positions[ 2 ].getout = %mi17_2_drop;
	positions[ 3 ].getout = %mi17_3_drop;
	positions[ 4 ].getout = %mi17_4_drop;
	positions[ 5 ].getout = %mi17_5_drop;
	positions[ 6 ].getout = %mi17_6_drop;
	positions[ 7 ].getout = %mi17_7_drop;
	positions[ 8 ].getout = %mi17_8_drop;

	positions[ 1 ].getoutstance = "crouch";
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
	
	positions[ 1 ].getoutsnd = "fastrope_loop_npc";
	positions[ 2 ].getoutsnd = "fastrope_loop_npc";
	positions[ 3 ].getoutsnd = "fastrope_loop_npc";
	positions[ 4 ].getoutsnd = "fastrope_loop_npc";
	positions[ 5 ].getoutsnd = "fastrope_loop_npc";
	positions[ 6 ].getoutsnd = "fastrope_loop_npc";
	positions[ 7 ].getoutsnd = "fastrope_loop_npc";
	positions[ 8 ].getoutsnd = "fastrope_loop_npc";

	positions[ 1 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 2 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 3 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 4 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 5 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 6 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 7 ].getoutloopsnd = "fastrope_loop_npc";
	positions[ 8 ].getoutloopsnd = "fastrope_loop_npc";
	
	positions[ 1 ].getoutrig = "TAG_FastRope_RI";
	positions[ 2 ].getoutrig = "TAG_FastRope_RI";
	positions[ 3 ].getoutrig = "TAG_FastRope_RI";
	positions[ 4 ].getoutrig = "TAG_FastRope_RI";
	positions[ 5 ].getoutrig = "TAG_FastRope_LE";
	positions[ 6 ].getoutrig = "TAG_FastRope_LE";
	positions[ 7 ].getoutrig = "TAG_FastRope_LE";
	positions[ 8 ].getoutrig = "TAG_FastRope_LE";
	
	return setplayer_anims( positions );                           
}                                             



unload_groups()
{
	unload_groups = [];
	unload_groups[ "back" ] = [];
	unload_groups[ "front" ] = [];
	unload_groups[ "both" ] = [];


	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 1;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 2;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 3;
	unload_groups[ "back" ][ unload_groups[ "back" ].size ] = 4;

	unload_groups[ "front" ][ unload_groups[ "front" ].size ] = 5;
	unload_groups[ "front" ][ unload_groups[ "front" ].size ] = 6;
	unload_groups[ "front" ][ unload_groups[ "front" ].size ] = 7;
	unload_groups[ "front" ][ unload_groups[ "front" ].size ] = 8;
	
	unload_groups[ "both" ][ unload_groups[ "both" ].size ] = 1;
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
	array[ "TAG_FastRope_LE" ].idleanim = %mi17_rope_idle_le;
	array[ "TAG_FastRope_LE" ].dropanim = %mi17_rope_drop_le;

	array[ "TAG_FastRope_RI" ] = spawnstruct();
	array[ "TAG_FastRope_RI" ].model = "rope_test_ri";
	array[ "TAG_FastRope_RI" ].tag = "TAG_FastRope_RI";
	array[ "TAG_FastRope_RI" ].idleanim = %mi17_rope_idle_ri;
	array[ "TAG_FastRope_RI" ].dropanim = %mi17_rope_drop_ri;
	
	strings = getarraykeys( array );
	
	for( i=0;i<strings.size;i++ )
		precachemodel( array[ strings[ i ] ].model );

	return array;
}
