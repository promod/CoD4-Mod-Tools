#include animscripts\combat_utility;    
#include animscripts\utility;
#include animscripts\shared;
#include common_scripts\utility;
#using_animtree ("generic_human");


// TODO:
// - figure out why aiming range is incorrect (aiming arc seems a bit off)

main()
{
    self trackScriptState( "Cover Prone Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize( "cover_prone" );

	// TODO: run cover crouch or exposed crouch
	if ( weaponClass( self.weapon ) == "rocketlauncher" )
	{
		animscripts\combat::main();
		return;
	}
	
	if ( isDefined( self.a.arrivalType ) && self.a.arrivalType == "prone_saw" )
	{
		assert( isDefined( self.node.turretInfo ) );
		self animscripts\cover_wall::useSelfPlacedTurret( "saw_bipod_prone", "weapon_saw_MG_Setup" );
	}
	else if ( isDefined( self.node.turret ) )
	{
		self animscripts\cover_wall::useStationaryTurret();
	}

	// if we're too close to our enemy, stand up
	// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
	if ( isDefined( self.enemy ) && lengthSquared( self.origin - self.enemy.origin ) < squared( 512 ) )
	{
		self thread animscripts\combat::main();
		return;
	}

	self setup_cover_prone();

    self.coverNode = self.node;    
	self OrientMode( "face angle", self.coverNode.angles[1] );	

	self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_modern, %prone_legs_up );
	if ( self.a.pose != "prone" )
		self transitionTo( "prone" );
	else
		self EnterProneWrapper( 0 );
	
	self thread idleThread();
		
	self setAnimKnobAll( %prone_aim_5, %body, 1, 0.1, 1 );

	// face the direction of our covernode
	self OrientMode( "face angle", self.coverNode.angles[1] );	
	self animmode("zonly_physics");
	
	self proneCombatMainLoop();
	
	self notify( "stop_deciding_how_to_shoot" );
	
}

idleThread()
{
	self endon("killanimscript");
	self endon("kill_idle_thread");
	for(;;)
	{
		idleAnim = animArrayPickRandom( "prone_idle" );
		self setflaggedanimlimited( "idle", idleAnim );
		self waittillmatch( "idle", "end" );
		self clearanim( idleAnim, .2 );
	}
}

UpdateProneWrapper( time )
{
	self UpdateProne( %prone_aim_feet_45up, %prone_aim_feet_45down, 1, time, 1 );
}

proneCombatMainLoop()
{
	self endon ("killanimscript");
	self endon ("melee");
	
	self thread trackShootEntOrPos();
	
//	self thread ReacquireWhenNecessary();
	
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );

	nextShootTime = 0;
	
//	self resetGiveUpOnEnemyTime();
	
	desynched = (gettime() > 2500);

	//prof_begin("prone_combat");
	
	for(;;)
	{
		self animscripts\utility::IsInCombat(); // reset our in-combat state
		
		self UpdateProneWrapper( 0.05 );
		
		if ( !desynched )
		{
			wait ( 0.05 + randomfloat( 1.5 ) );
			desynched = true;
			continue;
		}
		
		if ( !isdefined( self.shootPos ) )
		{
			assert( !isdefined( self.shootEnt ) );
			if ( considerThrowGrenade() )
				continue;
			
			wait(0.05);
			continue;
		}
		
		assert( isdefined( self.shootPos ) ); // we can use self.shootPos after this point.
//		self resetGiveUpOnEnemyTime();
		
		// if we're too close to our enemy, stand up
		// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );

		if ( self.a.pose != "crouch" && self isStanceAllowed("crouch") && distSqToShootPos < squared( 400 ) )
		{
			if ( distSqToShootPos < squared( 285 ) )
			{
				transitionTo( "crouch" );
				self thread animscripts\combat::main();
				return;
			}
		}

		if ( considerThrowGrenade() ) // TODO: make considerThrowGrenade work with shootPos rather than only self.enemy
			continue;
		
		if ( self proneReload( 0 ) )
			continue;

		if ( aimedAtShootEntOrPos() && gettime() >= nextShootTime )
		{
			shootUntilShootBehaviorChange();
			self clearAnim( %add_fire, .2 );
			continue;
		}
		
		// idleThread() is running, so just waiting a bit will cause us to idle
		wait(0.05);
	}
	
	//prof_end("prone_combat");
}




proneReload( threshold )
{
	return Reload( threshold, self animArray( "reload" ) );
}


setup_cover_prone()
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45; 
	self.downAimLimit = -45;

	anim_array = [];
	
	anim_array["straight_level"] = %prone_aim_5;
	
	anim_array["fire"] = %prone_fire_1;
	anim_array["semi2"] = %prone_fire_burst;
	anim_array["semi3"] = %prone_fire_burst;
	anim_array["semi4"] = %prone_fire_burst;
	anim_array["semi5"] = %prone_fire_burst;

	anim_array["single"] = array( %prone_fire_1 );

	anim_array["burst2"] = %prone_fire_burst; // (will be limited to 2 shots)
	anim_array["burst3"] = %prone_fire_burst;
	anim_array["burst4"] = %prone_fire_burst;
	anim_array["burst5"] = %prone_fire_burst;
	anim_array["burst6"] = %prone_fire_burst;
	
	anim_array["reload"] = %prone_reload;
	
	anim_array["look"] = array( %prone_twitch_look, %prone_twitch_lookfast, %prone_twitch_lookup );
							
	anim_array["grenade_safe"] = array( %prone_grenade_A, %prone_grenade_A );
	anim_array["grenade_exposed"] = array( %prone_grenade_A, %prone_grenade_A );
							
	anim_array["prone_idle"] = array( %prone_idle );
		
	anim_array["hide_to_look"] = %coverstand_look_moveup;
	anim_array["look_idle"] = %coverstand_look_idle;
	anim_array["look_to_hide"] = %coverstand_look_movedown;
	anim_array["look_to_hide_fast"] = %coverstand_look_movedown_fast;
	
	anim_array["stand_2_prone"] = %stand_2_prone_nodelta;
	anim_array["crouch_2_prone"] = %crouch_2_prone;
	anim_array["prone_2_stand"] = %prone_2_stand_nodelta;
	anim_array["prone_2_crouch"] = %prone_2_crouch;
	anim_array["stand_2_prone_firing"] = %stand_2_prone_firing;
	anim_array["crouch_2_prone_firing"] = %crouch_2_prone_firing;
	anim_array["prone_2_stand_firing"] = %prone_2_stand_firing;
	anim_array["prone_2_crouch_firing"] = %prone_2_crouch_firing;
	
	self.a.array = anim_array;
}


tryThrowingGrenade( throwAt, safe )
{
	theanim = undefined;
	if ( isdefined(safe) && safe )
		theanim = animArrayPickRandom("grenade_safe");
	else
		theanim = animArrayPickRandom("grenade_exposed");
	
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	
	armOffset = (32,20,64); // needs fixing!
	threwGrenade = TryGrenade( throwAt, theanim );
	
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}


considerThrowGrenade()
{
	if ( isdefined( anim.throwGrenadeAtPlayerASAP ) && isAlive( level.player ) )
	{
		if ( tryThrowingGrenade( level.player, 200 ) )
			return true;
	}
	
	if ( isdefined( self.enemy ) )
		return tryThrowingGrenade( self.enemy, 850 );
	
	return false;
}

shouldFireWhileChangingPose()
{
	if ( isdefined( self.node ) && distanceSquared( self.origin, self.node.origin ) < 16*16 )
		return false; // we're on a node and can't use an animation with a delta
	if ( isDefined( self.enemy ) && self canSee( self.enemy ) && !isdefined( self.grenade ) && self getAimYawToShootEntOrPos() < 20 )
		return animscripts\move::MayShootWhileMoving();
	return false;
}

transitionTo( newPose )
{
	if ( newPose == self.a.pose )
		return;
	
	self clearanim( %root, .3 );
	
	self notify( "kill_idle_thread" );
	
	if ( shouldFireWhileChangingPose() )
		transAnim = animArray( self.a.pose + "_2_" + newPose + "_firing");
	else
		transAnim = animArray( self.a.pose + "_2_" + newPose );
	
	if ( newPose == "prone" )
	{
		// this is crucial. if it doesn't have this notetrack, we won't call enterProneWrapper!
		assert( animHasNotetrack( transAnim, "anim_pose = \"prone\"" ) );
	}
	
	self setFlaggedAnimKnobAllRestart( "trans", transAnim, %body, 1, .2, 1.0 );
	animscripts\shared::DoNoteTracks( "trans" );

	assert( self.a.pose == newPose );

	self setAnimKnobAllRestart( animarray("straight_level"), %body, 1, .25 );
	setupAim( .25 );
}

finishNoteTracks(animname)
{
	self endon("killanimscript");
	animscripts\shared::DoNoteTracks(animname);
}


setupAim( transTime )
{
	self setAnimKnobAll( %prone_aim_5, %body, 1, transTime );
	self setAnimLimited( %prone_aim_2_add, 1, transTime );
	self setAnimLimited( %prone_aim_4_add, 1, transTime );
	self setAnimLimited( %prone_aim_6_add, 1, transTime );
	self setAnimLimited( %prone_aim_8_add, 1, transTime );
}


proneTo( newPose, rate )
{
	assert( self.a.pose == "prone" );
	
//	self OrientMode( "face angle", self.angles[1] );
	self clearanim( %root, .3 );
	
	transAnim = undefined;
	
	if ( shouldFireWhileChangingPose() )
	{
		if ( newPose == "crouch" )
			transAnim = %prone_2_crouch_firing;
		else if ( newPose == "stand" )
			transAnim = %prone_2_stand_firing;
	}
	else
	{
		if ( newPose == "crouch" )
			transAnim = %prone_2_crouch;
		else if ( newPose == "stand" )
			transAnim = %prone_2_stand_nodelta;
	}
		
	assert( isDefined( transAnim ) );
	
	if ( !isdefined( rate ) )
		rate = 1;
	
	self ExitProneWrapper( getAnimLength( transAnim ) / 2 );
	self setFlaggedAnimKnobAllRestart( "trans", transAnim, %body, 1, .2, rate );
	animscripts\shared::DoNoteTracks( "trans" );

	self clearAnim( transAnim, 0.1 );

	assert( self.a.pose == newPose );
//	self.a.pose = newPose; // failsafe
}
