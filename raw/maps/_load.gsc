#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;

main( bScriptgened, bCSVgened, bsgenabled )
{
	set_early_level();
	
	animscripts\weaponList::precacheclipfx();
	
	if ( !isdefined( level.script_gen_dump_reasons ) )
		level.script_gen_dump_reasons = [];
	if ( !isdefined( bsgenabled ) )
		level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "First run";
	if ( !isdefined( bCSVgened ) )
		bCSVgened = false;
	level.bCSVgened = bCSVgened;
	
	if ( !isdefined( bScriptgened ) )
		bScriptgened = false;
	else
		bScriptgened = true;
	level.bScriptgened = bScriptgened;
	
	 /# star( 4 + randomint( 4 ) ); #/ 

	if ( getDvar( "debug" ) == "" )
		setDvar( "debug", "0" );

	if ( getDvar( "fallback" ) == "" )
		setDvar( "fallback", "0" );

	if ( getDvar( "angles" ) == "" )
		setDvar( "angles", "0" );

	if ( getDvar( "noai" ) == "" )
		setDvar( "noai", "off" );

	if ( getDvar( "scr_RequiredMapAspectratio" ) == "" )
		setDvar( "scr_RequiredMapAspectratio", "1" );

	createPrintChannel( "script_debug" );


	if ( !isdefined( anim.notetracks ) )
	{
		// string based array for notetracks
		anim.notetracks = [];
		animscripts\shared::registerNoteTracks();
	}
	
	level._loadStarted = true;
	level.first_frame = true;
	level.level_specific_dof = false;
	thread remove_level_first_frame();

	level.wait_any_func_array = [];
	level.run_func_after_wait_array = [];
	level.do_wait_endons_array = [];
	
	level.script = tolower( getdvar( "mapname" ) );
	level.player = getent( "player", "classname" );
	level.player.a = spawnStruct();
	level.radiation_totalpercent = 0;

	flag_init( "missionfailed" );
	flag_init( "auto_adjust_initialized" );
	flag_init( "global_hint_in_use" );
	flag_init( "_radiation_poisoning" );
	thread maps\_gameskill::aa_init_stats();
	thread player_death_detection();

	level.default_run_speed = 190;
	setSavedDvar( "g_speed", level.default_run_speed );
	
	if ( !arcadeMode() )
		setSavedDvar( "sv_saveOnStartMap", true );
	else
	{
		setSavedDvar( "sv_saveOnStartMap", false);
		thread arcademode_save();
	}

	level.dronestruct = [];
	struct_class_init();
	
	if ( !isdefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}
	else
	{
		// flags initialized before this should be checked for stat tracking
		flags = getarraykeys( level.flag );
		array_levelthread( flags, ::check_flag_for_stat_tracking );
	}
	
	// can be turned on and off to control friendly_respawn_trigger
	flag_init( "respawn_friendlies" );
	flag_init( "player_flashed" );
	
	// for script gen
	flag_init( "scriptgen_done" );
	level.script_gen_dump_reasons = [];
	if ( !isdefined( level.script_gen_dump ) )
	{
		level.script_gen_dump = [];
		level.script_gen_dump_reasons[ 0 ] = "First run";
	}

	if ( !isdefined( level.script_gen_dump2 ) )
		level.script_gen_dump2 = [];
		
	if ( isdefined( level.createFXent ) )
		script_gen_dump_addline( "maps\\createfx\\" + level.script + "_fx::main();", level.script + "_fx" ); // adds to scriptgendump
		
	if ( isdefined( level.script_gen_dump_preload ) )
		for ( i = 0;i < level.script_gen_dump_preload.size;i ++ )
			script_gen_dump_addline( level.script_gen_dump_preload[ i ].string, level.script_gen_dump_preload[ i ].signature );

	level.player.maxhealth = level.player.health;
	level.player.shellshocked = false;
	level.aim_delay_off = false;
	level.player.inWater = false;
	level.last_wait_spread = -1;
	level.last_mission_sound_time = -5000;
	level.hero_list = [];
	thread precache_script_models();

// 	level.ai_array = [];
	
	level.player thread maps\_utility::flashMonitor();
	level.player thread maps\_utility::shock_ondeath();
// 	level.player thread ai_eq();
// 	level.player thread maps\_spawner::setup_ai_eq_triggers();
// 	level.eq_trigger_num = 0;
// 	level.eq_trigger_table = [];
// 	level.touched_eq_function[ true ] = ::player_touched_eq_trigger;
// 	level.touched_eq_function[ false ] = ::ai_touched_eq_trigger;

 /#
	precachemodel( "fx" );
// 	precachemodel( "temp" );
#/ 	
	precachemodel( "tag_origin" );
	precacheShellshock( "victoryscreen" );
	precacheShellshock( "default" );
	precacheShellshock( "flashbang" );
	precacheShellshock( "dog_bite" );
	precacheRumble( "damage_heavy" );
	precacheRumble( "damage_light" );
	precacheRumble( "grenade_rumble" );
	precacheRumble( "artillery_rumble" );
	
	precachestring( &"GAME_GET_TO_COVER" );
	precachestring( &"SCRIPT_GRENADE_DEATH" );
	precachestring( &"SCRIPT_GRENADE_SUICIDE_LINE1" );
	precachestring( &"SCRIPT_GRENADE_SUICIDE_LINE2" );
	precachestring( &"SCRIPT_EXPLODING_VEHICLE_DEATH" );
	precachestring( &"SCRIPT_EXPLODING_BARREL_DEATH" );
	precacheShader( "hud_grenadeicon" );
	precacheShader( "hud_grenadepointer" );
	precacheShader( "hud_burningcaricon" );
	precacheShader( "hud_burningbarrelicon" );

	level.createFX_enabled = ( getdvar( "createfx" ) != "" );
		
	maps\_cheat::init();
		
	maps\_mgturret::main();
	maps\_mgturret::setdifficulty();
	
	setupExploders();
	maps\_art::main();
	thread maps\_vehicle::init_vehicles();	

	maps\_anim::init();

	thread maps\_createfx::fx_init();
	if ( level.createFX_enabled )
		maps\_createfx::createfx();
	
	maps\_detonategrenades::init();
	
	thread setup_simple_primary_lights();
	
	// --------------------------------------------------------------------------------
	// ---- PAST THIS POINT THE SCRIPTS DONT RUN WHEN GENERATING REFLECTION PROBES ----
	// --------------------------------------------------------------------------------
	/#	
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		maps\_global_fx::main();
		level waittill( "eternity" );
	}
	#/
	thread handle_starts();
		
	if ( getDvar( "g_connectpaths" ) == "2" )
	{
		 /# printLn( "g_connectpaths == 2; halting script execution" ); #/ 
		level waittill( "eternity" );
	}

	printLn( "level.script: ", level.script );

	maps\_autosave::main();
	if ( !isdefined( level.animSounds ) )
		thread maps\_debug::init_animSounds();
	maps\_anim::init();
	maps\_ambient::init();

	// lagacy... necessary?
	anim.useFacialAnims = false;

	if ( !isdefined( level.missionfailed ) )
		level.missionfailed = false;
	
	maps\_gameskill::setSkill();
	maps\_loadout::init_loadout();
	maps\_destructible::main();
	SetObjectiveTextColors();
	
	// global effects for objects
	maps\_global_fx::main();
	
	//thread devhelp();// disabled due to localization errors
	
	setSavedDvar( "ui_campaign", level.campaign );// level.campaign is set in maps\_loadout::init_loadout

	 /#
	thread maps\_debug::mainDebug();
	#/ 
	thread maps\_introscreen::main();
	thread maps\_quotes::main();
//	thread maps\_minefields::main();
	thread maps\_shutter::main();
// 	thread maps\_breach::main();
//	thread maps\_inventory::main();
// 	thread maps\_photosource::main();
	thread maps\_endmission::main();
//	thread maps\_damagefeedback::init();
	maps\_friendlyfire::main();

	// For _anim to track what animations have been used. Uncomment this locally if you need it.
// 	thread usedAnimations();

	array_levelthread( getentarray( "badplace", "targetname" ), ::badplace_think );
	array_levelthread( getentarray( "delete_on_load", "targetname" ), ::deleteEnt );
	array_thread( getnodearray( "traverse", "targetname" ), ::traverseThink );
	/# array_thread( getnodearray( "deprecated_traverse", "targetname" ), ::deprecatedTraverseThink ); #/
	array_thread( getentarray( "piano_key", "targetname" ), ::pianoThink );
	array_thread( getentarray( "piano_damage", "targetname" ), ::pianoDamageThink );
	array_thread( getentarray( "water", "targetname" ), ::waterThink );
	array_thread( getentarray( "ammo_pickup_grenade_launcher", "targetname" ), ::ammo_pickup, "grenade_launcher" );
	array_thread( getentarray( "ammo_pickup_rpg", "targetname" ), ::ammo_pickup, "rpg" );
	array_thread( getentarray( "ammo_pickup_c4", "targetname" ), ::ammo_pickup, "c4" );
	array_thread( getentarray( "ammo_pickup_claymore", "targetname" ), ::ammo_pickup, "claymore" );
	
	thread maps\_interactive_objects::main();
	thread maps\_intelligence::main();
	
	thread maps\_gameskill::playerHealthRegen();
	thread playerDamageRumble();
	
	thread player_special_death_hint();

	// this has to come before _spawner moves the turrets around
	thread massNodeInitFunctions();
	
	// Various newvillers globalized scripts
	flag_init( "spawning_friendlies" );
	flag_init( "friendly_wave_spawn_enabled" );
	flag_clear( "spawning_friendlies" );
	
	level.friendly_spawner[ "rifleguy" ] = getentarray( "rifle_spawner", "script_noteworthy" );			
	level.friendly_spawner[ "smgguy" ] = getentarray( "smg_spawner", "script_noteworthy" );
	level.spawn_funcs = [];
	level.spawn_funcs[ "allies" ] = [];
	level.spawn_funcs[ "axis" ] = [];
	level.spawn_funcs[ "neutral" ] = [];
	thread maps\_spawner::goalVolumes();
	thread maps\_spawner::friendlyChains();
	thread maps\_spawner::friendlychain_onDeath();

// 	array_thread( getentarray( "ally_spawn", "targetname" ), maps\_spawner::squadThink );
	array_thread( getentarray( "friendly_spawn", "targetname" ), maps\_spawner::friendlySpawnWave );
	array_thread( getentarray( "flood_and_secure", "targetname" ), maps\_spawner::flood_and_secure );
	
	// Do various things on triggers
	array_thread( getentarray( "ambient_volume", "targetname" ), maps\_ambient::ambientVolume );

	level.trigger_hint_string = [];
	level.trigger_hint_func = [];
	if ( !isdefined( level.trigger_flags ) )
	{
		// may have been defined by AI spawning
		init_trigger_flags();
	}

	trigger_funcs = [];
	trigger_funcs[ "camper_spawner" ] = maps\_spawner::camper_trigger_think;
	trigger_funcs[ "flood_spawner" ] = maps\_spawner::flood_trigger_think;
	trigger_funcs[ "trigger_spawner" ] = maps\_spawner::trigger_spawner;
	trigger_funcs[ "friendly_wave" ] = maps\_spawner::friendly_wave;
	trigger_funcs[ "friendly_wave_off" ] = maps\_spawner::friendly_wave;
	trigger_funcs[ "friendly_mgTurret" ] = maps\_spawner::friendly_mgTurret;
	trigger_funcs[ "trigger_autosave" ] = maps\_autosave::trigger_autosave;
	trigger_funcs[ "autosave_now" ] = maps\_autosave::autosave_now_trigger;
	trigger_funcs[ "trigger_unlock" ] = ::trigger_unlock;
	trigger_funcs[ "trigger_lookat" ] = ::trigger_lookat;
	trigger_funcs[ "trigger_looking" ] = ::trigger_looking;
	trigger_funcs[ "trigger_cansee" ] = ::trigger_cansee;
	trigger_funcs[ "autosave_immediate" ] = maps\_autosave::trigger_autosave_immediate;
	trigger_funcs[ "flag_set" ] = ::flag_set_trigger;
	trigger_funcs[ "flag_set_player" ] = ::flag_set_player_trigger;
	trigger_funcs[ "flag_unset" ] = ::flag_unset_trigger;
	trigger_funcs[ "flag_clear" ] = ::flag_unset_trigger;
	trigger_funcs[ "random_spawn" ] = maps\_spawner::random_spawn;
	trigger_funcs[ "objective_event" ] = maps\_spawner::objective_event_init;
// 	trigger_funcs[ "eq_trigger" ] = ::eq_trigger;
	trigger_funcs[ "friendly_respawn_trigger" ] = ::friendly_respawn_trigger;
	trigger_funcs[ "friendly_respawn_clear" ] = ::friendly_respawn_clear;
	trigger_funcs[ "radio_trigger" ] = ::radio_trigger;
	trigger_funcs[ "trigger_ignore" ] = ::trigger_ignore;
	trigger_funcs[ "trigger_pacifist" ] = ::trigger_pacifist;
	trigger_funcs[ "trigger_delete" ] = ::trigger_turns_off;
	trigger_funcs[ "trigger_delete_on_touch" ] = ::trigger_delete_on_touch;
	trigger_funcs[ "trigger_off" ] = ::trigger_turns_off;
	trigger_funcs[ "trigger_outdoor" ] = maps\_spawner::outdoor_think;
	trigger_funcs[ "trigger_indoor" ] = maps\_spawner::indoor_think;
	trigger_funcs[ "trigger_hint" ] = ::trigger_hint;
	trigger_funcs[ "trigger_grenade_at_player" ] = ::throw_grenade_at_player_trigger;
	trigger_funcs[ "two_stage_spawner" ] = maps\_spawner::two_stage_spawner_think;
	trigger_funcs[ "flag_on_cleared" ] = maps\_load::flag_on_cleared;
	trigger_funcs[ "flag_set_touching" ] = ::flag_set_touching;
	trigger_funcs[ "delete_link_chain" ] = ::delete_link_chain;
	trigger_funcs[ "trigger_fog" ] = ::trigger_fog;
	

	trigger_funcs[ "no_crouch_or_prone" ] = ::no_crouch_or_prone_think;
	trigger_funcs[ "no_prone" ] = ::no_prone_think;
	


	// trigger_multiple and trigger_radius can have the trigger_spawn flag set
	trigger_multiple = getentarray( "trigger_multiple", "classname" );
	trigger_radius = getentarray( "trigger_radius", "classname" );
	triggers = array_merge( trigger_multiple, trigger_radius );

	for ( i = 0; i < triggers.size; i ++ )
	{
		if ( triggers[ i ].spawnflags & 32 )
			thread maps\_spawner::trigger_spawner( triggers[ i ] );
	}

	for ( p = 0;p < 6;p ++ )
	{
		switch( p )
		{
			case 0:
				triggertype = "trigger_multiple";
				break;

			case 1:
				triggertype = "trigger_once";
				break;

			case 2:
				triggertype = "trigger_use";
				break;
				
			case 3:	
				triggertype = "trigger_radius";
				break;
			
			case 4:	
				triggertype = "trigger_lookat";
				break;

			default:
				assert( p == 5 );
				triggertype = "trigger_damage";
				break;
		}

		triggers = getentarray( triggertype, "classname" );

		for ( i = 0;i < triggers.size;i ++ )
		{
			if ( isdefined( triggers[ i ].target ) )
				level thread maps\_spawner::trigger_spawn( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_flag_true ) )
				level thread script_flag_true_trigger( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_flag_false ) )
				level thread script_flag_false_trigger( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_autosavename ) || isdefined( triggers[ i ].script_autosave ) )
				level thread maps\_autosave::autoSaveNameThink( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_fallback ) )
				level thread maps\_spawner::fallback_think( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_mgTurretauto ) )
				level thread maps\_mgturret::mgTurret_auto( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_killspawner ) )
				level thread maps\_spawner::kill_spawner( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_emptyspawner ) )
				level thread maps\_spawner::empty_spawner( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_prefab_exploder ) )
				triggers[ i ].script_exploder = triggers[ i ].script_prefab_exploder;

			if ( isdefined( triggers[ i ].script_exploder ) )
				level thread maps\_load::exploder_load( triggers[ i ] );

			if ( isdefined( triggers[ i ].ambient ) )
				triggers[ i ] thread maps\_ambient::ambient_trigger();

			if ( isdefined( triggers[ i ].script_triggered_playerseek ) )
				level thread triggered_playerseek( triggers[ i ] );
				
			if ( isdefined( triggers[ i ].script_bctrigger ) )
				level thread bctrigger( triggers[ i ] );

			if ( isdefined( triggers[ i ].script_trigger_group ) )
				triggers[ i ] thread trigger_group();

			if ( isdefined( triggers[ i ].script_random_killspawner ) )
				level thread maps\_spawner::random_killspawner( triggers[ i ] );

			if ( isdefined( triggers[ i ].targetname ) )
			{
				// do targetname specific functions
				targetname = triggers[ i ].targetname;
				if ( isdefined( trigger_funcs[ targetname ] ) )
				{
					level thread [[ trigger_funcs[ targetname ] ]]( triggers[ i ] );
				}
			}
		}
	}
	
	level.ai_number = 0;
	level.shared_portable_turrets = [];
	maps\_spawner::main();
//	array_thread( getentarray( "misc_turret", "classname" ), ::mg42ModelReplace );

	// for cobrapilot extended visible distance and potentially others, stretch that horizon! - nate
	// origin of prefab is copied manually by LD to brushmodel contained in the prefab, no real way to automate this AFAIK
	array_thread( getentarray( "background_block", "targetname" ), ::background_block );

	maps\_hud::init();
	// maps\_hud_weapons::init();

	thread load_friendlies();
	
// 	level.player thread stun_test();
	level.player thread maps\_detonategrenades::watchGrenadeUsage(); // handles c4 / claymores with special script - nate
	
	thread maps\_animatedmodels::main();
	thread maps\_cagedchickens::initChickens();
	script_gen_dump();
	thread weapon_ammo();
	thread filmy();
}


set_early_level()
{
	level.early_level = [];
	level.early_level[ "killhouse" ] = true;
	level.early_level[ "cargoship" ] = true;
	level.early_level[ "coup" ] = true;
	level.early_level[ "blackout" ] = true;
	level.early_level[ "armada" ] = true;
	level.early_level[ "bog_a" ] = false;
	level.early_level[ "hunted" ] = false;
	level.early_level[ "ac130" ] = false;
	level.early_level[ "bog_b" ] = false;
	level.early_level[ "airlift" ] = false;
	level.early_level[ "aftermath" ] = false;
	level.early_level[ "village_assault" ] = false;
	level.early_level[ "scoutsniper" ] = false;
	level.early_level[ "sniperescape" ] = false;
	level.early_level[ "village_defend" ] = false;
	level.early_level[ "ambush" ] = false;
	level.early_level[ "icbm" ] = false;
	level.early_level[ "launchfacility_a" ] = false;
	level.early_level[ "launchfacility_b" ] = false;
	level.early_level[ "jeepride" ] = false;
	level.early_level[ "airplane" ] = false;
}

setup_simple_primary_lights()
{
	flickering_lights = getentarray ( "generic_flickering", "targetname" );	
	pulsing_lights = getentarray ( "generic_pulsing", "targetname" );
	double_strobe = getentarray ( "generic_double_strobe", "targetname" );
	
	array_thread( flickering_lights, maps\_lights::generic_flickering );
	array_thread( pulsing_lights, maps\_lights::generic_pulsing );
	array_thread( double_strobe, maps\_lights::generic_double_strobe );
}


weapon_ammo()
{
	ents = getentarray();
	for ( i = 0;i < ents.size;i ++ )
	{
		if ( ( isdefined( ents[ i ].classname ) ) && ( getsubstr( ents[ i ].classname, 0, 7 ) == "weapon_" ) )
		{
			weap = ents[ i ];
			change_ammo = false;
			clip = undefined;
			extra = undefined;
				
			if ( isdefined ( weap.script_ammo_clip ) )
			{
				clip = weap.script_ammo_clip;
				change_ammo = true;
			}
			if ( isdefined ( weap.script_ammo_extra ) )
			{
				extra = weap.script_ammo_extra;
				change_ammo = true;
			}
			
			if ( change_ammo )
			{
				if ( !isdefined ( clip ) )
					assertmsg( "weapon: " + weap.classname + " " + weap.origin + " sets script_ammo_extra but not script_ammo_clip" );
				if ( !isdefined ( extra ) )
					assertmsg( "weapon: " + weap.classname + " " + weap.origin + " sets script_ammo_clip but not script_ammo_extra" );
				weap ItemWeaponSetAmmo ( clip, extra );
				
			}
		}
	}
}

mg42ModelReplace()
{
	self setModel( "weapon_saw_MG_Setup" );
}

trigger_group()
{
	self thread trigger_group_remove();

	level endon( "trigger_group_" + self.script_trigger_group );
	self waittill( "trigger" );
	level notify( "trigger_group_" + self.script_trigger_group, self );
}

trigger_group_remove()
{
	level waittill( "trigger_group_" + self.script_trigger_group, trigger );
	if ( self != trigger )
		self delete();
}

/#
star( total )
{
	println ("         ");
	println ("         ");
	println ("         ");
	for (i=0;i<total;i++)
	{
		for (z=total-i;z>1;z--)
		print (" ");
		print ("*");
		for (z=0;z<i;z++)
			print ("**");
		println ("");
	}
	for (i=total-2;i>-1;i--)
	{
		for (z=total-i;z>1;z--)
		print (" ");
		print ("*");
		for (z=0;z<i;z++)
			print ("**");
		println ("");
	}

	println ("         ");
	println ("         ");
	println ("         ");
}
#/ 


exploder_load( trigger )
{
	level endon( "killexplodertridgers" + trigger.script_exploder );
	trigger waittill( "trigger" );
	if ( isdefined( trigger.script_chance ) && randomfloat( 1 ) > trigger.script_chance )
	{
		if ( isdefined( trigger.script_delay ) )
			wait trigger.script_delay;
		else
			wait 4;
		level thread exploder_load( trigger );
		return;
	}
	maps\_utility::exploder( trigger.script_exploder );
	level notify( "killexplodertridgers" + trigger.script_exploder );
}

shock_onpain()
{
	precacheShellshock( "pain" );
	precacheShellshock( "default" );
	level.player endon( "death" );
	if ( getdvar( "blurpain" ) == "" )
		setdvar( "blurpain", "on" );

	while ( 1 )
	{
		oldhealth = level.player.health;
		level.player waittill( "damage" );
		if ( getdvar( "blurpain" ) == "on" )
		{
// 			println( "health dif was ", oldhealth - level.player.health );
			if ( oldhealth - level.player.health < 129 )
			{
				// level.player shellshock( "pain", 0.4 );
			}
			else
			{
				level.player shellshock( "default", 5 );
			}
		}
	}
}




usedAnimations()
{
	setdvar( "usedanim", "" );
	while ( 1 )
	{
		if ( getdvar( "usedanim" ) == "" )
		{
			wait( 2 );
			continue;
		}

		animname = getdvar( "usedanim" );
		setdvar( "usedanim", "" );

		if ( !isdefined( level.completedAnims[ animname ] ) )
		{
			println( "^d -- -- No anims for ", animname, "^d -- -- -- -- -- - " );
			continue;
		}

		println( "^d -- -- Used animations for ", animname, "^d: ", level.completedAnims[ animname ].size, "^d -- -- -- -- -- - " );
		for ( i = 0;i < level.completedAnims[ animname ].size;i ++ )
			println( level.completedAnims[ animname ][ i ] );
	}
}


badplace_think( badplace )
{
	if ( !isdefined( level.badPlaces ) )
		level.badPlaces = 0;
		
	level.badPlaces ++ ;		
	badplace_cylinder( "badplace" + level.badPlaces, -1, badplace.origin, badplace.radius, 1024 );
}


setupExploders()
{
	level.exploders = [];
	
	// Hide exploder models.
	ents = getentarray( "script_brushmodel", "classname" );
	smodels = getentarray( "script_model", "classname" );
	for ( i = 0;i < smodels.size;i ++ )
		ents[ ents.size ] = smodels[ i ];

	for ( i = 0;i < ents.size;i ++ )
	{
		if ( isdefined( ents[ i ].script_prefab_exploder ) )
			ents[ i ].script_exploder = ents[ i ].script_prefab_exploder;

		if ( isdefined( ents[ i ].script_exploder ) )
		{
			if( ents[ i ].script_exploder < 10000 )
				level.exploders[ ents[ i ].script_exploder ] = true;  // nate. I wanted a list
			if ( ( ents[ i ].model == "fx" ) && ( ( !isdefined( ents[ i ].targetname ) ) || ( ents[ i ].targetname != "exploderchunk" ) ) )
				ents[ i ] hide();
			else if ( ( isdefined( ents[ i ].targetname ) ) && ( ents[ i ].targetname == "exploder" ) )
			{
				ents[ i ] hide();
				ents[ i ] notsolid();
				if ( isdefined( ents[ i ].script_disconnectpaths ) )
					ents[ i ] connectpaths();
			}
			else if ( ( isdefined( ents[ i ].targetname ) ) && ( ents[ i ].targetname == "exploderchunk" ) )
			{
				ents[ i ] hide();
				ents[ i ] notsolid();
				if ( isdefined( ents[ i ].spawnflags ) && ( ents[ i ].spawnflags & 1 ) )
					ents[ i ] connectpaths();
			}
		}
	}

	script_exploders = [];

	potentialExploders = getentarray( "script_brushmodel", "classname" );
	for ( i = 0;i < potentialExploders.size;i ++ )
	{
		if ( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
			potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;
			
		if ( isdefined( potentialExploders[ i ].script_exploder ) )
			script_exploders[ script_exploders.size ] = potentialExploders[ i ];
	}

	potentialExploders = getentarray( "script_model", "classname" );
	for ( i = 0;i < potentialExploders.size;i ++ )
	{
		if ( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
			potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;

		if ( isdefined( potentialExploders[ i ].script_exploder ) )
			script_exploders[ script_exploders.size ] = potentialExploders[ i ];
	}

	potentialExploders = getentarray( "item_health", "classname" );
	for ( i = 0;i < potentialExploders.size;i ++ )
	{
		if ( isdefined( potentialExploders[ i ].script_prefab_exploder ) )
			potentialExploders[ i ].script_exploder = potentialExploders[ i ].script_prefab_exploder;

		if ( isdefined( potentialExploders[ i ].script_exploder ) )
			script_exploders[ script_exploders.size ] = potentialExploders[ i ];
	}
	
	if ( !isdefined( level.createFXent ) )
		level.createFXent = [];
	
	acceptableTargetnames = [];
	acceptableTargetnames[ "exploderchunk visible" ] = true;
	acceptableTargetnames[ "exploderchunk" ] = true;
	acceptableTargetnames[ "exploder" ] = true;
	
	for ( i = 0; i < script_exploders.size; i ++ )
	{
		exploder = script_exploders[ i ];
		ent = createExploder( exploder.script_fxid );
		ent.v = [];
		ent.v[ "origin" ] = exploder.origin;
		ent.v[ "angles" ] = exploder.angles;
		ent.v[ "delay" ] = exploder.script_delay;
		ent.v[ "firefx" ] = exploder.script_firefx;
		ent.v[ "firefxdelay" ] = exploder.script_firefxdelay;
		ent.v[ "firefxsound" ] = exploder.script_firefxsound;
		ent.v[ "firefxtimeout" ] = exploder.script_firefxtimeout;
		ent.v[ "earthquake" ] = exploder.script_earthquake;
		ent.v[ "rumble" ] = exploder.script_rumble;
		ent.v[ "damage" ] = exploder.script_damage;
		ent.v[ "damage_radius" ] = exploder.script_radius;
		ent.v[ "soundalias" ] = exploder.script_soundalias;
		ent.v[ "repeat" ] = exploder.script_repeat;
		ent.v[ "delay_min" ] = exploder.script_delay_min;
		ent.v[ "delay_max" ] = exploder.script_delay_max;
		ent.v[ "target" ] = exploder.target;
		ent.v[ "ender" ] = exploder.script_ender;
		ent.v[ "physics" ] = exploder.script_physics;
		ent.v[ "type" ] = "exploder";
// 		ent.v[ "worldfx" ] = true;
		if ( !isdefined( exploder.script_fxid ) )
			ent.v[ "fxid" ] = "No FX";
		else
			ent.v[ "fxid" ] = exploder.script_fxid;
		ent.v[ "exploder" ] = exploder.script_exploder;
		assertEx( isdefined( exploder.script_exploder ), "Exploder at origin " + exploder.origin + " has no script_exploder" );

		if ( !isdefined( ent.v[ "delay" ] ) )
			ent.v[ "delay" ] = 0;
				

					
		if ( isdefined( exploder.target ) )
		{
			get_ent = getentarray( ent.v[ "target" ], "targetname" )[0];
			if(isdefined(get_ent))
			{
				org = get_ent.origin;
				ent.v[ "angles" ] = vectortoangles( org - ent.v[ "origin" ] );
			}
// 			forward = anglestoforward( angles );
// 			up = anglestoup( angles );
		}
			
		// this basically determines if its a brush / model exploder or not
		if ( exploder.classname == "script_brushmodel" || isdefined( exploder.model ) )
		{
			ent.model = exploder;
			ent.model.disconnect_paths = exploder.script_disconnectpaths;
		}
		
		if ( isdefined( exploder.targetname ) && isdefined( acceptableTargetnames[ exploder.targetname ] ) )
			ent.v[ "exploder_type" ] = exploder.targetname;
		else
			ent.v[ "exploder_type" ] = "normal";
		
		ent maps\_createfx::post_entity_creation_function();
	}
}


nearAIRushesPlayer()
{
	if ( isalive( level.enemySeekingPlayer ) )
		return;
	enemy = get_closest_ai( level.player.origin, "axis" );
	if ( !isdefined( enemy ) )
		return;
		
	if ( distance( enemy.origin, level.player.origin ) > 400 )
		return;
		
	level.enemySeekingPlayer = enemy;
	enemy setgoalentity( level.player );
	enemy.goalradius = 512;
	
}

		
playerDamageRumble()
{
	while ( true )
	{
		level.player waittill( "damage", amount );
		
		if ( isdefined( level.player.specialDamage ) )
			continue;

		level.player PlayRumbleOnEntity( "damage_heavy" );		
	}
}

playerDamageShellshock()
{
	while ( true )
	{
		level.player waittill( "damage", damage, attacker, direction_vec, point, cause );

		if ( cause == "MOD_EXPLOSIVE" || 
			cause == "MOD_GRENADE" || 
			cause == "MOD_GRENADE_SPLASH" || 
			cause == "MOD_PROJECTILE" || 
			cause == "MOD_PROJECTILE_SPLASH" )
		{
			time = 0;

			multiplier = level.player.maxhealth / 100;
			scaled_damage = damage * multiplier;
			
			if ( scaled_damage >= 90 )
				time = 4;
			else if ( scaled_damage >= 50 )
				time = 3;
			else if ( scaled_damage >= 25 )
				time = 2;
			else if ( scaled_damage > 10 )
				time = 1;
			
			if ( time )
				level.player shellshock( "default", time );
		}
	}
}

map_is_early_in_the_game()
{
	/#
	if ( isdefined( level.testmap ) )
		return true;
	#/
	
	return level.early_level[ level.script ];
}

player_throwgrenade_timer()
{
	level.player endon ("death");
	level.player.lastgrenadetime = 0;
	while(1)
	{
		while( ! level.player isthrowinggrenade() )
			wait .05;
		level.player.lastgrenadetime = gettime();
		while( level.player isthrowinggrenade() )
			wait .05;
	}
}

player_special_death_hint()
{
	if ( isalive( level.player ) )
		thread maps\_quotes::setDeadQuote();
		
	level.player thread player_throwgrenade_timer();

	level.player waittill( "death", attacker, cause, weaponName );
	
	if ( cause != "MOD_GRENADE" && cause != "MOD_GRENADE_SPLASH" && cause != "MOD_SUICIDE" && cause != "MOD_EXPLOSIVE" )
		return;
	
	if ( level.gameskill >= 2 )
	{
		// less death hinting on hard / fu
		if ( !map_is_early_in_the_game() )
			return;
	}
	
	if ( cause == "MOD_SUICIDE" )
	{
		if( level.player.lastgrenadetime > 3.5*1000 )
			return; //magic number copied from fraggrenade asset.
		level notify( "new_quote_string" );
		thread grenade_death_text_hudelement( &"SCRIPT_GRENADE_SUICIDE_LINE1", &"SCRIPT_GRENADE_SUICIDE_LINE2" );
		return;
	}
	
	if ( cause == "MOD_EXPLOSIVE" )
	{
		if ( isdefined( attacker.car_damage_owner_recorder ) )
		{
			level notify( "new_quote_string" );
			// You know what would be cool? If people would PUT THE TEXT OF THE LOCALIZED STRING IN THE COMMENT!!!!!!
			// You were killed by an exploding vehicle. Vehicles on fire are likely to explode.
			setdvar( "ui_deadquote", "@SCRIPT_EXPLODING_VEHICLE_DEATH" );
			thread special_death_indicator_hudelement( "hud_burningcaricon", 96, 96 );
			return;
		}
		
		// check if the death was caused by a barrel
		// have to check time and location against the last explosion because the attacker isn't the
		// barrel because the ent that damaged the barrel is passed through as the attacker instead
		if ( isdefined( level.lastExplodingBarrel ) )
		{
			// killed the same frame a barrel exploded
			if ( getTime() != level.lastExplodingBarrel[ "time" ] )
				return;
			
			// within the blast radius of the barrel that exploded
			d = distance( level.player.origin, level.lastExplodingBarrel[ "origin" ] );
			if ( d > 350 )
				return;
			
			// must have been killed by that barrel
			level notify( "new_quote_string" );
			// You were killed by an exploding barrel. Red barrels will explode when shot.
			setdvar( "ui_deadquote", "@SCRIPT_EXPLODING_BARREL_DEATH" );
			thread special_death_indicator_hudelement( "hud_burningbarrelicon", 64, 64 );
			return;
		}
		
		return;
	}
	
	if ( cause == "MOD_GRENADE" || cause == "MOD_GRENADE_SPLASH" )
	{
		if ( isdefined( weaponName ) && !IsWeaponDetonationTimed( weaponName ) )
		{
			return;
		}

		level notify( "new_quote_string" );
		// Would putting the content of the string here be so hard?
		setdvar( "ui_deadquote", "@SCRIPT_GRENADE_DEATH" );
		thread grenade_death_indicator_hudelement();
		return;
	}
}

grenade_death_text_hudelement( textLine1, textLine2 )
{
	level.player.failingMission = true;
	
	setdvar( "ui_deadquote", "" );
	
	wait( 1.5 );

	fontElem = newHudElem();
	fontElem.elemType = "font";
	fontElem.font = "default";
	fontElem.fontscale = 1.5;
	fontElem.x = 0;
	fontElem.y = -30;
	fontElem.alignX = "center";
	fontElem.alignY = "middle";
	fontElem.horzAlign = "center";
	fontElem.vertAlign = "middle";
	fontElem settext( textLine1 );
	fontElem.foreground = true;
	fontElem.alpha = 0;
	fontElem fadeOverTime( 1 );
	fontElem.alpha = 1;

	if ( isdefined( textLine2 ) )
	{
		fontElem = newHudElem();
		fontElem.elemType = "font";
		fontElem.font = "default";
		fontElem.fontscale = 1.5;
		fontElem.x = 0;
		fontElem.y = -25 + level.fontHeight * fontElem.fontscale;
		fontElem.alignX = "center";
		fontElem.alignY = "middle";
		fontElem.horzAlign = "center";
		fontElem.vertAlign = "middle";
		fontElem settext( textLine2 );
		fontElem.foreground = true;
		fontElem.alpha = 0;
		fontElem fadeOverTime( 1 );
		fontElem.alpha = 1;
	}
}

grenade_death_indicator_hudelement()
{
	wait( 1.5 );
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 68;
	overlay setshader( "hud_grenadeicon", 50, 50 );
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay fadeOverTime( 1 );
	overlay.alpha = 1;

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 25;
	overlay setshader( "hud_grenadepointer", 50, 25 );
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay fadeOverTime( 1 );
	overlay.alpha = 1;
}

special_death_indicator_hudelement( shader, iWidth, iHeight, fDelay )
{
	if ( !isdefined( fDelay ) )
		fDelay = 1.5;
	wait fDelay;
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 40;
	overlay setshader( shader, iWidth, iHeight );
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.foreground = true;
	overlay.alpha = 0;
	overlay fadeOverTime( 1 );
	overlay.alpha = 1;
}

triggered_playerseek( trig )
{
	groupNum = trig.script_triggered_playerseek;
	trig waittill( "trigger" );
	
	ai = getaiarray();
	for ( i = 0;i < ai.size;i ++ )
	{
		if ( !isAlive( ai[ i ] ) )
			continue;
		if ( ( isdefined( ai[ i ].script_triggered_playerseek ) ) && ( ai[ i ].script_triggered_playerseek == groupNum ) )
		{
			ai[ i ].goalradius = 800;
			ai[ i ] setgoalentity( level.player );
			level thread maps\_spawner::delayed_player_seek_think( ai[ i ] );
		}
	}
}

traverseThink()
{
	ent = getent( self.target, "targetname" );
	self.traverse_height = ent.origin[ 2 ];
	ent delete();
}

/#
deprecatedTraverseThink()
{
	wait .05;
	println("^1Warning: deprecated traverse used in this map somewhere around " + self.origin);
	if ( getdvarint("scr_traverse_debug") )
	{
		while(1)
		{
			print3d( self.origin, "deprecated traverse!" );
			wait .05;
		}
	}
}
#/

pianoDamageThink()
{
	org = self getorigin();
// 	note = "piano_" + self.script_noteworthy;
// 	self setHintString( &"SCRIPT_PLATFORM_PIANO" );
	note[ 0 ] = "large";
	note[ 1 ] = "small";
	for ( ;; )
	{
		self waittill( "trigger" );
		thread play_sound_in_space( "bullet_" + random( note ) + "_piano", org );
	}
}

pianoThink()
{
	org = self getorigin();
	note = "piano_" + self.script_noteworthy;
	self setHintString( &"SCRIPT_PLATFORM_PIANO" );
	for ( ;; )
	{
		self waittill( "trigger" );
		thread play_sound_in_space( note, org );
	}
}



bcTrigger( trigger )
{
	realTrigger = undefined;
	
	if ( isDefined( trigger.target ) )
	{
		targetEnts = getEntArray( trigger.target, "targetname" );

		if ( isSubStr( targetEnts[ 0 ].classname, "trigger" ) )
			realTrigger = targetEnts[ 0 ];
	}
	
	if ( isDefined( realTrigger ) )
		realTrigger waittill( "trigger", other );
	else
		trigger waittill( "trigger", other );
	
	soldier = undefined;
	
	if ( isDefined( realTrigger ) )
	{
		if ( other.team == "axis" && level.player isTouching( trigger ) )
		{
			soldier = get_closest_ai( level.player getOrigin(), "allies" );
			if ( distance( soldier.origin, level.player getOrigin() ) > 512 )
				return;
		}
		else if ( other.team == "allies" )
		{
			soldiers = getAIArray( "axis" );
			
			for ( index = 0; index < soldiers.size; index ++ )
			{
				if ( soldiers[ index ] isTouching( trigger ) )
					soldier = soldiers[ index ];
			}
		}
	}
	else if ( other == level.player )
	{
		soldier = get_closest_ai( level.player getOrigin(), "allies" );
		if ( distance( soldier.origin, level.player getOrigin() ) > 512 )
			return;
	}
	else
	{
		soldier = other;
	}
	
	if ( !isDefined( soldier ) )
		return;

	soldier custom_battlechatter( trigger.script_bctrigger );
}

waterThink()
{
	assert( isdefined( self.target ) );
	targeted = getent( self.target, "targetname" );
	assert( isdefined( targeted ) );
	waterHeight = targeted.origin[ 2 ];
	targeted = undefined;
	
	level.depth_allow_prone = 8;
	level.depth_allow_crouch = 33;
	level.depth_allow_stand = 50;
	
	//prof_begin( "water_stance_controller" );
	
	for ( ;; )
	{
		wait 0.05;
		// restore all defaults
		if ( !level.player.inWater )
		{
			level.player allowProne( true );
			level.player allowCrouch( true );
			level.player allowStand( true );
			thread waterThink_rampSpeed( level.default_run_speed );
		}
		
		// wait until in water
		self waittill( "trigger" );
		level.player.inWater = true;
		while ( level.player isTouching( self ) )
		{
			level.player.inWater = true;
			playerOrg = level.player getOrigin();
			d = ( playerOrg[ 2 ] - waterHeight );
			if ( d > 0 )
				break;
			
			// slow the players movement based on how deep it is
			newSpeed = int( level.default_run_speed - abs( d * 5 ) );
			if ( newSpeed < 50 )
				newSpeed = 50;
			assert( newSpeed <= 190 );
			thread waterThink_rampSpeed( newSpeed );
			
			// controll the allowed stances in this water height
			if ( abs( d ) > level.depth_allow_crouch )
				level.player allowCrouch( false );
			else
				level.player allowCrouch( true );
			
			if ( abs( d ) > level.depth_allow_prone )
				level.player allowProne( false );
			else
				level.player allowProne( true );
			
			wait 0.5;
		}
		level.player.inWater = false;
		wait 0.05;
	}
	
	//prof_end( "water_stance_controller" );
}

waterThink_rampSpeed( newSpeed )
{
	level notify( "ramping_water_movement_speed" );
	level endon( "ramping_water_movement_speed" );
	
	rampTime = 0.5;
	numFrames = int( rampTime * 20 );
	
	currentSpeed = getdvarint( "g_speed" );
	
	qSlower = false;
	if ( newSpeed < currentSpeed )
		qSlower = true;
	
	speedDifference = int( abs( currentSpeed - newSpeed ) );
	speedStepSize = int( speedDifference / numFrames );
	
	for ( i = 0 ; i < numFrames ; i ++ )
	{
		currentSpeed = getdvarint( "g_speed" );
		if ( qSlower )
			setsaveddvar( "g_speed", ( currentSpeed - speedStepSize ) );
		else
			setsaveddvar( "g_speed", ( currentSpeed + speedStepSize ) );
		wait 0.05;
	}
	setsaveddvar( "g_speed", newSpeed );
}



massNodeInitFunctions()
{
	nodes = getallnodes();

	thread maps\_mgturret::auto_mgTurretLink( nodes );	
	thread maps\_mgturret::saw_mgTurretLink( nodes );	
	thread maps\_colors::init_color_grouping( nodes );
}


 /* 
 * * * * * * * * * * 

TRIGGER_UNLOCK

 * * * * * * * * * * 
 */ 

trigger_unlock( trigger )
{
	// trigger unlocks unlock another trigger. When that trigger is hit, all unlocked triggers relock
	// trigger_unlocks with the same script_noteworthy relock the same triggers
	
	noteworthy = "not_set";
	if ( isdefined( trigger.script_noteworthy ) )
		noteworthy = trigger.script_noteworthy;
		
	target_triggers = getentarray( trigger.target, "targetname" );

	trigger thread trigger_unlock_death( trigger.target );

	for ( ;; )
	{	
		array_thread( target_triggers, ::trigger_off );
		trigger waittill( "trigger" );
		array_thread( target_triggers, ::trigger_on );
		
		wait_for_an_unlocked_trigger( target_triggers, noteworthy );

		array_notify( target_triggers, "relock" );
	}
}

trigger_unlock_death( target )
{
	self waittill( "death" );
	target_triggers = getentarray( target, "targetname" );
	array_thread( target_triggers, ::trigger_off );
}

wait_for_an_unlocked_trigger( triggers, noteworthy )
{
	level endon( "unlocked_trigger_hit" + noteworthy );
	ent = spawnstruct();
	for ( i = 0; i < triggers.size; i ++ )
	{
		triggers[ i ] thread report_trigger( ent, noteworthy );
	}
	ent waittill( "trigger" );
	level notify( "unlocked_trigger_hit" + noteworthy );
}

report_trigger( ent, noteworthy )
{
	self endon( "relock" );
	level endon( "unlocked_trigger_hit" + noteworthy );
	self waittill( "trigger" );
	ent notify( "trigger" );
}

 /* 
 * * * * * * * * * * 

TRIGGER_LOOKAT

 * * * * * * * * * * 
 */ 

get_trigger_targs()
{
	triggers = [];
	target_origin = undefined; // was self.origin
	if ( isdefined( self.target ) )
	{
		targets = getentarray( self.target, "targetname" );
		orgs = [];
		for ( i = 0; i < targets.size; i ++ )
		{
			if ( targets[ i ].classname == "script_origin" )
				orgs[ orgs.size ] = targets[ i ];
			if ( issubstr( targets[ i ].classname, "trigger" ) )
				triggers[ triggers.size ] = targets[ i ];
		}
		
		assertex( orgs.size < 2, "Trigger at " + self.origin + " targets multiple script origins" );
		if ( orgs.size == 1 )
		{
			target_origin = orgs[ 0 ].origin;
			orgs[ 0 ] delete();
		}
	}
	
	assertex( isdefined( target_origin ), self.targetname + " at " + self.origin + " has no target origin." );

	array = [];
	array[ "triggers" ] = triggers;
	array[ "target_origin" ] = target_origin;
	return array;
}

trigger_lookat( trigger )
{
	// ends when the flag is hit
	trigger_lookat_think( trigger, true );
}

trigger_looking( trigger )
{
	// flag is only set while the thing is being looked at
	trigger_lookat_think( trigger, false );
}

trigger_lookat_think( trigger, endOnFlag )
{
	dot = 0.78;
	if ( isdefined( trigger.script_dot ) )
	{
		dot = trigger.script_dot;
	}
		
	array = trigger get_trigger_targs();
	triggers = array[ "triggers" ];
	target_origin = array[ "target_origin" ];

	has_flag = isdefined( trigger.script_flag ) || isdefined( trigger.script_noteworthy );
	flagName = undefined;
	
	if ( has_flag )
	{
		flagName = trigger get_trigger_flag();
		if ( !isdefined( level.flag[ flagName ] ) )
			flag_init( flagName );
	}
	else
	{
		if ( !triggers.size )
			assertEx( isdefined( trigger.script_flag ) || isdefined( trigger.script_noteworthy ), "Trigger_lookat at " + trigger.origin + " has no script_flag! The script_flag is used as a flag that gets set when the trigger is activated." );
	}

	if ( endOnFlag && has_flag )
	{
		level endon( flagName );
	}	

	trigger endon( "death" );
	
	for ( ;; )
	{
		if ( has_flag )
			flag_clear( flagName );
			
		trigger waittill( "trigger", other );
	
		assertEx( other == level.player, "trigger_lookat currently only supports looking from the player" );
		while ( level.player istouching( trigger ) )
		{
			if ( !sightTracePassed( other geteye(), target_origin, false, undefined ) )
			{
				if ( has_flag )
					flag_clear( flagName );
				wait( 0.5 );
				continue;
			}
				
			normal = vectorNormalize( target_origin - other.origin );
		    player_angles = level.player GetPlayerAngles();
		    player_forward = anglesToForward( player_angles );
	
	// 		angles = vectorToAngles( target_origin - other.origin );
	// 	    forward = anglesToForward( angles );
	// 		draw_arrow( level.player.origin, level.player.origin + vectorscale( forward, 150 ), ( 1, 0.5, 0 ) );
	// 		draw_arrow( level.player.origin, level.player.origin + vectorscale( player_forward, 150 ), ( 0, 0.5, 1 ) );
	
			dot = vectorDot( player_forward, normal );
			if ( dot >= 0.78 )
			{
				if ( has_flag )
					flag_set( flagName );

				// notify targetted triggers as well
				array_thread( triggers, ::send_notify, "trigger" );

				if ( endOnFlag )
					return;
				wait( 2 );
			}
			else
			{
				if ( has_flag )
					flag_clear( flagName );
			}
			
			wait( 0.5 );
		}
	}
}

/* 
* * * * * * * * * * 

TRIGGER_CANSEE

* * * * * * * * * * 
*/ 

trigger_cansee( trigger )
{
	triggers = [];
	target_origin = undefined; // was trigger.origin

	array = trigger get_trigger_targs();
	triggers = array[ "triggers" ];
	target_origin = array[ "target_origin" ];

	has_flag = isdefined( trigger.script_flag ) || isdefined( trigger.script_noteworthy );
	flagName = undefined;
	
	if ( has_flag )
	{
		flagName = trigger get_trigger_flag();
		if ( !isdefined( level.flag[ flagName ] ) )
			flag_init( flagName );
	}
	else
	{
		if ( !triggers.size )
			assertEx( isdefined( trigger.script_flag ) || isdefined( trigger.script_noteworthy ), "Trigger_cansee at " + trigger.origin + " has no script_flag! The script_flag is used as a flag that gets set when the trigger is activated." );
	}
	
	trigger endon( "death" );
	
	range = 12;
	offsets = [];
	offsets[ offsets.size ] = ( 0,0,0 );
	offsets[ offsets.size ] = ( range,0,0 );
	offsets[ offsets.size ] = ( range * -1,0,0 );
	offsets[ offsets.size ] = ( 0,range,0 );
	offsets[ offsets.size ] = ( 0,range * -1,0 );
	offsets[ offsets.size ] = ( 0,0,range );
	
	for ( ;; )
	{
		if ( has_flag )
			flag_clear( flagName );
			
		trigger waittill( "trigger", other );
		assertEx( other == level.player, "trigger_cansee currently only supports looking from the player" );
		
		while ( level.player istouching( trigger ) )
		{
			if ( !( other cantraceto( target_origin, offsets ) ) )
			{
				if ( has_flag )
					flag_clear( flagName );
				wait( 0.1 );
				continue;
			}
			
			if ( has_flag )
				flag_set( flagName );

			// notify targetted triggers as well
			array_thread( triggers, ::send_notify, "trigger" );
			wait( 0.5 );
		}
	}
}

cantraceto( target_origin, offsets )
{
	for ( i = 0; i < offsets.size; i++ )
	{
		if ( sightTracePassed( self geteye(), target_origin + offsets[ i ], true, self ) )
			return true;
	}
	return false;
}


indicate_start( start )
{
	hudelem = newHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.x = 10;
	hudelem.y = 400;
//	hudelem.label = "Loading from start: " + start;
	hudelem.label = start;
	hudelem.alpha = 0;
	hudelem.fontScale = 3;
	wait( 1 );
	hudelem fadeOverTime( 1 );
	hudelem.alpha = 1;
	wait( 5 );
	hudelem fadeOverTime( 1 );
	hudelem.alpha = 0;
	wait( 1 );
	hudelem destroy();
}

handle_starts()
{
 	if ( !isdefined( level.start_functions ) )
		level.start_functions = [];

	assertEx( getdvar( "jumpto" ) == "", "Use the START dvar instead of JUMPTO" );
	
	start = tolower( getdvar( "start" ) );
	
	// find the start that matches the one the dvar is set to, and execute it
	dvars = getArrayKeys( level.start_functions );

	for ( i = 0; i < dvars.size; i ++ )
	{
		if ( start == dvars[ i ] )
		{
			level.start_point = start;
			break;
		}
	}

	if ( !isdefined( level.start_point ) )
	{
		level.start_point = "default";
	}

	waittillframeend;// starts happen at the end of the first frame, so threads in the mission have a chance to run and init stuff
	thread start_menu();
	
	if ( level.start_point != "default" )
	{
		thread indicate_start( level.start_loc_string[ level.start_point ] );
		thread [[ level.start_functions[ level.start_point ] ]]();
		return;
	}
	
	if ( isdefined( level.default_start ) )
	{
		thread [[ level.default_start ]]();
	}
	
	string = get_string_for_starts( dvars );
	setdvar( "start", string );
}

get_string_for_starts( dvars )
{
	string = " ** No starts have been set up for this map with maps\_utility::add_start().";
	if ( dvars.size )
	{
		string = " ** ";
		for ( i = dvars.size - 1; i >= 0; i -- )
		{
			string = string + dvars[ i ] + " ";
		}
	}
	
	setdvar( "start", string );
	return string;
}


create_start( start, index )
{
	hudelem = newHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.x = 10;
	hudelem.y = 80 + index * 20;
	hudelem.label = start;
	hudelem.alpha = 0;

	hudelem.fontScale = 2;
	hudelem fadeOverTime( 0.5 );
	hudelem.alpha = 1;
	return hudelem;
}

start_menu()
{
	precachestring( &"STARTS_AVAILABLE_STARTS" );
	precachestring( &"STARTS_CANCEL" );
	precachestring( &"STARTS_DEFAULT" );
	level.start_loc_string[ "default" ] = &"STARTS_DEFAULT";
	level.start_loc_string[ "cancel" ] = &"STARTS_CANCEL";

	for ( ;; )
	{
		if ( getdvarInt( "debug_start" ) )
		{
			setdvar( "debug_start", 0 );
			setsaveddvar( "hud_drawhud", 1 );
			display_starts();
		}
		else
		{
			level.display_starts_Pressed = false;
		}
		wait( 0.05 );
	}
}

display_starts() 
{
	level.display_starts_Pressed = true;
	dvars = getArrayKeys( level.start_functions );
	if ( dvars.size <= 0 )
		return;
		
	dvars[ dvars.size ] = "default";
	dvars[ dvars.size ] = "cancel";
	
	title = create_start( &"STARTS_AVAILABLE_STARTS", -1 );
	title.color = (1,1,1);
	elems = [];
	
	for ( i = 0; i < dvars.size; i++ )
	{
		elems[ elems.size ] = create_start( level.start_loc_string[ dvars[ i ] ] , dvars.size - i );
	}
	
	selected = dvars.size - 1;
	
	up_pressed = false;
	down_pressed = false;
	
	for ( ;; )
	{	
		if ( !( level.player buttonPressed( "F10" ) ) )
		{
			level.display_starts_Pressed = false;
		}

		
		for ( i = 0; i < dvars.size; i++ )
		{
			elems[ i ].color = ( 0.7, 0.7, 0.7 );
		}
		
		elems[ selected ].color = ( 1, 1, 0 );

		if ( !up_pressed )
		{
			if ( level.player buttonPressed( "UPARROW" ) || level.player buttonPressed( "DPAD_UP" ) || level.player buttonPressed( "APAD_UP" ) )
			{
				up_pressed = true;
				selected++;
			}
		}
		else
		{
			if ( !level.player buttonPressed( "UPARROW" ) && !level.player buttonPressed( "DPAD_UP" ) && !level.player buttonPressed( "APAD_UP" ) )
				up_pressed = false;
		}
		

		if ( !down_pressed )
		{
			if ( level.player buttonPressed( "DOWNARROW" ) || level.player buttonPressed( "DPAD_DOWN" ) || level.player buttonPressed( "APAD_DOWN" ) )
			{
				down_pressed = true;
				selected--;
			}
		}
		else
		{
			if ( !level.player buttonPressed( "DOWNARROW" ) && !level.player buttonPressed( "DPAD_DOWN" ) && !level.player buttonPressed( "APAD_DOWN" ) )
				down_pressed = false;
		}
		
		if ( selected < 0 )
			selected = 0;
			
		if ( selected >= dvars.size )
			selected = dvars.size - 1;
		
		
		if ( level.player buttonPressed( "kp_enter" ) || level.player buttonPressed( "BUTTON_A" ) || level.player buttonPressed( "enter" ))
		{
			if ( dvars[ selected ] == "cancel" )
			{
				title destroy();
				for ( i = 0; i < elems.size; i++ )
				{
					elems[ i ] destroy();
				}
				break;
			}
			
			setdvar( "start", dvars[ selected ] );
			changelevel( level.script, false );
		}
		wait( 0.05 );
	}

}

start_button_combo()
{
	if ( !( level.player buttonPressed( "BUTTON_RSTICK" ) ) )
		return false;
		
	if ( !( level.player buttonPressed( "BUTTON_RSHLDR" ) ) )
		return false;
		
	return true;
}


devhelp_hudElements( hudarray, alpha )
{
	for ( i = 0;i < hudarray.size;i ++ )
		for ( p = 0;p < 5;p ++ )
			hudarray[ i ][ p ].alpha = alpha;

}

devhelp()
{
	 /#
	helptext = [];
	helptext[ helptext.size ] = "P: pause                                                       ";
	helptext[ helptext.size ] = "T: super speed                                                 ";
	helptext[ helptext.size ] = ".: fullbright                                                  ";
	helptext[ helptext.size ] = "U: toggle normal maps                                          ";
	helptext[ helptext.size ] = "Y: print a line of text, useful for putting it in a screenshot ";
	helptext[ helptext.size ] = "H: toggle detailed ent info                                    ";
	helptext[ helptext.size ] = "g: toggle simplified ent info                                  ";
	helptext[ helptext.size ] = ", : show the triangle outlines                                  ";
	helptext[ helptext.size ] = " - : Back 10 seconds                                             ";
	helptext[ helptext.size ] = "6: Replay mark                                                 ";
	helptext[ helptext.size ] = "7: Replay goto                                                 ";
	helptext[ helptext.size ] = "8: Replay live                                                 ";
	helptext[ helptext.size ] = "0: Replay back 3 seconds                                       ";
	helptext[ helptext.size ] = "[ : Replay restart                                              ";
	helptext[ helptext.size ] = "\: map_restart                                                 ";
	helptext[ helptext.size ] = "U: draw material name                                          ";
	helptext[ helptext.size ] = "J: display tri counts                                          ";
	helptext[ helptext.size ] = "B: cg_ufo                                                      ";
	helptext[ helptext.size ] = "N: ufo                                                         ";
	helptext[ helptext.size ] = "C: god                                                         ";                                      
	helptext[ helptext.size ] = "K: Show ai nodes                                               ";                                      
	helptext[ helptext.size ] = "L: Show ai node connections                                    ";                                      
	helptext[ helptext.size ] = "Semicolon: Show ai pathing                                     ";                                      

	
	strOffsetX = [];
	strOffsetY = [];
	strOffsetX[ 0 ] = 0;
	strOffsetY[ 0 ] = 0;
	strOffsetX[ 1 ] = 1;
	strOffsetY[ 1 ] = 1;
	strOffsetX[ 2 ] = -2;
	strOffsetY[ 2 ] = 1;
	strOffsetX[ 3 ] = 1;
	strOffsetY[ 3 ] = -1;
	strOffsetX[ 4 ] = -2;
	strOffsetY[ 4 ] = -1;
	hudarray = [];
	for ( i = 0;i < helptext.size;i ++ )
	{
		newStrArray = [];
		for ( p = 0;p < 5;p ++ )
		{
			// setup instructional text
			newStr = newHudElem();
			newStr.alignX = "left";
			newStr.location = 0;
			newStr.foreground = 1;
			newStr.fontScale = 1.30;
			newStr.sort = 20 - p;
			newStr.alpha = 1;
			newStr.x = 54 + strOffsetX[ p ];
			newStr.y = 80 + strOffsetY[ p ] + i * 15;
			newstr settext( helptext[ i ] );
			if ( p > 0 )
				newStr.color = ( 0, 0, 0 );
			
			newStrArray[ newStrArray.size ] = newStr;
		}
		hudarray[ hudarray.size ] = newStrArray;
	}
	
	devhelp_hudElements( hudarray, 0 );

	while ( 1 )
	{
		update = false;
		if ( level.player buttonpressed( "F1" ) )
		{
				devhelp_hudElements( hudarray, 1 );
				while ( level.player buttonpressed( "F1" ) )
					wait .05;
		}
		devhelp_hudElements( hudarray, 0 );
		wait .05;
	}
	#/ 
}


flag_set_player_trigger( trigger )
{
	flag = trigger get_trigger_flag();
	
	if ( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
	
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( other != level.player )
			continue;
		self script_delay();
		flag_set( flag );
	}
}

flag_set_trigger( trigger )
{
	flag = trigger get_trigger_flag();
	
	if ( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
	
	for ( ;; )
	{
		trigger waittill( "trigger" );
		self script_delay();
		flag_set( flag );
	}
}

flag_unset_trigger( trigger )
{
	flag = trigger get_trigger_flag();
	
	if ( !isdefined( level.flag[ flag ] ) )
		flag_init( flag );
	for ( ;; )
	{
		trigger waittill( "trigger" );
		self script_delay();
		flag_clear( flag );
	}
}

eq_trigger( trigger )
{
	level.set_eq_func[ true ] = ::set_eq_on;
	level.set_eq_func[ false ] = ::set_eq_off;
	targ = getent( trigger.target, "targetname" );
	for ( ;; )
	{
		trigger waittill( "trigger" );
		ai = getaiarray( "allies" );
		for ( i = 0; i < ai.size; i ++ )
		{
			ai[ i ] [[ level.set_eq_func[ ai[ i ] istouching( targ ) ] ]]();
		}
		while ( level.player istouching( trigger ) )
			wait( 0.05 );

		ai = getaiarray( "allies" );
		for ( i = 0; i < ai.size; i ++ )
		{
			ai[ i ] [[ level.set_eq_func[ false ] ]]();
		}
	}
	 /* 
	num = level.eq_trigger_num;
	trigger.eq_num = num;
	level.eq_trigger_num ++ ;
	waittillframeend;// let the ai get their eq_num table created
	waittillframeend;// let the ai get their eq_num table created
	level.eq_trigger_table[ num ] = [];
	if ( isdefined( trigger.script_linkto ) )
	{
		tokens = strtok( trigger.script_linkto, " " );
		for ( i = 0; i < tokens.size; i ++ )
		{
			target_trigger = getent( tokens[ i ], "script_linkname" );
			// add the trigger num to the list of triggers this trigger hears 
			level.eq_trigger_table[ num ][ level.eq_trigger_table[ num ].size ] = target_trigger.eq_num;		
		}
	}
	
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		
		// are we already registered with this trigger?
		if ( other.eq_table[ num ] )
			continue;
			
		other thread [[ level.touched_eq_function[ other.is_the_player ] ]]( num, trigger );
	}
	 */ 
}


player_ignores_triggers()
{
	self endon( "death" );
	self.ignoretriggers = true;
	wait( 1 );
	self.ignoretriggers = false;
}

get_trigger_eq_nums( num )
{
	// tally up the triggers this trigger hears into, including itself
	nums = [];
	nums[ 0 ] = num;
	for ( i = 0; i < level.eq_trigger_table[ num ].size; i ++ )
	{
		nums[ nums.size ] = level.eq_trigger_table[ num ][ i ];
	}
	return nums;
}


player_touched_eq_trigger( num, trigger )
{
	self endon( "death" );

	nums = get_trigger_eq_nums( num );	
	for ( r = 0; r < nums.size; r ++ )
	{
		self.eq_table[ nums[ r ] ] = true;
		self.eq_touching[ nums[ r ] ] = true;
	}

	thread player_ignores_triggers();

	ai = getaiarray();
	for ( i = 0; i < ai.size; i ++ )
	{
		guy = ai[ i ];
		// is the ai in this trigger with us?
		for ( r = 0; r < nums.size; r ++ )
		{
			if ( guy.eq_table[ nums[ r ] ] )
			{
				guy eqoff();
				break;
			}
		}
	}

	while ( self istouching( trigger ) )
		wait( 0.05 );
		
	for ( r = 0; r < nums.size; r ++ )
	{
		self.eq_table[ nums[ r ] ] = false;
		self.eq_touching[ nums[ r ] ] = undefined;
	}
	
	ai = getaiarray();
	for ( i = 0; i < ai.size; i ++ )
	{
		guy = ai[ i ];

		was_in_our_trigger = false;
		// is the ai in the trigger we just left?
		for ( r = 0; r < nums.size; r ++ )
		{
			// was the guy in a trigger we could hear into?
			if ( guy.eq_table[ nums[ r ] ] )
			{
				was_in_our_trigger = true;
			}
		}
		
		if ( !was_in_our_trigger )
			continue;

		// check to see if the guy is in any of the triggers we're still in
	
		touching = getarraykeys( self.eq_touching );
		shares_trigger = false;
		for ( p = 0; p < touching.size; p ++ )
		{
			if ( !guy.eq_table[ touching[ p ] ] )
				continue;
				
			shares_trigger = true;
			break;
		}
		
		// if he's not in a trigger with us, turn his eq back on
		if ( !shares_trigger )
			guy eqOn();
	}
}

ai_touched_eq_trigger( num, trigger )
{
	self endon( "death" );

	nums = get_trigger_eq_nums( num );	
	for ( r = 0; r < nums.size; r ++ )
	{
		self.eq_table[ nums[ r ] ] = true;
		self.eq_touching[ nums[ r ] ] = true;
	}

	// are we in the same trigger as the player?
	for ( r = 0; r < nums.size; r ++ )
	{
		if ( level.player.eq_table[ nums[ r ] ] )
		{
			self eqoff();
			break;
		}
	}
		
	// so other AI can touch the trigger
	self.ignoretriggers = true;
	wait( 1 );
	self.ignoretriggers = false;
	while ( self istouching( trigger ) )
		wait( 0.5 );
		
	nums = get_trigger_eq_nums( num );	
	for ( r = 0; r < nums.size; r ++ )
	{
		self.eq_table[ nums[ r ] ] = false;
		self.eq_touching[ nums[ r ] ] = undefined;
	}
		
	touching = getarraykeys( self.eq_touching );
	for ( i = 0; i < touching.size; i ++ )
	{
		// is the player in a trigger that we're still in?
		if ( level.player.eq_table[ touching[ i ] ] )
		{
			// then don't turn eq back on
			return;
		}
	}

	self eqon();
}

ai_eq()
{
	level.set_eq_func[ false ] = ::set_eq_on;
	level.set_eq_func[ true ] = ::set_eq_off;
	index = 0;
	for ( ;; )
	{
		while ( !level.ai_array.size )
		{
			wait( 0.05 );
		}
		waittillframeend;
		waittillframeend;
		keys = getarraykeys( level.ai_array );
		index ++ ;
		if ( index >= keys.size )
			index = 0;
		guy = level.ai_array[ keys[ index ] ];
		guy [[ level.set_eq_func[ sighttracepassed( level.player geteye(), guy geteye(), false, undefined ) ] ]]();
		wait( 0.05 );
	}
}

set_eq_on()
{
	self eqon();
}

set_eq_off()
{
	self eqoff();
}

add_tokens_to_trigger_flags( tokens )
{
	for ( i = 0; i < tokens.size; i ++ )
	{
		flag = tokens[ i ];
		if ( !isdefined( level.trigger_flags[ flag ] ) )
		{
			level.trigger_flags[ flag ] = [];
		}
		
		level.trigger_flags[ flag ][ level.trigger_flags[ flag ].size ] = self;
	}
}

script_flag_false_trigger( trigger )
{
	// all of these flags must be false for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_false );
	trigger add_tokens_to_trigger_flags( tokens );
	trigger update_trigger_based_on_flags();
}

script_flag_true_trigger( trigger )
{
	// all of these flags must be false for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_true );
	trigger add_tokens_to_trigger_flags( tokens );
	trigger update_trigger_based_on_flags();
}

/*
	for( ;; )
	{
		trigger trigger_on();
		wait_for_flag( tokens );
		
		trigger trigger_off();
		wait_for_flag( tokens );
		for ( i = 0; i < tokens.size; i ++ )
		{
			flag_wait( tokens[ i ] );
		}		
	}
	 */ 


 /* 
script_flag_true_trigger( trigger )
{
	// any of these flags have to be true for the trigger to be enabled
	tokens = create_flags_and_return_tokens( trigger.script_flag_true );

	for ( ;; )
	{
		trigger trigger_off();
		wait_for_flag( tokens );
		trigger trigger_on();
		for ( i = 0; i < tokens.size; i ++ )
		{
			flag_waitopen( tokens[ i ] );
		}		
	}
}
 */ 

wait_for_flag( tokens )
{
	for ( i = 0; i < tokens.size; i ++ )
	{
		level endon( tokens[ i ] );
	}
	level waittill( "foreverrr" );
}

friendly_respawn_trigger( trigger )
{
	spawners = getentarray( trigger.target, "targetname" );
	assertEx( spawners.size == 1, "friendly_respawn_trigger targets multiple spawner with targetname " + trigger.target + ". Should target just 1 spawner." );
	spawner = spawners[ 0 ];
	spawners = undefined;
	
	spawner endon( "death" );
	
	for ( ;; )
	{
		trigger waittill( "trigger" );
		level.respawn_spawner = spawner;
		flag_set( "respawn_friendlies" );
		wait( 0.5 );
	}
}

friendly_respawn_clear( trigger )
{
	for ( ;; )
	{
		trigger waittill( "trigger" );
		flag_clear( "respawn_friendlies" );
		wait( 0.5 );
	}
}

radio_trigger( trigger )
{
	trigger waittill( "trigger" );
	radio_dialogue( trigger.script_noteworthy );	
}

background_block()
{
		assert( isdefined( self.script_bg_offset ) );
		self.origin -= self.script_bg_offset;
}

trigger_ignore( trigger )
{
	thread trigger_runs_function_on_touch( trigger, ::set_ignoreme, ::get_ignoreme );
}

trigger_pacifist( trigger )
{
	thread trigger_runs_function_on_touch( trigger, ::set_pacifist, ::get_pacifist );
}

trigger_runs_function_on_touch( trigger, set_func, get_func )
{
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( other [[ get_func ]]() )
			continue;
		other thread touched_trigger_runs_func( trigger, set_func );
	}
}

touched_trigger_runs_func( trigger, set_func )
{
	self endon( "death" );
	self.ignoreme = true;
	[[ set_func ]]( true );
	// so others can touch the trigger
	self.ignoretriggers = true;	
	wait( 1 );
	self.ignoretriggers = false;
	
	while ( self istouching( trigger ) )
	{
		wait( 1 );
	}
	
	[[ set_func ]]( false );
}

trigger_turns_off( trigger )
{
	trigger waittill( "trigger" );
	trigger trigger_off();
	
	if ( !isdefined( trigger.script_linkTo ) )
		return;
	
	// also turn off all triggers this trigger links to
	tokens = strtok( trigger.script_linkto, " " );
	for ( i = 0; i < tokens.size; i ++ )
		array_thread( getentarray( tokens[ i ], "script_linkname" ), ::trigger_off );
}



script_gen_dump_checksaved()
{
	signatures = getarraykeys( level.script_gen_dump );
	for ( i = 0;i < signatures.size;i ++ )
		if ( !isdefined( level.script_gen_dump2[ signatures[ i ] ] ) )
		{
			level.script_gen_dump[ signatures[ i ] ] = undefined;
			level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "Signature unmatched( removed feature ): " + signatures[ i ];
			
		}
}

script_gen_dump()
{
	// initialize scriptgen dump
	 /#

	script_gen_dump_checksaved();// this checks saved against fresh, if there is no matching saved value then something has changed and the dump needs to happen again.
	
	if ( !level.script_gen_dump_reasons.size )
	{
		flag_set( "scriptgen_done" );
		return;// there's no reason to dump the file so exit
	}
	
	firstrun = false;
	if ( level.bScriptgened )
	{
		println( " " );
		println( " " );
		println( " " );
		println( "^2 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
		println( "^3Dumping scriptgen dump for these reasons" );
		println( "^2 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
		for ( i = 0;i < level.script_gen_dump_reasons.size;i ++ )		
		{
			if ( issubstr( level.script_gen_dump_reasons[ i ], "nowrite" ) )
			{
				substr = getsubstr( level.script_gen_dump_reasons[ i ], 15 );// I don't know why it's 15, maybe investigate - nate
				println( i + ". ) " + substr );
				
			}
			else
				println( i + ". ) " + level.script_gen_dump_reasons[ i ] );
			if ( level.script_gen_dump_reasons[ i ] == "First run" )
				firstrun = true;
		}
		println( "^2 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
		println( " " );
		if ( firstrun )
		{
			println( "for First Run make sure you delete all of the vehicle precache script calls, createart calls, createfx calls( most commonly placed in maps\\" + level.script + "_fx.gsc ) " );
			println( " " );
			println( "replace:" );
			println( "maps\\\_load::main( 1 );" );
			println( " " );
			println( "with( don't forget to add this file to P4 ):" );
			println( "maps\\scriptgen\\" + level.script + "_scriptgen::main();" );
			println( " " );
		}
// 		println( "make sure this is in your " + level.script + ".csv:" );
// 		println( "rawfile, maps / scriptgen/" + level.script + "_scriptgen.gsc" );
		println( "^2 -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- " );
		println( " " );
		println( "^2 / \\ / \\ / \\" );
		println( "^2scroll up" );
		println( "^2 / \\ / \\ / \\" );
		println( " " );
	}
	else
	{
 /* 		println( " " );
		println( " " );
		println( "^3for legacy purposes I'm printing the would be script here, you can copy this stuff if you'd like to remain a dinosaur:" );
		println( "^3otherwise, you should add this to your script:" );
		println( "^3maps\\\_load::main( 1 );" );
		println( " " );
		println( "^3rebuild the fast file and the follow the assert instructions" );
		println( " " );
		
		 */ 
		return;
	}
	
	filename = "scriptgen/" + level.script + "_scriptgen.gsc";
	csvfilename = "zone_source/" + level.script + ".csv";
	
	if ( level.bScriptgened )
		file = openfile( filename, "write" );
	else
		file = 0;

	assertex( file != -1, "File not writeable( check it and and restart the map ): " + filename );

	script_gen_dumpprintln( file, "// script generated script do not write your own script here it will go away if you do." );
	script_gen_dumpprintln( file, "main()" );
	script_gen_dumpprintln( file, "{" );
	script_gen_dumpprintln( file, "" );
	script_gen_dumpprintln( file, "\tlevel.script_gen_dump = [];" );
	script_gen_dumpprintln( file, "" );

	signatures = getarraykeys( level.script_gen_dump );
	for ( i = 0;i < signatures.size;i ++ )
		if ( !issubstr( level.script_gen_dump[ signatures[ i ] ], "nowrite" ) )
			script_gen_dumpprintln( file, "\t" + level.script_gen_dump[ signatures[ i ] ] );

	for ( i = 0;i < signatures.size;i ++ )
		if ( !issubstr( level.script_gen_dump[ signatures[ i ] ], "nowrite" ) )
			script_gen_dumpprintln( file, "\tlevel.script_gen_dump[ " + "\"" + signatures[ i ] + "\"" + " ] = " + "\"" + signatures[ i ] + "\"" + ";" );
		else
			script_gen_dumpprintln( file, "\tlevel.script_gen_dump[ " + "\"" + signatures[ i ] + "\"" + " ] = " + "\"nowrite\"" + ";" );

	script_gen_dumpprintln( file, "" );
	
	keys1 = undefined;
	keys2 = undefined;
	// special animation threading to capture animtrees
	if ( isdefined( level.sg_precacheanims ) )
		keys1 = getarraykeys( level.sg_precacheanims );
	if ( isdefined( keys1 ) )
		for ( i = 0;i < keys1.size;i ++ )
			script_gen_dumpprintln( file, "\tanim_precach_" + keys1[ i ] + "();" );

	
	script_gen_dumpprintln( file, "\tmaps\\\_load::main( 1, " + level.bCSVgened + ", 1 );" );
	script_gen_dumpprintln( file, "}" );
	script_gen_dumpprintln( file, "" );
	
	///animations section
	
// 	level.sg_precacheanims[ animtree ][ animation ]
	if ( isdefined( level.sg_precacheanims ) )
		keys1 = getarraykeys( level.sg_precacheanims );
	if ( isdefined( keys1 ) )
	for ( i = 0;i < keys1.size;i ++ )
	{
		// first key being the animtree
		script_gen_dumpprintln( file, "#using_animtree( \"" + keys1[ i ] + "\" );" );
		script_gen_dumpprintln( file, "anim_precach_" + keys1[ i ] + "()" ); // adds to scriptgendump
		script_gen_dumpprintln( file, "{" );
		script_gen_dumpprintln( file, "\tlevel.sg_animtree[ \"" + keys1[ i ] + "\" ] = #animtree;" ); // adds to scriptgendump get the animtree without having to put #using animtree everywhere.

		keys2 = getarraykeys( level.sg_precacheanims[ keys1[ i ] ] );
		if ( isdefined( keys2 ) )
		for ( j = 0;j < keys2.size;j ++ )
		{
			script_gen_dumpprintln( file, "\tlevel.sg_anim[ \"" + keys2[ j ] + "\" ] = %" + keys2[ j ] + ";" ); // adds to scriptgendump
		
		}
		script_gen_dumpprintln( file, "}" );
		script_gen_dumpprintln( file, "" );
	}
	
	
	if ( level.bScriptgened )
		saved = closefile( file );
	else
		saved = 1; // dodging save for legacy levels
	
	// CSV section	
		
	if ( level.bCSVgened )
		csvfile = openfile( csvfilename, "write" );
	else
		csvfile = 0;
	
	assertex( csvfile != -1, "File not writeable( check it and and restart the map ): " + csvfilename );
	
	signatures = getarraykeys( level.script_gen_dump );
	for ( i = 0;i < signatures.size;i ++ )
		script_gen_csvdumpprintln( csvfile, signatures[ i ] );

	if ( level.bCSVgened )
		csvfilesaved = closefile( csvfile );
	else
		csvfilesaved = 1;// dodging for now

	// check saves
		
	assertex( csvfilesaved == 1, "csv not saved( see above message? ): " + csvfilename );
	assertex( saved == 1, "map not saved( see above message? ): " + filename );

	#/ 
	
	// level.bScriptgened is not set on non scriptgen powered maps, keep from breaking everything
	assertex( !level.bScriptgened, "SCRIPTGEN generated: follow instructions listed above this error in the console" );
	if ( level.bScriptgened )
		assertmsg( "SCRIPTGEN updated: Rebuild fast file and run map again" );
		
	flag_set( "scriptgen_done" );
	
}


script_gen_csvdumpprintln( file, signature )
{
	
	prefix = undefined;
	writtenprefix = undefined;
	path = "";
	extension = "";
	
	
	if ( issubstr( signature, "ignore" ) )
		prefix = "ignore";
	else
	if ( issubstr( signature, "col_map_sp" ) )
		prefix = "col_map_sp";
	else
	if ( issubstr( signature, "gfx_map" ) )
		prefix = "gfx_map";
	else
	if ( issubstr( signature, "rawfile" ) )
		prefix = "rawfile";
	else
	if ( issubstr( signature, "sound" ) )
		prefix = "sound";
	else
	if ( issubstr( signature, "xmodel" ) )
		prefix = "xmodel";
	else
	if ( issubstr( signature, "xanim" ) )
		prefix = "xanim";
	else
	if ( issubstr( signature, "item" ) )
	{
		prefix = "item";
		writtenprefix = "weapon";
		path = "sp/";
	}
	else
	if ( issubstr( signature, "fx" ) )
	{
		prefix = "fx";
	}
	else
	if ( issubstr( signature, "menu" ) )
	{
		prefix = "menu";
		writtenprefix = "menufile";
		path = "ui / scriptmenus/";
		extension = ".menu";
	}
	else
	if ( issubstr( signature, "rumble" ) )
	{
		prefix = "rumble";
		writtenprefix = "rawfile";
		path = "rumble/";
	}
	else
	if ( issubstr( signature, "shader" ) )
	{
		prefix = "shader";
		writtenprefix = "material";
	}
	else
	if ( issubstr( signature, "shock" ) )
	{
		prefix = "shock";
		writtenprefix = "rawfile";
		extension = ".shock";
		path = "shock/";
	}
	else
	if ( issubstr( signature, "string" ) )
	{
		prefix = "string";
		assertmsg( "string not yet supported by scriptgen" ); // I can't find any instances of string files in a csv, don't think we've enabled localization yet
	}
	else
	if ( issubstr( signature, "turret" ) )
	{
		prefix = "turret";
		writtenprefix = "weapon";
		path = "sp/";
	}
	else
	if ( issubstr( signature, "vehicle" ) )
	{
		prefix = "vehicle";
		writtenprefix = "rawfile";
		path = "vehicles/";
	}
	
	
 /* 		
sg_precachevehicle( vehicle )
 */ 

		
	if ( !isdefined( prefix ) )
		return;
	if ( !isdefined( writtenprefix ) )
		string = prefix + ", " + getsubstr( signature, prefix.size + 1, signature.size );
	else
		string = writtenprefix + ", " + path + getsubstr( signature, prefix.size + 1, signature.size ) + extension;

	
	 /* 		
	ignore, code_post_gfx
	ignore, common
	col_map_sp, maps / nate_test.d3dbsp
	gfx_map, maps / nate_test.d3dbsp
	rawfile, maps / nate_test.gsc
	sound, voiceovers, rallypoint, all_sp
	sound, us_battlechatter, rallypoint, all_sp
	sound, ab_battlechatter, rallypoint, all_sp
	sound, common, rallypoint, all_sp
	sound, generic, rallypoint, all_sp
	sound, requests, rallypoint, all_sp	
 */ 

	// printing to file is optional	
	if ( file == -1 || !level.bCSVgened )
		println( string );
	else
		fprintln( file, string );
}

script_gen_dumpprintln( file, string )
{
	// printing to file is optional
	if ( file == -1 || !level.bScriptgened )
		println( string );
	else
		fprintln( file, string );
}

set_player_viewhand_model( viewhandModel )
{
	assert( !isdefined( level.player_viewhand_model ) );	// only set this once per level
	level.player_viewhand_model = viewhandModel;
	precacheModel( level.player_viewhand_model );
}

trigger_hint( trigger )
{
	assertEx( isdefined( trigger.script_hint ), "Trigger_hint at " + trigger.origin + " has no .script_hint" );

	if ( !isdefined( level.displayed_hints ) )
	{
		level.displayed_hints = [];
	}
	// give level script a chance to set the hint string and optional boolean functions on this hint
	waittillframeend;

	hint = trigger.script_hint;
	assertEx( isdefined( level.trigger_hint_string[ hint ] ), "Trigger_hint with hint " + hint + " had no hint string assigned to it. Define hint strings with add_hint_string()" );
	trigger waittill( "trigger", other );

	assertEx( other == level.player, "Tried to do a trigger_hint on a non player entity" );

	if ( isdefined( level.displayed_hints[ hint ] ) )
		return;
	level.displayed_hints[ hint ] = true;
	
	display_hint( hint );
}

stun_test()
{
	
	if ( getDvar( "stuntime" ) == "" )
		setDvar( "stuntime", "1" );
	level.player.allowads = true;


	for ( ;; )
	{
		self waittill( "damage" );
		if ( getDvarint( "stuntime" ) == 0 )
			continue;
		
		thread stun_player( self playerADS() );			
	}
}

stun_player( ADS_fraction )
{
	self notify( "stun_player" );
	self endon( "stun_player" );
	
	if ( ADS_fraction > .3 )
	{
		if ( level.player.allowads == true )
			level.player playsound( "player_hit_while_ads" );
			
		level.player.allowads = false;
		level.player allowads( false );
	}
	level.player setspreadoverride( 20 );
	
	wait( getDvarint( "stuntime" ) );
	
	level.player allowads( true );
	level.player.allowads = true;
	level.player resetspreadoverride();
}

throw_grenade_at_player_trigger( trigger )
{
	trigger endon( "death" );
	
	trigger waittill( "trigger" );

	ThrowGrenadeAtPlayerASAP();
}

flag_on_cleared( trigger )
{
	flag = trigger get_trigger_flag();
	
	if ( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
	
	for ( ;; )
	{
		trigger waittill( "trigger" );
		wait( 1 );
		if ( trigger found_toucher() )
		{
			continue;
		}

		break;
	}
	
	flag_set( flag );
}

found_toucher()
{			
	ai = getaiarray( "axis" );
	for ( i = 0; i < ai.size; i ++ )
	{
		guy = ai[ i ];
		if ( !isalive( guy ) )
		{
			continue;
		}
			
		if ( guy istouching( self ) )
		{
			return true;
		}

		// spread the touches out over time
		wait( 0.1 );
	}
	
	// couldnt find any touchers so do a single frame complete check just to make sure
	
	ai = getaiarray( "axis" );
	for ( i = 0; i < ai.size; i ++ )
	{
		guy = ai[ i ];
		if ( guy istouching( self ) )
		{
			return true;
		}
	}
	
	return false;
}

trigger_delete_on_touch( trigger )
{
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( isdefined( other ) )
		{
			// might've been removed before we got it
			other delete();
		}
	}
}


flag_set_touching( trigger )
{
	flag = trigger get_trigger_flag();
	
	if ( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
	
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		flag_set( flag );
		while ( isalive( other ) && other istouching( trigger ) && isdefined( trigger ) )
		{
			wait( 0.25 );
		}
		flag_clear( flag );
	}
}

 /* 
rpg_aim_assist()
{
	level.player endon( "death" );
	for ( ;; )
	{
		level.player waittill( "weapon_fired" );
		currentweapon = level.player getCurrentWeapon();
		if ( ( currentweapon == "rpg" ) || ( currentweapon == "rpg_player" ) )
			thread rpg_aim_assist_attractor();
	}
}

rpg_aim_assist_attractor()
{
	prof_begin( "rpg_aim_assist" );
	
	// Trace to where the player is looking
	start = level.player getEye();
	direction = level.player getPlayerAngles();
	coord = bullettrace( start, start + vector_multiply( anglestoforward( direction ), 15000 ), true, level.player )[ "position" ];
	
	thread draw_line_for_time( level.player.origin, coord, 1, 0, 0, 10000 );
	
	prof_end( "rpg_aim_assist" );
	
	attractor = missile_createAttractorOrigin( coord, 10000, 3000 );
	wait 3.0;
	missile_deleteAttractor( attractor );
}
*/ 

SetObjectiveTextColors()
{
	// The darker the base color, the more-readable the text is against a stark-white backdrop.
	// However; this sacrifices the "white-hot"ness of the text against darker backdrops.

	MY_TEXTBRIGHTNESS_DEFAULT = "1.0 1.0 1.0";
	MY_TEXTBRIGHTNESS_90 = "0.9 0.9 0.9";
	MY_TEXTBRIGHTNESS_85 = "0.85 0.85 0.85";

	if ( level.script == "armada" )
	{
		SetSavedDvar( "con_typewriterColorBase", MY_TEXTBRIGHTNESS_90 );
		return;
	}

	SetSavedDvar( "con_typewriterColorBase", MY_TEXTBRIGHTNESS_DEFAULT );
}

ammo_pickup( sWeaponType )
{
	// possible weapons that the player could have that get this type of ammo
	validWeapons = [];
	if ( sWeaponType == "grenade_launcher" )
	{
		validWeapons[ 0 ] = "m203_m4";
		validWeapons[ 1 ] = "m203";
		validWeapons[ 2 ] = "gp25";
		validWeapons[ 3 ] = "m4m203_silencer_reflex";
		validWeapons[ 4 ] = "m203_m4_silencer_reflex";
	}
	else if ( sWeaponType == "rpg" )
	{
		validWeapons[ 0 ] = "rpg";
		validWeapons[ 1 ] = "rpg_player";
		validWeapons[ 2 ] = "rpg_straight";
	}
	else if ( sWeaponType == "c4" )
	{
		validWeapons[ 0 ] = "c4";
	}
	else if ( sWeaponType == "claymore" )
	{
		validWeapons[ 0 ] = "claymore";
	}
	assert( validWeapons.size > 0 );
	
	trig = spawn( "trigger_radius", self.origin, 0, 25, 32 );
	
	for(;;)
	{
		trig waittill( "trigger", triggerer );
		
		if ( !isdefined( triggerer ) )
			continue;
		
		if ( triggerer != level.player )
			continue;
		
		// check if the player is carrying one of the valid grenade launcher weapons
		weaponToGetAmmo = undefined;
		weapons = level.player GetWeaponsList();
		for ( i = 0 ; i < weapons.size ; i++ )
		{
			for ( j = 0 ; j < validWeapons.size ; j++ )
			{
				if ( weapons[ i ] == validWeapons[ j ]	 )
					weaponToGetAmmo = weapons[ i ];
			}
		}
		
		// no grenade launcher found
		if ( !isdefined( weaponToGetAmmo ) )
			continue;
		
		// grenade launcher found - check if the player has max ammo already
		if ( level.player GetFractionMaxAmmo( weaponToGetAmmo ) >= 1 )
			continue;
		
		// player picks up the ammo
		break;
	}
	
	// give player one more ammo, play pickup sound, and delete the ammo and trigger
	level.player SetWeaponAmmoStock( weaponToGetAmmo, level.player getWeaponAmmoStock( weaponToGetAmmo ) + 1 );
	level.player playlocalsound( "grenade_pickup" );
	trig delete();
	self delete();
}

get_script_linkto_targets()
{
	targets = [];
	if ( !isdefined( self.script_linkto ) )
		return targets;
		
	tokens = strtok( self.script_linkto, " " );
	for ( i = 0; i < tokens.size; i++ )
	{
		token = tokens[ i ];
		target = getent( token, "script_linkname" );
		if ( isdefined( target ) )
			targets[ targets.size ] = target;
	}
	return targets;
}

delete_link_chain( trigger )
{
	// deletes all entities that it script_linkto's, and all entities that entity script linktos, etc.
	trigger waittill( "trigger" );

	targets = trigger get_script_linkto_targets();
	array_thread( targets, ::delete_links_then_self );
}

delete_links_then_self()
{
	targets = get_script_linkto_targets();
	array_thread( targets, ::delete_links_then_self );
	self delete();
}

/*
	A depth trigger that sets fog
*/
trigger_fog( trigger )
{
	assertex( isdefined( trigger.start_neardist ), "trigger_fog lacks start_neardist" );
	assertex( isdefined( trigger.start_fardist ), "trigger_fog lacks start_fardist" );
	assertex( isdefined( trigger.start_color ), "trigger_fog lacks start_color" );
	assertex( isdefined( trigger.end_color ), "trigger_fog lacks end_color" );
	assertex( isdefined( trigger.end_neardist ), "trigger_fog lacks end_neardist" );
	assertex( isdefined( trigger.end_fardist ), "trigger_fog lacks end_fardist" );

	assertex( isdefined( trigger.target ), "trigger_fog doesnt target an origin to set the start plane" );
	ent = getent( trigger.target, "targetname" );
	assertex( isdefined( ent ), "trigger_fog doesnt target an origin to set the start plane" );
	
	start = ent.origin;
	end = undefined;
	
		
	if( isdefined( ent.target ) )
	{
		// if the origin targets a second origin, use it as the end point
		target_ent = getent( ent.target, "targetname" );
		end = target_ent.origin;
	}
	else
	{
		// otherwise double the difference between the target origin and start to get the endpoint
		end = start + vectorScale( trigger.origin - start, 2 );
	}

//	thread linedraw( start, end, (1,0.5,1) );
//	thread print3ddraw( start, "start", (1,0.5,1) );
//	thread print3ddraw( end, "end", (1,0.5,1) );
	dist = distance( start, end );

	for( ;; )
	{
		trigger waittill( "trigger", other );
		assertEx( other == level.player, "Non-player entity touched a trigger_fog." );

		progress = undefined;
		while( level.player istouching( trigger ) )
		{
			progress = maps\_ambient::get_progress( start, end, dist, level.player.origin );
//			println( "progress " + progress );
	
			if( progress < 0 )
				progress = 0;
			
			if( progress > 1 )
				progress = 1;
	
			trigger set_fog_progress( progress );
			wait( 0.05 );
		}

		// when you leave the trigger set it to whichever point it was closest too		
		if( progress > 0.5 )
			progress = 1;
		else
			progress = 0;

		trigger set_fog_progress( progress );
	}
}

set_fog_progress( progress )
{
	anti_progress = 1 - progress;
	startdist = self.start_neardist * anti_progress + self.end_neardist * progress;
	halfwayDist = self.start_fardist * anti_progress + self.end_fardist * progress;
	color = self.start_color * anti_progress + self.end_color * progress;
	
	SetExpFog( startdist, halfwaydist, color[ 0 ], color[ 1 ], color[ 2 ], 0.4 );
}

remove_level_first_frame()
{
	wait( 0.05 );
	level.first_frame = undefined;
}


no_crouch_or_prone_think( trigger )
{
	for ( ;; )
	{
		trigger waittill( "trigger" );
		while ( level.player istouching( trigger ) )
		{
			level.player AllowProne( false );
			level.player AllowCrouch( false );
			wait( 0.05 );
		}
		level.player AllowProne( true );
		level.player AllowCrouch( true );
	}
}

no_prone_think( trigger )
{
	for ( ;; )
	{
		trigger waittill( "trigger" );
		while ( level.player istouching( trigger ) )
		{
			level.player AllowProne( false );
			wait( 0.05 );
		}
		level.player AllowProne( true );
	}
}


load_friendlies()
{
	if( isdefined( game[ "total characters" ] ) )
	{
		game_characters = game[ "total characters" ];
		println( "Loading Characters: ", game_characters );
	}
	else
	{
		println( "Loading Characters: None!" );
		return;
	}

	ai = getaiarray( "allies" );
	total_ai = ai.size;
	index_ai = 0;

	spawners = getspawnerteamarray( "allies" );
	total_spawners = spawners.size;
	index_spawners = 0;

	while( 1 )
	{
		if( (( total_ai <= 0 ) && ( total_spawners <= 0 ) ) || ( game_characters <= 0 ) )
			return;

		if( total_ai > 0 )
		{
			if( isdefined( ai[ index_ai ].script_friendname ) )
			{
				total_ai -- ;
				index_ai ++ ;
				continue;
			}

			println( "Loading character.. ", game_characters );
			ai[ index_ai ] codescripts\character::new();
			ai[ index_ai ] thread codescripts\character::load( game[ "character" + ( game_characters - 1 ) ] );
			total_ai -- ;
			index_ai ++ ;
			game_characters -- ;
			continue;
		}

		if( total_spawners > 0 )
		{
			if( isdefined( spawners[ index_spawners ].script_friendname ) )
			{
				total_spawners -- ;
				index_spawners ++ ;
				continue;
			}

			println( "Loading character.. ", game_characters );
			info = game[ "character" + ( game_characters - 1 ) ];
			precache( info [ "model" ] );
			precache( info [ "model" ] );
			spawners[ index_spawners ] thread spawn_setcharacter( game[ "character" + ( game_characters - 1 ) ] );
			total_spawners -- ;
			index_spawners ++ ;
			game_characters -- ;
			continue;
		}
	}
}

check_flag_for_stat_tracking( msg )
{
	if ( !issuffix( msg, "aa_" ) )
		return;
		
	[[ level.sp_stat_tracking_func ]]( msg );
}



precache_script_models()
{
	waittillframeend;
	if ( !isdefined( level.scr_model ) )
		return;
	models = getarraykeys( level.scr_model );
	for ( i = 0; i < models.size; i++ )
	{
		precachemodel( level.scr_model[ models[ i ] ] );
	}
}


filmy()
{
	if( getdvar("grain_test") == "" )
		return;
	effect = loadfx( "misc/grain_test" );
	looper = spawn("script_model", level.player geteye() );
	looper setmodel("tag_origin");
	looper hide();
	PlayFXOnTag( effect, looper,"tag_origin" );
	settimescale(1.7);
	while(1)
	{
		wait .05;
		visionsetnaked("sepia");
		looper.origin = level.player geteye() +( vector_multiply( anglestoforward( level.player getplayerangles() ), 50 ) );
	}
}

arcademode_save()
{
	has_save = [];
	has_save[ "cargoship" ] = 			true;
	has_save[ "blackout" ] = 			true;
	has_save[ "armada" ] = 				true;
	has_save[ "bog_a" ] = 				true;
	has_save[ "hunted" ] = 				true;
	has_save[ "ac130" ] = 				true;
	has_save[ "bog_b" ] = 				true;
	has_save[ "airlift" ] = 			true;
	has_save[ "village_assault" ] = 	true;
	has_save[ "scoutsniper" ] = 		true;
	has_save[ "ambush" ] = 				true;
	has_save[ "sniperescape" ] = 		false;
	has_save[ "village_defend" ] = 		false;
	has_save[ "icbm" ] = 				true;
	has_save[ "launchfacility_a" ] = 	true;
	has_save[ "launchfacility_b" ] = 	false;
	has_save[ "jeepride" ] = 			false;
	has_save[ "airplane" ] = 			true;
	
	if ( has_save[ level.script ] )
		return;
		
	wait 2.5;
	imagename = "levelshots / autosave / autosave_" + level.script + "start";
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", imagename, true );
}

player_death_detection()
{
	// a dvar starts high then degrades over time whenever the player dies, 
	// checked from maps\_utility::player_died_recently()
	setdvar( "player_died_recently", "0" );
	thread player_died_recently_degrades();

	level add_wait( ::flag_wait, "missionfailed" );
	level.player add_wait( ::waittill_msg, "death" );
	do_wait_any();
		
	recently_skill = [];
	recently_skill[ 0 ] = 70;
	recently_skill[ 1 ] = 30;
	recently_skill[ 2 ] = 0;
	recently_skill[ 3 ] = 0;
	
	setdvar( "player_died_recently", recently_skill[ level.gameskill ] );
}

player_died_recently_degrades()
{
	for ( ;; )
	{
		recent_death_time = getdvarint( "player_died_recently" );
		if ( recent_death_time > 0 )
		{
			recent_death_time -= 5;
			setdvar( "player_died_recently", recent_death_time );
		}
		wait( 5 );
	}
}