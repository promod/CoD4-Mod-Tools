#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_stealth_logic;
#include maps\icbm_code;
#include maps\_debug;

dialog_intro()
{
	flag_wait( "landed" );
	wait 1;
 	level.price anim_single_queue( level.price, "regrouponme" );
    wait 6;
	
	//Where's Griggs?	
	level.price anim_single_queue( level.price, "wheresgriggs" );
    wait .5;
	//No idea sir.	
	level.gaz anim_single_queue( level.gaz, "noidea" ); 	
	wait 1;
	
	level.player playsound ( "icbm_hqr_gettingabortcodes" );
	wait 6;
	
	//We're on our way. Bravo Six out. Let's go.
	level.price anim_single_queue( level.price, "wereonourway" );
	
	//thread music_tension_loop( "music_endon_start_rescue", "icbm_stealth_movement_music", 56 );
	
	flag_set( "intro_dialog_done" );
}


/*
dialog_intro_old()
{
	flag_wait( "landed" );
	wait 1;
 	level.price anim_single_queue( level.price, "regrouponme" );
    wait 3;
	// iprintlnbold( "Price - Haggerty, you see where Griggs landed?" );
	level.price anim_single_queue( level.price, "grigsby_landed" );
	
    wait .5;
	// iprintlnbold( "Marine1 - Yeah, over by the buildings to the east. You think they got him? " );
	level.gaz anim_single_queue( level.gaz, "bybuildingseast" ); 	
	wait 1;
	// iprintlnbold( "Price - We're about to find out. Haggerty, take point" );
	level.price anim_single_queue( level.price, "abouttofindout" );
	
	thread music_tension_loop( "music_endon_start_rescue", "icbm_combat_tension_music", 55 );
	
	wait 1;
	// iprintlnbold( "Marine1 - You got it sir" );
	level.gaz anim_single_queue( level.gaz, "yougotit" );
	
	flag_set( "intro_dialog_done" );
}
*/

dialog_price_finds_griggs()
{
	// iprintlnbold( "Grigsby - Bout damn time... I was starting to think you guys were gonna leave me behind" );
	level.griggs anim_single_queue( level.griggs, "leavemebehind" );
	wait 0.5;
	// iprintlnbold( "Price - Yeah, that was the plan, but your ass had all the C4.  );
	level.price anim_single_queue( level.price, "firstthought" );
	
	
}

dialog_griggs_is_good()	
{
	// Price - you all right?
	level.price anim_single_queue( level.price, "youallright" );
	
	// iprintlnbold( "Grigsby - Yeah I'm good to go." );
	level.griggs anim_single_queue( level.griggs, "goodtogo" );	
	wait 1;
	// Price - Got Grigsby
	level.price anim_single_queue( level.price, "gotgriggs" );
}

dialog_check_houses()
{
 	level.price anim_single_queue( level.price, "griggsinhouses" ); 	
 	wait 1;						
	// iprintlnbold( "Price - Looks like we've got an entry point through that basement door. We'll work room to room from there" );
	level.price anim_single_queue( level.price, "keepitquiet" ); 
	
	flag_set( "music_endon_start_rescue" );
	thread music_tension_loop( "music_endon_tower_collapse", "icbm_launch_tension_music", 103 );
	level.ambient_track ["amb_day_intensity0"] = "ambient_icbm_ext0";
}

dialog_ambush_finished()
{
	guy = get_a_generic_friendly();
	//blues = get_force_color_guys( "allies", "b" );
	guy anim_single_queue( guy, "tangodown" ); 
	wait 1;	
	// iprintlnbold( "Price - move out" );
	level.price anim_single_queue( level.price, "move" );
	//wait 3;
	//truck_radio = getent( "truck_radio", "targetname" );
	//truck_radio play_sound_in_space( "icbm_ru1_unit4report", truck_radio.origin );
}

dialog_post_knife_kill()
{
	trigger_wait( "gaz_floor_clear", "targetname" );
	
	if ( !flag ( "house1_cleared" ) )
		level.gaz anim_single_queue( level.gaz, "roomclear" );
	wait 2;
	if ( !flag ( "house1_cleared" ) )
		level.gaz anim_single_queue( level.gaz, "floorsclear" );
}

dialog_proceed_upstairs()
{
	//Gaz: Floor clear. Proceed upstairs.
	level.gaz anim_single_queue( level.gaz, "proceedupstairs" );	
}

dialog_rescue_breach()
{
	// level.price anim_single_queue( level.price, "thisisplace" );
	level.player playsound( "icbm_pri_thisisplace" );
	wait 3;

	// level.price anim_single_queue( level.price, "readytobreach" );
	level.player playsound( "icbm_pri_readytobreach" );
}

tower_nag()
{
	level endon( "tower_destroyed" );
	if ( flag ( "tower_destroyed" ) )
		return;
	while ( 1 )
	{
		wait 30;
		// iprintlnbold( "Price - Jackson DO IT!" );
		level.price anim_single_queue( level.price, "doit" );
    } 
}

fence1_nag()
{
	level endon( "cut_fence1" );
	while ( 1 )
	{
		wait 50;
		// iprintlnbold( "Price - Regroup! Regroup on my position!" ); 	
       	level.price anim_single_queue( level.price, "jacksonregroup" );
    }   		
}

dialog_rescue()
{
	wait 2;
	
	level.gaz anim_single_queue( level.gaz, "allclear" );
	//level.buddies[ 1 ] anim_single_queue( level.buddies[ 1 ], "building2secured" );
	
	wait 1;
	level.price anim_single_queue( level.price, "cutloose" );
	wait 1;
    objective_string( 2, &"ICBM_UNTIE_GRIGGS" );
    
    wait 3;
    
    dialog_price_finds_griggs();
    
	wait 1;
	flag_wait( "griggs_loose" );
	
    dialog_griggs_is_good();
}

dialog_grigs_guys_jibjab()
{
	level endon( "breach_started" );
	level endon( "player_shooting_interogators" );
	
	level.ru1 anim_single_queue( level.ru1, "whereothers" );
	wait 1;
	level.griggs anim_single_queue( level.griggs, "grg_678452056" );
	wait 1;
	level.ru1 anim_single_queue( level.ru1, "tovarisch" );
	wait 1;
	level.ru1 anim_single_queue( level.ru1, "howmany" );
	wait 1;
	level.griggs anim_single_queue( level.griggs, "grg_678" );	
	level.ru1 anim_single_queue( level.ru1, "whoisofficer" );
	//wait 2;
	
	flag_set ( "get_yer_ass" );
	
	level.griggs anim_single_queue( level.griggs, "blowme" );
	wait 2;
	level.ru1 anim_single_queue( level.ru1, "whereshacksaw" );
	wait 1;
	level.ru1 anim_single_queue( level.ru1, "youhadit" );
	wait 0.5;
	level.ru1 anim_single_queue( level.ru1, "ifihad" );
}

dialog_enemy_vehicle()
{
	self waittill ( "trigger" );
	wait 3;
	
	flag_wait( "intro_dialog_done" );
	
	// iprintlnbold( "Marine1 - Contact front. Enemy vehicle." );
	
	if ( !flag ( "truckguys dead" ) )
		level.gaz anim_single_queue( level.gaz, "enemyvehicle" );  
	// iprintlnbold( "Price - I see 'em. Spread out!" );
	// level.price anim_single_queue( level.price, "abouttofindout" ); 
	flag_set ( "truck_spotted" );
}


dialog_blow_up_tower()
{
	tower_dialog = getent ( "tower_dialog", "targetname" );
	if ( isdefined ( tower_dialog ) )
		tower_dialog waittill ( "trigger" );
	
	// Price - lets go
	wait 0.5;
	level.price anim_single_queue( level.price, "blowuptower" );
}

dialog_contacts_in_the_woods()
{
	//self is bad guy
	while ( ( distance ( level.player.origin, self.origin ) ) > 2000 )
	{
		wait 1;
		if ( ! isalive ( self ) )
			break;
	}
	if ( flag ( "contacts_in_the_woods" ) )
		return;
	flag_set ( "contacts_in_the_woods" );
	
	
	guy = get_a_generic_friendly();
	if ( isalive ( guy ) )
		guy anim_single_queue( guy, "insight" ); 
}

dialog_jackson_do_it()
{
	level endon ( "tower_destroyed" );
	
	tower = getent( "tower", "targetname" );
	allies = getaiarray( "allies" );
	allies[ allies.size ] = level.player;
	
	for ( i = 0; i < allies.size; i++ )
	{
		if ( ! isalive ( allies [ i ] ) )
			continue;
		while ( distance ( allies[ i ].origin, tower.origin ) < 460 )
			wait .5;
	}
	
	level.price anim_single_queue( level.price, "doit" );
	level thread tower_nag();
}



dialog_tango_down()
{
	self waittill ( "death", killer );

	if ( !isdefined( killer ) )
		return;
	if ( killer == level.player )
		return;
	if (!isdefined ( killer.animname ) )
		return;
	
	if ( level.tango_down_dialog )
	{
		if ( randomint ( 2 ) > 0 )
			return;   //dont play dialog half the time if not the first time
	}
	dialog_enemy_kills( killer );
	level.tango_down_dialog = true;
}


dialog_enemy_kills( killer )
{
	/*
	i=0;
	dialog = [];
	dialog[ dialog.size ] = spawnstruct();
	dialog[ dialog.size ].sound = "UK_pri_inform_killfirm_generic_s";
	dialog[ dialog.size ].speaker = price;
	dialog[ dialog.size ] = spawnstruct();
	dialog[ dialog.size ].sound = "UK_0_inform_killfirm_generic_s";
	dialog[ dialog.size ].speaker = generic;
	dialog[ dialog.size ] = spawnstruct();
	dialog[ dialog.size ].sound = "UK_1_inform_killfirm_generic_s"; 
	dialog[ dialog.size ].speaker = generic;
	dialog[ dialog.size ] = spawnstruct();
	dialog[ dialog.size ].sound = "UK_2_inform_killfirm_generic_s"; 	
	dialog[ dialog.size ].speaker = gaz;
	dialog[ dialog.size ] = spawnstruct();
	dialog[ dialog.size ].sound = "UK_3_inform_killfirm_generic_s"; 	
	dialog[ dialog.size ].speaker = gaz;
	dialog[  dialog.size ] = spawnstruct();
	dialog[  dialog.size ].sound = "icbm_sas2_neutralized"; 	
	dialog[  dialog.size ].speaker = gaz;
	dialog[  dialog.size ] = spawnstruct();
	dialog[  dialog.size ].sound = "icbm_sas2_tangodown"; 	
	dialog[  dialog.size ].speaker = gaz;
	
	dialog = array_randomize( dialog );
	*/
	
	dialog[ "price" ] = "UK_pri_inform_killfirm_generic_s"; 	
	dialog[ "generic" ] = "UK_0_inform_killfirm_generic_s"; 
	dialog[ "gaz" ] = "UK_2_inform_killfirm_generic_s"; 
	
	//killer anim_single_queue( killer, create_anim_entry ); 
	killer playsound ( dialog[ killer.animname ] );
}


dialog_get_fence_open()
{
	// iprintlnbold( "Price - Grigsby, Haggerty chop the fence" );
	level.price anim_single_queue( level.price, "getfenceopen" );
	
	musicStop( 10 );
}

dialog_enemy_helicopters()
{
	trigger = getent( "move_to_oldbase01", "targetname" );
	assertex( isDefined( trigger ), "move_to_oldbase01 trigger not found" );
	trigger waittill( "trigger" );
	trigger trigger_off();
	// iprintlnbold( "Marine1 - Enemy helicopters!" );
	level.gaz anim_single_queue( level.gaz, "enemyhelicopters" );
	wait 1;
	level.griggs anim_single_queue( level.griggs, "getbusy2" );
}
	
dialog_trucks_with_shooters()
{	
	trigger = getent( "move_to_oldbase02", "targetname" );
	assertex( isDefined( trigger ), "move_to_oldbase02 trigger not found" );
	trigger waittill( "trigger" );
	trigger trigger_off();

	
	// iprintlnbold( "Marine4 - Team One, this is Team Two.  Three trucks packed with shooters are headed your way." );
	level.price anim_single_queue( level.price, "truckswithshooters" );
	wait 0.5;	
	// iprintlnbold( "Price - Copy. We're entering the old base now. Standby." );
	level.price anim_single_queue( level.price, "approachingbase" );
}


dialog_rpgs_on_rooftops()
{
	trigger_wait( "rpgs_on_roof_top", "targetname" );
	
	wait 4;
	
	level.gaz anim_single_queue( level.gaz, "rpgsonrooftop" );	
	//level.gaz playsound ( "icbm_sas1_rpgsonrooftop" );
}
	
dialog_rpgs_on_rooftops2()
{
	trigger_wait( "rpgs_on_roof_top2", "targetname" );
	
	level.gaz anim_single_queue( level.gaz, "rpgsonrooftop2" );
	//level.gaz playsound ( "icbm_sas2_rpgsonrooftops" );
}	
	
dialog_choppers_dropping()
{
	trigger_wait( "chopper_dialog1", "targetname" );
	
	level.gaz anim_single_queue( level.gaz, "choppersinbound" );
	wait 6;
	level.price anim_single_queue( level.price, "droppingin" ); 
	
	//trigger_wait( "chopper_dialog2", "targetname" );//not used
}

dialog_first_fight_clear_and_move()
{
	level endon ( "second_fight_started" );
	flag_wait( "first_fight_clear" );
	
	wait 2;
	
	//Gaz: All Clear
	level.gaz anim_single_queue( level.gaz, "allclear" );
	wait .3;
	activate_trigger_with_targetname( "first_fight_clear_nodes" );
	//level.gaz custom_battlechatter( "move_generic" );
	autosave_by_name( "all_clear" );	
}

dialog_second_fight_clear_and_move()
{
	level endon ( "third_fight_started" );
	flag_wait ( "second_fight_cleared" );
	
	wait 2;
	
	//Gaz: All Clear
	level.gaz anim_single_queue( level.gaz, "allclear" );
	wait .3;
	activate_trigger_with_targetname( "second_fight_friendly_nodes" );
	//level.gaz custom_battlechatter( "move_generic" );
	autosave_by_name( "all_clear" );
}