#include common_scripts\utility;
#include animscripts\utility;
#using_animtree ("generic_human");


//
//		 Damage Yaw
//
//           front
//        /----|----\
//       /    180    \
//      /\     |     /\
//     / -135  |  135  \
//     |     \ | /     |
// left|-90----+----90-|right
//     |     / | \     |
//     \  -45  |  45   /
//      \/     |     \/
//       \     0     / 
//        \----|----/
//           back

main()
{
    self trackScriptState( "Death Main", "code" );
	self endon("killanimscript");
	self stopsounds();
	// don't abort at this point unless you're going to play another animation!
	// just playing ragdoll isn't sufficient because sometimes ragdoll fails, and then
	// you'll just have a corpse standing around in limbo.
	
	if ( self.a.nodeath == true )
		return;
	
	if ( isdefined (self.deathFunction) )
	{
		self [[self.deathFunction]]();
		return;
	}
	
	// make sure the guy doesn't keep doing facial animation after death
	changeTime = 0.3;
	self clearanim( %scripted_look_straight,		changeTime );
	self clearanim( %scripted_talking,				changeTime );
	
	animscripts\utility::initialize("death");
	
	// Stop any lookats that are happening and make sure no new ones occur while death animation is playing.
	self notify ("never look at anything again");
	
	// should move this to squad manager somewhere...
	removeSelfFrom_SquadLastSeenEnemyPos(self.origin);
	
	anim.numDeathsUntilCrawlingPain--;
	anim.numDeathsUntilCornerGrenadeDeath--;
	
	if ( isDefined(self.deathanim) )
	{
		//thread [[anim.println]]("Playing special death as set by self.deathanim");#/
		self SetFlaggedAnimKnobAll("deathanim", self.deathanim, %root, 1, .05, 1);
		self animscripts\shared::DoNoteTracks("deathanim");
		if (isDefined(self.deathanimloop))
		{
			// "Playing special dead/wounded loop animation as set by self.deathanimloop");#/
			self SetFlaggedAnimKnobAll("deathanim", self.deathanimloop, %root, 1, .05, 1);
			for (;;)
			{
				self animscripts\shared::DoNoteTracks("deathanim");
			}
		}
		
		// Added so that I can do special stuff in Level scripts on an ai
		if ( isdefined( self.deathanimscript ) )
			self [[self.deathanimscript]]();
		return;
	}
	
	explosiveDamage = self animscripts\pain::wasDamagedByExplosive();
	
	if ( self.damageLocation == "helmet" )
		self helmetPop();
	else if ( explosiveDamage && randomint(3) == 0 )
		self helmetPop();
	
	self clearanim(%root, 0.3);
	//self thread animscripts\pain::PlayHitAnimation();
	
	if ( !damageLocationIsAny( "head", "helmet" ) )
	{
		if ( isDefined( self.dieQuietly ) && self.dieQuietly )
		{
			// replace with actual die quietly gurglesque sound
//			if ( randomint(3) < 2 )
//				self animscripts\face::SayGenericDialogue("pain");
		}
		else
		{
			PlayDeathSound();
		}
	}
	//deathFace = animscripts\face::ChooseAnimFromSet(anim.deathFace);
	//self animscripts\face::SaySpecificDialogue(deathFace, undefined, 1.0);
	
	if ( explosiveDamage && playExplodeDeathAnim() )
		return;

	if ( specialDeath() )
		return;
	
	
	deathAnim = getDeathAnim();

	/#
	if ( getdvarint("scr_paindebug") == 1 )
		println( "^2Playing pain: ", deathAnim, " ; pose is ", self.a.pose );
	#/
	
	playDeathAnim( deathAnim );
}


waitForRagdoll( time )
{
	wait( time );
	if ( isdefined( self ) )
		self startragdoll();
	if ( isdefined( self ) )
		self animscripts\shared::DropAllAIWeapons();
}	

playDeathAnim( deathAnim )
{
	if ( !animHasNoteTrack( deathAnim, "dropgun" ) && !animHasNoteTrack( deathAnim, "fire_spray" ) ) // && !animHasNotetrack( deathAnim, "gun keep" )
		self animscripts\shared::DropAllAIWeapons();
	
	self setFlaggedAnimKnobAllRestart( "deathanim", deathAnim, %body, 1, .1 );
	
	if ( ( isdefined( self.skipDeathAnim ) ) && self.skipDeathAnim )
	{
		self startRagDoll();
		return;
	}
	else if ( !animHasNotetrack( deathanim, "start_ragdoll" ) )
	{
		self thread waitForRagdoll( getanimlength( deathanim ) * 0.35 );
	}
	
	// do we really need this anymore?
	/#
	if (getdebugdvar("debug_grenadehand") == "on")
	{
		if (animhasnotetrack(deathAnim, "bodyfall large"))
			return;
		if (animhasnotetrack(deathAnim, "bodyfall small"))
			return;
			
		println ("Death animation ", deathAnim, " does not have a bodyfall notetrack");
		iprintlnbold ("Death animation needs fixing (check console and report bug in the animation to Boon)");
	}
	#/
	
	self animscripts\shared::DoNoteTracks( "deathanim" );
	self animscripts\shared::DropAllAIWeapons();
}


testPrediction()
{
	self BeginPrediction();

	self animscripts\predict::start();

	self animscripts\predict::_setAnim(%balcony_stumble_forward, 1, .05, 1);
	if (self animscripts\predict::stumbleWall(1))
	{
		self animMode("nogravity");

		self animscripts\predict::_setFlaggedAnimKnobAll("deathanim", %balcony_tumble_railing36_forward, %root, 1, 0.05, 1);
		if (self animscripts\predict::tumbleWall("deathanim"))
		{
			self EndPrediction();
			return true;
		}
	}

	self EndPrediction();
	self BeginPrediction();

	self animscripts\predict::start();

	self animscripts\predict::_setAnim(%balcony_stumble_forward, 1, .05, 1);
	if (self animscripts\predict::stumbleWall(1))
	{
		self animMode("nogravity");

		self animscripts\predict::_setFlaggedAnimKnobAll("deathanim", %balcony_tumble_railing44_forward, %root, 1, 0.05, 1);
		if (self animscripts\predict::tumbleWall("deathanim"))
		{
			self EndPrediction();
			return true;
		}
	}

	self EndPrediction();

	self animscripts\predict::end();

	return false;
}


// Special death is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the death for the special animation state, or false if it wants the regular 
// death function to handle it.
specialDeath()
{
	if (self.a.special == "none")
		return false;
	
	switch ( self.a.special )
	{
	case "cover_right":
		if (self.a.pose == "stand")
		{
			deathArray = [];
			deathArray[0] = %corner_standr_deathA;
			deathArray[1] = %corner_standr_deathB;
			DoDeathFromArray(deathArray);
		}
		else
		{
			assert(self.a.pose == "crouch");
			return false;
		}
		return true;
	
	case "cover_left":
		if (self.a.pose == "stand")
		{
			deathArray = [];
			deathArray[0] = %corner_standl_deathA;
			deathArray[1] = %corner_standl_deathB;
			DoDeathFromArray(deathArray);
		}
		else
		{
			assert(self.a.pose == "crouch");
			return false;
		}
		return true;
		
	case "cover_stand":
		deathArray = [];
		deathArray[0] = %coverstand_death_left;
		deathArray[1] = %coverstand_death_right;
		DoDeathFromArray( deathArray );
		return true;

	case "cover_crouch":
		deathArray = [];
		if ( damageLocationIsAny( "head", "neck" ) && (self.damageyaw > 135 || self.damageyaw <=-45) )	// Front/Left quadrant
			deathArray[deathArray.size] = %covercrouch_death_1;
		
		if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )	// Back quadrant
			deathArray[deathArray.size] = %covercrouch_death_3;
		
		deathArray[deathArray.size] = %covercrouch_death_2;

		DoDeathFromArray( deathArray );
		return true;

	case "saw":
		if ( self.a.pose == "stand" )
			DoDeathFromArray( array(%saw_gunner_death) );
		else if ( self.a.pose == "crouch" )
			DoDeathFromArray( array(%saw_gunner_lowwall_death) );
		else
			DoDeathFromArray( array(%saw_gunner_prone_death) );
		return true;
	
	case "dying_crawl":
		if ( self.a.pose == "back" )
		{
			deathArray = array( %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 );
			DoDeathFromArray( deathArray );
		}
		else
		{
			assertex( self.a.pose == "prone", self.a.pose );
			deathArray = array( %dying_crawl_death_v1, %dying_crawl_death_v2 );
			DoDeathFromArray( deathArray );
		}
		return true;
	}
	return false;
}


DoDeathFromArray( deathArray )
{
	deathAnim = deathArray[randomint(deathArray.size)];
	
	playDeathAnim( deathAnim );
	//nate - adding my own special death flag on top of special death. 
	if ( isdefined( self.deathanimscript ) )
		self [[self.deathanimscript]]();
}


PlayDeathSound()
{
//	if (self.team == "allies")
//		self playsound("allied_death"); 
//	else
//		self playsound("german_death"); 
	self animscripts\face::SayGenericDialogue("death");
}

print3dfortime( place, text, time )
{
	numframes = time * 20;
	for ( i = 0; i < numframes; i++ )
	{
		print3d( place, text );
		wait .05;
	}
}

helmetPop()
{
	if ( !isdefined( self ) )
		return;
	if ( !isdefined( self.hatModel ) )
		return;
	// used to check self removableHat() in cod2... probably not necessary though
	
	partName = GetPartName( self.hatModel, 0 );
	model = spawn( "script_model", self.origin + (0,0,64) );
	model setmodel( self.hatModel  );
	model.origin = self GetTagOrigin( partName ); //self . origin + (0,0,64);
	model.angles = self GetTagAngles( partName ); //(-90,0 + randomint(90),0 + randomint(90));
	model thread helmetLaunch( self.damageDir );

	hatModel = self.hatModel;
	self.hatModel = undefined;
	
	wait 0.05;
	
	if ( !isdefined( self ) )
		return;
	self detach( hatModel, "" );
}

helmetLaunch( damageDir )
{
    launchForce = damageDir;
	launchForce = launchForce * randomFloatRange( 1100, 4000 );

	forcex = launchForce[0];
	forcey = launchForce[1];
	forcez = randomFloatRange( 800, 3000 );
	
	contactPoint = self.origin + ( randomfloatrange(-1,1), randomfloatrange(-1,1), randomfloatrange(-1,1) ) * 5;
	
	self physicsLaunch( contactPoint, (forcex, forcey, forcez) );
	
	wait 60;
	
	while(1)
	{
		if ( !isdefined( self ) )
			return;
		
		if ( distanceSquared( self.origin, level.player.origin ) > 512*512 )
			break;
		
		wait 30;
	}
	
	self delete();
}


removeSelfFrom_SquadLastSeenEnemyPos(org)
{
	for (i=0;i<anim.squadIndex.size;i++)
		anim.squadIndex[i] clearSightPosNear(org);
}


clearSightPosNear(org)
{
	if (!isdefined(self.sightPos))
		return;
			
	if (distance (org, self.sightPos) < 80)
	{
		self.sightPos = undefined;
		self.sightTime = gettime();
	}
}


shouldDoRunningForwardDeath()
{
	if ( self.a.movement != "run" )
		return false;
		
	if ( self getMotionAngle() > 60 || self getMotionAngle() < -60 )
		return false;
		
	if ( (self.damageyaw >= 135) || (self.damageyaw <=-135) ) // Front quadrant
		return true;

	if ( (self.damageyaw >= -45) && (self.damageyaw <= 45) ) // Back quadrant
		return true;

	return false;
}


getDeathAnim()
{
	if ( self.a.pose == "stand" )
	{
		if ( shouldDoRunningForwardDeath() )
			return getRunningForwardDeathAnim();
		
		return getStandDeathAnim();
	}
	else if ( self.a.pose == "crouch" )
	{
		return getCrouchDeathAnim();
	}
	else if ( self.a.pose == "prone" )
	{
		return getProneDeathAnim();
	}
	else
	{
		assert( self.a.pose == "back" );
		return getBackDeathAnim();
	}
}


getRunningForwardDeathAnim()
{
	deathArray = [];
	deathArray[deathArray.size] = tryAddDeathAnim( %run_death_facedown );
	deathArray[deathArray.size] = tryAddDeathAnim( %run_death_roll );
	
	if ( (self.damageyaw >= 135) || (self.damageyaw <=-135) ) // Front quadrant
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %run_death_fallonback );
		deathArray[deathArray.size] = tryAddDeathAnim( %run_death_fallonback_02 );
	}
	else if ( (self.damageyaw >= -45) && (self.damageyaw <= 45) ) // Back quadrant
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %run_death_roll );
		deathArray[deathArray.size] = tryAddDeathAnim( %run_death_facedown );
	}

	deathArray = tempClean( deathArray );
	deathArray = animscripts\pain::removeBlockedAnims( deathArray );
	
	if ( !deathArray.size )
		return getStandDeathAnim();
	
	return deathArray[ randomint( deathArray.size ) ];
}

// temp fix for arrays containing undefined
tempClean( array )
{
	newArray = [];
	for ( index = 0; index < array.size; index++ )
	{
		if ( !isDefined( array[index] ) )
			continue;
			
		newArray[newArray.size] = array[index];
	}
	return newArray;
}

// TODO: proper location damage tracking
getStandDeathAnim()
{
	deathArray = [];
	
	if ( weaponAnims() == "pistol" )
	{
		if ( abs( self.damageYaw ) < 50 )
		{
			deathArray[ deathArray.size ] = %pistol_death_2; // falls forwards
		}
		else
		{
			if ( abs( self.damageYaw ) < 110 )
				deathArray[ deathArray.size ] = %pistol_death_2; // falls forwards
			
			if ( damageLocationIsAny( "torso_lower", "torso_upper", "left_leg_upper", "left_leg_lower", "right_leg_upper", "right_leg_lower" ) )
			{
				deathArray[ deathArray.size ] = %pistol_death_3; // hit in groin from front
				if ( !damageLocationIsAny( "torso_upper" ) )
					deathArray[ deathArray.size ] = %pistol_death_3; // (twice as likely)
			}
			
			if ( !damageLocationIsAny( "head", "neck", "helmet", "left_foot", "right_foot", "left_hand", "right_hand", "gun" ) && randomint( 2 ) == 0 )
				deathArray[ deathArray.size ] = %pistol_death_4; // hit at top and falls backwards, but more dragged out
			
			if ( deathArray.size == 0 || damageLocationIsAny( "torso_lower", "torso_upper", "neck", "head", "helmet", "right_arm_upper", "left_arm_upper" ) )
				deathArray[ deathArray.size ] = %pistol_death_1; // falls backwards
		}
	}
	else
	{
		// common ones
		if ( randomint( 3 ) < 2 )
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death );
		if ( randomint( 3 ) < 2 )
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_firing_02 );
	
		// torso or legs
		if ( damageLocationIsAny( "torso_lower", "left_leg_upper", "left_leg_lower", "right_leg_lower", "right_leg_lower" )	)
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_groin );
			
		if ( damageLocationIsAny( "head", "neck", "helmet" ) )
		{
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_headshot );
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_headtwist );
		}
	
		// neck torso
		if ( damageLocationIsAny( "torso_upper", "neck" ) )
		{
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_nerve );
			if ( self.damageTaken <= 70 ) // lots of damage means it probably wasn't just a bullet
				deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_neckgrab );
		}
		
		if ( (self.damageyaw > 135) || (self.damageyaw <=-135) ) // Front quadrant
		{
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_02 );
			if ( damageLocationIsAny( "torso_upper", "left_arm_upper", "right_arm_upper" ) )	
				deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_firing );
			if ( damageLocationIsAny( "torso_upper", "neck", "head", "helmet" ) )
				deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees_02 );
		}
		else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) ) // Right quadrant
		{
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees_02 );
		}
		else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) ) // Back quadrant
		{
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees );
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees_02 );
		}
		else // Left quadrant
		{
			if ( damageLocationIsAny( "torso_upper", "left_arm_upper", "head" ) )	
				deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_twist );
	
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees_02 );
		}
		
		assertex( deathArray.size > 0, deathArray.size );
	}
	
	deathArray = tempClean( deathArray );
	
	if ( deathArray.size == 0 )
		deathArray[deathArray.size] = %exposed_death;
	
	return deathArray[ randomint( deathArray.size ) ];
}


getCrouchDeathAnim()
{
	deathArray = [];

	if ( damageLocationIsAny( "head", "neck" ) )	// Front/Left quadrant
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_crouch_death_fetal );
		
	if ( damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_crouch_death_flip );
	
	if ( deathArray.size < 2 )
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_crouch_death_twist );
	if ( deathArray.size < 2 )
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_crouch_death_flip );
	
	deathArray = tempClean( deathArray );
	assertex( deathArray.size > 0, deathArray.size );
	return deathArray[ randomint( deathArray.size ) ];
}


getProneDeathAnim()
{
	return %prone_death_quickdeath;
}


getBackDeathAnim()
{
	deathArray = array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 );
	return deathArray[ randomint( deathArray.size ) ];
}


tryAddDeathAnim( animName )
{
	if ( !animHasNoteTrack( animName, "fire" ) && !animHasNoteTrack( animName, "fire_spray" ) )
		return animName;
	
	if ( self.a.weaponPos["right"] == "none" )
		return undefined;
	
	if ( weaponIsSemiAuto( self.weapon ) )
		return undefined;
	
	if ( WeaponAnims() != "rifle" )
		return undefined;
	
	if ( isDefined( self.dieQuietly ) && self.dieQuietly )
		return undefined;
	
	return animName;
}


playExplodeDeathAnim()
{
	if ( self.damageLocation != "none" )
		return false;

	deathArray = [];

	if ( self.a.movement != "run" )
	{	
		if ( self.mayDoUpwardsDeath && getTime() > anim.lastUpwardsDeathTime + 6000 )
		{
			deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_UP_v1 );
			deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_UP_v2 );
			anim.lastUpwardsDeathTime = getTime();
		}
		else
		{
			if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_B_v1 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_B_v2 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_B_v3 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_B_v4 );
			}
			else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_L_v1 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_L_v2 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_L_v3 );
			}
			else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_F_v1 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_F_v2 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_F_v3 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_F_v4 );
			}
			else
			{															// Left quadrant
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_R_v1 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_R_v2 );
			}
		}
	}
	else
	{
		if ( self.mayDoUpwardsDeath && getTime() > anim.lastUpwardsDeathTime + 2000 )
		{
			deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_UP_v1 );
			deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_stand_UP_v2 );
			anim.lastUpwardsDeathTime = getTime();
		}
		else
		{
			if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_B_v1 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_B_v2 );
			}
			else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_L_v1 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_L_v2 );
			}
			else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_F_v1 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_F_v2 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_F_v3 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_F_v4 );
			}
			else
			{															// Left quadrant
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_R_v1 );
				deathArray[deathArray.size] = tryAddDeathAnim( %death_explosion_run_R_v2 );
			}
		}
	}

	deathAnim = deathArray[ randomint( deathArray.size ) ];
	
	if ( getdvar( "scr_expDeathMayMoveCheck" ) == "on" )
	{
		localDeltaVector = getMoveDelta ( deathAnim, 0, 1 );
		endPoint = self localToWorldCoords( localDeltaVector );
		
		if ( !self mayMoveToPoint( endPoint, false ) )
			return false;
	}
	
	// this should really be in the notetracks
	self animMode ("nogravity");

	playDeathAnim( deathAnim );
	return true;
}

