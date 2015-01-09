#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle_aianim;
#include maps\armada;

#using_animtree ("generic_human");
anim_main()
{
	//only second guy kills
	//addNotetrack_customFunction( "generic", "fire", ::kill_during_breach, "detcord_stack_leftbreach_01" );
	addNotetrack_customFunction( "generic", "fire", ::kill_during_breach, "detcord_stack_leftbreach_02" );

	
	
	level.scr_anim[ "generic" ][ "jog" ]			= %combat_jog;
	level.scr_anim[ "generic" ][ "walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_stop" ]    = %patrol_bored_walk_2_bored;
	
	// quiet door open
	level.scr_anim[ "price" ][ "hunted_open_barndoor" ] =			%hunted_open_barndoor;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_stop" ] =		%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_idle" ][0] =	%hunted_open_barndoor_idle;
	
	animated_model_setup();
	
	level.scr_anim[ "razorwire_guy" ][ "razor_setup" ] = %armada_wire_setup_guy;
	level.scr_anim[ "barbed_wire_long" ][ "razor_setup" ] = %armada_wire_setup_wire;
	level.scr_anim[ "razorwire_guy" ][ "razor_idle" ] = %armada_wire_setup_guy_startidle;
	level.scr_anim[ "barbed_wire_long" ][ "razor_idle" ] = %armada_wire_setup_wire_startidle;
	level.scr_anim[ "razorwire_guy" ][ "razor_endidle" ] = %armada_wire_setup_guy;
	level.scr_anim[ "barbed_wire_long" ][ "razor_endidle" ] = %armada_wire_setup_wire_endidle;
	level.scr_animtree[ "barbed_wire_long" ] = #animtree;	
	
	level.scr_anim[ "griggs" ][ "enter" ] = %armada_grigs_enter;
	addNotetrack_dialogue( "griggs", "dialog", "enter", "armada_grg_scoreone" );
	
	level.scr_anim[ "griggs" ][ "end_idle" ][0] = %armada_grigs_music_idle;
	level.scr_anim[ "final_breacher_shotgun" ][ "react" ] = %armada_Left_Guy_react;
	level.scr_anim[ "final_breacher_right" ][ "react" ] = %armada_Right_Guy_react;
	
	level.scr_anim[ "price" ][ "finish" ] = %armada_sarge_end;
	addNotetrack_dialogue( "price", "dialog", "finish", "armada_vsq_rogercommand" );
	addNotetrack_dialogue( "price", "dialog", "finish", "armada_vsq_rallyup" );
	
	level.scr_anim[ "price" ][ "enter" ] = %armada_sarge_enter;
	addNotetrack_dialogue( "price", "dialog", "enter", "armada_vsq_griggsmusic" );
	addNotetrack_dialogue( "price", "dialog", "enter", "armada_vsq_recording" );
	
	
	
	//    DIALOG           
	
	level.scr_sound[ "price" ][ "targetbuilding" ]	= "armada_vsq_targetbuilding";//Target building in sight.
	level.scr_sound[ "price" ][ "throwflash" ]	= "armada_vsq_throwflash";//Jackson, throw a flashbang!
	
	level.scr_sound[ "griggs" ][ "watchsix" ]	= "armada_grg_watchsix";//Watch your six Devil Dog.
	
	level.scr_sound[ "price" ][ "allcallsigns" ]	= "armada_vsq_allcallsigns";	//All callsigns, check the bodies. We need a positive ID on Al-Asad.	
	level.scr_sound[ "generic" ][ "negid" ]		= "armada_gm1_negid";	//Negative ID over here sir.	
	level.scr_sound[ "generic" ][ "nosign" ]	= "armada_gm2_nosign";	//No sign of Al-Asad here sir.	

	level.scr_sound[ "generic" ][ "oorah1" ]		= "armada_gm2_oorah";	//Oo-rah…	
	level.scr_sound[ "generic" ][ "oorah2" ]	= "armada_gm3_oorah";	//Ooo-rah…	
	
	level.scr_sound[ "generic" ][ "armada_gm1_clear" ]		= "armada_gm1_clear";
	level.scr_sound[ "generic" ][ "armada_gm2_clear" ]		= "armada_gm2_clear";
	level.scr_sound[ "generic" ][ "armada_gm3_roomclear" ]	= "armada_gm3_roomclear";
	level.scr_sound[ "generic" ][ "armada_gm2_nothere" ]	= "armada_gm2_nothere";
	level.scr_sound[ "generic" ][ "armada_gm1_onaloop" ]	= "armada_gm1_onaloop";
	
	

	
	level.scr_sound[ "price" ][ "jacksonpoint" ]	= "armada_vsq_jacksonpoint";//jackson take point	
	level.scr_sound[ "price" ][ "stand_down" ]			= "armada_vsq_donthavealasad";
	level.scr_sound[ "price" ][ "roger_hq" ]			= "armada_vsq_rogerthat";
	level.scr_sound[ "price" ][ "heads_up" ]			= "armada_vsq_halfclickeast";
	level.scr_sound[ "price" ][ "move_out" ]			= "armada_vsq_moveout"; //We're gonna move out on foot, and take down the package there. Move out.

	
	level.scr_sound[ "generic" ][ "tvstation" ]				= "armada_gm1_tvstation";
	level.scr_sound[ "price" ][ "get_into_pos" ]				= "armada_vsq_getintoposition"; //Good, get in position to breach.


	level.scr_sound[ "price" ][ "do_it" ] = "armada_vsq_doit"; //Do it!
	level.scr_sound[ "generic" ][ "breaching_breaching" ] = "armada_gm1_breachingbreaching"; //Breaching breaching!


	level.scr_sound[ "price" ][ "room_clear" ] = "armada_vsq_roomclear"; //Room clear! Move up! Al-Asad should be on the second floor!

	level.scr_sound[ "generic" ][ "goesourboys" ] = "armada_gm1_goesourboys";  //there goes our boys!

	level.scr_sound[ "griggs" ][ "hold_fire" ] = "armada_grg_holdfire"; //Hold your fire! Friendlies coming out!
	level.scr_sound[ "griggs" ][ "no_sign" ] = "armada_grg_nosign"; //No sign of Al-Asad sir.
	level.scr_sound[ "price" ][ "fall_in" ] = "armada_vsq_fallin"; //All right. Fall in Marines. Stay frosty.

	level.scr_sound[ "griggs" ][ "I_hear_him" ] = "armada_grg_ihearhim"; //I think he's in there. I hear him.
	
	level.scr_sound[ "griggs" ][ "score_one" ] = "armada_grg_scoreone"; //Yeah…(snicker). Score one for mil-i-ta-ry intelligence!
	level.scr_sound[ "price" ][ "grigs_music" ] = "armada_vsq_griggsmusic"; //Griggs... music.
	level.scr_sound[ "griggs" ][ "roger_that" ] = "armada_grg_rogerMS"; //Roger that Master Sergeant!
	
	level.scr_sound[ "price" ][ "recording" ] = "armada_vsq_recording"; //Command this is Red Dog. TV station secure. No sign of Al-Asad. The broadcast is a recording, over.
	level.scr_sound[ "griggs" ][ "yeahhh" ] = "armada_grg_yeahoorah"; //Yeahhhh. Oooo-rahhh…
	
	level.scr_sound[ "price" ][ "roger_command" ] = "armada_vsq_rogercommand"; //Roger that Command. Out.
	level.scr_sound[ "price" ][ "new_assign" ] = "armada_vsq_rallyup"; //Marines! Rally up! We got a new assignment. Get your gear, and get ready to move out! Let's go!
}

// nate

guy_snipe( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	self notify ("ropeidleend");
	
	if( pos == 2 )
	{
		animontag( guy, animpos.sittag, %armada_blackhawk_sniper_idle );
	}
	thread guy_idle( guy, pos );
}





#using_animtree ("animated_props");
animated_model_setup()
{
	level.anim_prop_models["foliage_tree_palm_tall_3"]["still"] = %palmtree_tall3_still;
	level.anim_prop_models["foliage_tree_palm_tall_3"]["strong"] = %palmtree_tall3_sway;
	level.anim_prop_models["foliage_tree_palm_med_2"]["still"] = %palmtree_med2_still;
	level.anim_prop_models["foliage_tree_palm_med_2"]["strong"] = %palmtree_med2_sway;
	level.anim_prop_models["foliage_tree_palm_bushy_1"]["still"] = %palmtree_bushy1_still;
	level.anim_prop_models["foliage_tree_palm_bushy_1"]["strong"] = %palmtree_bushy1_sway;
	level.anim_prop_models["foliage_tree_palm_bushy_2"]["still"] = %palmtree_bushy2_still;
	level.anim_prop_models["foliage_tree_palm_bushy_2"]["strong"] = %palmtree_bushy2_sway;
	level.anim_prop_models["foliage_tree_palm_tall_2"]["still"] = %palmtree_tall2_still;
	level.anim_prop_models["foliage_tree_palm_tall_2"]["strong"] = %palmtree_tall2_sway;
	level.anim_prop_models["foliage_tree_palm_bushy_3"]["still"] = %palmtree_bushy3_still;
	level.anim_prop_models["foliage_tree_palm_bushy_3"]["strong"] = %palmtree_bushy3_sway;
	level.anim_prop_models["foliage_tree_palm_med_1"]["still"] = %palmtree_med1_still;
	level.anim_prop_models["foliage_tree_palm_med_1"]["strong"] = %palmtree_med1_sway;
	level.anim_prop_models["foliage_tree_palm_tall_1"]["still"] = %palmtree_tall1_still;
	level.anim_prop_models["foliage_tree_palm_tall_1"]["strong"] = %palmtree_tall1_sway;
}


#using_animtree ("vehicles");

player_heli_ropeanimoverride()
{
	// oh no, I've gone and made the fastrope very difficult to simply override animations so I'm overriding the whole damn thing for the ride in on armada - Nate.
	
	tag = "TAG_FastRope_RI";
	model = "rope_test_ri";
	snipeanim = %armada_blackhawk_sniper_idle_fastrope80;
	idleanim = %armada_blackhawk_sniper_idle_loop_fastrope80;
	dropanim = %armada_blackhawk_sniper_drop_fastrope80;
	
	array = [];
	array[ "TAG_FastRope_RI" ] = spawnstruct();
	self.attach_model_override = array;  // gets rid of blackhawks standard fastrope stuff for this rig

	rope = spawn("script_model", level.player.origin);
	rope setmodel (model);
	rope linkto (self, tag, (0,0,0),(0,0,0));
	rope useanimtree (#animtree);
	
//	flag_wait ("snipefromheli");
	//self notify ("groupedanimevent","snipe");  //tells the ai to snipe.
	//maps\_vehicle_aianim::animontag( rope, tag, snipeanim );
	thread player_heli_ropeanimoverride_idle( rope, tag, idleanim );
	self waittill ("unload");
	level.player thread play_loop_sound_on_entity("fastrope_loop_plr");
	thread maps\_vehicle_aianim::animontag( rope, tag, dropanim );
	wait getanimlength( dropanim ) - .2;
	level.player stop_loop_sound_on_entity("fastrope_loop_plr");
 	rope unlink();
 	level.player thread play_sound_on_entity("fastrope_end_plr");
	wait 10;
	rope delete();  // possibly do something to delete when the player is not looking at it.	
}

player_heli_ropeanimoverride_idle( guy, tag, animation )
{
	self endon ("unload");
	while(1)
		maps\_vehicle_aianim::animontag( guy, tag, animation );
}