#include maps\_hud_util;
#include maps\_utility;
#include maps\_debug;
#include animscripts\utility;
#include maps\_vehicle;
#include maps\sniperescape;
#include maps\sniperescape_exchange;
#include maps\sniperescape_code;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_stealth_logic;

bring_out_the_hounds()
{
	level endon( "break_for_apartment" );
	wait( 20 );
	
	kill_dog_spawners = getentarray( "kill_dog_spawner", "targetname" );
	array_thread( kill_dog_spawners, ::add_spawn_function, ::seek_player );
	
	for ( ;; )
	{
		if ( getaispeciesarray( "all", "all" ).size >= 24 )
		{
			wait( 1 );
			continue;
		}
		
		spawners = get_array_of_closest( level.player.origin, kill_dog_spawners );
		count = 0;
		
		for ( i = spawners.size - 1; i >= 0; i -- )
		{
			spawner = spawners[ i ];
			if ( bullettracepassed( level.player.origin + ( 0, 0, 32 ), spawner.origin + ( 0, 0, 32 ), false, level.player ) )
				continue;
			
			count++ ;
			spawner.count = 1;
			spawner dospawn();
			
			wait( randomfloat( 2, 3 ) );
			if ( count >= 8 )
				break;
		}
		
		wait( 3 );
	}
}

seek_player()
{
	self endon( "death" );
	for ( ;; )
	{
		self setgoalpos( level.player.origin );
		self.goalradius = 512;
		wait( 1 );
	}
}

pool_dog_think()
{
	self.team = "allies";// go getem!

	scene = "dog_food";
	if ( !isdefined( level.first_pool_dog ) )
	{
		// only one dog makes eating sound
		level.first_pool_dog = true;
		thread dog_loop_sound();
	}
	
	self endon( "death" );
	self.allowdeath = true;
	ent = getent( self.target, "targetname" );
	self.no_friendly_fire_penalty = true;
	
	ent thread anim_generic_loop( self, scene );
	wait( 0.05 );
	self setanimtime( getanim_generic( "dog_food_nonidle" ), randomfloat( 1 ) );
	self.goalheight = 512;

	thread dog_attacks_player_if_he_feels_threatened( ent );
	
	flag_wait( "fairbattle_high_intensity" );
	if ( !flag( "player_looked_in_pool" ) )
	{
		self delete();
	}
		
	wait( 3 );
	ent notify( "stop_loop" );
	self stopanimscripted();
	self.goalradius = 1500;
	park_reinforce = getent( "park_reinforce", "targetname" );
	self setgoalpos( park_reinforce.origin );
	
// 	self delete();// gotta wait until the op force tag_sync is in
}

dog_loop_sound()
{
	flag_init( "dogs_disturbed" );
	self playloopsound( "anml_dogs_eating_body_loop" );
	level add_wait( ::flag_wait, "dogs_disturbed" );
	self add_wait( ::waittill_msg, "death" );
	do_wait_any();
	if ( isalive( self ) )
		self stoploopsound( "anml_dogs_eating_body_loop" );
}

wait_for_angry_dog()
{
	level endon( "dog_attack_trigger" );
	for ( ;; )
	{
		flag_waitopen( "price_picked_up" );
		flag_wait( "pool_lookat" );
		
		// is price dropped?
		if ( !flag( "price_picked_up" ) )
			break;
	}
}

dog_attacks_player_if_he_feels_threatened( ent )
{
	
	self endon( "death" );
	level endon( "fairbattle_high_intensity" );

	wait_for_angry_dog();	
	
	ent notify( "stop_loop" );
	self stopanimscripted();
	flag_set( "dogs_disturbed" );
// 	self.goalradius = 4;
// 	wait( randomfloatrange( 2, 3 ) );
// 	wait( 151 );
// 	thread reacquire_player_pos();

	// the dogs flee if they've already been spawned once
// 	flag_wait( "pool_heli_attacks" );
	wait( randomfloatrange( 0.2, 0.9 ) );
	dog_flee_org = getent( "dog_flee_org", "targetname" );
	self stopanimscripted();
	self maps\_spawner::go_to_origin( dog_flee_org );
	self delete();
}

go_prone_line_check()
{
	if ( flag( "price_told_player_to_go_prone" ) )
		return;
		
	claymoreCount = getPlayerClaymores();
	if ( claymoreCount > 0 )
		return;

	// Find a good spot to snipe from and go prone.
	thread price_line( "find_spot_go_prone" );
	flag_set( "price_told_player_to_go_prone" );
}

wait_for_player_to_place_claymores()
{
	bonus = 0;

	oldClaymoreCount = getPlayerClaymores();
	for ( i = 0; i < 30; i++ )
	{
		newClaymoreCount = getPlayerClaymores();
		
		if ( newClaymoreCount < oldClaymoreCount )
		{
			bonus += 3.5;
		}
		oldClaymoreCount = newClaymoreCount;
		
		if ( level.player getstance() == "prone" && newClaymoreCount == 0 )
			return;
			
		go_prone_line_check();
		wait( 1 );
	}

	if ( bonus > 0 )
	
	for ( i = 0; i < bonus; i++ )
	{
		newClaymoreCount = getPlayerClaymores();
		if ( level.player getstance() == "prone" && newClaymoreCount == 0 )
			return;
			
		go_prone_line_check();
		wait( 1 );
	}
}

autosave_on_good_claymore_placement( claymoreCount )
{
	alt_fair_trigger = getent( "alt_fair_trigger", "targetname" );
	
	for ( i = 0; i < 5; i++ )
	{
		if ( level.player istouching( alt_fair_trigger ) )
			wait( 1 );
		else
			break;
	}
	
	if ( level.player istouching( alt_fair_trigger ) )
		return false;
		
	claymore_spots = getentarray( "claymore_spot", "targetname" );
	
	if ( claymoreCount <= 0 )
		return true;
		
	// gotta place
	required = claymoreCount * 0.40;
	required = int( required );// rounds down!
	
	grenades = getentarray( "grenade", "classname" );
	claymores = remove_without_model( grenades, "claymore" );
	
	count = 0;
	for ( i = 0; i < claymores.size; i++ )
	{
		for ( p = 0; p < claymore_spots.size; p++ )
		{
			if ( distance( claymores[ i ].origin, claymore_spots[ p ].origin ) < claymore_spots[ p ].radius )
			{
				// found a claymore that is close to a spot that would be smart to put one near
				
				count++ ;
				break;
			}
		}
		
		if ( count >= required )
			return true;
	}
	
	return false;
}

no_grenades()
{
	self.grenadeammo = 0;
}



price_says_a_bit_farther()
{
	level endon( "beacon_placed" );
	flag_assert( "beacon_placed" );
	price_putdown_hint_trigger = getent( "price_putdown_hint_trigger", "targetname" );
	
	lines = [];
	index = 0;
	// A bit farther to the north…	
	lines[ lines.size ] = "a_bit_farther_north_2";
	// Check your compass for the best location.	
	lines[ lines.size ] = "check_your_compass";

	
	for ( ;; )
	{
		price_putdown_hint_trigger waittill( "trigger" );
		if ( flag( "price_picked_up" ) )
		{
			price_line( lines[ index ] );
			index++ ;
			if ( index >= lines.size )
				index = 0;
			wait( randomfloatrange( 10, 12 ) );
		}
	}
}


fairground_keep_player_out_of_pool()
{

	// anti cheap the sequence by going into a non fighting area
	for ( ;; )
	{
		flag_wait( "player_goes_to_pool" );
		flag_clear( "can_save" );
		wait( randomfloat( 4, 6 ) );

		if ( !flag( "player_goes_to_pool" ) )
		{
			if ( !flag( "seaknight_lands" ) )
			{
				flag_set( "can_save" );
			}
			
			continue;
		}

		price_dies();
		flag_waitopen( "player_goes_to_pool" );
	}
}

player_abandons_seaknight_protection()
{
	flag_wait( "price_picked_up" );
// 	flag_wait( "player_abandon_protection" );
	level waittill( "foawerawer" );// recompling
	
	flag_set( "seaknight_leaves_prematurely" );
}

wait_for_seaknight_to_take_off()
{
	level endon( "seaknight_leaves_prematurely" );
	flag_wait( "player_made_it_to_seaknight" );
}

player_boards_seaknight( seaknight, trigger )
{
	asked_for_macmillan = false;
	for ( ;; )
	{
		if ( isalive( level.price ) )
			objective_position( getobj( "seaknight" ), level.price.origin );
		else
			objective_position( getobj( "seaknight" ), trigger.origin );
		
		wait( 0.05 );

		if ( distance( level.player.origin, trigger.origin ) >= trigger.radius )
			continue;
		
		// player has to carry price to chopper
		if ( !isalive( level.price ) )
			break;
			
		if ( !asked_for_macmillan )
		{
			// WHERE'S MACMILLAAAN?!!!
			// where is macmillan where's macmillan
			thread price_line( "where_is_he" );
			asked_for_macmillan = true;
			delaythread( 2, ::display_hint, "where_is_he" );
		}
	}

	// already left?
	if ( flag( "seaknight_leaves" ) )
		return;

	thread player_cant_die();
	
	flag_set( "player_made_it_to_seaknight" );
	stance_carry_icon_disable();
	
	// player flies off into the sunset
	level.player disableweapons();
	// this is the model the player will attach to for the pullout sequence
	ePlayerview = spawn_anim_model( "player_carry" );
	ePlayerview hide();

	// put the ePlayerview in the first frame so the tags are in the right place
	seaknight anim_first_frame_solo( ePlayerview, "wounded_seaknight_putdown", "tag_detach" );
	
	ePlayerview linkto( seaknight, "tag_detach" );

	// this smoothly hooks the player up to the animating tag
	ePlayerview lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
// 	level.cobrapilot show();
	
	price_spawner = getent( "price_spawner", "targetname" );
	price_spawner.animname = "price";
// 	price_spawner set_start_pos( "wounded_seaknight_putdown", org.origin, org.angles );
	price_spawner.origin = level.player.origin;
	price_spawner.count = 1;

	level.price = price_spawner stalingradspawn();
	spawn_failed( level.price );
	level.price.animname = "price";
	
	guys_animating = [];
	guys_animating[ guys_animating.size ] = ePlayerview;
	guys_animating[ guys_animating.size ] = level.price;
	
	
	// bad guys cant shoot you after you start to get in
	add_global_spawn_function( "axis", ::no_accuracy );
	ai = getaiarray( "axis" );
	array_thread( ai, ::no_accuracy );
	
	seaknight anim_single( guys_animating, "wounded_seaknight_putdown", "tag_detach" );
	level.price delete();

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	LINK PLAYER TO CURRENT POS TO SEE NUKE
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	level.player enableweapons();
										// < viewpercentag fraction> , <right arc> , <left arc> , <top arc> , <bottom arc> )
	level.player playerlinktodelta( ePlayerview, "tag_player", 1, 20, 45, 5, 25 );
// 	level.player playerlinktodelta( seaknight, "", 1, 20, 45, 5, 25 );
	
}

no_accuracy()
{
	self endon( "death" );
	self.baseaccuracy = 0;
	level waittill( "stop_having_low_accuracy" );
	self.baseaccuracy = 1;
}

seaknight_leaving_warning( hangout_time )
{
	level endon( "player_made_it_to_seaknight" );
	wait( hangout_time - 30 );

	// Alpha Team, we're at bingo fuel! You got thirty seconds!
	thread price_line( "heli_got_thirty_seconds" );
	wait( 30 );
	
	//* Alpha Team, we are too low on fuel. We're outta here.
	thread price_line( "heli_goodbye" );
	
}

update_objective_position_for_fairground( obj )
{
	level endon( "price_moves_to_position" );
	last_not_here = 0;
	
	for ( ;; )
	{
		flag_waitopen( "price_picked_up" );
		objective_position( obj, level.price.origin );
		thread price_complains_until_he_is_picked_up();
		
		flag_wait( "price_picked_up" );
		objective_position( obj, price_fair_defendspot() );
	}
}

price_complains_until_he_is_picked_up()
{
	level endon( "price_picked_up" );
	level endon( "price_moves_to_position" );
	wait( 0.5 );
	price_putdown_hint_trigger = getent( "price_putdown_hint_trigger", "targetname" );
	
	for ( ;; )
	{
		if ( level.price istouching( price_putdown_hint_trigger ) )
		{
			// Pick me up and move me a bit farther to the north.
			price_line( "pick_me_up_and_move_me" );
		}
		else
		{
			// Over there. Put me down on the rise behind the Ferris wheel.
			price_line( "over_there_behind_ferris_wheel" );
		}
		wait( randomfloat( 7, 9 ) );

		if ( level.price istouching( price_putdown_hint_trigger ) )
		{
			// A bit farther to the north, so I can get a clear shot.
			price_line( "a_bit_farther_north" );
		}
		else
		{
			// Get me over to that hill so I have a clear field of view.
			price_line( "over_to_that_hill" );
			
		}
		wait( randomfloat( 6, 12 ) );
	}
}

plant_price()
{
	endpos = physicstrace( level.price.origin + ( 0, 0, 2 ), level.price.origin + ( 0, 0, -100 ), true, level.price );
	level.price teleport( endpos );
}


player_gets_on_barret()
{
	turret2 = getent( "turret2", "targetname" );
	turret2 SetDefaultDropPitch( -30 );
	turret2 RestoreDefaultDropPitch();
	for ( ;; )
	{
		if ( isdefined( turret2 getturretowner() ) )
			break;
		wait( 0.05 );
	}
	
	flag_set( "player_on_barret" );
}

get_ent_with_key_from_array( array, msg, type )
{
	ents = getentarray( msg, type );
	
	for ( i = 0; i < array.size; i++ )
	{
		for ( p = 0; p < ents.size; p++ )
		{
			if ( ents[ p ] == array[ i ] )
				return ents[ p ];
		}
	}
}

go_axis()
{
	self.team = "axis";
}

modify_objective_destination_babystep( obj )
{
	trigger = getent( "objective_depth", "targetname" );
	ent = getent( trigger.target, "targetname" );
	
	obj_start = getent( trigger.script_linkto, "script_linkname" );
	obj_end = getent( obj_start.target, "targetname" );
	
	objective_position( obj, obj_start.origin );
	
	start = ent.origin;
	end = start + vectorScale( trigger.origin - start, 2 );

	dist = distance( start, end );
	for ( ;; )
	{
		trigger waittill( "trigger", other );

		progress = undefined;
		while ( level.player istouching( trigger ) )
		{
			progress = maps\_ambient::get_progress( start, end, dist, level.player.origin );
	
			if ( progress < 0 )
				progress = 0;
			
			if ( progress > 1 )
				progress = 1;
	
			trigger set_obj_progress( obj, progress, obj_start.origin, obj_end.origin );
			if ( progress == 1 )
				break;
			wait( 0.05 );
		}

		// when you leave the trigger set it to whichever point it was closest too		
		progress = 0;

		trigger set_obj_progress( obj, progress, obj_start.origin, obj_end.origin );
	}
	
	trigger delete();
}

set_obj_progress( obj, progress, start, end )
{
	vec = end * progress + start * ( 1 - progress );
	objective_position( obj, vec );
}


rappel_obj_org()
{
	// the rappel sequence is relative to this node
	player_node = getnode( "player_rappel_node", "targetname" );
	return player_node.origin;
}

addobj( obj )
{
	level.objectives[ obj ] = level.objectives.size;
}

getobj( obj )
{
	return level.objectives[ obj ];
}

apartment_price_waits_for_dog_death()
{
	level.price endon( "death" );
	price_dog_death_trigger = getent( "price_dog_death_trigger", "targetname" );
	price_dog_death_trigger waittill( "trigger" );
	if ( !flag( "fence_dog_dies" ) )
	{
		level.price.dontavoidplayer = true;
		level.price set_force_color( "p" );
		flag_wait( "fence_dog_dies" );	
		level.price set_force_color( "y" );
		level.price.dontavoidplayer = false;
	}
}

pool_have_body()
{
	dog_body = getent( "dog_body", "targetname" );
	
	model = spawn( "script_model", ( 0, 0, 0 ) );
	model.origin = dog_body.origin;
	model.angles = dog_body.angles;
	model.animname = "dead_guy";
	model assign_animtree();
	model character\character_sp_spetsnaz_derik::main();

//	dog_body anim_single_solo( model, "pool_death" );
	model setanim( model getanim( "pool_death" ), 1, 0, 1 );
}

heat_helis_transport_guys_in()
{
	flag_wait( "heat_heli_transport" );
	level endon( "heat_enemies_back_off" );
		
	for ( ;; )
	{
		spawn_vehicle_from_targetname_and_drive( "heat_transport_1" );
		wait( 10 );
		spawn_vehicle_from_targetname_and_drive( "heat_transport_2" );
		wait( 25 );
	}
}

fairground_patrollers()
{
	run_thread_on_noteworthy( "fair_patroller_spawner", ::add_spawn_function, ::fair_patroller_think );
	flag_wait( "pool_heli_attacks" );
	run_thread_on_noteworthy( "fair_patroller_spawner", ::spawn_ai );
}

fair_patroller_think()
{
	self endon( "death" );
	self set_generic_run_anim( "stealth_walk" );
	self.maxsightdistsqrd = 800 * 800;
	self waittill( "enemy" );
	self notify( "stop_going_to_node" );
	self clear_run_anim();
	node = getnode( "fair_sniper_node", "targetname" );
	if ( isalive( self.enemy ) && self.enemy.classname == "actor_enemy_dog" )
	{
		self.pathenemyfightdist = 0;
		self.pathenemylookahead = 0;
		self setgoalnode( node );
		self.goalradius = node.radius;
		self.enemy waittill( "death" );
		self set_default_pathenemy_settings();
		return;
	}
	
	self setgoalnode( node );
	self.goalradius = node.radius;
}

seaknight_sound()
{
	fly = "sniperescape_seaknight_fly";
	idle = "sniperescape_seaknight_idle";

	flyblend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	flyblend thread manual_linkto( self, ( 0, 0, 0 ) );

	idleblend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	idleblend thread manual_linkto( self, ( 0, 0, 64 ) );

	flyblend thread mix_up( fly );
	flag_wait( "seaknight_lands" );

	flyblend thread mix_down( fly );
	idleblend thread mix_up( idle );

	flag_wait( "seaknight_leaves" );
	flyblend thread mix_up( fly );
	idleblend thread mix_down( idle );
}

bus_grenade_think()
{
	targs = getstructarray( self.target, "targetname" );
	for ( ;; )
	{
		self waittill( "trigger" );
		wait( 4 );
		
		if ( !flag( "kill_heli_attacks" ) )
			continue;
			
		for ( ;; )
		{
			if ( !self istouching( level.player ) )
				break;
				
			new_targs = get_array_of_closest( level.player.origin, targs );
			new_targs = remove_can_sighttrace( level.player.origin, new_targs );
			if ( !new_targs.size )
			{
				wait( 0.5 );
				continue;
			}
			
			rand_spots = [];
			for ( i = 0; i < 3; i++ )
			{
				if ( i > new_targs.size )
					break;
				rand_spots[ rand_spots.size ] = new_targs[ i ];
			}
			
			spot = random( rand_spots );
			spot spot_launches_grenade();
			wait( randomfloat( 1.0, 2.0 ) );
		}
	}	
}

spot_launches_grenade()
{
	targ = getstruct( self.target, "targetname" );
	ai = getaiarray( "axis" );
	if ( !ai.size )
		return;
		
	ai[ 0 ].grenadeweapon = "fraggrenade";
	ai[ 0 ] MagicGrenade( self.origin, targ.origin, randomfloat( 4, 7 ) );
}

remove_can_sighttrace( org, array )
{
	new_array = [];
	for ( i = 0; i < array.size; i++ )
	{
		if ( !sighttracepassed( org, array[ i ].origin, true, undefined ) )
		{
			new_array[ new_array.size ] = array[ i ];
		}
	}
	return new_array;
}

fair_grenade_trigger_think()
{
	targs = getstructarray( self.target, "targetname" );
	
	// amount of time you can hide without getting grenades magic - chucked at you
	safety_times = [];
	safety_times[ 0 ] = 25;
	safety_times[ 1 ] = 20;
	safety_times[ 2 ] = 15;
	safety_times[ 3 ] = 15;
	safety_elapsed = 0;
	
	for ( ;; )
	{
		if ( !self istouching( level.player ) ) 
	
		self waittill( "trigger" );

		ai = getaiarray( "axis" );
		if ( !ai.size )
		{
			wait( 1 );
			continue;
		}
		
		guy = getclosest( level.player.origin, ai );
		if ( distance( guy.origin, level.player.origin ) > 1500 )
		{
			wait( 1 );
			continue;
		}

		if ( safety_elapsed < safety_times[ level.gameskill ] )
		{
			safety_elapsed++ ;
			wait( 1 );
			continue;
		}

		spot = random( targs );
		spot spot_launches_grenade();
		wait( randomfloat( 5.0, 7.0 ) );
	}
}

heli_shoots_targetnamed_rocket( targetname )
{
	ent = getent( targetname, "targetname" );
	bullet = spawn( "script_model", ( 0, 0, 0 ) );
	bullet setmodel( "tag_origin" );
	bullet playsound( "weap_lau61c_fire" );
	bullet.origin = ent.origin;

	playfx( getfx( "heli_missile_launch" ), bullet.origin );
	
	
	playfxontag( getfx( "rocket_geo" ), bullet, "tag_origin" );
	
	units_per_second = 2000;

	for ( ;; )
	{
		targ = getent( ent.target, "targetname" );
		dist = distance( ent.origin, targ.origin );
		time = dist / units_per_second;

		bullet moveto( targ.origin, time, 0, 0 );
		ent = targ;
		wait( time );
		if ( !isdefined( ent.target ) )
			break;
	}

	playfx( getfx( "wall_explosion" ), bullet.origin, bullet.origin + ( 1000, -1210, 0 ) );
	thread play_sound_in_space( "scn_se_rocket_explode_building", bullet.origin );
	bullet delete();
}

linktoblade( blade )
{
	self linkto( blade, self.tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	self.root = blade;
}


spawn_blade( name )
{
	blade1 = spawn_anim_model( "blade1" );
	blade2 = spawn_anim_model( "blade2" );
	blade3 = spawn_anim_model( "blade3" );
	blade4 = spawn_anim_model( "blade4" );
	blade5 = spawn_anim_model( "blade5" );
	
	blade2.tag = "tag_blade1";
	blade3.tag = "tag_blade2";
	blade4.tag = "tag_blade3";
	blade5.tag = "tag_blade4";
	
	blades = [];
	blades[ blades.size ] = blade2;
	blades[ blades.size ] = blade3;
	blades[ blades.size ] = blade4;
	blades[ blades.size ] = blade5;
	blade1.blades = blades;
	
	/* 
	blade1 thread maps\_debug::drawtagforever( "tag_blade1", ( 0, 1, 0 ) );
	blade1 thread maps\_debug::drawtagforever( "tag_blade2", ( 0, 1, 1 ) );
	blade1 thread maps\_debug::drawtagforever( "tag_blade3", ( 1, 1, 0 ) );
	blade1 thread maps\_debug::drawtagforever( "tag_blade4", ( 1, 0, 1 ) );
	*/ 

	array_thread( blades, ::linktoblade, blade1 );

	blades[ blades.size ] = blade1;
	array_thread( blades, ::get_blade_clip );

	blade1.animname = name;// override the name so that each runs a different anim
	return blade1;
}

get_blade_clip()
{
	clips = getentarray( "clip_" + self.animname, "targetname" );
	clip = clips[ 0 ];
	clip.targetname = "used";// so the others dont grab it when they do getentarray
	clip.origin = self.origin;
	clip.angles = self.angles;
	clip linkto( self );
	clip thread kill_toucher_until_msg( "blades_stop_killing" );
	flag_wait( "heli_comes_to_rest" );
	clip delete();
}

kill_toucher_until_msg( msg )
{
	level endon( msg );
	kill_player_on_touch( self );
}

kill_player_on_touch( clip )
{
	level.player endon( "death" );
	clip endon( "death" );
	for ( ;; )
	{
		if ( clip istouching( level.player )  )
		{
			level.player enableHealthShield( false );
			level.player die();
			level.player die();
			level.player die();
			level.player die();
		}
		wait( 0.05 );
	}
}

spawn_blades()
{
	blades = [];
	for ( i = 1; i <= 5; i++ )
		blades[ blades.size ] = spawn_blade( "blade" + i );
		
	return blades;
}

remove_blade( blade )
{
	removeblade = blade.blades[ blade.blades.size - 1 ];
	blade.blades[ blade.blades.size - 1 ] = undefined;
// 	removeblade thread drawpos();
	playfx( getfx( "rotor_smash" ), removeblade.origin, removeblade.angles );
	removeblade delete();
}

drawpos()
{
	org = self.root gettagorigin( self.tag );
	ang = self.root gettagangles( self.tag );
	for ( ;; )
	{
		maps\_debug::drawArrow( org, ang );
		wait( 0.05 );
	}
}

rotor_blades( heli )
{
	blades = spawn_blades();
	heli.node thread anim_single( blades, "spin" );
	heli hidepart( "main_rotor_jnt" );
	heli hidepart( "tail_rotor_jnt" );
}

add_dirtmodel( org, ang )
{
	dirtmodel = spawn( "script_model", ( 90, 0, 0 ) );
	dirtmodel setmodel( "tag_origin" );
	dirtmodel hide();
	dirtmodel linkto( self, "tag_body", org, ang );
	// dirtmodel thread maps\_debug::drawtagforever( "tag_origin" );
	return dirtmodel;
}

surprisers_die_soon()
{
	self endon( "death" );
	wait( randomfloatrange( 9, 12 ) );
	self die();
}

drawatag()
{
	for ( ;; )
	{
		tag = getdvar( "heli_tag" );
		if ( tag != "" )
		{
			self maps\_debug::drawTag( tag );
		}
		wait( 0.05 );
	}
}

final_heli_clip()
{
	// special clip for the heli's final pose
	self notsolid();
	flag_wait( "heli_comes_to_rest" );
	level.price_heli.clip delete();
	self solid();
	
	if ( !level.player istouching( self ) )
		return;
		
	for ( ;; )
	{
		level.player enableHealthShield( false );
		level.player die();
		level.player die();
		level.player die();
		level.player die();
		wait( 0.05 );
	}
}

heli_attacks_price_new()
{
	node = getnode( "price_apartment_destination_node", "targetname" );

	heli = spawn_vehicle_from_targetname_and_drive( "heli_price" );
	level.heli_turret = heli.mgturret;
	oldheli = heli;
	heli = heli vehicle_to_dummy();
//	heli thread drawatag();	
// 	heli thread maps\_debug::drawtagforever( "origin_animate_jnt", ( 1, 1, 1 ) );

	clip = getent( "death_heli_clip", "targetname" );
	clip linkto( heli, "origin_animate_jnt", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	clip hide();
	heli thread kill_toucher_until_stop( clip );
	heli.clip = clip;

	sparkmodel = spawn( "script_model", ( 0, 0, 0 ) );
	sparkmodel setmodel( "tag_origin" );
	sparkmodel hide();
	sparkmodel linkto( heli, "tail_rotor_jnt", ( 0, 0, 0 ), ( 0, 90, 0 ) );

	dirtmodels = [];
	passes = 1;
	max = 230;
	frac = max / passes;
	for ( i = 0; i < passes; i++ )
	{
		dirtmodels[ dirtmodels.size ] = heli add_dirtmodel( ( -20 + frac * i, 0, -70 ), ( 0, 90, 0 ) );
	}
	
	level.price_heli = heli;

	heli.animname = "mi28";
	
// 	heli thread helipath( heli.target, 70, 70 );
	wait( 1 );
	
	level.price endon( "death" );
	// More behind us!	
// 	level.price thread anim_single_queue( level.price, "more_behind" );

	node = getnode( "price_wounding_node", "targetname" );
	heli.node = node;
	
	heli_crashers = [];
	heli_crashers[ heli_crashers.size ] = heli;
	heli_crashers[ heli_crashers.size ] = level.price;
	thread price_death_failure();


	/* 
	flag_init( "mi28_in_position" );
	node add_wait( ::waittill_msg, "entrance" );
	node add_func( ::flag_set, "mi28_in_position" );
	node thread do_wait();
	*/ 

// 	level.price add_wait( ::waittill_msg, "goal" );
// 	node add_func( ::anim_loop_solo, level.price, "precrash_idle" );
// 	node thread do_wait();

	add_wait( ::wait_for_surprise_guys );
	add_wait( ::_wait, 20 );
	do_wait_any();

	// Incoming helicopter! Snipe the bastard!		
	delaythread( 3, ::price_line, "incoming_helicopter" );
	array_thread( level.deathflags[ "surprise_guys_dead" ][ "ai" ], ::surprisers_die_soon );
	array_thread( level.deathflags[ "patrol_guys_dead" ][ "ai" ], ::surprisers_die_soon );

	node anim_single_solo( heli, "entrance" );
	
	node thread anim_loop_solo( heli, "idle", undefined, "heli_loop" );
	
	node anim_reach_solo( level.price, "crash" );
	
	flag_wait_or_timeout( "surprise_guys_dead", 20 );

	node thread anim_loop_solo( level.price, "precrash_idle", undefined, "price_loop" );
	wait( 1 );
	node notify( "price_loop" );
	node thread anim_loop_solo( level.price, "fire_idle" );
	
	thread heli_shot_down_detection();
	level notify( "start_continues" );
	heli thread heli_fires_around_price();
	heli thread heli_kills_price();
	price_snipes_heli_until_player_does();
	
	if ( !isalive( level.price ) )
		return;
		
// 	wait( 4 );
	wait( 1 );
	node notify( "stop_loop" );
	node notify( "heli_loop" );
	
	
	heli thread enginefirefx();
	playfxontag( getfx( "aerial_explosion_heli" ), heli, "tag_engine_rear_left" );
	heli playsound( "scn_se_rocket_explode_building" );
	
	level.timer = gettime();
	target = getent( "crash_missile_org", "targetname" );
	heli delaythread( 5.600, ::heli_hits_wall );
	heli delaythread( 5.650, ::heli_shoots_targetnamed_rocket, "rocket_1_org" );
	heli delaythread( 5.750, ::heli_shoots_targetnamed_rocket, "rocket_2_org" );
	heli delaythread( 5.850, ::heli_shoots_targetnamed_rocket, "rocket_3_org" );

	heli delaythread( 9.65, ::heli_hits_ground, oldheli );
	heli delaythread( 9.65, ::enginesmolderfx );
	
	heli delaythread( 9.70, ::heli_shoots_dirt, dirtmodels );

	heli delaythread( 9.70, ::heli_rumbles );
	heli delaythread( 9.75, ::crash_dust_fx );

	heli delaythread( 15.00, ::heli_stops_rumbles );
	heli delaythread( 16.0, ::heli_rumbles_at_rest );

	heli delaythread( 10.00, ::send_notify, "stop_tail_fx" );

	sparkmodel delaythread( 10.00, ::heli_makes_sparks, heli );
	
	sparkmodel delaythread( 12.05, ::send_notify, "stop" );

	oldheli delaythread( 11.00, ::send_notify, "stop_kicking_up_dust" );

	heli delaythread( 13, ::exploder, 456 );
	heli delaythread( 14, ::exploder, 457 );
	heli delaythread( 14.5, ::send_notify, "kill_dirt" );
	heli delaythread( 15, ::send_notify, "stop_crash_dust_fx" );
	
	delaythread( 10.40, ::flag_set, "throw_model" + "swing" );
	delaythread( 10.65, ::flag_set, "throw_model" + "slide" );
	delaythread( 11.15, ::flag_set, "throw_model" + "merry_go_round" );
	level delaythread( 18.50, ::send_notify, "blades_stop_killing" );

	// Gooodnight ya bastard...		
	delaythread( 3.5, ::price_line, "goodnight_ya_bastard" );

	// Ahhh...CRAP! - RUUN!		
	delaythread( 9.2, ::price_line, "ahh_crap" );
	
	flag_set( "havoc_hits_ground" );

	delaythread( 15.5, ::flag_set, "heli_comes_to_rest" );

	heli playloopsound( "havoc_helicopter_dying_loop" );

	heli thread dead_heli_pilots();
	oldheli setenginevolume( 0 );
	
	node thread anim_single( heli_crashers, "crash" );
	wait( 18.500 );
	heli notify( "stop" );
	thread wounded_combat();
	/* 
	node anim_reach_solo( level.price, "wounded_begins" );
	
	flag_wait( "price_heli_in_position" );

	node anim_reach_solo( level.price, "wounded_begins" );
	
// 	heli thread kills_enemies_then_wounds_price_then_leaves();
	delaythread( 5.5, ::flag_set, "price_heli_moves_on" );
	heli delaythread( 6.5, ::heli_shoots_rockets_at_price );
	delaythread( 7.2, ::exploder, 500 );

	// Chopper!!! Get back! I'll cover you!	sniperescape_mcm_choppergetback
	node anim_single_solo( level.price, "wounded_begins" );
	
	thread wounded_combat();
	*/ 
}

heli_rumbles()
{
	self.rumbler = spawn( "script_origin", self.origin );
	self.rumbler linkto( self ,"main_rotor_jnt", (0,0,0),(0,0,0) );
	self.rumbler playrumblelooponentity( "crash_heli_rumble" );
}

heli_rumbles_at_rest()
{
	playrumbleonposition("crash_heli_rumble",self gettagorigin("main_rotor_jnt") ) ;
	wait .25;
	playrumbleonposition("crash_heli_rumble_rest",self gettagorigin("main_rotor_jnt") ) ;
}

heli_stops_rumbles()
{
	self.rumbler stoprumble( "crash_heli_rumble" );
	self.rumbler delete();
}

blocking_fence_falls()
{
	blocking_fence = getent( "blocking_fence", "targetname" );
	clip = getent( blocking_fence.target, "targetname" );
	clip connectpaths();
	clip linkto( blocking_fence );
	blocking_fence rotatepitch( 90, 1, 0.2 );
	wait( 1 );
	clip delete();
}


heli_shoots_dirt( models )
{
	self array_levelthread( models, ::dirt_model_shoots_dirt );
}

dirt_model_shoots_dirt( model )
{
	//Front Dirt
	fx = spawn( "script_model", ( 0, 0, 0 ) );
	fx setmodel( "tag_origin" );
	fx hide();
	
	playfxontag( getfx( "heli_dirt" ), fx, "tag_origin" );
	fx linkto( level.price_heli, "tag_deathfx", ( 0, 0, 0 ), ( 0, 0, 0 ) );

	//Rear Dirt
	fx2 = spawn( "script_model", ( 0, 0, 0 ) );
	fx2 setmodel( "tag_origin" );
	fx2 hide();
	
	playfxontag( getfx( "heli_dirt_rear" ), fx2, "tag_origin" );
	fx2 linkto( level.price_heli, "tag_deathfx", ( -100, 0, 100 ), ( 0, 0, 0 ) );

	self waittill( "kill_dirt" );
	fx delete();
	fx2 delete();
	
	if ( 1 ) return;
	
	for ( ;; )
	{
		forward = anglestoforward( model.angles );
		up = anglestoup( model.angles );
		vec = vectorscale( forward, 500 );
		trace = bullettrace( model.origin, model.origin + vec, true, self );
		org = trace[ "position" ];
// 		org = trace[ "position" ] + ( 8, 8, 16 );
// 		line( self.origin, org, ( 1, 0, 0 ) );
// 		playfx( getfx( "helicopter_tail_sparks" ), org, sparkang );

		if ( !isdefined( level.dirtfx_org ) )
		{
			dmodel = spawn( "script_model", org );
			dmodel setmodel( "tag_origin" );
			dmodel hide();
			
// 			dmodel thread maps\_debug::drawtagforever( "tag_origin", ( 1, 1, 0 ) );
// 			model thread maps\_debug::drawtagforever( "tag_origin", ( 1, 0, 0 ) );
// 			playfxontag( getfx( "heli_dirt" ), org, up );
			playfxontag( getfx( "heli_dirt" ), dmodel, "tag_origin" );
			level.dirtfx_org = dmodel;
// 			dmodel linkto( level.price_heli, "tag_body" );
		}
		
// 		level.dirtfx_org moveto( org, 0.1 );
// 		level.dirtfx_org rotateto( model.angles + ( -90, 0, 0 ), 0.1 );
		level.dirtfx_org.angles = model.angles + ( -90, 0, 0 );
		level.dirtfx_org.origin = org;
// 		level.dirt_fx_org = org;
// 		playfx( getfx( "heli_dirt" ), org, up );
		wait( 0.05 );
	}
}

sparkgen()
{
	self endon( "death" );
	for ( ;; )
	{
		if ( isdefined( self.spark ) )
		{
			playfx( getfx( "helicopter_tail_sparks" ), self.origin );
		}
		wait( 0.05 );		
	}
}

heli_makes_sparks( heli )
{
	self endon( "stop" );
	ent = getent( "spark_org", "targetname" );
	sparkang = anglestoforward( ent.angles );
	count = 0;
	
	for ( ;; )
	{
		forward = anglestoforward( self.angles );
		vec = vectorscale( forward, 500 );
		trace = bullettrace( self.origin, self.origin + vec, true, heli );
		org = trace[ "position" ] + ( 8, 8, 16 );
// 		line( self.origin, org, ( 1, 0, 0 ) );
// 		playfx( getfx( "helicopter_tail_sparks" ), org, sparkang );
		playfx( getfx( "helicopter_tail_sparks" ), org, sparkang );
		count -- ;
		if ( count <= 0 )
		{
			playfx( getfx( "brick_chunk" ), org, sparkang );
			count = randomintrange( 4, 5 );
		}
		wait( 0.05 );
	}
	
	if ( 1 )
		return;
	bullet = spawn( "script_model", ( 0, 0, 0 ) );
	bullet setmodel( "tag_origin" );
	bullet.origin = ent.origin;
	bullet.angles = ent.angles;
	playfxontag( getfx( "rocket_geo" ), bullet, "tag_origin" );
	
	model = spawn( "script_model", ( 0, 0, 0 ) );
// 	model setmodel( "temp" );
	model linkto( bullet, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	units_per_second = 1200;
	original_units_per_second = units_per_second;
	bullet.spark = true;

	bullet thread sparkgen();
	for ( ;; )
	{
		if ( isdefined( ent.speed ) )
		{
			units_per_second = original_units_per_second * ent.speed * 0.01;
			println( "speed went from " + original_units_per_second + " to " + units_per_second );
		}
		
		playfx( getfx( "brick_chunk" ), bullet.origin );
		targ = getent( ent.target, "targetname" );
		dist = distance( ent.origin, targ.origin );
		time = dist / units_per_second;

		bullet moveto( targ.origin, time, 0, 0 );
		ent = targ;
		wait( time );
		if ( !isdefined( ent.target ) )
			break;
	}

	bullet delete();
	
}

heli_hits_wall()
{
	thread exploder( 66 );
	self stoploopsound();

	self playsound( "scn_se_havoc_downed" );
	delaythread( 0.1, ::_Earthquake, 0.4, 1.2, self.origin, 6000 );
	self thread tailfx();
// 	self notify( "stop_tail_fx" );
}

heli_hits_ground( oldheli )
{
	thread exploder( 67 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
	delaythread( 0.1, ::_Earthquake, 0.6, 1.2, self.origin, 6000 );
// 	self thread tailfx();
	oldheli thread lights_off( "running" );
	self notify( "stop_enginefire_fx" );
	wait( 0.8 );
	level.player PlayRumbleLoopOnEntity( "tank_rumble" );

	timer = 6;
	Earthquake( 0.3, timer, self.origin, 2000 );
	level.player StopRumble( "tank_rumble" );

	wait( timer );
	Earthquake( 0.1, 1, self.origin, 2000 );

}

tailfx()
{
	self endon( "stop_tail_fx" );
	tags = [];
// 	tags[ tags.size ] = "tag_gunner";
	tags[ tags.size ] = "tail_rotor_jnt";
	// tags[ tags.size ] = "tag_engine_rear_left";
// 	tags[ tags.size ] = "tag_engine_rear_right";
	
	tagsKeys = getarraykeys( tags );
	fx = undefined;
	
	for ( ;; )
	{
		for ( i = 0; i < tagsKeys.size; i++ )
		{
			org = self GetTagOrigin( tags[ tagsKeys[ i ] ] );
			playfx( getfx( "smoke_trail_heli" ), org );
// 			fx = spawnFx( getfx( "smoke_trail_heli" ), org ); 
// 			delayThread( ::deleteEnt, 30, fx );
// 			triggerFx( fx, 0 );
			
// 			playfxontag( getfx( "smoke_trail_heli" ), self, tags[ tagsKeys[ i ] ] );
// 			playfxontag( getfx( "fire_trail_heli" ), self, tags[ tagsKeys[ i ] ] );
		}

		wait( 0.1 );
	}
}

enginefirefx()
{
	self endon( "stop_enginefire_fx" );
	tags = [];
	tags[ tags.size ] = "tag_engine_rear_left";
	
	tagsKeys = getarraykeys( tags );
	fx = undefined;
	
	for ( ;; )
	{
		for ( i = 0; i < tagsKeys.size; i++ )
		{
			org = self GetTagOrigin( tags[ tagsKeys[ i ] ] );
			playfx( getfx( "fire_trail_heli" ), org );
		}

		wait( 0.1 );
	}
}

enginesmolderfx()
{
	self endon( "stop_enginesmoke_fx" );
	tags = [];
	tags[ tags.size ] = "tag_engine_rear_left";
	
	tagsKeys = getarraykeys( tags );
	fx = undefined;
	
	for ( ;; )
	{
		for ( i = 0; i < tagsKeys.size; i++ )
		{
			org = self GetTagOrigin( tags[ tagsKeys[ i ] ] );
			playfx( getfx( "heli_engine_smolder" ), org );
		}

		wait( 0.1 );
	}
}

crash_dust_fx()
{
	self endon( "stop_crash_dust_fx" );
	tags = [];
	tags[ tags.size ] = "tag_deathfx";
	
	tagsKeys = getarraykeys( tags );
	fx = undefined;
	
	for ( ;; )
	{
		for ( i = 0; i < tagsKeys.size; i++ )
		{
			org = self GetTagOrigin( tags[ tagsKeys[ i ] ] );
			playfx( getfx( "heli_crash_dust" ), org );
		}

		wait( 0.2 );
	}
}

clip_setup()
{
	clip = getent( self.script_linkto, "script_linkname" );
	clip.origin = self.origin;
	clip.angles = self.angles;
	clip linkto( self );
	clip hide();
	flag_wait( "throw_model" + self.script_noteworthy );
	kill_toucher_until_stop( clip );
}

kill_toucher_until_stop( clip )
{
	self endon( "stop" );
	kill_player_on_touch( clip );
}

script_animator()
{
	flag_init( "throw_model" + self.script_noteworthy );
	if ( isdefined( self.script_linkto ) )
	{
		thread clip_setup();
	}
	ent = self;
	ent = getent( ent.target, "targetname" );

	
	for ( ;; )
	{
		ent.origin = ent.origin + ( 0, 0, -5000 );
		ent hide();
		if ( !isdefined( ent.target ) )
			break;
		ent = getent( ent.target, "targetname" );
	}
	self show();

	flag_wait( "throw_model" + self.script_noteworthy );

	ent = self;
	ent = getent( ent.target, "targetname" );
	for ( ;; )
	{
		ent.origin = ent.origin + ( 0, 0, 5000 );
		if ( !isdefined( ent.target ) )
			break;
		ent = getent( ent.target, "targetname" );
	}
	
	rate = 0.15;
	ent = self;
	for ( ;; )
	{
		if ( !isdefined( ent.target ) )
			break;
		ent = getent( ent.target, "targetname" );
		self moveto( ent.origin, rate, 0, 0 );
		self rotateto( ent.angles, rate, 0, 0 );
		wait( rate );
	}
	
	self notify( "stop" );
}

check_for_price()
{
	ai = level.deathflags[ "fair_snipers_died" ][ "ai" ];
	array_thread( ai, ::set_default_pathenemy_settings );
	
	 /#
	if ( !is_default_start() )
	{
		return;
	}
	#/ 
	
	if ( !isalive( level.price ) )
		return;

	setdvar( "ui_deadquote", &"SNIPERESCAPE_YOU_LEFT_YOUR_SPOTTER" );
	maps\_utility::missionFailedWrapper();
}

grass_obj()
{
	self setmodel( "foliage_drygrass_squareclump" );
	glow = spawn( "script_model", self.origin );
	glow.angles = self.angles;
	glow setmodel( "foliage_drygrass_squareclump_obj" );
	glow hide();
	
	hide_and_show_glowing_grass( glow );
	glow delete();
}

hide_and_show_glowing_grass( glow )
{
	level endon( "price_is_put_down_near_wheel" );
	
	for ( ;; )
	{
		flag_wait( "put_price_near_wheel" );
// 		flag_wait( "price_picked_up" );
		glow show();
		level waittill( "foreverever" );
		flag_waitopen( "price_picked_up" );
		glow hide();
	}
}

player_is_enemy()
{
	ai = getaiarray( "axis" );
	for ( i = 0; i < ai.size; i++ )
	{
		if ( isalive( ai[ i ].enemy ) )
		{
			if ( level.player == ai[ i ].enemy )
				return true;
		}
	}
	return false;
}

price_goes_to_window_to_shoot()
{
	if ( flag( "wounding_enemy_detected" ) )
		return;
		
	level endon( "wounding_enemy_detected" );
	autosave_by_name( "standby" );
	
	level.price disable_ai_color();
	level.price.ignoreall = true;
	// Standby…!	
	level.price clearenemy();
	level.price.ignoreme = true;
	level.price delaythread( 1.2, ::anim_single_queue, level.price, "standby" );
	// price singals to halt
	node = getent( "halt_node", "targetname" );
	node anim_reach_solo( level.price, "halt" );
	node anim_single_solo( level.price, "halt" );
	level.price pushplayer( true );

	level.price.disableexits = true;
	wait( 1 );
	
	claymoreCount = getPlayerClaymores();
	if ( claymoreCount > 0 )
	{
		// Quick, plant a claymore by the door up ahead!		
		thread price_line( "plant_claymore_by_door" );
		wait( 1 );
	}
	
	level.price enable_ai_color();
	activate_trigger_with_targetname( "price_moves_to_window_trigger" );
	flag_wait( "price_at_wounding_window" );
	wait( 0.5 );
	level.price.ignoreme = false;
	level.price.ignoreall = false;
	delete_wounding_sight_blocker();
	flag_wait( "wounding_enemy_detected" );
}

price_snipes_heli_until_player_does()
{
	level endon( "heli_shot_down" );
	flag_assert( "heli_shot_down" );	
	level.price endon( "death" );

	for ( ;; )
	{
		// Price, shoot the helicopter! We'll take it down together!		
		price_line( "shoot_the_helicopter" );
		level.price_heli add_wait( ::waittill_player_lookat, 0.995, 1.0, true );
		timer = randomfloatrange( 8, 12 );
		add_wait( ::_wait, timer );
		do_wait_any();

		if ( player_looking_at( level.price_heli.origin, 0.995 ) )
			break;
	}
	
	// Take out that helicopter! Hit the rotor!		
	price_line( "hit_the_rotor" );
	
	wait( 2.0 );
	// Fire! Fire!		
	price_line( "fire_fire" );
	
	flag_wait( "heli_shot_down" );	
}

heli_fires_around_price()
{
	
// 	level endon( "heli_kills_price" );
	flag_assert( "heli_shot_down" );	

	targets = getentarray( "death_heli_target", "targetname" );
	target = random( targets );
	oldtarget = target;
	for ( ;; )
	{
		while ( oldtarget == target )
			target = random( targets );
		
		oldtarget = target;
		wait( randomfloat( 0.35, 0.75 ) );
		heli_fires( target );
		if ( flag( "heli_shot_down" ) )
			return;
	}
}

heli_fires( org )
{
	model = spawn( "script_origin", ( 0, 0, 0 ) );
	model.origin = self.origin;
	model playloopsound( "tank_mg_cal30_loop" );
	timer = randomfloat( 1, 2 ) * 10;
	fx = spawn( "script_model", ( 0, 0, 0 ) );
	fx setmodel( "tag_origin" );

	for ( i = 0; i < timer; i++ )
	{
		target = org.origin + randomvector( 16 );
		origin = self gettagorigin( "tag_flash" );
		fx.origin = origin;
		
		angles = vectortoangles( target - origin );
		fx.angles = angles;
		
		playfxontag( getfx( "hind_fire" ), fx, "tag_origin" );
		MagicBullet( "barrett_fake", self gettagorigin( "tag_flash" ), target );
		wait( 0.10 );
	}
	
	fx delete();
	model stoploopsound();
	model delete();
}

heli_kills_price()
{
	level endon( "heli_shot_down" );
	flag_assert( "heli_shot_down" );	
	level.price endon( "death" );

	wait( 25 );
	level notify( "heli_kills_price" );	
	level.price.allowdeath = true;
	if ( isdefined( level.price.magic_bullet_shield ) )
		level.price stop_magic_bullet_shield();

	level.price.health = 150;
	for ( ;; )
	{
		timer = randomfloat( 1, 2 ) * 10;
		for ( i = 0; i < timer; i++ )
		{
// 			playfxontag( getfx( "hind_fire" ), level.price_heli, "tag_flash" );
			MagicBullet( "barrett_fake", level.price_heli gettagorigin( "tag_flash" ), level.price geteye() );
			wait( 0.10 );
		}
		wait( randomfloat( 0.3, 0.7 ) );
	}
}

price_death_failure()
{
	level endon( "heli_comes_to_rest" );
	flag_assert( "heli_comes_to_rest" );
	
	level.price waittill( "death" );
	wait( 4 );
	setdvar( "ui_deadquote", &"SNIPERESCAPE_CPT_MACMILLAN_DIED" );
	maps\_utility::missionFailedWrapper();
}

price_sets_stance()
{
	level.price waittill( "goal" );
	level.price allowedstances( "crouch" );
}

player_becomes_invul_on_pickup()
{
	level endon( "player_made_it_to_seaknight" );
	time = getdvar( "player_deathinvulnerabletime" );
	for ( ;; )
	{
		flag_wait( "price_picked_up" );
		setsaveddvar( "player_deathinvulnerabletime", "10000" );
		flag_waitopen( "price_picked_up" );
		setsaveddvar( "player_deathinvulnerabletime", time );
	}
}

heli_shot_down_detection()
{
	level endon( "heli_shot_down" );
	count = 0;
	for ( ;; )
	{
		if ( player_looking_at( level.price_heli.origin, 0.995 ) )
			count++ ;
		
		if ( count > 35 )
			break;
		wait( 0.05 );
	}
	
	flag_set( "heli_shot_down" );
}

helicopter_broadcast( msg )
{
	flag_wait( msg );
	name = level.heli_flag[ msg ];
	play_sound_in_space( level.scr_sound[ "heli" ][ name ], level.player.origin + ( 0, 0, 800 ) );
}

dead_heli_pilots()
{
	model = spawn( "script_model", ( 0, 0, 0 ) );
	model linkto( self, "tag_gunner", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	model.animname = "dead_heli_pilot";
	model character\character_sp_spetsnaz_collins::main();
	model assign_animtree();
	model setanim( getanim_generic( "dead_gunner" ) );
	
	model = spawn( "script_model", ( 0, 0, 0 ) );
	model linkto( self, "tag_pilot", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	model.animname = "dead_heli_pilot";
	model character\character_sp_spetsnaz_geoff::main();
	model assign_animtree();
	model setanim( getanim_generic( "dead_pilot" ) );

// 	model = spawn( "script_model", ( 0, 0, 0 ) );
// 	model setmodel( level.scr_model[ "tag_pilot" ] );
// 	model linkto( self, "tag_window_back", ( 0, 0, 0 ), ( 0, 0, 0 ) );
}

set_dog_threatbias_group()
{
	self endon( "death" );
	waittillframeend;
	if ( self.team == "allies" )
		self setthreatbiasgroup( "dog_allies" );	
}

merry_go_round_bottom()
{
	merry = getent( "merry_go_round", "script_linkname" );
	self linkto( merry );
}

merry_grass_delete()
{
	flag_wait( "throw_model" + "merry_go_round" );
	wait( 1.5 );
	self delete();
}

wait_for_surprise_guys()
{
	for ( ;; )
	{
		if ( level.deathflags[ "surprise_guys_dead" ][ "spawners" ].size > 0 )
		{
			wait( 0.05 );
			continue;
		}
		
		if ( level.deathflags[ "surprise_guys_dead" ][ "ai" ].size <= 2 )
			break;
			
		wait( 0.05 );
	}
}

player_cant_die()
{
	arcadeMode_stop_timer();
	level.player endon( "death" );
	for ( ;; )
	{
		setsaveddvar( "player_deathinvulnerabletime", "70000" );
		level.player EnableInvulnerability();
		level.player.attackeraccuracy = 0;
		wait( 0.05 );
	}
}