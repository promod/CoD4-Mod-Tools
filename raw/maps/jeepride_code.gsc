#include common_scripts\utility;
#include maps\_utility;
#include maps\_utility_code;
#include maps\_vehicle;
#include maps\_vehicle_aianim;

//#include maps\jeepride;
#include maps\_anim;

#using_animtree( "generic_human" );   

orientmodehack_axis( guy )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	guy endon( "death" );
	// set the orient mode to face the player every frame. lets  see what this does
	self endon( "unload" );
	
	while ( 1 )
	{
		guy orientmode( "face angle", vectortoangles( level.player.origin - guy.origin )[ 1 ] );
		wait .05;
	}
}

player_fudge_move_rotate_to( dest, destang, moverate, org )
{
	// moverate = units / persecond
	if ( !isdefined( moverate ) )
		moverate = 1;
	org unlink();
	dist = distance( level.player.origin, dest );
	movetime = dist / moverate;
	
	accel = movetime * .05;
	decel = movetime * .05;
	org moveto( dest, movetime, accel, decel );
	org rotateto( destang, movetime, accel, decel );
	wait movetime;
	level.player unlink();
}

attacknow()
{
	self waittill( "trigger", eVehicle );
	eVehicle.attacknow = true;
	eVehicle notify( "attacknow" );
}

player_link_update( influence )
{
	if ( !isdefined( influence ) )
		influence = level.playerlinkinfluence;
	level.player playerlinkto( level.playerlinkmodel, "polySurface1", influence );
}


player_link_update_delta( influence )
{
	if ( !isdefined( influence ) )
		influence = level.playerlinkinfluence;
	level.player playerlinktodelta( level.playerlinkmodel, "polySurface1", influence );
}

fake_position( model, pos )
{
// 	if ( !isdefined( self.riders ) )
// 		return;
	model hide();
	
	if ( pos == 999 )
	{
		level.player unlink();
		level.playerlinkmodel = model;
		return;
	}

	if ( pos == 888 )
	{
		self.rpgguyspot = model;
		return;
	}
	
	if ( pos == 336 )
	{
		model setcandamage( true );
		model show();
		return;
	}
	if ( pos == 339 )
	{
		self hide();
		model show();
		return;
	}
	
	if ( pos == 237 )
		return put_stinger_guy_here( model );
	
	if ( pos == 532 )
	{
		model thread rpg_spot( self );
		return;
	}
	
	if ( pos == 533 )
	{
		model hide();
		self.rpgguyspotsecondary = model;
		return;
	}
	
	rider = undefined;
	for ( i = 0 ; i < self.riders.size ; i++ )
		if ( self.riders[ i ].pos == pos )
			rider = self.riders[ i ];
			
	if ( !isdefined( rider ) )
		return;
	rider unlink();
	tag = "polySurface1";
	rider linkto( model, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );	
	wait 1;
	if ( !isai( rider ) )
	{
		guy_force_remove_from_vehicle( self, rider );
		rider thread rider_droneai( model, tag, self );
	}
	else
	{
		guy_force_remove_from_vehicle( self, rider );
		self thread whackamole( rider );
	}
}

put_stinger_guy_here( model )
{
	guy = undefined;
 	for ( i = 0; i < self.riders.size; i++ )
 	{
 		if ( issubstr( self.riders[ i ].classname, "stinger" ) )
 		{
 			guy = self.riders[ i ];
 			break;
 		}
 	}
 	if ( !isdefined( guy ) )
 		return;
 	waittillframeend;// lets _vehicle_aianim link the guy first
 	guy unlink();
 	guy linkto( model, "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
 	
}

in_GetWeaponsList( weaponname )
{
	weaponlist = level.player GetWeaponsList();
	for ( i = 0; i < weaponlist.size; i++ )
		if ( weaponname == weaponlist[ i ] )
			return true;
	
	return false;
}

rpg_spot( vehicle )
{
	self hide();
	level waittill( "newrpg" );
	matchedweapon = false;
	weaponname = "rpg";
	weapon = spawn( "weapon_" + weaponname, self.origin, 1 );// 1 = suspended
	weapon.angles = self.angles;
	weapon linkto( self );
	self.jeepride_linked_weapon = self;// so I can delete it later
	list = [];
	while ( !in_GetWeaponsList( weaponname )  )
	{
// 		list = level.player GetWeaponsList();
		wait .05;// while the player doesn't have the weapon that's on the box in his inventory
	}
// 	weapon = undefined;
// 	for ( i = 0; i < list.size; i++ )
// 	{
// 		weapon = getent( "weapon_" + list[ i ], "classname" );
// 		if ( isdefined( weapon ) )
// 			break;
// 	}
// 	assert( isdefined( weapon ) );
// 	weapon unlink();
// 	weapon.origin = vehicle.rpgguyspotsecondary.origin;
// 	weapon.angles = vehicle.rpgguyspotsecondary.angles;
// 	weapon linkto( self );
// 	
	level.player givemaxammo( weaponname );
	flag_set( "rpg_taken" );
	ammo = level.player GetWeaponAmmoStock( "rpg" );
	if( getdvar("player_sustainAmmo") == "0" )
		while ( level.player GetWeaponAmmoStock( "rpg" ) == ammo && ammo )
			wait .05;
	flag_set( "rpg_shot" );
	firstrun = false;
}

local_drone_animontag( guy, tag, animation, bIspose, vehicle_to_break )
{
	if ( isdefined( vehicle_to_break ) )
		vehicle_to_break endon( "attacknow" );
	if ( !isdefined( bIspose ) )
		bIspose = false;
	org = self gettagOrigin( tag );
	angles = self gettagAngles( tag );
	flag = "animontag";
	guy animscripted( flag, org, angles, animation );
	if ( !bIspose )
		guy waittillmatch( flag, "end" );
	else
		wait .05;
	guy notify( "droneanimfinished" );
}

rider_drone_toai( rider, model, tag, animation )
{
	ai = makerealai( rider );
	ai linkto( model, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );

	model thread local_drone_animontag( ai, tag, animation );

	ai.desired_anim_pose = "crouch";	
	ai allowedstances( "crouch" );
	ai thread animscripts\utility::UpdateAnimPose();
	ai allowedstances( "stand", "crouch" );

	self thread whackamole( ai );
}

rider_droneai( model, tag, vehicle )
{            
	
// 	simple stuff.  have them randomly play a bunch of random animations untill a point designated to convert the whole group into whackamole guys
	if ( !( isdefined( self.script_noteworthy ) && self.script_noteworthy == "whackamole_guy" ) )
		return;

	self endon( "death" );
	script_stance = "coverstand";
	
	animarray = [];
	animgroup = "coverstand";
	animarray[ animgroup ] = [];
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch01;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch02;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch03;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch04;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle_twitch05;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_look_quick;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_look_quick;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_look_quick;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %coverstand_hide_idle;

	animgroup = "crouch";
	animarray[ animgroup ] = [];
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %crouch_aim_straight;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %exposed_crouch_reload;
	animarray[ animgroup ][ animarray[ animgroup ].size ] = %exposed_crouch_reload;

	animuparray = [];
	animgroup = "coverstand_up";
	animuparray[ animgroup ] = [];
	animuparray[ animgroup ][ animuparray[ animgroup ].size ] = %coverstand_hide_2_aim;

	animgroup = "crouch_up";
	animuparray[ animgroup ] = [];
	animuparray[ animgroup ][ animuparray[ animgroup ].size ] = %crouch2stand;
	
	animdownarray = [];
	animgroup = "crouch_down";
	animdownarray[ animgroup ] = [];
	animdownarray[ animgroup ][ animdownarray[ animgroup ].size ] = %stand2crouch_attack;

	animgroup = "crouch_down";
	animdownarray[ animgroup ] = [];
	animdownarray[ animgroup ][ animdownarray[ animgroup ].size ] = %stand2crouch_attack;
	
	vehicle endon( "death" );
	vehicle.attacknow = false;// set by trigger.
	
	index = 0;

// 	delaythread( .05, ::guy_force_remove_from_vehicle, vehicle, self );
	
	while ( ! vehicle.attacknow )
	{
		keys = getarraykeys( animarray );
		index = randomint( keys.size );
		animgroup = keys[ index ];
		index = randomint( animarray[ animgroup ].size );
		model local_drone_animontag( self, tag, animarray[ animgroup ][ index ], undefined, vehicle );
	}
	
// 	animgroup = animgroup + "_up";
	// need to find 

	// stand up
// 	model local_drone_animontag( self, tag, animuparray[ animgroup ][ 0 ] );
	vehicle thread rider_drone_toai( self, model, tag, animarray[ animgroup ][ index ] );
}


apply_truckjunk_loc( eVehicle, truckjunk )
{
// 	eVehicle.truckjunk = [];
	for ( i = 0 ; i < truckjunk.size ; i++ )
	{
		model = eVehicle.truckjunk[ i ];
		if ( isdefined( truckjunk[ i ].script_startingposition ) )
			eVehicle thread fake_position( model, truckjunk[ i ].script_startingposition );
		if ( isdefined( truckjunk[ i ].script_noteworthy ) && truckjunk[ i ].script_noteworthy == "loosejunk" )
			model thread loosejunk( eVehicle );
	}
}

process_vehicles_spawned()
{
	while ( 1 )
	{
		eVehicle = waittill_vehiclespawn_spawner_id( self.spawner_id );
		
//	eVehicle stopenginesound();

		if ( eVehicle.script_team == "allies" )
			eVehicle thread riders_godon();
		
		eVehicle thread tire_deflate();
		
		eVehicle thread godon();// all vehicles get godmode untill I tell them it's ok to die
		if ( isdefined( level.vehicle_truckjunk[ self.spawner_id ] ) )
			apply_truckjunk_loc( eVehicle, level.vehicle_truckjunk[ self.spawner_id ] );
			
		eVehicle thread kill_stupid_vehicle_threads();
		eVehicle thread freeOnEnd();
		eVehicle thread joltOnend();
		
		if(isdefined(level.passerby_timing[ self.spawner_id ] ))
			eVehicle thread delaythread_loc( level.passerby_timing[ self.spawner_id ], ::play_sound_on_entity_loc, eVehicle honker_get_sound() );
	}	
}

play_sound_on_entity_loc( sound )
{
//	thread draw_arrow_time( self.origin , level.player.origin , (1,1,1) , 5 );
	self play_sound_on_entity( sound );
}

joltOnend()
{
	self waittill( "reached_end_node" );
	self joltbody( ( self.origin + ( 32, 32, 64 ) ), 1.5 );
}


kill_stupid_vehicle_threads()
{
	waittillframeend;
	maps\_vehicle::vehicle_kill_badplace_forever();
	maps\_vehicle::vehicle_kill_rumble_forever();
// 	maps\_vehicle::vehicle_kill_treads_forever();
	maps\_vehicle::vehicle_kill_disconnect_paths_forever();
}

player_death()
{
	level.player waittill( "death" );
	array_thread( getentarray( "script_vehicle", "classname" ), ::deadplayer_stop );
}

deadplayer_stop()
{
	if ( ishelicopter() )
		return;
	self setspeed( 0, 25 );
}

spawners_setup()
{
	self waittill( "spawned", other );
	waittillframeend;
	if ( ! isdefined( other ) )
		return;// deleted to make room for new ai.

	remember_weaponsondeath( other );
	other add_death_function( ::remember_weaponsondeath );
	if ( level.flag[ "bridge_zakhaev_setup" ] )
	{
		other.a.disableLongDeath = true;
		other.dropweapon = false;
	}
		
	if ( level.flag[ "end_ride" ] )
		return;
	if ( isdefined( other.a.rockets ) && other.a.rockets && other.weapon == "stinger_speedy" )
	{
		other thread rocket_handle();
	}

	other.a.disableLongDeath = true;
	other endon( "death" );
	other.dropweapon = false;
// 	other waittill( "jumpedout" );
// 	wait 4;
// 	other delete();
}

sethindtarget( eVehicle )
{
	
	if( isdefined( eVehicle ) )
		self.hindenemy = eVehicle;
	else
		eVehicle = self.hindenemy;

	attractorent = spawn( "script_origin", eVehicle gettagorigin( "tag_light_belly" ) );
	attractorent.origin = eVehicle gettagorigin( "tag_light_belly" )+(0,0,-24);
	attractorent linkto( eVehicle );
	
	attractorent thread attractorent_delete_on_vehicle_death( eVehicle );
	
//	self thread orientmodehack_axis_2( attractorent );
//	self orientmode( "face angle", vectortoangles( eVehicle.origin - self.origin )[ 1 ] );
//	eVehicle.flaretargetents = array_add( eVehicle.flaretargetents, attractorent );
// 	thread	draw_line_from_ent_to_ent_until_notify( self, attractorent, 1, 1, 1, self, "never" );
 
	self clearentitytarget();
	self setentitytarget( attractorent );
	
	self.shootEnt = attractorent;
	self.shootPos = self.shootEnt getShootAtPos();
	self.attractorent = attractorent;
	self.shootStyle = "single";
	
	self.hindenemy = eVehicle;
}

attractorent_delete_on_vehicle_death( eVehicle )
{
	self endon ("death");
	evehicle waittill ("death");
	self delete();
}

set_animarray_standing()
{
	self.a.array = [];


	self.a.array["add_aim_up"] = %RPG_stand_aim_8;
	self.a.array["add_aim_down"] = %RPG_stand_aim_2;
	self.a.array["add_aim_left"] = %RPG_stand_aim_4;
	self.a.array["add_aim_right"] = %RPG_stand_aim_6;  

	self.a.array["fire"] = %RPG_stand_fire;
	self.a.array["straight_level"] = %RPG_stand_aim_5;
	self.a.array["reload"] = animscripts\utility::array( %RPG_stand_reload );
	self.a.array["reload_crouchhide"] = animscripts\utility::array();

	self.a.array["exposed_idle"] = animscripts\utility::array( %RPG_stand_idle );
	
	self.a.array["single"] = animscripts\utility::array( %exposed_shoot_semi1 );
	
	self.a.array["crouch_2_stand"] = %exposed_crouch_2_stand;
	self.a.array["crouch_2_prone"] = %crouch_2_prone;
	self.a.array["stand_2_crouch"] = %exposed_stand_2_crouch;
	self.a.array["stand_2_prone"] = %stand_2_prone;
	self.a.array["prone_2_crouch"] = %prone_2_crouch;
	self.a.array["prone_2_stand"] = %prone_2_stand;

	self.a.array["turn_left_45"] = %exposed_tracking_turn45L;
	self.a.array["turn_left_90"] = %exposed_tracking_turn90L;
	self.a.array["turn_left_135"] = %exposed_tracking_turn135L;
	self.a.array["turn_left_180"] = %exposed_tracking_turn180L;
	self.a.array["turn_right_45"] = %exposed_tracking_turn45R;
	self.a.array["turn_right_90"] = %exposed_tracking_turn90R;
	self.a.array["turn_right_135"] = %exposed_tracking_turn135R;
	self.a.array["turn_right_180"] = %exposed_tracking_turn180L;		

	self.a.array["add_turn_aim_up"] = %exposed_turn_aim_8;
	self.a.array["add_turn_aim_down"] = %exposed_turn_aim_2;
	self.a.array["add_turn_aim_left"] = %exposed_turn_aim_4;
	self.a.array["add_turn_aim_right"] = %exposed_turn_aim_6;
	self.turnThreshold = 35;
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;

	self.turnleft180limit =  -130;
	self.turnright180limit = 130;
	self.turnleft90limit = -70;
	self.turnright90limit = 70;
}

rpg_guy_animcustom_setup()
{
	self set_animarray_standing();
	self.isturning = false;
	self.a.movement = "stop";
	self.previousPitchDelta = 0.0;
	
	self clearAnim( %root, .2 );
	self setAnim( animscripts\utility::animarray("straight_level") );
	self setAnim( %add_idle );
	self clearanim( %aim_4, .2 );
	self clearanim( %aim_6, .2 );
	self clearanim( %aim_2, .2 );
	self clearanim( %aim_8, .2 );
	
	animscripts\combat::setupAim( .2 );
	
	thread idleThread();

	self.a.meleeState = "aim";
	self.twitchallowed = true;
}

watchShootEntVelocity()
{
	self endon ("death");
	self.shootEntVelocity = (0,0,0);

	prevshootent = undefined;
	prevpos = self.origin;
	
	interval = .15;
	
	while(1)
	{
		if ( isdefined( self.enemy ) && isdefined( prevshootent ) && self.enemy == prevshootent )
		{
			curpos = self.enemy.origin;
			self.shootEntVelocity = vectorScale( curpos - prevpos, 1 / interval );
			prevpos = curpos;
		}
		else
		{
			if ( isdefined( self.enemy ) )
				prevpos = self.enemy.origin;
			else
				prevpos = self.origin;
			prevshootent = self.enemy;
			
			self.shootEntVelocity = (0,0,0);
		}
		
		wait interval;
	}
}

decideWhatAndHowToShoot( )
{
//	self endon("killanimscript");
	self notify("stop_deciding_how_to_shoot"); // just in case...
	self endon("stop_deciding_how_to_shoot");
	self endon("death");
	
	self.shootObjective = "normal";
//	self.shootEnt = undefined;
//	self.shootPos = undefined;
//	self.shootStyle = "none";
	self.fastBurst = false;
	self.shouldReturnToCover = false;
	
	self.changingCoverPos = false;
	
	prevShootEnt = self.shootEnt;
	prevShootPos = self.shootPos;
	prevShootStyle = self.shootStyle;

}

idleThread()
{
	self endon ("kill_local_animcustoms");
	for(;;)
	{
		idleAnim = animscripts\utility::animArrayPickRandom( "exposed_idle" );
		self setflaggedanimlimited("idle", idleAnim );
		self waittillmatch( "idle", "end" );
		self clearanim( idleAnim, .2 );
	}
}

trackShootEntOrPos()
{
	self endon ("death");
	self endon ("kill_local_animcustoms");
	
	animscripts\shared::trackLoop( %aim_2, %aim_4, %aim_6, %aim_8 );
}

suppress_animscripts()
{
	self endon ("death");
	while(1)
	{
		self notify ("killanimscript");
		waittillframeend;
		self notify ("killanimscript");
		wait .05;
	}
}

rpg_guy_animcustom()
{
//	self endon ("killanimscript");
//	self endon ("melee");
//	self thread suppress_animscripts();
	
	self endon ("death");
	self endon ("kill_local_animcustoms");
	
	self rpg_guy_animcustom_setup();
	self animscripts\shared::setAnimAimWeight(0);
	self thread trackShootEntOrPos();
	self thread decideWhatAndHowToShoot();
	self thread watchShootEntVelocity();
	
	//self thread ReacquireWhenNecessary();
	//self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
	//self thread watchShootEntVelocity();
	//self thread attackEnemyWhenFlashed();
	
	self animMode("zonly_physics", false);
	self OrientMode( "face angle", self.angles[1] );
	
	
	self.a.scriptStartTime = gettime();

	self.deathFunction = undefined;
	
	set_animarray_standing();

	self.shootent = self.enemy;
	self.shootpos = self.shootent.origin;
	
	while ( animscripts\combat::needToTurn() )
	{
		predictTime = 0.25;
		if ( isdefined( self.enemy ) && !isSentient( self.enemy ) )
			predictTime = 1.5;
		yawToShootEntOrPos = animscripts\shared::getPredictedAimYawToShootEntOrPos( predictTime ); // yaw to where we think our enemy will be in x seconds
		if ( animscripts\combat::TurnToFaceRelativeYaw( yawToShootEntOrPos ) )
			wait .05;
		else
			wait .05;
	}
	
//	while( !animscripts\combat_utility::aimedAtShootEntOrPos() )
//		wait .05;
		
	if( ! self has_hind_enemy() )
		return;
		
	self shoot();
	self.ignoreall = true;
	
	assert( isdefined( self.enemy ) );
	
	self.shootent = self.enemy;
	self.shootpos = self.shootent.origin;
	
	level thread vehicle_dropflare( self.hindenemy, self.attractorent );
	
	self clearAnim( %add_fire, .2 );

	wait randomfloatrange(5,9);
	self.shootent = undefined;
	self.shootpos = undefined;	
	
}

has_hind_enemy()
{
	return ( isdefined( self.hindenemy ) );

}




orientmodehack_axis_2( destent )
{
	self notify( "orientmodehack_axis_2" );
	self endon( "orientmodehack_axis_2" );
	self endon( "death" );
	self endon( "unload" );
	destent endon ("death");
	
	
	while ( 1 )
	{
		self orientmode( "face angle", vectortoangles( destent.origin - self.origin )[ 1 ] );
		wait .05;
	}
}


attractorent_link( eVehicle )
{

}

rocket_handle()
{
	self endon( "death" );
	wait 1;
	if ( !isdefined( self.ridingvehicle ) )
		return;
	vehicle = self.ridingvehicle;
	self.rocketattachpos = self.pos;
	guy_force_remove_from_vehicle( vehicle, self );
	self allowedstances( "crouch", "stand" );
	
	if ( !isdefined( vehicle.rocketmen ) )
		vehicle.rocketmen = [];
	vehicle.rocketmen[ vehicle.rocketmen.size ] = self;
	self.ignoreall = true; 

	self.a.rockets = 400;// hackery to keep them firing rockets.
	rocketcount = self.a.rockets;


	while(1)
	{
		self.ignoreall = true; 
		while( ! isdefined( self.hindenemy ) )
			wait .05;

		self.ignoreall = false; 
		
		self animcustom(::rpg_guy_animcustom);
		
		while( isdefined( self.shootent ) && isdefined(self.hindenemy) )
			wait .05;

		wait .05;	
		self notify ("kill_local_animcustoms");
		
		if( isdefined( self.hindenemy ) )
			self sethindtarget();
	}


}

donothing()
{
	while(1)
		wait 1;
}

magic_missileguy_magiccrouch()
{
	// hide the guy while he crouches
	self endon( "death" );
	self hide();
	self.desired_anim_pose = "crouch";
	self allowedstances( "crouch" );
	self thread animscripts\utility::UpdateAnimPose();
	wait 1.5;
	self show();
	self.desired_anim_pose = "stand";
	self allowedstances( "stand" );
	self thread animscripts\utility::UpdateAnimPose();
	wait 3;
	self notify( "missileready" );
}

magic_missileguy_spawner()
{
	targetnode = getvehiclenode( self.target, "targetname" );
	targetnode waittill( "trigger", vehicle );
	if ( isdefined( vehicle.magic_missile_guy ) )
		return;
		
	level.special_autosavecondition = ::save_fail_on_rpgguy;	
	
	linkent = vehicle.rpgguyspot;
	self.origin = linkent.origin;
	self.angles = vectortoangles( level.player geteye() - self.origin );
	
	guy = dronespawn( self );

	// hack some aim assist onto the drone.
	assist = getentarray( "assist_brush", "targetname" )[ 0 ];
	assist notsolid();
	assist unlink();
	assist linkto( guy, "J_Head", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	assist enableaimassist();
	assist hide();

	tag = "polySurface1";
	guy linkto( linkent, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	vehicle.magic_missile_guy = guy;
	targetent = spawn( "script_model", level.player geteye() );
	targetent.origin = level.player geteye() + vector_multiply( anglestoforward( self.angles ), 64 ) ;
 	targetent hide();
	targetent setmodel( "fx" );
	targetent linkto( level.playersride );
 	player_link_update( .1 );// steady players aim.
	guy thread magic_missileguy_takehits( vehicle, targetent );
	guy thread magic_missileguy_rpg( vehicle, linkent, tag, targetent );
}


reset_autosave_condition()
{
	level.special_autosavecondition = undefined;
	
}

magic_missileguy_takehits( vehicle, targetent )
{
	self setcandamage( true );
	self.health = 4000;
	vehicle endon( "death" );
// 	accumdam = 0;
	health = 100;
	while ( 1 )
	{
		self waittill( "damage", amount, attacker );
		if ( attacker == level.player )
			break;
// 			accumdam += amount;
// 		if ( accumdam > health )
// 			break;
		self.health = 4000;
	}
 	player_link_update();// back to normal
 	
	level notify( "kill_confirm" );
	
	vehicle.magic_missile_guy = undefined;

	self dodamage( self.health + 10, self.origin );
	if( getdvar("ragdoll_enable") != "0" )
		self unlink();
	self stopanimscripted();
	animation = %death_stand_dropinplace;
	self animscripted( "death_stand_dropinplac", self.origin, self.angles, animation );
	self thread ragdoll_or_death_duringanimation( animation );
}

ragdoll_or_death_duringanimation( animation )
{
	fraction = .2;
	animlength = getanimlength( animation );
	timer = gettime() + ( animlength * 1000 );
	wait animlength * .2;
	if( getdvar("ragdoll_enable") == "0" )
	{
		wait animlength *.8;
		self delete();
		return;
	}
	while ( ! self isragdoll() && gettime() < timer )
	{
		self startragdoll();
		wait .05;
	}
	if ( !self isragdoll() )
		self delete();
		
	wait 10;
	if(isdefined(self))
		self delete();
}

dialog_rpg()
{
	
	pricerpgdialog = [];
	grgsrpgdialog = [];
	
	grgsrpgdialog[ grgsrpgdialog.size ] = "jeepride_grg_hostilerpg";
	grgsrpgdialog[ grgsrpgdialog.size ] = "jeepride_grg_anotherrpg";
	grgsrpgdialog[ grgsrpgdialog.size ] = "jeepride_grg_takemout";

	pricerpgdialog[ pricerpgdialog.size ] = "jeepride_pri_fireontruck";
	pricerpgdialog[ pricerpgdialog.size ] = "jeepride_pri_openfire";
	pricerpgdialog[ pricerpgdialog.size ] = "jeepride_pri_shootthattruck";
	
	pricerpgdialog = array_randomize( pricerpgdialog ); 
	pricerpgdialog = array_randomize( pricerpgdialog );

	priceindex = 0;
	grgsindex = 0;
	
	while ( 1 )
	{
		level waittill( "rpg_truck" );
		{
			level.griggs thread anim_single_queue( level.griggs, grgsrpgdialog[ grgsindex ] );
			grgsindex++ ;
			if ( grgsindex == grgsrpgdialog.size )
				grgsindex = 0;
		}
		level waittill( "rpg_truck" );
		{
			level.price thread anim_single_queue( level.price, pricerpgdialog[ priceindex ] );
			priceindex++ ;
			if ( priceindex == pricerpgdialog.size )
				priceindex = 0;
		}
	}
	
}


magic_missileguy_rpg( vehicle, animatemodel, tag, targetent )
{
	vehicle endon( "death" );
	self endon( "death" );
	crouchaim = %crouch_aim_straight;
	toaim = %crouch2stand;
	aim = %RPG_stand_aim_5;
	tocrouch = %stand2crouch_attack;

	fire_aim_idle_time = 3000;	
	fire_crouch_idle_time = 2500;
	
	animatemodel local_drone_animontag( self, tag, crouchaim );
	level notify( "rpg_truck" );
	animatemodel local_drone_animontag( self, tag, toaim );

	while ( 1 )
	{
		

		// aim for a bit;
		timer = timer_set( fire_aim_idle_time );
		
		while ( ! timer_past( timer ) )
			animatemodel local_drone_animontag( self, tag, aim, true );
		
		// fire!
		thread fake_rpg_shot( targetent, vehicle );
		
		// go to crouch
		animatemodel local_drone_animontag( self, tag, tocrouch );
		
		timer = timer_set( fire_crouch_idle_time );
		while ( ! timer_past( timer ) )
			animatemodel local_drone_animontag( self, tag, crouchaim );
		
		level notify( "rpg_truck" );
		
		// go to stand aiming again
		animatemodel local_drone_animontag( self, tag, toaim );
	}
}

fake_rpg_shot( targetent, vehicle )
{
	barrelpos = self gettagorigin( "tag_flash" );
	barrelang = self gettagangles( "tag_flash" );
	fxent = spawn( "script_model", barrelpos );
	fxent.angles = barrelang;
	fxent setmodel( "projectile_rpg7" );
	PlayFXOnTag( level._effect[ "rpg_flash" ], fxent, "TAG_FX" );
	thread play_sound_in_space( "weap_rpg_fire_npc", fxent.origin );
	fxent PlayLoopSound( "weap_rpg_fire_npc" );
	movespeed = 2400;
	fire_vect = vectornormalize( targetent.origin - barrelpos );
	fire_org = barrelpos + vector_multiply( fire_vect, 5000 );
	PlayFXOnTag( level._effect[ "rpg_trail" ], fxent, "TAG_FX" );
	lastdest = barrelpos;
	fxent notsolid();
	fxent thread movewithrate( fire_org, barrelang, movespeed );
	engagedist = 450;

	while ( 1 )
	{
		wait .05;
		trace = BulletTrace( lastdest, fxent.origin, false, vehicle );
		if ( fxent.movefinished )
		{
			fxent delete();
			return;
		}
		if ( trace[ "fraction" ] != 1 
			 && distance( barrelpos, fxent.origin ) > engagedist )
			break;
		lastdest = fxent.origin;
	}
	playfx( level._effect[ "rpg_explode" ], fxent.origin );
	radiusdamage( fxent.origin, 400, 150, 26 );
	level.player playrumbleonentity ("tank_rumble");
	Earthquake( .8, .8, level.player.origin , 2000 );
	wait .01;
	fxent delete();	
}

timer_set( timer )
{
	return gettime() + timer;
}

timer_past( timer )
{
	if ( gettime() > timer )
		return true;
	return false;
}

physicslaunch_loc( centroid, strength, vec_sampledelay )
{
	if ( !isdefined( vec_sampledelay ) )
		vec_sampledelay = .1;
	orgbefore = self.origin;
	wait vec_sampledelay;
	throwvec = vectornormalize( self.origin - orgbefore );
	upvect = anglestoup( self.angles );
	self unlink();
	self physicslaunch( self.origin + vector_multiply( upvect, centroid ), vector_multiply( throwvec, strength ) );
	wait 10;
	self delete();
}

can_cannon()
{
	level.cannonpower = 100;
	precachemodel( "com_trashcan_metal" );
	while ( 1 )
	{
		if ( level.player usebuttonpressed() )
			fire_can();
		wait .05;
	}
}

fire_can()
{
	can = spawn( "script_model", level.player geteye() );
	can setmodel( "com_trashcan_metal" );
	throw_vect = vector_multiply( vectornormalize( anglestoforward( level.player getplayerangles() ) ), level.cannonpower );
	can physicslaunch( can.origin + ( 0, 0, 17 ), throw_vect + ( 0, 0, 17 ) );
	wait .05;
	
}

no_godmoderiders()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		for ( i = 0 ; i < other.riders.size ; i++ )
			if ( issentient( other.riders[ i ] ) && isdefined( other.riders[ i ].magic_bullet_shield ) )
				other.riders[ i ] thread stop_magic_bullet_shield();
		if ( isdefined( other.rocketmen ) )
			for ( i = 0; i < other.rocketmen.size; i++ )
				if ( issentient( other.rocketmen[ i ] ) && isdefined( other.rocketmen[ i ].magic_bullet_shield ) )
				{
					other.rocketmen[ i ] thread stop_magic_bullet_shield();
					other.rocketmen[ i ] delete();// try just deleting them here.
				}

	}
}

all_allies_targetme()
{
	self waittill( "trigger", eVehicle );
	if ( !isdefined( eVehicle.flaretargetents ) )
		eVehicle.flaretargetents = [];
	ai = getaiarray( "allies" );
	for ( i = 0 ; i < ai.size ; i++ )
	{
		if ( ai[ i ].classname != "actor_ally_sas_woodland_stinger" )
			continue;
		ai[ i ] thread sethindtarget( eVehicle );
	}
	
	eVehicle endon( "death" );
//	while ( 1 )
//	{
//		level waittill( "rpg_guy_shot" );
//		thread vehicle_dropflare( eVehicle );
//	}
}
 
vehicle_dropflare( eVehicle,theflare )
{
	wait randomfloatrange( 0, .5 );
	if( ! isdefined( eVehicle ) )
	{
		if(isdefined(theflare))
			theflare delete();  // oh yeah getting defensive.. I'm pretty sure I'm deleting this elsewhere.
		return;
	}
	level thread jeepride_flares_fire_burst( eVehicle, 8, 6, 5.0 );
	eVehicle thread vehicle_drop_single_flare(theflare);
//	eVehicle array_levelthread( eVehicle.flaretargetents, ::vehicle_drop_single_flare );
}

vehicle_drop_single_flare( attractorent )
{
//	self.flaretargetents = array_remove( self.flaretargetents, attractorent );
	attractorent endon ("death");
	attractorent unlink();
	vec = maps\_helicopter_globals::flares_get_vehicle_velocity( self );
	attractorent movegravity( vec, 8 );
	wait 12;
	attractorent delete();
}

hind_lock_on_player_on()
{
	level.lock_on_player = true;
	level endon( "lock_on_player_off" );
	// this is a once off gag. hacks away.
	level.lock_on_player_ent.script_shotcount = 1;
	while ( 1 )
	{
		while ( level.lock_on_player_ent.script_attackmetype == "missile" )
			wait .05;
		wait 2;
		level.lock_on_player_ent.script_shotcount = 1;
		level.lock_on_player_ent.script_attackmetype = "missile";
	}
}

hind_lock_on_player_off()
{
	level notify( "lock_on_player_off" );
	level.lock_on_player = false;
}

stinger_me( bPlayerlock )
{
	level endon( "clear_all_vehicles_but_heros" );
	self waittill( "trigger", eVehicle );
	if ( !isdefined( bPlayerlock ) )
		bPlayerlock = true;
		
	player_link_update( 0.1 );

	if ( bPlayerlock )
		wait 3;
	
	level notify( "newrpg" );// sets RPG on box	

	if ( bPlayerlock )
		wait 8;
	
	if ( bPlayerlock )
		thread hind_lock_on_player_on();

	flag_wait( "rpg_taken" );
	flag_wait( "rpg_shot" );	
		
	if ( bPlayerlock )
		hind_lock_on_player_off();

	player_link_update();// resets the link

	if ( !isdefined( eVehicle ) )
		return;

	eVehicle endon( "death" );
	
	level thread jeepride_flares_fire_burst( eVehicle, 8, 6, 5.0 );
}

jeepride_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
// 		copied from maps\hunted which was copied from maps\_helicopter_globals
// 		had to change it a litle since I couldn't redirect the missile in my case.
// 		I simplified even more because I don't need any of that stuff that those scripts do

	vehicle endon( "death" );
	assert( isdefined( level.flare_fx[ vehicle.vehicletype ] ) );
	assert( fxCount >= flareCount );
	
	for ( i = 0 ; i < fxCount ; i++ )
	{
		playfx( level.flare_fx[ vehicle.vehicletype ], vehicle getTagOrigin( "tag_light_belly" ) );
		wait 0.05;
	}
}

do_or_die()
{
	self waittill( "trigger" );
	if ( !level.lock_on_player )
		return;
		
	wait .45;
	playfx( level._effect[ "rpg_explode" ], level.player.origin );
	level.playervehicle thread play_sound_in_space( "explo_metal_rand", level.player geteye(), true );
	
	level.player enableHealthShield( false );
	radiusDamage( level.player.origin, 8, level.player.health + 5, level.player.health + 5 );
	level.player enableHealthShield( true );
}

loosejunk( eVehicle )
{
	self.health = 700;
	self setcandamage( true );
	eVehicle endon( "junk_throw" );
	while ( 1 )
	{
// 		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
			self waittill( "damage", damage, attacker, direction_vec, point );
			
			if ( attacker != level.player && self.health > 100 )
				continue;
			self unlink();
			forward = anglestoforward( eVehicle.angles );
			offsetthrow = vector_multiply( vectornormalize( point - self.origin ), randomfloat( 2 ) );// little bit of a spin but not a lot based on where the thing was hit
			self.origin += vector_multiply( forward, 32 );// move it forward a little because physics launch is a bit slow.  may 
			forwardthrow = vector_multiply( forward, 18000 );

			self physicslaunch( self.origin + offsetthrow, vector_multiply( direction_vec, 10 ) + ( 0, 0, 20 ) + forwardthrow );
			return;
	}
}

junk_to_dummy( model )
{
	if ( !isdefined( self.truckjunk ) )
		return;
	for ( i = 0 ; i < self.truckjunk.size ; i++ )
	{
		self.truckjunk[ i ] unlink();
		self.truckjunk[ i ] linkto( model );
	}
}

junk_throw()
{
	if ( !isdefined( self.truckjunk ) )
		return;
	if ( self == level.playersride )
		return;
	self notify( "junk_throw" );
	for ( i = 0 ; i < self.truckjunk.size ; i++ )
	{
		if ( isdefined( self.truckjunk[ i ].script_startingposition ) || self.truckjunk[ i ].model == "axis" )
		{
// 			self.truckjunk[ i ] thread delayThread( 2, ::deleteme );
			
			continue;
		}
		center_height = 17;
		strength = 80000;
		delay = randomfloat( .7 );
		if ( self.truckjunk[ i ].model == "com_barrel_blue"
		 || self.truckjunk[ i ].model == "com_barrel_black"
		 || self.truckjunk[ i ].model == "com_plasticcase_beige_big" 
		 )
		{
			strength = 660000;
			center_height = 23;
			delay = randomfloat( 1 );
		}
		else if ( self.truckjunk[ i ].model == "me_corrugated_metal2x4" )
		{
			strength = 1000;
			center_height = 0;
		}
		self.truckjunk[ i ] delaythread( delay, ::physicslaunch_loc, center_height, strength );
	}
}

riders_godon()
{
	bKillfreevehicle = false;
	for ( i = 0 ; i < self.riders.size ; i++ )
		if ( issentient( self.riders[ i ] ) )
		{
			bKillfreevehicle = true;
			if ( !isdefined( self.riders[ i ].magic_bullet_shield ) && ! self.riders[ i ] ishero() )
				self.riders[ i ] thread magic_bullet_shield();
		}
	
	if ( !bKillfreevehicle )
		return;
	wait .2;
	self notify( "no_free_on_end" );
}

monitorvehiclecounts()
{
	while ( 1 )
	{
		if ( getentarray( "script_vehicle", "classname" ).size > 60 )
		{
			vehicle_dump();
			assertmsg( "too many vehicles" );
		}
		wait .05;
	}
}

destructible_assistance()
{
 	self waittill( "trigger", eVehicle );
 	eVehicle maps\_vehicle::godoff();
	eVehicle notify( 	"stop_friendlyfire_shield" );
	eVehicle.health = 1;
	if ( eVehicle isDestructible() )
		eVehicle notify( "damage", 5000, level.player, ( 1, 1, 1 ), eVehicle.origin, "mod_explosive", eVehicle.model, undefined );
	else
		eVehicle notify( "death" );
		
}

killthrow()
{
	if ( !isai( self ) )
	{
		self thread ragdollragdollragdollragdollragdollragdoll();
		return;
	}
	if ( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
		return;
	if ( isdefined( self.pos ) )
	if ( self.pos == 0 || self.pos == 1 )
	{
		self delete();
		return;
	}
	self dodamage( 8000, self.origin ); 
	
	wait 10;
	if(isdefined(self))
		self delete(); // make sure this guy dies.
}

heli_focusonplayer()
{
	self waittill( "trigger", other );
	other setlookatent( level.playersride );
	other setTurretTargetEnt( level.playersride );
}

heli_mg_burst( eTarget )
{
	shots = randomintrange( 25, 45 );
	for ( i = 0; i < shots; i++ )
	{
		self setVehWeapon( "hind_turret" );
		self fireWeapon( "tag_flash" );
		wait 0.05;
		if ( eTarget.script_attackmetype != "mg_burst" || playerinhelitargetsights_orrandom( eTarget ) )
			break;
	}
	wait randomfloatrange( .5, 1 );
}

playerinhelitargetsights_orrandom( eTarget )
{
	inrange = distance( eTarget.origin, level.player.origin ) < 32;
	if ( !inrange && randomint( 25 ) > 18 )
		inrange = true;
	if ( inrange )
		eTarget.script_attackmetype = ( "missile" );
	return inrange;
}

shoot_the_vehicles()
{
	timeouttime = gettime() + 10000;
	array = getentarray( "destroy_at_end", "script_noteworthy" );
	vehicles = [];
	for ( i = 0; i < array.size; i++ )
		if ( array[ i ].classname == "script_vehicle" )
			vehicles[ vehicles.size ] = array[ i ];
	for ( i = 0; i < vehicles.size; i++ )
	{
		shootspotoncewithmissile( vehicles[ i ].origin + ( 0, 0, 34 ) );
	}
		
}

shootnearest_non_hero_friend()
{
	ai = getaiarray( "allies" );
	newai = [];
	for ( i = 0; i < ai.size; i++ )
		if ( !isdefined( ai[ i ].magic_bullet_shield ) || !ai[ i ].magic_bullet_shield )
			newai[ newai.size ] = ai[ i ];
			
	if ( !newai.size )
		return;
	nearest = getClosest( level.player.origin, newai );
	
	shootspotoncewithmissile( nearest gettagorigin( "J_Head" ) );
}

shootspotoncewithmissile( origin )
{
	spot = spawn( "script_model", origin );
	BadPlace_Cylinder( "missilespot", 2, origin, 200, 300, "allies", "axis" );
	spot.oldmissiletype = false;
	spot.script_attackmetype = "missile";
	spot.script_shotcount = 1;
	self thread shootEnemyTarget( spot );
	spot waittill( "shot_at" );
	spot delete();
}

shootEnemyTarget( eTarget, delay )
{
	if ( !isdefined( delay ) )
		delay = 0;
	self endon( "death" );
	self endon( "mg_off" );
	eTarget endon( "death" );
	self endon( "gunner_new_target" );
	self setTurretTargetEnt( eTarget );
	wait delay;
	script_attackmetype = "mg";
	originaltarget = eTarget;
	offshooting = false;
	while ( self.health > 0 )
	{
		if ( level.lock_on_player )
		{
			self setTurretTargetEnt( eTarget );
			eTarget = level.lock_on_player_ent;
		}
		else if ( isdefined( eTarget.offshoot_ent ) ) 
		{
			eTarget = eTarget.offshoot_ent;
			offshooting = true;
		}
		else
		{
			eTarget = originaltarget;
		}
		if ( isdefined( eTarget.script_attackmetype ) )
			script_attackmetype = eTarget.script_attackmetype;
		if ( script_attackmetype == "none" )
			wait .05;
		else if ( script_attackmetype == "mg" )
		{
			self setVehWeapon( "hind_turret" );
			self fireWeapon( "tag_flash" );
			wait 0.05;
		}
		else if ( script_attackmetype == "mg_burst" )
		{
			heli_mg_burst( eTarget );
		}
		else if ( 
							script_attackmetype == "missile" 
							 || script_attackmetype == "missile_old" 
							 || script_attackmetype == "missile_bridgebuster" 
						 )
		{
			missiletype = "hind_FFAR_jeepride";
			if ( script_attackmetype == "missile_bridgebuster" )
				missiletype = "hunted_crash_missile";
				
			if ( script_attackmetype == "missile_old" )
				eTarget.oldmissiletype = true;
				
			self setVehWeapon( missiletype );
			script_shotcount = 6;
			
			if ( isdefined( eTarget.script_shotcount ) )
				script_shotcount = eTarget.script_shotcount;
			self fire_missile( missiletype, script_shotcount, eTarget, .2 );
			eTarget notify( "shot_at" );

			eTarget.script_attackmetype = "mg";
			
			if ( script_attackmetype == "missile_bridgebuster" )
				eTarget.script_attackmetype = "none";
			
			if ( offshooting )
			{
				eTarget = originaltarget;
				offshooting = false;
				
			}
		}
		else
		{
			println( "attackmetype: " + script_attackmetype );
			assertmsg( "check attackmetype" );
		}
	}
}

missile_offshoot()
{
	target = getstruct( self.target, "targetname" );
	self.script_attackmetype = "missile";
	target.offshoot_ent = self;
	self.oldmissiletype = false;
	self.script_shotcount = 1;
	self hide();
}

sound_emitter()
{
	links = get_links();
	trigger = undefined;
	sound = self.script_noteworthy;
	assert( isdefined( sound ) );
	for ( i = 0 ; i < links.size ; i++ )
	{
		trigger = getvehiclenode( links[ i ], "script_linkname" );
		if ( !isdefined( trigger ) )
			continue;
		trigger thread sound_emitter_single( sound );
	}
	self delete();
}

sound_emitter_single( sound )
{
	self waittill( "trigger", vehicle );
	if(sound == "truck_horn" && vehicle != level.playersride )
		return;
	vehicle thread play_sound_on_entity( sound );
}

ambient_setter()
{
	trigger = getvehiclenode( self.target, "targetname" );
	self hide();
	assert( isdefined( trigger ) );
	ambient = self.ambient;
	trigger waittill( "trigger" );
// 	level thread maps\_ambient::activateAmbient( ambient );
	type = ambient;
	if ( type == "interior" )
		set_vision_set( "jeepride_tunnel", 2 );
	if ( type == "exterior" )
		set_vision_set( "jeepride", 2 );
	
	
	level.player setReverb( level.ambient_reverb[ type ][ "priority" ], level.ambient_reverb[ type ][ "roomtype" ], level.ambient_reverb[ type ][ "drylevel" ], level.ambient_reverb[ type ][ "wetlevel" ], level.ambient_reverb[ type ][ "fadetime" ] );
}


whackamole_unload( guy )
{
	self endon( "death" );
	guy endon( "death" );
	self waittill( "unload" );
	guy.desired_anim_pose = undefined;
	guy allowedstances( "crouch", "stand", "prone" );
	guy.ignoreall = false;
	wait 1;
	guy unlink();
	
}

whackamole( guy )
{
	guy endon( "newanim" );
	self endon( "death" );
	self endon( "unload" );
	guy endon( "death" );
	
	if ( !isdefined( self.whackamolecount ) )
		self.whackamolecount = 0;
	if ( !isdefined( self.whackamoleguys ) )
		self.whackamoleguys = [];
		
	guy.whackamole_on = false;	
	if ( !isai( guy ) )
		return;
	thread whackamole_death( guy );
	thread whackamole_unload( guy );
	
	if ( guy.team == "allies" )
	{
		guy.desired_anim_pose = "crouch";	
		guy allowedstances( "crouch" );
		guy thread animscripts\utility::UpdateAnimPose();
		return;
	}
	
	thread orientmodehack_axis( guy );
	
	whackamole_off( guy );
	while ( 1 )
	{
		while ( self.whackamolecount > 2 )
			wait .05;
		whackamole_on( guy );
		wait randomfloatrange( 3, 7 );
		whackamole_off( guy );
		wait randomfloatrange( 3, 5 );
	}
}

whackamole_on( guy )
{

	guy.whackamole_on = true;
	guy.desired_anim_pose = "stand";	
	guy allowedstances( "stand" );
	guy.ignoreall = false;
	guy thread animscripts\utility::UpdateAnimPose();	
	self.whackamolecount++ ;
}

whackamole_off( guy )
{
	self endon( "death" );
	guy endon( "death" );
	guy.whackamole_on = false;
	guy.desired_anim_pose = "crouch";	
	guy.ignoreall = true;
	guy allowedstances( "crouch" );
	guy thread animscripts\utility::UpdateAnimPose();
	guy.bulletsInClip = 0;// make him reload.
	self.whackamolecount -- ;
}

whackamole_death( guy )
{
	if ( guy.team == "allies" )
		return;// allies don't die
	self.whackamoleguys[ self.whackamoleguys.size ] = guy;
	self endon( "death" );
	guy waittill( "death" );
	thread whackamole_dialog();
	self.whackamoleguys = array_remove( self.whackamoleguys, guy );
	self.whackamolecount -- ;

	if ( !isdefined( guy ) )
		return;
	
	guy waittillmatch( "deathanim", "start_ragdoll" );	
// 	guy unlink();
// 	guy thread ragdollragdollragdollragdollragdollragdoll();// damnit work you
	if( getdvar("ragdoll_enable") != "0" )
		thread dropspeedbump( guy.origin, self );
	else
		guy delete();

}

whackamole_dialog()
{
	if ( !isdefined( level.whackamole_lastspeak ) )
		level.whackamole_lastspeak = gettime() + 3005;
	if ( gettime() < level.whackamole_lastspeak + 10000 )
		return;
	level.whackamole_lastspeak = gettime();
// 	level notify( "kill_confirm" );

}

dialog_killconfirm()
{
	dialog = [];
	dialog[ dialog.size ] = "jeepride_grg_killfirm";   
	dialog[ dialog.size ] = "jeepride_grg_niceshootin";
	dialog[ dialog.size ] = "jeepride_grg_success";
	dialog[ dialog.size ] = "jeepride_grg_thatsahit";
	dialog[ dialog.size ] = "jeepride_grg_devastation";
	for ( i = 0; i < dialog.size; i++ )
	{
		level waittill( "kill_confirm" );
		level.griggs anim_single_queue( level.griggs, dialog[ i ] );
	}
}

ghetto_tag()
{
		if ( !isdefined( level.ghettotag ) )
			level.ghettotag = [];
		target = getent( self.target, "targetname" );
		assert( isdefined( target ) );
		assert( isdefined( target.model ) );
		if ( !isdefined( level.ghettotag[ target.model ] ) )
			level.ghettotag[ target.model ] = [];
		level.ghettotag[ target.model ][ level.ghettotag[ target.model ].size ] = ghetto_tag_create( target );
		
}

trigger_sparks_on()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		other thread maps\jeepride_fx::apply_ghettotag();
			
	}
}

trigger_sparks_off()
{
	while ( 1 )
	{
		self waittill( "trigger", other );
		other thread remove_ghettotag();
	}
}

remove_ghettotag()
{
	if ( !isdefined( self.ghettotags ) )
		return;
	array_thread( self.ghettotags, ::deleteme );
	if ( !isdefined( self ) )
		return;
	self.ghettotags = [];
}

// helicopter fires at a moving invisible object, object is made to sync with players ride making things dramatic.
attack_dummy_path()
{
	
// 	path = setup_throwchain( self );
	path = setup_throwchain_dummy_path( self );
	delay = 0;
	if ( isdefined( self.script_delay ) )
		delay = self.script_delay;// nasty.
	trigger = getent( self.script_linkto, "script_linkname" );
	trigger waittill( "trigger", helicopter );

	model = spawn( "script_model", path[ 0 ].origin );
	model setmodel( "fx" );

	if ( getdvar( "jeepride_showhelitargets" ) == "off" )
	 	model hide();
	 	
	model notsolid();
	model.oldmissiletype = false;
	helicopter endon( "gunner_new_target" );
	helicopter endon( "death" );
	helicopter clearlookatent();
	helicopter setlookatent( model );
	
	// I'm ghetto hacking this.  only handles hind in Jeepride. doin what I need to do to do th e stuff.  get out of my sandbox!
	helicopter thread shootEnemyTarget( model, delay );
	ghetto_animate_through_chain( path, model, 500, true );
	helicopter clearlookatent();
	model delete();
}

rpgers_to_dummy( dummy )
{
	if ( !isdefined( self.rocketmen ) )
		return;
	for ( i = 0; i < self.rocketmen.size; i++ )
	{
		assert( isdefined( self.rocketmen[ i ].rocketattachpos ) );
		animpos = anim_pos( self, self.rocketmen[ i ].rocketattachpos );
		
		assert(isdefined( self.truckjunk[0]));
		self.rocketmen[ i ] linkto( self.truckjunk[0], "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );;
//		self.rocketmen[ i ] unlink();
//		self.rocketmen[ i ] linkto( dummy, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
}

fliptruck_ghettoanimate()
{
	throwchain = setup_throwchain( self );
	vehiclenode =  getvehiclenode( self.script_linkto, "script_linkname" );
	previous_vehiclenode = getvehiclenode( vehiclenode.targetname, "target" );
	assert( isdefined( previous_vehiclenode ) );
	previous_vehiclenode waittill( "trigger", truck );
	time = gettime();
	prevorg = truck.origin;
	vehiclenode waittill( "trigger", truck );
	timediff = ( gettime() - time ) / 1000;
	dist = distance( prevorg, truck.origin );
	rate = dist / timediff;

	// todo copy collmap and apply it to the dummy for better physics.
	
	
	
	dummy = truck maps\_vehicle::vehicle_to_dummy();
	truck junk_to_dummy( dummy );
	truck rpgers_to_dummy( dummy );
	truck notify( "kill_treads_forever" );
	truck notify( "stop_tire_deflate" );
	if ( truck == level.playersride )
	{
		level.player unlink();
		level.player playerlinktodelta( level.playerlinkmodel, "polySurface1", level.playerlinkinfluence );
	}
	
	if ( isdefined( level.fxplay_model ) )
		truck thread junk_throw();
	dummy notsolid();
	
	if ( animated_crash( dummy, rate, truck ) )
		return truck remove_ghettotag();// eyick
		
	array_thread( truck.riders, ::killthrow );
	if ( isdefined( truck.whackamoleguys ) )
		array_thread( truck.whackamoleguys, ::killthrow );
	if ( isdefined( truck.magic_missile_guy ) )
		truck.magic_missile_guy thread killthrow();
	waittillframeend;// lets vehicle script remove the guy
	truck ghetto_animate_through_chain( throwchain, dummy, rate );

	truck remove_ghettotag();
}

show_ghetto_tags()
{
	for ( i = 0; i < self.ghettotags.size; i++ )
	{
		self.ghettotags[ i ] show();
	}
}

animated_crash( dummy, rate, nondummy )
{
	if ( 
		 ! isdefined( self.script_parameters ) || 
		  ! isdefined( level.jeepride_crash_anim ) || 
		 ! isdefined( level.jeepride_crash_anim[ self.script_parameters ] ) 
		 )
			return false;
			
	if ( isdefined( level.jeepride_crash_model[ self.script_parameters ] ) )
	{
		angles = dummy.angles;
		origin = dummy.origin;
		model = dummy.model;
		dummy hide();
		dummy = spawn( "script_model", origin );
		dummy.angles = angles;
		dummy setmodel( level.jeepride_crash_model[ self.script_parameters ] );
		dummy_dummy = spawn( "script_model", dummy.origin );
		dummy_dummy setmodel( "tag_origin" );
		dummy_dummy.angles = dummy gettagangles( "body_animate_jnt" );
		dummy_dummy.origin = dummy gettagorigin( "body_animate_jnt" );
		dummy_dummy dontinterpolate();
		dummy_dummy notsolid();
		dummy_dummy linkto( dummy, "body_animate_jnt", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		assert( isdefined( level.jeepride_crash_animtree[ self.script_parameters ] ) );
		dummy useanimtree( level.jeepride_crash_animtree[ self.script_parameters ] );
// 		nondummy show_ghetto_tags();
//		nondummy move_ghettotags_here( dummy_dummy );
		
		dummy_dummy thread maps\jeepride_fx::apply_ghettotag( model,"tag_origin" );
	}
	nondummy hide();
// 	dummy hide();
		
	dummy movewithrate( self.origin, self.angles, rate );
	flagName = "crashanim";
	dummy thread animated_crashtracks( flagName );
// 	dummy animscripted( flagName, node.origin, node.angles, level.jeepride_crash_anim[ node.script_noteworthy ] );
	dummy animscripted( flagName, self.origin, self.angles, level.jeepride_crash_anim[ self.script_parameters ] );
	dummy waittillmatch( flagName, "end" );
	nondummy delete();// kills the vehicle and the dummy
	return true;
}

animated_crashtracks( flagName )
{
	crash_tracks_func = [];
	crash_tracks_func[ "slide" ] = ::crashtrack_note_slide;
	crash_tracks_func[ "breakwall" ] = ::crashtrack_note_breakwall;
	crash_tracks_func[ "splash" ] = ::crashtrack_note_splash;
	
	for ( ;; )
	{
		self waittill( flagName, note );
		if ( isdefined( crash_tracks_func[ note ] ) )
			[[ crash_tracks_func[ note ] ]]();
		if ( note == "end" )
			break;
	}
}

crashtrack_note_slide()
{
	self playsound( "vehicle_skid_long" );
}

crashtrack_note_breakwall()
{
	//PlayFX( level._effect[ "truck_busts_pillar" ], self gettagorigin( "tag_wheel_front_left" ), anglestoforward( self.angles ), anglestoup( self.angles ) );
	//exploder( 4 );
}

crashtrack_note_splash()
{
	//exploder( 2 );
}



fire_missile( weaponName, iShots, eTarget, fDelay )
{
	self endon( "death" );
	self endon( "gunner_new_target" );
	
	if ( level.lock_on_player )
		eTarget = level.lock_on_player_ent;
	
	eTarget endon( "death" );
	if ( !isdefined( iShots ) )
		iShots = 1;
	assert( self.health > 0 );
	
	if ( self.vehicletype == "hind" )
	{
		tags[ 0 ] = "tag_missile_left";
		tags[ 1 ] = "tag_missile_right";
	}
	else
	{
		tags[ 0 ] = "tag_store_L_2_a";
		tags[ 1 ] = "tag_store_R_2_a";		
		tags[ 2 ] = "tag_store_L_2_b";
		tags[ 3 ] = "tag_store_R_2_b";
		tags[ 4 ] = "tag_store_L_2_c";
		tags[ 5 ] = "tag_store_R_2_c";
		tags[ 6 ] = "tag_store_L_2_d";
		tags[ 7 ] = "tag_store_R_2_d";
	}
	
	
	weaponShootTime = weaponfiretime( weaponName );
	assert( isdefined( weaponShootTime ) );
	self setVehWeapon( weaponName );
	nextMissileTag = -1;
	originaltarget = eTarget;
	
	for ( i = 0 ; i < iShots ; i++ )
	{
		if ( level.lock_on_player )
			eTarget = level.lock_on_player_ent;
		else
			eTarget = originaltarget;
		nextMissileTag++ ;
		if ( nextMissileTag >= tags.size )
			nextMissileTag = 0;
		eMissile = self fireWeapon( tags[ nextMissileTag ] );
		if ( !isdefined( eMissile ) )
			continue;// TODO: I should find out why.  there's no apparent reason. maybe I'm firing too many?
		if ( weaponname == "hunted_crash_missile" )
		{
			level notify( "missile_tracker", eMissile );
			eMissile thread maps\jeepride::blown_bridge( eTarget ); 
		}
			
		if ( isdefined( eTarget.vehicletype ) && eTarget.vehicletype == "hind" )
			eMissile missile_settarget( eTarget, ( 0, 0, -56 ) );
		else if ( eTarget.oldmissiletype )
			eMissile missile_settarget( eTarget, ( 80, 20, -200 ) );
		else
			eMissile missile_settarget( eTarget );
		if ( i < iShots - 1 )
			wait weaponShootTime;
		if ( isdefined( fDelay ) )
			wait( fDelay );
	}
}

// view_magnet()
// {
// 		org_ent = spawn( "script_origin", level.player.origin );
// 		self waittill( "trigger", other );
// 		level notify( "new_magnet" );
// 		level endon( "new_magnet" );
// 		org_ent thread magnet_endon();
// 		
// 		org_ent.origin = level.player geteye();
// 		org_ent.angles = level.player getplayerangles();
// 		
// 		dest_angle = vectortoangles( vectornormalize( ( other.origin + ( 0, 0, 48 ) ) - org_ent.origin ) );
// 		
// 		waittime = .5;
// 		org_ent rotateto( dest_angle, waittime, .2, .2 );
// 		incs = int( waittime / .05 );	
// 		for ( i = 0 ; i < incs ; i++ )
// 		{
// 				level.player setplayerangles( org_ent.angles );
// 				wait .05;
// 		}
// }


script_playerlink_org()
{
	if ( isdefined( level.player.script_linker_model ) )
		return level.player.script_linker_model;
	level.player.script_linker_model = spawn( "script_model", level.player.origin );
	level.player.script_linker_model setmodel( "axis" );
	return level.player.script_linker_model; 
}

view_turn( dest_origin, bLink )
{
	bLink = true;
	playerlinkorg = script_playerlink_org();
	playerlinkorg.angles = level.player getplayerangles();
	org_ent = spawn( "script_origin", level.player.origin );
	org_ent.origin = level.player geteye();
	org_ent.angles = level.player getplayerangles();
	level.player PlayerLinkToAbsolute( playerlinkorg, "polySurface1" );
	
	dest_angle = vectortoangles( vectornormalize( dest_origin  - org_ent.origin ) );
	
	waittime = .5;
	playerlinkorg rotateto( dest_angle, waittime, .2, .2 );
// 	incs = int( waittime / .05 );	
// 	for ( i = 0 ; i < incs ; i++ )
// 	{
// 		playerlinkorg rotateto( ;
// 		wait .05;
// 	}	
}

delaythread_loc( delay, sthread, param1, param2, param3, param4 )
{
	delay *= 1000;
	
	if ( level.startdelay != 0 && level.startdelay  > delay )
		return;// this event has passed in the wip start point.
	while ( gettime() + level.startdelay < delay )
		wait .05;
	if ( isdefined( param4 ) )
		thread [[ sthread ]]( param1, param2, param3, param4 );
	else if ( isdefined( param3 ) )
		thread [[ sthread ]]( param1, param2, param3 );
	else if ( isdefined( param2 ) )
		thread [[ sthread ]]( param1, param2 );
	else if ( isdefined( param1 ) )
		thread [[ sthread ]]( param1 );
	else
		thread [[ sthread ]]();
}

// magnet_endon()
// {
// 	level waittill( "new_magnet" );
// 	self delete();
// }

jeepride_start_dumphandle()
{
	button1 = "h";
	button2 = "CTRL";
	while ( 1 )
	{
		while ( ! twobuttonspressed( button1, button2 )  )
			wait .05;
			while ( !jeepride_start_dump() )
				wait.05;
		while ( twobuttonspressed( button1, button2 ) )
			wait .05;
	}
}

get_vehicles_with_spawners()
{
	vehicles = getentarray( "script_vehicle", "classname" );
	spawned_vehicles = [];
	for ( i = 0;i < vehicles.size;i++ )
		if ( isdefined( vehicles[ i ].spawner_id ) && isdefined( vehicles[ i ].currentnode ) )
			spawned_vehicles[ spawned_vehicles.size ] = vehicles[ i ];
	return spawned_vehicles;		
}

jeepride_start_dump( startname )
{
	
	if ( !isdefined( startname ) )
		startname = "wip";
	spawned_vehicles = [];
 /#
	freezeframed_vehicles = get_vehicles_with_spawners();
	
	// freezeframe the vehicles because fileprint requires some frames.
	for ( i = 0;i < freezeframed_vehicles.size;i++ )
	{
		struct = spawnstruct();
		struct.vehicletype = freezeframed_vehicles[ i ].vehicletype;
		struct.origin = freezeframed_vehicles[ i ].origin;
		struct.angles = freezeframed_vehicles[ i ].angles;
		struct.currentnode = freezeframed_vehicles[ i ].currentnode;
		struct.detouringpath = freezeframed_vehicles[ i ].detouringpath;
		struct.target = freezeframed_vehicles[ i ].target;
		struct.targetname = freezeframed_vehicles[ i ].targetname;
		struct.script_forceyaw = freezeframed_vehicles[ i ].script_forceyaw;// remove me when models are rigged
		struct.spawner_id = freezeframed_vehicles[ i ].spawner_id;
		struct.speedmph = freezeframed_vehicles[ i ] getspeedmph();
		struct.ghettomodel_obj = freezeframed_vehicles[ i ].ghettomodel_obj;
		struct.script_angles = freezeframed_vehicles[ i ].script_angles;
		spawned_vehicles[ i ] = struct;
	}

	// break if detouring oddlike
	for ( i = 0;i < spawned_vehicles.size;i++ )
	{
		if ( ! isdefined( spawned_vehicles[ i ].currentnode.target ) && ! isdefined( spawned_vehicles[ i ].detouringpath ) )
			continue;// this vehicle is at the end of its path and doesn't really need to be in the quickload.
		targetnode = getvehiclenode( spawned_vehicles[ i ].currentnode.target, "targetname" );
		if ( !isdefined( targetnode ) )
			continue;
		if ( isdefined( targetnode.detoured ) )
			return false;
	}	
	starttime = string( gettime() + level.startdelay );

	// starts a map with a header and a blank worldspawn
	fileprint_map_start( level.script + "_dumpstart_" + startname );
	
	if ( !isdefined( level.start_dump_index ) )
		level.start_dump_index = 0;

	for ( i = 0;i < spawned_vehicles.size;i++ )
	{
		if ( spawned_vehicles[ i ] ishelicopter() )
			continue;// no helicopters in quickstarts yet.  I'm too scared of them. I should be able to use some sort of setspeed immediate but they won't be as close to accurate I don't think.
		if ( ! isdefined( spawned_vehicles[ i ].currentnode.target ) && ! isdefined( spawned_vehicles[ i ].detouringpath ) )
			continue;// this vehicle is at the end of its path and doesn't really need to be in the quickload.
		level.start_dump_index++ ;
		target = "dumpstart_node_target_" + level.start_dump_index;
		// vectors print as( 0, 0, 0 ) where they need to be converted to "0 0 0" for radiant to know what's up
		origin = fileprint_radiant_vec( spawned_vehicles[ i ].origin + ( 0, 0, 64 ) );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "script_delay", starttime );
			fileprint_map_keypairprint( "spawnflags", "1" );
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", "dumpstart_node" );
			fileprint_map_keypairprint( "_color", "1.000000 0.000000 0.000000" );
			fileprint_map_keypairprint( "target", target );
			fileprint_map_keypairprint( "spawner_id", spawned_vehicles[ i ].spawner_id );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );
			if ( isdefined( spawned_vehicles[ i ].ghettotags ) )
				fileprint_map_keypairprint( "script_ghettotag", "1" );
			fileprint_map_keypairprint( "lookahead", ".2" );// static lookahead for the short duration of the path shouldn't put it too out of sync
			fileprint_map_keypairprint( "speed", spawned_vehicles[ i ].speedmph  );
			fileprint_map_keypairprint( "script_noteworthy", startname );
		fileprint_map_entity_end();

		// project a node towards the next node in the chain for an onramp
		if ( isdefined( spawned_vehicles[ i ].detouringpath ) )
			nextnode = spawned_vehicles[ i ].detouringpath;
		else
			nextnode = getvehiclenode( spawned_vehicles[ i ].currentnode.target, "targetname" );
		origin = spawned_vehicles[ i ].origin;
		vect = vectornormalize( nextnode.origin - origin );
		nextorigin = origin + vector_multiply( vect, distance( origin, nextnode.origin ) / 5 ); 
// 		nextorigin = nextnode.origin; 

		origin = fileprint_radiant_vec( nextorigin + ( 0, 0, 64 ) );

		fileprint_map_entity_start();
			fileprint_map_keypairprint( "origin", origin );
			fileprint_map_keypairprint( "targetname", target );
			fileprint_map_keypairprint( "_color", "1.000000 0.000000 0.000000" );
			// fileprint_map_keypairprint( "spawner_id", spawned_vehicles[ i ].spawner_id );
			fileprint_map_keypairprint( "classname", "info_vehicle_node" );
			fileprint_map_keypairprint( "script_noteworthy", nextnode.targetname );
		fileprint_map_entity_end();
		
	}
	fileprint_end();
#/ 
	iprintlnbold( "start: " + startname + " dumped!" );
	return true;
}

origintostring( origin )
{
	string = "" + origin[ 0 ] + " " + origin[ 1 ] + " " + origin[ 2 ] + "";
	return string;
}

sync_vehicle()
{
	spawner = level.vehicle_spawners[ self.spawner_id ];
	
	node = self;
	targetnode = getvehiclenode( self.target, "targetname" );
	
	vehicle = vehicle_spawn( spawner );

	vehicle notify( "newpath" );
	vehicle.origin = self.origin + ( 0, 0, 555 );
	vehicle.angles = self.angles;
	vehicle attachpath( node );
	vehicle startpath();
	if ( isdefined( node.script_ghettotag ) )
		vehicle maps\jeepride_fx::apply_ghettotag();
	if ( isdefined( node.script_delay ) )
		level.startdelay = node.script_delay;
	detournode = getvehiclenode( targetnode.script_noteworthy, "targetname" );
	vehicle setswitchnode( targetnode, detournode );
	vehicle.attachedpath = detournode;
	vehicle thread vehicle_paths();
}



hillbump()
{
	// gag script for simulating bumps going down the hill
	self waittill( "trigger", other );
	other notify( "newjolt" );
	other endon( "newjolt" );
	other endon( "death" );
	
	if( flag("slam_zoom_done") ) 
	{
		level.playersride PlayRumbleOnEntity( "tank_rumble" );
		thread play_sound_in_space( "jeepride_grassride_thud", level.player.origin, 1 );
	}
	
	
	for ( i = 0;i < 6 ;i++ )
	{
		if( ! flag("slam_zoom_done") ) 
		{
			wait .2 + randomfloat( .2 );
			continue;
		}
		other joltbody( ( other.origin + ( 23, 33, 64 ) ), 0.6 );
		if ( other == level.playersride )
			earthquake( .15, 1, level.player.origin, 1000 );
		wait .2 + randomfloat( .2 );
		thread play_sound_in_space( "jeepride_grassride_through", level.player.origin, 1 );
	}
}

bridge_uaz_crash()
{
	node = getvehiclenode( "bridge_uaz_crash", "script_noteworthy" );
	node waittill( "trigger", other );
	other joltbody( other.origin + vector_multiply( anglestoforward( other.angles ), 48 ), 16 );
	thread play_sound_in_space( "jeepride_sideswipe", other.origin, 1 );
	Earthquake( .7, 2, other.origin, 2000 );
}

sideswipe()
{
	// sideswipes from other cars to players car bumping 
	self waittill( "trigger", other );

	other notify( "newjolt" );
	level.playersride notify( "newjolt" );

	other endon( "newjolt" );
	level.playersride endon( "newjolt" );
	
	other joltbody( ( level.playersride.origin + ( 0, 0, 64 ) ), 16 );
	level.playersride joltbody( ( other.origin + ( 0, 0, 64 ) ), 16 );
	dist = distance( other.origin, level.playersride.origin );
	sndorg = vector_multiply( vectornormalize( other.origin - level.playersride.origin ), dist / 2 ) + level.playersride.origin + ( 0, 0, 48 );
	thread play_sound_in_space( "jeepride_sideswipe", sndorg, 1 );
// 	iprintlnbold( "sideswipe" );
	earthquake( .45, 1, level.player.origin, 1000 );
	
	// 	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	level.player PlayRumbleOnEntity( "tank_rumble" );
}

jolter()
{
	// sideswipes from other cars to players car bumping 
	self waittill( "trigger", other );
	other joltbody( ( self.origin + ( 32, 32, 64 ) ), 3.5 );
}


#using_animtree( "generic_human" );   

deleteme()
{
	self delete();
}

speedbumps_setup()
{
	level.speedbumpcurrent = 0;
	level.speedbumps = getentarray( "speedbump", "targetname" );
}

dropspeedbump( origin, ignoreent )
{
	if ( level.flag[ "end_ride" ] )
		return;
	level.speedbumpcurrent++ ;
	if ( level.speedbumpcurrent >= level.speedbumps.size )
		level.speedbumpcurrent = 0;
	groundpos = bullettrace( origin + ( 0, 0, -32 ), ( origin + ( 0, 0, -100000 ) ), 0, ignoreent )[ "position" ];
// 	thread	draw_arrow_time( groundpos, groundpos + ( 0, 0, 25 ), ( 1, 1, 1 ), 5 );
	wait .5;// give time for truck they are riding to go.
	level.speedbumps[ level.speedbumpcurrent ].origin = groundpos + ( 0, 0, 4 );
}

// assure ragdoll. somehow ragdoll fails to initialize. 
// I suspect the unlink() and ragdoll at the same time isn't working.
ragdollragdollragdollragdollragdollragdoll() 
{
	if( getdvar("ragdoll_enable") == "0" )
	{
		self delete();
		return;
	}

	self endon( "death" ); 
	timer = gettime()+10000;
	while ( isdefined( self ) && gettime()<timer )
	{
		assert( !isdefined( self.magic_bullet_shield ) );
		assert( !ishero() );
		wait .05;
		self startragdoll();
	}
	self delete();
}

fx_wait_set( time, origin, angles, effectID, time2, origin2, angles2, effectID2 )
{
	_fx_wait_set( time, origin, angles, effectID );
	_fx_wait_set( time2, origin2, angles2, effectID2 );
}

_fx_wait_set( time, origin, angles, effectID, tag )
{
	tag = "polySurface1";// using axis model . may use other models later on
	// delay was suffering some roundoff issues I believe. storing and comparing gettime is more accurate that setting a delay on each effect
	if ( time < level.startdelay )
		return; 
	while ( gettime() + level.startdelay < time )
		wait .05;
	setfxplayer();
	level.fxplay_model.origin = origin;
	level.fxplay_model.angles = angles;
	playfxontag( level._effect[ effectID ], level.fxplay_model, tag );
}

createfxplayers( amount )
{
	level.Fxplay_model_array = [];
	level.Fxplay_index = 0;
	level.Fxplay_indexmax = amount;
	for ( i = 0 ; i < amount ; i++ )
	{
		model = spawn( "script_model", ( 0, 0, 0 ) );
		model setmodel( "axis" );
		model hide();
		level.Fxplay_model_array[ i ] = model;
	}
	return setfxplayer();
}

setfxplayer()
{
	level.fxplay_model = level.Fxplay_model_array[ level.Fxplay_index ];
	level.Fxplay_index++ ;
	if ( level.Fxplay_index >= level.Fxplay_indexmax )
		level.Fxplay_index = 0;
}

exploder_hack()
{
	if ( !isdefined( self.target ) )
		return;
	exploder = self.script_exploder;
	trigger = undefined;
	targets = getentarray( self.target, "targetname" );
	for ( i = 0; i < targets.size; i++ )
	{
		if ( targets[ i ].classname == "trigger_damage" )
			trigger = targets[ i ];
		break;
	}
	if ( !isdefined( trigger ) )
		return;
	trigger thread exploder_damager_trigger_by_hind();
	trigger waittill( "trigger" );
	exploder_loc( exploder );
}

exploder_damager_trigger_by_hind()
{
	self endon( "trigger" );
	while ( 1 )
	{
		self waittill( "damage", damage, attacker );
		if ( !isdefined( attacker ) )
			continue;
		if ( isdefined( attacker.vehicletype ) && attacker.vehicletype == "hind" )
			self notify( "trigger" );
	}
}

exploder_loc( exploder, bFast )
{
	if ( isdefined( bFast ) && bFast )
		level.exploder_fast[ exploder ] = true;
		
	level notify( "exploded_" + exploder );
	exploder( exploder );
}



exploder_animate()
{
	if ( !isdefined( self.target ) )
		return;
	assert( isdefined( self.script_exploder ) || isdefined( self.script_prefab_exploder ) );
	exploder = self.script_exploder;
	if ( !isdefined( exploder ) )
		exploder = self.script_prefab_exploder;
	exploder_linktargets();
	target = getstruct( self.target, "targetname" );
	if ( !isdefined( target ) )
		return;
	self.target = undefined;
	throwchain = setup_throwchain( target ); 
	
	level waittill( "exploded_" + exploder );
	linkent = spawn( "script_model", target.origin );
	assert( isdefined( target.angles ) );
	linkent.angles = target.angles;
	self linkto( linkent );
	
	exploder_showlinks();
	
	if(isdefined( self.is_end_tanker) )
		thread exploder_tankersparker_links();

// 	ghetto_animate_through_chain( throwchain, dummy, rate, nodelay, bFast )
	bFast = false;
	if ( isdefined( level.exploder_fast[ exploder ] ) && level.exploder_fast[ exploder ] )
		bFast = true;
	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "movekiller" )
		self thread enable_move_killer();
	ghetto_animate_through_chain( throwchain, linkent, undefined, undefined, bFast );
	self disable_move_killer();
}

exploder_tankersparker_links()
{
	sparkers = [];
	for ( i = 0; i < self.linkedtargets.size; i++ )
		if(self.linkedtargets[i].model == "axis")
			sparkers[sparkers.size] = self.linkedtargets[i];
	lastorg = self.origin;

	wait 9;
	
	incs = 7;
	inc = 0;
	
	while(lastorg != self.origin)
	{
		for ( i = 0; i < sparkers.size; i++ )
		{
			lastorg = self.origin;
			playfxontag( level._effect[ "tanker_sparker" ], sparkers[i], "polySurface1" );	
			inc++;
			if(inc == incs)
			{
				inc = 0;
				wait .05;
				if(lastorg != self.origin)
					break;
			}
		}
		sparkers = array_randomize( sparkers );
	}
	
}

disable_move_killer()
{
	self notify( "stop_move_killer" );	
}

enable_move_killer()
{
	self endon( "stop_move_killer" );	
	
	while ( 1 )
	{
		if ( level.player istouching( self ) )
		{
			level.player enableHealthShield( false );
			radiusDamage( level.player.origin, 8, level.player.health + 5, level.player.health + 5 );
			level.player enableHealthShield( true );
		}
		wait .05;
	}
}

exploder_showlinks()
{
	if ( ! self.linkedtargets.size )
		return;
		
	for ( i = 0; i < self.linkedtargets.size; i++ )
	{
		if ( isdefined( self.linkedtargets[i].script_noteworthy ) && self.linkedtargets[i].script_noteworthy == "tanker_sparkers" )
		{
			self.is_end_tanker = true;
			continue;
			
		}
		else if ( self.linkedtargets[i].model == "axis" )
			continue;
		if ( self.model == "axis" )
			continue;
		self.linkedtargets[ i ] show();
	}
}


exploder_linktargets()
{
	targets = getentarray( self.target, "targetname" );
	for ( i = 0; i < targets.size; i++ )
	{
		if ( targets[ i ].classname != "script_model" )
			continue;  
		targets[ i ] linkto( self );
		targets[ i ] hide();
	}
	self.linkedtargets = targets;
}


smokey_transition( intime, outtime, fullalphatime )
{
// 		overlay = newHudElem();
// 		overlay.x = 10;
// 		overlay.y = 0;
// 		overlay.alignx = "center";
// 		overlay.aligny = "middle";
// 		overlay.horzAlign = "center";
// 		overlay.vertAlign = "middle";
// 		scale = 40;
// 		overlay setshader( "jeepride_smoke_transition_overlay", scale, scale );
  						
// 	throwdown grid of solid particles.						
		spacing = 100;
		gridsize = 2;
		sort = 1;
		
		startref = ( ( gridsize - 1 ) / 2 * spacing * - 1 );
		for ( i = 0; i < gridsize ; i++ )
		for ( j = 0; j < gridsize ; j++ )
		{
			xpos = startref + i * spacing;
			ypos = startref + j * spacing;
			thread smoke_transition_elem( xpos, ypos, intime, outtime, fullalphatime, 1, sort );
			sort++ ;
		}

		// grid of transparentparticles.
		spacing = 90;
		gridsize = 3;
		
		startref = ( ( gridsize - 1 ) / 2 * spacing * - 1 );
		for ( i = 0; i < gridsize ; i++ )
		for ( j = 0; j < gridsize ; j++ )
		{
			xpos = startref + i * spacing;
			ypos = startref + j * spacing;
			thread smoke_transition_elem( xpos, ypos, intime, outtime, fullalphatime, randomfloatrange( .1, .8 ), sort );
			sort++ ;
		}


}

smoke_transition_elem( x, y, intime, outtime, fullalphatime, startalpha, sort )
{
	
		overlay = newHudElem();
		overlay.sort = sort;
		overlay.x = x;
		overlay.y = y;

		xdir = 1;
		ydir = 1;
		if ( overlay.x > 0 )
			xdir = -1;
		if ( overlay.y > 0 )
			ydir = -1;
		movementx = randomintrange( 200, 1200 ) * xdir;
		movementy = randomint( 200, 1200 ) * ydir;
		initscale = randomfloatrange( 2, 4 );
		scale = randomintrange( 400, 1000 );
		overlay setshader( "jeepride_smoke_transition_overlay", scale, scale );
		
		overlay.alignX = "center";
		overlay.alignY = "middle";
// 		overlay.horzAlign = "fullscreen";
// 		overlay.vertAlign = "fullscreen";
		overlay.horzAlign = "center";
		overlay.vertAlign = "middle";
		overlay.alpha = 0;
		overlay.foreground = true;
		overlay MoveOverTime( intime + outtime + fullalphatime );
		overlay.x += movementx;
		overlay.y += movementy;
		destscale = randomfloatrange( 4, 6 );
		scale = int( scale * destscale );
		if ( scale > 1000 )
			scale = 1000;
		overlay scaleovertime( intime + outtime + fullalphatime, scale, scale );	
		overlay fadeovertime( intime );
		overlay.alpha = startalpha;
		wait intime + fullalphatime;
		overlay fadeovertime( outtime );
		overlay.alpha = 0;
		wait outtime;
		overlay destroy();
		
}

// clears the model angles value for variable savings.
setup_throwchain_dummy_path( pathpoint )
{
	arraycount = 0;
	pathpoints = [];
	chain = [];
	while ( isdefined( pathpoint ) )
	{
		chain[ arraycount ] = pathpoint; 
		pathpoints[ arraycount ] = pathpoint; 
		arraycount++ ; 
		if ( isdefined( pathpoint.target ) )
			pathpoint = getstructarray( pathpoint.target, "targetname" )[ 0 ];
		else
			break; 
	}
	for ( i = 0; i < pathpoints.size; i++ )
		pathpoints[ i ] setup_throwchain_dummy_path_clearjunkvars();

	return pathpoints;	
}

setup_throwchain_dummy_path_clearjunkvars()
{
	self.angles = undefined;
	self.model = undefined;
// 	level.struct_remove[ level.struct_remove.size ] = self;
}

setup_throwchain( pathpoint )
{
	arraycount = 0;
	pathpoints = [];
	chain = [];
	while ( isdefined( pathpoint ) )
	{
		if ( !isdefined( pathpoint.angles ) )
			pathpoint.angles = ( 0, 0, 0 );
		chain[ arraycount ] = pathpoint; 
		pathpoints[ arraycount ] = pathpoint; 
		arraycount++ ; 
		if ( isdefined( pathpoint.target ) )
			pathpoint = getstructarray( pathpoint.target, "targetname" )[ 0 ];
		else
			break;
	}
	for ( i = 0; i < pathpoints.size; i++ )
		pathpoints[ i ] setup_throwchain_clearjunkvars();
	return pathpoints;
}

setup_throwchain_clearjunkvars()
{
	self.model = undefined;
}

ghetto_animate_through_chain( throwchain, dummy, rate, nodelay, bFast )
{
	if ( !isdefined( bFast ) )
		bFast = false;
	if ( !isdefined( nodelay ) )
		nodelay = false;
	dummy endon( "death" );
	if ( !isdefined( rate ) )
		rate = 500;
	gravity = false;
	if ( bFast )
		nodelay = 1;
		
	dummy.linkedobject = self; //pass them through.. jeesh I'm tired right now. 
		
	for ( i = 0 ; i < throwchain.size - 1 ; i++ )
	{
		script_accel_fraction = 0;
		script_decel_fraction = 0;
		org = throwchain[ i ];
		dest = throwchain[ i + 1 ];
		dir = 0;
		
		if ( isdefined( org.speed ) )
			rate = org.speed;
		
		endrate = rate;
		
		if ( isdefined( org.script_attackmetype ) )
			dummy.script_attackmetype = org.script_attackmetype;
		else
			dummy.script_attackmetype = undefined;
			
		if ( isdefined( org.offshoot_ent ) )
			dummy.offshoot_ent = org.offshoot_ent;
			
		if ( isdefined( org.script_shotcount ) )
			dummy.script_shotcount = org.script_shotcount;
			
		if ( isdefined( org.script_exploder ) )
			thread exploder_loc( org.script_exploder );
		else if ( isdefined( org.script_prefab_exploder ) )
			thread exploder_loc( org.script_prefab_exploder );

		if ( isdefined( org.script_parameters ) && org.script_parameters == "badplace" )
		{
			if ( !isdefined( org.radius ) )
				org.radius = 600;
			BadPlace_Cylinder( "dummypath_badplace", 1, org.origin, org.radius, 512, "allies", "axis" );
		}

		if ( isdefined( org.script_flag_wait ) )
			flag_wait( org.script_flag_wait );
			
		if ( ! nodelay )
		if ( isdefined( org.script_delay ) )
			wait org.script_delay;
		if ( isdefined( org.script_sound ) )
		{
			if( org.script_sound == "bricks_crumbling" )
			{
				dummy thread flag_sound(org.script_sound);
			}
			else if ( isdefined( org.script_parameters ) && org.script_paramters == "in_space" )
				dummy thread play_sound_in_space( org.script_sound, org.origin );
			else
				dummy thread play_sound_on_entity( org.script_sound );
			
		}
		
		if ( isdefined( org.script_noteworthy ) )
		{
			if ( org.script_noteworthy == "gravity" )
				gravity = true;
		}
		if(dummy.model == "vehicle_uaz_open_for_ride" && i == 0)
			dummy thread ride_smoker();
		if ( isdefined( org.script_accel_fraction ) )
			script_accel_fraction = org.script_accel_fraction;
		if ( isdefined( org.script_decel_fraction ) )
			script_decel_fraction = org.script_decel_fraction;
			
// 		println( "speed of ghettoanimated: " + rate );

		angles = ( 0, 0, 0 );
		
		if ( isdefined( dest.angles ) )
			angles = dest.angles;

		if ( bFast )
		{
			dummy.origin = dest.origin;
			dummy.angles = angles;
		}
		else
			dummy movewithrate( dest.origin, angles, rate, endrate, gravity, script_accel_fraction, script_decel_fraction );

		if ( isdefined( dest.script_disconnectpaths ) )
			self script_disconnectpaths( dest.script_disconnectpaths );

		if ( isdefined( dest.script_noteworthy ) )
		{
			level notify( dest.script_noteworthy );
			if ( dest.script_noteworthy == "delete" )
			{
				self delete();
				return;
			}
		}
		
		if ( isdefined( dest.script_flag_set ) )
			flag_set( dest.script_flag_set );
		
	}
}

script_disconnectpaths( script_disconnectpaths )
{
	if ( self.classname == "script_model" )
		return;
	if ( script_disconnectpaths )
	{
		self connectpaths();
		self disconnectpaths();
	}
	else
		self connectpaths();
}

bridge_bumper()
{
	bridgebumper = spawn( "script_origin", level.player.origin );
	bridgebumper linkto( level.player );
	
	while ( 1 )
	{
		level waittill( "bridge_bump" );
		bridgebumper PlayRumbleOnEntity( "jeepride_bridgesink" );
		earthquake( .25, 1, level.player.origin, 1000 );
	}
}

_notsolid()
{
	self notsolid();
}
	
movewithrate( dest, destang, moverate, endrate, gravity, accelfraction, decelfraction )
{
	self notify( "newmove" );
	self endon( "newmove" );
	if ( !isdefined( gravity ) )
		gravity = false;
	if ( !isdefined( accelfraction ) )
		accelfraction = 0;
	if ( !isdefined( decelfraction ) )
		decelfraction = 0;
	if ( !isdefined( endrate ) )
		endrate = moverate;
	self.movefinished = false;
	// moverate = units / persecond
	if ( !isdefined( moverate ) )
		moverate = 200;

	dist = distance( self.origin, dest );
	movetime = dist / moverate;
	movevec = vectornormalize( dest - self.origin );

	accel = 0;
	decel = 0;

	if ( accelfraction > 0 )
		accel = movetime * accelfraction;
	if ( decelfraction > 0 )
		decel = movetime * decelfraction;
		
		
		
	if ( gravity )
	{
		assert( isdefined( self.velocity ) );
		self movegravity( self.velocity, movetime );
		self rotateto( destang, movetime, accel, decel );

		if ( isdefined( self.linkedobject.linkedtargets ) )
			array_thread( self.linkedobject.linkedtargets, ::_notsolid );
			
 		while ( self.origin[ 2 ] > dest[ 2 ]+ 512 ) // yay magic number
 			wait .05; 
		while ( 1 )
		{
			lastdest = self.origin;
			wait .05;
			trace = BulletTrace( lastdest, self.origin, false, self.linkedobject );
			if ( isdefined(trace["entity"]) )
				continue;
			if ( trace[ "fraction" ] != 1 )
				break;
		}
		
		if ( isdefined( self.linkedobject.linkedtargets ) )
			array_thread( self.linkedobject.linkedtargets, ::deleteme );// they look nasty on the bridge pieces
		self moveto( self.origin + ( 0, 0, 24 ), .5, 0, 0 ); 
		self rotateto( destang, .5, 0, 0 ); 
	}
	else
	{
		self moveto( dest, movetime, accel, decel );
		self rotateto( destang, movetime, accel, decel );
		wait movetime;
	}

	if ( !isdefined( self ) )
		return; 
	self.velocity = vector_multiply( movevec, dist / movetime );
	self.movefinished = true;
}

clear_all_vehicles_but_heros_and_hind()
{
	level notify( "clear_all_vehicles_but_heros" );
	vehicles = getentarray( "script_vehicle", "classname" );
	guystoremove = [];
	for ( i = 0; i < vehicles.size; i++ )
	{
		if ( vehicles[ i ].vehicletype == "hind" )
		{
			self notify( "gunner_new_target" );// clears his firing
			continue;
		}
		riders = vehicles[ i ].riders;
		guystoremove = [];
		for ( j = 0; j < riders.size; j++ )
		{
			if ( riders[ j ] ishero() )
			{
				guystoremove[ guystoremove.size ] = riders[ j ];
				continue;
			}
			if ( isdefined( riders[ j ].magic_bullet_shield ) && riders[ j ].magic_bullet_shield )
				riders[ j ] stop_magic_bullet_shield();
			riders[ j ] delete();
		}
		for ( j = 0; j < guystoremove.size; j++ )
			guy_force_remove_from_vehicle( vehicles[ i ], guystoremove[ j ] );
		vehicles[ i ] vehicle_clear_truckjunk();
		vehicles[ i ] delete();
	}
}

vehicle_clear_truckjunk()
{
	junk = self.truckjunk;
	if ( isdefined( self.jeepride_linked_weapon ) )
		self.jeepride_linked_weapon delete();
	if ( !isdefined( junk ) )
		return;
	array_thread( self.truckjunk, ::deleteme );
	
}

guy_force_remove_from_vehicle( vehicle, guy, origin )
{
	vehicle notify( "forcedremoval" );
	vehicle.riders = array_remove( vehicle.riders, guy );
	vehicle.usedPositions[ guy.pos ] = false;
	guy notify( "jumpedout" );
	guy notify( "newanim" );
	if ( isai( guy ) )
		guy allowedstances( "stand", "crouch", "prone" );
	guy.ridingvehicle = undefined;
	guy.drivingVehicle = undefined;
	guy.pos = undefined;
}

startgen()
{
	assert( isdefined( self.script_parameters ) );
	self waittill( "trigger" );
	while ( !jeepride_start_dump( self.script_parameters ) )
		wait.05;
}

ClearEnemy_loc()
{
	self ClearEnemy();
}

tire_deflate()
{
	if ( self.vehicletype != "bm21_troops" )
		return;
	if ( flag( "end_ride" ) )	
		return;
	level endon( "end_ride" );
	level.tiredefeffectcount = 0;
	self endon( "death" );
	self endon( "stop_tire_deflate" );
	while ( 1 )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		
		if ( !isdefined( tagName ) || !isdefined( modelName ) )
			return;
			
		if ( attacker == level.player && issubstr( tagname, "_wheel" ) )
			thread tire_deflater( direction_vec, point, tagName );
// 	 	iprintlnbold( "hit_tag: " + tagName );
// 	 	iprintlnbold( "hit_model: " + modelName );

	}
}

tire_deflater( direction_vec, point, tagName )
{
	if ( level.tiredefeffectcount > 1 )
		return;
	level.tiredefeffectcount++ ;
	self endon( "stop_tire_deflate" );
	model = spawn( "script_model", point );
	model setmodel( "axis" );
	model hide();
	model playsound( "mtl_steam_pipe_hit" );
	self thread tire_deflater_interuptable( model );
// 	model linkto( self, tagName, point - self gettagorigin( tagName ), vectortoangles( direction_vec ) - self gettagangles( tagName )  );
	model linkto( self, tagName, ( 32, 0, 0 ), ( 0, 0, 0 )  );
	self joltbody( ( self.origin + ( 23, 33, 64 ) ), 1 );

	PlayFXOnTag( level._effect[ "tire_deflate" ], model, "polySurface1" );
	wait 3;
	level.tiredefeffectcount -- ;
	model delete();
}

tire_deflater_interuptable( model )
{
	model endon( "death" );
	self waittill( "stop_tire_deflate" );
	model delete();
}


nodisconnectpaths()
{
	self waittill( "trigger", other );
	other.dontDisconnectPaths = true;
}


vehicle_mgmanage()
{
	self endon( "death" );
	self endon( "c4_detonation" );
	self endon( "stop_thinking" );
	self endon( "bridge_zakhaev_setup" );
	// assumes enemy vehicle with one turret;
	mg = self.mgturret[ 0 ];
	while ( 1 )
	{
		friends = getaiarray( "axis" );
		if ( mg_check_for_friends( mg, friends ) )
			self mgoff();
		else
			self mgon();
		wait .05;
	}
}

mg_check_for_friends( mg, friends )
{
	for ( i = 0; i < friends.size; i++ )
		if ( within_fov( mg gettagorigin( "tag_flash" ), mg gettagangles( "tag_flash" ), friends[ i ] geteye(), cos( 10 )  ) )
			return true;
	return false;
}


// ganked from ICBM

vehicle_turret_think()
{
	self endon( "death" );
	self endon( "c4_detonation" );
	self endon( "stop_thinking" );
	self endon( "bridge_zakhaev_setup" );

	self.turretFiring = false;
	eTarget = undefined;
	aExcluders = [];

	aExcluders[ 0 ] = level.price;
	aExcluders[ 1 ] = level.griggs;
	aExcluders[ 2 ] = level.gaz;

	currentTargetLoc = undefined;
	
	self setTurretTargetEnt( level.player );
	self thread vehicle_mgmanage();

	while ( true )
	{
		wait( 0.05 );
		/* -- -- -- -- -- -- -- -- -- -- -- - 
		GET A NEW TARGET UNLESS CURRENT ONE IS PLAYER
		 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
		eTarget = level.player;
		if ( ( isdefined( eTarget ) ) && ( eTarget == level.player ) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self gettagorigin( "tag_flash" ), level.player geteye(), true, self );
			if ( !sightTracePassed )
				eTarget = self vehicle_get_target( aExcluders );
		}

		/* -- -- -- -- -- -- -- -- -- -- -- - 
		ROTATE TURRET TO CURRENT TARGET
		 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
		if ( isalive( eTarget ) )
		{
			targetLoc = eTarget.origin + ( 0, 0, 32 );
			self setTurretTargetVec( BulletSpread( self gettagorigin( "tag_flash" ) , targetLoc , 2.0 )  );
			
			if ( getdvar( "debug_bmp" ) == "1" )
				thread draw_line_until_notify( self.origin + ( 0, 0, 32 ), targetLoc, 1, 0, 0, self, "stop_drawing_line" );
			
			fRand = ( randomfloatrange( 2, 3 ) );
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/* -- -- -- -- -- -- -- -- -- -- -- - 
			FIRE MAIN CANNON OR MG
			 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
			if ( isalive( eTarget ) )
			{
				if ( distancesquared( eTarget.origin, self.origin ) <= level.bmpMGrangeSquared )
				{
					wait( .5 );
					if ( !self.turretFiring )
						self thread vehicle_fire_main_cannon();			
				}
				else
				{
					if ( !self.turretFiring )
						self thread vehicle_fire_main_cannon();	
				}				
			}
			else
				eTarget = self vehicle_get_target( aExcluders );
		}
	}
}

vehicle_fire_main_cannon( iBurstNumber )
{
	self endon( "death" );
	self endon( "c4_detonation" );
	// self notify( "firing_cannon" );
	// self endon( "firing_cannon" );
	
	iFireTime = weaponfiretime( "bmp_turret" );
	assert( isdefined( iFireTime ) );
	
	if ( !isdefined( iBurstNumber ) )
		iBurstNumber = randomintrange( 3, 8 );
	
	self.turretFiring = true;
	i = 0;
	while ( i < iBurstNumber )
	{
		i++ ;
		wait( iFireTime );
		self fireWeapon();
	}
	self.turretFiring = false;
}

vehicle_get_target( aExcluders )
{
	// getEnemyTarget( 																	fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )

	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, true, false, false, aExcluders );
	return eTarget;
}

vehicle_badplacer()
{
	target = getvehiclenode( self.target, "targetname" );
	target waittill( "trigger", other );
	radius = 500;
	if ( isdefined( self.radius ) )
		radius = self.radius;
	duration = 3;
	if ( isdefined( self.script_offtime ) )
		duration = self.script_offtime;
	
	BadPlace_Cylinder( "badplacer_" + target.targetname, duration, self.origin, radius, 300, "allies", "axis" );
	
}

path_array_setup_loc( pathpoint )
{
	get_func = ::get_from_entity;
	arraycount = 0;
	pathpoints = [];
	while ( isdefined( pathpoint ) )
	{
		pathpoints[ arraycount ] = pathpoint; 
		arraycount++ ; 

		if ( isdefined( pathpoint.target ) )
			pathpoint = [[ get_func ]]( pathpoint.target );
		else
			break; 
	}
	return pathpoints;
}

stop_looping_deathfx()
{
	deathfx_ent() delete();
}


guy_hidetoback_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).hidetoback );
}

guy_hidetoback_startingback( guy, pos )
{
	animpos = anim_pos( self, pos );
		
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	assert( isdefined( animpos.hidetoback ) );
	animontag( guy, animpos.sittag, animpos.hidetoback );
	thread guy_back_attack( guy, pos );
}


guy_back_attack( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	assert( isdefined( animpos.back_attack ) );
	while ( 1 )
		animontag( guy, animpos.sittag, animpos.back_attack );
}

guy_backtohide_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).backtohide );
}


guy_hide_starting_back( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	animpos = anim_pos( self, pos );
	
	assert( isdefined( animpos.backtohide ) );
		
	animontag( guy, animpos.sittag, animpos.backtohide );
	thread guy_hide_attack_back( guy, pos );	
}

guy_hide_startingleft( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	animpos = anim_pos( self, pos );
	if ( !isdefined( animpos.backtohide ) )
		return guy_idle( guy, pos );
	
	animontag( guy, animpos.sittag, animpos.backtohide );
	thread guy_hide_attack_left( guy, pos );	
		
}

guy_backtohide( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	assert( isdefined( animpos.backtohide ) );
	animontag( guy, animpos.sittag, animpos.backtohide );
	thread guy_idle( guy, pos );
}


guy_react( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	assert( isdefined( animpos.react ) );
	animontag( guy, animpos.sittag, animpos.react );
	thread guy_idle( guy, pos );
}

guy_react_check( guy, pos )
{
	return isdefined( anim_pos( self, pos ).react );	
}


guy_hide_attack_back_check( guy, pos )
{
	return isdefined( anim_pos( self, pos ).hide_attack_back );	
}

guy_hide_attack_back( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	animpos = anim_pos( self, pos );
	assert( isdefined( animpos.hide_attack_back ) );
		
	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_back_occurrence ) )
		{
			theanim = randomoccurrance( guy, animpos.hide_attack_back_occurrence );
			animontag( guy, animpos.sittag, animpos.hide_attack_back[ theanim ] );
		}
		else
			animontag( guy, animpos.sittag, animpos.hide_attack_back );
	}		
}

guy_hide_attack_forward_check( guy, pos )
{
	return isdefined( anim_pos( self, pos ).hide_attack_forward );	
}

guy_hide_attack_forward( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	
	assert( isdefined( animpos.hide_attack_forward ) );

	while ( 1 )
		animontag( guy, animpos.sittag, animpos.hide_attack_forward );
}

guy_hide_attack_left_check( guy, pos )
{
	return isdefined( anim_pos( self, pos ).hide_attack_left );
}

guy_hide_attack_left( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	
	assert( isdefined( animpos.hide_attack_left ) );

	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_left_occurrence ) )
		{
			theanim = randomoccurrance( guy, animpos.hide_attack_left_occurrence );
			animontag( guy, animpos.sittag, animpos.hide_attack_left[ theanim ] );
		}
		else
			animontag( guy, animpos.sittag, animpos.hide_attack_left );
	}
}

guy_hide_attack_left_standing( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	
	assert( isdefined( animpos.hide_attack_left_standing ) );
	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_left_standing_occurrence ) )
		{
			theanim = randomoccurrance( guy, animpos.hide_attack_left_standing_occurrence );
			animontag( guy, animpos.sittag, animpos.hide_attack_left_standing[ theanim ] );
		}
		else
			animontag( guy, animpos.sittag, animpos.hide_attack_left_standing );
	}
}

remember_weaponsondeath( other )
{
	if ( !isdefined( self.weapon ) )
		return;
	weapon = [];
	weapon[ 0 ] = "weapon_" + self.weapon;
	weapon[ 1 ] = "weapon_" + self.primaryweapon;
	weapon[ 2 ] = "weapon_" + self.secondaryweapon;
	
	level.potentialweaponitems = array_merge( level.potentialweaponitems, weapon );
}

remove_all_weapons()
{
	// maybe this should be a made better and into a utility function. as it is here it's a bit too hackeryish.
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_fraggrenade" );
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_brick_bomb" );
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_claymore" );
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_flash_grenade" );
	level.potentialweaponitems = array_add( level.potentialweaponitems, "weapon_smoke_grenade_american" );
	
	weapontoremove = undefined;
	for ( i = 0; i < level.potentialweaponitems.size; i++ )
	{
		println( "weapon removed: " + level.potentialweaponitems[ i ] );
		weapontoremove = getentarray( level.potentialweaponitems[ i ], "classname" );
		if ( !weapontoremove.size )
			continue;
		array_levelthread( weapontoremove, ::deleteent );
	}
	
}

add_death_function( func, param1, param2, param3 )
{
	array = [];
	array[ "func" ] = func;
	array[ "params" ] = 0;
	
	if ( isdefined( param1 ) )
	{
		array[ "param1" ] = param1;
		array[ "params" ]++ ;
	}
	if ( isdefined( param2 ) )
	{
		array[ "param2" ] = param2;
		array[ "params" ]++ ;
	}
	if ( isdefined( param3 ) )
	{
		array[ "param3" ] = param3;
		array[ "params" ]++ ;
	}
	self.deathFuncs[ self.deathFuncs.size ] = array;
}

#using_animtree( "vehicles" );   
freeOnEnd()
{
	if ( level.flag[ "end_ride" ] )
		return;
	self endon( "end_ride" );
	self endon( "no_free_on_end" );
	self waittill( "reached_end_node" );
	self freevehicle();
	self clearanim( %root, 0.5 );
	if ( isdefined( self.modeldummyon ) && self.modeldummyon )
		self hide();
}



hidemeuntilflag()
{
	assert( isdefined( self.script_flag_wait ) );
	self waittill( "trigger", other );
	for ( i = 0; i < other.riders.size; i++ )
		other.riders[ i ] hide();
	other hide();
	flag_wait( self.script_flag_wait );
	other show();
	for ( i = 0; i < other.riders.size; i++ )
		other.riders[ i ] show();
}

ishero()
{
	if ( !isdefined( self.script_noteworthy ) )
		return false;
	return( 
						self.script_noteworthy == "price"
				 || self.script_noteworthy == "griggs" 
				 || self.script_noteworthy == "gaz"
				 || self.script_noteworthy == "medic"
				 );
}

crazy_bmp()
{
	self waittill( "trigger", other );
	if ( flag( "bridge_zakhaev_setup" ) )
		return;
	level.crazy_bmp = other;
	other thread vehicle_turret_think();

}

clouds_off()
{
	self waittill( "trigger" );
	array_thread( getfxarraybyID( "cloud_bank_far" ), ::pauseEffect );
}

clouds_on()
{
	self waittill( "trigger" );
	array_thread( getfxarraybyID( "cloud_bank_far" ), ::restartEffect );
}

shot_in_the_head_point_blank( guy, killedguy )
{
	org = guy gettagorigin( "tag_flash" );
	angles = guy gettagangles( "tag_flash" );
	PlayFX( level._effect[ "griggs_brains" ], org, anglestoforward( angles ) );
	killedguy waittillmatch( "single anim", "end" );
	killedguy blead();
}

blead_on_death( offset )
{
	if( !isdefined(offset) )
		offset = 45;
	self waittill ("death");
	self blead( offset );
}

blead( offset )
{
	if( !isdefined(offset) )
		offset = 45;
	org = groundpos( self gettagorigin( "J_Head" ) );
	org+= vector_multiply( vectornormalize( flat_origin(level.player.origin)-flat_origin(org ) ),offset );
	wait .5;
	PlayFX( level._effect[ "bloodpool" ], org+(0,0,-.95), ( 0, 0, 1 ) );
}

shot_in_the_head( guy )
{
	// I don't know. 	
	org = guy gettagorigin( "TAG_EYE" );
	angles = guy gettagangles( "TAG_EYE" );
	PlayFX( level._effect[ "griggs_brains" ], org, vector_multiply( anglestoforward( angles ), -2 ) );
// 	PlayFXOnTag( level._effect[ "griggs_brains" ], guy, "TAG_EYE"  );
}



save_fail_on_rpgguy()
{
	return false;
}

alltheweapons()
{
	weapons = [];
	weapons[ weapons.size ] = "weapon_ak47";
	weapons[ weapons.size ] = "weapon_ak74u";
	weapons[ weapons.size ] = "weapon_g36c";
	weapons[ weapons.size ] = "weapon_m16_basic";
	weapons[ weapons.size ] = "weapon_m16_grenadier";
	weapons[ weapons.size ] = "weapon_m4_grunt";
	weapons[ weapons.size ] = "weapon_m4_silencer_acog";
	weapons[ weapons.size ] = "weapon_m4_grenadier";
	weapons[ weapons.size ] = "weapon_g3";
	weapons[ weapons.size ] = "weapon_m4m203_silencer";
	weapons[ weapons.size ] = "weapon_m4m203_silencer_reflex";
	weapons[ weapons.size ] = "weapon_m4_silencer";
	weapons[ weapons.size ] = "weapon_ak47_grenadier";
	weapons[ weapons.size ] = "weapon_saw";
	weapons[ weapons.size ] = "weapon_rpd";
	weapons[ weapons.size ] = "weapon_at4";
	weapons[ weapons.size ] = "weapon_stinger";
	weapons[ weapons.size ] = "weapon_winchester1200";
	weapons[ weapons.size ] = "weapon_rpg";
	weapons[ weapons.size ] = "weapon_mp5";
	weapons[ weapons.size ] = "weapon_p90";
	weapons[ weapons.size ] = "weapon_beretta";
	weapons[ weapons.size ] = "weapon_dragunov";
	weapons[ weapons.size ] = "weapon_m14_scoped";
	weapons[ weapons.size ] = "weapon_m40a3";
	weapons[ weapons.size ] = "weapon_remington700";
	weapons[ weapons.size ] = "weapon_usp";
	weapons[ weapons.size ] = "weapon_uzi";
	weapons[ weapons.size ] = "weapon_uzi_sd";
	weapons[ weapons.size ] = "weapon_skorpion";
	weapons[ weapons.size ] = "weapon_m60e4";
	weapons[ weapons.size ] = "weapon_c4";
	weapons[ weapons.size ] = "weapon_claymore";
	weapons[ weapons.size ] = "weapon_mp5_silencer";
	weapons[ weapons.size ] = "weapon_p90_silencer";
	weapons[ weapons.size ] = "weapon_colt45";
	weapons[ weapons.size ] = "weapon_deserteagle";
	weapons[ weapons.size ] = "weapon_m1014";
	weapons[ weapons.size ] = "weapon_javelin";
	weapons[ weapons.size ] = "weapon_barrett";
	return weapons;
}

exploder_phys()
{
	if ( self.classname != "script_model" )
		return;
		
	if ( !issubstr( self.model, "com_debris" ) )
		return;
		
	assert( isdefined( self.script_exploder ) );
	
	level waittill( "exploded_" + self.script_exploder );
	
	wait .1;// before turning it into a phys obj let exploder make it visible. 
	
	self PhysicsLaunch( self.origin, ( 0, 0, 1 ) );// simple nudge just turns it into physics object
	
}

layer_of_death_ai_mode( baseaccuracy, playerisfavoriteenemy )
{
	self.baseaccuracy = baseaccuracy;
	if ( playerisfavoriteenemy )
		self.favoriteenemy = level.player;
	else
		self.favoriteenemy = undefined;
}

layer_of_death_getlayer( index )
{
	layer = [];
	layer[ 0 ] = [];
	layer[ 1 ] = [];
	layer[ 2 ] = [];
	layer[ 3 ] = [];


	switch( level.gameSkill )
	{
		case 0:// easy
			layer[ 0 ][ "baseaccuracy" ] = 1;
			layer[ 0 ][ "threatbias" ] = 150;
			layer[ 0 ][ "playerisfavoriteenemy" ] = false;
			layer[ 1 ][ "baseaccuracy" ] = 1;
			layer[ 1 ][ "threatbias" ] = 150;
			layer[ 1 ][ "playerisfavoriteenemy" ] = false;
			layer[ 2 ][ "baseaccuracy" ] = 1.2;
			layer[ 2 ][ "threatbias" ] = 150;
			layer[ 2 ][ "playerisfavoriteenemy" ] = false;
			layer[ 3 ][ "baseaccuracy" ] = 2;
			layer[ 3 ][ "threatbias" ] = 250;
			layer[ 3 ][ "playerisfavoriteenemy" ] = false;
			layer[ 4 ][ "baseaccuracy" ] = 3;
			layer[ 4 ][ "threatbias" ] = 400;
			layer[ 4 ][ "playerisfavoriteenemy" ] = true;
		case 1:// regular
			layer[ 0 ][ "baseaccuracy" ] = 1;
			layer[ 0 ][ "threatbias" ] = 150;
			layer[ 0 ][ "playerisfavoriteenemy" ] = false;
			layer[ 1 ][ "baseaccuracy" ] = 1.1;
			layer[ 1 ][ "threatbias" ] = 165;
			layer[ 1 ][ "playerisfavoriteenemy" ] = false;
			layer[ 2 ][ "baseaccuracy" ] = 1.7;
			layer[ 2 ][ "threatbias" ] = 200;
			layer[ 2 ][ "playerisfavoriteenemy" ] = false;
			layer[ 3 ][ "baseaccuracy" ] = 2;
			layer[ 3 ][ "threatbias" ] = 250;
			layer[ 3 ][ "playerisfavoriteenemy" ] = false;
			layer[ 4 ][ "baseaccuracy" ] = 3;
			layer[ 4 ][ "threatbias" ] = 400;
			layer[ 4 ][ "playerisfavoriteenemy" ] = true;		
			break;	
		case 2:// hardened
			layer[ 0 ][ "baseaccuracy" ] = 1;
			layer[ 0 ][ "threatbias" ] = 150;
			layer[ 0 ][ "playerisfavoriteenemy" ] = false;
			layer[ 1 ][ "baseaccuracy" ] = 1.3;
			layer[ 1 ][ "threatbias" ] = 175;
			layer[ 1 ][ "playerisfavoriteenemy" ] = false;
			layer[ 2 ][ "baseaccuracy" ] = 1.7;
			layer[ 2 ][ "threatbias" ] = 200;
			layer[ 2 ][ "playerisfavoriteenemy" ] = false;
			layer[ 3 ][ "baseaccuracy" ] = 2;
			layer[ 3 ][ "threatbias" ] = 250;
			layer[ 3 ][ "playerisfavoriteenemy" ] = false;
			layer[ 4 ][ "baseaccuracy" ] = 3;
			layer[ 4 ][ "threatbias" ] = 400;
			layer[ 4 ][ "playerisfavoriteenemy" ] = true;		
			break;	
		case 3:// veteran
			layer[ 0 ][ "baseaccuracy" ] = 1;
			layer[ 0 ][ "threatbias" ] = 150;
			layer[ 0 ][ "playerisfavoriteenemy" ] = false;
			layer[ 1 ][ "baseaccuracy" ] = 1.3;
			layer[ 1 ][ "threatbias" ] = 175;
			layer[ 1 ][ "playerisfavoriteenemy" ] = false;
			layer[ 2 ][ "baseaccuracy" ] = 1.7;
			layer[ 2 ][ "threatbias" ] = 200;
			layer[ 2 ][ "playerisfavoriteenemy" ] = false;
			layer[ 3 ][ "baseaccuracy" ] = 2;
			layer[ 3 ][ "threatbias" ] = 250;
			layer[ 3 ][ "playerisfavoriteenemy" ] = false;
			layer[ 4 ][ "baseaccuracy" ] = 3;
			layer[ 4 ][ "threatbias" ] = 400;
			layer[ 4 ][ "playerisfavoriteenemy" ] = true;		
			break;
			default:
				assertmsg( "what game difficulty?" );	
	}
	
	return layer[ index ];
}

layer_of_death( index )
{
	level endon( "murdering_player" );
	while ( 1 )
	{
		self waittill( "trigger" );
		set_layer_of_death( index );
	}
}

layer_of_death_timed_kill( timer )
{
	level endon ("layer_of_death");
	wait timer;
	player_kill();
}

set_layer_of_death( index )
{
	if ( level.ai_in_boundry )
		return;
	level.last_layer_of_death = index;
	layer = layer_of_death_getlayer( index );
// 		iprintlnbold( "layer of death: " + index );
	array_thread( getaiarray( "axis" ), ::layer_of_death_ai_mode, layer[ "baseaccuracy" ], layer[ "playerisfavoriteenemy" ] );
	level.player.threatbias = layer[ "threatbias" ]; 
	level notify( "layer_of_death" );
	if(index == 4)
		thread layer_of_death_timed_kill( 4 );
	level waittill( "layer_of_death" );
}

encroacher()
{
	encroachtimer = 10;
	encroacher = [];
	encroacher[ 0 ] = "bridge_encroach_03";
	encroacher[ 1 ] = "bridge_encroach_02";
	encroacher[ 2 ] = "bridge_encroach_01";

	level endon( "bridge_zakhaev_setup" );
	level endon( "murdering_player" );
	
	switch( level.gameSkill )
	{
		case 0:// easy
			encroachtimer = 25;
			break;	
		case 1:// regular
			encroachtimer = 17;
			break;	
		case 2:// hardened
			encroachtimer = 12;
			break;	
		case 3:// veteran
			encroachtimer = 8;
			break;	
	}
	
	// hacking. they no longer encroach they just sort of fall back to a more defensive position. 
	encroachtimer = 20;
	
	for ( i = 0; i < encroacher.size; i++ )
	{
		activate_trigger_with_targetname( encroacher[ i ] );
// 		iprintlnbold( "encroaching, level: " + i );
		wait encroachtimer;
	}

}
unload_single_guy()
{
	guy = undefined;
	for ( i = 0; i < self.riders.size; i++ )
		if ( !isdefined( self.riders[ i ].ragdoll_getout_death ) )
		{
			guy = self.riders[ i ];
			break;
		}
	
	if ( !isdefined( guy ) )
		return;
// 	guy = self.riders[ 0 ];
	
	assert( isdefined( guy.pos ) );
	self.groupedanim_pos = guy.pos;
	self notify( "groupedanimevent", "unload" );
	return guy;
}


unloadmanager()
{
	level.drone_unloader++ ;
	self waittill( "trigger", other );
	other.dontunloadonend = true;
	level.vehicles_with_drones[ level.vehicles_with_drones.size ] = other;
}


bridge_vehiclde_drone_unloader()
{
	level endon( "bridge_zakhaev_setup" );
	index = 0;
	
	ai_around = 12;
	switch( level.gameSkill )
	{
		case 0:// easy
			ai_around = 10;
			break;	
		case 1:// regular
			ai_around = 11;
			break;	
		case 2:// hardened
			ai_around = 12;
			break;	
		case 3:// veteran
			ai_around = 13;
			break;	
	}
	


	while ( 1 )
	{
		while ( !level.vehicles_with_drones.size )
			wait .05;
		
		if ( getaiarray( "axis" ).size + count_unload_que() < ai_around && level.vehicles_with_drones.size )
			level.vehicles_with_drones[ index ] unload_single_guy();
			
		if ( ! level.vehicles_with_drones[ index ].riders.size )
		{
			level.vehicles_with_drones = array_remove( level.vehicles_with_drones, level.vehicles_with_drones[ index ] );
			level.drone_unloader -- ;
		}
		wait .1;
		index++ ;
		if ( index >= level.vehicles_with_drones.size )
			index = 0;
		if ( level.drone_unloader == 0 )
			break;
	}
	flag_set( "no_more_drone_unloaders" );
}

count_unload_que()
{
	count = 0;
	vehicles = getentarray( "script_vehicle", "classname" );
	for ( i = 0; i < vehicles.size; i++ )
		count += vehicles[ i ].unloadque.size;
	return count;
}

kill_unload_que()
{
	array_thread(  getentarray("script_vehicle","classname"), ::vehicle_enemies_with_drones_delete_on_unload );
	array_thread( level.vehicles_with_drones, ::kill_unload_que_single_vehicle );
}

vehicle_enemies_with_drones_delete_on_unload()
{
	if(self.script_team == "allies")
		return;
	for ( i = 0; i < self.riders.size; i++ )
		self.riders[i].drone_delete_on_unload = true;
}

kill_unload_que_single_vehicle()
{
	array_levelthread( self.riders,::deleteent );
}

bridge_defence_bounds()
{
	level endon( "bridge_zakhaev_setup" );
	trigger = getent( "defence_bounds", "targetname" );
	
	
	time_in_trigger_untill_friendlies_become_vulnerable = 0;

	switch( level.gameSkill )
	{
		case 0:// easy
			time_in_trigger_untill_friendlies_become_vulnerable = 32;
			break;	
		case 1:// regular
			time_in_trigger_untill_friendlies_become_vulnerable = 24;
			break;	
		case 2:// hardened
			time_in_trigger_untill_friendlies_become_vulnerable = 12;
			break;	
		case 3:// veteran
			time_in_trigger_untill_friendlies_become_vulnerable = 7;
			break;	
	}
	
	timer = gettime() + ( time_in_trigger_untill_friendlies_become_vulnerable * 1000 );
	
	while ( 1 )
	{
		trigger waittill( "trigger", other );

		timer = gettime() + ( time_in_trigger_untill_friendlies_become_vulnerable * 1000 );

		while ( isalive( other ) && gettime() < timer )
			wait .05;
			
		if ( !isalive( other ) )
			continue;

		touching = true;

// 		heros_shields_off();

		set_layer_of_death( 4 );
		level.ai_in_boundry = true;

		while ( touching )
		{
			ai = getaiarray( "axis" );
			touching = false;
			for ( i = 0; i < ai.size; i++ )
			{
				if ( ai[ i ] istouching( trigger ) )
				{
					touching = true;
					break;
				}
			}
			wait .05;
		}
		
		level.ai_in_boundry = false;
		set_layer_of_death( level.last_layer_of_death );

// 		heros_shields_on();

	}
}

heros_shields_off()
{
	array_thread( get_heroes(), ::stop_magic_bullet_shield );
}

heros_shields_on()
{
	array_thread( get_heroes(), ::magic_bullet_shield );
}


hind_bombplayer()
{
	self waittill( "trigger", other );
	other endon( "stop_killing_theplayer" ) ;
	wait 2;

	while ( 1 )
	{
		bursts = randomint( 4 );
		for ( i = 0;i < bursts;i++ )
		{
			vehicle = nearby_destry_at_end_vehicle();
			
			innerbox = 200;
			outerbox = 300;
			if ( level.player.health != level.player.maxhealth )
			{
				innerbox = 400;
				outerbox = 600;
			}
			
			ai = undefined;
			if ( level.player.health == level.player.maxhealth )
				ai = nearby_non_hero();
			
			if ( isdefined( vehicle ) )
				spot = vehicle.origin + ( 0, 0, 16 );
			else if ( isdefined( ai ) )
				spot = ai[ i ].origin;
			else
				spot = random_outer_box( level.player.origin, innerbox, outerbox );
				
			if(player_in_blastradius())
				spot = level.player geteye();
				
			other shootspotoncewithmissile( spot );
		}
		wait randomfloatrange( .5, 1 );
	}
}

player_in_blastradius()
{
	if( distance((-36286.3, -17573.5, 0 ),flat_origin(level.player.origin) ) < 962.438110 )
		return true;
	return false;
}       

random_outer_box( origin, insidebox, outsidebox )
{
	xdir = randomint( 50 ) > 25;
	ydir = randomint( 50 ) > 25;
	if ( !xdir )
		xdir = -1;
	if ( !ydir )
		ydir = -1;
	x = randomfloatrange( insidebox, outsidebox ) * xdir;
	x += origin[ 0 ];
	y = randomfloatrange( insidebox, outsidebox ) * ydir;
	y += origin[ 1 ];
	z = origin[ 2 ];
// 	thread draw_arrow_time( level.player.origin, ( x, y, z ), ( 1, 1, 1 ), 3 );
	return( x, y, z );
}

nearby_destry_at_end_vehicle()
{
	vehicle = undefined;
	if ( level.player.health != level.player.maxhealth )
		return vehicle;

	timeouttime = gettime() + 10000;
	array = getentarray( "destroy_at_end", "script_noteworthy" );
	vehicles = [];
	for ( i = 0; i < array.size; i++ )
		if ( array[ i ].classname == "script_vehicle" && isalive( array[ i ] ) )
			vehicles[ vehicles.size ] = array[ i ];	
			
	if ( !vehicles.size )
		return vehicle;
		
	vehicle = getclosest( level.player.origin, vehicles, 500 );
	return vehicle;
}

nearby_non_hero()
{
	
}

drag_shots()
{
	level endon( "stop_drag_shots" );
	bursts = 4;
	burst_delay = .4;
	target = getent( self.target, "targetname" );

	base_org = self.origin;
	dest_org = target.origin;
		
	while ( 1 )
	{
		bursts = randomintrange( 3, 6 );
		burst_delay = .4;
		for ( i = 0; i < bursts; i++ )
		{
			trace_dest = bulletspread( base_org, dest_org, 5 );
			trace = BulletTrace( base_org, trace_dest, true, undefined );
			
			if ( isdefined( trace[ "entity" ] ) && ( isai( trace[ "entity" ] ) || trace[ "entity" ].classname == "script_model" ) )
			{
				wait .05;// infinite loop dodging.
				continue;
			}
			trace_dest = trace[ "position" ];
			BulletTracer( base_org, trace_dest, false );

			bulletstart = trace_dest - vector_multiply( vectornormalize( trace_dest - base_org ), 5 );
			
// 			draw_line_for_time( bulletstart, trace_dest, 1, 1, 1, .3 );
			
			
// 			magicbullet( "ak47", bulletstart, trace_dest );
			magicbullet( "ak47", base_org, base_org + ( 0, 0, 66 ) );// for sounds
			
			
		// 	bullet_large_normal, concrete, impacts / large_concrete_1
			fx = ak_Fx_lookup( trace[ "surfacetype" ] );
			PlayFX( fx, trace_dest, trace[ "normal" ] );
			wait .1;	
		}
		wait burst_delay;
	}
}


ak_Fx_lookup( surfacetype )
{
	fx = level._ak_impacts[ surfacetype ];
	if ( !isdefined( fx ) )
		fx = level._ak_impacts[ "concrete" ];
	return fx;
}


honker_initiate()
{
	while(1)
	{
		self waittill ("trigger",other);
		if(isdefined(other.honker_thinking) || isdefined(level.passerby_timing[ other.spawner_id ]) )
			continue;
		other thread honker_think();
	}
}

print_passerby_timing()
{
	//this is where the effects get written to scripts
	 /#
	file = "scriptgen/" + level.script + "_passbytimings.gsc";
	file = fileprint_start( file );
	fileprint_chk( level.fileprint, "#include maps\\jeepride_code;" );
	fileprint_chk( level.fileprint, "passbytimings()" );
	fileprint_chk( level.fileprint, "{" );
	keys = getarraykeys(level.passerby_timing_record);
	for ( i = 0; i < keys.size; i++ )
		fileprint_chk( level.fileprint, "level.passerby_timing[\""+keys[i]+"\"] = " + level.passerby_timing_record[ keys[i] ] + ";" );
	fileprint_chk( level.fileprint, "}" );
	fileprint_end();
	#/ 
}

honker_think()
{
	self.honker_thinking = true;
	
	self endon ("death");
	
	if( ! playervehicle_infront_of_honkingvehicle_vehicle( level.playersride, self ) )
		return;
		
	while(playervehicle_infront_of_honkingvehicle_vehicle( level.playersride, self ))
		wait .05;
		
	level.passerby_timing_record[ self.spawner_id ] = (gettime()/1000)-2;
	
	thread draw_arrow_time( self.origin, level.playersride.origin, (1,0,0),6 );
}

honker_get_sound()
{
	sound = "veh_car_passby";
	if( self.vehicletype == "van" )
		sound = ("veh_van_passby");
	else if( self.vehicletype == "truck" )
		sound = ("veh_truck_passby");

	return sound;	
}

playervehicle_infront_of_honkingvehicle_vehicle( playervehicle, honkingvehicle )
{
	forwardvec = anglestoforward( flat_angle( honkingvehicle.angles ) );
	normalvec = vectorNormalize( flat_origin( playervehicle.origin )-flat_origin( honkingvehicle.origin ) );
	dot = vectordot( forwardvec, normalvec ); 
	if( dot > 0 )
		return true;
	else
		return false;
}

ride_smoker()
{
	PlayFXOnTag( level._effect["smoke_blind"], self, "tag_glass_front" );
	//and that's not all!
	level.player ShellShock( "jeepride_bridgebang", 15 );
	Earthquake( .7, 3, ( -35893.6, -15878.5, 460 ), 2500 );
	for( i = 0; i < 5; i++ )
	{
		level.player playrumbleonentity ("tank_rumble");
		wait randomfloatrange(.2,.7);		
	}
}

player_kill()
{
	level.player enableHealthShield( false );
	radiusDamage( level.player.origin, 8, level.player.health + 5, level.player.health + 5 );
	level.player enableHealthShield( true );
}


bridge_fall()
{
	self waittill ("trigger");
	dest_angle = level.player getplayerangles();
	x = 70;
	y = dest_angle[1];
	z = dest_angle[2];
	dest_angle = (x,y,z);
	player_fudge_rotateto( dest_angle ,.6 );
	wait 1.5;
	
	if(isalive(level.player))
		player_kill();
}

player_fudge_rotateto( dest_angle,waittime )
{
	org_ent = spawn( "script_origin", level.player.origin );
	org_ent.origin = level.player geteye();
	org_ent.angles = level.player getplayerangles();
	
	if(!isdefined(waittime))
		waittime = .5;
	org_ent rotateto( dest_angle, waittime, .2, .2 );
	incs = int( waittime / .05 );	
	for ( i = 0 ; i < incs ; i++ )
	{
		level.player setplayerangles( org_ent.angles );
		wait .05;
	}
}


//ganked from hunted

exp_fade_overlay( target_alpha, fade_time )
{
	fade_steps = 4;
	step_angle = 90 / fade_steps;
	current_angle = 0;
	step_time = fade_time / fade_steps;

	current_alpha = self.alpha;
	alpha_dif = current_alpha - target_alpha;

	for ( i=0; i<fade_steps; i++ )
	{
		current_angle += step_angle;

		self fadeOverTime( step_time );
		if ( target_alpha > current_alpha )
		{
			fraction = 1 - cos( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}
		else
		{
			fraction = sin( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}

		wait step_time;
	}
	self.alpha = target_alpha;
}

create_overlay_element( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	if(!isdefined(level.overlays))
		level.overlays =[];
	level.overlays[level.overlays.size] = overlay;
	
	return overlay;
}


rescue_scene_patrol_01()
{
	friends = getaiarray("allies");
	excluders = [];
	if(isdefined(level.medic))
		excluders[excluders.size] = level.medic;
	if(isdefined(level.ru1))
		excluders[excluders.size] = level.ru1;
	if(isdefined(level.ru2))
		excluders[excluders.size] = level.ru2;
	
	for ( i = 0; i < friends.size; i++ )
	{
		if(isdefined(friends[i].rescue_patroler) && friends[i].rescue_patroler == self.targetname )
			excluders[excluders.size] = friends[i];
	}
	nearest = get_array_of_closest(self.origin,friends,excluders,1)[0];
	nearest.rescue_patroler = self.targetname;
	
	if(isdefined(nearest.ridingvehicle))
	{
		nearest waittill ("jumpedout");
		wait .05;
	}
	
	nearest force_teleport( self.origin,(0,0,0));

//	nearest.goalradius = 4;
//	nearest setgoalpos(self.origin);
//	nearest waittill ("goal");
	
	if( isdefined(self.target ) )
		nearest thread maps\_patrol::patrol( self.target );
	
}

dummyfunction()
{
	
}

flag_sound(sound)
{
	if(flag("flag_sound"+sound))
		return;
	flag_set("flag_sound"+sound);
	play_sound_on_entity( sound );
	flag_clear("flag_sound"+sound);
}

force_teleport( origin, angles )
{
	linker = spawn( "script_model", origin );
	linker setmodel( "fx" );
	self linkto( linker );
	self teleport( origin, angles );
	self unlink();
	linker delete();
}

fake_water_tread()
{
	vehicles = getentarray("script_vehicle","classname");
	thehind = undefined;
	for ( i = 0; i < vehicles.size; i++ )
		if(vehicles[i].vehicletype == "hind")
			thehind = vehicles[i];
	if(!isdefined(thehind))
		return;
			
	level endon ("end_fake_water_tread");
	
	while(1)
	{
		position = (thehind.origin[0],thehind.origin[1],375);
		playfx( level._vehicle_effect[ thehind.vehicletype ][ "water" ], position );
		wait .1;
	}

}

stop_fake_water_tread()
{
	level notify ("end_fake_water_tread");
}
