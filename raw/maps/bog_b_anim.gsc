#include maps\_anim;
#using_animtree("generic_human");
main()
{
	animated_model_setup();
	
	level.scr_anim[ "dumpsterGuy" ][ "dumpster_idle1" ][ 0 ]		= %bog_b_dumpster_guy1_idle;
	level.scr_anim[ "dumpsterGuy" ][ "dumpster_peek" ]				= %bog_b_dumpster_guy1_peek;
	level.scr_anim[ "dumpsterGuy" ][ "dumpster_idle2_reach" ]		= %bog_b_dumpster_guy1_push_idle;
	level.scr_anim[ "dumpsterGuy" ][ "dumpster_idle2" ][ 0 ]		= %bog_b_dumpster_guy1_push_idle;
	level.scr_anim[ "dumpsterGuy" ][ "dumpster_push" ]				= %bog_b_dumpster_guy1_push;
	level.scr_anim[ "price" ][ "dumpster_push" ]					= %bog_b_dumpster_guy2_push;
	
	level.scr_anim[ "alley_door_kicker_left" ][ "idle" ][ 0 ]	= %breach_kick_stackl1_idle;
	level.scr_anim[ "alley_door_kicker_left" ][ "idle_reach" ]	= %breach_kick_stackl1_idle;
	level.scr_anim[ "alley_door_kicker_left" ][ "enter" ]		= %breach_kick_stackl1_enter;
	level.scr_anim[ "alley_door_kicker_right" ][ "enter" ]		= %breach_kick_kickerr1_enter;
	level.scr_sound[ "alley_door_kicker_right" ][ "enter" ]		= "bog_gm1_breaching";					// "Breaching breaching!"
	addNotetrack_customFunction( "alley_door_kicker_right", "kick", maps\bog_b::alley_doorOpen );
	
	// guy in stand casual pose tells you to stop as you walk in the room
	level.scr_anim[ "guard" ][ "stop" ]					= %bog_b_guard_stop;
	level.scr_sound[ "guard" ][ "stop" ]				= "bog_gm4_holdhere";					// "Hold up! There's a T-72 movin' up the road!"
	level.scr_anim[ "guard" ][ "react" ]				= %bog_b_guard_react;
	level.scr_anim[ "guard" ][ "celebrate" ]			= %hunted_celebrate;
	level.scr_anim[ "gm1" ][ "celebrate" ]				= %hunted_celebrate;
	level.scr_anim[ "gm2" ][ "celebrate" ]				= %hunted_celebrate;
	level.scr_anim[ "gm3" ][ "celebrate" ]				= %hunted_celebrate;
	level.scr_anim[ "gm4" ][ "celebrate" ]				= %hunted_celebrate;
	level.scr_anim[ "gm5" ][ "celebrate" ]				= %hunted_celebrate;
	
	// price calls in the position of the tank to the m1a1 friendly tank
	level.scr_anim[ "price" ][ "casual_2_spot" ]		= %bog_b_spotter_casual_2_spot;
	level.scr_anim[ "price" ][ "spot_2_casual" ]		= %bog_b_spotter_spot_2_casual;
	level.scr_anim[ "price" ][ "spot" ][ 0 ]			= %bog_b_spotter_spot_idle;
	level.scr_anim[ "price" ][ "spot" ][ 1 ]			= %bog_b_spotter_spot_twitch;
	level.scr_anim[ "price" ][ "react" ]				= %bog_b_spotter_react;
	
	level.scr_anim[ "casualcrouch" ][ "react" ]			= %bog_b_casualcrouch_react;
	
	if ( !isdefined( level.scr_animtree ) )
		level.scr_animtree = [];
	
	dumpster_anims();
	tank_crush_anims();
	tank_explode_anims();
	
	dialog();
}

#using_animtree( "script_model" );
dumpster_anims()
{
	level.scr_animtree[ "dumpster" ]			= #animtree;
	level.scr_anim[ "dumpster" ][ "dumpster_idle1" ][ 0 ]	= %bog_b_dumpster_guy1_idle_dumpster;
	level.scr_anim[ "dumpster" ][ "dumpster_peek" ]			= %bog_b_dumpster_guy1_peek_dumpster;
	level.scr_anim[ "dumpster" ][ "dumpster_idle2" ][ 0 ]	= %bog_b_dumpster_guy1_push_idle_dumpster;
	level.scr_anim[ "dumpster" ][ "dumpster_push" ]			= %bog_b_dumpster_guy1_push_dumpster;
}

#using_animtree( "vehicles" );
tank_crush_anims()
{
	level.scr_animtree[ "tank_crush" ]			= #animtree;
	level.scr_anim[ "truck" ][ "tank_crush" ]	= %pickup_tankcrush_front;
	level.scr_anim[ "tank" ][ "tank_crush" ] 	= %tank_tankcrush_front;
	level.scr_sound[ "tank_crush" ]				= "bog_tank_crush_truck";
	level.scr_sound[ "tank_crush2" ]			= "bog_tank_crush_truck2";
}

#using_animtree( "vehicles" );
tank_explode_anims()
{
	level.scr_animtree[ "tank_explosion" ]		= #animtree;
	level.scr_anim[ "tank" ][ "explosion1" ]	= %bog_b_tank_explosion;
	level.scr_anim[ "tank" ][ "explosion2" ]	= %bog_b_tank_explosion2;
}

dialog()
{
	//Generic Marine 1
	level.scr_sound[ "marine1" ][ "getyourass" ]	= "bog_gm1_getyourass";
	level.scr_sound[ "marine1" ][ "rightflank" ]	= "bog_gm1_rightflank";
	
	//Generic Marine 2
	level.scr_sound[ "marine2" ][ "enemyair" ]		= "bog_gm2_enemyair";
	
	//Tank Commander
	level.scr_sound[ "tank_commander" ][ "wereclear" ]			= "bog_tcm_wereclear";
	level.scr_sound[ "tank_commander" ][ "possibleambush" ]		= "bog_tcm_possibleambush";
	level.scr_sound[ "tank_commander" ][ "standclear" ]			= "bog_tcm_standclear";
	level.scr_sound[ "tank_commander" ][ "cleartoadvance" ]		= "bog_tcm_cleartoadvance";
	level.scr_sound[ "tank_commander" ][ "rogermoving" ]		= "bog_tcm_rogermoving";
	level.scr_sound[ "tank_commander" ][ "movingup" ]			= "bog_tcm_movingup";
	level.scr_sound[ "tank_commander" ][ "3story11_2ndfloor" ]	= "bog_tcm_3story11_2ndfloor";
	level.scr_sound[ "tank_commander" ][ "3story1130_2ndfloor" ]= "bog_tcm_3story1130_2ndfloor";
	level.scr_sound[ "tank_commander" ][ "2story1_ground" ]		= "bog_tcm_2story1_ground";
	level.scr_sound[ "tank_commander" ][ "2story1_2ndfloor" ]	= "bog_tcm_2story1_2ndfloor";
	level.scr_sound[ "tank_commander" ][ "3story1230_2ndfloor" ]= "bog_tcm_3story1230_2ndfloor";
	level.scr_sound[ "tank_commander" ][ "fire" ]				= "bog_tcm_fire1";
	level.scr_sound[ "tank_commander" ][ "switchmanual" ]		= "bog_tcm_switchmanual";				// "Roger that Bravo Six, I got him on thermal, switching to manual."
	level.scr_sound[ "tank_commander" ][ "takeshot" ]			= "bog_tcm_takeshot";					// "Takin' the shot."
	
	
	
	//Tank Loader
	level.scr_sound[ "tank_loader" ][ "up1" ]					= "bog_tld_up1";
	level.scr_sound[ "tank_loader" ][ "up2" ]					= "bog_tld_up2";
	level.scr_sound[ "tank_loader" ][ "up3" ]					= "bog_tld_up3";
	level.scr_sound[ "tank_loader" ][ "up4" ]					= "bog_tld_up4";
	
	//Tank Gunner
	level.scr_sound[ "tank_gunner" ][ "targetacquired1" ]		= "bog_tgn_targetacquired1";
	level.scr_sound[ "tank_gunner" ][ "targetacquired2" ]		= "bog_tgn_targetacquired2";
	level.scr_sound[ "tank_gunner" ][ "targetacquired3" ]		= "bog_tgn_targetacquired3";
	
	//Captain Price
	level.scr_sound[ "price" ][ "grabrpg" ]						= "bog_pri_grabrpg";
	level.scr_sound[ "price" ][ "watchrooftops" ]				= "bog_pri_watchrooftops";
	level.scr_sound[ "price" ][ "rogermoveup" ]					= "bog_pri_rogermoveup";
	level.scr_sound[ "price" ][ "roger" ]						= "bog_pri_roger";
	
	level.scr_sound[ "price" ][ "keeppinned" ]					= "bog_pri_keeppinned";					// "Private, keep 'em pinned down from here! Alpha! Lets' head out back and flank 'em from the right!! Move!!!"
	level.scr_sound[ "grigsby" ][ "staysharp" ]					= "bog_grg_staysharp";					// "They's pullin' back...stay sharp, could be a trap."
	
	level.scr_sound[ "mgkiller_right" ][ "comingleft" ]			= "bog_gm1_comingleft";					// "Bravo Six, this is Charlie Two Delta. We're comin' in from your left side at the far end. Hold your fire, we're almost at the door over."
	level.scr_sound[ "price" ][ "rogerthat" ]					= "bog_pri_rogerthat";					// "Roger that!"
	
	level.scr_sound[ "price" ][ "t72behind" ]					= "bog_pri_t72behind";					// "Warpig! T-72 behind the building at your 10 o'clock! Can you engage over!!"
	
	level.scr_sound[ "gm1" ][ "callit" ]						= "bog_gm1_callit";						// "Anyone wanna call it? I'm thinkin' thirty feet."
	level.scr_sound[ "gm2" ][ "afterlast" ]						= "bog_gm2_afterlast";					// "After the last time? Whatever man, I say fifty."
	level.scr_sound[ "gm1" ][ "youreon" ]						= "bog_gm1_youreon";					// "Ok you're on."
	
	level.scr_sound[ "gm1" ][ "wooyeah" ]						= "bog_gm1_wooyeah";					// "WOOOOOO!!!! YEAH!!!! Woo!!!"
	level.scr_sound[ "gm2" ][ "holyshit" ]						= "bog_gm2_holyshit";					// "HOLY shit did you see that???"
	level.scr_sound[ "gm3" ][ "hellyeah" ]						= "bog_gm3_hellyeah";					// "Hell yeah that turret flew like a fuckin' bird man!!!"
	level.scr_sound[ "gm4" ][ "yeahwoo" ]						= "bog_gm4_yeahwoo";					// "Yeah!!! Woooo!!!!"
	level.scr_sound[ "gm5" ][ "talkinabout" ]					= "bog_gm4_talkinabout";				// "YEAHHHHH!!!! That's what I'm talkin' 'bout baby!!!"
	
	level.scr_sound[ "price" ][ "niceshootingpig" ]				= "bog_pri_niceshootingpig";			// "Nice shootin' Warpig. Lots o' secondaries. Now let's get the hell outta here."
	level.scr_sound[ "tank_commander" ][ "wethereyet" ]			= "bog_tcm_wethereyet";					// "Roger that Bravo Six. So…uh, hehe, are we there yet?"
	level.scr_sound[ "tank_commander" ][ "comingthrough" ]		= "bog_tcm_comingthrough";				// "Comin' through."
	level.scr_sound[ "hq_radio" ][ "statusover" ]				= "bog_hqr_statusover";					// "Bravo Six, 2nd Platoon is moving to rendezvous near your location, what's your status over?"
	level.scr_sound[ "price" ][ "cargo" ]						= "bog_pri_cargo";						// "Precious cargo is intact and en route. We're almost at Highway 4 and should make visual contact shortly with 2nd Platoon. Out."
	
	level.scr_sound[ "saknight" ][ "getonboard" ]				= "bog_mhp_getonboard";					// "Lt. Vasquez, this is Outlaw Two-Five. The Task Force is moving in to capture Al-Asad. It's all hands on deck for this one so get on board, over."
	level.scr_sound[ "price" ][ "fixonposition" ]				= "bog_pri_fixonposition";				// "Roger that! Marines! We just got a fix on Al-Asad's position! Everyone on board! Let's go!"
}

#using_animtree ("animated_props");
animated_model_setup()
{
	level.anim_prop_models["foliage_tree_palm_tall_1"]["still"] = %palmtree_tall1_still;
	level.anim_prop_models["foliage_tree_palm_tall_1"]["strong"] = %palmtree_tall1_sway;
	level.anim_prop_models["foliage_tree_palm_med_1"]["still"] = %palmtree_med1_still;
	level.anim_prop_models["foliage_tree_palm_med_1"]["strong"] = %palmtree_med1_sway;
	level.anim_prop_models["foliage_tree_palm_bushy_2"]["still"] = %palmtree_bushy2_still;
	level.anim_prop_models["foliage_tree_palm_bushy_2"]["strong"] = %palmtree_bushy2_sway;
	level.anim_prop_models["foliage_tree_palm_bushy_1"]["still"] = %palmtree_bushy1_still;
	level.anim_prop_models["foliage_tree_palm_bushy_1"]["strong"] = %palmtree_bushy1_sway;
}

/*

Generic Arabic 1:
(In Arabic) "Let them enter, then attack them once they've passed!"
bog_as1_letenter

Generic Arabic 2:
(In Arabic) "They're downstairs, get ready"
bog_as2_getready

Generic Marine 1:
"Throwing flash."
bog_gm1_throwflash

Generic Marine 2:
"Tango down."
bog_gm2_tangodown

Generic Marine 3:
"Go! Go! Go!"
bog_gm3_gogogo

Generic Marine 1:
"CLEAR!"
bog_gm4_clear

Generic Marine 2:
"CLEAR UP!"
bog_gm1_clearup

Generic Marine 4:
"GET DOWN!!!!"
bog_gm2_getdown

Generic Marine 5:
"INCOMING!!!"
bog_gm3_incoming




Tank Commander ( Radio ):
"Bravo Six, this is Warpig. Bad news - we're down to one H.E. round and a couple of sabots for the main gun. Over."
bog_tcm_lowammo

Price:
"You got any GOOD news to go with that, over?"
bog_pri_anygoodnews

Tank Commander ( Radio ):
"Roger that. We have 8000 rounds of .50cal"
bog_tcm_noworries

Tank Commander ( Radio ):
"Never mind, make that 7000 rounds. We'll suppress 'em from here until you can flush 'em out of the buildings. Warpig out."
bog_tcm_pinneddown




Price:
"Warpig, this is Bravo Six! My men are taking heavy fire from the bus, over!!!"
bog_pri_firefrombus

Tank Commander ( Radio ):
"Bravo Six, be advised, we're down to our last high explosive round, over."
bog_tcm_lasthe

Price:
"Roger! Now do it!!!"
bog_pri_nowdoit

Tank Commander ( Radio ):
"You got it. Gunner! Bus at 12 o'clock!"
bog_tcm_yougotit

Tank Gunner:
"Target acquired!!!"
bog_tgn_targetacquired

Tank Commander ( Radio ):
"FIRE!!!"
bog_tcm_firealt

*/