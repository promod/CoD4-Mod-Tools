#include maps\_hud_util;
#include maps\_utility;
#include maps\_debug;
#include maps\_props;
#include animscripts\utility;
#include maps\_vehicle;
#include maps\blackout;
#include common_scripts\utility;
#include maps\_stealth_logic;
#include maps\_anim;

print3DthreadZip( sMessage )
{
	self notify( "stop_3dprint" );
	self endon( "stop_3dprint" );
	self endon( "death" );

	for ( ;; )
	{
		if ( isdefined( self ) )
			print3d( self.origin + ( 0, 0, 0 ), sMessage, ( 1, 1, 1 ), 1, 0.5 );
		wait( 0.05 );
	}
}



bm21_think( sTargetname )
{
	eVehile = spawn_vehicle_from_targetname( sTargetname );
	eVehile thread bm21_artillery_think();

}

bm21_artillery_think()
{
	self endon( "death" );

	aTargets = [];
	tokens = strtok( self.script_linkto, " " );
	for ( i = 0; i < tokens.size; i++ )
		aTargets[ aTargets.size ] = getent( tokens[ i ], "script_linkname" );

	aTargets = array_randomize( aTargets );

	self setturrettargetent( aTargets[ 0 ] );
	self waittill( "turret_rotate_stopped" );	
	flag_wait( "bm21s_attack" );

	timer = [];
	timer[ "bm21_01" ] = 0;
	timer[ "bm21_02" ] = 2.2;
	timer[ "bm21_03" ] = 3.4;
	// big initial volley
	wait( timer[ self.targetname ] );
	for ( i = 0; i < aTargets.size; i++ )
	{
		iTimesToFire = 5;
		for ( p = 0; p < iTimesToFire; p++ )
		{
			self setturrettargetent( aTargets[ i ] );

			self notify( "shoot_target", aTargets[ i ] );
			wait( .45 );
		}
		wait( randomfloatrange( 0.3, 0.7 ) );
	}

		
	assertEx( aTargets.size > 1, "Vehicle at position " + self.origin + " needs to scriptLinkTo more than 1 script_origin artillery targets" );
	for ( ;; )
	{
		flag_wait( "bm21s_fire" );
		
	
		
		bm21_fires_until_flagged( aTargets  );
	}
}

bm21_fires_until_flagged( aTargets )
{
	level endon( "bm21s_fire" );
	aTargets = array_randomize( aTargets );

	wait( randomfloatrange( 2, 3 ) );
	
	for ( i = 0; i < aTargets.size; i++ )
	{
		iTimesToFire = 2 + randomint( 2 );
		for ( i2 = 0; i2 < iTimesToFire; i2++ )
		{
			if ( i2 == 0 )
			{
				self setturrettargetent( aTargets[ i ] );
				self waittill( "turret_rotate_stopped" );	
				wait( 1 );	
			}

			self notify( "shoot_target", aTargets[ i ] );
			wait( .25 );
		}
	}
}

die_soon()
{
	self endon( "death" );
	wait( randomfloatrange( 0.5, 1.5 ) );
	self die();
}

kill_player()
{
	self endon( "death" );
	self.baseaccuracy = 10;
	self.goalradius = 256;
	for ( ;; )
	{
		self setgoalpos( level.player.origin );
		wait( 2 );
	}
}


second_shack_trigger()
{
	self waittill( "trigger" );
	/* 
	axis = getaiarray( "axis" );
	if ( axis.size )
	{
		array_thread( axis, ::die_soon );
		flag_wait( "hut_cleared" );
	}
	*/ 
	thread chess_guys();
	thread sleepy_shack();
	flag_set( "second_shacks" );
}

sleepy_shack()
{
	shack_guys = getentarray( "shack_guy", "targetname" );
	array_thread( shack_guys, ::spawn_ai );
	
	shack_light = getent( "shack_light", "targetname" );
	intensity = shack_light getLightIntensity();
	shack_light setLightIntensity( 0 );
	
	flag_wait( "second_shacks" );
	flag_wait( "high_alert" );
	wait( 1.5 );
	
	sleep_alert_trigger = getent( "sleep_alert_trigger", "targetname" );
	if ( level.player istouching( sleep_alert_trigger ) )
	{
		// don't flick the lights on if the player is standing in a place that reveals our lack of light flicking animation
		return;
	}
	
	// light flickers on
	/* 
	shack_light setLightIntensity( intensity );
	wait( 0.3 );
	shack_light setLightIntensity( 0 );
	wait( 0.01 );
	shack_light setLightIntensity( intensity );
	wait( 0.2 );
	shack_light setLightIntensity( 0 );
	wait( 1 );

	timer = 2;
	timer *= 20;
	
	for ( i = 0; i < timer; i++ )
	{
		new_intensity = intensity * ( 1 / ( timer - i ) );
		new_intensity *= randomfloatrange( 0.3, 1.7 );
		shack_light setLightIntensity( new_intensity );
		wait( 0.05 );
	}
	*/ 

	timer = 2;
	timer *= 20;
	for ( i = 0; i < timer; i++ )
	{
		new_intensity = intensity * ( 1 / ( timer - i ) );
		new_intensity *= randomfloatrange( 0.3, 1.7 );
		shack_light setLightIntensity( new_intensity );
		wait( 0.05 );
	}
	
	shack_light setLightIntensity( intensity );
}

guy_stops_animating_on_high_alert( node, react_anim, built_in )
{
	self endon( "death" );
// 	flag_assert( "high_alert" );
	level waittill( "high_alert" );
	node notify( "stop_loop" );
	
	// animates from elsewhere?
	if ( isdefined( built_in ) )
		return;
	
	if ( isdefined( react_anim ) )
	{
		self anim_generic( self, react_anim );
	}
	else
	{
		self stopanimscripted();
	}
}

chess_guys_drop_weapon()
{
	model = spawn( "script_model", (0,0,0) );
	model setmodel( "weapon_" + self.weapon );
	model linkto( self, "TAG_WEAPON_RIGHT", (0,0,0), (0,0,0) );
	wait( 1 );
	model unlink();
	self gun_remove();
	self waittill_either( "stop_loop", "death" );
	if ( isalive( self ) )
		self gun_recall();
	model delete();
//	maps\_debug::drawtagforever( "TAG_WEAPON_RIGHT" );
}
	
chess_guys()
{
	guy1 = get_guy_with_script_noteworthy_from_spawner( "chess_guy_1" );
	guy2 = get_guy_with_script_noteworthy_from_spawner( "chess_guy_2" );
	if ( flag( "high_alert" ) )
		return;
		
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "spotted"]	= getdvar( "ai_eventDistBullet" );
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "alert" ] 	= 200;
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "hidden" ] 	= 200;
	
	stealth_detect_ranges_set( undefined, undefined, undefined );
		
	guy1.animname = "chess_guy1";
	guy2.animname = "chess_guy2";
	guys = [];
	guys[ guys.size ] = guy1;
	guys[ guys.size ] = guy2;


	array_thread( guys, ::set_deathanim, "death" );
	array_thread( guys, ::set_allowdeath, true );

	node = getent( "chess_ent", "targetname" );
	node2 = spawn( "script_origin", node.origin );
	node2.angles = node.angles;
	node thread stealth_ai_idle_and_react( guy1, "idle_1", "surprise_1" );
	node2 thread stealth_ai_idle_and_react( guy2, "idle_2", "surprise_2" );
	
	
	array_thread( guys, ::chess_guys_drop_weapon );
	array_thread( guys, ::add_wait, ::player_got_close );
	array_thread( guys, ::add_wait, ::waittill_msg, "death" );
	array_thread( guys, ::add_wait, ::waittill_msg, "stop_loop" );
	do_wait_any();
	guys = remove_dead_from_array( guys );
	array_thread( guys, ::clear_deathanim );
	array_thread( guys, ::chess_guys_investigate );
}

player_got_close()
{
	self endon( "death" );
	for ( ;; )
	{
		if ( distance( level.player.origin, self.origin ) < 46 )
			return;
		wait( 0.05 );
	}
}

chess_guys_investigate()
{
	//thread maps\_stealth_behavior::enemy_stop_current_behavior();
	self notify( "event_awareness", "explosion" );
	if ( !isdefined( self.target ) )
		return;
	node = getnode( self.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = node.radius;
}

chess_guy_init( node )
{
	self.allowdeath = true;
	self thread custom_stealth_ai();
	self thread guy_stops_animating_on_high_alert( node, undefined, true );
}

descriptions()
{
	descriptions = getentarray( "description", "targetname" );
	for ( i = 0;i < descriptions.size;i++ )
		descriptions[ i ] thread print3DthreadZip( descriptions[ i ].script_noteworthy );
}


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    MAIN TOWN START
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/ 
AA_town_init()
{
	thread bm21_spawn_and_think();
}


bm21_spawn_and_think()
{
	flag_set( "bm21s_fire" );
	aBM21targetnames = [];
	aBM21targetnames[ aBM21targetnames.size ] = "bm21_01";
	aBM21targetnames[ aBM21targetnames.size ] = "bm21_02";
	aBM21targetnames[ aBM21targetnames.size ] = "bm21_03";
// 	aBM21targetnames[ 3 ] = "bm21_04";
	
	for ( i = 0;i < aBM21targetnames.size;i++ )
		thread bm21_think( aBM21targetnames[ i ] );
}


empty( fuk )
{
}

custom_stealth_ai()
{
/* 
	alert_functions[ 1 ] = ::empty;
	alert_functions[ 2 ] = ::empty;
	alert_functions[ 3 ] = ::empty;
*/ 
	
	awareness_functions = [];
	/* 
	if ( isdefined( self.stealth_whizby_reaction ) )
	{
		awareness_functions[ "bulletwhizby"	 ] = ::enemy_awareness_reaction_whizby;
	}
	*/ 
	
// 	awareness_functions[ "explode" ] = ::enemy_hears_explosion;

	alert_functions = [];
// 	alert_functions[ "attack" ] = ::enemy_attacks;
	
	
	thread stealth_ai( undefined, alert_functions, undefined, awareness_functions );
}

enemy_attacks( type )
{
	self endon( "death" );
	self endon( "pain_death" );
	
	self thread maps\_stealth_behavior::enemy_announce_spotted( self.origin );
			
	// might have to link this into enemy_awareness_reaction_attack() at some point
// 	self setgoalpos( enemy.origin );
	self.goalradius = 2048;
}

enemy_hears_explosion( type )
{
	anime = "_stealth_behavior_whizby_" + randomint( 5 );	
	
	self ent_flag_set( "_stealth_behavior_first_reaction" );
	self ent_flag_set( "_stealth_behavior_reaction_anim" );
	
	self stopanimscripted();
	self notify( "stop_animmode" );
	self notify( "end_patrol" );
	
	waittillframeend;

	self.allowdeath = true;
	self anim_generic_custom_animmode( self, "gravity", "bored_alert" );

	// self stopanimscripted();
	self ent_flag_clear( "_stealth_behavior_reaction_anim" );
	self.goalradius = 1024;
}

enemy_awareness_reaction_whizby( type )
{
	self endon( "death" );
	
	enemy = self._stealth.logic.event.awareness[ type ];
	
/* 
	vec1 = undefined;
	if ( isplayer( enemy ) )
		vec1 = anglestoforward( enemy getplayerangles() );
	else
		vec1 = anglestoforward( enemy gettagangles( "tag_flash" ) );
	
	point = enemy.origin + vector_multiply( vec1, distance( enemy.origin, self.origin ) );
	
	vec1 = vectornormalize( point - self.origin );
	vec2 = anglestoright( self.angles );
	
	anime = undefined;
	
	if ( vectordot( vec1, vec2 ) > 0 )
		anime = "_stealth_behavior_whizby_right";
	else
		anime = "_stealth_behavior_whizby_left";
*/ 
	
	if ( self ent_flag( "_stealth_behavior_first_reaction" ) )
		return;	
	
	anime = "_stealth_behavior_whizby_" + randomint( 5 );	
	
	self ent_flag_set( "_stealth_behavior_first_reaction" );
	self ent_flag_set( "_stealth_behavior_reaction_anim" );
	
	self stopanimscripted();
	self notify( "stop_animmode" );
	self notify( "end_patrol" );
	
	waittillframeend;

	self.allowdeath = true;
	self anim_generic_custom_animmode( self, "gravity", self.stealth_whizby_reaction );

	// self stopanimscripted();
	self ent_flag_clear( "_stealth_behavior_reaction_anim" );
}


hut_think()
{
	self set_generic_run_anim( "casual_patrol_walk" );
	custom_stealth_ai();
	
	self.disablearrivals = true;
}

pier_trigger_think()
{
	self waittill( "trigger", other );
	
	other.allowdeath = true;

	other thread anim_generic( other, "smoke" );
	other endon( "death" );
	other waittill( "damage" );
	other stopanimscripted();
// 	@$e90._stealth.logic.alert_level.lvl
// 	bored_alert
// 	self stealth_enemy_waittill_alert();
}

reach_and_idle_relative_to_target( reach, idle, react )
{
	targ = getent( self.target, "targetname" );
	targ thread stealth_ai_reach_idle_and_react( self, reach, idle, react );
}

idle_relative_to_target( idle, react )
{
	targ = getent( self.target, "targetname" );
	targ thread stealth_ai_idle_and_react( self, idle, react );
}

hut_sentry()
{
/* 
	self set_generic_run_anim( "casual_patrol_walk" );
	self.stealth_whizby_reaction = "bored_alert";
	custom_stealth_ai();
	self.disablearrivals = true;
*/ 
}

signal_stop()
{
	self waittill( "trigger", other );
	
	// big battle going on
	if ( flag( "high_alert" ) )
		return;

	other handSignal( "stop" );
	
}

bored_guy()
{
	self endon( "death" );
	
	targ = getent( self.target, "targetname" );
	
	targ thread anim_generic_loop( self, "bored_idle", undefined, "stop_idle" );
	flag_wait( "high_alert" );
	targ notify( "stop_idle" );
	self stopanimscripted();
}


hut_tv()
{
	// tv turns off when it gets shot
	thread bbc_voice();
	
	light = getent( "tv_light", "targetname" );
	light thread maps\_lights::television();
	
	// did the tv get shot?
	wait_for_targetname_trigger( "tv_trigger" );
	
	light notify( "light_off" );
	light setLightIntensity( 0 );
	level.bbc_voice stopsounds();
	level.bbc_voice notify( "stopsounds" );
	wait( 0.05 );
	level.bbc_voice delete();
}

bbc_voice()
{
	org = spawn( "script_origin", ( -13630.8, -8353.29, 28.5023 ) );
	org endon( "death" );
	org endon( "stopsounds" );
	level.bbc_voice = org;
	aliases = [];
	aliases[ aliases.size ] = "blackout_bbc_lessthanday";
	aliases[ aliases.size ] = "blackout_bbc_foreigninterest";
	aliases[ aliases.size ] = "blackout_bbc_exacttime";
	
	index = 0;
	
	for ( ;; )
	{
		org playsound( aliases[ index ], "done" );
		org waittill( "done" );
		wait( randomfloatrange( 1, 2 ) );
		index++;
		if ( index >= aliases.size )
			index = 0;
	}
}

friendly_think()
{
	self.maxvisibledist = 480;
	self.ignoreme = true;
	for ( ;; )
	{
		self.ignoreall = true;
		flag_wait_either( "high_alert", "recent_flashed" );
		wait( 0.5 );
		self.ignoreme = false;
		self.ignoreall = false;
		flag_waitopen( "high_alert" );
		flag_waitopen( "recent_flashed" );
	}
}

shack_sleeper()
{
//	self thread high_alert_on_death();
	self.allowdeath = true;
	
	chair = spawn_anim_model( "chair" );
	self.has_delta = true;
	self.anim_props = make_array( chair );
	thread idle_relative_to_target( "sleep_idle", "sleep_react" );
	targ = getent( self.target, "targetname" );
// 	targ thread drawOriginForever();
// 	targ thread anim_generic_loop( self, "sleep_idle", undefined, "stop_idle" );
	targ thread anim_first_frame_solo( chair, "sleep_react" );
	if ( 1 )
		return;
	

	flag_wait( "high_alert" );
	
	chair notify( "stop_first_frame" );
// 	targ notify( "stop_idle" );
// 	targ thread anim_generic( self, "sleep_react" );
	chair playsound( "scn_relaxed_guard_chair_fall" );
	targ thread anim_single_solo( chair, "sleep_react" );
	wait( 3.73 * 0.77 );

	if ( isalive( self ) )
	{
		self stopanimscripted();
		self notify( "single anim", "end" );
	}
}

high_alert_on_death()
{
	self waittill( "death" );
	flag_set( "_stealth_spotted" );
}

outpost_objectives()
{	
	thread hut_friendlies_chats_about_russians();
//	flag_wait( "introscreen_text_gone" );
	wait( 6 );
	hut_obj_org = getent( "hut_obj_org", "targetname" );
// Eliminate the outer guard posts.
	Objective_Add( 1, "current", &"BLACKOUT_ELIMINATE_THE_OUTER_GUARD", hut_obj_org.origin );
	field_org = getent( "field_org", "targetname" );
	Objective_Add( 2, "active", &"BLACKOUT_MEET_THE_RUSSIAN_LOYALISTS", field_org.origin );
	
	flag_wait( "hut_cleared" );
	chess_obj_org = getent( "chess_obj_org", "targetname" );
	objective_position( 1, chess_obj_org.origin );
	

	flag_wait( "chess_cleared" );
	shack_obj_org = getent( "shack_obj_org", "targetname" );
	objective_position( 1, shack_obj_org.origin );
	
	flag_wait( "shack_cleared" );
	objective_complete( 1 );
	autosave_by_name( "other_huts_cleared" );
	
// "Meet the Russian Loyalists at the field.", field_org.origin );

	Objective_State( 2, "current" );
}

field_russian_think()
{
	level.field_russians[ level.field_russians.size ] = self;
	self endon( "death" );
	self allowedstances( "prone" );	
	self.fixednode = false;
	self.drawoncompass = false;
	self.goalradius = 16;
	flag_wait( "russians_stand_up" );
	wait( randomfloat( 1 ) );
	if ( cointoss() )
		self allowedstances( "stand" );
	else
		self allowedstances( "crouch" );
	
	if ( isdefined( self.script_linkto ) )
	{
		self allowedstances( "stand" );
		path = getent( self.script_linkto, "script_linkname" );
		self.disablearrivals = true;
		self.disableexits = true;
		self maps\_spawner::go_to_origin( path );
		self.disablearrivals = false;
		self.disableexits = false;
	}
	self.goalradius = 16;

	self waittill( "go_up_hill" );
	
	self allowedstances( "stand", "crouch", "prone" );
	wait( randomfloatrange( 0.1, 1.7 ) );
	self.drawoncompass = true;
	nodes = getnodearray( "hilltop_delete_node", "targetname" );
	node = undefined;
	for ( i = 0; i < nodes.size; i++ )
	{
		if ( !isdefined( nodes[ i ].taken ) )
		{
			node = nodes[ i ];
			break;
		}
	}
	node.taken = true;
	
	if ( isdefined( self.script_noteworthy ) )
	{
		org = getent( self.script_noteworthy, "targetname" );
		self setgoalpos( org.origin );
		self.goalradius = 8;
		self.interval = 0;
		self waittill( "goal" );
		
		for ( ;; )
		{
			if ( flag( "field_go" ) )
				break;
			angles = vectortoangles( level.price.origin - self.origin );
			yaw = angles[ 1 ];
			self OrientMode( "face angle", yaw );
			wait( 0.05 );
		}
		/*
		flag_wait( "field_stop" );
		timers = [];
		timers[ "stopper_1" ] = 1.2;
		timers[ "stopper_2" ] = 1.2;
		timers[ "stopper_3" ] = 3.0;
		thread pr();
		wait( timers[ self.script_noteworthy ] );
		self setgoalpos( self.origin );
		angles = vectortoangles( level.price.origin - self.origin );
		yaw = angles[ 1 ];
		self OrientMode( "face angle", yaw );
		*/
		flag_wait( "field_go" );
		self OrientMode( "face default" );
		self setgoalnode( node );
	}
	else
		self setgoalnode( node );
	
	self.fixednode = true;
	self.goalradius = 16;
	
	flag_wait( "player_at_overlook" );
	self delete();
	
	// prone_to_stand_1, prone_to_stand_2, prone_to_stand_3
// 	self anim_generic( self, "prone_to_stand_" + ( randomint( 3 ) + 1 ) );
}

hilltop_mortar_team( msg )
{
	ent = getent( msg, "targetname" );
	self.goalradius = 16;
	self setgoalpos( ent.origin );
}

russian_leader_think( first_scene )
{
	level.kamarov = self;
	self.drawOnCompass = false;
	self.animname = "kamarov";
	if ( isdefined( first_scene ) )
	{
		self setgoalpos( self.origin );
		self.goalradius = 8;
	}

	flag_wait( "russians_stand_up" );
	self.drawOnCompass = true;
}

kamarov()
{
	return level.kamarov.script_friendname;
}

setup_sas_buddies()
{
	level.price = getent( "price", "targetname" );
	level.price.animname = "price";
	level.gaz = getent( "gaz", "targetname" );
	level.gaz.animname = "gaz";
	level.price thread waterfx( "shack_cleared" );
	level.gaz thread waterfx( "shack_cleared" );
	level.player thread waterfx( "shack_cleared" );
	
	level.price animscripts\init::initWeapon( "m4m203_silencer_reflex", "primary" );
	level.price animscripts\shared::placeWeaponOn( "m4m203_silencer_reflex", "right" );
	level.price.primaryweapon = level.price.weapon;
	level.price.lastweapon = level.price.weapon;
	
	
	level.gaz animscripts\init::initWeapon( "m4m203_silencer_reflex", "primary" );
	level.gaz animscripts\shared::placeWeaponOn( "m4m203_silencer_reflex", "right" );
	level.gaz.primaryweapon = level.gaz.weapon;
	level.gaz.lastweapon = level.gaz.weapon;

	
// 	level.bob = getent( "bob", "targetname" );
// 	level.bob.animname = "bob";
	
	level.price make_hero();
	level.gaz make_hero();
// 	level.bob make_hero();

// 	level.bob delete();
	allies = getaiarray( "allies" );
	array_thread( allies, ::sas_main_think );
}

aim_at_overlook_fight()
{
	self waittill( "goal" );
	friendly_cliff_target = getent( "friendly_cliff_target", "targetname" );
	self cqb_walk( "on" );
	self cqb_aim( friendly_cliff_target );
	flag_wait( "overlook_attack_begins" );
	self cqb_aim();
	self cqb_walk( "off" );
}

player_push_toggle()
{
	flag_wait( "burning_door_open" );
//	self pushplayer( false );
	flag_wait( "player_reaches_cliff_area" );
//	self pushplayer( true );
}

sas_main_think()
{
	self.battleChatter = false;
	self.baseaccuracy = 10000;
	self.grenadeammo = 0;
	self ent_flag_init( "rappelled" );
	thread magic_bullet_shield();
	thread player_push_toggle();
	go_to_overlook = false;
	
	if ( !flag( "go_up_hill" ) )
	{
		go_to_overlook = true;
		enable_cqbwalk();
	
		flag_wait( "gaz_and_price_go_up_hill" );	
		disable_cqbwalk();
		hilltop_friendly_orgs = getentarray( "hilltop_friendly_org", "targetname" );
		
		for ( i = 0; i < hilltop_friendly_orgs.size; i++ )
		{
			if ( !isdefined( hilltop_friendly_orgs[ i ].used ) )
			{
				hilltop_friendly_orgs[ i ].used = true;
				self setgoalpos( hilltop_friendly_orgs[ i ].origin );
				self.goalradius = 16;
				break;
			}
		}
	}
	
	self notify( "stop_going_to_node" );
	self.baseaccuracy = 1;

	if ( !flag( "go_to_overlook" ) || go_to_overlook )
	{
		flag_wait( "go_to_overlook" );
		self.maxvisibledist = 8000;
		
		if ( self == level.gaz )
			self.ignoreall = true;
	
		nodes = [];
		nodes[ "price" ] = "price_overlook_node";
		nodes[ "gaz" ] = "gaz_overlook_node";
//		nodes[ "kamarov" ] = "bob_overlook_node";
		
		self.ignoreall = true;
		self.ignoreme = true;
		self notify( "stop_going_to_node" );

		if ( self != level.kamarov )
		{
			node = getnode( nodes[ self.animname ], "targetname" );
			self setgoalnode( node );
		}
		else
		{
			node = getent( "kaz_overlook_org", "targetname" );
			self setgoalpos( node.origin );
		}
		
		self.goalradius = 16;
		if ( self == level.price )
		{
			thread aim_at_overlook_fight();
		}
		if ( self == level.kamarov )
		{
			self pushplayer( true );
			self waittill( "goal" );
			wait( 1 );
			level.binocs = self get_prop( "binocs" );
			node thread anim_loop_solo( self, "binoc_idle" );
		}
	}
	
	if ( !flag( "overlook_attack_begins" ) )
	{
		self.ignoreall = true;
		self.ignoreme = true;
		flag_wait( "overlook_attack_begins" );
		self.ignoreall = false;
		self.ignoreme = false;
	}

	if ( is_overlook_or_earlier_start() )
	{
		if ( self == level.kamarov )
		{
			flag_wait( "kam_go_through_burning_house" );	
			node = getent( "kaz_overlook_org", "targetname" );
			node notify( "stop_loop" );
			level.binocs delete();
			level.kamarov set_force_color( "y" );
		}
		else
		{
			flag_wait( "go_through_burning_house" );
		}
		
		if ( self == level.gaz )
		{
			self.ignoreall = false;
			wait( 1.2 );
			level.price set_force_color( "r" );
		}
		if ( self == level.price )
		{
			wait( 0.5 );
			level.gaz set_force_color( "o" );
		}
		
		self.ignoreall = true;
	}
	
	if ( is_rappel_or_earlier_start() )
	{
		flag_wait( "power_plant_cleared" );
		
		if ( !self ent_flag( "rappelled" ) )
		{
			if ( self == level.price )
			{
				thread cliff_dialogue();
			}
			flag_wait( "head_to_the_cliff" );
			
			self set_force_color( "g" );
			self.ignoreme = true;
	
			if ( self == level.kamarov )
			{
				flag_wait( "kam_heads_to_rappel_spot" );
				self disable_ai_color();
				node = getnode( "kam_power_node", "targetname" );
				self setgoalnode( node );
				self.goalradius = 16;
			}
			else
			{
				flag_wait( "head_to_rappel_spot" );
				self.disableexits = true;
				self.interval = 0;
				self set_force_color( "p" );
			}
			self.ignoreall = true;
			
			if ( self.animname == "kamarov" )
			{
				flag_wait( "player_finishes_rappel" );
				self stop_magic_bullet_shield();
				self delete();
				return;
			}
			self ent_flag_wait( "rappelled" );
			if ( self == level.price )
			{
				self endon( "death" );
//				thread price_swap();
			}
			self.ignoreall = false;
		}
	}

	sas_handle_farm();
}

sas_handle_farm()
{	
	self set_force_color( "r" );
	flag_wait( "rpg_guy_attacks_bm21s" );
	self set_force_color( "o" );
	
}


blackout_stealth_settings()
{
	// these values represent the BASE huristic for max visible distance base meaning 
	// when the character is completely still and not turning or moving
	// HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]	 = 70;
	hidden[ "crouch" ]	 = 260;
	hidden[ "stand" ]	 = 380;
	
	// ALERT levels are when the same AI has sighted the same enemy twice OR found a body	
	alert = [];
	alert[ "prone" ]	 = 140;
	alert[ "crouch" ]	 = 900;
	alert[ "stand" ]	 = 1500;

	// SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	// distance they can see you is still limited by these numbers because of the assumption that
	// you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	 = 512;
	spotted[ "crouch" ]	 = 5000;
	spotted[ "stand" ]	 = 8000;
	
	stealth_detect_ranges_set( hidden, alert, spotted );
}


setup_player()
{
	level.player thread stealth_ai();
	level.player._stealth_move_detection_cap = 100;
}


hilltop_sniper()
{
	guys = get_guys_with_targetname_from_spawner( "hilltop_sniper" );
	array_thread( guys, ::hilltop_sniper_moves_in );
	array_thread( guys, ::ground_allied_forces );
}

hilltop_sniper_moves_in()
{
	self endon( "death" );
	self.ignoreall = true;
	self.ignoreme = true;
	
// 	wait_for_targetname_trigger( "prone_trigger" );
// 	self thread anim_custommode( self, "prone_dive" );
	
	
	targ = getent( self.target, "targetname" );
	
	targ anim_generic_reach( self, "prone_dive" );
	self allowedstances( "prone" );
	targ thread anim_generic_custom_animmode( self, "gravity", "prone_dive" );
	wait( 1.2 );
	self notify( "stop_animmode" );
	
	targ = getnode( targ.target, "targetname" );
	
	self setgoalpos( targ.origin );
	self.goalradius = 32;

	flag_wait( "overlook_attack_begins" );
	self allowedstances( "prone", "crouch" );
	
	self.ignoreall = false;
	self.ignoreme = false;
}

hut_cleared()
{
	flag_wait( "hut_guys" );
	flag_wait( "pier_guys" );
	flag_set( "hut_cleared" );
}


set_high_alert_on_alarm()
{
	self endon( "death" );
	stealth_enemy_waittill_alert();
	flag_set( "high_alert" );
}

set_high_alert()
{
	level endon( "overlook_attack_begins" );
	level endon( "instant_high_alert" );
	array_thread( level.deathflags[ "hut_guys" ][ "ai" ], ::set_high_alert_on_alarm );
	
	for ( ;; )
	{
		level add_wait( ::flag_wait, "high_alert" );
		level add_wait( ::flag_wait, "_stealth_spotted" );
//		level add_wait( ::flag_wait, "_stealth_alert" );
		level add_wait( ::_waittillmatch, "event_awareness", "heard_corpse" );
		level add_wait( ::_waittillmatch, "event_awareness", "heard_scream" );
		level add_wait( ::_waittillmatch, "event_awareness", "explode" );
		level add_wait( ::_waittillmatch, "event_awareness", "doFlashBanged" );		

//		level add_wait( ::flag_wait, "_stealth_alert" );
		do_wait_any();
	
		flag_set( "high_alert" );
		for ( ;; )
		{
			ai = getaiarray( "axis" );
			if ( !ai.size )
				break;
			
			if ( flag( "hut_cleared" ) )
			{
				wait( 0.05 );
				continue;
			}
			
			has_enemy = false;
			for ( i = 0; i < ai.size; i++ )
			{
				if ( !isalive( ai[ i ].enemy ) )
					continue;
				has_enemy = true;
				break;
			}
			if ( !has_enemy )
				break;
			wait( 0.05 );
				
			/*
				
			if ( flag( "_stealth_spotted" ) )
			{
				wait( 0.05 );
				continue;
			}
			if ( flag( "_stealth_alert" ) )
			{
				wait( 0.05 );
				continue;
			}
			break;
			*/
		}
		flag_clear( "high_alert" );
		wait( 0.05 );
	}	
}

overlook_runner_think()
{
	self endon( "death" );
	overlook_enemy_waits_for_player();
	overlook_enemy_leaves_stealth();
}

street_walker_think()
{
	self endon( "death" );
	overlook_enemy_waits_for_player();
	// ends when stealth is broken
	if ( !isdefined( level.street_walker_delay ) )
		level.street_walker_delay = 0.0;
	else
		level.street_walker_delay+= randomfloatrange( 0.2, 0.4 );
		
	wait( level.street_walker_delay );
	maps\_patrol::patrol( self.target );
	overlook_enemy_leaves_stealth();
}

overlook_enemy_waits_for_player()
{
	self thread custom_stealth_ai();
	flag_wait( "player_at_overlook" );
}
	
overlook_enemy_leaves_stealth()
{

	flag_wait( "_stealth_spotted" );
	
	
// 	if ( !isdefined( level.attention_getter ) )
	{
		level.attention_getter = true;
		overlook_attention = getent( "overlook_attention", "targetname" );
		self setgoalpos( overlook_attention.origin );
		self.goalradius = overlook_attention.radius;
		self waittill( "goal" );
		if ( !flag( "overlook_attention" ) )
		{
			flag_set( "overlook_attention" );
			wait( 3 );
		}
	}

	set_goalpos_and_volume_from_targetname( "enemy_overlook_defense" );
}

breach_first_building()
{
	breach_guys = get_guys_with_targetname_from_spawner( "breach_spawner" );
	/* 
	breach_guys = [];
	breach_guys[ breach_guys.size ] = get_closest_colored_friendly( "c" );
	breach_guys[ breach_guys.size ] = get_closest_colored_friendly( "b" );
	*/ 
	
	for ( i = 0; i < breach_guys.size; i++ )
	{
		spawn_failed( breach_guys[ i ] );
	}
	
	array_thread( breach_guys, ::pre_breach );

	first_house_breach_volume = getent( "first_breach_volume", "targetname" );
	first_house_breach_volume maps\_breach::breach_think( breach_guys, "explosive_breach_left" );
	
	array_thread( breach_guys, ::post_breach );
	flag_set( "breach_complete" );
}

pre_breach()
{
	self thread magic_bullet_shield();
	self.ignoreall = true;
	self.ignoreme = true;
}

post_breach()
{
	self stop_magic_bullet_shield();
// 	self enable_ai_color();
	self.ignoreall = false;
	self.ignoreme = false;
	self delete();
}

spawn_replacement_baddies()
{
	level endon( "cliff_fighting" );
	count = 10;
	spawners = getentarray( "enemy_reinforce_spawner", "targetname" );
	
	spawners = array_randomize( spawners );
	array_thread( spawners, ::add_spawn_function, ::fall_back_to_defensive_position );

	index = 0;	
	for ( ;; )
	{
		axis = getaiarray( "axis" );
		if ( axis.size > 10 )
		{
			wait( 1 );
			continue;
		}

		spawner = spawners[ index ];
		spawner.count = 1;
		spawner spawn_ai();
		index++ ;
		if ( index >= spawners.size )
			index = 0;

		wait( 0.5 );
	}
}

fall_back_to_defensive_position()
{
	self endon( "death" );
	self endon( "long_death" );
	thread macmillan_proud_hook();
	
	if ( !flag( "mgs_cleared" ) )
	{
		set_goalpos_and_volume_from_targetname( "enemy_overlook_defense" );
		flag_wait( "mgs_cleared" );
	}
	
	if ( !flag( "player_reaches_cliff_area" ) )
	{
		set_goalpos_and_volume_from_targetname( "enemy_first_defense" );
		flag_wait( "player_reaches_cliff_area" );
	}
	
	defend_second_area();
}

teleport_and_take_node_by_targetname( targetname )
{
	nodes = getnodearray( targetname, "targetname" );
	for ( i = 0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		if ( isdefined( node.taken ) )
			continue;
		node.taken = true;
		self teleport( node.origin );
		self.goalradius = 32;
		self setgoalnode( node );
		return;
	}
}

set_flag_on_player_damage( msg )
{
	flag_assert( msg );
	level endon( msg );
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "damage", amt, entity, enemy_org, impact_org );
		if ( !isalive( entity ) )
			continue;
		if ( entity != level.player )
			continue;
		
		thread set_flag_and_die( msg, impact_org );
	}
}

set_flag_and_die( msg, impact_org )
{
	flag_set( msg );
	self dodamage( self.health + 150, impact_org );
}

ground_allied_forces()
{
	self endon( "death" );
	self endon( "damage_notdone" );
	
	if ( !flag( "breach_complete" ) )
	{
		flag_wait( "breach_complete" );
		wait( 0.1 );	// if we disable color the guys dont respawn so we just overwrite color by setting the new goal position
		
		set_goalpos_and_volume_from_targetname( "ally_first_offense" );
		self.ranit = true;
	}

	if ( !flag( "player_reaches_cliff_area" ) )
	{
		flag_wait( "player_reaches_cliff_area" );
		self set_force_color( "c" );
		teleport_and_take_node_by_targetname( "ally_cliff_start_node" );
		self.baseaccuracy = 0;
	}
	
	if ( !flag( "cliff_look" ) )
	{
		self set_force_color( "c" );
		self thread deletable_magic_bullet_shield();
		flag_wait( "cliff_look" );
		self stop_magic_bullet_shield();
	}

	if ( !flag( "cliff_moveup" ) )
	{
		self set_force_color( "c" );
		/*
		if ( issubstr( self.classname, "_AT_" ) )
		{
			thread rocket_guy_targets_bmp();
		}
		*/
		
		flag_wait( "cliff_moveup" );	
	
// 		wait( 0.1 );	// if we disable color the guys dont respawn so we just overwrite color by setting the new goal position

// 		set_goalpos_and_volume_from_targetname( "ally_second_attack" );
		
		flag_wait( "cliff_complete" );

	}

/*
	if ( !flag( "player_rappels" ) )
	{
		waittillframeend;// otherwise the respawn logic will overwrite the color
		cliff_remove_node = getnode( "cliff_remove_node", "targetname" );
		self setgoalnode( cliff_remove_node );
		self.goalradius = 32;
		self waittill( "goal" );
	}
*/
}

rocket_guy_targets_bmp()
{
	self endon( "death" );
	// they both continue on from the same flag
	if ( !isalive( level.enemy_bmp ) )
		waittillframeend;
	if ( !isalive( level.enemy_bmp ) )
		return;
		
	self setentitytarget( level.enemy_bmp, 0.6 );
	level.enemy_bmp godoff();
	level.enemy_bmp waittill( "death" );
	self clearentitytarget();
}

set_goalpos_and_volume_from_targetname( targetname )
{
	org = getent( targetname, "targetname" );
	volume = getent( org.target, "targetname" );
	
	self.fixednode = false;
	self.goalheight = 512;
// 	self disable_ai_color();
	
	self allowedstances( "stand", "prone", "crouch" );	
	self setgoalpos( org.origin );
	self.goalradius = org.radius;
	self setgoalvolume( volume );
}

turn_off_stealth()
{
	// end of stealth for the level
	level waittill( "_stealth_spotted" );
	level notify( "_stealth_stop_stealth_logic" );
}

blackout_guy_leaves_ignore( guy )
{
	guy endon( "death" );
	self waittill( "trigger" );
	guy.ignoreme = false;
}

blackout_guy_animates_once( noteworthy, anime, theflag, timer )
{
	if ( !isdefined( level.flag[ theflag ] ) )
		flag_init( theflag );
	
	guy = get_guy_with_script_noteworthy_from_spawner( noteworthy );
	guy endon( "death" );
	targ = getent( guy.target, "targetname" );
	guy set_generic_deathanim( anime + "_death" );

	guy.ignoreme = true;
	if ( isdefined( guy.script_linkto ) )
	{
		// links to the trigger that forces ignore off
		triggers = guy get_linked_ents();
		array_thread( triggers, ::blackout_guy_leaves_ignore, guy );
	}
	
	guy.allowdeath = true;
	guy.health = 1;

	targ thread anim_generic_first_frame( guy, anime + "_ff" );
	flag_wait( theflag );
	length = getanimlength( guy getgenericanim( anime + "_ff" ) );
	targ thread anim_generic( guy, anime + "_ff" );
	wait( timer );
	guy.ignoreme = false;
}

blackout_guy_animates( noteworthy, anime, theflag, timer )
{
	if ( !isdefined( level.flag[ theflag ] ) )
		flag_init( theflag );
	
	guy = get_guy_with_script_noteworthy_from_spawner( noteworthy );
	guy endon( "death" );
	targ = getent( guy.target, "targetname" );
	guy set_generic_deathanim( anime + "_death" );

	guy.ignoreme = true;
	if ( isdefined( guy.script_linkto ) )
	{
		// links to the trigger that forces ignore off
		triggers = guy get_linked_ents();
		array_thread( triggers, ::blackout_guy_leaves_ignore, guy );
	}
	
	guy.allowdeath = true;
	guy.health = 1;

	// freeze until its time to start
	targ thread anim_generic_first_frame( guy, anime + "_ff" );
	flag_wait( theflag );
	
	// start animating
	length = getanimlength( guy getgenericanim( anime + "_ff" ) );
	targ thread anim_generic_loop( guy, anime );
	
	// nearing end of anim, price kills
	wait( timer );
	guy.ignoreme = false;
	wait( 1 );
	guy die();
}

blackout_guy_animates_loop( noteworthy, anime, theflag, startflag )
{	
	if ( !isdefined( level.flag[ theflag ] ) )
		flag_init( theflag );

	 /#	
	if ( isdefined( startflag ) )
	{
		assertex( isdefined( level.flag[ startflag ] ), "Startflag was not set" );
	}
	#/ 

	guy = get_guy_with_script_noteworthy_from_spawner( noteworthy );
	guy endon( "death" );
	targ = getent( guy.target, "targetname" );
	guy set_generic_deathanim( anime + "_death" );

	guy.ignoreme = true;
	if ( isdefined( guy.script_linkto ) )
	{
		// links to the trigger that forces ignore off
		triggers = guy get_linked_ents();
		array_thread( triggers, ::blackout_guy_leaves_ignore, guy );
	}
		
	guy.allowdeath = true;
	guy.health = 1;

	if ( isdefined( startflag ) )
	{	
		targ thread anim_generic_first_frame( guy, anime + "_ff" );
		flag_wait( startflag );
	}

	targ thread anim_generic_loop( guy, anime );
	level waittill( "price_aims_at" + theflag );
	
	level.price waittill( "goal" );
	wait( 10 );
	guy.ignoreme = false;
}

price_checks_goal_for_noteworthy()
{
	self endon( "stop_checking_node_noteworthy" );
	used = [];
	
	for ( ;; )
	{
		self waittill( "goal" );
		while ( !isdefined( self.node ) )
		{
			wait( 0.05 );
		}
		
		node = self.node;
		if ( isdefined( used[ node.origin + "" ] ) )
			continue;
		used[ node.origin + "" ] = true;
		
		if ( distance( node.origin, self.origin ) > self.goalradius )
			continue;
		
		if ( !isdefined( node.script_noteworthy ) )
			continue;

		if ( node.script_noteworthy == "signal_moveup" )
		{
			threadCQB_stand_signal_move_up = getent( "CQB_stand_signal_move_up", "targetname" );
			price_signals_moveup();
		}
	}
}

price_signals_moveup()
{
	while ( isalive( level.price.enemy ) )
		wait( 0.05 );
		
	level.price handsignal( "moveup", "enemy" );
}

price_cqb_aims_at_target( deathflag )
{
	level notify( "price_gets_new_cqb_targ" );
	level endon( "price_gets_new_cqb_targ" );
	for ( ;; )
	{
		if ( deathflag == "hide" )
		{
			special = getent( "hide_target", "targetname" );
			level.price cqb_aim( special );
			level notify( "price_aims_at" + deathflag );
			wait( 0.05 );
			continue;
		}
		
		keys = getarraykeys( level.deathflags[ deathflag ][ "ai" ] );
		if ( keys.size )
		{
			level.price cqb_aim( level.deathflags[ deathflag ][ "ai" ][ keys[ 0 ] ] );
			level notify( "price_aims_at" + deathflag );
			return;
		}
		wait( 0.05 );
	}
}

price_attack_hunt()
{
	for ( ;; )
	{
		self.noshoot = true;
		if ( !isalive( self.enemy ) )
		{
			wait( 0.05 );
			continue;
		}
		
		if ( !isdefined( self.enemy.dont_hit_me ) )
		{
			self.noshoot = undefined;
		}
		else
		{
			assertex( self.enemy.dont_hit_me, ".dont_hit_me has to be true or undefined" );
		}
		wait( 0.05 );
	}
}


spawn_replacement_cliff_baddies()
{
	level endon( "cliff_complete" );

	count = 10;
	spawners = getentarray( "later_spawner", "targetname" );
	
	spawners = array_randomize( spawners );
	array_thread( spawners, ::add_spawn_function, ::defend_second_area );

	index = 0;	
	for ( ;; )
	{
		axis = getaiarray( "axis" );
		if ( axis.size > 10 )
		{
			wait( 1 );
			continue;
		}

		spawner = spawners[ index ];
		spawner.count = 1;
		spawner spawn_ai();
		index++ ;
		if ( index >= spawners.size )
			index = 0;

		wait( 0.5 );
	}
}

defend_second_area()
{
	self endon( "death" );
	self endon( "long_death" );

	teleport_and_take_node_by_targetname( "enemy_cliff_start_node" );
	if ( !flag( "cliff_look" ) )
	{
		self.health = 50000;
		thread set_flag_on_player_damage( "cliff_look" );
		flag_wait( "cliff_look" );
		self.health = 100;
	}
	thread track_defender_deaths();

	self.baseaccuracy = 0;
	flag_wait( "cliff_moveup" );
	set_goalpos_and_volume_from_targetname( "enemy_cliff_defense" );
	
	flag_wait( "cliff_complete" );
	cliff_enemy_delete_org = getent( "cliff_enemy_delete_org", "targetname" );
	wait( randomfloatrange( 1, 5 ) );
	self setgoalpos( cliff_enemy_delete_org.origin );
	self.goalradius = 32;
	self waittill( "goal" );
	self delete();
}

roof_spawner_think()
{
	self endon( "death" );
	self.ignoreme = true;
	wait( randomintrange( 30, 60 ) );
	self die();
}

track_defender_deaths()
{
	self waittill( "death" );
	level.defenders_killed++ ;
	if ( level.defenders_killed >= 3 )
		flag_set( "cliff_moveup" );
}

swarm_hillside()
{
	self endon( "death" );
	lowest = 5000;
	lowest_index = 0;
	orgs = getentarray( "power_station_attack_org", "targetname" );
	for ( i = 0; i < orgs.size; i++ )
	{
		org = orgs[ i ];
		if ( !isdefined( org.count ) )
		{
			org.count = 0;
		}
		
		if ( org.count < lowest )
		{
			lowest = org.count;
			lowest_index = i;
		}
	}
	
	org = orgs[ lowest_index ];
	org.count++;
	
	self setgoalpos( org.origin );
	self.goalradius = org.radius;
	self waittill( "goal" );

	node = getnode( "power_plant_fight_node", "targetname" );
	self setgoalnode( node );
	self.goalradius = 2048;	
	for ( ;; )
	{
		wait( randomfloatrange( 7, 10 ) );
		self.goalradius -= 128;
		if ( self.goalradius < 650 )
			self.goalradius = 650;
	}
}

power_plant_spawner()
{
	self endon( "death" );
	self setgoalpos( self.origin );
	self.goalradius = 64;
	flag_wait( "player_reaches_cliff_area" );
	
	self thread swarm_hillside();
}

overlook_turret_think()
{
	// a function the AI runs when they try to use a turret
	self.turret_function = set_turret_manual();
	self endon( "death" );
	self.ignoreme = true;
	delaythread( 32, ::set_ignoreme, false );
	delaythread( randomfloatrange( 50, 55 ), ::die );
	
	mg_overlook_targets = getentarray( "mg_overlook_target", "targetname" );
	
	for ( ;; )
	{
		self setentitytarget( random( mg_overlook_targets ) );
		wait( randomfloatrange( 1, 2 ) );
	}
}

set_turret_manual( turret )
{
// 	turret setmode( "manual_ai" );
}

power_plant_org()
{
	power_plant = getent( "power_plant", "targetname" );
	return power_plant.origin;
}

cliff_org()
{
	cliff_org = getent( "cliff_org", "targetname" );
	return cliff_org.origin;
}



overlook_player_mortarvision()
{
	level endon( "mgs_cleared" );
	// cause a mortar to go off if the player looks near an AI that is near certain spots set up in createfx
	orgs = [];
	
	ent = undefined;	
	for ( i = 0; i < level.createfxent.size; i++ )
	{
		if ( !isdefined( level.createfxent[ i ].v[ "exploder" ] ) )
			continue;
			
		if ( level.createfxent[ i ].v[ "exploder" ] != 70 )
			continue;

		ent = level.createfxent[ i ];
	
		neworg = spawnstruct();
		neworg.origin = ent.v[ "origin" ];
		
		orgs[ orgs.size ] = neworg;
	}
	
	
	flag_wait( "overlook_attack_begins" );
	wait( 5 );
	
	last_mortar_point = undefined;

	for ( ;; )
	{
		wait_for_player_to_ads_for_time( 1.5 );
		
		for ( ;; )
		{
			wait( 0.5 );
			if ( !player_is_ads() )
				break;
				
			ai = getaiarray( "axis" );
			
			eye = level.player geteye();
			angles = level.player getplayerangles();
			
			forward = anglestoforward( angles );
			end = eye + vectorScale( forward, 5000 );
			trace = bullettrace( eye, end, true, level.player );
			viewpoint = trace[ "position" ];
			
			guy = getclosest( viewpoint, ai, 500 );
			if ( !isdefined( guy ) )
				continue;
			
			mortar_point = getclosest( guy.origin, orgs, 500 );
			
			if ( !isdefined( mortar_point ) )
				continue;
		
			if ( isdefined( last_mortar_point ) )
			{
				// dont have the same one go off twice
				if ( mortar_point == last_mortar_point )
					continue;
			}	
			
			last_mortar_point = mortar_point;
			// move one of the exploders there and set it off
			ent.v[ "origin" ] = mortar_point.origin;
			play_sound_in_space( "mortar_incoming", ent.v[ "origin" ] );
			wait( 1.5 );
			ent activate_individual_exploder();
			wait( randomfloat( 8, 12 ) );
		}
	}
}

wait_for_player_to_ads_for_time( timer )
{
	ads_timer = gettime();

	for ( ;; )
	{
		if ( player_is_ads() )
		{
			if ( gettime() > ads_timer + timer )
				return;
		}
		else
		{
			ads_timer = gettime();
		}
		
		wait( 0.05 );
	}
}

player_is_ads()
{
	return level.player PlayerAds() > 0.5;
}

physics_launch_think()
{
	self hide();
	self setcandamage( true );
	for ( ;; )
	{
		self waittill( "damage", one, entity, three, four, five, six, seven );
		if ( !isdefined( entity ) )
			continue;
		if ( !isdefined( entity.model ) )
			continue;
		if ( !issubstr( entity.model, "vehicle" ) )
			continue;
		break;
	}		

			
	targ = getent( self.target, "targetname" );
	
	org = targ.origin;
// 	vel = distance( self.origin, targ.origin );
	vel = targ.origin - self.origin;
	vel = vectorscale( vel, 100 );
	
	model = spawn( "script_model", ( 0, 0, 0 ) );
	model.angles = self.angles;
	model.origin = self.origin;
	model setmodel( self.model );
	model physicslaunch( model.origin, vel );
	self delete();
}

ally_rappels( msg, timer )
{
	if ( self == level.price )
	{
		/*
		self.walkdist = 1000;
		walk = getdvar( "walk" );
		self set_generic_run_anim( walk );
		self.disableexits = true;
		self.disablearrivals = true;
		wait( 5 );
		*/
	}

	node = getnode( msg, "targetname" );
	
	rope = level.rope[ msg ];
	node thread anim_first_frame_solo( rope, "rappel_start" );
	
	node anim_generic_reach( self, "rappel_start" );
	
	
	if ( !flag( "player_rappels" ) )
	{
		flag_wait( "player_at_rappel" );
		flag_set( "gaz_rappels" );
	}

	if ( self.animname == "kamarov" )
		return;
		
	guys = [];
	guys[ guys.size ] = self;
	guys[ guys.size ] = rope;

	node thread anim_single_solo( rope, "rappel_start" );
	node anim_generic( self, "rappel_start" );
	
	if ( !flag( "player_rappels" ) )
	{
		node thread anim_loop_solo( rope, "rappel_idle" );
		node thread anim_generic_loop( self, "rappel_idle" );
		flag_wait( "player_rappels" );
		wait( timer );
		node notify( "stop_loop" );
	}

	node thread anim_single_solo( rope, "rappel_end" );
	node anim_generic( self, "rappel_end" );

	level notify( "shack_cleared" ); // clear water walk stuff in start point

	self ent_flag_set( "rappelled" );
	self clear_run_anim();
	self.walkdist = 16;
	self.disableexits = false;
	self.disablearrivals = false;
	self.interval = 96;
	self.disableexits = false;
}

price_swap()
{
/*
	node = getnode( "price_swap_node", "targetname" );
	level.price setgoalnode( node );
	level.price.goalradius = node.radius;
*/	
	for ( ;; )
	{
		if ( player_looking_at( level.price geteye(), 0.7 ) )
		{
			wait( 0.1 );
			continue;
		}
		break;
	}
	
	price_nvg_spawner = getent( "price_nvg_spawner", "targetname" );
	price_nvg_spawner.origin = self.origin;
	price_nvg_spawner.angles = self.angles;
	guy = price_nvg_spawner stalingradspawn();
	if ( spawn_failed( guy ) )
		return;

	// doppleganger!
	level.price stop_magic_bullet_shield();
	level.price delete();
	level.price = guy;
	guy.animname = "price";
	guy thread magic_bullet_shield();
	guy sas_handle_farm();
//	guy pushplayer( true );
}

player_rappel_think()
{
	/* 
	level.price thread ally_rappels( "ally1_rappel_node", 0.3 );
	level.gaz thread ally_rappels( "ally2_rappel_node", 0 );
	level.bob thread ally_rappels( "ally3_rappel_node", 0.9 );
	*/ 
	

	node = getnode( "player_rappel_node", "targetname" );
// 	node.origin = node.origin + ( 0, 0, 64 );
	
	rope = spawn_anim_model( "player_rope" );
	node thread anim_first_frame_solo( rope, "rappel_for_player" );

	rope_glow = spawn_anim_model( "player_rope_obj" );
	node thread anim_first_frame_solo( rope_glow, "rappel_for_player" );
	rope_glow hide();

	// this is the model the player will attach to for the rappel sequence
	model = spawn_anim_model( "player_rig" );
	model hide();
	
	// put the model in the first frame so the tags are in the right place
	node anim_first_frame_solo( model, "rappel" );

	flag_wait( "gaz_rappels" );
	rappel_trigger = getent( "player_rappel_trigger", "targetname" );
	rappel_trigger trigger_on();
	rope_glow show();
	rappel_trigger sethintstring( &"BLACKOUT_RAPPEL_HINT" );
	rappel_trigger waittill( "trigger" );	
	
	// damage trigger at the bottom of the rappel
	cliffhanger = getent( "cliffhanger", "targetname" );
	cliffhanger delete();
	
	rope_glow hide();
// 	model show();
	rappel_trigger delete();
	
	flag_set( "player_rappels" );
	level.player allowprone( false );
	level.player allowcrouch( false );
	
	level.player disableweapons();
	
	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	node thread anim_single_solo( model, "rappel" );
	node thread anim_single_solo( rope, "rappel_for_player" );
	node waittill( "rappel" );
	level.player unlink();
	model delete();
	level.player enableweapons();
	flag_set( "player_finishes_rappel" );
	level.player allowprone( true );
	level.player allowcrouch( true );
	level.player.ignoreme = false;
	
	wait( 15 );
	spawners = getentarray( "mg_gunner", "script_noteworthy" );
	for ( i = 0; i < spawners.size; i++ )
	{
		if ( isalive( spawners[ i ] ) )
			continue;
		spawners[ i ] delete();
	}
}

cliff_bm21_blows_up()
{
	 /#
	wait( 0.05 );// for the start point
	#/ 
	flag_wait( "saw_first_bm21" );
	bm21_03 = getent( "bm21_03", "targetname" );
	radiusdamage( bm21_03.origin, 250, 5000, 2500 );
}

farm_rpg_guy_attacks_bm21s()
{
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self.IgnoreRandomBulletDamage = true;
	self waittill( "goal" );
	
	underground_bm21_target = getent( "underground_bm21_target", "targetname" );
	// aim underground so he doesnt shoot too soon
	self setentitytarget( underground_bm21_target );
	
	flag_wait( "rpg_guy_attacks_bm21s" );
	autosave_by_name( "farm_raid" );
	self.a.rockets = 5000;
	bm21_01 = getent( "bm21_01", "targetname" );
	 /#
	if ( isalive( bm21_01 ) && !self cansee( bm21_01 ) )
	{
		// in case of mymapents
		radiusdamage( bm21_01.origin, 250, 5000, 2500 );
	}
	#/ 
	
	if ( isalive( bm21_01 ) )
	{
		self setentitytarget( bm21_01 );
		attractor = Missile_CreateAttractorOrigin( bm21_01.origin + ( 0, 0, 50 ), 5000, 500 );
		bm21_01.health = 500;
		bm21_01 waittill( "death" );
		Missile_DeleteAttractor( attractor );
	}

	bm21_02 = getent( "bm21_02", "targetname" );

	 /#
	if ( isalive( bm21_02 ) && !self cansee( bm21_02 ) )
	{
		// in case of mymapents
		radiusdamage( bm21_02.origin, 250, 5000, 2500 );
	}
	#/ 
	
	if ( isalive( bm21_02 ) )
	{
		self setentitytarget( bm21_02 );
		attractor = Missile_CreateAttractorOrigin( bm21_02.origin + ( 0, 0, 50 ), 5000, 500 );
		bm21_02.health = 500;
		bm21_02 waittill( "death" );
		Missile_DeleteAttractor( attractor );
	}
	
	self.IgnoreRandomBulletDamage = false;
	self.ignoreme = false;
	self stop_magic_bullet_shield();
	self.a.rockets = 1;
	self.goalradius = 2048;
	self clearentitytarget();
}

rappel_org()
{
	player_rappel = getent( "player_rappel", "targetname" );
	return player_rappel.origin;
}

prep_for_rappel_think()
{
	// makes friendlies rappel when they touch the trigger
	
	used = [];
	used[ 1 ] = false;
	used[ 2 ] = false;
	used[ 3 ] = false;
	
	timer[ 1 ] = 0.4;
	timer[ 2 ] = 0.8;
	timer[ 3 ] = 1.3;
	
	create_rope( "ally1_rappel_node" );
	create_rope( "ally2_rappel_node" );
	
	for ( ;; )
	{
		self waittill( "trigger", other );

		other thread gaz_and_kamarov_fight();
//		continue;
//		
//		if ( isdefined( other.rappelling ) )
//			continue;
//		if ( other == level.kamarov )
//		{
//			other.ignoretriggers = true;
//			continue;
//		}
//			
//		other.rappelling = true;
//		
//		for ( i = 1; i <= 3; i++ )
//		{
//			if ( !used[ i ] )
//			{
//				other thread ally_rappels( "ally" + i + "_rappel_node", timer[ i ] );
//				used[ i ] = true;
//				break;
//			}
//		}
	}
}

create_rope( msg )
{
	node = getnode( msg, "targetname" );
	rope = spawn_anim_model( "rope" );
	node thread anim_first_frame_solo( rope, "rappel_start" );
	level.rope[ msg ] = rope;
}

gaz_and_kamarov_fight()
{
	self.ignoretriggers = true;
	self.kam_gaz_fight = true;
	
// 	node = getnode( "gaz_kamarov_node", "targetname" );
	node = getent( "gaz_kam_org", "targetname" );
	
//	if ( self == level.price )
//	{
//		node = getent( "price_rap_org", "targetname" );
//	}
	
	node anim_reach_and_approach_solo( self, "cliff_start" );
	

	flag_set( "final_raid_begins" );
	setsaveddvar( "ai_friendlyFireBlockDuration", "0" );

	if ( self == level.price )
	{
		flag_set( "price_at_fight" );
		assertex( self == level.price, "self wasnt price!" );
		flag_wait( "rappel_kamarov_ready" );
		flag_wait( "rappel_gaz_ready" );
		flag_wait( "gaz_kam_fight_begins" );
		
//		self waittill( "goal" );
		self delaythread( 24, ::ally_rappels, "ally2_rappel_node", 0.5 );
//		node anim_single_solo( self, "cliff_start" );
		self waittillend( "single anim" );
		self setgoalpos( self.origin );
		self.goalradius = 16;
		self.ignoretriggers = false;
		self.rappelling = true;
		return;
	}

	if ( self == level.gaz )
		flag_set( "gaz_at_fight" );
	if ( self == level.kamarov )
		flag_set( "kam_at_fight" );

	// must be kam or gaz
	flag_set( "rappel_" + self.animname + "_ready" ); // rappel_kamarov_ready, rappel_gaz_ready
	flag_set( "gaz_fight_preps" );	

	if ( self == level.kamarov )
	{
		level.binocs = self get_prop( "binocs" );
		thread binocs_delete();
	}
	
	flag_set( "power_station_dialogue_begins" );
	
	if ( !flag( "gaz_kam_fight_begins" ) )
	{
		// loop until the fight starts
		node thread anim_loop_solo( self, "cliff_start_idle", undefined, "stop_loop" + self.animname );
		flag_wait( "gaz_kam_fight_begins" );
		node notify( "stop_loop" + self.animname );
	}

	self waittillend( "single anim" );
//	node thread anim_single_solo( self, "cliff_start" );

	if ( self == level.kamarov )
	{
		node thread anim_loop_solo( self, "cliff_end_idle" );
		return;
	}

	self.ignoretriggers = false;
	self thread ally_rappels( "ally1_rappel_node", 0.25 );
	setsaveddvar( "ai_friendlyFireBlockDuration", "2000" );
}

take_out_pier_guy( guy )
{
	if ( flag( "high_alert" ) )
		return;
	level endon( "high_alert" );
	guy.threatbias = 35000;

	// Price: weapons free
	radio_dialogue_queue( "weapons_free" );
	// gaz: roger that
//	radio_dialogue_queue( "roger_that" );

	if ( !isalive( guy ) )
		return;
	
	guy.ignoreme = false;
// 	level.price.ignoreall = false;
	level.gaz.ignoreall = false;
	
// 	level.gaz thread kill_guy( guy );
	guy waittill( "death" );
	level.price.ignoreall = true;
	level.gaz.ignoreall = true;
}


_waittillmatch( msg1, msg2 )
{
	level waittillmatch( msg1, msg2 );
}

kill_hut_patrol( hut_patrol )
{
	hut_patrol endon( "death" );
	level endon( "high_alert" );
	flag_assert( "high_alert" );
	
	level add_wait( ::_waittillmatch, "event_awareness", "found_corpse" );
	level add_wait( ::_waittillmatch, "event_awareness", "heard_corpse" );
	level add_wait( ::_waittillmatch, "event_awareness", "heard_scream" );
	level add_wait( ::waittill_msg, "_stealth_no_corpse_announce" );
	
	do_wait_any();
	wait( 1.62 );
//	wait( 0.25 );
	level.price.ignoreall = false;
	level.gaz.ignoreall = false;

}

hut_friendlies_chats_about_russians()
{
	alert = [];
	alert[ "prone" ]	 = 70;
	alert[ "crouch" ]	 = 260;
	alert[ "stand" ]	 = 380;
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ][ "spotted" ] 	= 1024;
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ][ "alert" ] 	= 200;
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ][ "hidden" ] 	= 200;

	level._stealth.logic.ai_event[ "ai_eventDistPain" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistPain" ][ "spotted" ] 	= 512;
	level._stealth.logic.ai_event[ "ai_eventDistPain" ][ "alert" ] 		= 200;
	level._stealth.logic.ai_event[ "ai_eventDistPain" ][ "hidden" ] 	= 200;
	
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "spotted"]	= getdvar( "ai_eventDistBullet" );
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "alert" ] 	= 64;
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "hidden" ] 	= 64;
	
	stealth_detect_ranges_set( undefined, alert, undefined );
	
	hut_patrol = getent( "hut_patrol", "targetname" );
	hut_patrol thread custom_stealth_ai();
	hut_patrol.goalradius = 4;
	hut_patrol.no_corpse_announce = true;
	thread kill_hut_patrol( hut_patrol );
	
	axis = getaiarray( "axis" );
	for ( i = 0; i < axis.size; i++ )
	{
		axis[ i ].no_corpse_caring = true;
	}
	hut_patrol.no_corpse_caring = undefined;
	hut_patrol.found_corpse_wait = 15.0;
	
	activate_trigger_with_targetname( "first_pier_trigger" );

	flag_wait( "introscreen_complete" );
	// The Loyalists are expecting us half a klick to the north. Move out.
	level.price dialogue_queue( "expecting_us" );

	level.price set_force_color( "r" );
	level.gaz delaythread( 0.5, ::set_force_color, "r" );


	// Loyalists eh? Are those the good Russians or the bad Russians?                              
	level.gaz dialogue_queue( "loyalists_eh" );
	
	// Well, they won't shoot at us on sight, if that's what you're asking.                               
	level.price dialogue_queue( "wont_shoot_us" );

	// That's good enough for me sir.                                                                   
	level.gaz dialogue_queue( "good_enough" );

	pier_guy = getent( "pier_guy", "targetname" );
	if ( isalive( pier_guy ) )
	{
		pier_guy.health = 20;
		level.price thread cqb_aim( pier_guy );
		level.gaz thread cqb_aim( pier_guy );
	}

	if ( isalive( hut_patrol ) )
		hut_patrol patrol_soon();
	
	add_wait( ::_wait, 8.4 );
	add_wait( ::flag_wait, "high_alert" );
	add_wait( ::flag_wait, "weapons_free" );
	hut_patrol add_wait( ::waittill_msg, "death" );
	do_wait_any();

	if ( isalive( pier_guy ) )
	{
		take_out_pier_guy( pier_guy );
		level.price cqb_aim();
		level.gaz cqb_aim();
	}

	if ( isalive( hut_patrol ) && !flag( "high_alert" ) )
	{
		level.price cqb_aim( hut_patrol );
		level.gaz cqb_aim( hut_patrol );

		level.price.ignoreall = true;
		level.gaz.ignoreall = true;
	}

 	flag_wait( "pier_guys" );
	level.price cqb_aim();
	level.gaz cqb_aim();
	if ( !flag( "high_alert" ) )
	{
		level.price.ignoreall = true;
		level.gaz.ignoreall = true;
	}
	

	flag_wait( "hut_cleared" );
	autosave_by_name( "hut_cleared" );
	wait( 0.05 );
	if ( !flag( "high_alert" ) )
	{
		level.price.ignoreall = true;
		level.gaz.ignoreall = true;
	}
		
//	blackout_stealth_settings();
}

price_tells_player_to_come_over()
{
	level endon( "breach_complete" );
	flag_assert( "breach_complete" );
	flag_wait( "over_here" );
	
	wait( 2 );
	level.price waittill( "goal" );	
	
	for ( ;; )
	{
		if ( flag( "player_near_overlook" ) )
			break;

		over_here();
	}
}

overlook_price_tells_you_to_shoot_mgs()
{
	wait( 8 );
	
	// Soap! Hit those machine gunners in the windows!                         
	// Soap, take out the machine gunners in the windows so Kamarov's men can storm the building!          
	level.price dialogue_queue( "machine_gunners_in_windows" );

	if ( flag( "mgs_cleared" ) )
		return;
	level endon( "mgs_cleared" );

	wait( 3 );
	mg_window_reminder_in_sight_guy();

	flag_waitopen( "visible_mg_gunner_alive" );
	wait( 4 );
	// Hit the other machine gunner through the wall.	
	level.price dialogue_queue( "other_mg_wall" );
}

mg_window_reminder_in_sight_guy()
{
	level endon( "mgs_cleared" );

	if ( !flag( "visible_mg_gunner_alive" ) )
		return;

	// Soap, take out the machine gunners in the windows, 10 o'clock low!	
	level.price dialogue_queue( "mg_windows" );
	wait( 4 );

	if ( !flag( "visible_mg_gunner_alive" ) )
		return;
	// Soap, hit those machine gunners, 10 o'clock low!	
	level.price dialogue_queue( "mg_low" );
}


clear_target_radius()
{
	// kill all the baddies in the targetted radius
	self waittill( "trigger" );
	org = getent( self.target, "targetname" );
	
	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::die_if_near, org );
}

die_if_near( org )
{
	if ( distance( self.origin, org.origin ) > org.radius )
		return;

	self die();
}

price_finishes_farm()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( other != level.price )
		{
			other thread ignore_triggers( 1.0 );
			continue;
		}
		break;
	}
	
	flag_set( "farm_complete" );
}

informant_org()
{
	if ( !flag( "player_in_house" ) )
	{
		blackout_door = getent( "blackout_door", "targetname" );
		return blackout_door.origin+(0,0,100);
	}
	
	informant_org = getent( "informant_org", "targetname" );
		
	if ( !flag( "farm_complete" ) )
	{
		return informant_org.origin;	
	}

	// discovered he's not there!	
	informant_org = getent( informant_org.target, "targetname" );
	return informant_org.origin;	
}

vip_death()
{
	self waittill( "death" );
	setdvar( "ui_deadquote", &"BLACKOUT_THE_INFORMANT_WAS_KILLED" ); // "The Informant was killed" );
	maps\_utility::missionFailedWrapper();
}

blackout_flashlight_guy()
{
	level.spotlight = [];
	vip_spawner = getent( "vip_spawner", "targetname" );
	vip = vip_spawner spawn_ai();
	vip endon( "death" );
	vip.animname = "vip";
	vip.allowdeath = true;
	vip.ignoreme = true;
	vip.ignoreall = true;
	vip thread vip_death();
	vip gun_remove();
	vip.has_ir = undefined;
	vip thread magic_bullet_shield();
	level.vip = vip;

	node = getnode( "vip_node", "targetname" );
	node thread anim_loop_solo( vip, "idle" );

	flashlight_spawner = getent( "flashlight_spawner", "targetname" );
	flashlight_guy = flashlight_spawner spawn_ai();
	if ( spawn_failed( flashlight_guy ) )
		return;

	flashlight_guy thread blind_guy_gets_flashed();
	flashlight_guy.animname = "flashlight_guy";

	flashlight = spawn_anim_model( "flashlight" );
	level.flashlight = flashlight;

	guy_and_flashlight = [];
	guy_and_flashlight[ guy_and_flashlight.size ] = flashlight_guy;
	guy_and_flashlight[ guy_and_flashlight.size ] = flashlight;
// 	flashlight_guy.ignoreme = true;

	// hang at 15% into the anim until the player approaches
	start_time = 0.15;	
	node thread anim_single( guy_and_flashlight, "search" );
	delaythread( 0.05, ::anim_set_rate, guy_and_flashlight, "search", 0 );
	delaythread( 0.05, ::anim_set_time, guy_and_flashlight, "search", start_time );

	flashlight_guy.health = 50000;
	flashlight_guy.allowdeath = true;
	flashlight_guy.a.nodeath = true;
	flashlight_guy.dontshootstraight = true;

	thread blackout_flashlight_death( node, flashlight_guy, flashlight, guy_and_flashlight );

	setsaveddvar( "r_spotlightbrightness", "3" );
	setsaveddvar( "r_spotlightendradius", "1200" );
	setsaveddvar( "r_spotlightstartradius", "5" );
	

	flag_wait( "blackout_flashlight_guy" );
	
	// we want the flashlight guy to shoot the player
	level.price.ignoreme = true;
	level.gaz.ignoreme = true;


// 	flashlight thread maps\_debug::drawtagforever( "tag_light", ( 0, 1, 0 ) );
// 	flashlight thread maps\_debug::drawtagforever( "tag_origin", ( 1, 0, 1 ) );

/* 	
	ent = spawn( "script_model", ( 0, 0, 0 ) );
	ent setmodel( "tag_origin" );
	ent linkto( flashlight, "tag_light", ( 100, 0, 0 ), ( 0, 0, 0 ) );
	PlayFXOnTag( getfx( "spotlight" ), ent, "tag_origin" );
	ent thread maps\_debug::drawtagforever( "tag_origin" );
	thread light();	
*/ 
	
	priceGuys = [];
	priceGuys[ priceGuys.size ] = vip;
	priceGuys[ priceGuys.size ] = level.price;
	priceGuys[ priceGuys.size ] = flashlight;

	
	level.flash_timer = gettime();

	delaythread( 2, ::flag_set, "price_and_gaz_attack_flashlight_guy" );
	if ( flashlight_guy is_healthy() )
	{
		flashlight_guy StartIgnoringSpotLight();
		blackout_flashlight_guy_attacks( node, flashlight_guy, flashlight, guy_and_flashlight, start_time );
	}
	flag_set( "blackout_flashlightguy_dead" );

// 	thread compare_animtime( "search", flashlight_guy, flashlight );
// 	flashlight_guy thread drawanimtime( "search" );
// 	flashlight thread drawanimtime( "search" );
	
// 	wait( 5 );

	if ( flashlight_guy is_healthy() )
		flashlight_guy StopIgnoringSpotLight();
		
	level.price StartIgnoringSpotLight();
	flag_wait( "door" );
	
	flag_wait( "price_rescues_vip" );
	
	
	node thread anim_reach_solo( level.price, "rescue" );


	flag_wait( "price_and_gaz_attack_flashlight_guy" );	
	flag_wait( "gaz_opens_door" );

	level.price waittill( "goal" );

 /#
	if ( getdvar( "flashlight_debug" ) == "on" )
		return;
#/ 


	node notify( "stop_loop" );

	level.vip gun_recall();
// 	thread gaz_talks_to_vip();

	// who are you?
	level.vip playsound( "blackout_nkd_whoareyou" );

	node anim_single( priceGuys, "rescue" );
	level.vip setgoalpos( level.vip.origin );

	self.walkdist = 5000;
	level.price StopIgnoringSpotLight();
	flag_set( "blackout_rescue_complete" );
	
// 	iprintlnbold( "End of current mission" );
// 	wait( 2 );
// 	missionsuccess( "armada", false );
// 	node anim_single( guys, "death" );
}

vip_rescue_dialogue( empty )
{
	if ( isdefined( level.rescue_dialogue ) )
		return;
	
	level.rescue_dialogue = true;
	// its him.
	level.price dialogue_queue( "its_him" );
	level.price.walkdist = 5800;
	

	// Nikolai - are you all right? Can you walk?														    
	level.gaz dialogue_queue( "are_you_all_right" );

	// Yes...and I can still fight. Thank you for getting me out of here.	
	level.vip thread vip_can_still_fight();
	wait( 5.1 );

	level.price.disableexits = true;
	price_rescue_node = getnode( "price_rescue_node", "targetname" );
	level.price setgoalnode( price_rescue_node );

	// Big Bird this Bravo Six. We have the package. Meet us at LZ one. Over.                              
	level.price dialogue_queue( "have_the_package" );

	// Bravo Six this is Big Bird. We're on our way. Out.	
	radio_dialogue( "on_our_way" );

	// Let's go! Let's go!                                                                                   
	level.price dialogue_queue( "lets_go_lets_go" );
	level.price.walkdist = 16;
	level.gaz set_force_color( "p" );// gaz leads the player out
	vip_rescue_node = getnode( "vip_rescue_node", "targetname" );
	level.vip setgoalnode( vip_rescue_node );
}

vip_can_still_fight()
{
	// Yes...and I can still fight. Thank you for getting me out of here.	
	dialogue_queue( "yes_can_still_fight" );
//	level.timer = gettime();
//	talk_for_time( 5 );
}

vip_talks_to_price()
{	
	// Have the Americans already attacked Al - Asad?	
	level.vip dialogue_queue( "have_americans_attacked" );

	// No, their invasion begins in a few hours! Why?                                                      
	level.price dialogue_queue( "invasion_begins" );

	// The Americans are making a mistake. They will never take Al - Asad alive.	
	level.vip dialogue_queue( "making_a_mistake" );
}


flashlight_fx_change( price )
{
	level.spotlight_caster delete();
	level.spotlight_caster = level.flashlight spawn_flashlighfx( "spotlight", 0 );
}

blackout_flashlight_guy_attacks( node, flashlight_guy, flashlight, guy_and_flashlight, start_time )
{
	flashlight_guy endon( "damage" );
	flashlight_guy endon( "doFlashBanged" );
	
	// flashlight guy steps out
	anim_set_rate( guy_and_flashlight, "search", 1 );
	flashlight_guy thread blackout_flashlight_kill_player();
	
	level.flashlight delaythread( 0.50, ::spawn_flashlighfx, "spotlight", 8 );
	level.flashlight delaythread( 0.50, ::spawn_flashlighfx, "flashlight", 8 );
	level.flashlight delaythread( 0.50, ::play_sound_on_entity, "scn_blackout_flashlight_on" );

	anim_set_rate( guy_and_flashlight, "search", 2 );
	wait( 1.2 );
	flashlight_guy notify( "flashlight_guy_attacks" );
	anim_set_rate( guy_and_flashlight, "search", 1 );
	wait( 1.3 );
	anim_set_rate( guy_and_flashlight, "search", 0 );
	flashlight_guy waittill_either( "damage", "doFlashBanged" );
}

blackout_flashlight_kill_player()
{
	self endon( "death" );
	self waittill( "flashlight_guy_attacks" );
	
	waits = [];
	waits[ waits.size ] = 0.65;
	waits[ waits.size ] = 0.3;
	waits[ waits.size ] = 0.35;
	waits[ waits.size ] = 0.6;
	waits[ waits.size ] = 0.3;
	waits[ waits.size ] = 0.55;
	index = 0;
	
	for ( ;; )
	{
		if ( !BulletTracePassed( self gettagorigin( "tag_flash" ), level.player geteye(), false, undefined ) )
// 		if ( !self cansee( level.player ) )
		{
			wait( 0.05 );
			continue;
		}
		
		magicbullet( self.weapon, self gettagorigin( "tag_flash" ), level.player geteye() );
		PlayFXOnTag( getfx( "pistol_muzzleflash" ), self, "tag_flash" );
		self thread play_sound_on_entity( "weap_m9_fire_npc" );
// 		self shoot( 1, level.player geteye() );
		wait( waits[ index ] );
		index++ ;
		if ( index >= waits.size )
			index = 0;
	}
}

blackout_flashlight_death( node, flashlight_guy, flashlight, guy_and_flashlight )
{
	flashlight_guy waittill_either( "damage", "doFlashBanged" );
	flashlight_guy.died = true;

	if ( !isdefined( level.spotlight[ "spotlight" ] ) )
	{
		// killed before he popped out by smart player
		level.flashlight delaythread( 0.50, ::spawn_flashlighfx, "spotlight", 8 );
		level.flashlight delaythread( 0.50, ::play_sound_on_entity, "scn_blackout_flashlight_on" );
	}

	if ( isdefined( level.spotlight[ "flashlight" ] ) )
		level.spotlight[ "flashlight" ] delete();
		
	org = getstartorigin( node.origin, node.angles, flashlight_guy getanim( "fl_death" ) );
	node thread anim_single_solo( flashlight, "fl_death" );

	if ( flashlight_guy.health == 50000 )
		flashlight_guy waittill( "damage" );
	
	if ( distance( org, flashlight_guy.origin ) > 8 )
	{
		// if the guy would pop to the spot he needs to die at then just play his death where he is and chuck the spotlight
		node thread anim_single_solo( flashlight, "fl_death" );
		flashlight_guy thread anim_single_solo( flashlight_guy, "fl_death_local" );
	}
	else
	{
		node thread anim_single_solo( flashlight_guy, "fl_death" );
	}

	wait( 0.5 );
	flashlight_guy die();
}


spawn_flashlighfx( fx, offset )
{
	if ( isdefined( level.spotlight[ fx ] ) )
		return;

	ent = spawn( "script_model", ( 0, 0, 0 ) );
	level.spotlight[ fx ] = ent;
	ent setmodel( "tag_origin" );
	ent linkto( self, "tag_light", ( offset, 0, 0 ), ( 0, 0, 0 ) );
	PlayFXOnTag( getfx( fx ), ent, "tag_origin" );
}

drawanimtime( anime )
{
	for ( ;; )
	{
		println( self.animname + " " + self getanimtime( getanim( anime ) ) + " " + getanimlength( getanim( anime ) ) );
		wait( 0.05 );
	}
}

compare_animtime( anime, guy1, guy2 )
{
	for ( ;; )
	{
		time1 = guy1 getanimtime( guy1 getanim( anime ) );
		time2 = guy2 getanimtime( guy2 getanim( anime ) );
		
		println( time1 - time2 );
		wait( 0.05 );
	}
}

flashlight_fire( guy )
{
	// manually disable his shooting
	guy.a.lastShootTime = gettime();
}

blind_guy_gets_flashed()
{
	self waittill( "doFlashBanged" );
	self.isFlashed = true;
	self stopanimscripted();
	self notify( "stop_first_frame" );
}

blind_corner_spawner_sound()
{
	// start praying when sasha guy dies
	self endon( "death" );
	flag_wait( "blind_trigger" + "wall_spawner" );
	self playsound( level.scr_sound[ "generic" ][ "breathing" ] );
}

blind_guy_think()
{
	anims = [];
	anims[ "lightswitch_spawner" ] = "blind_lightswitch";
	anims[ "wall_spawner" ] = "blind_wall_feel";
	anims[ "corner_spawner" ] = "blind_fire_pistol";
	anims[ "hide_spawner" ] = "blind_hide_fire";
	
	flag_init( "blind_trigger" + self.script_noteworthy );
	flag_init( "blind" + self.script_noteworthy );
	self add_wait( ::waittill_msg, "death" );
	level add_func( ::flag_set, "blind" + self.script_noteworthy );
	thread do_wait();
	
	timers = [];
	timers[ "lightswitch_spawner" ] = 5.0;
	timers[ "wall_spawner" ] = 3.4;
	timers[ "corner_spawner" ] = 2;
	timers[ "hide_spawner" ] = 0.9;
	
	death_timers = [];
	death_timers[ "lightswitch_spawner" ] = 2.5;
	death_timers[ "wall_spawner" ] = 1.5;
	death_timers[ "corner_spawner" ] = 3;
	death_timers[ "hide_spawner" ] = 1.9;
	
	timer = timers[ self.script_noteworthy ];
	death_timer = death_timers[ self.script_noteworthy ];
	
	moment_anim = anims[ self.script_noteworthy ];
	death_anim = anims[ self.script_noteworthy ] + "_death";

	if ( self.script_noteworthy == "corner_spawner" )
	{
		thread blind_corner_spawner_sound();
	}
	moment_trigger = get_linked_trigger();

	self.ignoreme = true;
	self.allowdeath = true;
	self.health = 8;
	self thread blind_guy_gets_flashed();
	
	moment_org = getent( self.target, "targetname" );
	moment_org thread anim_generic_first_frame( self, moment_anim );

	if ( self.script_noteworthy == "hide_spawner" )
	{
		self.a.pose = "crouch";// doesnt play his death anim by default because the death anim pops if its played too early
		// hide guy is simplified cause he is killed quick
		moment_trigger waittill( "trigger" );
		if ( isalive( self ) )
		{
			delaythread( 0.693, ::set_generic_deathanim, death_anim );// if you shoot him too early he pops
			if ( !self isFlashed() )
				moment_org thread anim_generic( self, moment_anim );
			wait( timer );
			if ( isalive( self ) )
			{
				self thread blind_guy_dies_soon( death_timer );
			}
		}
		return;
	}

	self set_generic_deathanim( death_anim );
	
	weapons_free_trigger = getent( moment_trigger.script_linkto, "script_linkname" );
	signal_node = get_linked_node();
	weapons_free_node = getnode( signal_node.script_linkto, "script_linkname" );
	next_signal_node = getnode( weapons_free_node.script_linkto, "script_linkname" );

	signal_node thread price_signals_on_arrival();
	noteworthy = self.script_noteworthy;
		
	moment_trigger waittill( "trigger" );
	
	flag_set( "blind_trigger" + noteworthy );
	if ( isalive( self ) )
	{
		// moment begins if the guy is alive
		if ( !self isFlashed() )
		{
//			if ( self.script_noteworthy == "corner_spawner" )
//				self playsound( "blackout_ru4_breathing" );

			moment_org thread anim_generic( self, moment_anim );
			weapons_free_trigger wait_for_trigger_or_timeout( timer );
		}
		
		level.price advances_to_node( weapons_free_node );
		if ( isalive( self ) )
		{
			// guy needs to die if the player gets too close
			self thread blind_guy_dies_soon( death_timer );
		}
	}		

	level.price advances_to_node( next_signal_node );
	level.price node_notifies_on_arrival( next_signal_node );
}

advances_to_node( node )
{
	if ( isdefined( node.already_advanced ) )
		return;
	node.already_advanced = true;
	self.goalradius = 16;
	self setgoalnode( node );
}

price_signals_on_arrival()
{
	self waittill( "price_reaches_signal_node" );
	for ( ;; )
	{
		level.price waittill_player_lookat();
		wait( 0.5 );// so price can settle after arriving at the node
		if ( !isdefined( level.price.node ) )
			return;
		if ( level.price.node != self )
			return;
	
		level.price handsignal( "go" );
		wait( randomfloatrange( 1.5, 3.5 ) );
	}
}

node_notifies_on_arrival( signal_node )
{
	self waittill( "goal" );
	if ( !isdefined( self.node ) )
		return;
	if ( self.node != signal_node )
		return;
	signal_node notify( "price_reaches_signal_node" );
}


blind_guy_dies_soon( timer )
{
	self endon( "death" );
	self.ignoreme = false;
	wait( timer );
	level.price shoot();
	self die();
}


get_linked_trigger()
{
	links = get_links();
	
	for ( i = 0; i < links.size; i++ )
	{
		ent = getent( links[ i ], "script_linkname" );
		if ( !isdefined( ent ) )
			continue;
			
		if ( issubstr( ent.classname, "trigger" ) )
			return ent;
	}
}

get_linked_node()
{
	links = get_links();
	
	for ( i = 0; i < links.size; i++ )
	{
		node = getnode( links[ i ], "script_linkname" );
		if ( !isdefined( node ) )
			continue;
			
		return node;
	}
}

gaz_teleports_upstairs()
{
	gaz_teleport_node = getnode( "gaz_teleport_node", "targetname" );
	level.gaz teleport( gaz_teleport_node.origin );
	level.gaz setgoalnode( gaz_teleport_node );
	level.gaz.disableexits = true;
	level.gaz.disablearrivals = true;
	level.gaz cqb_walk( "on" );
}

record_old_intensity()
{
	self.old_intensity = self getlightintensity();
}

blackout_lights_go_out()
{
	flag_set( "lights_out" );
	node = getnode( "power_node_switch", "targetname" );
	level.gaz setgoalnode( node ); // turn his back to the player
	level.gaz playsound( "scn_blackout_breaker_box" );
	wait( 2.5 );
	blackout_spotlights = getentarray( "blackout_spotlight", "targetname" );
	array_thread( blackout_spotlights, ::record_old_intensity );
	array_thread( blackout_spotlights, ::_setLightIntensity, 0 );
	disable_oneshotfx_with_noteworthy( "blackout_light_org" );
	blackout_spotlight_model = getent( "blackout_spotlight_model", "targetname" );
	blackout_spotlight_model setmodel( "ch_street_wall_light_01_off" );
}

blackout_fence_swap()
{
	blackout_fence_up = getent( "blackout_fence_up", "targetname" );
	blackout_fence_up connectpaths();
	blackout_fence_up delete();
	blackout_fence_down = getent( "blackout_fence_down", "targetname" );
	blackout_fence_down show();
	blackout_fence_down solid();
}

gaz_runs_by_window()
{
	gaz_teleport_node = getnode( "gaz_teleport_node", "targetname" );
	node = getnode( gaz_teleport_node.target, "targetname" );
	level.gaz maps\_spawner::go_to_node( node );
	flag_set( "gaz_got_to_blackout_door" );
}

gaz_opens_door_and_enters()
{
	level endon( "blackout_rescue_complete" );
	flag_wait( "gaz_got_to_blackout_door" );
	gaz_door = getent( "gaz_door", "targetname" );
	// gaz pops in through the exit door
	door = getent( "exit_door", "targetname" );
	door thread palm_style_door_open();
	
	gaz_door anim_generic( level.gaz, "smooth_door_open" );
	
	node = getnode( "gaz_door_dead_node", "targetname" );
	level.gaz setgoalnode( node );
	
	flag_set( "gaz_opens_door" );
	
	flag_wait( "price_and_gaz_attack_flashlight_guy" );	
	node = getnode( node.target, "targetname" );
	level.gaz setgoalnode( node );
}

#using_animtree( "generic_human" );

gaz_goes_to_cut_the_power()
{
	setsaveddvar( "ai_friendlyFireBlockDuration", "0" );
	level endon( "lights_out" );
	node = getnode( "power_node", "targetname" );
	level.gaz setgoalnode( node );
	level.gaz.goalradius = 32;
	level.gaz waittill( "goal" );
	
	flag_wait( "player_bugs_gaz" );

	// Soap! Regroup with Captain Price! You can storm the building when I cut the power. Go!         
//	level.gaz.looktarget = level.player;
	level.gaz dialogue_queue( "regroup_with_price" );
//	level.gaz.looktarget = undefined;
}

price_approaches_door()
{
	level.price.fixednode = false;
	blackout_door = getent( "blackout_door", "targetname" );
	blackout_door anim_generic_reach_and_arrive( level.price, "smooth_door_open" );
//	level.price.fixednode = true;
	level.price.goalradius = 32;
	level.price.grenadeammo = 0;// bad when he throws them indoors
	level.price.baseaccuracy = 1000;
	level.price.noreload = true;
}

price_opens_door_and_goes_in()
{
	level.price.fixednode = true;

	blackout_door = getent( "blackout_door", "targetname" );
	door = getent( "slow_door", "targetname" );

	door thread palm_style_door_open();
	blackout_door thread anim_generic( level.price, "smooth_door_open" );
	
	blackout_first_price_node = getnode( "blackout_first_price_node", "targetname" );
	level.price advances_to_node( blackout_first_price_node );
	level.price thread node_notifies_on_arrival( blackout_first_price_node );
}

price_attacks_door_guy()
{
	node = getnode( "price_door_attack_node", "targetname" );
	level.price setgoalnode( node );
	thread last_signal_node( node );
	

	flag_wait( "price_and_gaz_attack_flashlight_guy" );	
	node = getnode( node.target, "targetname" );
	level.price setgoalnode( node );
	
	flag_wait( "blackout_flashlightguy_dead" );

	level.price.fixednode = true;
	price_rescue_room_node = getnode( "price_rescue_room_node", "targetname" );
	level.price setgoalnode( price_rescue_room_node );
}

last_signal_node( node )
{
	node thread price_signals_on_arrival();
	
	level.price.goalradius = 8;
	level.price waittill( "goal" );
	node notify( "price_reaches_signal_node" );
}


blackout_vision_adjustment()
{
	for ( ;; )
	{	
		flag_wait( "player_in_house" );
		thread set_vision_set( "blackout_darkness", 0.5 );
// 		thread set_nvg_vision( "blackout_nvg", 0.5 );
		flag_waitopen( "player_in_house" );
		thread set_vision_set( "blackout", 0.5 );
// 		thread set_nvg_vision( "default_night", 0.5 );
	}
}

get_evac_org()
{
	rescue_heli_org = getent( "rescue_heli_org", "targetname" );
	return rescue_heli_org.origin;
}

open_door_trigger( doorname )
{
	flag_init( doorname + "_door_open" );
	burning_door = getent( doorname + "_door", "targetname" );
// 	burning_door connectpaths();
	self waittill( "trigger", other );
	wait( 0.8 );
	burning_door_org = getent( doorname + "_door_org", "targetname" );
	burning_door = getent( doorname + "_door", "targetname" );
	burning_door thread palm_style_door_open();
	length = getanimlength( other getanim_generic( "smooth_door_open" ) );
	burning_door_org thread anim_generic( other, "smooth_door_open" );
	wait( length - 0.5 );
	
	flag_set( doorname + "_door_open" );
}

price_evac_idle()
{
	self waittill( "evac" );
	self anim_loop_solo( level.price, "evac_idle", "tag_detach" );
}


should_break_grenade_launcher_hint( nothing )
{
	heldweapons = level.player getweaponslist();
	stored_ammo = [];
	for ( i = 0; i < heldweapons.size; i++ )
	{
		weapon = heldweapons[ i ];
		stored_ammo[ weapon ] = level.player getWeaponAmmoClip( weapon );
	}

	// dont do the hint if we don't have the weapon
	if ( !isdefined( stored_ammo[ "m203_m4_silencer_reflex" ] ) )
		return true;	
		
	weapon = level.player getcurrentweapon();
	if ( weapon == "m203_m4_silencer_reflex" )
		return true;
	if ( flag( "power_plant_cleared" ) )
		return true;
	
	// dont do the hint if we're out of ammo
	return stored_ammo[ "m203_m4_silencer_reflex" ] == 0;
}

should_break_sniper_rifle_hint( nothing )
{
	heldweapons = level.player getweaponslist();
	stored_weapon = [];
	for ( i = 0; i < heldweapons.size; i++ )
	{
		weapon = heldweapons[ i ];
		stored_weapon[ weapon ] = true;
	}

	// dont do the hint if we don't have the weapon
	if ( !isdefined( stored_weapon[ "m14_scoped_silencer_woodland" ] ) )
		return true;
	
	if ( flag( "overlook_attack_begins" ) )
		return true;
		
	// don't do the hint if we're already using the sniper rifle
	return level.player getcurrentweapon() == "m14_scoped_silencer_woodland";
}

attack_player()
{
	self endon( "death" );
	self.goalradius = 1200;
	
	for ( ;; )
	{
		self.goalradius -= 128;
		if ( self.goalradius < 750 )
			self.goalradius = 750;
			
		self setgoalpos( level.player.origin );
		wait( 5 );
	}
}

grenade_hint_logic()
{
	level endon( "farm_complete" );
	flag_wait( "m203_hint" );
	thread display_hint( "grenade_launcher" );
}

swamp_sprint_protection()
{
	flag_wait( "play_nears_meeting" );
	
	flags = [];
	flags[ flags.size ] = "pier_guys";
	flags[ flags.size ] = "hut_guys";
	flags[ flags.size ] = "chess_cleared";
	flags[ flags.size ] = "shack_cleared";

	// all the flags cleared?
	cleared = 0;
	for ( i = 0; i < flags.size; i++ )
	{
		if ( !flag( flags[ i ] ) )
		{
			break;
		}
		cleared++;
	}
	if ( cleared == flags.size )
		return;

	// the player has skipped ahead so kill the baddies and tele gaz and price up
	meeting_catchup_org = getentarray( "meeting_catchup_org", "targetname" );
	level.price teleport( meeting_catchup_org[ 0 ].origin );
	level.gaz teleport( meeting_catchup_org[ 1 ].origin );	
	level.price set_force_color( "c" );
	level.gaz set_force_color( "c" );
	
	array_levelthread( flags, ::kill_all_ai_of_deathflag );
}

kill_all_ai_of_deathflag( flagname )
{
	array_levelthread( level.deathflags[ flagname ][ "ai" ], ::kill_myself_shortly );
}

kill_myself_shortly( guy )
{
	// guy instead of self because the member of the array could potentially be removed and unable to thread a function
	if ( !isalive( guy ) )
		return;
		
	guy endon( "death" );
	wait( randomfloatrange( 0.1, 3.5 ) );
	guy die();		
}

price_and_gaz_catchup_to_bridge()
{
	orgs = getentarray( "friendly_catchup_org_1", "targetname" );
	
	// spammy because the player can be in a wide positional range due to the 2 open
	// spots under the bridge.
	for ( i = 0; i < orgs.size; i++ )
	{
		level.gaz teleport( orgs[ i ].origin );
		level.price teleport( orgs[ i ].origin );
	}
}

blackhawk_sound()
{
	fly = "blackout_blackhawk_fly";
	idle = "blackout_blackhawk_idle";

	flyblend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	flyblend thread manual_linkto( self, ( 0, 0, 0 ) );

	idleblend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	idleblend thread manual_linkto( self, ( 0, 0, 64 ) );

	flyblend thread mix_up( fly );
	flag_wait( "blackhawk_lands" );

	flyblend thread mix_down( fly );
	idleblend thread mix_up( idle );

	flag_waitopen( "blackhawk_lands" );
	flyblend thread mix_up( fly );
	idleblend thread mix_down( idle );
}

player_jumps_into_heli()
{
	level endon( "player_gets_on_heli" );
	for ( ;; )
	{
		level.hud_mantle[ "text" ].alpha = 0;
		level.hud_mantle[ "icon" ].alpha = 0;
		flag_wait( "player_near_heli" );
		detect_player_mantle();
	}
}

detect_player_mantle()
{
	level endon( "player_gets_on_heli" );
	for ( ;; )
	{
		if ( !flag( "player_near_heli" ) )
		{
			level.hud_mantle[ "text" ].alpha = 0;
			level.hud_mantle[ "icon" ].alpha = 0;
			return;
		}
		level.hud_mantle[ "text" ].alpha = 1;
		level.hud_mantle[ "icon" ].alpha = 1;
			
		if ( level.player getvelocity()[ 2 ] > 8 )
		{
			flag_set( "player_gets_on_heli" );
		}
		wait( 0.05 );
	}
}

first_rpg_spawner_think()
{
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self.IgnoreRandomBulletDamage = true;
	self waittill( "goal" );
	
	self.a.rockets = 5000;
	bm21 = getent( "bm21_03", "targetname" );
	if ( isalive( bm21 ) )
	{
		self setentitytarget( bm21 );
		attractor = Missile_CreateAttractorOrigin( bm21.origin + ( 0, 0, 50 ), 5000, 500 );
		bm21.health = 500;
		bm21 add_wait( ::waittill_msg, "death" );
		add_wait( ::_wait, 30 );
		do_wait_any();
	
		if ( isalive( bm21 ) )
			radiusdamage( bm21.origin, 250, 5000, 2500 );

		Missile_DeleteAttractor( attractor );
	}
	
	self.IgnoreRandomBulletDamage = false;
	self.ignoreme = false;
	self stop_magic_bullet_shield();
	self.a.rockets = 1;
	wait( 1 );
	self die();
	flag_set( "first_bmp_destroyed" );
}

bmp_killer_spawner_think()
{
	level.bmp_killer = self;
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self.IgnoreRandomBulletDamage = true;
	self waittill( "goal" );
	
	self.a.rockets = 5000;
	if ( isalive( level.enemy_bmp ) )
	{
		self setentitytarget( level.enemy_bmp );
		attractor = Missile_CreateAttractorOrigin( level.enemy_bmp.origin + ( 0, 0, 0 ), 5000, 500 );
		level.enemy_bmp godoff();
		level.enemy_bmp.health = 500;
		level.enemy_bmp add_wait( ::waittill_msg, "death" );
		add_wait( ::_wait, 30 );
		do_wait_any();
	
		if ( isalive( level.enemy_bmp ) )
			radiusdamage( level.enemy_bmp.origin, 250, 5000, 2500 );

		Missile_DeleteAttractor( attractor );
	}
	
	self.IgnoreRandomBulletDamage = false;
	self.ignoreme = false;
	self stop_magic_bullet_shield();
	self.a.rockets = 1;
	
	cliff_remove_node = getnode( "cliff_remove_node", "targetname" );
	self setgoalnode( cliff_remove_node );
	self.goalradius = 32;
	self waittill( "goal" );
	self delete();
}

waittill_on_node( node )
{
	self waittill( "goal" );
	for ( ;; )
	{
		if ( !isdefined( self.node ) )
		{
			wait( 0.05 );
			continue;
		}
		if ( self.node != node )
		{
			wait( 0.05 );
			continue;
		}
		if ( distance( self.origin, node.origin ) > 12 )
		{
			wait( 0.05 );
			continue;
		}
		/*
		if ( self.a.movement != "stop" )
		{
			wait( 0.05 );
			continue;
		}
		*/
		break;
	}
}

first_signal_on_node( node, signal )
{
	level endon( "high_alert" );
	hut_patrol = getent( "hut_patrol", "targetname" );
	if ( !isalive( hut_patrol ) )
		return;
	hut_patrol endon( "death" );
	waittill_on_node( node );
	flag_wait( "player_near_pier" );
	self thread anim_generic( self, signal );
	wait( 2.0 );
	flag_set( "weapons_free" );
}

shack_signal( node )
{
	level endon( "high_alert" );
	level endon( "chess_cleared" );

//	level.price setgoalnode( node );
	level.price waittill_on_node( node );
	// do it
	
//	level.price thread anim_single_queue( level.price, "do_it" );
	level.price thread anim_generic( level.price, "go_exposed" );

	//	Soap - plant some claymores in front of the door, then get their attention.	
	level.price thread dialogue_queue( "plant_claymore" );
	
	// delete the clip that makes price's approach look better
	hut_approach_clip = getent( "hut_approach_clip", "targetname" );
	hut_approach_clip connectpaths();
	hut_approach_clip delete();
	
	wait( 4 );
	thread display_hint( "claymore_plant" );
	for ( ;; )
	{
		if ( should_break_claymores() )
			break;
		wait( 0.05 );
	}
	wait( 3.0 );
	thread display_hint( "claymore_placement" );
}

signal_on_node( node, signal )
{
	level endon( "high_alert" );
	waittill_on_node( node );
// 	wait( 0.25 );
	
	self anim_generic( self, signal );
}

price_and_gaz_flash_hut()
{
	if ( flag( "hut_guys" ) )
		return;
	level endon( "hut_guys" );
	level endon( "high_alert" );
	level endon( "recent_flashed" );
	
	flag_wait( "price_throws_flash" );
	flag_wait( "gaz_flash_ready" );
	
	price_door_flash = getent( "price_door_flash", "script_noteworthy" );
	
	for ( ;; )
	{
		if ( !isdefined( level.price.node ) )
		{
			wait( 0.05 );
			continue;
		}
		if ( !level.price istouching( price_door_flash ) )
		{
			wait( 0.05 );
			continue;
		}
		break;		
	}
	wait( 0.5 ); // for price to get on node

	node = spawn( "script_origin", level.price.node.origin );
	node.angles = level.price.node.angles + ( 0, 90, 0 );
		
	node thread anim_generic( level.price, "grenade_throw" );
	
	oldGrenadeWeapon = level.price.grenadeWeapon;
	level.price.grenadeWeapon = "flash_grenade";
	level.price.grenadeAmmo++ ;

	wait 3.5;		

	flash_throw_offset = getent( "flash_throw_offset", "targetname" );
	targ = getent( flash_throw_offset.target, "targetname" );
	
	start = flash_throw_offset.origin;
	
	end = start + ( targ.origin - flash_throw_offset.origin );
	vel = targ.origin - flash_throw_offset.origin;
	/*
	if ( isdefined( velocity ) )
	{
		end = end + ( 0, 0, 200 );
		vec = vectornormalize( end - start );
		if ( !isdefined( magnitude ) )
			magnitude = 350;
		vec = vector_multiply( vec, magnitude );
		
		level.price magicgrenademanual( start, vec, 1.1 );
	}
	else
	*/
	vec = vectornormalize( end - start );
	magnitude = 350;
	vec = vector_multiply( vec, magnitude );
	level.price magicgrenademanual( start, vec, 1.1 );
	level.price.grenadeWeapon = oldGrenadeWeapon;	
	level.price.grenadeAmmo = 0;
	
	wait 0.8;
	flag_set( "gaz_rushes_hut" );
}

should_break_claymores()
{
	if ( flag( "high_alert" ) )
		return true;
	if ( flag( "chess_cleared" ) )
		return true;
	claymoreCount = getPlayerClaymores();
	if ( claymoreCount <= 0 )
		return true;

	return level.player GetCurrentWeapon() == "claymore";
}

should_break_claymore_placement()
{
	if ( flag( "high_alert" ) )
		return true;
	if ( flag( "chess_cleared" ) )
		return true;
	claymoreCount = getPlayerClaymores();
	if ( claymoreCount < 2 )
		return true;

	return level.player GetCurrentWeapon() != "claymore";
}

sniper_remove_trigger()
{
	self waittill( "trigger" );
	flag_set( "bm21s_attack" );
	
	if ( !player_has_weapon_substr( "m14" ) )
		return;
	gun = getent( self.target, "targetname" );
	gun delete();
}

player_has_weapon_substr( msg )
{
	heldweapons = level.player getweaponslist();
	
	// take away weapons mo has in scoutsniper that we dont have in sniperescape
	
	for ( i = 0; i < heldweapons.size; i++ )
	{
		if ( issubstr( heldweapons[ i ], msg ) )
			return true;
	}
	return false;
}

player_in_house()
{
	Objective_Position( 7, informant_org() );
	Objective_Ring( 7 );

	thread display_hint( "nvg" );
	flag_waitopen( "player_in_house" );
	thread display_hint( "disable_nvg" );
}

watch_for_movement()
{
	if ( getaiarray( "axis" ).size > 0 )
		return;
	wait( 0.5 );
	if ( flag( "high_alert" ) )
		return;
	level endon( "high_alert" );
	
	wait( 8 );
	radio_dialogue( "watch_for_movement" );
	wait( 2 );
//	radio_dialogue( "whats_noise" );
}

lightswitch_response()
{
	flag_wait( "lightswitch" );
	wait( 1.2 );
	// this night vision makes it too easy
	level.price anim_single_queue( level.price, "this_night_vision" );
}


get_prop( prop )
{
	model = undefined;
	if ( prop == "binocs" )
	{
		model = spawn( "script_model", (0,0,0) );
		model setmodel( level.scr_model[ "binocs" ] );
		model linkto( self, "TAG_INHAND", (0,0,0), (0,0,0) );
	}
	return model;
}

tango_down_detection()
{
	self waittill( "death" );	
	wait( 1 );
	
	if ( gettime() < level.next_tango_timer )
		return;
		
	level.next_tango_timer = gettime() + 4000;
		
	if ( randomint( 100 ) > 50 )
	{
		level.price anim_single_queue( level.price, "tango_down" );
	}
	else
	{
		level.gaz anim_single_queue( level.gaz, "tango_down" );
	}
}

patrol_soon()
{
	self endon( "death" );
	if ( flag( "high_alert" ) )
		return;
	level endon( "high_alert" );		
	flag_wait( "player_near_pier" );
	self thread maps\_patrol::patrol( self.target );
}

ignore_until_high_alert()
{
	self endon( "death" );
	self.ignoreme = true;
	flag_wait( "high_alert" );
	self.ignoreme = false;
}

activate_farmhouse_defenders()
{
	wait( 4 );
	farmhouse_defender = getent( "farmhouse_defender", "target" );
	for ( i = 0; i < 20; i++ )
	{
		farmhouse_defender activate_trigger();
		wait( 2 );
	}
}

set_allowed_stances( stance1, stance2, stance3 )
{
	if ( isdefined( stance3 ) )
	{
		self allowedstances( stance1, stance2, stance3 );
		return;
	}
	if ( isdefined( stance2 ) )
	{
		self allowedstances( stance1, stance2 );
		return;
	}
	self allowedstances( stance1 );
}

field_russians_go_up_hill()
{
	flag_wait( "go_up_hill" );
	org = getent( "mortar_setup_1", "targetname" );
	
	guys = get_array_of_closest( org.origin, level.field_russians );
	
	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] notify( "go_up_hill" );
		if ( !isdefined( guys[ i ].script_noteworthy ) )
			wait( 0.3 + randomfloat( 0.1, 0.2 ) );
	}
}

delete_meeting_clip( meeting_clip )
{
	meeting_clip connectpaths();
	meeting_clip delete();
}

hut_runner_think()
{
	self endon( "death" );
	flag_wait( "high_alert" );
	org = getent( "hut_runner_dest", "targetname" );
	for ( ;; )
	{
		self notify( "_stealth_stop_stealth_behavior" );
		self setgoalpos( org.origin );
		self.goalradius = 128;
		self.pathenemyfightdist = 32;
		self.pathenemylookahead = 32;
		wait( 0.05 );
	}
}

smell_kamarov()
{
	flag_wait( "smell_kamarov" );
	level.price dialogue_queue( "smell_that" );
	wait( 0.8 );
	level.gaz dialogue_queue( "yeah_kam" );
}


kam_and_price_chat()
{
	// Welcome to the new Russia, Captain Price.	
//	level.kamarov delaythread( 4.250, ::dialogue_queue, "welcome" );

	// What's the target Kamarov? We've got an informant to recover.                                     
//	level.price delaythread( 8.0, ::dialogue_queue, "whats_the_target" );

	// The Ultranationalists have BM21s on the other side of the hill. Their rockets have killed hundreds of civilians in the valley below.	
//	level.kamarov delaythread( 11.00, ::dialogue_queue, "valley_below" );

	// Not so fast. Remember Beirut? You're with us.	
//	level.price delaythread( 18.75, ::dialogue_queue, "beirut" );

	// Hmm…I guess I owe you one.	
//	level.kamarov delaythread( 22.4, ::dialogue_queue, "owe_you" );

	// Move out.	
//	level.price delaythread( 25.25, ::dialogue_queue, "move_out" );

	// Bloody right you do.	
	level.gaz delaythread( 25.4, ::anim_single_solo, level.gaz, "bloody_right" );

	// Vanya, move in and prepare to attack. Wait for my signal.	
	level.kamarov delaythread( 33.3, ::dialogue_queue, "prepare_to_attack" );

	// This way. There's a good spot where your sniper can cover my men.	
	level.kamarov delaythread( 39.3, ::dialogue_queue, "good_spot" );
	
	level delaythread( 43, ::flag_set, "ready_to_commence_attack" );

}

display_sniper_hint()
{
	if ( should_break_sniper_rifle_hint() )
		return;
	// Soap, switch to your sniper rifle.	
	level.price dialogue_queue( "switch_sniper" );
	wait( 4 );
	thread display_hint( "sniper_rifle" );
}



macmillan_proud_hook()
{
	self waittill( "death", attacker, type, weapon );
	if ( isdefined( level.mac_proud ) )
		return;
	wait( 0.35 );

	if ( flag( "mission_chatter" ) )
		return;
	if ( !isalive( attacker ) )
		return;
	if ( attacker != level.player )
		return;
	if ( !isdefined( weapon ) )
		return;
		
	if ( !issubstr( weapon, "m14" ) )
		return;
	if ( distance( self.origin, attacker.origin ) < 3000 )
		return;

		
	level.mac_proud = true;
	// Nice shot. MacMillan would be impressed.	
	level.price dialogue_queue( "macmillan_impressed" );
}

visible_mgguy_think()
{
	flag_set( "visible_mg_gunner_alive" );
	self waittill( "death" );
	flag_clear( "visible_mg_gunner_alive" );
}

damn_helicopters()
{
	flag_set( "mission_chatter" );
	// Damn, enemy helicopters!	
	level.kamarov dialogue_queue( "damn_helis" );

	// You didn't say there would be helicopters Kamarov.	
	level.price dialogue_queue( "you_didnt_say" );

	// I didn't say there wouldn't be any either. We need to protect my men from those helicopter troops. This way!	
	level.kamarov dialogue_queue( "need_protect" );

	thread damn_helicopters_followup();
}

damn_helicopters_followup()
{
	wait( 1 );
	// Make it quick Kamarov, I want that informant…	
	level.price dialogue_queue( "make_quick" );

	// You have nothing to worry about. We'll take out the BM21s and carve a path straight to your informant Captain Price.	
	level.kamarov dialogue_queue( "nothing_to_worry" );

	wait( 1.5 );
	level.kamarov dialogue_queue( "stalling" );

	wait( 1 );
	// We should just beat it out of him sir.	
	level.gaz dialogue_queue( "beat_it_out" );

	wait( 0.8 );
	// Not yet.	
	level.price dialogue_queue( "not_yet" );
	flag_clear( "mission_chatter" );
}

cliff_dialogue()
{
	// What is your status? How much longer do you need? All right, I'll keep stalling them.	
//	level.kamarov dialogue_queue( "stalling" );
	
	delaythread( 2, ::flag_set, "head_to_the_cliff" );

	/#
	if ( level.start_point == "rappel" )
		return;
	#/
	// Captain Price, my men have run into heavy resistance. Help me support them from the cliffs.	
	level.kamarov dialogue_queue( "heavy_resistance" );
	
	// What about our informant? He's running out of time!	
	level.price dialogue_queue( "our_informant" );
	
	// Then help us! The further my men can get into this village, the closer we will be to securing your informant!	
	level.kamarov dialogue_queue( "then_help" );
	
}

power_station_dialogue()
{
	flag_wait( "power_station_dialogue_begins" );
	flag_wait( "kam_starts_talking" );
	thread price_and_gaz_arrive_at_fight_check();


	
	// Look. The final assault has already begun. With a little more of your sniper support we are sure to be victorious. Captain Price, I need to ask one more favor of you and your men - (gets cut off)	
	level.kamarov thread dialogue_queue( "final_assault" );
	delaythread( 5, ::flag_set, "kam_wants_more_sniping" );

//	flag_wait( "price_and_gaz_arrive_at_fight" );
	flag_wait( "gaz_at_fight" );
	flag_wait( "price_at_fight" );
	flag_wait( "kam_at_fight" );
	flag_wait_or_timeout( "player_at_rappel", 5 );
	flag_set( "gaz_kam_fight_begins" );
	
	guys = [];
	guys[ guys.size ] = level.price;
	guys[ guys.size ] = level.gaz;
	guys[ guys.size ] = level.kamarov;
	
	level.kamarov thread gun_remove();
	level.kamarov thread play_sound_on_entity( "scn_blackout_bodyslam_kamarov" );
	node = getent( "gaz_kam_org", "targetname" );
	node thread anim_single( guys, "cliff_start" );
	
	minus_time = 5.5;
	level.timer = gettime();
	// Enough sniping! Where is the informant?	
	level.gaz delaythread( 10 - minus_time, ::anim_single_solo, level.gaz, "enough_sniping" );
	level.kamarov delaythread( 10.2 - minus_time, ::_stopsounds );
	level.kamarov delaythread( 16.2 - minus_time, ::_stopsounds );

	// What are you doing - are you out of your mind? Who do you think you are you - (cut off by Gaz)	
	level.kamarov delaythread( 12.25 - minus_time, ::anim_single_solo, level.kamarov, "russian_out_of_mind" );
	// Where..IS he?	/ where is he
	level.gaz delaythread( 14.8 - minus_time, ::anim_single_solo, level.gaz, "where_is" );
	// The house (cough)... the house at the northeast end of the village! 	
	level.kamarov delaythread( 16.6 - minus_time, ::anim_single_solo, level.kamarov, "the_house" );
	// Well that wasn't so hard was it? Now go sit in the corner.	
	level.gaz delaythread( 21.0 - minus_time, ::anim_single_solo, level.gaz, "wasnt_that_hard" );
	// Soap, Gaz. We've got to reach that house before anything happens to the informant. Let's go!	
	level.price delaythread( 24 - minus_time, ::anim_single_solo, level.price, "reach_that_house" );
	delaythread( 24 - minus_time, ::flag_set, "price_got_to_go" );

	wait( 26 - minus_time );	
	flag_set( "gaz_convinces_kam_otherwise" );
	
	if ( flag( "player_rappels" ) )
		return;
		
	level endon( "player_rappels" );
	wait( 12 );
	// Soap, get down here, move!	
	level.price dialogue_queue( "get_down_here" );
}

_stopsounds()
{
	self stopsounds();
}

bmp_targets_stuff()
{
	self endon( "death" );
	level.timer = gettime();
	wait( 15.2 );
	targets = getentarray( "cliff_tank_target", "targetname" );
	
	self thread bmp_aims_at_targets();
	wait( 1.5 );
	for ( ;; )
	{
		shots = randomintrange( 4, 7 );
		for ( i = 0; i < shots; i++ )
		{
			self fireWeapon();
			wait( 0.35 );
		}
		wait( randomfloatrange( 1.5, 3 ) );
	}
	
}

bmp_aims_at_targets()
{
	self endon( "death" );
	targets = getentarray( "cliff_tank_target", "targetname" );
	for ( ;; )
	{
		for ( i = 0; i < targets.size; i++ )
		{
			self setturrettargetent( targets[ i ] );
			self waittill( "turret_on_target" );
			wait( randomfloat( 1.5, 2.5 ) );
		}
	}
	
}

is_healthy()
{
	if ( !isalive( self ) )
		return false;

	if ( isdefined( self.isFlashed ) )
		return false;
	return self.health == 50000;
}

music_control()
{
	wait( 1 );
	
	if ( !flag( "smell_kamarov" ) )
		thread music_playback( "blackout_deadpool", 121, true );
	
	flag_wait( "smell_kamarov" );
	level notify ( "next_music_track" );
	musicstop( 18 );
	
	flag_wait( "bm21s_attack" );
	wait 12;
	thread music_playback( "blackout_danger", 124, true );
	
	flag_wait( "overlook_attack_begins" );
	level notify ( "next_music_track" );
	musicstop( 6 );
	
	flag_wait( "cliff_complete" );
	level notify ( "next_music_track" );
	musicstop();
	wait 6;
	thread music_playback( "blackout_danger", 124, true );
	
	//flag_wait( "hurry_to_nikolai" );
	//flag_wait( "player_rappels" );
	flag_wait( "price_got_to_go" );
	level notify ( "next_music_track" );
	musicstop( 3.7 );
	wait 3.8;
	thread music_playback( "blackout_hurry", 55, true, 0.5 );
	
	//flag_wait( "player_in_house" );
	//flag_wait( "blackout_house_begins" );
	
	flag_wait( "player_at_blackout_door" );
	flag_wait( "lights_out" );
	level notify ( "next_music_track" );
	musicstop( 5 );
	wait 5.1;
	thread music_playback( "blackout_nightvision", 43, true );
	
	//flag_wait( "blackout_rescue_complete" );
	flag_wait( "price_rescues_vip" );
	level notify ( "next_music_track" );
	musicstop( 7 );
	wait 8;
	
	//flag_waitopen( "player_in_house" );
	//level notify ( "next_music_track" );
	//thread music_playback( "blackout_danger", 124, true );
	
	flag_wait( "player_gets_on_heli" );
	level notify ( "next_music_track" );
	musicstop();
	wait 0.1;
	thread music_playback( "blackout_outro", 24 );
}

music_playback( cuename, cuelength, repeating, repeatgap )
{
	level endon( "next_music_track" );
	
	assertEX( isdefined( cuename ), "specify an alias to play" );
	assertEX( isdefined( cuelength ), "specify the length of the music cue in seconds" );
	
	if ( !isdefined( repeating ) )
		repeating = false;
		
	if ( !isdefined( repeatgap ) )
		repeatgap = 1;
	
	if ( repeating )
	{
		while ( 1 )
		{
			MusicPlayWrapper( cuename );
			wait cuelength;
			musicstop();
			wait repeatgap;
		}
	}
	else
	{
		MusicPlayWrapper( cuename );
	}
}

cliff_reminder()
{
	if ( flag( "player_reaches_cliff_area" ) )
		return;
		
	level endon( "player_reaches_cliff_area" );
	for ( ;; )
	{
		if ( distance( level.player.origin, level.price.origin ) > 600 )
			over_here();
		wait( 1 );
	}
}

over_here()
{
	// Soap, over here.                                                                                    
	level.price dialogue_queue( "over_here" );
	wait( randomfloatrange( 9, 14 ) );
	// Soap, get down here, move!	
	level.price dialogue_queue( "get_down_here" );
}

binocs_delete()
{
	flag_wait( "kamarov_drops_binocs" );
	level.binocs delete();
}

breach_door()
{
	// work around the door handle being wrong
	breach1_door = getent( "breach1_door", "targetname" );
	breach1_bmodel_door = getent( "breach1_bmodel_door", "targetname" );
	breach1_bmodel_door linkto( breach1_door );
	breach1_door hide();
}

trigger_deletes_children()
{
	self endon( "death" );
	ents = self get_linked_ents();
	self waittill( "trigger" );
	for ( i = 0; i < ents.size; i++ )
	{
		if ( isdefined( ents[ i ] ) )
			ents[ i ] delete();
	}

	self delete();
}

price_and_gaz_arrive_at_fight_check()
{
	trigger = getent( "price_gaz_cliff_trigger", "targetname" );
	for ( ;; )
	{
		if ( level.price istouching( trigger ) && level.gaz istouching( trigger ) )
			break;
		wait( 0.05 );
	}

	wait( 3.5 );
	flag_set( "price_and_gaz_arrive_at_fight" );
}

commence_attack_on_death()
{
	self waittill( "death" );
	flag_set( "player_near_overlook" );
}

overlook_alarm()
{
	alarm = getent( "alarm_org", "targetname" );
	alarm playloopsound( "emt_alarm_base_alert" );
	wait( 15 );
	alarm delete();
}

instant_high_alert()
{
	self waittill( "damage" );
	wait( 2 );
	flag_set( "high_alert" );
	level notify( "instant_high_alert" );
}

detect_recent_flashed()
{
	for ( ;; )
	{
		level add_wait( ::_waittillmatch, "event_awareness", "explode" );
		level add_wait( ::_waittillmatch, "event_awareness", "doFlashBanged" );		
		do_wait_any();
		flag_set( "recent_flashed" );
		wait( 4 );
		flag_clear( "recent_flashed" );
	}
}

is_overlook_or_earlier_start() 
{
	if ( is_default_start() )
		return true;
	
	if ( level.start_point == "overlook" )
		return true;
	
	if ( level.start_point == "field" )
		return true;
	
	return level.start_point == "chess";
}

is_rappel_or_earlier_start()
{
	if ( level.start_point == "cliff" )
		return true;
	if ( level.start_point == "rappel" )
		return true;
	return is_overlook_or_earlier_start();
}
