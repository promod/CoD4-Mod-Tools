#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\coup_code;

main()
{
	precachemodel( "fx" );
	precachemodel( "viewhands_player_usmc" );
	precachemodel( "weapon_desert_eagle_silver_HR_promo" );
	precachemodel( "com_door_01_handleright" );
	precachemodel( "chicken" );
	precachemodel( "com_cellphone_on" );
	precachemodel( "com_trashcan_metal" );
	precachemodel( "com_spray_can01" );
	precacheShellShock( "coup_blackout1" );
	precacheShellShock( "coup_blackout2" );
	precacheShellShock( "coup_blackout3" );
	precacheShellShock( "coup_death" );
	
	initSubtitles();

	level.debug_turnanims = false;
	level.debug_passengeranims = false;
	level.debug_slowmo = false;
	level.debug_speech = false;
	
	level.weaponClipModels = [];
	level.weaponClipModels[ 0 ] = "weapon_ak47_clip";
	level.weaponClipModels[ 1 ] = "weapon_ak74u_clip";

	default_start( ::startIntro );
	add_start( "drive", ::startDrive, &"STARTS_DRIVE" );
	add_start( "doorkick", ::startDoorKick, &"STARTS_DOORKICK" );
	add_start( "trashstumble", ::startTrashStumble, &"STARTS_TRASHSTUMBLE" );
	add_start( "runners2", ::startRunners2, &"STARTS_RUNNERS2" );
	add_start( "alley", ::startAlley, &"STARTS_ALLEY2" );
	add_start( "shore", ::startShore, &"STARTS_SHORE" );
	add_start( "carexit", ::startCarExit, &"STARTS_CAREXIT" );
	add_start( "ending", ::startEnding, &"STARTS_END" );

	maps\_luxurysedan::main( "vehicle_luxurysedan_viewmodel" );
	maps\_hind::main( "vehicle_mi24p_hind_desert" );
 	maps\_mig29::main( "vehicle_mig29_desert" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
 	maps\_80s_sedan1::main( "vehicle_80s_sedan1_silv" );
 	maps\_mi17::main( "vehicle_mi17_woodland_fly" );
 	maps\_bmp::main( "vehicle_bmp" );
 	maps\_uaz::main( "vehicle_uaz_fabric" );
 	animscripts\dog_init::initDogAnimations();
	
	maps\coup_fx::main();
	maps\createart\coup_art::main();
	maps\_load::main();
	maps\createfx\coup_audio::main();
	maps\coup_anim::main();
	thread maps\coup_amb::main();
	maps\_drone::init(); 
	DeleteCharacterTriggers();

 	// spawn func support was removed from drones so much of this no longer works
 	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	//array_thread( getentarray( "civilian", "script_noteworthy" ), ::add_spawn_function, ::gun_remove );
	array_thread( getentarray( "civilian", "script_noteworthy" ), ::add_spawn_function, ::RemoveWeapon );
	array_thread( getentarray( "civilian_redshirt", "script_noteworthy" ), ::add_spawn_function, ::setSightDist, 0 );
	array_thread( getentarray( "civilian_redshirt", "script_noteworthy" ), ::add_spawn_function, ::setTeam, "allies" );
	array_thread( getentarray( "civilian_redshirt", "script_noteworthy" ), ::add_spawn_function, ::RemoveWeapon );
	array_thread( getentarray( "civilian_attacker", "script_noteworthy" ), ::add_spawn_function, ::setTeam, "allies" );
	array_thread( getentarray( "civilian_firingsquad", "script_noteworthy" ), ::add_spawn_function, ::setTeam, "allies" );
	array_thread( getentarray( "guard_firingsquad", "script_noteworthy" ), ::add_spawn_function, ::setupTarget );
	array_thread( getentarray( "passenger_event", "targetname" ), ::passenger_event );
	array_thread( getentarray( "loudspeaker_event", "targetname" ), ::loudspeaker_event );
	array_thread( getentarray( "delete_on_goal", "script_noteworthy" ), ::add_spawn_function, ::DeleteOnGoal );
	array_thread( getentarray( "intro_crowdmember", "targetname" ), ::blah );
	array_thread( getentarray( "endcrowd_crowdmember", "targetname" ), ::blah );
	//array_thread( getentarray( "civilian", "script_noteworthy" ), ::add_spawn_function, ::gun_remove_drone );
	
	flag_init( "drive" );
	flag_init( "doors_open" );
	flag_init( "ending" );
	flag_init( "firingsquad_atnodes" );
	flag_init( "firingsquad_aiming" );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	battlechatter_off( "neutral" );
	
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player takeAllWeapons();
	level.player.ignoreme = true;
	level.player EnableInvulnerability();

	level.playerview = spawn_anim_model( "playerview" );
	level.playerview hide();

	level.car = spawn_anim_model( "car" );
	

	tag_offset = level.car fake_tag( "tag_origin", (-48, 0, 48) );
	playfxontag( level._effect["car_interior"], tag_offset, "tag_origin" );
	//tag_offset thread maps\_debug::drawTagForever( "tag_origin", ( 0, 1, 0 ) );
	
	// TODO: Add more of these
	addPassengerEvent( "phone", "animation", "carpassenger_phone" );
	addPassengerEvent( "phone", "dialog", "coup_ab4_wehavetraitor", 3 );
	addPassengerEvent( "turnleft", "animation", "carpassenger_pointturn" );
	addPassengerEvent( "turnleft", "dialog", "coup_ab4_turnlefthere" );
	addPassengerEvent( "turnright", "dialog", "coup_ab4_rightatintersection" );
	addPassengerEvent( "point", "animation", "carpassenger_point" );

	wait 0.05;// can't set dvars on the first frame
	SetSavedDvar( "g_friendlyfiredist", 0 );
	SetSavedDvar( "g_friendlynamedist", 0 );	
	SetSavedDvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", 1 );	
	SetSavedDvar( "hud_showStance", 0 );
	// setsaveddvar( "cg_fov", 50 );
	SetSavedDvar( "g_entEqEnable", 0 );
}

startIntro()
{
	thread initCredits();
	thread intro_doors();
	//intro_scuffle();
	
	thread execIntro();
}

startDrive()
{
	thread execDrive();
	flag_set( "drive" );
}

startDoorKick()
{
	thread execDrive( 0.15 );
	flag_set( "drive" );
}

startTrashStumble()
{
	start = getent( "start_trashstumble", "targetname" );
	
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );

	thread execDrive( 0.32 );
	flag_set( "drive" );
}

startRunners2()
{
	thread execDrive( 0.45 );
	flag_set( "drive" );
}

startAlley()
{
	start = getent( "start_alley", "targetname" );
	
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );

	thread execDrive( 0.55 );
	flag_set( "drive" );
}

startShore()
{
	start = getent( "start_shore", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );

	thread execDrive( 0.80 );
	flag_set( "drive" );
}

startCarExit()
{
	start = getent( "start_carexit", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );

	thread execDrive( 0.88 );
	flag_set( "drive" );
}

startEnding()
{
	start = getent( "start_ending", "targetname" );
	
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( start.angles );
	
	thread execEnding();
}

blah()
{
	self waittill( "drone_spawned", drone );

	drone thread crowdmember_setuptriggers();
	drone setcontents(0);
}

execIntro()
{
	thread execDrive();
	thread intro_speech();
	thread playCredits();
	thread SubtitleSequence();
	delaythread( 0.5, ::music_start );
	delaythread( 0.5, ::openIntroDoors );
	delaythread( 5, ::intro_birds );
	delaythread( 1, ::ziptie, "ziptie1a", undefined, 20 );
	delaythread( 1, ::spawn_vehicle_from_targetname_and_drive, "intro_heli" );

	node = getent( "intro_node", "targetname" );
	leftguard = scripted_spawn2( "intro_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "intro_rightguard", "targetname", true );
	carguard = scripted_spawn2( "intro_carguard", "targetname", true );
	radioguard = scripted_spawn2( "intro_radioguard", "targetname", true );
	smokingguard = scripted_spawn2( "intro_smokingguard", "targetname", true );
	dog = scripted_spawn2( "intro_dog", "targetname", true );

	idleguards = scripted_array_spawn( "intro_idleguards", "targetname", true );
	for ( i = 0; i < idleguards.size; i++ )
		idleguards[ i ].animname = "human";

	crowdmembers = scripted_array_spawn( "intro_crowdmember", "targetname", true );
	for ( i = 0; i < crowdmembers.size; i++ )
	{
		crowdmembers[ i ].animname = "human";
		//crowdmembers[ i ] removeDroneWeapon();
		crowdmembers[ i ].a = spawnstruct();
		crowdmembers[ i ].a.script = "scripted";
		crowdmembers[ i ].a.weaponPos["right"] = "defined";
		crowdmembers[ i ] thread celebrate();
	}

	tiedcivilians = scripted_array_spawn( "intro_tiedcivilian", "targetname", true );
	for ( i = 0; i < tiedcivilians.size; i++ )
		thread ziptied( tiedcivilians[ i ], 20 );

	eatingdogs = scripted_array_spawn( "intro_eatingdogs", "targetname", true );
	for ( i = 0; i < eatingdogs.size; i++ )
	{
		eatingdog = eatingdogs[ i ];
		eatingdog.animname = "dog";
		
		eatingdog thread anim_loop_solo( eatingdog, "eating" );
	}

	rightguard.animname = "human";
	leftguard.animname = "human";
	radioguard.animname = "human";
	smokingguard.animname = "human";
	dog.animname = "dog";

	radioguard thread anim_single_solo( radioguard, "radio" );
	smokingguard thread anim_loop_solo( smokingguard, "leaning_smoking_idle" );
	dog thread anim_single_solo( dog, "idle" );

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	node anim_first_frame_solo( playerview, "intro" );
	level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );

	node thread anim_single_solo( rightguard, "intro_rightguard" );
	node thread anim_single_solo( leftguard, "intro_leftguard" );
	node thread anim_single_solo( level.car, "intro" );
	node anim_single_solo( playerview, "intro" );
	
	wait 1.5;
	flag_set( "drive" );
}

execDrive( time )
{
	thread drive_talkingguards1();
	thread drive_casualguards1();
	thread drive_eatingdog1();
	thread drive_doorkick1();
	thread drive_ziptie1();
	thread drive_ziptie2();
	thread drive_ziptie3();
	thread drive_doorkick2();
	thread drive_runners1();
	thread drive_windowshout1();
	thread drive_gunpoint1();
	thread drive_interrogation1();
	thread drive_trashstumble();
	thread drive_casualguards2();
	thread drive_spraypaint1();
	thread drive_sneakattack();
	thread drive_ziptie4();
	thread drive_runners2();
	thread drive_garage2();
	thread drive_basehelicopters();
	thread drive_celebrators2();
	thread drive_casualguards3();
	thread drive_endcrowd();
	thread drive_fastrope1();
	thread drive_firingsquad();
	thread drive_ziptie5();
	thread drive_dogchase1();
	thread drive_carjack1();
	thread drive_dumpsterhide1();
	thread drive_phonering();
	thread drive_carsounds();
	thread drive_arrivewalla();

	// show car tags
	// level.car thread maps\_debug::drawTagForever( "tag_driver", ( 0, 1, 0 ) );
	// level.car thread maps\_debug::drawTagForever( "tag_passenger" );
	// level.car thread maps\_debug::drawTagForever( "tag_guy0" );
	// level.car thread maps\_debug::drawTagForever( "tag_guy1" );

	car_driver = scripted_spawn2( "car_driver", "targetname", true );
	car_driver.animname = "human";
	car_driver linkto( level.car, "tag_driver" );
	car_driver thread magic_bullet_shield( undefined, undefined, undefined, undefined, true );

	car_passenger = scripted_spawn2( "car_passenger", "targetname", true );
	car_passenger.animname = "human";
	car_passenger linkto( level.car, "tag_passenger" );
	car_passenger thread magic_bullet_shield( undefined, undefined, undefined, undefined, true );
	
	level.car.driver = car_driver;
	level.car.passenger = car_passenger;
	level.car.playerview = level.playerview;

	level.car thread maps\coup_anim::loopDriverAnim( "idle" );
	level.car thread maps\coup_anim::loopPassengerAnim( "carpassenger_idle" );

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	level.car anim_first_frame_solo( playerview, "car_idle_firstframe", "tag_guy1" );
	playerview linkto( level.car, "tag_guy1" );
	//playerview linkto( level.car, "tag_guy1", ( 50, 0, -20 ), ( 0, 90, 0 ) ); // view driver 
	//playerview linkto( level.car, "tag_guy1", ( 35, 26, -20 ), ( 0, 0, 0 ) ); // view wheel

	flag_wait( "drive" );

	// level.player playerlinktodelta( playerview, "tag_player", 1, 180, 180, 30, 30 );
	level.player playerlinktodelta( playerview, "tag_player", 1, 150, 150, 45, 45 );

	// level.car thread anim_loop_solo( playerview, "car_idle", "tag_guy1", "stop_playerview_idle" );// temp

	drive_node = getent( "intro_node", "targetname" );
	drive_node thread anim_single_solo( level.car, "coup_car_driving" );
	
	if ( isdefined( time ) )
	{
		anime = level.car getanim( "coup_car_driving" );
		level.car SetAnimTime( anime, time );
	}
	
	thread execCarExit();
}

execCarExit()
{
	flag_wait( "drive_carexit" );

	node = getent( "carexit_node", "targetname" );

	leftguard = scripted_spawn2( "carexit_leftguard", "targetname", true );
	leftguard.animname = "human";
	node anim_first_frame_solo( leftguard, "carexit_leftguard" );
	leftguard thread anim_loop_solo( leftguard, "stand_idle" );

	rightguard = scripted_spawn2( "carexit_rightguard", "targetname", true );
	rightguard.animname = "human";
	node anim_first_frame_solo( rightguard, "carexit_rightguard" );
	rightguard thread anim_loop_solo( rightguard, "stand_idle" );
	
	level.car waittillmatch( "single anim", "end" );

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	level.car anim_first_frame_solo( playerview, "carexit" );
	wait 0.05;

	final_origin = playerview gettagorigin( "tag_player" );
	final_angles = playerview gettagangles( "tag_player" );

	origin = spawn( "script_model", level.player.origin );
	origin setmodel( "tag_origin" );
	origin.origin = get_player_feet_from_view();
	origin.angles = level.player GetPlayerAngles();

	level.player unlink();
	wait( 0.05 );
	level.player playerlinktodelta( origin, "tag_origin", 1, 0, 0, 0, 0 );

	level.car thread anim_single_solo( leftguard, "carexit_leftguard" );
	level.car thread anim_single_solo( rightguard, "carexit_rightguard" );
	level.car thread anim_single_solo( level.car, "carexit" );
	
	//wait 1;
	blend = 0.25;
	duration = 2; // 0.8
	origin MoveTo( final_origin, duration, duration * blend, duration * blend );
	origin RotateTo( final_angles, duration, duration * blend, duration * blend );

	wait duration;
	level.player playerlinkto( playerview, "tag_player", 1, 0, 0, 0, 0 );
	level.car thread anim_single_solo( playerview, "carexit" );

	wait 10.6; // 12.6
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.sort = 1;

	thread pulseFadeVision( 26.95, 0 );// long pulsing fades
	maps\_ambient::set_ambience_blend_over_time( 0, "exterior", "bunker" );
	//thread maps\_ambient::set_ambience_blend_over_time( 34, "bunker", "exterior" );
	delaythread( 28.5, maps\_ambient::set_ambience_blend_over_time, 5.5, "bunker", "exterior" );
	level.player shellshock( "coup_blackout1", 8 );// fade out over 1 sec, wait 2, fade in over 5
	overlay blackOut( 1, 6 );
	deleteai_special = getent( "deleteai_special", "script_noteworthy" );
	deleteai_special.origin = level.player.origin;
	wait 2;

	thread music_end();

	// do intro drag with glimpses
	node = getent( "enddrag1_node", "targetname" );
	leftguard = scripted_spawn2( "enddrag_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "enddrag_rightguard", "targetname", true );

	rightguard.animname = "human";
	leftguard.animname = "human";

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	node anim_first_frame_solo( playerview, "intro" );
	playerview_angles = playerview gettagangles( "tag_player" );
	level.player setPlayerAngles( playerview_angles );
	level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );

	node thread anim_single_solo( rightguard, "intro_rightguard" );
	node thread anim_single_solo( leftguard, "intro_leftguard" );
	node thread anim_single_solo( playerview, "intro" );
	level.dragsound = level.player thread PlayLinkedSound( "scn_coup_drag_to_post" );

	level notify( "continue_credits" );
	overlay restoreVision( 5, 2.5 );
	wait 5;
	level.player shellshock( "coup_blackout2", 8 );// fade out over 1 sec, wait 2, fade in over 5
	overlay blackOut( 1, 6 );
	wait 2;

	// scripted_array_spawn( "ending_spawner", "script_noteworthy", true );
	// scripted_array_spawn( "ending_idleguards", "targetname", true );

	idleguards = scripted_array_spawn( "ending_idleguards", "targetname", true );
	for ( i = 0; i < idleguards.size; i++ )
		idleguards[ i ].animname = "human";

	smokingguards = scripted_array_spawn( "ending_smokingguards", "targetname", true );
	for ( i = 0; i < smokingguards.size; i++ )
	{
		smokingguards[ i ].animname = "human";
		smokingguards[ i ] thread anim_loop_solo( smokingguards[ i ], "leaning_smoking_idle" );
	}

	celebratingguards = scripted_array_spawn( "ending_celebratingguards", "targetname", true );
	for ( i = 0; i < celebratingguards.size; i++ )
	{
		celebratingguards[ i ].animname = "human";
		//celebratingguards[ i ] removeDroneWeapon();
		celebratingguards[ i ].a = spawnstruct();
		celebratingguards[ i ].a.script = "scripted";
		celebratingguards[ i ].a.weaponPos["right"] = "defined";
		celebratingguards[ i ] thread celebrate();
	}

	level.zakhaev = scripted_spawn2( "ending_zakhaev", "targetname", true );
	level.zakhaev.animname = "human";
	level.zakhaev gun_remove();
	level.zakhaev attach( "weapon_desert_eagle_silver_HR_promo", "tag_inhand" );
	tunnel_node = getent( "tunnel_node", "targetname" );
	tunnel_node thread first_frame_delay_anim( level.zakhaev, "ending_zakhaev", 6 );

	//node = getent( "enddrag3_node", "targetname" );
	node = getent( "enddrag4_node", "targetname" );
	node anim_first_frame_solo( playerview, "intro" );
	node thread anim_single_solo( rightguard, "intro_rightguard" );
	node thread anim_single_solo( leftguard, "intro_leftguard" );
	node thread anim_single_solo( playerview, "intro" );

	level.player thread play_sound_on_entity( "scn_coup_walla_stadium" );

	overlay restoreVision( 5, 2.5 );
	wait 5;
	level.player shellshock( "coup_blackout3", 8 );// fade out over 1 sec, wait 2, fade in over 5
	overlay blackOut( 1, 6 );
	wait 2;

	thread execEnding();
	leftguard delete();
	rightguard delete();
	playerview delete();

	//overlay.alpha = 0; // testing
	overlay restoreVision( 4, 0 );
	overlay destroy();
}

first_frame_delay_anim( guy, anime, delay )
{
	self anim_first_frame_solo( guy, anime );
	
	wait delay;
	self anim_single_solo( guy, anime );
}

execEnding()
{
	thread initDOF();
	thread ending_shadowchange();
	thread ending_speech();
	thread ending_slowmo();
	setDOF( 0, 1, 5, 500, 2000, 4 );// initial DOF setting

	setsaveddvar( "cg_fov", 50 );
	
	node = getent( "ending_node", "targetname" );
	
	alasad = scripted_spawn2( "ending_alasad", "targetname", true );
	alasad.animname = "human";
	alasad removeDroneWeapon();
	
	//zakhaev = scripted_spawn2( "ending_zakhaev", "targetname", true );
	//zakhaev.animname = "human";
	//zakhaev removeDroneWeapon();
	zakhaev = level.zakhaev;
	
	leftguard = scripted_spawn2( "ending_leftguard", "targetname", true );
	leftguard.animname = "human";
	
	rightguard = scripted_spawn2( "ending_rightguard", "targetname", true );
	rightguard.animname = "human";
	
	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	node anim_first_frame_solo( playerview, "ending" );
	
	level.player unlink();
	tag_player = playerview getTagOrigin( "tag_player" );
	level.player setOrigin( tag_player );
	level.player playerlinkto( playerview, "tag_player", 1, 0, 0, 0, 0 );
	
	// works but drag guards are clipping into the player
	//leftguard stopAnimScripted();
	//rightguard stopAnimScripted();
	//pausenode = getent( "ending_pausenode", "targetname" );
	//pausenode thread anim_first_frame_solo( leftguard, "ending_leftguard" );
	//pausenode thread anim_first_frame_solo( rightguard, "ending_rightguard" );

	level.dragsound delete();
	zakhaev detach( "weapon_desert_eagle_silver_HR_promo", "tag_inhand" );
	node thread anim_single_solo( zakhaev, "endtaunt" );
	node anim_single_solo( playerview, "endtaunt" );

	level.player unlink();
	level.player playerlinkto( playerview, "tag_player", 1, 45, 45, 30, 30 );

	SetSavedDvar( "sm_sunSampleSizeNear", "0.25" );
	level.player thread play_sound_on_entity( "scn_coup_drag_to_post_part2" );
	node thread anim_single_solo( playerview, "ending" );
	node thread anim_single_solo( leftguard, "ending_leftguard" );
	node thread anim_single_solo( rightguard, "ending_rightguard" );

	// play anim on alasad so he isn't idling without a weapon if the player looks left
	node thread anim_single_solo( alasad, "ending_alasad" );

	playerview waittillmatch( "single anim", "anim_start" );
	zakhaev attach( "weapon_desert_eagle_silver_HR_promo", "tag_inhand" );
	node thread anim_single_solo( zakhaev, "ending_zakhaev" );
	node thread anim_single_solo( alasad, "ending_alasad" );

	thread ending_dofchange();
}

intro_scuffle()
{
	maps\_ambient::set_ambience_blend_over_time( 0, "exterior", "bunker" );
	level.player thread play_sound_on_entity( "assault_killing_interior2" );
	level.player delaythread( 5, ::play_sound_on_entity, "bog_scn_melee_struggle" );
	
	dragsound = level.player thread PlayLinkedSound( "scn_coup_drag_to_car" );
	dragsound = level.player delaythread( 12.5, ::PlayLinkedSound, "scn_coup_drag_to_car" );
	dragsound thread DeleteOnFlag( "doors_open", 1 );

	wait 15.5;
}

intro_doors()
{
	intro_leftdoor = getent( "intro_leftdoor", "targetname" );
	intro_leftdoor.origin = ( -15, -510, 70 );
	intro_leftdoor.angles += ( 0, 180, 0 );

	intro_rightdoor = getent( "intro_rightdoor", "targetname" );
	intro_rightdoor.origin = ( 143, -510, 70 );
	intro_rightdoor.angles += ( 0, 180, 0 );

	// Force glow on, even if turned off in menu.
	SetSavedDvar( "r_glow_allowed_script_forced", 1 );
	set_vision_set( "coup_sunblind" );
	
	// blackout player's view
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay.sort = 1;
	overlay.foreground = true;
	
	level.player freezeControls( true );
	
	flag_wait( "doors_open" );
	
	level.player freezeControls( false );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	level.player thread play_sound_on_entity( "scn_coup_drag_to_car" );

	set_vision_set( "coup", 12 );
	
	overlay fadeOverTime( 0.5 );
	overlay.alpha = 0;

	wait 0.5;
	overlay destroy();
}

intro_speech()
{
	//origin playsound( "coup_ab4_waitedforthisday" );		// (driver to player, looking forward) I have waited for this day for a long time, Al-Fulani. You're only going to get what you deserve.
	//origin playsound( "coup_ab4_laughs" );				// (driver) Laughing
	//origin playsound( "coup_ab4_endoftheroad" );			// (driver to player, over shoulder) This is the end of the road, Al-Fulani. May you suffer for all eternity for placing yourself and your greed before the security of the great people of this nation.
	//origin playsound( "coup_ab4_pieceoffilth" );			// (driver to player, looking forward) Get this piece of filth out of my car!

	//origin playsound( "coup_ab4_wehavetraitor" );			// (passenger on cell phone) We have the traitor and we are on our way to the palace... Yes sir…. The rest of the royal family is dead. I saw to it personally.
	//origin playsound( "coup_ab4_turnlefthere" );			// (passenger to driver) Turn left here. Turn left.
	//origin playsound( "coup_ab4_rightatintersection" );	// (passenger to driver) Right turn at the next intersection.
	//origin playsound( "coup_ab4_yourescarednow" );		// (passenger to player, looking forward) I'll bet you're scared now, huh? Where are your American friends now? (laughs)
	//origin playsound( "coup_ab4_justwethimself" );		// (passenger to driver, after looking at player) He just wet himself.

	// Outside car
	//origin playsound( "coup_ab4_dontmoveyou" );			// (soldier to civilians) Don't move! You! Stay where you are!
	//origin playsound( "coup_ab4_keepmouthshut" );			// (soldier to civilians) You! Keep your mouth shut! No talking! 
	//origin playsound( "coup_ab4_clearthesebuildings" );	// (soldier to others) Clear these buildings! Move! Move!
	
	// PA sounds
	//origin playsound( "coup_ab4_undermartiallaw" );		//1 (PA) This city is under martial law. Do not attempt to leave the city without proper authorization.
	//origin playsound( "coup_ab4_obeymilitary" );			//1 (PA) Obey the military personnel in your area. Follow their commands and you will not be harmed.
	//origin playsound( "coup_ab4_withinsociety" );			//1 (PA) The corrupt government is no more. Their betrayal will not go unpunished. Report any collaborators to the nearest military patrol. It is your duty as a citizen to prevent corruption within our society.
	//origin playsound( "coup_ab4_actsoftreason" );			// (PA) All men aged 16 to 25 must report to their local recruiting station for assignment to compulsory military service. Failure to report for duty is punishable by incarceration for a first offense. Second offenses will be deemed acts of treason and may be punishable by death.
	//origin playsound( "coup_ab4_safetransition" );		//1 (PA) Martial law is now in effect. Remain in your homes. We are working to ensure a peaceful and safe transition to a government that serves all equally.
	//origin playsound( "coup_ab4_civilunrest" );			// (PA) Civil unrest in sector four. Old regime collaborators have set the market on fire. Intercept and suppress the insurgency.
	
	println( "Walk to car" );
	level.player delaythread( 4, ::playspeech, "coup_kaa_onenation", "Today, we rise again as one nation, in the face of betrayal and corruption!!!" );
	level.player delaythread( 35, ::playspeech, "coup_kaa_newera", "We all trusted this man to deliver our great nation into a new era of prosperity..." );

	println( "In car" );
	level.player delaythread( 66, ::playspeech, "coup_kaa_selfinterest", "...But like our monarchy before the Revolution, he has been colluding with the West with only self interest at heart!" );
	level.player delaythread( 99, ::playspeech, "coup_kaa_notenslaved", "Collusion breeds slavery!! And we shall not be enslaved!!!" );
	level.player delaythread( 140, ::playspeech, "coup_kaa_donotfear", "The time has come to show our true strength. They underestimate our resolve. Let us show that we do not fear them." );
	level.player delaythread( 154, ::playspeech, "coup_kaa_freefromyoke", "As one people, we shall free our brethren from the yoke of foreign oppression!" );
	level.player delaythread( 176, ::playspeech, "coup_kaa_armiesstrong", "Our armies are strong, and our cause is just." );
	level.player delaythread( 182, ::playspeech, "coup_kaa_greatnation", "As I speak, our armies are nearing their objectives, by which we will restore the independence of a once great nation." );
	level.player delaythread( 204.5, ::playspeech, "coup_kaa_begun", "Our noble crusade has begun." );
}

intro_birds()
{
	exploder( 1 );
	
	wait 5.5;
	exploder( 2 );
}

drive_talkingguards1()
{
	flag_wait( "drive_talkingguards1" );

	node = getent( "talkingguards1_node", "targetname" );
	leftguard = scripted_spawn2( "talkingguards1_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "talkingguards1_rightguard", "targetname", true );

	leftguard.animname = "human";
	rightguard.animname = "human";

	node thread anim_single_solo( leftguard, "talkingguards_leftguard" );
	node thread anim_single_solo( rightguard, "talkingguards_rightguard" );
	
	delaythread( 20, ::DeleteEntity, node );
	delaythread( 20, ::DeleteEntity, leftguard );
	delaythread( 20, ::DeleteEntity, rightguard );
}

drive_casualguards1()
{
	flag_wait( "drive_casualguards1" );

	smokingguard = scripted_spawn2( "casualguards1_smokingguard", "targetname", true );
	idleguard1 = scripted_spawn2( "casualguards1_idleguard1", "targetname", true );
	idleguard2 = scripted_spawn2( "casualguards1_idleguard2", "targetname", true );
	dog = scripted_spawn2( "casualguards1_dog", "targetname", true );

	smokingguard.animname = "human";
	dog.animname = "dog";

	smokingguard thread anim_loop_solo( smokingguard, "leaning_smoking_idle" );
	dog thread anim_loop_solo( dog, "sleeping" );
	
	delaythread( 20, ::DeleteEntity, smokingguard );
	delaythread( 20, ::DeleteEntity, idleguard1 );
	delaythread( 20, ::DeleteEntity, idleguard2 );
	delaythread( 20, ::DeleteEntity, dog );
}

drive_eatingdog1()
{
	flag_wait( "drive_eatingdog1" );
	
	dogs = scripted_array_spawn( "eatingdog1_dogs", "targetname", true );
	for ( i = 0; i < dogs.size; i++ )
	{
		dog = dogs[ i ];
		dog.animname = "dog";
		dog thread anim_loop_solo( dog, "eating" );
	
		delaythread( 20, ::DeleteEntity, dog );
	}
}

drive_doorkick1()
{
	flag_wait( "drive_doorkick1" );

	node = getent( "doorkick1_node", "targetname" );
	leftguard = scripted_spawn2( "doorkick1_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "doorkick1_rightguard", "targetname", true );

	node doorkick( leftguard, rightguard, 7, 10 );
}

drive_ziptie1()
{
	flag_wait( "drive_ziptie1" );

	ziptie( "ziptie1", undefined, 20 );
}

drive_ziptie2()
{
	flag_wait( "drive_ziptie2" );

	ziptie( "ziptie2", undefined, 20 );
}

drive_doorkick2()
{
	flag_wait( "drive_doorkick2" );

	node = getent( "doorkick2_node", "targetname" );
	leftguard = scripted_spawn2( "doorkick2_leftguard", "targetname", true );
	rightguard = scripted_spawn2( "doorkick2_rightguard", "targetname", true );

	node doorkick( leftguard, rightguard, undefined, 10, true );
}

// make sure this plays out killing the runners in the correct order
drive_runners1()
{
	flag_wait( "drive_runners1" );

	civilian1 = scripted_spawn2( "runners1_civilian1", "targetname", true );
	civilian2 = scripted_spawn2( "runners1_civilian2", "targetname", true );
	civilian3 = scripted_spawn2( "runners1_civilian3", "targetname", true );
	// civilian4 = scripted_spawn2( "runners1_civilian4", "targetname", true );

	civilian1.animname = "human";
	civilian2.animname = "human";
	civilian3.animname = "human";
	// civilian4.animname = "human";
	
	civilian1.disableexits = true;
	civilian2.disableexits = true;
	civilian3.disableexits = true;
	// civilian4.disableexits = true;

	runanims[ 0 ] = "run_panicked1";
	runanims[ 1 ] = "run_panicked2";
	civilian1 setRandomRun( runanims );
	civilian2 setRandomRun( runanims );
	civilian3 setRandomRun( runanims );
	// civilian4 set_run_anim( runanims[ RandomInt( 1 ) ], true );

	civilian1 thread ignore( 11 );
	civilian2 thread ignore( 7.5 );
	civilian3 thread ignore( 4 );
	
	wait 1.75;

	guard1 = scripted_spawn2( "runners1_guard1", "targetname", true );
	guard2 = scripted_spawn2( "runners1_guard2", "targetname", true );

	wait 5.25;
	guard1.baseaccuracy = 1000;
	guard2.baseaccuracy = 1000;

	
	/* wait 10;
	runner1 delete();
	runner2 delete();
	runner3 delete();*/ 
}

ignore( duration )
{
	self.ignoreme = true;
	self.a.disablePain = true;
	self.allowpain = false;
	self thread magic_bullet_shield();
	
	wait duration;
	self.ignoreme = false;
	self.a.disablePain = false;
	self.allowpain = true;
	self stop_magic_bullet_shield();
}

drive_windowshout1()
{
	flag_wait( "drive_windowshout1" );

	civilian = scripted_spawn2( "windowshout1_civilian", "targetname", true );
	
	thread windowshout( civilian );
}

drive_gunpoint1()
{
	flag_wait( "drive_gunpoint1" );

	standguard = scripted_spawn2( "gunpoint1_standguard", "targetname", true );
	standcivilian = scripted_spawn2( "gunpoint1_standcivilian", "targetname", true );
	crouchguard = scripted_spawn2( "gunpoint1_crouchguard", "targetname", true );
	crouchcivilian = scripted_spawn2( "gunpoint1_crouchcivilian", "targetname", true );

	tiedcivilians = scripted_array_spawn( "gunpoint1_tiedcivilian", "targetname", true );
	for ( i = 0; i < tiedcivilians.size; i++ )
		thread ziptied( tiedcivilians[ i ], 20 );

	thread gunpoint_stand( standguard, standcivilian, 20 );
	thread gunpoint_crouch( crouchguard, crouchcivilian, 20 );
}

drive_interrogation1()
{
	flag_wait( "drive_interrogation1" );

	guard_a = scripted_spawn2( "interrogation1_guard_a", "targetname", true );
	guard_a.animname = "human";
	suspect_a = scripted_spawn2( "interrogation1_suspect_a", "targetname", true );
	suspect_a.animname = "human";

	guard_b = scripted_spawn2( "interrogation1_guard_b", "targetname", true );
	guard_b.animname = "human";
	suspect_b = scripted_spawn2( "interrogation1_suspect_b", "targetname", true );
	suspect_b.animname = "human";

	guard_b2 = scripted_spawn2( "interrogation1_guard_b2", "targetname", true );
	guard_b2.animname = "human";
	suspect_b2 = scripted_spawn2( "interrogation1_suspect_b2", "targetname", true );
	suspect_b2.animname = "human";

	suspect_c = scripted_spawn2( "interrogation1_suspect_c", "targetname", true );
	suspect_c.animname = "human";

	suspect_c2 = scripted_spawn2( "interrogation1_suspect_c2", "targetname", true );
	suspect_c2.animname = "human";

	suspect_d = scripted_spawn2( "interrogation1_suspect_d", "targetname", true );
	suspect_d.animname = "human";

	suspect_d2 = scripted_spawn2( "interrogation1_suspect_d2", "targetname", true );
	suspect_d2.animname = "human";

	suspect_a thread anim_single_solo( suspect_a, "interrogation_suspect_a" );
	suspect_a thread anim_single_solo( guard_a, "interrogation_guard_a" );

	suspect_b delaythread( 1.4, ::anim_single_solo, suspect_b, "interrogation_suspect_b" );
	suspect_b delaythread( 1.4, ::anim_single_solo, guard_b, "interrogation_guard_b" );

	suspect_b2 thread anim_single_solo( suspect_b2, "interrogation_suspect_b" );
	suspect_b2 thread anim_single_solo( guard_b2, "interrogation_guard_b" );

	suspect_c thread anim_single_solo( suspect_c, "interrogation_suspect_c" );
	
	suspect_c2 thread anim_single_solo( suspect_c2, "interrogation_suspect_c" );

	suspect_d thread anim_single_solo( suspect_d, "interrogation_suspect_d" );
	
	suspect_d2 thread anim_single_solo( suspect_d2, "interrogation_suspect_d" );
	
	delaythread( 20, ::DeleteEntity, guard_a );
	delaythread( 20, ::DeleteEntity, guard_b );
	delaythread( 20, ::DeleteEntity, guard_b2 );
	
	delaythread( 20, ::DeleteEntity, suspect_a );
	delaythread( 20, ::DeleteEntity, suspect_b );
	delaythread( 20, ::DeleteEntity, suspect_b2 );
	delaythread( 20, ::DeleteEntity, suspect_c );
	delaythread( 20, ::DeleteEntity, suspect_c2 );
	delaythread( 20, ::DeleteEntity, suspect_d );
	delaythread( 20, ::DeleteEntity, suspect_d2 );
}

drive_ziptie3()
{
	flag_wait( "drive_ziptie3" );

	ziptie( "ziptie3", undefined, 20 );
}

// change guards to script spawned and set accuracy to 0 to make sure the runner isn't killed
drive_trashstumble()
{
	node = getent( "trashstumble_node", "targetname" );

	trashcan_rig = spawn_anim_model( "trashcan_rig" );
	trashcan_rig.origin = node.origin;
	trashcan_rig.angles = node.angles;
	
	trashcan = spawn( "script_model", ( 0, 0, 0 ) );
	trashcan setmodel( "com_trashcan_metal" );
	trashcan.origin = trashcan_rig getTagOrigin( "prop_rig_anim" );
	trashcan.angles = trashcan_rig getTagAngles( "prop_rig_anim" );
	trashcan linkto( trashcan_rig, "prop_rig_anim", ( 0, 0, 0 ), ( 0, 0, -90 ) );	
	node thread anim_first_frame_solo( trashcan_rig, "trash_stumble" );

	flag_wait( "drive_trashstumble" );
	
	//delaythread( 2, ::trashstumble_guards );
	thread trashstumble_guards();

	runner = scripted_spawn2( "trashstumble_runner", "targetname", true );
	runner.animname = "human";
	runner.a.disablePain = true;
	runner.disableExits = true;
	runner.allowpain = false;
	runner.ignoreall = true;
	runner thread magic_bullet_shield();
	runner set_run_anim( "run_panicked2", true );

	// chaser = scripted_spawn2( "trashstumble_chaser", "targetname", true );
	// chaser_goal = getent( "trashstumble_chaser_goal", "targetname" );
	// chaser setgoalpos( chaser_goal.origin );

	node anim_reach_solo( runner, "trash_stumble" );
	node thread anim_single_solo( trashcan_rig, "trash_stumble" );
	node anim_custom_animmode_solo( runner, "gravity", "trash_stumble" );

	node = getent( "wallclimb_node", "targetname" );
	node anim_single_solo( runner, "wall_climb" );
	
	runner thread DeleteOnGoal();
	wait 10;
	trashcan delete();
	trashcan_rig delete();
}

trashstumble_guards()
{
	guard1 = scripted_spawn2( "trashstumble_guard1", "targetname", true );
	guard2 = scripted_spawn2( "trashstumble_guard2", "targetname", true );

	guard1_goal = getent( "trashstumble_guard1_goal", "targetname" );
	guard2_goal = getent( "trashstumble_guard2_goal", "targetname" );

	wait 3;
	guard1.ignoreall = true;
	guard2.ignoreall = true;

	guard1 thread maps\_spawner::go_to_origin( guard1_goal );
	wait 0.5;
	guard2 thread maps\_spawner::go_to_origin( guard2_goal );
	
	wait 3;
	guard1.ignoreall = false;
	//guard2.ignoreall = false;
}

drive_casualguards2()
{
	flag_wait( "drive_casualguards2" );

	smokingguard = scripted_spawn2( "casualguards2_smokingguard", "targetname", true );
	idleguard = scripted_spawn2( "casualguards2_idleguard", "targetname", true );
	smokingguard.animname = "human";

	smokingguard thread anim_loop_solo( smokingguard, "leaning_smoking_idle" );
	
	delaythread( 20, ::DeleteEntity, smokingguard );
	delaythread( 20, ::DeleteEntity, idleguard );
}

drive_spraypaint1()
{
	flag_wait( "drive_spraypaint1" );

	node = getent( "spraypaint1_node", "targetname" );
	civilian = scripted_spawn2( "spraypaint1_civilian", "targetname", true );
	civilian.animname = "human";
	civilian.disableexits = true;
	civilian.ignoreme = true;	// temp
	civilian attach( "com_spray_can01", "tag_inhand" );
	
	runanims[ 0 ] = "run_panicked1";
	runanims[ 1 ] = "run_panicked2";
	civilian set_run_anim( runanims[ RandomInt( 1 ) ], true );

	civilian delaythread( 8.75, ::detach_spraycan );
	node anim_single_solo( civilian, "spraypainting" );
	
	civilian thread DeleteOnGoal();
}

detach_spraycan()
{
	self detach( "com_spray_can01", "tag_inhand" );
}

// guards pointing weapons at civilians are attacked
// they kill atleast 1 civilian at gunpoint
drive_sneakattack()
{
	flag_wait( "drive_sneakattack" );

	cower1 = scripted_spawn2( "sneakattack_cower1", "targetname", true );
	cower1.animname = "human";
	cower1 thread anim_loop_solo( cower1, "cowerstand_pointidle" );
	cower2 = scripted_spawn2( "sneakattack_cower2", "targetname", true );
	cower2.animname = "human";
	cower2 thread anim_loop_solo( cower2, "cowerstand_pointidle" );

	attacker1 = scripted_spawn2( "sneakattack_attacker1", "targetname", true );
	victim1 = scripted_spawn2( "sneakattack_victim1", "targetname", true );
	attacker2 = scripted_spawn2( "sneakattack_attacker2", "targetname", true );
	victim2 = scripted_spawn2( "sneakattack_victim2", "targetname", true );

	wait 5;
	victim1 thread attackbehind( attacker1, 20 );
	victim2 thread attackside( attacker2, 20 );
	
	wait 1;
	cower2 thread anim_single_solo( cower2, "cowerstand_react" );
	
	wait 1;
	cower1 thread anim_single_solo( cower1, "cowerstand_react_to_crouch" );
}

drive_ziptie4()
{
	flag_wait( "drive_ziptie4" );

	tiedcivilians = scripted_array_spawn( "ziptie4_tiedcivilian", "targetname", true );
	for ( i = 0; i < tiedcivilians.size; i++ )
		thread ziptied( tiedcivilians[ i ], 20 );

	thread ziptie( "ziptie4", undefined, 20 );
	wait 2;
	thread ziptie( "ziptie4b", undefined, 20 );
}

drive_runners2()
{
	flag_wait( "drive_runners2" );

	civilian1 = scripted_spawn2( "runners2_civilian1", "targetname", true );
	civilian2 = scripted_spawn2( "runners2_civilian2", "targetname", true );
	civilian3 = scripted_spawn2( "runners2_civilian3", "targetname", true );
	civilian4 = scripted_spawn2( "runners2_civilian4", "targetname", true );

	/* civilian1.animname = "human";
	civilian2.animname = "human";
	civilian3.animname = "human";
	civilian4.animname = "human";
	
	civilian1.disableexits = true;
	civilian2.disableexits = true;
	civilian3.disableexits = true;
	civilian4.disableexits = true;

	runanims[ 0 ] = "run_panicked1";
	runanims[ 1 ] = "run_panicked2";
	
	civilian1 set_run_anim( runanims[ RandomInt( 1 ) ], true );
	civilian2 set_run_anim( runanims[ RandomInt( 1 ) ], true );
	civilian3 set_run_anim( runanims[ RandomInt( 1 ) ], true );
	civilian4 set_run_anim( runanims[ RandomInt( 1 ) ], true );*/ 
	
	wait 1;

	guard1 = scripted_spawn2( "runners2_guard1", "targetname", true );
	guard2 = scripted_spawn2( "runners2_guard2", "targetname", true );
	guard3 = scripted_spawn2( "runners2_guard3", "targetname", true );

	guard1 thread magic_bullet_shield();
	guard2 thread magic_bullet_shield();
	guard3 thread magic_bullet_shield();

	wait 2.5;

	guard1.baseaccuracy = 1000;
	guard2.baseaccuracy = 1000;
	guard3.baseaccuracy = 1000;
	
	flag_wait( "runners2_dead" );

	guard1 stop_magic_bullet_shield();
	guard2 stop_magic_bullet_shield();
	guard3 stop_magic_bullet_shield();
	
	goal = getent( "runners2_guardsgoal", "targetname" );
	guard1 thread maps\_spawner::go_to_origin( goal );
	guard2 thread maps\_spawner::go_to_origin( goal );
	guard3 thread maps\_spawner::go_to_origin( goal );

	guard1 thread DeleteOnGoal();
	guard2 thread DeleteOnGoal();
	guard3 thread DeleteOnGoal();
}

drive_garage2()
{
	flag_wait( "drive_garage2" );

	node = getent( "garage2_node", "targetname" );
	civilian = scripted_spawn2( "garage2_civilian", "targetname", true );
	runner = scripted_spawn2( "garage2_runner", "targetname", true );
	door = getent( "garage2_door", "targetname" );

	node garage( civilian, runner, door, 4 );
}

drive_basehelicopters()
{
	flag_wait( "drive_basehelicopters" );

	helicopter1 = spawn_vehicle_from_targetname_and_drive( "base_helicopter1" );
	helicopter1 sethoverparams( 0, 1, 0.5 );

	wait 1;
	helicopter2 = spawn_vehicle_from_targetname_and_drive( "base_helicopter2" );
	helicopter2 sethoverparams( 0, 1, 0.5 );

	wait 1;
	helicopter3 = spawn_vehicle_from_targetname_and_drive( "base_helicopter3" );
	helicopter3 sethoverparams( 0, 1, 0.5 );

	
	flag_wait( "basehelicopters_flyaway" );
	helicopter1 setSpeed( 60, 15 );
	helicopter2 setSpeed( 60, 15 );
	helicopter3 setSpeed( 60, 15 );
}

drive_celebrators2()
{
	flag_wait( "drive_celebrators2" );

	celebrators = scripted_array_spawn( "celebrators2", "targetname", true );
	for ( i = 0; i < celebrators.size; i++ )
	{
		celebrators[ i ].animname = "human";
		celebrators[ i ] thread celebrate();
	}
}

// add a few dogs
drive_casualguards3()
{
	flag_wait( "drive_casualguards3" );

	smokingguards = scripted_array_spawn( "casualguards3_smokingguards", "targetname", true );
	for ( i = 0; i < smokingguards.size; i++ )
	{
		smokingguards[ i ].animname = "human";
		smokingguards[ i ] thread anim_loop_solo( smokingguards[ i ], "leaning_smoking_idle" );
	}

	idleguards = scripted_array_spawn( "casualguards3_idleguards", "targetname", true );
	for ( i = 0; i < idleguards.size; i++ )
		idleguards[ i ].animname = "human";

	// dog = scripted_spawn2( "casualguards1_dog", "targetname", true );
	// dog.animname = "dog";
	// dog thread anim_loop_solo( dog, "sleeping" );
	
	/* wait 20;
	smokingguard delete();
	idleguard delete();
	dog delete();*/ 
}

drive_endcrowd()
{
	flag_wait( "drive_endcrowd" );

	smokingguards = scripted_array_spawn( "endcrowd_smokingguards", "targetname", true );
	for ( i = 0; i < smokingguards.size; i++ )
	{
		smokingguards[ i ].animname = "human";
		smokingguards[ i ] thread anim_loop_solo( smokingguards[ i ], "leaning_smoking_idle" );
	}

	idleguards = scripted_array_spawn( "endcrowd_idleguards", "targetname", true );
	for ( i = 0; i < idleguards.size; i++ )
		idleguards[ i ].animname = "human";

	crowdmembers = scripted_array_spawn( "endcrowd_crowdmember", "targetname", true );
	for ( i = 0; i < crowdmembers.size; i++ )
	{
		crowdmembers[ i ].animname = "human";
		//crowdmembers[ i ] removeDroneWeapon();
		crowdmembers[ i ].a = spawnstruct();
		crowdmembers[ i ].a.script = "scripted";
		crowdmembers[ i ].a.weaponPos["right"] = "defined";
		crowdmembers[ i ] thread celebrate();
	}

	dog = scripted_spawn2( "endcrowd_idledog", "targetname", true );
	dog.animname = "dog";
	dog thread anim_single_solo( dog, "idle" );// ? why isn't this looped

	// walkguard1 = scripted_spawn2( "endcrowd_walkguard1", "targetname", true );
	// walkguard1 set_generic_run_anim( "patrol_walk", true );

	// goal = getent( walkguard1.target, "targetname" );
	// walkguard1 thread maps\_spawner::go_to_origin( goal );	
	
	/* wait 20;
	smokingguard delete();
	idleguard delete();
	dog delete();*/ 
}

drive_fastrope1()
{
	flag_wait( "drive_fastrope1" );

	spawn_vehicle_from_targetname_and_drive( "fastrope1_heli" );
}

// guards should play raise weapon anim, wait, then fire
drive_firingsquad()
{
	flag_wait( "drive_firingsquad" );

	captain = scripted_spawn2( "firingsquad_captain", "targetname", true );
	guards = scripted_array_spawn( "guard_firingsquad", "script_noteworthy", true );
}

drive_ziptie5()
{
	flag_wait( "drive_ziptie5" );

	tiedcivilians = scripted_array_spawn( "ziptie5_tiedcivilian", "targetname", true );
	for ( i = 0; i < tiedcivilians.size; i++ )
		thread ziptied( tiedcivilians[ i ], 20 );

	thread ziptie( "ziptie5", undefined, 20 );
	wait 1.2;
	thread ziptie( "ziptie5b", undefined, 20 );
}

drive_dogchase1()
{
	flag_wait( "drive_dogchase1" );
	
	thread fenceclimb( "dogchase1", undefined, 12 );
	
	wait 3.5;
	thread fencedog( "dogchase1", undefined, 12 );
}

drive_carjack1()
{
	flag_wait( "drive_carjack1" );
	
	thread carjack( "carjack1", 5, undefined );
}

drive_dumpsterhide1()
{
	flag_wait( "drive_dumpsterhide1" );
	
	thread dumpsterhide( "dumpsterhide1", undefined, 10 );
}

drive_phonering()
{
	flag_wait( "drive_phonering" );
	
	level.car.passenger playsound( "scn_coup_mobile_ring" );
}

dumpsterhide( instance, pausetime, duration )
{
	dumpster = getent( instance + "_dumpster", "targetname" );
	dumpster.animname = "dumpster";
	dumpster assign_animtree();

	civilian = scripted_spawn2( instance + "_civilian", "targetname", true );
	civilian.animname = "human";
	civilian.origin = dumpster.origin;
	civilian.angles = dumpster.angles;
	civilian RemoveDroneWeapon();

	if ( isdefined( pausetime ) )
		wait pausetime;
	
	civilian thread anim_single_solo( civilian, "dumpster_open" );
	dumpster anim_single_solo( dumpster, "dumpster_open" );
	civilian delete();
	
	delaythread( duration, ::DeleteEntity, dumpster );
}

drive_arrivewalla()
{
	flag_wait( "drive_arrivewalla" );
	
	level.player thread play_sound_on_entity( "scn_coup_walla_arrive" );
}

carjack( instance, pausetime, duration )
{
	car = spawn_vehicle_from_targetname( instance + "_car" );
	car.animname = "uaz";

	victim = scripted_spawn2( instance + "_victim", "targetname", true );
	victim.animname = "human";
	
	driver = scripted_spawn2( instance + "_driver", "targetname", true );
	driver.animname = "human";
	driver.cartag = "tag_driver";
	
	frontright = scripted_spawn2( instance + "_frontright", "targetname", true );
	frontright.animname = "human";
	frontright.cartag = "tag_passenger";
	
	backleft = scripted_spawn2( instance + "_backleft", "targetname", true );
	backleft.animname = "human";
	backleft.cartag = "tag_guy1";
	
	backright = scripted_spawn2( instance + "_backright", "targetname", true );
	backright.animname = "human";
	backright.cartag = "tag_guy0";

	car anim_first_frame_solo( driver, "carjack_driver", "tag_detach" );
	car anim_first_frame_solo( frontright, "carjack_frontright", "tag_detach" );
	car anim_first_frame_solo( backright, "carjack_backright", "tag_detach" );
	car anim_reach_solo( backleft, "carjack_backleft", "tag_detach" );

	if ( isdefined( pausetime ) )
		wait pausetime;
	
	driver thread carjacker( car, "carjack_driver", "cardriver_idle" );
	frontright thread carjacker( car, "carjack_frontright", "carpassenger_idle" );
	backright thread carjacker( car, "carjack_backright", "carpassenger_idle" );
	
	car thread anim_single_solo( victim, "carjack_victim", "tag_detach" );
	car thread anim_single_solo( car, "carjack_driver_door" );

	driver waittillmatch( "single anim", "start_others" );
	backleft thread carjacker( car, "carjack_backleft", "carpassenger_idle" );
	car thread anim_single_solo( car, "carjack_others_door" );

/*	node = getent( instance + "_fenceclimb_node", "targetname" );

	civilian = scripted_spawn2( instance + "_fenceclimb_civilian", "targetname", true );
	civilian.animname = "human";
	civilian.disableExits = true;
	civilian set_run_anim( "run_panicked2", true );

	if ( isdefined( pausetime ) )
		wait pausetime;

	node anim_reach_solo( civilian, "wall_climb" );
	node thread anim_single_solo( civilian, "wall_climb" );
	
	goal = getent( civilian.target, "targetname" );
	civilian thread maps\_spawner::go_to_origin( goal );*/
}

carjacker( car, guy_anime, guy_idle )
{
	car anim_single_solo( self, guy_anime, "tag_detach" );

	/*if(isdefined(self.cartag))
	{
		self linkto( car );
		car thread anim_loop_solo( self, guy_idle, self.cartag, "stop_idle", car );
	}*/
}

fenceclimb( instance, pausetime, duration )
{
	node = getent( instance + "_fenceclimb_node", "targetname" );

	civilian = scripted_spawn2( instance + "_fenceclimb_civilian", "targetname", true );
	civilian.animname = "human";
	civilian.disableExits = true;
	civilian set_run_anim( "run_panicked2", true );

	if ( isdefined( pausetime ) )
		wait pausetime;

	node anim_reach_solo( civilian, "wall_climb" );
	node thread anim_single_solo( civilian, "wall_climb" );
	
	goal = getent( civilian.target, "targetname" );
	civilian thread maps\_spawner::go_to_origin( goal );
	
	DeleteEntity( node );
	civilian thread DeleteOnGoal();
}

fencedog( instance, pausetime, duration )
{
	node = getent( instance + "_fencedog_node", "targetname" );

	dog = scripted_spawn2( instance + "_fencedog_dog", "targetname", true );
	dog.animname = "dog";

	if ( isdefined( pausetime ) )
		wait pausetime;

	node anim_reach_solo( dog, "fence_attack" );
	node thread anim_single_solo( dog, "fence_attack" );
	
	delaythread( duration, ::DeleteEntity, node );
	delaythread( duration, ::DeleteEntity, dog );
}

setupTarget()
{
	if ( !isdefined( level.aim_count ) )
	{
		level.aim_count = 1;
		thread syncAiming();
	}
	else
		level.aim_count++ ;

	if ( !isdefined( level.firenode_count ) )
	{
		level.firenode_count = 1;
		thread syncFireNodes();
	}
	else
		level.firenode_count++ ;

	self.interval = 0;
	self.goalradius = 8;
	self.disableArrivals = true;
	self.disableExits = true;
	self set_generic_run_anim( "patrol_walk", true );
	self.walk_combatanim = level.scr_anim[ "generic" ][ "patrol_walk" ];
	self.walk_noncombatanim = level.scr_anim[ "generic" ][ "patrol_walk" ];
	
	civilian = scripted_spawn2( self.target, "targetname", true );
	civilian.animname = "human";
	civilian.allowdeath = true;
	civilian.dieQuietly = true;
	civilian gun_remove();
	civilian thread anim_loop_solo( civilian, "cowerstand_pointidle" );
	civilian thread dropdead();

	target = getent( civilian.target, "targetname" );
	position = target.origin;

	//wait 4;
	wait RandomFloat( 1 );
	node = getnode( self.target, "targetname" );
	while ( 1 )
	{
		self setGoalNode( node );
		self waittill( "goal" );
		if ( !isdefined( node.target ) )
			break;
		node = getnode( node.target, "targetname" );
	}
	self orientMode( "face angle", node.angles[1] );
	level.firenode_count-- ;
	level.aim_count-- ;

	flag_wait( "firingsquad_atnodes" );
	flag_wait( "firingsquad_aiming" );

	wait 3;
	wait RandomFloat( .75 );

	for ( i = 0; i < 20; i++ )
	{
		self thread animscripts\utility::shootPosWrapper( position );
		wait 0.1;
	}
}

syncAiming()
{
	while ( level.aim_count )
		wait 0.5;

	flag_set( "firingsquad_aiming" );
	println( "All guards finished aiming" );
}

syncFireNodes()
{
	while ( level.firenode_count )
		wait 0.5;
	
	flag_set( "firingsquad_atnodes" );
	println( "All guards reached firing nodes" );
}

passenger_event()
{
	self waittill( "trigger" );

	if( isdefined(self.script_noteworthy) && isdefined( level.passenger_events[self.script_noteworthy] ) )
	{
		if( isdefined( level.passenger_events[self.script_noteworthy].animation ) )
		{
			anime = level.passenger_events[self.script_noteworthy].animation.anime;
			animdelay = level.passenger_events[self.script_noteworthy].animation.delay;

			if( isdefined( animdelay ) )
				level delaythread( animdelay, ::animthread, anime );
			else
				thread animthread( anime );
		}
		
		if( isdefined( level.passenger_events[self.script_noteworthy].dialog ) )
		{
			soundalias = level.passenger_events[self.script_noteworthy].dialog.soundalias;
			sounddelay = level.passenger_events[self.script_noteworthy].dialog.delay;
			
			if( isdefined( sounddelay ) )
				level delaythread( sounddelay, ::dialogthread, soundalias );
			else
				thread dialogthread( soundalias );
		}
	}
}

animthread( anime )
{
	level.car.passenger StopAnimScripted();
	level.car maps\coup_anim::playPassengerAnim( anime ); // change so this thread doesn't append a suffix
	level.car maps\coup_anim::loopPassengerAnim( "carpassenger_idle" ); // change so this thread doesn't append a suffix
}

dialogthread( soundalias )
{
	level.car.passenger playsound( soundalias );
}

loudspeaker_event()
{
	self waittill( "trigger" );

	if( !isdefined(self.target) )
		return;
		
	loudspeaker = getent( self.target, "targetname" );
	
	if( isdefined(loudspeaker.script_noteworthy) )
		loudspeaker playsound( loudspeaker.script_noteworthy ); // on loudspeaker
}

crowdmember_setuptriggers()
{
	triggers = get_linked_ents();
	// threads multiple crowdmember_triggerevent calls passing in a trigger to each one
	array_levelthread( triggers, ::crowdmember_triggerevent );
	
	if( !isdefined(self.target) )
		return;

	duration = self.script_duration;
	if(!isdefined(duration))
		duration = 10;

	status = self.script_noteworthy;
	if(!isdefined(status))
		status = "jeer";
	
	crowdmembers = getentarray( self.target, "targetname" );
	array_thread( crowdmembers, ::crowdmember_status, status, duration );
}

crowdmember_triggerevent( trigger )
{
	trigger waittill( "trigger" );

	duration = trigger.script_duration;
	if(!isdefined(duration))
		duration = 3;

	status = trigger.script_noteworthy;
	if(!isdefined(status))
		status = "idle";
		
	oldstatus = self.crowdstatus;
	self.crowdstatus = status;
	
	wait duration;
	self.crowdstatus = oldstatus;
}

crowdmember_status( status, duration )
{
	oldstatus = self.crowdstatus;
	self.crowdstatus = status;
	
	wait duration;
	self.crowdstatus = oldstatus;
}

ending_shadowchange()
{
	SetSavedDvar( "sm_sunSampleSizeNear", "0.0625" );

	wait 8;
	thread lerpShadowDetail( 0.25, 1 );
}

ending_speech()
{
	level.player delaythread( 13.25, ::playspeech, "coup_kaa_laywaste", "Just as they lay waste to our country, we shall lay waste to theirs." );
	level.player delaythread( 27.6, ::playspeech, "coup_kaa_beginsa", "This is how it begins." );
}

ending_dofchange()
{
	setDOF( 0, 1, 5, 250, 800, 4, 10 );
	// println( "250, 800 over 10 seconds finished" );
	wait 8;
	// println( "wait 8 seconds finished" );
	setDOF( 0, 1, 5, 50, 315, 4, 3 );
	// println( "50, 315 over 3 seconds finished" );
}

ending_slowmo()
{
	wait 30.25;

	thread ending_heartbeat();
	
	slowmo_start();

		time = 3.5;
		timein = 1;
		speed = 0.45;
		timeout = 0.5;
	
		printslowmo( "lerping to walk speed" );
		slowmo_setspeed_slow( speed );
		slowmo_setlerptime_in( timein );
		
		slowmo_lerp_in();
		wait time;
		printslowmo( "walk time finished" );
	
		slowmo_setlerptime_out( timeout );
		slowmo_setspeed_norm( 1 );
		
		slowmo_lerp_out();
		printslowmo( "resuming normal speed" );
	
	slowmo_end();
}

ending_heartbeat()
{
	level endon( "player_death" );

	wait 1.3;
	level.player thread play_sound_on_entity( "coup_breathing_heartbeat" );
	wait 0.05;
	level.player PlayRumbleOnEntity( "damage_light" );

	wait 0.95;
	level.player thread play_sound_on_entity( "coup_breathing_heartbeat" );
	wait 0.05;
	level.player PlayRumbleOnEntity( "damage_light" );

	wait 1.1;
	level.player thread play_sound_on_entity( "coup_breathing_heartbeat" );
	wait 0.05;
	level.player PlayRumbleOnEntity( "damage_light" );
}

initCredits()
{
	level.namelist = [];
	addName( &"CREDIT_ROGER_ABRAHAMSSON_CAPS" );
	addName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
	addName( &"CREDIT_TODD_ALDERMAN_CAPS" );
	addName( &"CREDIT_BRAD_ALLEN_CAPS" );
	addName( &"CREDIT_CHRISSY_ARYA_CAPS" );
	addName( &"CREDIT_RICHARD_BAKER_CAPS" );
	addName( &"CREDIT_CHAD_BARB_CAPS" );
	addName( &"CREDIT_ALESSANDRO_BARTOLUCCI_CAPS" );
	addName( &"CREDIT_KEITH_BELL_CAPS" );
	addName( &"CREDIT_PETE_BLUMEL_CAPS" );
	addName( &"CREDIT_MICHAEL_BOON_CAPS" );
	addName( &"CREDIT_ROBERT_BOWLING_CAPS" );
	addName( &"CREDIT_PETER_CHEN_CAPS" );
	addName( &"CREDIT_CHRIS_CHERUBINI_CAPS" );
	addName( &"CREDIT_GRANT_COLLIER_CAPS" );
	addName( &"CREDIT_KRISTIN_COTTERELL_CAPS" );
	addName( &"CREDIT_JON_DAVIS_CAPS" );
	addName( &"CREDIT_DERRIC_EADY_CAPS" );
	addName( &"CREDIT_JOEL_EMSLIE_CAPS" );
	addName( &"CREDIT_ROBERT_FIELD_CAPS" );
	addName( &"CREDIT_STEVE_FUKUDA_CAPS" );
	addName( &"CREDIT_ROBERT_GAINES_CAPS" );
	addName( &"CREDIT_MARK_GANUS_CAPS" );
	addName( &"CREDIT_FRANCESCO_GIGLIOTTI_CAPS" );
	addName( &"CREDIT_CHANCE_GLASCO_CAPS" );
	addName( &"CREDIT_PRESTON_GLENN_CAPS" );
	addName( &"CREDIT_JOEL_GOMPERT_CAPS" );
	addName( &"CREDIT_CHAD_GRENIER_CAPS" );
	addName( &"CREDIT_MARK_GRIGSBY_CAPS" );
	addName( &"CREDIT_JOHN_HAGGERTY_CAPS" );
	addName( &"CREDIT_EARL_HAMMON_JR_CAPS" );
	addName( &"CREDIT_JEFF_HEATH_CAPS" );
	addName( &"CREDIT_NEEL_KAR_CAPS" );
	addName( &"CREDIT_JAKE_KEATING_CAPS" );
	addName( &"CREDIT_RICHARD_KRIEGLER_CAPS" );
	addName( &"CREDIT_BRYAN_KUHN_CAPS" );
	addName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
	addName( &"CREDIT_OSCAR_LOPEZ_CAPS" );
	addName( &"CREDIT_CHENG_LOR_CAPS" );
	addName( &"CREDIT_HERBERT_LOWIS_CAPS" );
	addName( &"CREDIT_JULIAN_LUO_CAPS" );
	addName( &"CREDIT_STEVE_MASSEY_CAPS" );
	addName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
	addName( &"CREDIT_DREW_MCCOY_CAPS" );
	addName( &"CREDIT_BRENT_MCLEOD_CAPS" );
	addName( &"CREDIT_PAUL_MESSERLY_CAPS" );
	addName( &"CREDIT_STEPHEN_MILLER_CAPS" );
	addName( &"CREDIT_TAEHOON_OH_CAPS" );
	addName( &"CREDIT_SAMI_ONUR_CAPS" );
	addName( &"CREDIT_VELINDA_PELAYO_CAPS" );
	addName( &"CREDIT_ERIC_PIERCE_CAPS" );
	addName( &"CREDIT_JON_PORTER_CAPS" );
	addName( &"CREDIT_ZIED_RIEKE_CAPS" );
	addName( &"CREDIT_LINDA_ROSEMEIER_CAPS" );
	addName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
	addName( &"CREDIT_MARK_RUBIN_CAPS" );
	addName( &"CREDIT_EMILY_RULE_CAPS" );
	addName( &"CREDIT_NICOLE_SCATES_CAPS" );
	addName( &"CREDIT_ALEXANDER_SHARRIGAN_CAPS" );
	addName( &"CREDIT_JON_SHIRING_CAPS" );
	addName( &"CREDIT_NATHAN_SILVERS_CAPS" );
	addName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
	addName( &"CREDIT_RICHARD_SMITH_CAPS" );
	addName( &"CREDIT_JIESANG_SONG_CAPS" );
	addName( &"CREDIT_THEERAPOL_SRISUPHAN_CAPS" );
	addName( &"CREDIT_TODD_SUE_CAPS" );
	addName( &"CREDIT_SOMPOOM_TANGCHUPONG_CAPS" );
	addName( &"CREDIT_JANICE_TURNER_CAPS" );
	addName( &"CREDIT_RAYME_VINSON_CAPS" );
	addName( &"CREDIT_ZACH_VOLKER_CAPS" );
	addName( &"CREDIT_ANDREW_WANG_CAPS" );
	addName( &"CREDIT_JASON_WEST_CAPS" );
	addName( &"CREDIT_LEI_YANG_CAPS" );
	addName( &"CREDIT_VINCE_ZAMPELLA_CAPS" );

	level.namesize = 1.5;
	level.credits = spawnstruct();

	pagesideindex = 0;
	pageside[0] = "left";
	pageside[1] = "right";
	xoffset[0] = 64;
	xoffset[1] = -64;

	namedirectionindex = 0;
	namedirection[0] = "left";
	namedirection[1] = "right";

	pagechangecounter = 0;
	page = undefined;
	for ( nameindex = 0; nameindex < level.namelist.size; nameindex++ )
	{
		if ( pagechangecounter == 0 )
			page = createPage( pageside[pagesideindex], xoffset[pagesideindex], 340 );

		page addCredit( level.namelist[ nameindex ], namedirection[namedirectionindex] );
		
		if ( namedirectionindex )
			namedirectionindex = 0;
		else
			namedirectionindex = 1;

		if ( pagechangecounter >= 2 )
		{
			level.credits addPage( page );
			pagechangecounter = 0;
			
			if ( pagesideindex )
				pagesideindex = 0;
			else
				pagesideindex = 1;
		}
		else
			pagechangecounter++;
	}
	
	if ( pagechangecounter ) // if page change counter isn't 0, we have a partial page to add
		level.credits addPage( page );
}

addName( name )
{
	precacheString( name );
	level.namelist[ level.namelist.size ] = name;
}

createPage( alignment, x, y )
{
	page = spawnstruct();
	page.alignment = alignment;
	page.x = x;
	page.y = y;	
	
	return page;
}

addPage( page )
{
	if ( !isdefined( self.pages ) )
	{	
		self.pages = [];
		self.pages[ 0 ] = page;
	}
	else
		self.pages[ self.pages.size ] = page;
}

addCredit( name, direction )
{
	if ( !isdefined( self.names ) )
		self.names = [];
	
	credit = spawnstruct();
	credit.name = name;
	credit.direction = direction;
	
	self.names[ self.names.size ] = credit;
}

playCredits()
{
	level waittill( "continue_credits" );
	wait 1;
	thread displayPage( level.credits.pages[ 0 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 1 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 2 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 3 ] );

	level waittill( "continue_credits" );
	wait 1;
	thread displayPage( level.credits.pages[ 4 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 5 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 6 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 7 ] );
	
	level waittill( "continue_credits" );
	wait 1;
	thread displayPage( level.credits.pages[ 8 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 9 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 10 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 11 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 12 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 13 ] );
	wait 5.25;

	level waittill( "continue_credits" );
	wait 1;
	thread displayPage( level.credits.pages[ 14 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 15 ] );

	level waittill( "continue_credits" );
	wait 1;
	thread displayPage( level.credits.pages[ 16 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 17 ] );
	
	level waittill( "continue_credits" );
	wait 1;
	thread displayPage( level.credits.pages[ 18 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 19 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 20 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 21 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 22 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 23 ] );
	wait 5.25;
	thread displayPage( level.credits.pages[ 24 ] );
	
	/*for ( i = 0; i < level.credits.pages.size; i++ )
	{
		displayPage( level.credits.pages[ i ] );
		wait 1.9;
	}*/
}

displayPage( page )
{
	names = undefined;
	
	if ( isdefined( page.names ) )
	{
		for ( i = 0; i < page.names.size; i++ )
		{
			names[ i ] = newHudElem();

			assert( page.alignment == "left" || page.alignment == "right" );
			names[ i ].alignX = page.alignment;
			names[ i ].horzAlign = page.alignment;

			if ( page.alignment == "left" )
				names[ i ].x = page.x + ( i * 46 );
			else if ( page.alignment == "right" )
				names[ i ].x = page.x + ( i * 46 ) - 138;
			
			names[ i ].y = page.y + ( i * 16 );
			names[ i ] setText( page.names[ i ].name );
			names[ i ].font = "objective";
			names[ i ].fontScale = level.namesize;
			names[ i ].sort = 2;
			names[ i ].glowColor = ( 0.7, 0.7, 0.3 );
			names[ i ].glowAlpha = 1;
			names[ i ] SetPulseFX( 40, 4500, 600 );

			if ( page.names[ i ].direction == "left" )
			{
				names[ i ] moveOverTime( 5 );
				names[ i ].x = names[ i ].x - 12;
			}
			else if ( page.names[ i ].direction == "right" )
			{
				names[ i ] moveOverTime( 5 );
				names[ i ].x = names[ i ].x + 12;
			}
			
			wait 0.6;
		}
	}

	wait 4.5;

	if ( isdefined( names ) )
	{
		for ( i = 0; i < names.size; i++ )
			names[ i ] destroy();	
	}
}

openIntroDoors()
{
	flag_set( "doors_open" );
	
	thread openIntroLeftDoor();
	thread openIntroRightDoor();
}

openIntroLeftDoor()
{
	intro_leftdoor = getent( "intro_leftdoor", "targetname" );

	time = 1;
	intro_leftdoor rotateyaw( 180, time, ( time * 0.5 ), ( time * 0 ) );
	intro_leftdoor waittill( "rotatedone" );	
	
	time = 1;
	intro_leftdoor rotateyaw( -60, time, ( time * 0 ), ( time * 1 ) );
}

openIntroRightDoor()
{
	intro_rightdoor = getent( "intro_rightdoor", "targetname" );
	
	time = 1;
	intro_rightdoor rotateyaw( -180, time, ( time * 0.5 ), ( time * 0 ) );
	intro_rightdoor waittill( "rotatedone" );	

	time = 1;
	intro_rightdoor rotateyaw( 60, time, ( time * 0 ), ( time * 1 ) );
}

removeDroneWeapon()
{
	size = self getattachsize();
	for ( i = 0;i < size;i++ )
	{
		tag = self getattachtagname( i );

		if ( tag == "tag_weapon_right" )
		{
			model = self getattachmodelname( i );
			self Detach( model, tag );
		}
	}
}

setWeapon( weapon )
{
	self animscripts\shared::placeWeaponOn( self.weapon, weapon );
}

setTeam( team )
{
	self.team = team;
}

setSightDist( value )
{
	self.maxsightdstsqrd = value;
}

setRandomRun( array )
{
	self set_run_anim( array[ RandomInt( array.size ) ], true );
}

kickdoor( node, door )
{
	self waittillmatch( "single anim", "kick" );
	node thread anim_single_solo( door, "doorkick" );
	door playsound( "wood_door_kick" );
}

// fix distance between kick animation and actual door
doorkick( leftguard, rightguard, pausetime, duration, runtoposition )
{
	leftguard.animname = "human";
	rightguard.animname = "human";

	// rotate the offset for the door positioning to match the angles the scene is placed at
	x = 0;
	y = 0;
	c = cos( self.angles[ 1 ] );
	s = sin( self.angles[ 1 ] );
	new_x = c * x - s * y;
	new_y = s * x + c * y;
	door_originmod = ( new_x, new_y, 0 );
	door_anglesmod = ( 0, -90, 0 );
	
	door_node = spawn( "script_origin", self.origin + door_originmod );
	door_node.angles = self.angles + door_anglesmod;
	door = spawn_anim_model( "door" );
	door.origin = door_node.origin;
	door.angles = door_node.angles;

	door_node thread anim_first_frame_solo( door, "doorkick" );
	
	if ( isdefined( runtoposition ) )
	{
		self thread anim_reach_solo( leftguard, "doorkick_left_idle" );
		self anim_reach_solo( rightguard, "doorkick_right_idle" );
	}
	self thread anim_first_frame_solo( leftguard, "doorkick_left_idle" );
	self thread anim_first_frame_solo( rightguard, "doorkick_right_idle" );

 	// self thread maps\_debug::drawOrgForever( ( 1, 0, 0 ) );
 	// door_node thread maps\_debug::drawOrgForever( ( 0, 1, 0 ) );
 	// door thread maps\_debug::drawOrgForever( ( 0, 0, 1 ) );

	if ( isdefined( pausetime ) )
		wait pausetime;
	
	leftguard thread kickdoor( door_node, door );
	self thread anim_single_solo( rightguard, "doorkick_right_stepout_runin" );
	self anim_single_solo( leftguard, "doorkick_left_stepout" );
	self anim_single_solo( leftguard, "doorkick_left_runin" );

	delaythread( duration, ::DeleteEntity, door_node );
	delaythread( duration, ::DeleteEntity, door );
	delaythread( duration, ::DeleteEntity, leftguard );
	delaythread( duration, ::DeleteEntity, rightguard );
}

// pausetime not used until first frame of animations are in the correct positions
ziptie( instance, pausetime, duration )
{
	node = getent( instance + "_node", "targetname" );

	guard = scripted_spawn2( instance + "_guard", "targetname", true );
	guard.animname = "human";

	civilian = scripted_spawn2( instance + "_civilian", "targetname", true );
	civilian.animname = "human";

	node thread anim_first_frame_solo( guard, "ziptie_guard" );
	node thread anim_first_frame_solo( civilian, "ziptie_civilian" );
	
	if ( isdefined( pausetime ) )
		wait pausetime;

	delaythread( duration, ::DeleteEntity, node );
	delaythread( duration, ::DeleteEntity, guard );
	delaythread( duration, ::DeleteEntity, civilian );
		
	node thread anim_single_solo( guard, "ziptie_guard" );
	node anim_single_solo( civilian, "ziptie_civilian" );
	node anim_loop_solo( civilian, "ziptie_civilian_idle" );
}

ziptied( civilian, duration )
{
	civilian.animname = "human";
	civilian removeDroneWeapon();
	
	node = getent( civilian.target, "targetname" );
	node thread anim_loop_solo( civilian, "ziptie_civilian_idle" );
	
	delaythread( duration, ::DeleteEntity, civilian );
	delaythread( duration, ::DeleteEntity, node );
}

gunpoint_stand( guard, civilian, duration )
{
	guard.animname = "human";
	civilian.animname = "human";

	guard thread anim_loop_solo( guard, "aim_straight" );
	civilian thread anim_loop_solo( civilian, "cowerstand_pointidle" );

	delaythread( duration, ::DeleteEntity, guard );
	delaythread( duration, ::DeleteEntity, civilian );
}

gunpoint_crouch( guard, civilian, duration )
{
	guard.animname = "human";
	civilian.animname = "human";

	guard thread anim_loop_solo( guard, "aim_straight" );
	civilian thread anim_loop_solo( civilian, "cowercrouch_idle" );

	delaythread( duration, ::DeleteEntity, guard );
	delaythread( duration, ::DeleteEntity, civilian );
}

garage( operator, runner, door, pausetime )
{
	operator.animname = "human";

	runner.animname = "human";
	runner.disableExits = true;

	runanims[ 0 ] = "run_panicked1";
	runanims[ 1 ] = "run_panicked2";
	runner setRandomRun( runanims );
	
	nodeoffset = AnglesToForward( self.angles ) * - 22;
	self.origin = self.origin + nodeoffset;
	door.origin = door.origin + ( 0, 0, 51.013 );

	self anim_first_frame_solo( operator, "close_garage_a" );// needed?
	self anim_reach_solo( runner, "runinto_garage_right" );
	
	self thread anim_single_solo( operator, "close_garage_a" );
	self thread anim_single_solo( runner, "runinto_garage_right" );
	wait 1;
	
	door linkto( operator, "TAG_WEAPON_CHEST" );
	operator waittillmatch( "single anim", "end" );
	door unlink();
	operator delete();
	runner delete();
}

windowshout( civilian )
{
	civilian.animname = "human";
	civilian removeDroneWeapon();
	civilian thread anim_single_solo( civilian, "window_shout_a" );

	delaythread( 20, ::DeleteEntity, civilian );
}

leaningguard( guard )
{
	guard.animname = "leaning_guard";

	// loop
	guard thread anim_loop_solo( guard, "leaning_smoking_idle" );
	// guard thread anim_single_solo( guard, "window_shout_a" );

	delaythread( 20, ::DeleteEntity, guard );
}

attackside( attacker, duration )
{
	node = spawn( "script_origin", self.origin );
	node.angles = self.angles;	

	attacker.animname = "human";
	self.animname = "human";
	attacker.favoriteenemy = self;

	// node anim_reach_solo( attacker, "attack_side" );
	node thread anim_single_solo( attacker, "sneakattack_attack_side" );	
	node thread anim_single_solo( self, "sneakattack_defend_side" );	

	delaythread( duration, ::DeleteEntity, attacker );
}

attackbehind( attacker, duration )
{
	node = spawn( "script_origin", self.origin );
	node.angles = self.angles;	

	attacker.animname = "human";
	self.animname = "human";
	attacker.favoriteenemy = self;

	node anim_reach_solo( attacker, "sneakattack_attack_behind" );
	node thread anim_single_solo( attacker, "sneakattack_attack_behind" );	
	node thread anim_single_solo( self, "sneakattack_defend_behind" );	

	delaythread( duration, ::DeleteEntity, attacker );
}

celebrate()
{
	self endon( "death" );
	
	crowdmember[ "up" ][ "idle" ] = "crowdmember_gunup_idle";
	crowdmember[ "up" ][ "jeer" ] = "crowdmember_gunup_idle"; // no non-firing jeers
	crowdmember[ "up" ][ "fire" ][ 0 ] = "crowdmember_gunup_fire";

	crowdmember[ "down" ][ "idle" ] = "crowdmember_gundown_idle";
	crowdmember[ "down" ][ "jeer" ] = "crowdmember_gundown_jeer";
	crowdmember[ "down" ][ "fire" ][ 0 ] = "crowdmember_gundown_fire_a";
	crowdmember[ "down" ][ "fire" ][ 1 ] = "crowdmember_gundown_fire_b";

	gunpositions[ 0 ] = "up";
	gunpositions[ 1 ] = "down";
	gunposition = gunpositions[ RandomInt( gunpositions.size ) ];
	
	self.crowdanims_starting = true;
	self.crowdstatus = "idle";
	crowdanim = undefined;

	for( ;; )
	{
		if( self.crowdstatus == "fire" )
			crowdanim = crowdmember[ gunposition ][ "fire" ][ RandomInt( crowdmember[ gunposition ][ "fire" ].size ) ];
		else
			crowdanim = crowdmember[ gunposition ][ self.crowdstatus ];
		
		if( isdefined(self.crowdanims_starting) )
		{
			anime = self getanim( crowdanim );
			starttime = RandomFloatRange( 0, 1.0 );
			self thread DelaySetAnimTime( anime, starttime, 0.05 );
			
			self.crowdanims_starting = undefined;
		}

		self anim_single_solo( self, crowdanim );
		self anim_single_solo( self, crowdmember[ gunposition ][ "idle" ] );
	}
}

DelaySetAnimTime( anime, starttime, delay )
{
	wait delay;
	self SetAnimTime( anime, starttime );
}

music_start()
{
	MusicPlayWrapper( "music_coup_intro" );
}

music_end()
{
	MusicStop();
	MusicPlayWrapper( "coup_b_section_music" );
}

drive_carsounds()
{
	level.car delaythread ( 25, ::playCarSound, "scn_coup_car_move1" );
	level.car delaythread ( 48, ::playCarSound, "scn_coup_car_move2" );
	level.car delaythread ( 122, ::playCarSound, "scn_coup_car_move3" );
	level.car delaythread ( 164, ::playCarSound, "scn_coup_car_move4" );
}

playCarSound( alias )
{
	self thread play_sound_on_entity( alias );
	//println( " --- CARSOUNDS: " + alias );
}

addPassengerEvent( eventname, eventtype, alias, delay )
{
	if( !isdefined( level.passenger_events ) )
		level.passenger_events = [];
	
	if( !isdefined( level.passenger_events[ eventname ] ) )
		level.passenger_events[ eventname ] = spawnstruct();
	
	if( eventtype == "animation" )
	{
		animation = spawnstruct();
		animation.anime = alias;
		animation.delay = delay;
	
		level.passenger_events[ eventname ].animation = animation;
	}
	else if( eventtype == "dialog" )
	{
		dialog = spawnstruct();
		dialog.soundalias = alias;
		dialog.delay = delay;
	
		level.passenger_events[ eventname ].dialog = dialog;
	}
}

RemoveWeapon()
{
	if( IsAI( self ) )
		self gun_remove();
	else
	{
		size = self getattachsize();
	
		for ( i = 0; i < size; i++ )
		{
			model = self getattachmodelname( i );
			
			if( model == self.weapon )
				self detach( model );
		}
	}
}


initSubtitles()
{
	precacheString( &"COUP_SUBTITLE_01A" );
	precacheString( &"COUP_SUBTITLE_01B" );
	precacheString( &"COUP_SUBTITLE_02A" );
	precacheString( &"COUP_SUBTITLE_02B" );
	precacheString( &"COUP_SUBTITLE_03A" );
	precacheString( &"COUP_SUBTITLE_03B" );
	precacheString( &"COUP_SUBTITLE_04" );
	precacheString( &"COUP_SUBTITLE_05A" );
	precacheString( &"COUP_SUBTITLE_05B" );
	precacheString( &"COUP_SUBTITLE_06A" );
	precacheString( &"COUP_SUBTITLE_06B" );
	precacheString( &"COUP_SUBTITLE_07" );
	precacheString( &"COUP_SUBTITLE_08A" );
	precacheString( &"COUP_SUBTITLE_08B" );
	precacheString( &"COUP_SUBTITLE_09" );
	precacheString( &"COUP_SUBTITLE_10" );
	precacheString( &"COUP_SUBTITLE_11" );
}

SubtitleSequence()
{
	delaythread ( 5.5, ::Subtitle, &"COUP_SUBTITLE_01A", &"COUP_SUBTITLE_01B", 7.75 );
	delaythread ( 36.35, ::Subtitle, &"COUP_SUBTITLE_02A", &"COUP_SUBTITLE_02B", 7.75, true );
	delaythread ( 67.15, ::Subtitle, &"COUP_SUBTITLE_03A", &"COUP_SUBTITLE_03B", 9.95, true );
	delaythread ( 100.1, ::Subtitle, &"COUP_SUBTITLE_04", undefined, 5.75, true );
	delaythread ( 141, ::Subtitle, &"COUP_SUBTITLE_05A", &"COUP_SUBTITLE_05B", 13.55 );
	delaythread ( 155, ::Subtitle, &"COUP_SUBTITLE_06A", &"COUP_SUBTITLE_06B", 7.9, true );
	delaythread ( 177.2, ::Subtitle, &"COUP_SUBTITLE_07", undefined, 4.35 );
	delaythread ( 183, ::Subtitle, &"COUP_SUBTITLE_08A", &"COUP_SUBTITLE_08B", 9.95, true );
	delaythread ( 205.8, ::Subtitle, &"COUP_SUBTITLE_09", undefined, 4.4 );
	delaythread ( 253.05, ::Subtitle, &"COUP_SUBTITLE_10", undefined, 7.9 );
	delaythread ( 267.3, ::Subtitle, &"COUP_SUBTITLE_11", undefined, 2.95 );
}

Subtitle( text, text2, duration, donotify )
{
	subtitle = newHudElem();
	subtitle.x = 0;
	subtitle.y = -42;
	subtitle settext( text );
	subtitle.fontScale = 1.46;
	subtitle.alignX = "center";
	subtitle.alignY = "middle";
	subtitle.horzAlign = "center";
	subtitle.vertAlign = "bottom";
	subtitle.sort = 1;

	subtitle2 = undefined;
	
	if( isdefined( text2 ) )
	{
		subtitle2 = newHudElem();
		subtitle2.x = 0;
		subtitle2.y = -24;
		subtitle2 settext( text2 );
		subtitle2.fontScale = 1.46;
		subtitle2.alignX = "center";
		subtitle2.alignY = "middle";
		subtitle2.horzAlign = "center";
		subtitle2.vertAlign = "bottom";
		subtitle2.sort = 1;
	}
	
	wait duration;
	subtitle destroy();
	
	if( isdefined( subtitle2 ) )
		subtitle2 destroy();
	
	if( isdefined( donotify ) )
		level notify( "continue_credits" );
}