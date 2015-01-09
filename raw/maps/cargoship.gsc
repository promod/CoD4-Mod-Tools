#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\mo_tools;
#include maps\cargoship_code;
#include maps\_hud_util;

main()
{
	level.fogvalue["near"] = 100;
	level.fogvalue["half"] = 15000;	
/*
	level.fogvalue["r"] = 20/256;
	level.fogvalue["g"] = 30/256; 
	level.fogvalue["b"] = 38/256;
*/	
	level.fogvalue["r"] = 0/256;
	level.fogvalue["g"] = 0/256; 
	level.fogvalue["b"] = 0/256;
	setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 0.1);
	
	level.fogvalue["near"] = 100;
	level.fogvalue["half"] = 4000;	
	setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 20);
	
	add_start( "bridge", maps\cargoship::misc_dummy, &"STARTS_BRIDGE" );	
	add_start( "deck", maps\cargoship::misc_dummy, &"STARTS_DECK" );
	add_start( "hallways", maps\cargoship::misc_dummy, &"STARTS_HALLWAYS" );
	add_start( "cargohold", maps\cargoship::misc_dummy, &"STARTS_CARGOHOLD" );
	add_start( "cargohold2", maps\cargoship::misc_dummy, &"STARTS_CARGOHOLD2" );
	add_start( "laststand", maps\cargoship::misc_dummy, &"STARTS_LASTSTAND" );
	add_start( "package", maps\cargoship::misc_dummy, &"STARTS_PACKAGE" );
	add_start( "escape", maps\cargoship::misc_dummy, &"STARTS_ESCAPE" );
	add_start( "end", maps\cargoship::misc_dummy, &"STARTS_END" );
	
	flag_init("at_bridge");
	flag_init("bridge_landing");
	flag_init("bridgefight");
	
	flag_init( "sweet_dreams" );
	
	flag_init("quarters");
	flag_init("quarters_drunk_spawned");
	flag_init("quarters_drunk_ready");
	flag_init("price_at_top_of_stairs");
	flag_init("quarters_price_says_clear");
	flag_init("quarters_sleepers_dead");
	
	flag_init("deck_heli");
	flag_init("walk_deck");
	flag_init("deck_enemies_spawned");
	flag_init("deck_windows");
	flag_init("windows_got_company_line_before");
	flag_init("windows_got_company_line");
	flag_init("heli_shoot_deck_windows");
	
	flag_init("hallways");
	flag_init("hallways_lower_runners1");
	flag_init("hallways_lower_runners2");
	flag_init("hallways_lowerhall_guys");
	flag_init("hallways_moveup");
	
	flag_init("cargoholds_1_enter_clear");
	flag_init("pulp_fiction_guy");
	
	flag_init("cargoholds2");
	flag_init("cargoholds2_breach");	
	flag_init("cargohold2_enemies");
	flag_init("cargohold2_enemies2");
	flag_init("cargohold2_enemies_dead");
	
	flag_init("laststand");
	flag_init("laststand_3left");
	
	flag_init("package");
	flag_init("package_enter");
	flag_init("package_report");
	flag_init("package_reading");
	flag_init("found_package");
	flag_init("package_orders");
	flag_init("package_secure");
	flag_init("package_open_doors");
	flag_init( "strong_reading" );
	
	flag_init("escape");
	flag_init("escape_cargohold2_fx");
	flag_init("start_sinking_boat");
	flag_init("escape_explosion");
	flag_init("escape_get_to_catwalks");
	
	flag_init("escape_death_cargohold2");
	flag_init("escape_death_cargohold1");
	flag_init("escape_death_hallways_lower");
	flag_init("escape_death_hallways_upper");
	flag_init("escape_death_deck");
	flag_init("escape_player_rescue");
	
	flag_init( "escape_seaknight_ready" );
	flag_init( "cargoship_end_music" );
	
	flag_init( "end_start_player_anim" );
	flag_init( "end_linked_player_to_rig" );
	flag_init( "end_seaknight_leaving" );
	flag_init( "end_price_rescue_anim" );
	flag_init( "end_no_jump" );
	flag_init( "end_finished" );
	flag_init( "end_screen_done" );
	flag_init( "gotcha" );
	
	flag_init( "player_rescued" );
	flag_init( "nothing" );
	
	flag_init("topside_fx");
	flag_set("topside_fx");
	flag_init("cargohold_fx");
	flag_init("heroes_ready");
	
	flag_init( "nade_hint" );
	flag_init( "crouch_hint" );
	flag_init( "stand_hint" );	
	
	flag_init( "music_tension_notime" );
	
	setsaveddvar( "compassmaxrange", 1500 );
	
	level.missionFailedQuote = [];
	level.missionFailedQuote["slow"] = &"CARGOSHIP_YOU_WERENT_FAST_ENOUGH";
	level.missionFailedQuote["wrongway"] = &"CARGOSHIP_YOU_WENT_THE_WRONG_WAY";
	level.missionFailedQuote["jump1"] = &"CARGOSHIP_NOBODY_MAKES_THEIR_FIRST";
	level.missionFailedQuote["jump2"] = &"CARGOSHIP_NOBODY_MAKES_THEIR_SECOND";
	level.missionFailedQuote["jump3"] = &"CARGOSHIP_NOBODY_MAKES_THEIR_THIRD";
	level.missionFailedQuote["jump"] = &"CARGOSHIP_NOBODY_MAKES_THEIR_JUMP";
	
	level.missionFailedQuote["escape"] = level.missionFailedQuote["slow"];
	
	keys = getarraykeys(level.missionFailedQuote);
	for ( i = 0; i < keys.size; i++ )
		precachestring(level.missionFailedQuote[keys[i]]);
		
	precachestring( &"CARGOSHIP_INFINITY_WARD_PRESENTS" );	
		
	//maps\createart\cargoship_art::main();
	level.start_point = "default";
	jumptoInit();
	
	maps\_seaknight::main( "vehicle_ch46e_opened_door_interior" );
	maps\_blackhawk::main( "vehicle_blackhawk_hero_sas_night" );
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_mp5_clip";
	level.weaponClipModels[1] = "weapon_m16_clip";
	level.weaponClipModels[2] = "weapon_ak47_clip";
	level.weaponClipModels[3] = "weapon_ak74u_clip";

	maps\cargoship_fx::main();
	maps\createfx\cargoship_audio::main();

	thread maps\_pipes::main();
	thread maps\_leak::main();
	//maps\scriptgen\cargoship_scriptgen::main();
	
	maps\createart\cargoship_art::main();
	maps\createfx\cargoship_fx::main();
	maps\_load::main();
	
	maps\cargoship_anim::main();
	maps\_compass::setupMiniMap( "compass_map_cargoship" );
	maps\mo_globals::main("cargoship");
	water_stuff_for_art1();
	maps\_sea::main();
	maps\mo_fastrope::main();
	level thread maps\cargoship_amb::main();
		
	array_thread( getentarray("stairs","targetname"), ::stairs );
	
	set_console_status();

	setsaveddvar("sm_sunSampleSizeNear", ".5");
	setSavedDvar("r_specularColorScale", "3");
	
	misc_precacheInit();
	misc_setup();		
	create_mantle();
	thread initial_setup();
	thread objective_main();
	thread jumptoThink();

	thread water_stuff_for_art2( 2 );
	switch(level.jumptosection)
	{
		case "bridge":		bridge_main();
		case "deck":		deck_main();
		case "hallways":	hallways_main();
		case "cargohold":	cargohold_main();
		case "cargohold2":	thread cargohold2_main();
		case "laststand":	laststand_main();
		case "package":		package_main();
		case "escape":		escape_main();
	}
}

#using_animtree("generic_human");
initial_setup()
{
	temp = getentarray("intro_spawners", "target");
	name = temp[0].targetname;
	level.heli = level.fastrope_globals.helicopters[maps\mo_fastrope::fastrope_heliname(name)];	
	
	level.heli initial_setup_vehicle_override();
	//level.heli maps\mo_fastrope::fastrope_ropeanimload(%bh_rope_idle_cargoship_begin_ri, %bh_rope_drop_cargoship_begin_ri, "right", %cargoship_opening_fastrope_80ft);
	level.heli maps\mo_fastrope::fastrope_ropeanimload(undefined, undefined, "right", %cargoship_opening_fastrope_80ft);
	level.heli maps\mo_fastrope::fastrope_ropeanimload(%bh_rope_idle_le, %bh_rope_drop_le, "left");
	if(level.jumpto != "start")
	{
		setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], .1);//40
		level.heli maps\mo_fastrope::fastrope_override(1, undefined, %cs_bh_1_idle_start, %cs_bh_1_drop);
		level.heli maps\mo_fastrope::fastrope_override(2, undefined, %cs_bh_2_idle_start, %cs_bh_2_drop);	
	}
	else
	{
		setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 40);//40
		level.heli maps\mo_fastrope::fastrope_override(1, %cargoship_opening_position1);
		level.heli maps\mo_fastrope::fastrope_override(2, %cargoship_opening_price);
	}
	level.heli maps\mo_fastrope::fastrope_override(4, undefined, %bh_idle_start_guy2, %bh_4_drop);
	level.heli maps\mo_fastrope::fastrope_override(5, undefined, undefined, %bh_5_drop);
	level.heli maps\mo_fastrope::fastrope_override(6, undefined, %bh_idle_start_guy1, %bh_6_drop);
	
	level.heli maps\mo_fastrope::fastrope_override(9, undefined, %bh_crew_idle_guy1);
	level.heli maps\mo_fastrope::fastrope_override(10, undefined, %bh_crew_idle_guy2);
	
	
	trig =  getent("intro_spawners","targetname");
	trig notify ("trigger");	
	wait .1;
	level notify("level heli ready");
	
	level.heli.model heli_minigun_attach("left");
	
	ai = getaiarray("allies");
	
	level.heroes7 = [];
	level.heroes5 = [];
	level.heroes3 = [];
	
	for(i=0; i<ai.size; i++)
	{
		switch( ai[i].seat_pos )
		{
			case 1:{	level.heroes7["alavi"] 		= ai[i];  }break;
			case 2:{  	level.heroes7["price"] 		= ai[i];  }break;
			case 4:{ 	level.heroes7["grigsby"]	= ai[i];  }break;
			case 9:{  	level.heroes7["pilot"] 		= ai[i];  }break;
			case 10:{  	level.heroes7["copilot"]	= ai[i];  }break;
			case 5:{	level.heroes7["seat5"]		= ai[i];  }break;
			case 6:{	level.heroes7["seat6"]		= ai[i];  }break;
		}
	}
	
	level.heroes7["copilot"]	gun_remove();
	level.heroes7["copilot"] 	disable_ai_color();
	level.heroes7["pilot"]		gun_remove();
	level.heroes7["pilot"] 		disable_ai_color();
	
	level.heroes5["alavi"] 		= level.heroes7["alavi"];
	level.heroes5["price"] 		= level.heroes7["price"];
	level.heroes5["grigsby"] 	= level.heroes7["grigsby"];
	level.heroes5["seat5"] 		= level.heroes7["seat5"];
	level.heroes5["seat6"] 		= level.heroes7["seat6"];
	
	level.heroes3["alavi"] 		= level.heroes5["alavi"];
	level.heroes3["price"] 		= level.heroes5["price"];
	level.heroes3["grigsby"] 	= level.heroes5["grigsby"];
	
	createthreatbiasgroup( "price" );
	createthreatbiasgroup( "alavi" );
	createthreatbiasgroup( "grigsby" );
	createthreatbiasgroup( "seat5" );
	createthreatbiasgroup( "seat6" );
	createthreatbiasgroup( "player" );	
	
	level.heroes5["price"].cgo_old_accuracy 	= level.heroes5["price"].accuracy;
	level.heroes5["price"].cgo_old_baseaccuracy	= level.heroes5["price"].baseAccuracy;
	level.heroes5["price"].accuracy = 1000;
	level.heroes5["price"].baseAccuracy = 1000;
	level.heroes5["price"].fixednode = false;
	level.heroes5["price"].script_noteworthy = "price";
	level.heroes5["price"] setthreatbiasgroup( "price" );
	level.heroes5["price"].grenadeammo = 0;
	level.heroes5["price"].ignoresuppression = true;	
	level.heroes5["price"] setFlashBangImmunity( true );
	
	level.heroes5["alavi"].cgo_old_accuracy 	= level.heroes5["alavi"].accuracy;
	level.heroes5["alavi"].cgo_old_baseaccuracy	= level.heroes5["alavi"].baseAccuracy;
	level.heroes5["alavi"].accuracy = 1000;
	level.heroes5["alavi"].baseAccuracy = 1000;
	level.heroes5["alavi"].fixednode = false;
	level.heroes5["alavi"].script_noteworthy = "alavi";
	level.heroes5["alavi"] setthreatbiasgroup( "alavi" );
	level.heroes5["alavi"].grenadeammo = 0;
	level.heroes5["alavi"].ignoresuppression = true;
	level.heroes5["alavi"] setFlashBangImmunity( true );
	
	level.heroes5["grigsby"].cgo_old_accuracy 		= level.heroes5["grigsby"].accuracy;
	level.heroes5["grigsby"].cgo_old_baseaccuracy	= level.heroes5["grigsby"].baseAccuracy;
	level.heroes5["grigsby"].accuracy = 1000;
	level.heroes5["grigsby"].baseAccuracy = 1000;
	level.heroes5["grigsby"].fixednode = false;
	level.heroes5["grigsby"].script_noteworthy = "grigsby";
	level.heroes5["grigsby"] setthreatbiasgroup( "grigsby" );
	level.heroes5["grigsby"].grenadeammo = 0;
	level.heroes5["grigsby"].ignoresuppression = true;
	level.heroes5["grigsby"] setFlashBangImmunity( true );
	
	level.heroes5["seat5"].accuracy = 1000;
	level.heroes5["seat5"].baseAccuracy = 1000;
	level.heroes5["seat5"].fixednode = false;
	level.heroes5["seat5"].script_noteworthy = "seat5";
	level.heroes5["seat5"] setthreatbiasgroup( "seat5" );
	level.heroes5["seat5"].grenadeammo = 0;
	level.heroes5["seat5"].ignoresuppression = true;
	level.heroes5["seat5"] disable_ai_color();
	level.heroes5["seat5"] setFlashBangImmunity( true );	
	level.heroes5["seat5"].name = "Sgt. Wallcroft";	
	
	level.heroes5["seat6"].accuracy = 1000;
	level.heroes5["seat6"].baseAccuracy = 1000;
	level.heroes5["seat6"].fixednode = false;
	level.heroes5["seat6"].script_noteworthy = "seat6";
	level.heroes5["seat6"] setthreatbiasgroup( "seat6" );
	level.heroes5["seat6"].grenadeammo = 0;
	level.heroes5["seat6"].ignoresuppression = true;
	level.heroes5["seat6"] disable_ai_color();
	level.heroes5["seat6"] setFlashBangImmunity( true );
	//level.heroes5["seat6"].name = "Pvt. Griffen";	
	thread intro_movie_hack();
	
	level.player.script_noteworthy = "player";
	level.player setthreatbiasgroup( "player" );
	
	flag_set("heroes_ready");
}

intro_movie_hack()
{
	level.heroes5["seat6"].name = "";
	level waittill( "intro_movie_done" );
	level.heroes5["seat6"].name = "Pvt. Griffen";	
}

#using_animtree("vehicles");
initial_setup_vehicle_override()
{
	node = getstruct("intro_ride_node","targetname");
	self maps\mo_fastrope::fastrope_override_vehicle(%bh_cargo_path, node);
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	BRIDGE LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

bridge_main()
{
	switch(level.jumpto)
	{
		case "start":{
			MusicPlayWrapper("cargoship_intro_music"); 
			//level thread maps\_introscreen::introscreen_delay(level.strings["intro1"], level.strings["intro2"], level.strings["intro3"], level.strings["intro4"], 2, 2, 1);
			
			setsaveddvar("ai_friendlyFireBlockDuration", 250);
			
			thread bridge_intro();
			thread bridge_intro_thunder();
			thread bridge_heroes();
			thread bridge_heli_1();
			}
		case "bridge":{
			thread bridge_setup();								
			thread bridge_heli_2();
			thread bridge_standoff();
			}
		case "quarters":{
			flag_wait("quarters");
			flag_set("_sea_waves");
			thread quarters_sleeping();
			thread quarters_dialogue();
			thread quarters_player_speed();
			quarters();
			}
	}
}

bridge_intro_thunder()
{
	thread maps\cargoship_fx::normal();
	wait 5;
	thread maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	wait 10;
	thread maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	wait 4;
	maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	wait 1;
	maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	wait .5;
	maps\_weather::lightningFlash( maps\cargoship_fx::normal, maps\cargoship_fx::flash );
}

bridge_intro()
{	
	thread intro_heli_rain_fx();
	level._sea_scale = 2;
	//setsaveddvar("sm_sunSampleSizeNear", ".25");	
	wait 10;
	//setsaveddvar("sm_sunSampleSizeNear", "1.25");
	//setsaveddvar("sm_sunSampleSizeNear", ".5");
	wait 12;
	
	level._sea_scale = 1.5;
	wait 4;
	flag_clear("_sea_bob");
	wait 12;
	flag_set("_sea_viewbob");
	flag_set("_sea_bob");
	//setsaveddvar("sm_sunSampleSizeNear", ".75");
}

intro_heli_rain_fx()
{
	flag_wait( "heroes_ready" );
	heli = level.heli.model;
		
	playfxontag (level._effect["rain_heavy_mist_heli_hack"], heli, "tag_deathfx");
}

bridge_setup()
{
	trig = [];
	trig[trig.size] = getent("stair_bottom_save","script_noteworthy");
	trig = array_combine(trig, getentarray("bridge_flags","script_noteworthy") );
	array_thread(trig, ::trigger_off);	
	
	level waittill("level heli ready");
	
	thread battleChatter_Off();
	
	ai = getaiarray("allies");
	for(i=0; i<ai.size; i++)
	{
		if( isdefined( ai[i].spawner.nounload ) && ai[i].spawner.nounload == true )
			continue;
		node = getnode( ( "seat" + ai[i].seat_pos ), "targetname" );
		ai[i] setgoalnode( node );
		ai[i].goalradius = 32;
		ai[i].ignoresuppression = true;
		ai[i].suppressionwait = 0;
	}
				
	level.heli.vehicle waittill("reached_wait_node");
	flag_set("at_bridge");
	thread maps\cargoship_fx::flash(2, 4, 2, 3, ( -25, -160, 0 ) );
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	level.player thread play_sound_on_entity ("elm_thunder_strike");
	
	wait 4.5;
	thread maps\cargoship_fx::flash(3, 4, 2, 3, ( -25, -110, 0 ) );
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	level.player thread play_sound_on_entity ("elm_thunder_strike");
}

bridge_heli_1()
{
	level waittill("level heli ready");
		
	fxmodel = spawn("script_model", level.heli.model gettagorigin( "main_rotor_jnt" ) );
	fxmodel setmodel(level.heli.modelname);
	fxmodel.angles = level.heli.model.angles;
	fxmodel linkto(level.heli.model);
	fxmodel hide();
	fxmodel setcontents(0);
	fxmodel thread maps\mo_fastrope::fastrope_heli_playExteriorLightFX();
	fxmodel maps\mo_fastrope::fastrope_heli_playInteriorLightFX();
	//fxmodel maps\mo_fastrope::fastrope_heli_playInteriorLightFX2();
		
	level waittill("going_dark");
	wait 1;
	
	wait .5;
	fxmodel delete();
	wait 1.5;
	
	level.heli.vehicle waittill("reached_wait_node");
	wait 5;
}

bridge_heli_2()
{	
	level waittill("level heli ready");

	if(level.jumpto == "start")
	{	
		wait 29;
		level.heli.vehicle notify("fake_wait_node");
	}	
	level.heli.model thread maps\mo_fastrope::fastrope_heli_playExteriorLightFX();
	level.heli.model maps\mo_fastrope::fastrope_heli_playInteriorLightFX2();
	if(level.jumpto == "start")
		level.heli maps\mo_fastrope::fastrope_heli_overtake();
	else
		level waittill("bridge_jumpto_done");
		
	thread bridge_heli_3();
	
	wait 1;
		
	level.heli.model heli_searchlight_on();
	
	target = spawn("script_origin", (3184, 152, 364) );
	target.targetname = "bridge_fake_spottarget";
	level.heli.model thread heli_searchlight_target("targetname", "bridge_fake_spottarget");	
		
	wait 4;
	target moveto( (2896, -232, 364), 4, 1, 1);
}

bridge_heli_3()
{
	level endon("price_wait_at_stairs");
			
	level.heli.vehicle sethoverparams( 32, 10, 3 );
	level.heli.vehicle clearlookatent();
	
	node = getstruct("heli_bridge_node","targetname");
	level.heli.vehicle setspeed( 15, 10, 10 );
	level.heli.vehicle setLookAtEnt( level.heroes5["price"] );
	
	heli_flypath(node);
}

grigs_clip_handoff( guy2 )
{
	self attach( "weapon_mp5_clip", "tag_inhand" );
	self waittillmatch( "single anim", "clip delete" );
	self detach( "weapon_mp5_clip", "tag_inhand" );
	
	guy2 attach( "weapon_mp5_clip", "tag_inhand" );
	wait 2;
	guy2 detach( "weapon_mp5_clip", "tag_inhand" );
}

bridge_heroes()
{			
	flag_wait("heroes_ready");
	
	cigar = spawn("script_model", level.heroes5["price"] gettagorigin("tag_inhand") );
	cigar.angles = level.heroes5["price"] gettagangles("tag_inhand");
	cigar linkto(level.heroes5["price"], "tag_inhand");
	cigar setmodel("prop_price_cigar");
	playfxontag (level._effect["cigar_glow"], cigar, "tag_cigarglow");
	level.heroes5["price"] thread priceCigarPuffFX(cigar);
	level.heroes5["price"] thread priceCigarExhaleFX(cigar);
	cigar thread priceCigarDelete();
	
	level.heroes5[ "grigsby" ] thread grigs_clip_handoff( level.heroes7["seat6"] );
	
	wait 1;
	//base plate this is hammer two four, we have visual on the target, eta 60 seconds
	radio_msg_stack("cargoship_hp1_baseplatehammertwo");
	//copy two four
	radio_msg_stack("cargoship_hqr_copytwofour");
		
	wait 5;	
	level notify("going_dark");
	//30 seconds, going dark
	radio_msg_stack("cargoship_hp1_thirtysecdark");
	
	wait 8;
	//ten secounds
	radio_msg_stack("cargoship_hp1_tensecondsradio");
	
	wait 1;
	//radio check, going to secure channel
	thread radio_msg_stack("cargoship_hp1_radiocheck");
	
	wait 1;
	autosave_by_name("fastrope");
	wait 1;
	thread PlayerMaskPuton();
			
	wait 1.7;
	//lock and load
	thread radio_msg_stack("cargoship_pri_crewexpend");
		
	level.heli.vehicle waittill("reached_wait_node");
	
	//green light, go go go
	thread radio_msg_stack("cargoship_hp1_greenlightgoradio");
}

bridge_standoff()
{
	trig1 = getent("bridge_standoff_guys","target");
	start = getent("start_bridge_standoff", "targetname");
	damage = getent("bridge_damage_trig","targetname");
	damage thread bridge_standoff_damage();

	array_thread( getentarray( "bridge_standoff_guys","targetname" ), ::add_spawn_function, ::bridge_standoff_behavior);
	level.enemies = [];
	trig1 notify("trigger");
	
	start waittill("trigger");
	flag_set("bridge_landing");
	setsaveddvar("sm_sunSampleSizeNear", ".25");
	wait .1;
	//bridge secure
	thread ai_clear_dialog(undefined, undefined, undefined, level.player, "cargoship_gm1_bridgesecure");
	
	damage wait_for_trigger_or_timeout(.75);
	//weapons free
	delayThread(1.25, ::radio_msg_stack, "cargoship_pri_weaponsfree" );
	
	level.enemies[ "bridge_capt" ] notify("bridge_react");
	wait .5;
	level.enemies[ "bridge_clipboard" ] notify("bridge_react");
	wait .25;
	wait .85;//.6
	level.enemies[ "bridge_tv" ] notify("bridge_react");
	wait .45;//.2
	level.enemies[ "bridge_stand1" ] notify("bridge_react");
	
	//flag_set("bridgefight");
	level waittill("ai_clear_dialog_done");
	flag_set("quarters");
}

bridge_standoff_damage()
{
	while(1)
	{
		self waittill( "trigger", other);
		if( other == level.player )
			break;
	}
	flag_set("bridgefight");
}

#using_animtree( "chair" );
bridge_standoff_chair(node)
{
	chair = spawn("script_model", node.origin);
	chair setmodel("com_restaurantchair_2");
	chair.animname = "chair";
	chair UseAnimTree(#animtree);
	
	node thread anim_loop_solo(chair, "start", undefined, "stoploop");
	 
	self waittill_either( "damage", "already_dying" );
	
	node notify("stoploop");
	self thread bridge_standoff_mug();
	//self.mug physicslaunch( self.mug.origin + (1,1,2), (60, 60, 600) );
	
	node anim_single_solo(chair, "fall"); 
	node thread anim_loop_solo(chair, "end");
}

bridge_standoff_mug()
{
	wait .15;
	
	if ( !isdefined(self) )
		return;

	playfx( level._effect["coffee_mug"], self gettagorigin("tag_inhand") );
	self detach("cs_coffeemug01", "tag_inhand" );
}

bridge_standoff_behavior()
{
	node = getnode(self.target, "targetname");
		
	self.animname = self.script_noteworthy;
	self.deathanim = level.scr_anim[self.animname]["death"];
	level.enemies[ self.script_noteworthy ] = self;
	self.grenadeAmmo = 0;
	chair = undefined;
	
	if(self.animname == "bridge_stand1")
		node = getent(self.target, "targetname");
			
	node thread anim_loop_solo(self, "idle", undefined, "stoploop");
	
	if(self.animname == "bridge_capt")
	{
		self thread bridge_standoff_chair(node);
		self attach("cs_coffeemug01", "tag_inhand", true );
	}
	self thread ignoreAllEnemies( true );
	self gun_remove();
	
	self thread bridge_standoff_behavior_earlydeath(node);
	
	self endon ("death_by_player");
	self waittill("bridge_react");
				
	length = getanimlength( level.scr_anim[self.animname]["react"] );
	delay = length - .5;
	switch( self.animname )
	{
		case "bridge_clipboard":
			node thread notify_delay("stoploop", .25);
			node delayThread( .25, ::anim_single_solo, self, "react");
			break;
		default:
			node notify("stoploop");
			node thread anim_single_solo(self, "react");
			break;
	}
	switch( self.animname )
	{
		case "bridge_capt":
			self delayThread(1.5, ::play_sound_on_entity, "cargoship_rus_huh2");
			break;
	}	
	wait delay;	
	
	switch( self.animname )
	{
		case "bridge_capt":
			level.heroes5[ "alavi" ] thread execute_ai_solo( self, 0.1, 6, true );
			wait .5;
			//self.ignoreme = false;
			break;	
		case "bridge_tv":
			level.heroes5[ "alavi" ] thread execute_ai_solo( self, 0, 6, true );
			wait .5;
			//self.ignoreme = false;
			break;	
		case "bridge_stand1":
			wait .25;
			level.heroes5[ "price" ] thread execute_ai_solo( self, 0.1, 6, true );
			level.heroes5[ "alavi" ] delayThread(.25, ::execute_ai_solo, self, 0, 6, true );
			//self.ignoreme = false;
			wait .25;
			break;	
		case "bridge_clipboard":
			level.heroes5[ "price" ] thread execute_ai_solo( self, 0, 6, true );
			//self.ignoreme = false;
			wait .75;
			break;	
	}
	
	self notify("already_dying");
	self stopanimscripted();
	self dodamage(self.health + 300, self.origin);
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), node.origin );
}

bridge_standoff_behavior_earlydeath(node)
{
	self endon("already_dying");
	self.health = 10000;
	while(1)
	{
		self waittill( "damage", damage, other);
		if( other == level.player )
			break;			
	}
	self.allowdeath = true;
	
	self notify ("death_by_player");

	self stopanimscripted();
	self dodamage(self.health + 300, self.origin);
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), node.origin );
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	QUARTERS LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

quarters_sleeping()
{
	org = getentarray("sleeping_nodes","targetname");
	spawners = getentarray("quarters_sleepers", "targetname");
	guys = []; 
	for(i=0; i<org.size; i++)
	{
		guys[i] = spawners[i] stalingradspawn();
		spawn_failed(guys[i]);
		guys[i].animname = ( "sleeper_" + i );
		guys[i].ignoreme = true;
		guys[i].grenadeAmmo = 0;
		org[i] thread anim_loop_solo(guys[i], "sleep", undefined, "stop_sleeping");
		guys[i] thread quarters_sleeping_death(org[i]);
		guys[i] thread quarters_sleeping_player();
	}
	
	if( flag( "deck_drop" ) )
		return;
	level endon( "deck_drop" );
	
	waittill_dead(guys);  
	flag_set("quarters_sleepers_dead");	
	flag_set("deck");
	
	if( randomint( 100 ) > 50 )
		radio_dialogue("cargoship_sas4_sweetdreams");
	else
		radio_dialogue("cargoship_sas4_sleeptight");
	
	flag_set( "sweet_dreams" );
}

quarters_sleeping_player()
{
	level endon("deck");
	self endon( "death" );
	while(1)
	{
		if(self cansee(level.player) )
			break;
		wait .1;	
	}	
	wait 1;
	flag_set("deck");
}

#using_animtree("generic_human");
quarters_sleeping_death(node)
{
	self gun_remove();
	self thread ignoreAllEnemies( true );
	
	self waittill("damage", damage, other, dir, p, type );
	
	level notify("sleeping_guys_wake");
	self notify("death", other, type );	
	thread play_sound_in_space("generic_pain_russian_" + randomintrange(1,8), self.origin );
	
	if( isdefined( level.cheatStates ) && isdefined( level.cheatStates[ "sf_use_tire_explosion" ] ) && level.cheatStates[ "sf_use_tire_explosion" ] == true )
		return;
	
	waittillframeend;
	model = spawn("script_model", self.origin);
	model.angles = self.angles;
	model setmodel(self.model);
	
	numAttached = self getattachsize();
	for(i=0; i<numAttached; i++)
	{
		modelname 	= self getattachmodelname(i);
		tagname 	= self getattachtagname(i);
		model attach(modelname, tagname, true);
	}
	
	model.animname = self.animname;
	model UseAnimTree(#animtree);
	node thread anim_single_solo(model, "death");
	waittillframeend;

	if ( isdefined( self ) )
		self delete();
}

quarters_dialogue()
{
	wait 1;
	//griggs, stay in the bird till we secure the deck, over
	radio_dialogue("cargoship_pri_holdyourfire");
	//roger that
	radio_dialogue("cargoship_grg_rogerthat");
}

quarters_heli()
{	
	level endon("deck");
	level endon("deck_heli");
	
	flag_wait("price_wait_at_stairs");
	
	node = getstruct( "heli_deck_landing_node", "targetname" );	
	ang = node.angles[1];	
	
	level.heli.vehicle setspeed( 20, 10, 10 );
	level.heli.vehicle sethoverparams( 32, 10, 3 );
	level.heli.vehicle clearlookatent();
	level.heli.vehicle cleargoalyaw();	
	node = getstruct( "heli_quarters_node", "targetname" );
	
	level.heli.vehicle setvehgoalpos( node.origin, 1 );
	
	level.heli.vehicle setgoalyaw(ang);
	level.heli.vehicle settargetyaw(ang);
	
	while( isdefined(node) )
	{
		stop = false;
		if(!isdefined(node.target))
			stop = true;
		level.heli.vehicle setvehgoalpos( node.origin + (0,0,150), stop );
		level.heli.vehicle setNearGoalNotifyDist( 150 );
		level.heli.vehicle waittill( "near_goal" );
		
		if( isdefined(node.target) )
			node = getstruct( node.target, "targetname" );
		else
			node = undefined;			
	}
	flag_set( "deck_heli" );
}

quarters_redlightatstairs()
{
	org = spawn("script_model", (2811, -346, 299));
	org setmodel("tag_origin");
	org hide();
	playfxontag( level._effect[ "aircraft_light_cockpit_red" ], org, "tag_origin" );

	flag_wait("deck");
	
	org delete();
}

quarters()
{
	thread quarters_redlightatstairs();
	
	thread quarters_heli();
	
	trig = [];
	trig = array_combine(trig, getentarray("bridge_flags","script_noteworthy") );
	array_thread(trig, ::trigger_on);
	
	level.heroes5[ "price" ] pushplayer(true);
	level.heroes5[ "price" ].animname = "price";
	level.heroes5[ "price" ].animplaybackrate = 1.0816;
	level.heroes5[ "price" ].moveplaybackrate = 1.0816;	
	
	level.heroes5[ "alavi" ] pushplayer(true);
	level.heroes5[ "alavi" ].animname = "alavi";
	level.heroes5[ "alavi" ].animplaybackrate = 1.0816;
	level.heroes5[ "alavi" ].moveplaybackrate = 1.0816;
		
	rnode = getnode("bridge_door_open","targetname");
	node1 = spawn( "script_origin", rnode.origin + ( -20, -13, 0 ));
	node1.angles = rnode.angles;
	
	node2 = spawn( "script_origin", node1.origin);
	node2.angles = node1.angles + (0,-15,0);
	guys = [];
	guys[ guys.size ] = level.heroes5[ "price" ];
	guys[ guys.size ] = level.heroes5[ "alavi" ];
	
	msg1 = "quarters_alavi_doorbreach";
	msg2 = "quarters_price_doorbreach";
	flag_init( msg1 );
	flag_init( msg2 );
	
	node2 thread cargoship_hack_animreach( level.heroes5[ "alavi" ], "door_breach_setup", "door_breach_setup_idle", "stop_loop", msg1 );
	node1 thread cargoship_hack_animreach( level.heroes5[ "price" ], "door_breach_setup", "door_breach_setup_idle", "stop_loop", msg2 );
	
	flag_wait_all( msg1, msg2 );
	//node2 thread anim_reach_and_idle_solo( level.heroes5[ "alavi" ], "door_breach_setup", "door_breach_setup_idle", "stop_loop" );
	//node1 anim_reach_and_idle_solo( level.heroes5[ "price" ], "door_breach_setup", "door_breach_setup_idle", "stop_loop" );
	
	node1 notify( "stop_loop" );
	node2 notify( "stop_loop" );
	node1 thread anim_single_solo( level.heroes5[ "price" ], "door_breach_setup");
	node2 anim_single_solo( level.heroes5[ "alavi" ], "door_breach_setup");
	
	node1 thread anim_single_solo( level.heroes5[ "price" ], "door_breach" );	
	node2 thread anim_single_solo( level.heroes5[ "alavi" ], "door_breach" );	
		
	level.heroes5[ "price" ] waittillmatch( "single anim", "kick" );
	door = getent( "bridge_door", "targetname" );
	clip = getent(door.target, "targetname");
	clip connectpaths();
	clip linkto( door );
	door door_opens();	
		
	level.heroes5[ "price" ] enable_cqbwalk_ign_demo_wrapper();
	level.heroes5[ "alavi" ] enable_cqbwalk_ign_demo_wrapper();
	
	wait 1;
	level.heroes5[ "alavi" ] stopanimscripted();
	level.heroes5[ "alavi" ] thread quarters_alavi();
	
	wait .25;
	level.heroes5[ "price" ] stopanimscripted();
	level.heroes5[ "price" ] thread quarters_price();
	
	node1 delete();
	node2 delete();
	
	flag_wait( "quarters_killem" );
	flag_clear("_sea_bob");
	getent("quarters_drunk","targetname") quarters_drunk();
}

quarters_player_speed()
{
	flag_wait("quarters_start");
	thread player_speed_set(137, 1);
	
	flag_wait("deck_drop");
	thread player_speed_reset(.5);
}

quarters_drunk()
{
	guy = self stalingradspawn();
	level.quartersdrunk = guy;
	spawn_failed( guy );
	guy.ignoreme = true;
	guy.grenadeAmmo = 0;
	level.player.ignoreme = true;
	guy thread ignoreAllEnemies( true );
	guy gun_remove();
	
	flag_set("quarters_drunk_spawned");
	guy.animname = "drunk";
	guy.deathanim = level.scr_anim[guy.animname]["death"];
	guy.health = 1;
	guy.maxhealth = 1;
	guy.allowdeath = true;
	
	node = getnode(self.target, "targetname");	
	
	guy attach( "cs_vodkabottle01", "tag_inhand", true );
	guy thread quarters_drunk_bottle();
	guy thread quarters_drunk_earlydeath(node);
	guy endon ("death_by_player");
	
	guy playsound("cargoship_rud_3sec");
	node thread anim_single_solo(guy, "walk");	
	
	guy.spinetarget = spawn("script_origin", guy gettagorigin("j_spine4") );
	guy.spinetarget linkto(guy, "j_spine4");
	
	level.heroes3["price"] cqb_aim( guy.spinetarget );
	level.heroes3["alavi"] cqb_aim( guy.spinetarget );
	
	length = getanimlength( level.scr_anim[guy.animname]["walk"] );
	
	wait 3;
	guy.ignoreme = false;
	flag_set("quarters_drunk_ready");

	wait .5;
						
	guy notify("already_dying");
	
	guy quarters_drunk_death( node );

/*	
	guy stopanimscripted();
	guy dodamage(guy.health + 300, guy.origin);
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), node.origin );
*/
}

quarters_drunk_bottle()
{
	self waittill( "damage" );
		
	forward = vectornormalize(level.player.origin -  self gettagorigin("tag_inhand") );
	playfx(level._effect["vodka_bottle"], self gettagorigin("tag_inhand"), forward);
	self detach( "cs_vodkabottle01", "tag_inhand" );
	play_sound_in_space("cgo_glass_bottle_break", self gettagorigin("tag_inhand") );
}

quarters_drunk_earlydeath(node)
{
	self endon("already_dying");
	self endon( "quarters_drunk_earlydeath2" );
	self thread quarters_drunk_earlydeath2( node );
	while(1)
	{
		self waittill( "damage", damage, other);
		if( other == level.player )
			break;
	}
	self notify( "quarters_drunk_earlydeath1" );
	self quarters_drunk_earlydeath_proc( node );
}

quarters_drunk_earlydeath2( node )
{
	self endon("already_dying");
	self endon( "quarters_drunk_earlydeath1" );
	
		self waittill( "death", other );
		if( other != level.player )
			return;
	
	self notify( "quarters_drunk_earlydeath2" );
	self quarters_drunk_earlydeath_proc( node );
}

quarters_drunk_earlydeath_proc( node )
{
	self notify ("death_by_player");
	flag_set("quarters_drunk_ready");
	self quarters_drunk_death( node, false );
}

quarters_drunk_death( node, fake )
{
	if( !isdefined( fake ) )
		fake = true;
		
	self stopanimscripted();
	if( fake )
		self dodamage(self.health + 300, self.origin);
	thread play_sound_in_space("generic_death_russian_" + randomintrange(1,8), node.origin );
}

quarters_price()
{
	//squad on me
	delaythread( .6, ::radio_dialogue, "cargoship_pri_squadonme");
	level notify("bridge_secured");
	
	node0 = getnode("quarters_price_0", "targetname");
	node1 = getnode("quarters_price_1", "targetname");
	node2 = getnode("quarters_price_2", "targetname");	
	
	self.ignoreme = true;
	self.ignoresuppression = true;
	
	if( !flag( "price_wait_at_stairs" ) )
	{
		self setgoalnode(node0);
		self.goalradius = node0.radius;
		self.disableExits = true;
		flag_wait( "price_wait_at_stairs" );
		//stairs clear
		thread radio_dialogue("cargoship_pri_stairsclear");
		wait .4;
	}
	
	thread quarters_price_safety();
	level endon("deck_drop");
	
	self setgoalnode(node1);
	self.goalradius = node1.radius;
	
	flag_wait("quarters_drunk_spawned");
	self.disableExits = false;
	self cqb_aim(level.quartersdrunk);
	flag_wait("quarters_drunk_ready");
	
	while( isalive( level.quartersdrunk ) )
	{
		shots = randomintrange(3,6);
		self burstshot(shots);
		wait .2;
	}
	
	self cqb_aim( undefined );
	
	//hallway clear
	wait .25;
	radio_dialogue( "cargoship_pri_lastcall" );
	thread radio_dialogue("cargoship_pri_hallwayclear");
	
	flag_set("quarters_price_says_clear");
	
	self handsignal("onme");
	self pushplayer(true);
	
	self setgoalnode(node2);
	self.goalradius = node2.radius;
}

quarters_price_safety()
{
	level endon( "quarters_price_says_clear" );
	flag_wait("deck_drop");
	thread flag_set("quarters_price_says_clear");
}

quarters_alavi_stairs()
{
	while(1)
	{
		self waittill("trigger", other);
		if(other == level.heroes5[ "price" ])
			break;
	}	
	
	flag_set("price_at_top_of_stairs");
}

quarters_alavi()
{	
	self ent_flag_init( "at_sleeper" );
	node0 = getnode("quarters_price_0", "targetname");
	node1 = getnode("quarters_alavi_1", "targetname");
	node2 = getnode("quarters_alavi_2", "targetname");
	
	self.ignoreme = true;
	self.ignoresuppression = true;
	
	getent("price_at_top_of_stairs","targetname") thread quarters_alavi_stairs();
	
	if( !flag( "price_at_top_of_stairs" ) )
	{
		self setgoalnode(node0);
		self.goalradius = node0.radius;
		flag_wait( "price_at_top_of_stairs" );
	}
			
	self setgoalnode(node1);
	self.goalradius = node1.radius;
	
	flag_wait("quarters_drunk_spawned");
	self cqb_aim(level.quartersdrunk);
	flag_wait("quarters_drunk_ready");
	
	wait .25;
	
	while( isalive( level.quartersdrunk ) )
	{
		shots = randomintrange(3,6);
		self burstshot(shots);
		wait .2;
	}
	
	level endon("deck_drop");
	
	if( !flag("deck") )
	{
		flag_wait("quarters_price_says_clear");
		wait .25;
	}
	self setgoalnode(node2);
	self.goalradius = node2.radius;
	
	self waittill( "goal" );
	self ent_flag_set( "at_sleeper" );
	ai = getaiarray("axis");
	self cqb_aim( ai[0] );
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 				  	DECK LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

deck_main()
{
	jumpto = level.jumpto;
	if(level.jumptosection != "deck")
		jumpto = "deck";	
	
	switch(jumpto)
	{
		case "deck":{
			thread deck_heli();
			flag_wait("deck");
			
			setsaveddvar("ai_friendlyFireBlockDuration", 2000);
			
			flag_set("deck_heli");
			
			thread deck_start();
			//thread deck_wave();
			array_thread( getentarray("aftdeck_level2_enemies","targetname"), ::add_spawn_function, ::deck_aftdeck_enemies);
			array_thread( getentarray("aftdeck_level3_runners","targetname"), ::add_spawn_function, ::deck_aftdeck_runners);
			array_thread( getentarray( "deck2_platform","targetname" ), ::add_spawn_function, ::deck_enemies_logic);
			deck_dialogue1();	
			flag_wait("windows_got_company_line_before");
			level.player.ignoreme = true;
			flag_wait("windows_got_company_line");
			wait 2;
			trig = getent("aftdeck_level3_runners", "target");
			trig notify("trigger");
			}	
	}
}

deck_wave()
{
	flag_wait("deck_wave");
	
	level._sea_org notify("manual_override");
	
	if(level._sea_org.sway == "sway1")
	{
		level._sea_org.sway = "sway2";
		level._sea_org notify("sway2");
		wait .05;
	}
	
	level._sea_org.time = 2.5;
	level._sea_org.acctime = .1;
	level._sea_org.dectime = .5;
	level._sea_org.rotation = (10,0,20);
	
	level._sea_org.sway = "sway1";
	level._sea_org notify("sway1");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	wait level._sea_org.time;
	
	
	level._sea_org.time = 1.5;
	level._sea_org.acctime = .5;
	level._sea_org.dectime = .25;
	level._sea_org.rotation = (-5,0,-5);
	
	level._sea_org.sway = "sway2";
	level._sea_org notify("sway2");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	wait level._sea_org.time;
	
	level._sea_org thread maps\_sea::sea_bob();	
}

deck_aftdeck_enemies()
{
	delaythread( 5, ::flag_set, "crouch_hint" );
	
	self endon("death");
	
	self.ignoreme = true;	
	self.ignoresuppression = true;
	if( !isdefined( level.aftdeck_enemies ) )
		level.aftdeck_enemies = [];
	
	level.aftdeck_enemies[ level.aftdeck_enemies.size ] = self;
	
	targetarray = getentarray("deck_window_targets1", "targetname");
	targetarray = array_combine( targetarray, getentarray( "deck_window_targets2", "targetname" ) );
	
	node = getnode(self.target, "targetname");
	if( !isdefined( node.target ) )
	{
		while(1)
		{
			wait .5;
			self setentitytarget(  random( targetarray ), .8 );
		}	
	}
}

deck_aftdeck_runners()
{
	self endon("death");
	self.animname = "sprinter";
	self.moveplaybackrate = 1.2;
	self set_run_anim( "sprint" );
	
	self waittill("goal");
	self delete();
}

deck_kill_off_sleepers()
{	
	level endon("deck_drop");//basically check to see if the helicopter is dropping guys...

	//if not - that means we hit this because the player went far enough for the sleepers
	//to "see" him, but not all the way out the door...so now lets wait for them to die
	if( !flag("quarters_sleepers_dead"))
	{
		level.heroes5["alavi"] ent_flag_wait( "at_sleeper" );
		level.heroes5["alavi"] execute_ai( getaiarray("axis"), .3, undefined, true, true );
	}
	wait .25;
	//Crew quarters clear. Move up.
	thread deck_kill_off_sleepers_dialogue();
}
deck_kill_off_sleepers_dialogue()
{
	level endon("deck_drop");
	flag_wait( "sweet_dreams" );
	thread radio_dialogue("cargoship_pri_crewquarters");
}

deck_start()
{
	level.heroes5["alavi"] disable_ai_color();
	level.heroes5["price"] pushplayer(true);
	level.heroes5["alavi"] pushplayer(false);
	level.heroes5["price"].ignoresuppression = false;
	level.heroes5["alavi"].ignoresuppression = false;
	level.heroes5["price"].ignoreme = false;
	level.heroes5["alavi"].ignoreme = false;
	level.heroes5["price"] disable_cqbwalk_ign_demo_wrapper();
	level.heroes5["alavi"] disable_cqbwalk_ign_demo_wrapper();
	
	if( level.jumpto != "deck" )
		deck_kill_off_sleepers();
	//if the helicopters already dropping guys, the player's left quarters...just screw the sleeping
	//guys and go...
	
	level.heroes5["alavi"] cqb_aim( undefined );
	
	temp = getallnodes();
	list = [];
	for(i=0; i<temp.size; i++)
	{
		if( issubstr( tolower( temp[i].type ), "cover" ) || issubstr( tolower( temp[i].type ), "guard" ))
			list[ list.size ] = temp[i];
	}	
	
	temp = getnodearray("decknodes", "targetname");
	nodes = [];
	for(i=0; i<temp.size; i++)
		nodes[ temp[i].script_noteworthy ] = temp[i];
	
	keys = getarraykeys(level.heroes5);
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		level.heroes5[ key ] thread deck_heroes( nodes[ key ], list );	
	}
	thread deck_heroes_holdtheline();
		
	flag_wait("moveup_deck1a");
	autosave_by_name("deck");
	thread player_speed_set(137, 2);
	
	flag_wait("deck_windows");
	autosave_by_name("aftdeck");
	thread player_speed_reset(1);
}

deck_dialogue1_kill()
{
	flag_wait("deck_enemies_spawned");
	wait .1;
	ai = getaiarray("axis");
	waittill_dead(ai);
	level notify("kill_deck_dialogue");	
}

deck_dialogue1()
{
	thread deck_dialogue1_kill();
	level endon("kill_deck_dialogue");
		
	flag_wait("moveup_deck1b");
	wait .5;
	//Got two on the platform.
	radio_dialogue("cargoship_grg_gottwo");
	//i see 'em
	radio_dialogue("cargoship_pri_iseeem");
	
	flag_wait("moveup_deck2a");
	//weapons free
	radio_dialogue("cargoship_pri_weaponsfree");
	//roger that
	radio_dialogue("cargoship_grg_rogerthat");
}

deck_heroes(node, list)
{
	self.goalradius = 64;
	self.ignoreme = false;
	self pushplayer( true );
	
	if( self.script_noteworthy == "grigsby" )
	{

		self waittillmatch("single_anim_done");
		self setgoalpos (self.origin);
		self.goalradius = 16;
				
		//Ready sir.
		thread radio_msg_stack("cargoship_grg_readysir");
			
		//self setanim(%crouch_2run_180, 1 );
		self.animname = "guy";
		temp = spawn("script_origin", self.origin);
		temp.angles = (0,0,0);
		temp thread anim_single_solo( self, "grigsturn" );
		wait (getanimlength( self getanim( "grigsturn" ) ) ) - .2;
		self stopanimscripted();
		temp.origin = self.origin;
		temp.angles = (0,180,0);
		temp thread anim_single_solo( self, "grigstop" );
				
		flag_set("_sea_bob");
		thread flag_set_delayed("walk_deck", 1.5);
		//Fan out. Three metre spread.
		thread radio_msg_stack("cargoship_pri_fanout");
		
		wait (getanimlength( self getanim( "grigstop" ) ) ) - .2;
		self stopanimscripted();
		self setgoalpos (self.origin);
		self.goalradius = 4;
		
		wait 1.5;
		
		temp.origin = self.origin;
		temp thread anim_single_solo( self, "grigsgo" );
		wait (getanimlength( self getanim( "grigsgo" ) ) ) - .2;
		self stopanimscripted();
		temp delete();
	}
	
	self setgoalnode( node );
	if( node.radius )
		self.goalradius = node.radius;
	else
		self.goalradius = 80;
	
	node = getnode(node.target, "targetname");
	
	self waittill("goal");
	flag_wait("walk_deck");
	
	self enable_cqbwalk_ign_demo_wrapper();
		
	while( isdefined( node.target ) )
	{
		self setgoalnode( node );
		
		if( node.radius )
			self.goalradius = node.radius;
		else
			self.goalradius = 80;
	
		self waittill("goal");
		
		struct = getstruct(node.targetname, "target");
		if( isdefined( struct ) )
		{
			trig = getent( struct.targetname, "target" );
			if( !flag( trig.script_flag ) )
			{
				if( node.radius )
				{
					self setgoalnode( getClosest(node.origin, list, node.radius) );	
					self.goalradius = 16;
				}
				flag_wait( trig.script_flag );
			}
		}
		
		node = getnode(node.target, "targetname");
	}
	
	flag_set("deck_windows");
	self setgoalnode( node );
	self.goalradius = 16;
	self disable_cqbwalk_ign_demo_wrapper();
	
	if( self.script_noteworthy != "price" )
		self pushplayer( false );
	self.oldsuppressionThresold = self.suppressionThresold;
	self.suppressionThresold = 0;
	self.ignoresuppression = false;
	
	if( self.script_noteworthy == "price" )
	{
		self waittill("goal");
		//Hammer two-four, we got tangos on the 2nd floor.
		flag_wait("windows_got_company_line");
		radio_dialogue("cargoship_pri_tangos2ndfl");
		flag_set("heli_shoot_deck_windows");
	}
	else if(! flag("windows_got_company_line_before") )
	{
		//We got company..
		flag_set("windows_got_company_line_before");
		radio_dialogue("cargoship_grg_gotcompany");
		flag_set("windows_got_company_line");
	}
}

deck_heli()
{
	flag_wait("deck_heli");
	
	spot = getstruct( "heli_deck_landing_node", "targetname" );	
	level.heli.vehicle setspeed( 40, 30, 20 );
	level.heli.vehicle sethoverparams( 0, 0, 0 );
		
	level.heli.vehicle setgoalyaw( spot.angles[1] );
	level.heli.vehicle settargetyaw( spot.angles[1] );
	level.heli.vehicle setvehgoalpos( spot.origin + (0,0,146), 1 );
	level.heli.vehicle setNearGoalNotifyDist( 32 );
	level.heli.vehicle waittill( "near_goal" );
		
	flag_wait("deck_drop");
	thread radio_dialogue("cargoship_hp1_forwarddeckradio");
	level.heli.model thread heli_searchlight_target("default");	
	level.heli notify("unload_rest");
	
	wait 2;
	maps\cargoship_fx::flash(3, 4, 2, 3);
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	level.player thread play_sound_on_entity ("elm_thunder_strike");	
	wait 1;
	maps\cargoship_fx::flash(3, 4, 2, 3);
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	level.player thread play_sound_on_entity ("elm_thunder_strike");
	wait 2;
	maps\cargoship_fx::flash(3, 4, 2, 3);
	level.player thread play_sound_on_entity ("elm_thunder_distant");
	
	wait 3.5;

	level.heli.vehicle setspeed( 15, 5, 5 );
	level.heli.vehicle sethoverparams( 32, 10, 3 );
	level.heli.vehicle clearlookatent();
	level.heli.vehicle cleargoalyaw();	
	level.heli.vehicle cleartargetyaw();	
	level.heli.vehicle setLookAtEnt( level.heroes5["price"] );
	
	flag_wait("moveup_deck1a");
	level.heli.model thread heli_searchlight_target( "aiarray", "allies" );
	thread heli_flypath(getstruct( "heli_deck_landing_node", "targetname" ));
	
	flag_wait("moveup_deck1b");
	thread heli_flypath(getstruct( "deck_helinode_1b", "targetname" ));
	
	flag_wait("moveup_deck2b");
	thread heli_flypath(getstruct( "deck_helinode_2b", "targetname" ));
	
	flag_wait("heli_shoot_deck_windows");
	
	level.heli.vehicle setspeed( 20, 10, 10 );
	level.heli.vehicle clearlookatent();
	level.heli.vehicle settargetyaw(110);
	level.heli.vehicle setgoalyaw(110);
	//copy engaging
	thread radio_dialogue("cargoship_hp1_copyengaging");
	target1 = spawn("script_origin", (-2324, 32, 256) );
	target1.targetname = "aftdeck_helispot_target";
	level.heli.model thread heli_searchlight_target( "targetname", "aftdeck_helispot_target" );
	thread heli_flypath(getstruct( "deck_helinode_win", "targetname" ));
	
	wait 1.5;
	level.heli.vehicle setspeed( 2, 7, 7 );
	
	
	alltopsidefx 	= getfxarraybyID( "rain_noise" );
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "rain_noise_ud" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_lights_cr" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_lights_flr" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_drips" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_drips_a" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgo_ship_puddle_small" ));
			
	for(i=0; i<alltopsidefx.size; i++)
		alltopsidefx[i] pauseEffect();
	
	
	wait 1;
	target2 = spawn("script_origin", (-2324, -416, 270) );
	
	time = 3.5;
	target2 moveto((-2368, 592, 270), time);
	target2 thread deck_minigun_dodamage();
	level.heli.model.minigun["left"] settargetentity(target2);
	level.heli.model heli_minigun_fire();	
	
	eject = spawn( "script_model", level.heli.model.minigun["left"] gettagorigin("tag_flash") );
	eject setmodel( "tag_origin" );
	eject linkto(level.heli.model.minigun["left"], "tag_flash", (-30,0,0), (0,0,0));
	eject thread deck_heli_minigun_fx();	
	
	wait time;
	
	
	for(i=0; i<alltopsidefx.size; i++)
		alltopsidefx[i] restartEffect();
	
	level.heli.model heli_minigun_stopfire();
	eject delete();
	level.heli.vehicle setspeed( 10, 7, 7 );
	wait 1;
	//level.heli.model thread heli_searchlight_target( "hero", "price" );
	level.heli.model.minigun["left"] cleartargetentity();
	//target1 delete();
	target2 delete();
	level.heli.vehicle setgoalyaw(225);
	level.heli.vehicle cleartargetyaw();
	
	flag_set("hallways");
	//Bravo Six, Hammer is at bingo fuel. We're buggin out. Big Bird will be on station for evac in ten.
	radio_dialogue("cargoship_hp1_bingofuel");
	flag_set("hallways_moveup");
	level.heli.model thread heli_searchlight_target("default");	
	level.heli.vehicle setspeed( 35, 10, 10 );
	heli_flypath(getstruct( "deck_helinode_gohome", "targetname" ));
	
	level.heli.model heli_searchlight_off();	
	level.heli.model.minigun["left"] delete();
	level.heli maps\mo_fastrope::fastrope_heli_cleanup();
	level.heroes7["pilot"] delete();
	level.heroes7["copilot"] delete();
}

deck_enemies_logic()
{
	flag_set("deck_enemies_spawned");
	self.ignoreme = true;
	self.health = 10;
	self.maxhealth = 10;
	node = getnode(self.target,"targetname");
	
	self thread patrol();
	self thread deck_enemies_herokill();	
	self thread deck_enemies_behavior();
	
	if( !isdefined( level.deck_enemy_die ) )
	{
		level.deck_enemy_die = true;
		thread enemies_death_msg( "cargoship_grg_tangodown" );
	}
	else
		thread enemies_death_msg( "cargoship_gm2_targetneutralized" );
		
	
	self endon("death");
	self waittill("in_range");
	self.ignoreme = false;
}

/************************************************************************************************************************************/
/*                  		                 				  	HALLWAYS LOGIC														*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

cover_relax(trans, stance, idle)
{
	self.animname = "guy";
	self anim_single_solo(self, trans);
	
	if(!isdefined(idle))
		idle = true;
	
	switch(stance)
	{
		case "stand":
			if(trans != "coverleft_crouch_aim")
				self anim_single_solo(self, "standaim2idle");
			if(idle)
				self thread anim_loop_solo(self, "standidle", undefined, "stop_loop");
			break;	
	}
}

hallways_main()
{
	jumpto = level.jumpto;
	if(level.jumptosection != "hallways")
		jumpto = "hallways";	
	
	switch(jumpto)
	{
		case "hallways":{
			flag_wait("hallways");
			
			level.player.ignoreme = false;
			
			ai = getaiarray("axis");
			for(i=0; i<ai.size; i++)
				ai[i] dodamage(ai[i].health + 300, ai[i].origin);
			
			thread hallways_player_speed();
			autosave_by_name("hallways_breach");
			
			if( level.jumpto != "hallways" )
			{
				level.heroes5["price" ] delayThread(0, ::cover_relax, "coverstand_aim", "stand");
				level.heroes5["seat6" ] delayThread(1, ::cover_relax, "coverstand_aim", "stand");
				level.heroes5["seat5" ] delayThread(.5, ::cover_relax, "coverstand_aim", "stand");
				level.heroes5["grigsby" ] delayThread(0, ::cover_relax, "coverleft_crouch_aim", "stand");
			}
			
			level.heroes5["price" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["alavi" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["grigsby" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["price" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["alavi" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["grigsby" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["price" ].ignoreme 		= false;
			level.heroes5["alavi" ].ignoreme 		= false;
			level.heroes5["grigsby" ].ignoreme 		= false;
			
			hallways_breach();
			
			array_thread( getentarray( "hallways_lower_runners","targetname" ), ::add_spawn_function, ::hallways_lower_runners);
			array_thread( getentarray( "hallways_lower_runners2","targetname" ), ::add_spawn_function, ::hallways_lower_runners2);
			thread hallways_lower_runners1_death();
			thread hallways_lower_runners_deathnotify();
			thread hallways_dialogue();
			
			msgs = [];
			msgs["alavi"] = "cargoship_gm1_clearleft";
			msgs["grigsby"] = "cargoship_grg_clearright";
			msgs["price"] = undefined;
			
			autosave_by_name("hallways");
			
			hallways_heroes("hallways_enter", "hallways_corner", msgs );
			
			
			
			//hallway clear
			thread radio_msg_stack("cargoship_pri_hallwayclear");
			//move up
			level.heroes3[ "price" ] delayThread(1, ::handsignal, "go");
			thread radio_msg_stack("cargoship_pri_moveup");
			msgs["alavi"] = "cargoship_gm1_clearright";
			msgs["grigsby"] = undefined;
			msgs["price"] = undefined;
			
			hallways_heroes("hallways_corner", "hallways_stairs", msgs);
			//stairs clear
			thread radio_msg_stack("cargoship_pri_stairsclear");
			flag_wait("hallways_bottom_stairs");
			
			
			
			setsaveddvar("ai_friendlyFireBlockDuration", 0);
			
			autosave_by_name("hallways_stairs");
		
			thread hallways_heroes("hallways_stairs", "hallways_lowerhall_guys");
			
			target = spawn( "script_origin", (-2740, -20, -116 ) );
			level.heroes3["grigsby"] setentitytarget( target );
			level.heroes3["price"] setentitytarget( target );
			
			flag_wait("hallways_lowerhall");
			
			level.heroes3["grigsby"] clearentitytarget();
			level.heroes3["price"] clearentitytarget();
			target delete();
			
			flag_wait("hallways_lowerhall_guys");
			
			delaythread( 2, ::autosave_by_name, "hallways_lowerhall" );
			delaythread( .5, ::radio_msg_stack, "cargoship_grg_tangodown");
			delaythread( 1, ::radio_msg_stack, "cargoship_pri_hallwayclear");
			delayThread(6, ::radio_msg_stack, "cargoship_pri_checkcorners" );
			
			//clear left
			msgs["alavi"] = "cargoship_gm1_clearleft";
			msgs["grigsby"] = "cargoship_grg_readysir";
			msgs["price"] = undefined;
			
			exits["alavi"] = "crouch2run";
			exits["grigsby"] = undefined;
			exits["price"] = undefined;
						
			hallways_heroes("hallways_lowerhall", "hallways_lowerhall2", msgs);//, undefined, exits);
			//move up
			thread radio_msg_stack("cargoship_pri_moveup");		
			flag_set("hallways_lowerhall2");
			//level.heroes3[ "price" ] thread handsignal("go");	//this is not working
			}	
	}
}

hallways_player_speed()
{	
	flag_wait("hallways_enter");
	thread player_speed_set(137, 1);
}

hallways_dialogue()
{	
	trig = getent("hallways_lower_runners","target" );
	trig waittill("trigger");
	
	wait 1.75;
	//movement right
	radio_msg_stack("cargoship_gm1_movementright");
}

hallways_lower_runners_deathnotify()
{
	flag_wait("hallways_lower_runners2");
	
	wait .2;
	
	ai = getaiarray("axis");
		
	thread hallways_lower_runners_instakill( ai );
	
	waittill_dead( ai );
	
	flag_set( "hallways_lowerhall_guys");
	flag_set( "hallways_lowerhall" );
}

hallways_lower_runners_instakill( ai )
{
	flag_wait( "cargoholds_1_enter" );
	ai = array_removedead( ai );
	
	if( !ai.size )
		return;
	
	for( i=0; i<ai.size; i++ )
		ai[ i ] dodamage( ai[ i ].health + 200, level.player.origin );
}	

hallways_lower_runners1_death()
{
	flag_wait("hallways_lower_runners1");
	
	wait .1;
	
	ai = getaiarray("axis");
	waittill_dead( ai );
	
	trig = getent("hallways_lower_runners2","target");
	trig notify("trigger");
}

hallways_lower_runners()
{	
	self endon("death");
	self.ignoreme = true;
	self.ignoreall = true;
	self.goalradius = 64;
	flag_set("hallways_lower_runners1");
	
	self thread hallways_lower_runners_common();
	
	self.animname = "sprinter";
	self.moveplaybackrate = 1;
	self set_run_anim( "sprint" );
	
	self waittill("goal");
	self.ignoreall = false;
	self clear_run_anim();
}

hallways_lower_runners2()
{
	self endon("death");
	flag_set("hallways_lower_runners2");
	
	self thread hallways_lower_runners_common();
}

hallways_lower_runners_common()
{
	self endon("death");
	self.a.disableLongDeath = true;
	
	self waittill("goal");
	self.ignoreme = false;
	self.ignoresuppression = true;
	
	waittillframeend;
	self.goalradius = 16;
	
	flag_wait("hallways_lower_runners2");
	wait .5;
	
	self.goalradius = 512;
}

hallways_breach_moveout( xanim, node )
{
	endmsg = "nothing_at_all";
	if( level.jumpto != "hallways" )
		endmsg = "stop_loop";

	self notify( endmsg );		
	self.animname = "guy";
	
	length = getanimlength( self getanim( xanim ) );
	self thread anim_single_solo( self, xanim );			
	
	wait length - .2;
	
	self setgoalnode( node );
	self.goalradius = 16;
	
	self stopanimscripted();
		
	self pushplayer(true);
}

#using_animtree("generic_human");
hallways_breach()
{
	level endon("hallways_enter");
	temp = getnodearray("hallways_door_open_guard","targetname");
	extras = [];
	for(i=0; i<temp.size; i++)
		extras[ temp[i].script_noteworthy ] = temp[i];
	keys = getarraykeys(level.heroes5);
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		level.heroes5[ key ].ignoresuppression = false;	
		level.heroes5[ key ].suppressionThresold = level.heroes5[ key ].oldsuppressionThresold;
	}
	
	if( level.jumpto != "hallways" )
	{
		wait 3;
		level.heroes5[ "alavi" ] setgoalnode( extras[ "alavi" ] );
		level.heroes5[ "alavi" ].goalradius = 16;
		level.heroes5[ "alavi" ] pushplayer(true);
			
		flag_wait("hallways_moveup");
		
		//Copy Hammer.
		thread radio_msg_stack("cargoship_pri_copyhammer");
		//Wallcroft, Griffen, cover our six. The rest of you, on me.
		thread radio_msg_stack("cargoship_pri_restonme");
		//roger that
		thread radio_msg_stack( "cargoship_grg_rogerthat");
	
		level.heroes5[ "seat6" ] thread hallways_breach_moveout( "stand2runL", extras[ "seat6" ]);
		level.heroes5[ "seat5" ] thread hallways_breach_moveout( "stand2runL", extras[ "seat5" ]);
		
		wait 1;
			
	}
	
	rnode = getnode("hallways_door_open","targetname");
	node1 = spawn( "script_origin", rnode.origin );// + ( 20, 13, 0 ));
	node1.angles = rnode.angles;
	
	node2 = spawn( "script_origin", node1.origin);
	node2.angles = node1.angles;// + (0,-15,0);
	
	if( level.jumpto != "hallways" )
	{
		level.heroes5[ "price" ] thread hallways_breach_moveout( "stand2runL", rnode);
		wait .5;
	}
		
	if( level.jumpto != "hallways" )
		level.heroes5[ "grigsby" ] hallways_breach_moveout( "stand2run", rnode);
	
	level.heroes5[ "price" ].animname = "price";
	level.heroes5[ "grigsby" ].animname = "grigsby";
	
	msg2 = "hallways_grigs_doorbreach";
	msg1 = "hallways_price_doorbreach";
	flag_init( msg1 );
	flag_init( msg2 );
			
	node1 thread cargoship_breach2_setup( level.heroes5[ "price" ], "breach2_price_arrival", "breach2_price_idle", "stop_loop", msg1 );
	node2 thread cargoship_breach2_setup( level.heroes5[ "grigsby" ], "breach2_grigsby_arrival", "breach2_grigsby_idle", "stop_loop", msg2 );
	flag_wait_all( msg1, msg2 );
	
	wait .1;
	
	flag_wait( "hallways_ready_to_breach" );
	flag_set( "stand_hint" );	
	
	//I like to keep this for close encounters.
	delayThread(2, ::radio_dialogue, "cargoship_grg_closeencounters" );
	node2 notify( "stop_loop" );
	level.heroes5[ "grigsby" ].wantShotgun = true;
	node2 anim_generic( level.heroes5[ "grigsby" ], "breach2_grigsby_talk");
	//Too right mate.
	thread radio_dialogue( "cargoship_gm1_tooright" );
		
	node1 notify( "stop_loop" );
	node2 notify( "stop_loop" );
	
	door = getent( "hallways_door", "targetname" );
	clip = getent(door.target, "targetname");
	clip connectpaths();
	//clip linkto( door );
	door UseAnimTree(#animtree);
	
	rnode thread anim_generic( door, "breach2_door_breach" );
	node2 thread anim_generic( level.heroes5[ "grigsby" ], "breach2_grigsby_breach");
	node1 thread anim_generic( level.heroes5[ "price" ], "breach2_price_breach");	
	
	node3 = spawn( "script_origin", level.heroes5[ "alavi" ].origin );
	node3.angles = ( 0, 90, 0 );
	node3 thread hallways_breach_alavi_hack( level.heroes5[ "alavi" ] );
	level.heroes5[ "alavi" ] thread notify_delay( "exit", 4.2 );
		
	wait 1.8;
	//On my mark - go.
	thread radio_dialogue( "cargoship_pri_onmymark" );
	clip rotateyaw( -80, 1, 0, .3);
	clip thread hallways_breach_clip();
	
	wait 2.2;
	//Check your corners…
	delaythread( .5, ::radio_dialogue,  "cargoship_pri_checkcorners");
	//check those corners!
	delaythread( 6, ::radio_msg_stack, "cargoship_pri_checkthose");
	
		
	level.heroes5[ "price" ] enable_cqbwalk_ign_demo_wrapper();
	level.heroes5[ "grigsby" ] enable_cqbwalk_ign_demo_wrapper();
	
	wait .2;	
	
	level.heroes5[ "alavi" ] thread hallways_heroes_solo("hallway_attack", "hallways_enter");
	
	wait .2;
	//level.heroes5[ "grigsby" ] stopanimscripted();
	level.heroes5[ "grigsby" ] thread hallways_heroes_solo("hallway_attack", "hallways_enter");	
	
	//wait 1.7;
	//level.heroes3[ "price" ] thread handsignal("go");
	//wait 1.1;

	level.heroes5[ "price" ] waittillmatch( "single anim", "end" );
	level.heroes3[ "price" ].animname = "guy";
	
	delayThread(.5, ::radio_dialogue, "cargoship_pri_move");
	level.heroes3[ "price" ] setgoalpos( level.heroes3[ "price" ].origin );
	level.heroes3[ "price" ].goalradius = 16;
	level.heroes3[ "price" ] pushplayer(true);	
	level.heroes3[ "price" ] handsignal("onme");
	level.heroes3[ "price" ] pushplayer(true);	
	level.heroes5[ "price" ] thread hallways_heroes_solo("hallway_attack", "hallways_enter");
	//level.heroes5[ "price" ] stopanimscripted();
		
//	node1 delete();
//	node2 delete();
//	node3 delete();
}

hallways_breach_clip()
{
	self waittill( "rotatedone" );
	self door_player_clip();
}

door_player_clip()
{	
	if( level.player istouching( self ) )
		self notsolid();
	else
		return;
		
	while( level.player istouching( self ) )
		wait .05;
	
	self solid();	
}

hallways_breach_alavi_hack( guy )
{
	self anim_generic( guy, "standidle2aim" );
	self thread anim_generic_loop( guy, "standaim" );
	
	guy waittill( "exit" );
	
	self notify( "stop_loop" );
	self thread anim_generic( guy, "stand2run" );
	
	length = getanimlength( getanim_generic( "stand2run" ) );
	wait length - .2;
	
	guy stopanimscripted();	
}

/************************************************************************************************************************************/
/*                  		                 				  	CARGOHOLDS LOGIC													*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

cargohold_flash()
{
	if( flag( "cargoholds_1_enter" ) )
		return;
	level endon("cargoholds_1_enter");
	
	cargohold_main_alavi_reach_flash();					
	thread radio_msg_stack( "cargoship_pri_standby" );
	thread radio_msg_stack( "cargoship_gm1_standingby" );

	level.heroes3[ "price" ] waittill("goal");
	flag_wait("cargohold1_flashmoment");		
		
	thread cargohold_flash2();
							
	level.heroes3[ "price" ] cargohold_flashthrow( (155,130,5), true );
	level notify("flashbang");
	thread radio_msg_stack( "cargoship_pri_go" );	
}

cargohold_flash2()
{
	level endon("cargoholds_1_enter");
	wait 3;
	radio_msg_stack( "cargoship_pri_flashbangout" );
}

cargohold_main()
{		
	jumpto = level.jumpto;
	if(level.jumptosection != "cargohold")
		jumpto = "cargohold";	
	
	switch(jumpto)
	{
		case "cargohold":{	
			thread cargohold1_pulp_fiction_think();
			enemies = getentarray( "pulp_fiction_guy","script_noteworthy" );
			array_thread( enemies, ::add_spawn_function, ::cargohold1_pulp_fiction_guy);
					
			flag_wait("hallways_lowerhall2");
						
			level.heroes3[ "grigsby" ].wantShotgun = true;
			thread player_speed_set(137, 1);
			
			level.heroes3[ "price" ] pushplayer(true);
			level.heroes3[ "alavi" ] pushplayer(true);
			level.heroes3[ "grigsby" ] pushplayer(true);
			
			exits = [];
			delays = [];
			msgs = [];
			
			exits["alavi"] 		= undefined; 
			if(level.jumpto == "cargohold")
				exits["grigsby"] 	= undefined;
			else
				exits["grigsby"] 	= "stand2run";
			exits["price"] 		= undefined;
			
			enemies = getentarray( "cargohold1_flashed_enemies","targetname" );
			array_thread( enemies, ::add_spawn_function, ::cargohold1_flashed_enemies);
			thread cargohold1_flashed_enemies_death();	

			delays["price"] = 2.25;
			delays["alavi"] = 0;
			delays["grigsby"] = 1.25;
											
			thread hallways_heroes("hallways_lowerhall2", "cargoholds_1_enter", undefined, delays, exits );
			
			setsaveddvar("ai_friendlyFireBlockDuration", 2000);
												
			array_thread(level.heroes3, ::disable_cqbwalk_ign_demo_wrapper );
			
			cargohold_flash();					
			level.heroes3[ "grigsby" ] pushplayer(false);
			level.heroes3[ "grigsby" ].dontpushplayer = true;
			
			
			level.heroes3[ "price" ].ignoreme = (false);
			level.heroes3[ "alavi" ].ignoreme = (false);
			level.heroes3[ "grigsby" ].ignoreme = (false);
			
			
			if( flag( "cargoholds_1_enter" ) )
			{
				exits["alavi"] 		= undefined; 
				exits["grigsby"] 	= undefined;
				exits["price"] 		= undefined;
				
				delays["price"] = .1;
				delays["alavi"] = 0;
				delays["grigsby"] = 0;	
			}
			else
			{							
				exits["alavi"] 		= "cornerleft8"; 
				exits["grigsby"] 	= undefined;
				exits["price"] 		= "cornerleft8";
				
				delays["price"] = .35;
				delays["alavi"] = 0;
				delays["grigsby"] = 1.7;
			}			
			
			level.heroes3[ "alavi" ] notify( "stop_loop" );
			level.heroes3[ "price" ] notify( "stop_loop" );
			level.heroes3[ "alavi" ] stopanimscripted();			
			level.heroes3[ "price" ] stopanimscripted();	
									
			thread hallways_heroes("cargoholds_1_enter", "nothing", undefined, delays, exits);
			
			flag_wait("cargoholds_1_enter_clear");
			thread radio_msg_stack("cargoship_gm1_moveup");
			
			level.heroes3[ "grigsby" ].dontpushplayer = undefined;		
			level.heroes3[ "grigsby" ] pushplayer(true);	
			
						
			delays["alavi"] = 0;
			delays["grigsby"] = 0;
			delays["price"] = 2;
											
			hallways_heroes("cargoholds_1_enter_clear", "cargoholds_1_cross", undefined, delays);
					
			thread radio_msg_stack("cargoship_pri_squadonme");
			
			delays["price"] = 0;
			delays["alavi"] = 1;
			delays["grigsby"] = 2;
					
			msgs["alavi"] = "cargoship_gm1_notangos";
			msgs["grigsby"] = "cargoship_grg_forwardclear";
			msgs["price"] = undefined;
						
			hallways_heroes("cargoholds_1_cross", "cargoholds_1_part3", msgs, delays);
			//stairs clear
			level.heroes3[ "price" ] thread handsignal("go");
			thread radio_msg_stack("cargoship_pri_moveup");
			
			delays["price"] = 1;
			delays["alavi"] = 0;
			delays["grigsby"] = 1;
			
			exits["alavi"] 		= undefined; 
			exits["grigsby"] 	= undefined;
			exits["price"] 		= "crouch2run";
			
			thread cargohold1_dialogue1();
						
			hallways_heroes("cargoholds_1_part3", "cargoholds_1_cross2", undefined, delays);//, exits);
			
			delays["price"] = 0;
			delays["alavi"] = 1;
			delays["grigsby"] = 3.5;
			
			exits["alavi"] = "cornerleft6";
			exits["grigsby"] = undefined;
			exits["price"] = undefined;
			
		
			thread cargohold1_dialogue2();	
			thread cargohold1_dialogue3();
						
			hallways_heroes("cargoholds_1_cross2", "cargoholds_1_part5", undefined, delays, exits);
			
			delays["price"] = 1;
			delays["alavi"] = 0;
			delays["grigsby"] = 0;
			
			hallways_heroes("cargoholds_1_part5", "nothing", undefined, delays);
			flag_set("cargoholds2");
		}	
	}
}

cargohold1_dialogue1()
{
	if( flag( "cargoholds_1_cross2" ) )
		return;
	level endon( "cargoholds_1_cross2" );
	
	wait 2.25;
	thread radio_msg_stack( "cargoship_pri_keepittight" );
		
	wait 2.75;
	
	if( flag("pulp_fiction_guy") )
		return;
	thread radio_msg_stack( "cargoship_grg_zeromovement" );
}

cargohold1_dialogue2()
{
	if( flag( "cargoholds_1_part5" ) )
		return;
	level endon( "cargoholds_1_part5" );
	
	wait 2.5;
	thread radio_msg_stack( "cargoship_pri_rightside" );
	wait .2;
	thread radio_msg_stack( "cargoship_grg_onit" );
		
	wait 3.8;
	
	if( flag("pulp_fiction_guy") )
		return;
	
	thread radio_msg_stack( "cargoship_gm1_looksquiet" );
	wait .5;
	thread radio_msg_stack( "cargoship_pri_stayfrosty" );
}

cargohold1_dialogue3()
{
	wait 10.5;
	
	if( flag("pulp_fiction_guy") )
		return;
		
	thread radio_msg_stack( "cargoship_grg_notangos" );
}

cargohold1_pulp_fiction_think()
{
	if (getdvar("pulp_fiction_guy") == "")
    	setdvar("pulp_fiction_guy", "");
    
    if (!isdefined(getdvar ("pulp_fiction_guy")))
	 	setdvar ("pulp_fiction_guy", "");
	 	
	flag_wait("cargoholds_1_enter");
	autosave_by_name_thread("cargoholds_1_enter");
	
	flag_wait("cargoholds_1_cross");
	
	trigs = getentarray("pulp_fiction_trigger", "targetname");
	exception = getentarray("absolute", "script_noteworthy");
	trigs = array_exclude(trigs, exception);
	array_thread(trigs, ::trigger_off );
	
	trigs = getentarray("pulp_fiction_trigger", "targetname");
		 
	string1 = getdvar("pulp_fiction_guy");
	
	index = randomint(trigs.size);
	
	if( isdefined( string1 ) )
	{
		trigs[ int(string1) ] trigger_off();//this will make sure 2 absolutes dont happen twice in a row
		while( int(string1)	== index )
		{
			index = randomint(trigs.size);
			wait .05;
		}
	}
	
	setdvar("pulp_fiction_guy", index);
		
	lucky = trigs[ index ];
	lucky trigger_on();	

	flag_wait_either( "pulp_fiction_guy", "laststand");
	
	trigs = getentarray("pulp_fiction_trigger", "targetname");
	array_thread(trigs, ::trigger_off );
}

cargohold1_pulp_fiction_guy()
{
	keys = getarraykeys(level.heroes3);
	//this is to make sure the ai doesn't spawn ontop of the friendlies if the friendlies are
	//ahead of the player.
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		dist1 = distance(self.origin, level.heroes3[ key ].origin );
		if( dist1  < 128 )
		{
			if( dist1 < distance(self.origin, level.player.origin) )
			{
				self delete();
				return;
			}
		}
	}
	
	flag_set("pulp_fiction_guy");
	self endon("death");
	
	anim.shootEnemyWrapper_func = animscripts\utility::ShootEnemyWrapper_shootNotify;
	
	self thread cargohold1_pulp_fiction_guy_ignore();
	self thread cargohold1_pulp_fiction_guy_healthshield();
	self.weapon = self.sidearm;
	self.favoriteenemy = level.player;
	self.disablearrivals = true;
	self.disableexits = true;
	self.animname = "pulp_fiction_guy";
	self.baseaccuracy = 1;
	self.accuracy = 1;
	//self set_run_anim("run");
	
	self.goalradius = 90;
	self setgoalpos( level.player.origin );	
	
	radio_dialogue_stop();
	self playsound( "generic_meleecharge_russian_" + randomintrange(1,8) );
	
	while( level.player.health > 0 )
	{
		level waittill( "an_enemy_shot", guy );
		
		if(guy != self)
			continue;
		
		num = 1;
		while(num)
		{
			wait .25;
			self shoot();	
			num--;
		}
	}
	
	self.ignoreme = true;
}

cargohold1_pulp_fiction_guy_healthshield()
{
	num = 1;
	while( num )
	{
		level.player waittill("damage", damage, other);
		if(!isalive(self))
			return;
		if(other == self)
			num--;
	}
	if(!isalive(self))
		return;
	
	level.player enableHealthShield( false );
	
	self waittill("death");
	
	level.player enableHealthShield( true );	
}

cargohold1_pulp_fiction_guy_ignore()
{
	self endon("death");
	self.ignoreme = true;
	
	wait 2;
	
	self.ignoreme = false;
}

cargohold1_flashed_enemies_death()
{
	flag_wait("cargohold1_flashmoment");
	wait .1;
	
	ai_clear_dialog(undefined, undefined, undefined, level.player, "cargoship_gm1_catwalkclear");
	flag_set("cargoholds_1_enter_clear");
}

cargohold1_flashed_enemies()
{
	self endon ("death");
	
	self.grenadeammo = 0;
	//self.ignoreme = true;
	wait .15;
	self.goalradius = 64;
	self.health = 2;
	self.disablelongdeath = 1;	
		
	target = spawn("script_origin", (-2176, 540, -140 ) );
	level waittill("alavi_looked");
	self setentitytarget(target);
	
	level waittill("flashbang");

	//self.flashingTeam = self.team;
	//self setflashbanged(true, 6);
	
	target delete();		
	self clearentitytarget();
/*		
	delayThread(randomfloatrange(5, 5.5), ::set_ignoreme, false);
	
	self.allowdeath = true;
	
	self.animname = "flashed";
	
	self endon("death");
	
	if( !isdefined(level.flashanims) )
		level.flashanims = 0;
	
	num = 2;
	while(num)
	{
		level.flashanims++;
		if(level.flashanims > 4)
			level.flashanims = 0;
			
		//xanim = self getanim( "" + level.flashanims );
		
		self thread anim_custom_animmode_solo( self, "gravity", "" + level.flashanims );
					
		//self setanimknoball( xanim, %body );
		wait randomfloatrange(1.5, 2);
		self.flashingTeam = self.team;
		num--;
	}
	*/
}

cargohold_main_alavi_reach_flash()
{
	level endon("cargoholds_1_enter");
	
	wait .1;
	level.heroes3[ "alavi" ].goalradius = 8;
	level.heroes3[ "alavi" ] waittill("hallways_heroes_ready");	
	
	level.heroes3[ "alavi" ] thread cargohold_main_alavi_reach_flash2();
}

cargohold_main_alavi_reach_flash2()
{
	level endon("cargoholds_1_enter");
	
	flag_wait("cargohold1_flashmoment");
	wait .5;
	self.animname = "guy";
	self.ignoresuppression = true;
	self.oldsuppression = self.suppressionwait;
	self.suppressionwait = 0;
	
	self anim_single_solo(self, "corner_l_look");
	level notify("alavi_looked");
	self anim_single_solo(self, "corner_l_quickreact");
	self thread anim_loop_solo(self, "corner_l_idle", undefined, "stop_loop");
	
	level waittill("flashbang");
	self notify("stop_loop");
	wait 2;
	self.suppressionwait = self.oldsuppression;
}

cargohold1_breach2( node )
{
	wait 2;
	level.heroes5[ "alavi" ] setgoalnode( node );
	level.heroes5[ "alavi" ].goalradius = 16;
}

cargohold1_breach()
{
	node = getnode("cargohold1_door","targetname");
	
	level.heroes5[ "alavi" ] disable_cqbwalk_ign_demo_wrapper();	
	level.heroes5[ "grigsby" ] disable_cqbwalk_ign_demo_wrapper();
	//open the door
	level.heroes5[ "price" ].animname = "price";
	level.heroes5[ "grigsby" ].animname = "grigsby";
		
	rnode = getnode("cargohold1_door_open","targetname");
	node1 = spawn( "script_origin", rnode.origin + ( 15, -30, 0 ));
	node1.angles = rnode.angles;
	
	node2 = spawn( "script_origin", node1.origin);
	node2.angles = node1.angles + (0,-13,0);
	
	msg1 = "cargohold1_grigsby_doorbreach";
	msg2 = "cargohold1_price_doorbreach";
	flag_init( msg1 );
	flag_init( msg2 );
	
	node1 thread cargoship_hack_animreach( level.heroes5[ "price" ], "door_breach_setup", "door_breach_setup_idle", "stop_loop", msg2 );
	
	wait 1.5;
	thread cargohold1_breach2(node);
	node2 thread cargoship_hack_animreach( level.heroes5[ "grigsby" ], "door_breach_setup", "door_breach_setup_idle", "stop_loop", msg1 );
	
	flag_wait_all( msg1, msg2 );
	
	radio_msg_stack("cargoship_grg_readysir");
	autosave_by_name("cargohold2_breach");
	
	node1 notify( "stop_loop" );
	node2 notify( "stop_loop" );
	
	node1 thread anim_single_solo( level.heroes5[ "price" ], "door_breach_setup");
	node2 anim_single_solo( level.heroes5[ "grigsby" ], "door_breach_setup");
	
	
	node1 thread anim_single_solo( level.heroes5[ "price" ], "door_breach" );	
	node2 thread anim_single_solo( level.heroes5[ "grigsby" ], "door_breach" );	
			
	level.heroes5[ "price" ] waittillmatch( "single anim", "kick" );
	
	delaythread( .5, ::radio_msg_stack, "cargoship_pri_go");
	
	door = getent( "cargohold1_door", "targetname" );
	clip = getent(door.target, "targetname");
	clip connectpaths();
	clip linkto( door );
	door door_opens( .8 );		
	
	level.heroes5[ "price" ] 	enable_cqbwalk_ign_demo_wrapper();
	level.heroes5[ "grigsby" ] 	enable_cqbwalk_ign_demo_wrapper();
		
	wait 1;
	level.heroes5[ "alavi" ] thread hallways_heroes_solo("cargohold2_enter", "cargohold2_catwalk", "cargoship_gm1_clearright");//, "stand2run");
	level.heroes3[ "alavi" ] pushplayer(true);
	wait .2;
	level.heroes5[ "grigsby" ] stopanimscripted();
	level.heroes3[ "grigsby" ] pushplayer(true);
	level.heroes5[ "grigsby" ] thread hallways_heroes_solo("cargohold2_enter", "cargohold2_catwalk", "cargoship_grg_clearleft");	
	
		
	level.heroes5[ "price" ] waittillmatch( "single anim", "end" );
	flag_set("cargoholds2_breach");
	level.heroes3[ "price" ].animname = "guy";
	level.heroes3[ "price" ] handsignal("onme");
	level.heroes3["price"] anim_single_solo(level.heroes3["price"], "stand2runL");
	level.heroes3[ "price" ] pushplayer(true);
	
	node2 delete();
	node1 delete();
}

/************************************************************************************************************************************/
/*                  		                 				  	CARGOHOLD 2 LOGIC													*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

cargohold2_main()
{	
	enemies = getentarray( "cargohold2_catwalk_enemies","targetname" );
	enemies2 = getentarray( "cargohold2_catwalk_enemies2","targetname" );
	array_thread( enemies, ::add_spawn_function, ::cargohold2_enemies1);
	array_thread( enemies2, ::add_spawn_function, ::cargohold2_enemies2);
	thread cargohold2_enemies1_death();	
	thread cargohold2_enemies2_death();	
	
	flag_wait("cargoholds2");
		
	delayThread(1, ::radio_msg_stack, "cargoship_pri_stackup" );												
	thread cargohold1_breach();
	
	flag_wait("cargoholds2_breach");
	level.heroes5[ "alavi" ] 	enable_cqbwalk_ign_demo_wrapper();
	
	delayThread(.25, ::radio_msg_stack, "cargoship_pri_move" );
				
	delays["price"] = 0;
	delays["alavi"] = 0;
	delays["grigsby"] = .5;
	
	exits["alavi"] = "stand2run180";
	exits["grigsby"] = undefined;
	exits["price"] = undefined;
	
	level.heroes3[ "alavi" ] 	delayThread(.5, ::cargohold_catwalk_shuffle );
	level.heroes3[ "grigsby" ] 	delayThread(.5, ::cargohold_catwalk_shuffle );
	level.heroes3[ "price" ] 	delayThread(.5, ::cargohold_catwalk_shuffle );
	
	hallways_heroes("cargohold2_catwalk", "cargohold2_catwalk2", undefined, delays, exits );
	
	flag_wait("cargohold2_catwalk2a");
	
	thread player_speed_reset( 1 );
	
	
	if( flag("package_enter") )
		return;
		
	level endon("package_enter");
	
	thread radio_msg_stack( "cargoship_pri_moveup" );
	
	delays["price"] = 0;
	delays["alavi"] = 0;
	delays["grigsby"] = 0;
	
	hallways_heroes("cargohold2_catwalk2a", "cargohold2_door", undefined, delays );
																		
	flag_wait("cargohold2_catwalk2");
	
	if( flag("cargohold2_enemies_dead") )
	{
		thread radio_msg_stack( "cargoship_gm1_forwardclear" );
		thread radio_msg_stack( "cargoship_pri_move" );
	}
		
	delays["price"] = 1;
	delays["alavi"] = .5;
	delays["grigsby"] = 0;
	
	flag_wait("cargohold2_enemies_dead");
	
	autosave_by_name("cargohold2_enemies_dead");
	
	msgs["alavi"] = "cargoship_gm1_clearleft";
	msgs["grigsby"] = "cargoship_grg_clearright";
	msgs["price"] = undefined;
		
	wait .1;
	
	hallways_heroes("cargohold2_catwalk2", "cargohold2_door", msgs, delays );
	
	thread radio_msg_stack( "cargoship_pri_stackup" );
	wait 1;
	level.heroes3[ "price" ] thread handsignal("go");
	flag_set("laststand");
}

cargohold2_enemies1_death()
{
	flag_wait("cargohold2_enemies");
	thread radio_msg_stack("cargoship_grg_movementright");
	
	wait .25;
	ai = getaiarray("axis");
	waittill_dead(ai);
	
	flag_set("cargohold2_catwalk2a");
}

cargohold2_enemies2_death()
{
	flag_wait("cargohold2_enemies2");
	
	wait .25;
	ai = getaiarray("axis");
	waittill_dead(ai);
	
	flag_set("cargohold2_catwalk2");
	flag_set("cargohold2_enemies_dead");
}

cargohold2_enemies2()
{
	self endon("death");
	
	flag_set("cargohold2_enemies2");
	thread cargohold2_enemies_common();
	
	self waittill("goal");
	waittillframeend;
	self.goalradius = 275;
}

cargohold2_enemies1()
{
	self endon("death");
	
	flag_set("cargohold2_enemies");
	thread cargohold2_enemies_common();
	
	self waittill("goal");
	waittillframeend;
	self.goalradius = 64;
	
	flag_wait("cargohold2_catwalk2a");
	self setgoalnode( getnode("cargohold2_enemynode2", "targetname") );
	self.goalradius = 275;
}

cargohold2_enemies_common()
{
	self endon("death");
	
	self.grenadeammo = 0;
	self.suppressionwait = 0;
	self.suppressionThreshold = .75;
	self.baseaccuracy *= .8;
	self.a.disableLongDeath = true;
	
	flag_wait("package_enter");
	self setgoalnode( getnode("laststand_friendlynode", "targetname") );
	self.goalradius = 800;
}

cargohold_catwalk_shuffle()
{	
	self waittill("hallways_heroes_ready");
	
	self.animname = "shuffle";
		
	node = spawn("script_origin", self.origin );
	node.angles = (0,0,0);
	
	length = getanimlength( level.scr_anim[ "shuffle" ][ "arrival" ] );
	node thread anim_single_solo(self, "arrival" );
	wait length - .4;
	self stopanimscripted();
	
	node.origin = self.origin;
	node.angles = (0,270,0);
	num = 5;
	
	self.shuffling = true;
	self.ignoreme = false;
	
	self notify("shuffling");
	
	self OrientMode( "face angle", node.angles[1] );
	xanim = self getanim("loop");
	length = getanimlength(xanim);
	rate = 1.25;
	length *= (1/rate);
	
	self animcustom(::cargohold_catwalk_shuffle_aim );
	self.a.disablePain = true;
	
	while(num && !flag("cargohold2_catwalk2a") )
	{
		//self setflaggedanimknoball( "custom_anim", xanim, %body, 1, .2, rate );
		self setanim(xanim, 1, .2, rate );
	//	self setanim(%exposed_modern,1,.2);
		self setanim(%exposed_aiming,1);
		
		wait length;
		
		node.origin = self.origin;
		num--;
	}
	self.shuffling = false;
	self.a.disablePain = false;
	self disable_cqbwalk();
				
	flag_set("cargohold2_catwalk2a");	
	
	node thread anim_single_solo(self, "exit" );
	wait .5;
	self stopanimscripted();
	self pushplayer( false );
	
	node delete();
}

cargohold_catwalk_shuffle_aim()
{
	level endon("killanimscript");

	flag_wait("cargohold2_enemies");

	self thread cargohold_catwalk_shuffle_shoot();
	
	while( self.shuffling )
	{
		axis = getaiarray("axis");
		if ( !axis.size )
		{
			// game dies if there are no axis alive at this point
			// seems odd to have an animcustom call some level script, should put this stuff in an animscript
			wait( 0.05 );
			continue;
		}
		
		target = random(axis);
		
		self.shootEnt = target;
		while( self.shuffling && isalive( target ) )
			animscripts\shared::trackShootEntOrPos();
	}
}

cargohold_catwalk_shuffle_shoot()
{
	while( self.shuffling )
	{
		if( self.script_noteworthy == "grigsby" )
		{
			wait randomfloatrange(.6, 1);
			self shoot();
		}
		else
		{
			wait randomfloatrange(.3, 1);
			self burstshot( randomintrange(6,10) );
		}
	}
}

/************************************************************************************************************************************/
/*                  		                 				  	LAST STAND LOGIC													*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

laststand_main()
{
	jumpto = level.jumpto;
	if(level.jumptosection != "laststand")
		jumpto = "laststand";	
	
	switch(jumpto)
	{
		case "laststand":{
			array_thread( getentarray( "cargohold3_enemies1","targetname" ), ::add_spawn_function, ::laststand_enemies1);
			array_thread( getentarray( "cargohold3_enemies2","targetname" ), ::add_spawn_function, ::laststand_enemies2);
			array_thread( getentarray( "cargohold3_enemies3","targetname" ), ::add_spawn_function, ::laststand_enemies3);
			
			thread laststand_enemyspawn( "cargohold3_enemies1", "cargohold3_enemies2", 1 );						
			thread laststand_enemyspawn( "cargohold3_enemies2", "cargohold3_enemies3", 2 );
			
			flag_wait("laststand");
			
			array_thread( level.heroes3, ::laststand_hero_think );
												
			thread laststand_clear();
			laststand_breach();
			
			delaythread( 15, ::flag_set, "nade_hint" );
			
			flag_set("package_enter");
			autosave_by_name("package_enter");
			thread player_speed_reset( 1 );
						
			trig = getent("laststand_red1", "targetname");
			trig notify("trigger");
			
			level.heroes3[ "grigsby" ] thread enable_ai_color();
			level.heroes3[ "price" ] delaythread(.75, ::enable_ai_color );
			level.heroes3[ "alavi" ] delaythread(1.5, ::enable_ai_color );	
			
			wait 3;
			setsaveddvar("ai_friendlyFireBlockDuration", 2000);		
		}
	}
}

laststand_hero_think()
{
	self thread disable_ai_color();
	
	flag_wait("package_enter");
	
	self.ignoreme = false;
	self pushplayer(false);
	self.ignoresuppression = false;
	
	wait randomfloatrange(4,7);
	
	self disable_ai_color();
	self.fixednode = false;
		
	node = getnode("laststand_friendlynode","targetname");
	self setgoalnode( node );
	self.goalradius = node.radius;
	
	self waittill("goal");
	wait randomfloatrange(10,15);
		
	self.goalradius = 600;
	
	while( !flag("laststand_3left") )
	{
		pos = ( level.player.origin[0], level.player.origin[1], node.origin[2] );
		self setgoalpos( pos );
		wait randomfloatrange(1, 5);
	}
	
	switch(self.script_noteworthy)
	{
		case "price":	
			while(  !flag("package")  )
			{
				ai = getaiarray("axis");
				if( !isdefined( ai ) || ai.size == 0 )
					break;
				self.favoriteenemy = ai[0];
				self.goalradius = 400;
				while( isalive(ai[0]) )
				{
					self setgoalpos( ai[0].origin );	
					wait randomfloatrange(1, 5);
				}
			}
			break;
		
		default:
			self.goalradius = 400;
			while( !flag("package") )
			{
				self setgoalpos( level.heroes3[ "price" ].origin );
				wait 1;
			}
			break;
	}
		
	flag_wait("package");
	
	self setgoalpos(self.origin);
	self.goalradius = 64;
}

laststand_breach()
{
	if( flag("package_enter") )
		return;
	level endon("package_enter");
		
	exits["alavi"] 		= "cornerleft7"; 
	exits["grigsby"] 	= "cornerright8";
	exits["price"] 		= undefined;
	
	delays["price"] = 2;
	delays["alavi"] = .5;
	delays["grigsby"] = 0;
	
	level.heroes3[ "price" ].ignoreme = true;
	level.heroes3[ "price" ].ignoresuppression = true;
	level.heroes3[ "alavi" ].ignoreme = true;
	level.heroes3[ "alavi" ].ignoresuppression = true;
	level.heroes3[ "grigsby" ].ignoreme = true;
	level.heroes3[ "grigsby" ].ignoresuppression = true;
	
	thread radio_msg_stack( "cargoship_pri_standby" );
	level.heroes3[ "alavi" ] thread laststand_msg( "cargoship_gm1_twoready" );
	level.heroes3[ "grigsby" ] thread laststand_msg( "cargoship_grg_oneready" );
	hallways_heroes("cargohold2_door", "nothing", undefined, delays, exits );
	autosave_by_name("cargohold2b");
	
	delayThread(3.4, ::radio_msg_stack, "cargoship_pri_onmymark" );	
	setsaveddvar("ai_friendlyFireBlockDuration", 0);	
	level.heroes3[ "price" ] cargohold_flashthrow( (500,10,300), true, 500);
}

laststand_msg( msg )
{
	self waittill( "hallways_heroes_atgoal" );
	radio_msg_stack( msg );	
}

laststand_enemies_common()
{
	self endon("death");
	self.grenadeammo = 0;
	
	flag_wait("laststand_3left");	
	
	wait randomfloatrange(.25, 1.25);
	
	self setgoalpos( (2221, 230, -320) );
	self.goalradius = 300;
}

laststand_enemies3()
{
	self thread laststand_enemies_common();
}

laststand_enemies2()
{
	self thread laststand_enemies_common();
	flag_set("package_enter");
	flag_set("laststand");
}

laststand_enemies1()
{
	self thread laststand_enemies_common();
	self endon("death");
	
	self.ignoreme = true;
		
	self waittill("goal");
	waittillframeend;
	
	self.oldradius = self.goalradius;
	self.goalradius = 90;
	
	flag_wait("package_enter");
	
	self.goalradius = self.oldradius;
	self.ignoreme = false;
}

laststand_enemyspawn(name1, name2, count, time)
{
	trig1 	= getent( name1, "target" );
	trig2 	= getent( name2, "target" );
	num1 	= getentarray( name1, "targetname" );
		
	trig2 endon("trigger");
	
	trig1 waittill("trigger");	
	
	wait .25;
	ai = getaiarray("axis");
	
	waittill_dead( ai, ( num1.size - count ), time);
	
	trig2 notify("trigger");
}

laststand_clear()
{
	trigger = getent("cargohold3_enemies3","target");
	trigger waittill( "trigger" );	
	
	flag_set("package_enter");
	
	wait .5;
	
	ai = getaiarray("axis");
	waittill_dead( ai, ( ai.size - 3 ) );
	flag_set("laststand_3left");
	
	ai = getaiarray("axis");
	for(i=0; i<ai.size; i++)
		ai[i].a.disableLongDeath = true;
	
	ai_clear_dialog(undefined, undefined, undefined, level.player, "cargoship_gm1_tangodown");
	flag_set("package");
}

/************************************************************************************************************************************/
/*                  		                 				  	PACKAGE LOGIC														*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
package_main()
{
	jumpto = level.jumpto;
	if(level.jumptosection != "package")
		jumpto = "package";	
	
	switch(jumpto)
	{
		case "package":
		{	
			flag_wait("package");
			
			wait 1; 
									
			thread package_dialogue();		
			thread package_music();
			
			flag_wait("package_report");			
			
			thread package_grigs();
						
			keys = getarraykeys( level.heroes3 );							
			for(i=0; i<keys.size; i++)
			{
				key = keys[ i ];
				level.heroes3[ key ].animname = "escape";
			}
			
			level.heroes3[ "price" ]	pushplayer(true);
			level.heroes3[ "grigsby" ] 	pushplayer(true);
			level.heroes3[ "alavi" ] 	pushplayer(true);
			
			level.heroes3[ "alavi" ] delayThread(.5, ::hallways_heroes_solo, "package1", "nothing" );
			level.heroes3[ "price" ] hallways_heroes_solo("package1", "nothing" );
			
			flag_set("package_reading");	
					
			level.heroes3[ "price" ].goalradius = 4;
			level.heroes3[ "price" ].goalradius = 4;
			
			level.heroes3["price"] setmodel( "body_complete_sp_sas_ct_price_maskup" );	
							
			flag_wait("package_orders");
			
			thread player_speed_set(185, 1);
			array_thread(level.heroes3, ::clear_run_anim);			
			flag_set("escape");
		}	
	}
}

package_grigs()
{
	//level.heroes3[ "grigsby" ] hallways_heroes_solo("package1", "nothing", undefined, undefined);
	guy = level.heroes3[ "grigsby" ];
	guy.animname = "escape";
	node = getent( "package_dooranim_node" , "targetname" );
	anime = "package_grigs";
	
	thread package_grigs2( guy );
	
	node anim_generic_reach_and_arrive( guy, anime );				
	//node anim_first_frame_solo( guy, anime );
	
	flag_wait( "package_reading" );
	flag_wait( "strong_reading" );
	
	while( distance( guy.origin, level.player.origin ) > 700 )
		wait .05;
		
	flag_set("package_open_doors");
	
	guy thread anim_single_queue(guy, "cargoship_gaz_takealook");
	node anim_generic( guy, anime );
	
	guy pushplayer( true );
	guy setgoalpos( guy.origin );
	guy.goalradius = 4;
		
	flag_set("found_package");
}

package_grigs2( guy )
{
	wait 1.25;
	guy anim_single_queue( guy, "cargoship_grg_strongreading" );
	flag_set( "strong_reading" );
}

#using_animtree("generic_human");
package_open_doors( node )
{
	doorR = getent("package_door_left", "targetname");
	doorR thread package_doorsetup();
	doorL = getent("package_door_right", "targetname");
	doorL thread package_doorsetup();
	
	wait .1;
		
	doorL_link = spawn( "script_model", doorR.link.origin );
	doorL_link.angles = (0,0,0);
	doorL_link setmodel( "cs_container_door_joint" );
	//doorL_link hide();
	doorL_link UseAnimTree(#animtree);
	doorR linkto( doorL_link, "tag_animate" );
	
	doorR_link = spawn( "script_model", doorL.link.origin );
	doorR_link.angles = (0,0,0);
	doorR_link setmodel( "cs_container_door_joint" );
	//doorR_link hide();
	doorR_link UseAnimTree(#animtree);
	doorL linkto( doorR_link, "tag_animate" );
	
	doorL_link.animname = "generic";
	doorR_link.animname = "generic";
	node thread anim_first_frame_solo( doorL_link, "package_doorL" );
	node thread anim_first_frame_solo( doorR_link, "package_doorR" );
	
	flag_wait("package_open_doors");
	
	doorL connectpaths();
	doorR connectpaths();
	
	node thread anim_generic( doorL_link, "package_doorL" );
	node anim_generic( doorR_link, "package_doorR" );
	
	doorL thread door_player_clip();
	doorR thread door_player_clip();
	doorL unlink();
	doorR unlink();
	doorL_link delete();
	doorR_link delete();
	waittillframeend;
	doorR notify ( "sway" );
	doorL notify ( "sway" );
	
	node delete();
}

package_dialogue()
{
	price 	= level.heroes3[ "price" ];
	grigsby = level.heroes3[ "grigsby" ];
	
	thread package_radiation();
	
	radio_msg_stack("cargoship_pri_report");
	radio_msg_stack("cargoship_grg_rogerthat");
	
	flag_set("package_report");	
	flag_wait("found_package");
	//Baseplate, no sign of the package, over.
//	grigsby anim_single_queue(price, "cargoship_gaz_takealook");
	price anim_single_queue(price, "cargoship_pri_inarabic");
	price anim_single_queue(price, "cargoship_pri_readytosecure");
	
	flag_set( "music_tension_notime" );
	
	//Bravo Six, Evac is topside and standing by. Bogies are 20 miles out and closing fast. 
	//You guys need to get the hell off that ship right now, over.
	radio_msg_stack("cargoship_hqr_notime");	
	//Fast movers. Probably MiGs. We'd better go..
	grigsby anim_single_queue(grigsby, "cargoship_grg_fastmovers");
	//mac, grab the laptop, everyone, topside, double time.
	price anim_single_queue(price, "cargoship_pri_getmanifestmove");
	
	flag_set("package_orders");
}

package_music()
{
	level endon ( "cargoship_escape_music" );
	
	flag_wait( "music_tension_notime" );
	musicstop();
	wait 2;
	
	while( 1 )
	{
		MusicPlayWrapper( "tension_maintheme_groove" );
		wait 47;
	}
}

package_radiation()
{
	origin = spawn( "script_origin", ( 2477.2, 198, -311 ) );
	
	radiation_sound = "none";
	
	while( !flag( "escape_explosion" ) )
	{
		dist = distance( level.player.origin, origin.origin );
		
		if( dist > 300 )
		{
			radiation_sound = "none";
			origin stoploopsound();
		}
		else if( dist < 150 && radiation_sound != "item_geigercouner_level2" )
		{
			origin stoploopsound();
			radiation_sound = "item_geigercouner_level2";
			origin playloopsound( radiation_sound );	
		}
		else if( radiation_sound != "item_geigercouner_level1" )
		{
			origin stoploopsound();
			radiation_sound = "item_geigercouner_level1";
			origin playloopsound( radiation_sound );	
		}		
		
		wait .1;
	}
	origin stoploopsound();
	waittillframeend;
	origin delete();
}

package_doorsetup()
{
	dependants = getentarray(self.targetname, "target");
	for(i=0; i<dependants.size; i++)
		dependants[i] linkto(self);
	
	node = getstruct(self.target, "targetname");
	rotateent = spawn ("script_origin",(0,0,0));
	rotateent.axial = true;
			
	A = node.origin;
	B = undefined;
	vec = anglestoup(node.angles);
	vec = vector_multiply(vec, 10);
	if( issubstr(self.target, "right") )
		B = A-vec;
	else
		B = A+vec;
	world 	= (0,360,0);
	ang = node.angles;
	
	rotateent.origin = A;
	rotateent.angles = vectortoangles (B - A);
	rotateent.pratio = 1;//vectordot(anglestoright(ang), anglestoforward(world));
	rotateent.rratio = -1;//vectordot(anglestoright(ang), anglestoright(world));
	rotateent.sway1max = 20;
	rotateent.sway2max = 20;
	rotateent.setscale = undefined;
	
	self.link = rotateent;
	
	self waittill("sway");
	
	self linkto ( rotateent );				
	maps\_sea::sea_objectbob_logic(level._sea_org, rotateent);
	
}
/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 				  	ESCAPE LOGIC														*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
escape_main()
{
	flag_wait("escape");
	
	water_stuff_for_art1( true );
	thread water_stuff_for_art2( 0 );
		
	door = getent("escape_door","targetname");
	clip = getent(door.target, "targetname");
	clip notsolid();
	clip connectpaths();
	door thread door_opens( .6 );
		
	flag_set("escape_cargohold2_fx");
	
	escape_heroes_turn_setup();
	escape_heroes_runanim_setup();
	thread escape_fx_setup();
	thread escape_tiltboat();
	thread escape_dialogue();
	thread escape_cargohold_flood();
	thread escape_catwalk();
	thread escape_hallways_lower_flood();
	thread escape_seaknight();
	thread escape_autosaves();
	thread escape_invisible_timer();
	
	array_thread( getentarray("cargohold_debri", "targetname"), ::escape_debri );
	array_thread( getentarray("escape_event","targetname"), ::escape_event );
	array_thread( getentarray("light_cargohold","targetname"), ::misc_light_flicker, "cargo_vl_white", "cargohold_fx", "escape_explosion");
	array_thread( getentarray("lights_cargohold_up","targetname"), ::misc_light_flicker, "cargo_vl_white_soft", "cargohold_fx", "escape_explosion");
	array_thread( getentarray("lights_hallway_lower","targetname"), ::misc_light_flicker, undefined, "cargohold_fx", "escape_explosion");
	
	flag_wait("package_secure");
		
	level.heroes3[ "price" ].animname = "escape";
	level.heroes3[ "grigsby" ].animname = "escape";
	level.heroes3[ "alavi" ].animname = "escape";
		
	level.heroes3["price"] thread anim_single_stack(level.heroes3["price"], "cargoship_pri_topside");
	
	pack = [];
	pack[ pack.size ] = level.heroes3["price"];
	pack[ pack.size ] = level.heroes3["alavi"];
	pack[ pack.size ] = level.heroes3["grigsby"];
	
	level.heroes3["price"] 		ent_flag_init("turning");
	level.heroes3["grigsby"]	ent_flag_init("turning");
	level.heroes3["alavi"]		ent_flag_init("turning");
	
	level.heroes3["price"] 		thread escape_heroes_holdtheline(350, pack, 100);
	level.heroes3["grigsby"] 	thread escape_heroes_holdtheline(450, pack, 100);
	level.heroes3["alavi"] 		thread escape_heroes_holdtheline(300, pack, 100);
	
	array_thread( level.heroes3, ::escape_heroes );
	array_thread( getentarray("sink_waterlevel","targetname"), ::escape_waterlevel );
	
	array_thread(getentarray("escape_flags","script_noteworthy"), ::trigger_on);
	thread escape_explosion();
	
	
	stairblocker = getent( "escape_stair_blocker", "targetname" );
	stairblocker show();
	stairblocker solid();
	stairblocker disconnectpaths();
	
	player_end_water_clip = getent( "player_end_water_clip", "targetname" );
	player_end_water_clip solid();
	
	
	flag_wait("escape_explosion");
	array_thread( level.heroes3, ::escape_heroes2 );
	//talk a whole bunch about shit - then go
	flag_wait("escape_get_to_catwalks");
	
	level.heroes3["alavi"] thread function_stack( ::escape_heroes_run, "escape_cargohold2" );	
	wait .5;
	level.heroes3["grigsby"] thread function_stack( ::escape_heroes_run, "escape_cargohold2" );	
	wait .5;
	level.heroes3["price"] thread function_stack( ::escape_heroes_run, "escape_cargohold2" );	
			
	level.heroes3["alavi"] thread escape_heroes_holdtheline(500, pack, 200);
	level.heroes3["grigsby"] thread escape_heroes_holdtheline(400, pack, 150);
	level.heroes3["price"] thread escape_heroes_holdtheline(350, pack, 150);
	
	keys = getarraykeys(level.heroes3);
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_cargohold2b");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_cargohold1");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_hallway_lower");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_hallway_lowerb");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_hallway_lowerc");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_hallway_lowerd");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_hallway_lowere");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_hallway_upper");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_hallway_upperb");
		level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_aftdeck");
	//	level.heroes3[ key ] thread function_stack( ::escape_heroes_run, "escape_aftdeckb");
	}
	
	thread end_main();
}

end_main()
{
	node = getent("escape_end_anim_node", "targetname");
	//node.angles += (0,15,0);
	
	
	thread end_jump();
	thread end_nojump();
	thread end_anim_thread();
	thread end_handle_player_fall();
	
	flag_wait( "escape_hallway_upper_flag" );
	heli = level.seaknight.model;
	price = level.heroes3[ "price"];
		
	thread end_dialogue();
	
	flag_wait( "escape_aftdeck_flag" );
	
	while( distance( level.player.origin, price.origin ) > 490 )
		wait .05;
	
	level.heroes3[ "alavi" ] thread function_stack( ::escape_heroes_rescue );
	level.heroes3[ "grigsby" ] delaythread(1, ::function_stack, ::escape_heroes_rescue );
	level.heroes3[ "price" ] delaythread(1.5, ::function_stack, ::escape_heroes_rescue );
	
	pack = [];
	pack[ pack.size ] = level.heroes3["price"];
	pack[ pack.size ] = level.heroes3["alavi"];
	pack[ pack.size ] = level.heroes3["grigsby"];
	level.heroes3["alavi"] thread escape_heroes_holdtheline(500, pack, 200, 1.1 );
	level.heroes3["grigsby"] thread escape_heroes_holdtheline(400, pack, 150, 1.1 );
	level.heroes3["price"] thread escape_heroes_holdtheline(350, pack, 150, 1.1, true);
	thread player_speed_set( 175, 1);
	
	level endon("mission_failed");
	
	flag_wait( "end_start_player_anim" );
	
	level.player freezeControls(true);
	
	level.fogvalue["near"] = 500;
	level.fogvalue["half"] = 15000;	
	setExpFog (level.fogvalue["near"], level.fogvalue["half"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 10);
	
	dummy = spawn_anim_model( "end_hands" );
	dummy hide();
	heli anim_first_frame_solo( dummy, "player_rescue", "tag_detach" );
	dummy linkto( heli, "tag_detach" );

	time = .25;

	level._sea_org rotateto( (0,0,0), time );
	//turn off the thing that's adjusting the players view
	thread flag_clear_delayed( "_sea_viewbob", time ); 
	
	//spawn camera and link player
	camera = spawn_anim_model( "end_hands" );
	camera hide();
	camera.origin = get_player_feet_from_view();
	camera.angles = level.player getplayerangles();		
	
	
	level.player PlayerLinkToabsolute(camera, "tag_player", 1 );//, 100, 100, 30, 60);
					
	origin = dummy gettagorigin( "tag_player" );
	angles = dummy gettagangles( "tag_player" );
	
	camera moveto( origin, time );
	camera rotateto( angles, time );
	

	wait time;

	camera delete();
	dummy show();
	
	level.player PlayerLinkToabsolute(dummy, "tag_player", 1 );//, 100, 100, 30, 60);
			
	flag_set( "end_linked_player_to_rig" );
	
	node notify( "stop_loop_heli" );
	node thread anim_single_solo( heli, "out");
	price linkto( heli, "tag_detach" );
	heli thread anim_generic( price, "help_price", "tag_detach" );
	heli thread anim_single_solo( dummy, "player_rescue", "tag_detach" );
	
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
	SetSavedDvar( "hud_showStance", 0 );
	//setSavedDvar( "hud_drawhud", "0" );
				
	//THUNDER
		delayThread(.1, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
		delayThread(2, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
		delayThread(5, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
		delayThread(8, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
		delayThread(9, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
		delayThread(12, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
		delayThread(14, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
		delayThread(15, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	
	//we dont set this last flag until we want to clear the objective for getting off the ship.
	
	flag_wait( "gotcha" );
	
	//level.player PlayerLinkToDelta(dummy, "tag_player", 1, 100, 100, 30, 60);
	
	flag_wait( "end_finished" );
		
	thread end_screen();	
}

end_anim_thread()
{
	flag_wait( "escape_seaknight_ready" );

	heli = level.seaknight.model;
	price = level.heroes3[ "price" ];
	
	node = getent("escape_end_anim_node", "targetname");
	
	flag_wait("escape_seaknight_flag");
	heli delayThread(1, ::play_loop_sound_on_entity, "seaknight_idle_high" );
		
	heli thread seaknight_playlightfx();
	node anim_single_solo( heli, "in");	
	if( !flag( "end_price_rescue_anim" ) )
		node thread anim_loop_solo( heli, "idle", undefined, "stop_loop_heli" );
	
	flag_wait( "end_price_rescue_anim" );
	
	if( distance( level.player.origin, price.origin ) < 512 )
		thread escape_player_last_quake();
	
	node notify( "stop_loop_heli" );
		
	node thread anim_single_solo( heli, "drift" );	
	node anim_generic( price, "rescue_price");//, "tag_detach" );
	
	price linkto( heli, "tag_detach" );	
	
	if( !flag( "end_start_player_anim" ) )
	{
		node thread anim_loop_solo( heli, "drift_idle", undefined, "stop_loop_heli" );
		heli thread anim_generic_loop( price, "rescue_price_idle", "tag_detach", "stop_loop_price" );
	}
		
	flag_wait_or_timeout( "end_start_player_anim", 3 );
	
	//if he's pressed the button - then wait for him to be attached to the rig
	if( flag( "end_start_player_anim" ) )
	{
		flag_wait( "end_linked_player_to_rig" );
		return;
	}
	
	flag_set( "end_seaknight_leaving" ); 
	delaythread( 5, ::escape_mission_failed );
	thread play_sound_in_space( "elm_wave_crash_ext", (-3392, 656, -64) );
	thread exploder( 304 );
	
	level.hud_mantle[ "text" ].alpha = 0;
	level.hud_mantle[ "icon" ].alpha = 0;
	
	node notify( "stop_loop_heli" );
	heli notify( "stop_loop_price" );
	node thread anim_single_solo( heli, "out");
}	

escape_heroes_rescue()
{
	self clear_run_anim();
	
	node = getent("escape_end_anim_node", "targetname");
	heli = level.seaknight.model;
	
	anime = "rescue_" + self.script_noteworthy;
	idle = anime + "_idle";
	stop = "stop_loop" + self.script_noteworthy;
	
	if( self.script_noteworthy == "price" )
	{
		node anim_generic_reach(self, "reach_price" );	
	//	node anim_generic( self, anime );//, "tag_detach" );
		flag_set( "end_price_rescue_anim" );
		//flag_wait( "end_start_player_anim" );
		//heli notify( stop );
	}
	else
	{
		node anim_generic_reach(self, anime );	
		node anim_generic( self, anime ); 
		self linkto( heli, "tag_detach" );
		heli thread anim_generic_loop(self, idle, "tag_detach", stop );
	}
}

#using_animtree("vehicles");
escape_seaknight()
{
	flag_wait("escape_hallway_lower_flag");
	
	node = getent("escape_end_anim_node", "targetname");
	
	level.seaknight = seaknight_spawn( node );
	guy = level.heroes5["seat5"];
	guy.animname = guy.script_noteworthy;
	guy linkto( level.seaknight.model, "tag_detach" );
	level.seaknight.model thread anim_loop_solo(guy, "rescue", "tag_detach", "never_stop");
		
	guy = level.heroes5["seat6"];
	guy.animname = guy.script_noteworthy;
	guy linkto( level.seaknight.model, "tag_detach" );
	level.seaknight.model thread anim_loop_solo(guy, "rescue", "tag_detach", "never_stop");
	
	level.seaknight.model UseAnimTree(#animtree);
	level.seaknight.model setanim( %sniper_escape_ch46_rotors );
	
	flag_set( "escape_seaknight_ready" );
}

end_jump()
{
	level endon( "player_rescued" );
	level endon( "end_seaknight_leaving" );
	
	jump = getent( "escape_player_jump", "targetname" );
	level.player NotifyOnCommand( "jump", "+gostand" );
	level.player NotifyOnCommand( "jump", "+moveup" );
	
	jump thread end_jump_mantle();
	
	jump waittill( "trigger" );
	
	while( 1 )
	{		
		level.player waittill( "jump" );
								
		if( level.player istouching( jump ) && level.player getstance() == "stand" && end_mantle_angle() )
			break;
	}
	
	level.hud_mantle[ "text" ].alpha = 0;
	level.hud_mantle[ "icon" ].alpha = 0;
	flag_set( "end_start_player_anim" );
}

end_mantle_angle()
{
	angles = level.player getplayerangles();	
	
	vec1 = anglestoforward( angles );
	vec2 = vectornormalize( level.seaknight.model.origin - level.player.origin );
	
	if( vectordot( vec1, vec2 ) > .75 )
		return true;
	else
		return false;
}

end_jump_mantle()
{
	level endon( "end_start_player_anim" );
	level endon( "end_seaknight_leaving" );
		
	while(1)
	{
		self waittill( "trigger" );
		
		if( end_mantle_angle() )
			level.hud_mantle[ "text" ].alpha = 1;
			level.hud_mantle[ "icon" ].alpha = 1;
		
		while( level.player istouching( self ) && end_mantle_angle() )
			wait .05;
		
		level.hud_mantle[ "text" ].alpha = 0;
		level.hud_mantle[ "icon" ].alpha = 0;
	}	
}

end_nojump()
{
	level endon("player_rescued");
	level endon( "end_seaknight_leaving" );
	
	nojump = getent( "escape_player_nojump", "targetname" );
	
	while(1)
	{
		nojump waittill( "trigger" );
		
		flag_set( "end_no_jump" );
		level.player allowjump( false );	
		
		while( level.player istouching( nojump ) )
			wait .05;
		
		level.player allowjump( true );	
	}
}

end_music()
{
	flag_wait( "cargoship_end_music" );
	musicstop();
	wait 0.1;
	MusicPlayWrapper("cargoship_finale_music");
}

end_dialogue()
{
	grigsby = level.heroes3["grigsby"];
	price	= level.heroes3["price"];
	
	flag_wait("escape_seaknight_flag");
	
	wait 1;
	
	grigsby anim_single_stack( grigsby, "cargoship_grg_whereisit" );
	
	flag_wait( "end_no_jump" );
	//Jump for iiiiit!!!!!!!
	radio_msg_stack("cargoship_gm2_jumpforit");
	
	flag_wait( "end_linked_player_to_rig" );
	wait 3.7;
	thread end_music();
	//radio_msg_stack("cargoship_pri_gotcha");
	flag_set( "gotcha" );
	thread end_sink_ship();
	
	wait 2;
	radio_msg_stack("cargoship_pri_allaboard");
	flag_set( "player_rescued" );
	radio_msg_stack("cargoship_hp3_outtahere");
	radio_msg_stack("cargoship_hp3_returntobase");
	
	flag_set( "end_finished" );
	
	//gotcha
}

escape_dialogue()
{
	grigsby = level.heroes3["grigsby"];
	price	= level.heroes3["price"];
	
	flag_wait("escape_moveup1");
	
	//Wallcroft, Griffen, what's your status?.
	price anim_single_stack( price, "cargoship_pri_status" );
	soundent = spawn( "script_origin", level.player.origin );
	soundent linkto( level.player );
	//Already in the helicopter sir. Enemy aircraft inbound…SHIT! They've opened fire! Get out of there, NOW!!!
	soundent playsound( "cargoship_gm2_aircraftinbound2" );//, "stopsound", true );
	
	flag_wait( "escape_explosion" );
	thread flag_set_delayed("escape_get_to_catwalks", 22.25);

	soundent StopSounds();
	wait 1;
	soundent delete();	
	
	wait 2;
	//Bravo Six! Come in! Bravo Six, what's your status???.
	thread radio_msg_stack("cargoship_hp3_yourstatus");
	wait 4;
	thread radio_msg_stack("cargoship_grg_whathappened");
	wait 4;
	grigsby thread anim_single_stack( grigsby, "cargoship_grg_shipssinking" );
	wait 3.5;
	thread radio_msg_stack("cargoship_hp3_comein");
	
	price delaythread(10, ::anim_single_stack, price, "cargoship_pri_gettocatwalks" );
	//Move your asses!!!!! Go!!!!
	grigsby delayThread(11, ::anim_single_stack, grigsby, "cargoship_grg_movego" );
		
	
	
	
	flag_wait( "escape_dialogue1" );
	
	
	
	//Back on your feet!!!! Let's go!!!!.
	price delaythread(.5, ::anim_single_stack, price, "cargoship_pri_backonfeet" );
	//Watch your head!!!!.
	delaythread(5, ::radio_msg_stack, "cargoship_gm1_watchyerhead" );

	flag_wait( "escape_dialogue2" );
	//Go! Go!!! Keep moviiiing!!!
	grigsby thread anim_single_stack(grigsby, "cargoship_grg_keepmoving");
				
	flag_wait("escape_catwalk");
	//it's breaking away!
	grigsby thread anim_single_stack(grigsby, "cargoship_grg_breakinaway");
	//come on, come on!
	price thread anim_single_stack(price, "cargoship_pri_comeoncomeon");
	
	flag_wait("escape_hallway_lower_enter");
	flag_clear("hallways_lowerhall2");
	//Watch the pipes!!!!.
	grigsby delaythread(1, ::anim_single_stack, grigsby, "cargoship_grg_watchpipes" );
	
	flag_wait("hallways_lowerhall2");
	//Talk to me Bravo Six, where the hell are you?!.	
	radio_msg_stack("cargoship_hp3_talktome");
	//Standby. We're almost there!.
	price anim_single_stack( price, "cargoship_pri_almostthere" );
		
	
	flag_wait("escape_hallway_lower_flag");	
	//Which waaaay?! Which way to the helicopter?!!.
	radio_msg_stack("cargoship_gm1_whichway");
	//To the right to the right!!!!.
	price anim_single_stack( price, "cargoship_pri_totheright" );	
	
	flag_wait("escape_hallway_upper_flag");
	//We're runnin' outta time!!!! Come on!!! Let's go!!!!.
	grigsby anim_single_stack( grigsby, "cargoship_grg_outtatime" );
	//Keep moving!!!!
	price delayThread(2, ::anim_single_stack, price, "cargoship_pri_keepmoving" );
}

end_sink_ship()
{
	level._sea_link movez(550, .5);	
	level._sea_org movez(550, .5);
	
	angle = (-10, 0, -40);
	
	level._sea_link rotateto( angle, .5);	
	level._sea_org rotateto( angle, .5);	
	
	wait .5;
	
	level._sea_link movez(1400, 15);	
	level._sea_org movez(1400, 15);	
}

end_screen()
{
	black_overlay = create_overlay_element( "black", 0 );
	black_overlay.sort = 3;
	//iw = create_credit_element( "credits_iw_presents" );
		
	level.player shellshock("cargoship", 50);	
	black_overlay exp_fade_overlay( 1, 4 );
	
	
	level.intro_offset = 0;
	lines = [];
	lines[ lines.size ] = &"CARGOSHIP_INFINITY_WARD_PRESENTS";
	
	for ( i=0; i < lines.size; i++ )
	{
		interval = 1;
		time = ( i * interval ) + 1;
		delayThread( time, ::centerLineThread, lines[ i ], ( lines.size - i - 1 ), interval );
	}	
	
	wait 5.5;
	
	cod4 = create_credit_element( "credits_cod4" );
	cod4.sort = 4;
	
	cod4 exp_fade_overlay( 1, 3 );
	
	wait 5;
	
	cod4 exp_fade_overlay( 0, 4 );
		
	flag_set( "end_screen_done" );
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 				  	MISC LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

misc_dummy()
{
	level._sea_scale = 1.5;
}

misc_setup()
{
	array_thread(getstructarray("spotlights","targetname"), ::misc_spotlight_fx);	
	array_thread(getstructarray("floorlights","targetname"), ::misc_floorlight_fx);
	array_thread(getentarray("fx_handler", "targetname"), ::misc_fx_handler_trig);
	thread misc_fx_handlers();
	thread misc_radar();	
	array_thread(getentarray("vision_change","targetname"), ::misc_vision);	
	array_thread(getentarray("tv","targetname"), ::misc_tv);
	array_thread(getentarray("tv","targetname"), ::misc_tv_stairs_on);
	array_thread(getentarray("light_flicker","targetname"), ::misc_light_flicker, undefined, "topside_fx");
	array_thread(getentarray("light_cargohold","targetname"), ::misc_light_sway);
	
	array_thread(getentarray("escape_flags","script_noteworthy"), ::trigger_off);
	
	array_thread(getentarray("sink_waterlevel","targetname"), ::misc_setup_waterlevel );
	
	stairblocker = getent( "escape_stair_blocker", "targetname" );
	stairblocker connectpaths();
	stairblocker hide();
	stairblocker notsolid();
	
	player_end_water_clip = getent( "player_end_water_clip", "targetname" );
	player_end_water_clip notsolid();
	
	liteent 	= getent("cargohold1_utilitylight","targetname");
	litemodel	= getent("cargohold1_utilitylight_model", "targetname");
	
	liteent thread cargohold_1_light_sway( litemodel );
	
	water = getentarray("sink_waterlevel","targetname");
	for(i=0; i<water.size; i++)
		water[i] hide();
	
	bigcontainerend = getent("escape_first_fallen_container","targetname");
	bigcontainerend notsolid();
	bigcontainerend hide();
	bigcontainerend connectpaths();
	
	blockerend = getentarray("escape_big_blocker","targetname");
	for(i=0; i< blockerend.size; i++)
	{
		blockerend[i] hide();
		blockerend[i] notsolid();
		if(blockerend[i].spawnflags & 1)
			blockerend[i] connectpaths();
	}
	
	panels = getentarray("cargohold_debri", "targetname");
	for(i=0; i< panels.size; i++)
	{
		if( !isdefined( panels[i].target ) )	
			continue;
		model = getent( panels[i].target, "targetname" );
		model hide();
	}
	
	escapefx = getfxarraybyID( "sparks_runner" );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_waternoise" ) );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_waternoise_ud" ) );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_waterdrips" ) );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_water_drip_stairs" ) );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_water_gush_stairs" ) );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_caustics" ) );
	
	for(i=0; i<escapefx.size; i++)
		escapefx[i] delayThread(.1, ::pauseEffect);
	
	pipes = getentarray("escape_pipe","script_noteworthy");
	for(i=0; i< pipes.size; i++)
		pipes[i] hide();
	
	containers = getentarray("escape_container", "targetname");
	for(i=0; i<containers.size; i++)
	{
		target = getent(containers[ i ].target, "targetname");
		target hide();	
		target notsolid();
	}
	
	node = getent( "package_dooranim_node" , "targetname" );
	node2 = spawn("script_origin", node.origin + (0,0,10) );
	node2.angles = node.angles;
	thread package_open_doors( node2 );
	array_thread( getentarray( "no_prone", "targetname" ), ::player_noprone );
	
	hint_setup();	
}

misc_setup_waterlevel()
{
	array_thread(getstructarray(self.target, "targetname"), ::escape_waterlevel_parts, self);
	wait 1;
	self geo_off();
	
}

misc_fx_handlers()
{
	wait .1; 
	allcargoholdfx	= getfxarraybyID( "cargo_vl_red_thin" );
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_soft" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_eql" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_eql_flare" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_sml" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_sml_a" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_red_lrg" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_steam" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_steam_add" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "chains" ));
	
	alltopsidefx 	= getfxarraybyID( "rain_noise" );
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "rain_noise_ud" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_lights_cr" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_lights_flr" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_drips" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgoshp_drips_a" ));
	alltopsidefx 	= array_combine(alltopsidefx, getfxarraybyID( "cgo_ship_puddle_small" ));
			
	while(1)
	{
		if(flag("cargohold_fx"))
		{
			for(i=0; i<alltopsidefx.size; i++)
				alltopsidefx[i] pauseEffect();
			for(i=0; i<allcargoholdfx.size; i++)
				allcargoholdfx[i] restartEffect();
			
			flag_clear("_sea_waves");
			
			thread maps\_weather::rainNone(1);
			thread misc_hidesea();
			maps\_compass::setupMiniMap( "compass_map_cargoship_2" );
			thread maps\_utility::set_ambient("interior");
			
			flag_wait("topside_fx");
		}
		if(flag("topside_fx"))
		{
			for(i=0; i<allcargoholdfx.size; i++)
				allcargoholdfx[i] pauseEffect();
			for(i=0; i<alltopsidefx.size; i++)
				alltopsidefx[i] restartEffect();
				
			if(level.jumpto != "start" || flag("quarters"))
				flag_set("_sea_waves");
			
			thread maps\_weather::rainHard(1);
			thread misc_showsea();
			maps\_compass::setupMiniMap( "compass_map_cargoship" );
			thread maps\_utility::set_ambient("exterior");
			
			flag_wait("cargohold_fx");
		}	
	}
}

misc_hidesea()
{
	level.sea_model hide();
	wait .05;
	level.sea_black hide();
}
misc_showsea()
{
	level.sea_model show();
	level.sea_black show();
}

misc_radar()
{
	radar = getent("radar","targetname");
	time = 5000;
	
	while(1)
	{
		radar rotatevelocity((0,120,0), time);	
		wait time;
	}
}

misc_floorlight_fx()
{
	ent = createOneshotEffect("cgoshp_lights_flr");
 	ent.v["origin"] = (self.origin);
	ent.v["angles"] = (self.angles);
 	ent.v["fxid"] = "cgoshp_lights_flr";
 	ent.v["delay"] = -15;	
}

misc_spotlight_fx()
{
	ent = createOneshotEffect("cgoshp_lights_cr");
	ent.v["origin"] = (self.origin);
	ent.v["angles"] = (self.angles);
	ent.v["fxid"] = "cgoshp_lights_cr";
	ent.v["delay"] = -15;
}

misc_precacheInit()
{
	//level.strings["obj_alassad"] 		= &"DESCENT_OBJ_ALASSAD";
	//precacheString(level.strings["obj_alassad"]);
	
	level.strings["intro1"]				= &"CARGOSHIP_TITLE";	
	level.strings["intro2"]				= &"CARGOSHIP_DATE";
	level.strings["intro3"]				= &"CARGOSHIP_PLACE";
	level.strings["intro4"]				= &"CARGOSHIP_INFO";
	
	level.strings["hint_laptop"]		= &"CARGOSHIP_LAPTOP_HINT";
	level.strings["obj_package"]		= &"CARGOSHIP_OBJ_PACKAGE";
	level.strings["obj_laptop"]			= &"CARGOSHIP_OBJ_LAPTOP";
	level.strings["obj_exit"]			= &"CARGOSHIP_OBJ_EXIT";
	
	level.strings["mantle"]				= &"CARGOSHIP_MANTLE";
	
	keys = getarraykeys(level.strings);
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		precacheString(level.strings[ key ]);	
	}
	
	precacheItem("rpg");
	precacheItem("rpg_straight");
	precacheItem("facemask");
	precacheTurret("heli_spotlight");
	precacheTurret("heli_minigun_noai");
	precacheModel("vehicle_blackhawk_hero_sas_night");
	precacheModel("vehicle_ch46e_opened_door_interior");
	precacheModel("tag_flash");
	precacheModel("tag_origin");
	precacheModel("weapon_saw_MG_setup");
	precacheModel("com_blackhawk_spotlight_on_mg_setup");
	precacheModel("weapon_minigun");
	precachemodel("prop_price_cigar");
	precachemodel("ch_industrial_light_02_off");
	precachemodel("com_lightbox");
	precachemodel("me_lightfluohang");
	precachemodel("com_flashlight_on");
	precachemodel("cs_vodkabottle01");
	precachemodel("cs_coffeemug01");
	precachemodel("com_clipboard_wpaper_obj");
	precacheshellshock("cargoship");
	precacheShader( "overlay_hunted_red" );
	precacheShader( "overlay_hunted_black" );
	precacheShader( "credits_iw_presents" );
	precacheShader( "credits_cod4" );
	precacherumble ( "tank_rumble" );
	precacherumble ( "damage_heavy" );
	
	precachemodel("me_ac_window" );
	precachemodel("com_fire_extinguisher" );
	precachemodel("com_pipe_4_coupling_ceramic" );
	precachemodel("com_pipe_coupling_metal" );
	precachemodel("me_plastic_crate3" );
	precachemodel("me_plastic_crate10" );
	precachemodel("me_plastic_crate1" );
	precachemodel("me_plastic_crate4" );
	precachemodel("me_plastic_crate9" );
	precachemodel("com_pot_metal" );
	precachemodel("com_soup_can" );
	precachemodel("com_milk_carton" );
	precachemodel("me_plastic_crate6" );
	precachemodel("com_pail_metal1" );
	precachemodel("com_pan_copper" );
	precachemodel("com_propane_tank" );
	precachemodel("com_plastic_bucket" );
	precachemodel("cargoship_water");
	precachemodel("cargoship_water_black");
	precachemodel("cargoship_water_static");
	precachemodel("cargoship_water_black_static");
	precachemodel( "body_complete_sp_sas_ct_price_maskup" );
	precacheshader( "hint_mantle" );
	precachemodel( "cs_container_door_joint" );
	precachemodel( "weapon_mp5_clip" );
	
	precacheshader( "popmenu_bg" );
	precachestring( &"CARGOSHIP_HINT_FRAG" );
	precachestring( &"CARGOSHIP_HINT_CROUCH_STANCE" );
	precachestring( &"CARGOSHIP_HINT_CROUCH" );
	precachestring( &"CARGOSHIP_HINT_CROUCH_TOGGLE" );
	precachestring( &"CARGOSHIP_HINT_STAND" );
	precachestring( &"CARGOSHIP_HINT_STAND_STANCE" );
	
	
	level.misc_tv_damage_fx["tv_explode"] = loadfx ("explosions/tv_explosion");	
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	OBJECTIVE LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
objective_main()
{
	objnum = 1;

	if(level.jumpto != "start")
	{
		objective_add(objnum, "active", level.strings["obj_package"], (3052, 15, 407) );
		objective_current(objnum);	
	}

	switch(level.jumpto)
	{
		case "start":
			flag_wait("at_bridge");
		case "bridge":{
			objective_add(objnum, "active", level.strings["obj_package"], (3052, 15, 407) );
			objective_current(objnum);	
	
			level waittill("bridge_secured");
			objective_position(objnum, ( 2640, 624, 208 ) );
			
			flag_wait("deck");
			}
		case "deck":{
			objective_position(objnum, ( -2116, 0, 80 ) );
			flag_wait("hallways_moveup");
			}
		case "hallways":{
			objective_position(objnum, ( -2506, -496, 96 ) );
			flag_wait("hallways_enter");
			objective_position(objnum, ( -2806, -122, 96 ) );
			flag_wait("hallways_stairs");
			objective_position(objnum, ( -3292, -248, -65 ) );
			flag_wait("hallways_bottom_stairs");
			}
		case "cargohold":{
			}
		case "cargohold2":{
			}
		case "laststand":{
			}
		case "package":{
			thread objective_laptop();
			objective_position(objnum, ( 2254, 197, -320 ) );
			flag_set("package_reading");
			objective_position(objnum, ( 2254, 197, -320 ) );
			flag_wait("package_orders");
			objective_state(objnum, "done");
			objnum++;
			trig = getent("objective_package", "targetname");
			waittillframeend;//so that the trigger can be trigger_on'ed so it's origin is correct
			objective_add(objnum, "active", level.strings["obj_laptop"], trig getorigin() );
			objective_current(objnum);	
			flag_wait("package_secure");
			}
		case "escape":{
			}
		case "end":{
			objective_state(objnum, "done");
			objnum++;
			objective_add(objnum, "active", level.strings["obj_exit"] );
			thread objective_price( objnum );
			objective_current(objnum);	
			flag_wait("player_rescued");
			arcadeMode_stop_timer();
			objective_state(objnum, "done");
			
			flag_wait( "end_screen_done" );
			nextmission();
			}
	}	
}

objective_price( objnum )
{
	flag_wait("heroes_ready");
	
	level endon("player_rescued");
	
	while( 1 )
	{
		objective_position( objnum, level.heroes3[ "price" ].origin );
		wait .05;
	}	
}

objective_laptop_nag()
{
	level endon("package_secure");
	
	trigs = getentarray("escape_flags", "script_noteworthy");
	for(i=0; i<trigs.size; i++)
	{
		if( !isdefined( trigs[i].script_flag ) || trigs[i].script_flag != "escape_gotlaptop" )
			continue;
		
		trigs[i] trigger_on();
		break;
	}
	
	flag_wait_or_timeout("escape_gotlaptop", 10);
	line = 1;
	price = level.heroes3[ "price" ];
	while(1)
	{
		//nag
		switch(line)
		{
			case 1:
				//Mac, get that camcorder! Hurry!.
				anim_single_stack( price, "cargoship_pri_macgetmanifest" );
				break;
			case 2:
				//Mac! Grab the camcorder off the table and let's get out of here!.
				anim_single_stack( price, "cargoship_pri_donthavetime" );
				anim_single_stack( price, "cargoship_pri_getmanifest" );
				break;	
			case 3:
				//Mac! Grab the camcorder off the table and let's get out of here!.
				anim_single_stack( price, "cargoship_pri_gottamove" );
				anim_single_stack( price, "cargoship_pri_manifestletsgo" );
				break;
		}
		line++;
		if( line > 3 )
			line = 1;
		wait 10;
	}
}

objective_laptop()
{
	trig = getent("objective_package", "targetname");
	trig trigger_off();	
	
	flag_wait("package_orders");
	
	thread objective_laptop_nag();
	
	trig trigger_on();	
	trig setHintString ( level.strings["hint_laptop"] );
	trig usetriggerrequirelookat();
	
	model = getent(trig.target, "targetname");
	obj = spawn("script_model", model.origin + (-0.1, 0.1, 0.1));
	obj.angles = model.angles;
	obj setmodel("com_clipboard_wpaper_obj");
	
	trig waittill("trigger");
	
	thread play_sound_in_space( "intelligence_pickup_clipboard", obj.origin );
	
	model delete();
	obj delete();
	trig delete();
	flag_set("package_secure");
}

objective_move(name, objnum, check, msg)
{
	if(isdefined(check) && level.jumpto != check)
		return;
	
	if(!isdefined(level.objective_position))
		level.objective_position = [];
	
	if(isdefined(msg))
		level waittill(msg);
		
	level notify("objective_move_" + objnum);
	level endon("objective_move_" + objnum);
	
	trig = getent("objective_move_" + name, "targetname");
	
	while(isdefined(trig))
	{
		objective_position(objnum, trig.origin);
		level.objective_position[objnum] = trig.origin;
		trig waittill("trigger");
		if(!isdefined(trig.target))
			trig = undefined;
		else
			trig = getent(trig.target, "targetname");	
	}
}
