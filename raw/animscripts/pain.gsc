#include animscripts\Utility;
#include animscripts\weaponList;
#include common_scripts\utility;
#include animscripts\Combat_Utility;
#using_animtree ("generic_human");

main()
{
	self setflashbanged(false);
	
	if ( isdefined( self.longDeathStarting ) )
	{
		// important that we don't run any other animscripts.
		self waittill("killanimscript");
		return;
	}

	if ( [[ anim.pain_test ]]() )
		return;	
	if ( self.a.disablePain )
		return;
	
	self notify( "kill_long_death" );
	
	self.a.painTime = gettime();
	
	if (self.a.nextStandingHitDying)
		self.health = 1;

	dead = false;
	stumble = false;
	
	ratio = self.health / self.maxHealth;
	
//	println ("hit at " + self.damagelocation);
	
    self trackScriptState( "Pain Main", "code" );
    self notify ("anim entered pain");
	self endon("killanimscript");

	// Two pain animations are played.  One is a longer, detailed animation with little to do with the actual 
	// location and direction of the shot, but depends on what pose the character starts in.  The other is a 
	// "hit" animation that is very location-specific, but is just a single pose for the affected bones so it 
	// can be played easily whichever position the character is in.
    animscripts\utility::initialize("pain");
    
    self animmode("gravity");
	
	//thread [[anim.println]] ("Shot in "+self.damageLocation+" from "+self.damageYaw+" for "+self.damageTaken+" hit points");#/
	
	self animscripts\face::SayGenericDialogue("pain");
	
	if ( self.damageLocation == "helmet" )
		self animscripts\death::helmetPop();
	else if ( self wasDamagedByExplosive() && randomint(2) == 0 )
		self animscripts\death::helmetPop();

	// corner grenade death takes priority over crawling pain
	/#
	if ( getDvarInt( "scr_forceCornerGrenadeDeath" ) == 1 )
	{
		if ( self TryCornerRightGrenadeDeath() )
			return;
	}
	#/
	if ( self.a.special == "corner_right_mode_b" && TryCornerRightGrenadeDeath() )
		return;
	
	if ( crawlingPain() )
		return;
	
	if ( specialPain( self.a.special ) )
		return;
	// if we didn't handle self.a.special, we can't rely on it being accurate after the pain animation we're about to play.
	self.a.special = "none";

	//self thread PlayHitAnimation();

	painAnim = getPainAnim();
	
	/#
	if ( getdvarint("scr_paindebug") == 1 )
		println( "^2Playing pain: ", painAnim, " ; pose is ", self.a.pose );
	#/
	
	playPainAnim( painAnim );
}

wasDamagedByExplosive()
{
	if ( self.damageWeapon != "none" )
	{
		if ( weaponClass( self.damageWeapon ) == "rocketlauncher" || weaponClass( self.damageWeapon ) == "grenade" || self.damageWeapon == "fraggrenade" || self.damageWeapon == "c4" || self.damageWeapon == "claymore" )
		{
			self.mayDoUpwardsDeath = (self.damageTaken > 300); // TODO: is this a good value?
			return true;
		}
	}
	
	if ( gettime() - anim.lastCarExplosionTime <= 50 )
	{
		rangesq = anim.lastCarExplosionRange * anim.lastCarExplosionRange * 1.2 * 1.2;
		if ( distanceSquared( self.origin, anim.lastCarExplosionDamageLocation ) < rangesq )
		{
			// assume this exploding car damaged us.
			upwardsDeathRangeSq = rangesq * 0.5 * 0.5;
			self.mayDoUpwardsDeath = (distanceSquared( self.origin, anim.lastCarExplosionLocation ) < upwardsDeathRangeSq );
			return true;
		}
	}
	
	return false;
}

getPainAnim()
{
	if ( self.a.pose == "stand" )
	{
		if ( self.a.movement == "run" && (self getMotionAngle()<60) && (self getMotionAngle()>-60) )
			return getRunningForwardPainAnim();
		
		self.a.movement = "stop";
		return getStandPainAnim();
	}
	else if ( self.a.pose == "crouch" )
	{
		self.a.movement = "stop";
		return getCrouchPainAnim();
	}
	else if ( self.a.pose == "prone" )
	{
		self.a.movement = "stop";
		return getPronePainAnim();
	}
	else
	{
		assert( self.a.pose == "back" );
		self.a.movement = "stop";
		return %back_pain;
	}
}

getRunningForwardPainAnim()
{
	// simple random choice for now
	painArray = array( %run_pain_fallonknee, %run_pain_fallonknee_02, %run_pain_fallonknee_03, %run_pain_stomach, %run_pain_stumble );

	painArray = removeBlockedAnims( painArray );
	if ( !painArray.size )
	{
		self.a.movement = "stop";
		return getStandPainAnim();
	}
	
	return painArray[ randomint( painArray.size ) ];
}

getStandPainAnim()
{
	painArray = [];
	
	if ( weaponAnims() == "pistol" )
	{
		if ( self damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
			painArray[painArray.size] = %pistol_stand_pain_chest;
		if ( self damageLocationIsAny( "torso_lower", "left_leg_upper", "right_leg_upper" ) )
			painArray[painArray.size] = %pistol_stand_pain_groin;
		if ( self damageLocationIsAny( "head", "neck" ) )
			painArray[painArray.size] = %pistol_stand_pain_head;
		if ( self damageLocationIsAny( "left_arm_lower", "left_arm_upper", "torso_upper" ) )
			painArray[painArray.size] = %pistol_stand_pain_leftshoulder;
		if ( self damageLocationIsAny( "right_arm_lower", "right_arm_upper", "torso_upper" ) )
			painArray[painArray.size] = %pistol_stand_pain_rightshoulder;
		
		if ( painArray.size < 2 )
			painArray[painArray.size] = %pistol_stand_pain_chest;
		if ( painArray.size < 2 )
			painArray[painArray.size] = %pistol_stand_pain_groin;
	}
	else
	{
		damageAmount = self.damageTaken / self.maxhealth;

		if ( damageAmount > .4 && !damageLocationIsAny( "left_hand", "right_hand", "left_foot", "right_foot", "helmet" ) )
			painArray[painArray.size] = %exposed_pain_2_crouch;
		if ( self damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
			painArray[painArray.size] = %exposed_pain_back;
		if ( self damageLocationIsAny( "right_hand", "right_arm_upper", "right_arm_lower", "torso_upper" ) )
			painArray[painArray.size] = %exposed_pain_dropgun;
		if ( self damageLocationIsAny( "torso_lower", "left_leg_upper", "right_leg_upper" ) )
			painArray[painArray.size] = %exposed_pain_groin;
		if ( self damageLocationIsAny( "left_hand", "left_arm_lower", "left_arm_upper" ) )
			painArray[painArray.size] = %exposed_pain_left_arm;
		if ( self damageLocationIsAny( "right_hand", "right_arm_lower", "right_arm_upper" ) )
			painArray[painArray.size] = %exposed_pain_right_arm;
		if ( self damageLocationIsAny( "left_foot", "right_foot", "left_leg_lower", "right_leg_lower", "left_leg_upper", "right_leg_upper" ) )
			painArray[painArray.size] = %exposed_pain_leg;
		
		if ( painArray.size < 2 )
			painArray[painArray.size] = %exposed_pain_back;
		if ( painArray.size < 2 )
			painArray[painArray.size] = %exposed_pain_dropgun;
	}

	assertex( painArray.size > 0, painArray.size );
	return painArray[ randomint( painArray.size ) ];
}


removeBlockedAnims( array )
{
	newArray = [];
	for ( index = 0; index < array.size; index++ )
	{
		localDeltaVector = getMoveDelta( array[index], 0, 1 );
		endPoint = self localToWorldCoords( localDeltaVector );

		if ( self mayMoveToPoint( endPoint ) )
			newArray[newArray.size] = array[index];
	}
	return newArray;
}

getCrouchPainAnim()
{
	painArray = [];

	if ( damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
		painArray[painArray.size] = %exposed_crouch_pain_chest;
	if ( damageLocationIsAny( "head", "neck", "torso_upper" ) )
		painArray[painArray.size] = %exposed_crouch_pain_headsnap;
	if ( damageLocationIsAny( "left_hand", "left_arm_lower", "left_arm_upper" ) )
		painArray[painArray.size] = %exposed_crouch_pain_left_arm;
	if ( damageLocationIsAny( "right_hand", "right_arm_lower", "right_arm_upper" ) )
		painArray[painArray.size] = %exposed_crouch_pain_right_arm;
	
	if ( painArray.size < 2 )
		painArray[painArray.size] = %exposed_crouch_pain_flinch;
	if ( painArray.size < 2 )
		painArray[painArray.size] = %exposed_crouch_pain_chest;
	
	assertex( painArray.size > 0, painArray.size );
	return painArray[ randomint( painArray.size ) ];
}

getPronePainAnim()
{
	if ( randomint(2) == 0 )
		return %prone_reaction_A;
	else
		return %prone_reaction_B;
}


playPainAnim( painAnim )
{
	if ( isdefined( self.magic_bullet_shield ) )
		rate = 1.5;
	else
		rate = self.animPlayBackRate;
	
	self setFlaggedAnimKnobAllRestart( "painanim", painAnim, %body, 1, .1, rate );
	
	if ( self.a.pose == "prone" )
		self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.1, 1);
	
	if ( animHasNotetrack( painAnim, "start_aim" ) )
	{
		self thread notifyStartAim( "painanim" );
		self endon("start_aim");
	}
	
	self animscripts\shared::DoNoteTracks( "painanim" );
}

notifyStartAim( animFlag )
{
	self endon( "killanimscript" );
	self waittillmatch( animFlag, "start_aim" );
	self notify( "start_aim" );
}


// Special pain is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the pain for the special animation state, or false if it wants the regular 
// pain function to handle it.
specialPain( anim_special )
{
	if (anim_special == "none")
		return false;

//	self thread PlayHitAnimation();
	
	switch ( anim_special )
	{
	case "cover_left":
		if (self.a.pose == "stand")
		{
			painArray = [];
			if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standl_painB; // groin hit
			if ( self damageLocationIsAny("torso_lower", "torso_upper", "left_arm_upper", "right_arm_upper", "neck") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standl_painC; // chest hit
			if ( self damageLocationIsAny("left_leg_upper", "left_leg_lower", "left_foot") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standl_painD; // left leg hit
			if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standl_painE; // right leg hit
			if ( painArray.size < 2 )
				painArray[painArray.size] = %corner_standl_pain; // dizzy fall against wall
			DoPainFromArray(painArray);
			handled = true;
		}
		else
			handled = false;
		break;
	case "cover_right":
		if (self.a.pose == "stand")
		{
			painArray = [];
			if ( self damageLocationIsAny("right_arm_upper", "torso_upper", "neck") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standr_pain; // right shoulder hit
			if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standr_painB; // right leg hit
			if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || randomfloat(10) < 3 )
				painArray[painArray.size] = %corner_standr_painC; // groin hit
			if ( painArray.size == 0 ) {
				painArray[0] = %corner_standr_pain;
				painArray[1] = %corner_standr_painB;
				painArray[2] = %corner_standr_painC;
			}
			DoPainFromArray(painArray);
			handled = true;
		}
		else
			handled = false;
		break;
	case "cover_crouch":
		/*painArray = [];
		if ( self damageLocationIsAny() || randomfloat(10) < 3 )
			painArray[painArray.size] = ;
		if ( painArray.size < 2 )
			painArray[painArray.size] = ;
		DoPainFromArray(painArray);
		handled = true;*/
		handled = false;
		break;
	case "cover_stand":
		painArray = [];
		if ( self damageLocationIsAny("torso_lower", "left_leg_upper", "right_leg_upper") || randomfloat(10) < 3 )
			painArray[painArray.size] = %coverstand_pain_groin; // groin hit
		if ( self damageLocationIsAny("torso_lower", "torso_upper", "left_arm_upper", "right_arm_upper", "neck") || randomfloat(10) < 3 )
			painArray[painArray.size] = %coverstand_pain_groin; // chest hit
		if ( self damageLocationIsAny("left_leg_upper", "left_leg_lower", "left_foot") || randomfloat(10) < 3 )
			painArray[painArray.size] = %coverstand_pain_leg; // left leg hit
		if ( self damageLocationIsAny("right_leg_upper", "right_leg_lower", "right_foot") || randomfloat(10) < 3 )
			painArray[painArray.size] = %coverstand_pain_leg; // right leg hit
		if ( painArray.size < 2 )
			painArray[painArray.size] = %coverstand_pain_leg;
		DoPainFromArray(painArray);
		handled = true;
		break;	
	case "saw":
		if ( self.a.pose == "stand" )
			painAnim = %saw_gunner_pain;
		else if ( self.a.pose == "crouch" )
			painAnim = %saw_gunner_lowwall_pain_02;
		else
			painAnim = %saw_gunner_prone_pain;

		self setflaggedanimknob( "painanim", painAnim, 1, .3, 1);
		self animscripts\shared::DoNoteTracks ("painanim");
		handled = true;
		break;
	case "mg42":
		mg42pain( self.a.pose );
		handled = true;
		break;
	case "corner_right_mode_b":
	case "rambo_left":
	case "rambo_right":
	case "rambo":
	case "dying_crawl":
		handled = false;
		break;
	default:
		println ("Unexpected anim_special value : "+anim_special+" in specialPain.");
		handled = false;
	}
	return handled;
}

painDeathNotify()
{
	self endon("death");
	
	// it isn't safe to notify "pain_death" from the start of an animscript.
	// this can cause level script to run, which might cause things with this AI to change while the animscript is starting
	// and this can screw things up in unexpected ways.
	// take my word for it.
	wait .05;
	self notify("pain_death");
}

DoPainFromArray( painArray )
{
	painAnim = painArray[randomint(painArray.size)];
	
	self setflaggedanimknob( "painanim", painAnim, 1, .3, 1);
	self animscripts\shared::DoNoteTracks ("painanim");
}

mg42pain( pose )
{
//		assertmsg("mg42 pain anims not implemented yet");//scripted_mg42gunner_pain
		
	/#
	assertEx ( isdefined( level.mg_animmg ), "You're missing maps\\_mganim::main();  Add it to your level." );
	{
		println("	maps\\_mganim::main();");
		return;
	}
	#/

	self setflaggedanimknob( "painanim", level.mg_animmg[ "pain_" + pose ], 1, .1, 1);
	self animscripts\shared::DoNoteTracks ("painanim");
}


// This is to stop guys from taking off running if they're interrupted during pain.  This used to happen when 
// guys were running when they entered pain, but didn't play a special running pain (eg because they were 
// running sideways).  It resulted in a running pain or death being played when they were shot again.
waitSetStop ( timetowait, killmestring )
{
	self endon("killanimscript");
	self endon ("death");
	if (isDefined(killmestring))
		self endon(killmestring);
	wait timetowait;

	self.a.movement = "stop";
}

PlayHitAnimation()
{
	// Note the this thread doesn't endon "killanimscript" like most thread, because I don't want it to die 
	// when a new script starts.

	animWeights = animscripts\utility::QuadrantAnimWeights( self.damageYaw + 180 );

	// Pick the animation to play, based on location and direction.
	playHitAnim = 1;
	switch(self.damageLocation)
	{
	case "torso_upper":
	case "torso_lower":
		frontAnim =	%minorpain_chest_front;
		backAnim =	%minorpain_chest_back;
		leftAnim =	%minorpain_chest_left;
		rightAnim =	%minorpain_chest_right;
		break;
	case "helmet":
	case "head":
	case "neck":
		frontAnim =	%minorpain_head_front;
		backAnim =	%minorpain_head_back;
		leftAnim =	%minorpain_head_left;
		rightAnim =	%minorpain_head_right;
		break;
	case "left_arm_upper":
	case "left_arm_lower":
	case "left_hand":
		frontAnim =	%minorpain_leftarm_front;
		backAnim =	%minorpain_leftarm_back;
		leftAnim =	%minorpain_leftarm_left;
		rightAnim =	%minorpain_leftarm_right;
		break;
	case "right_arm_upper":
	case "right_arm_lower":
	case "right_hand":
	case "gun":
		frontAnim =	%minorpain_rightarm_front;
		backAnim =	%minorpain_rightarm_back;
		leftAnim =	%minorpain_rightarm_left;
		rightAnim =	%minorpain_rightarm_right;
		break;
	case "none":
	case "left_leg_upper":
	case "left_leg_lower":
	case "left_foot":
	case "right_leg_upper":
	case "right_leg_lower":
	case "right_foot":
//println (self.damagelocation+" "+direction+" "+self.damageTaken);
		return;
	default:
		assertmsg("pain.gsc/HitAnimation: unknown hit location "+self.damageLocation);
		return;
	}

//println (self.damagelocation+" "+direction+" "+self.damageTaken+" "+playHitAnim);
	// Now play the animation for a really sort amount of time.  Weight the animation based on the 
	// damage inflicted (or k-factor?).
	if (playHitAnim)
	{
		if(self.damageTaken > 200)
			weight = 1;
		else
			weight = (self.damageTaken+50.0)/250;
//println (weight);
		// (Note that setanim makes the animation transition to the weight set at a rate of 1 per the time 
		// set, so if the weight is less than 1, I need to set my time longer since it will get there faster 
		// than my time.)
		self clearanim(%minor_pain, 0.1);	// In case there's a minor pain already playing.

		self setanim(frontAnim, animWeights["front"], 0.05, 1);	// Setting the blendtime to 0.05 will result in 
		self setanim(backAnim, animWeights["back"], 0.05, 1);	// some non-linear blending in of these anims, 
		self setanim(leftAnim, animWeights["left"], 0.05, 1);	// but that's not such a bad thing.  A pop 
		self setanim(rightAnim, animWeights["right"], 0.05, 1);	// would be a bad thing.

		self setanim(%minor_pain, weight, (0.05/weight), 1);
		wait 0.05;
		if (!isdefined(self))
			return;
		self clearanim(%minor_pain, (0.2/weight));	// Don't want to leave residue for the next pain.
		wait 0.2;
	}
}

crawlingPain()
{
	/#
	if ( getDvarInt( "scr_forceCrawl" ) == 1 && !isdefined( self.magic_bullet_shield ) )
	{
		self.health = 10;
		self thread crawlingPistol();
		
		self waittill("killanimscript");
		return true;
	}
	#/
	
	legHit = self damageLocationIsAny( "left_leg_upper", "left_leg_lower", "right_leg_upper", "right_leg_lower", "left_foot", "right_foot" );
	
	if ( legHit && self.health < self.maxhealth * .4 )
	{
		if ( gettime() < anim.nextCrawlingPainTimeFromLegDamage )
			return false;
	}
	else
	{
		if ( anim.numDeathsUntilCrawlingPain > 0 )
			return false;
		if ( gettime() < anim.nextCrawlingPainTime )
			return false;
	}
	
	if ( self.team != "axis" )
		return false;
	
	if ( self.a.disableLongDeath || (isDefined( self.dieQuietly ) && self.dieQuietly) )
		return false;

	/*if ( self.a.movement != "stop" )
		return false;*/
	
	if ( self.a.pose != "prone" && self.a.pose != "crouch" && self.a.pose != "stand" )
		return false;
	
	if ( isDefined( self.deathFunction ) )
		return false;
		
	if ( distance( self.origin, level.player.origin ) < 175)
		return false;

	if ( self damageLocationIsAny( "head", "helmet", "gun", "right_hand", "left_hand" ) )
		return false;
		
	if ( usingSidearm() )
		return false;
	
	// we'll wait a bit to see if this crawling pain will really succeed.
	// in the meantime, don't start any other ones.
	anim.nextCrawlingPainTime = gettime() + 3000;
	anim.nextCrawlingPainTimeFromLegDamage = gettime() + 3000;
	
	// needs to be threaded
	self thread crawlingPistol();
	
	self waittill("killanimscript");
	return true;
}


crawlingPistol()
{
	// don't end on killanimscript. pain.gsc will abort if self.crawlingPistolStarting is true.
	self endon ( "kill_long_death" );
	self endon ( "death" );
	
	self.a.array = [];
	self.a.array["stand_2_crawl"] = array( %dying_stand_2_crawl_v1, %dying_stand_2_crawl_v2, %dying_stand_2_crawl_v3 );
	self.a.array["crouch_2_crawl"] = array( %dying_crouch_2_crawl );
	
	self.a.array["crawl"] = %dying_crawl;
	
	self.a.array["death"] = array( %dying_crawl_death_v1, %dying_crawl_death_v2 );
	
	self.a.array["prone_2_back"] = array( %dying_crawl_2_back );
	self.a.array["stand_2_back"] = array( %dying_stand_2_back_v1, %dying_stand_2_back_v2, %dying_stand_2_back_v3 );
	self.a.array["crouch_2_back"] = array( %dying_crouch_2_back );
	
	self.a.array["back_idle"] = %dying_back_idle;
	self.a.array["back_idle_twitch"] = array( %dying_back_twitch_A, %dying_back_twitch_B );
	self.a.array["back_crawl"] = %dying_crawl_back;
	self.a.array["back_fire"] = %dying_back_fire;
	
	self.a.array["back_death"] = array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3 );
	
	self thread preventPainForAShortTime( "crawling" );
	
	self.a.special = "none";

	self thread painDeathNotify();
	//notify ac130 missions that a guy is crawling so context sensative dialog can be played
	level notify ( "ai_crawling", self );
	
	self thread crawling_stab_achievement();
	
	self.isSniper = false;
	
	self setAnimKnobAll( %dying, %body, 1, 0.1, 1 );
	
	// dyingCrawl() returns false if we die without turning around
	if ( !self dyingCrawl() )
		return;
	
	assert( self.a.pose == "stand" || self.a.pose == "crouch" || self.a.pose == "prone" );
	transAnim = self.a.pose + "_2_back";
	
	self setFlaggedAnimKnob( "transition", animArrayPickRandom( transAnim ), 1, 0.5, 1 );
	self animscripts\shared::DoNoteTracksIntercept( "transition", ::handleBackCrawlNotetracks );
	assert( self.a.pose == "back" );
	
	self.a.special = "dying_crawl";
	
	self thread dyingCrawlBackAim();
	
	decideNumCrawls();
	while ( shouldKeepCrawling() )
	{
		crawlAnim = animArray( "back_crawl" );
		delta = getMoveDelta( crawlAnim, 0, 1 );
		endPos = self localToWorldCoords( delta );
		
		if ( !self mayMoveToPoint( endPos ) )
			break;
		
		self setFlaggedAnimKnobRestart( "back_crawl", crawlAnim, 1, 0.1, 1.0 );
		self animscripts\shared::DoNoteTracksIntercept( "back_crawl", ::handleBackCrawlNotetracks );
	}
	
	self.desiredTimeOfDeath = gettime() + randomintrange( 4000, 20000 );
	while ( shouldStayAlive() )
	{
		if ( self canSeeEnemy() && self aimedSomewhatAtEnemy() )
		{
			backAnim = animArray( "back_fire" );
			
			self setFlaggedAnimKnobRestart( "back_idle_or_fire", backAnim, 1, 0.2, 1.0 );
			self animscripts\shared::DoNoteTracks( "back_idle_or_fire" );
		}
		else
		{
			backAnim = animArray( "back_idle" );
			if ( randomfloat(1) < .4 )
				backAnim = animArrayPickRandom( "back_idle_twitch" );
			
			self setFlaggedAnimKnobRestart( "back_idle_or_fire", backAnim, 1, 0.1, 1.0 );
			
			timeRemaining = getAnimLength( backAnim );
			while( timeRemaining > 0 )
			{
				if ( self canSeeEnemy() && self aimedSomewhatAtEnemy() )
					break;
				
				interval = 0.5;
				if ( interval > timeRemaining )
				{
					interval = timeRemaining;
					timeRemaining = 0;
				}
				else
				{
					timeRemaining -= interval;
				}
				self animscripts\shared::DoNoteTracksForTime( interval, "back_idle_or_fire" );
			}
		}
	}
	
	self notify("end_dying_crawl_back_aim");
	self clearAnim( %dying_back_aim_4_wrapper, .3 );
	self clearAnim( %dying_back_aim_6_wrapper, .3 );
	
	self.a.nodeath = true;
	animscripts\death::playDeathAnim( animArrayPickRandom( "back_death" ) );
	self doDamage( self.health + 5, (0,0,0) );

	self.a.special = "none";
}

crawling_stab_achievement()
{
	if( self.team == "allies" )
		return;
	self endon ("end_dying_crawl_back_aim");
	self waittill( "death", attacker, type );
	if( !isdefined( self ) || !isdefined( attacker ) || attacker != level.player )
		return;
	if( type == "MOD_MELEE" )
		maps\_utility::giveachievement_wrapper("NO_REST_FOR_THE_WEARY");
}

shouldStayAlive()
{
	if ( !enemyIsInGeneralDirection( anglesToForward( self.angles ) ) )
		return false;
	
	return gettime() < self.desiredTimeOfDeath;
}

dyingCrawl()
{
	if ( self.a.pose == "prone" )
		return true;
	
	if ( self.a.movement == "stop" )
	{
		if ( randomfloat(1) < .2 ) // small chance of randomness
		{
			if ( randomfloat(1) < .5 )
				return true;
		}
		else
		{
			// if hit from front, return true
			if ( abs( self.damageYaw ) > 90 )
				return true;
		}
	}
	else
	{
		// if we're not stopped, we want to fall in the direction of movement
		// so return true if moving backwards
		if ( abs( self getMotionAngle() ) > 90 )
			return true;
	}
	
	self setFlaggedAnimKnob( "falling", animArrayPickRandom( self.a.pose + "_2_crawl" ), 1, 0.5, 1 );
	self animscripts\shared::DoNoteTracks( "falling" );
	assert( self.a.pose == "prone" );
	
	self.a.special = "dying_crawl";
	
	decideNumCrawls();
	while ( shouldKeepCrawling() )
	{
		crawlAnim = animArray( "crawl" );
		delta = getMoveDelta( crawlAnim, 0, 1 );
		endPos = self localToWorldCoords( delta );

		if ( !self mayMoveToPoint( endPos ) )
			return true;
			
		self setFlaggedAnimKnobRestart( "crawling", crawlAnim, 1, 0.1, 1.0 );
		self animscripts\shared::DoNoteTracks( "crawling" );
	}
	
	// check if target is in cone to shoot
	if ( enemyIsInGeneralDirection( anglesToForward( self.angles ) * -1 ) )
		return true;
	
	self.a.nodeath = true;
	animscripts\death::playDeathAnim( animArrayPickRandom( "death" ) );
	self doDamage( self.health + 5, (0,0,0) );
	
	self.a.special = "none";
	
	return false;
}

dyingCrawlBackAim()
{
	self endon ( "kill_long_death" );
	self endon ( "death" );
	self endon ( "end_dying_crawl_back_aim" );
	
	if ( isdefined( self.dyingCrawlAiming ) )
		return;
	self.dyingCrawlAiming = true;
	
	self setAnimLimited( %dying_back_aim_4, 1, 0 );
	self setAnimLimited( %dying_back_aim_6, 1, 0 );
	
	prevyaw = 0;
	
	while(1)
	{
		aimyaw = self getYawToEnemy();
		
		diff = AngleClamp180( aimyaw - prevyaw );
		if ( abs( diff ) > 3 )
			diff = sign( diff ) * 3;
		
		aimyaw = AngleClamp180( prevyaw + diff );
		
		if ( aimyaw < 0 )
		{
			if ( aimyaw < -45.0 )
				aimyaw = -45.0;
			weight = aimyaw / -45.0;
			self setAnim( %dying_back_aim_4_wrapper, weight, .05 );
			self setAnim( %dying_back_aim_6_wrapper, 0, .05 );
		}
		else
		{
			if ( aimyaw > 45.0 )
				aimyaw = 45.0;
			weight = aimyaw / 45.0;
			self setAnim( %dying_back_aim_6_wrapper, weight, .05 );
			self setAnim( %dying_back_aim_4_wrapper, 0, .05 );
		}
		
		prevyaw = aimyaw;
		
		wait .05;
	}
}

startDyingCrawlBackAimSoon()
{
	self endon ( "kill_long_death" );
	self endon ( "death" );

	wait 0.5;
	self thread dyingCrawlBackAim();
}

handleBackCrawlNotetracks( note )
{
	if ( note == "fire_spray" )
	{
		if ( !self canSeeEnemy() )
			return true;
		
		if ( !self aimedSomewhatAtEnemy() )
			return true;
		
		self shootEnemyWrapper();
		
		return true;
	}
	else if ( note == "pistol_pickup" )
	{
		self thread startDyingCrawlBackAimSoon();
		return false;
	}
	return false;
}

aimedSomewhatAtEnemy()
{
	assert( isValidEnemy( self.enemy ) );
	
	enemyShootAtPos = self.enemy getShootAtPos();
	
	weaponAngles = self gettagangles("tag_weapon");
	anglesToEnemy = vectorToAngles( enemyShootAtPos - self gettagorigin("tag_weapon") );
	
	absyawdiff = AbsAngleClamp180( weaponAngles[1] - anglesToEnemy[1] );
	if ( absyawdiff > 25 )
	{
		if ( distanceSquared( self getShootAtPos(), enemyShootAtPos ) > 64*64 || absyawdiff > 45 )
			return false;
	}
	
	return AbsAngleClamp180( weaponAngles[0] - anglesToEnemy[0] ) <= 30;
}

enemyIsInGeneralDirection( dir )
{
	if ( !isValidEnemy( self.enemy ) )
		return false;
	
	toenemy = vectorNormalize( self.enemy getShootAtPos() - self getEye() );
	
	return (vectorDot( toenemy, dir ) > 0.5); // cos(60) = 0.5
}


preventPainForAShortTime( type )
{
	self endon ( "kill_long_death" );
	self endon ( "death" );
	
	self.flashBangImmunity = true;
	
	self.longDeathStarting = true;
	self.doingLongDeath = true;
	self notify( "long_death" );
	self.health = 10000; // also prevent death
	
	// during this time, we won't be interrupted by more pain.
	// this increases the chances of the crawling pain succeeding.
	wait .75;
	
	// important that we die the next time we get hit,
	// instead of maybe going into pain and coming out and going into combat or something
	if ( self.health > 1 )
		self.health = 1;
	
	// important that we wait a bit in case we're about to start pain later in this frame
	wait .05;
	
	self.longDeathStarting = undefined;
	self.a.mayOnlyDie = true; // we've probably dropped our weapon and stuff; we must not do any other animscripts but death!
	
	if ( type == "crawling" )
	{
		wait 1.0;
		
		// we've essentially succeeded in doing a crawling pain.
		if ( isdefined( level.player ) && distanceSquared( self.origin, level.player.origin ) < 1024 * 1024 )
		{
			anim.numDeathsUntilCrawlingPain = randomintrange( 10, 30 );
			anim.nextCrawlingPainTime = gettime() + randomintrange( 15000, 60000 );
		}
		else
		{
			anim.numDeathsUntilCrawlingPain = randomintrange( 5, 12 );
			anim.nextCrawlingPainTime = gettime() + randomintrange( 5000, 25000 );
		}
		anim.nextCrawlingPainTimeFromLegDamage = gettime() + randomintrange( 7000, 13000 );
		/#
		if ( getDebugDvarInt( "scr_crawldebug" ) == 1 )
		{
			thread printLongDeathDebugText( self.origin + (0,0,64), "crawl death" );
			return;
		}
		#/
	}
	else if ( type == "corner_grenade" )
	{
		wait 1.0;
		
		// we've essentially succeeded in doing a corner grenade death.
		if ( isdefined( level.player ) && distanceSquared( self.origin, level.player.origin ) < 700 * 700 )
		{
			anim.numDeathsUntilCornerGrenadeDeath = randomintrange( 10, 30 );
			anim.nextCornerGrenadeDeathTime = gettime() + randomintrange( 15000, 60000 );
		}
		else
		{
			anim.numDeathsUntilCornerGrenadeDeath = randomintrange( 5, 12 );
			anim.nextCornerGrenadeDeathTime = gettime() + randomintrange( 5000, 25000 );
		}
		/#
		if ( getDebugDvarInt( "scr_cornergrenadedebug" ) == 1 )
		{
			thread printLongDeathDebugText( self.origin + (0,0,64), "grenade death" );
			return;
		}
		#/
	}
}

/#
printLongDeathDebugText( loc, text )
{
	for ( i = 0; i < 100; i++ )
	{
		print3d( loc, text );
		wait .05;
	}
}
#/

decideNumCrawls()
{
	self.a.numCrawls = randomIntRange( 0, 5 );
}

shouldKeepCrawling()
{
	// TODO: player distance checks, etc...
	
	assert( isDefined( self.a.numCrawls ) );
		
	if ( !self.a.numCrawls )
	{
		self.a.numCrawls = undefined;
		return false;
	}
		
	self.a.numCrawls--;
	
	return true;
}


TryCornerRightGrenadeDeath()
{
	/#
	if ( getDvarInt( "scr_forceCornerGrenadeDeath" ) == 1 )
	{
		self thread CornerRightGrenadeDeath();
		self waittill("killanimscript");
		return true;
	}
	#/

	if ( anim.numDeathsUntilCornerGrenadeDeath > 0 )
		return false;
	if ( gettime() < anim.nextCornerGrenadeDeathTime )
		return false;
	
	if ( self.team != "axis" )
		return false;
	
	if ( self.a.disableLongDeath || (isDefined( self.dieQuietly ) && self.dieQuietly) )
		return false;
	
	if ( isDefined( self.deathFunction ) )
		return false;
		
	if ( distance( self.origin, level.player.origin ) < 175)
		return false;

	// we'll wait a bit to see if this crawling pain will really succeed.
	// in the meantime, don't start any other ones.
	anim.nextCornerGrenadeDeathTime = gettime() + 3000;

	self thread CornerRightGrenadeDeath();

	self waittill("killanimscript");
	return true;
}

CornerRightGrenadeDeath()
{
	self endon ( "kill_long_death" );
	self endon ( "death" );
	
	self thread painDeathNotify();
	
	self thread preventPainForAShortTime( "corner_grenade" );
	
	self thread maps\_utility::set_battlechatter( false );
	
	self.threatbias = -1000; // no need for AI to target me
	
	self setFlaggedAnimKnobAllRestart( "corner_grenade_pain", %corner_standR_death_grenade_hit, %body, 1, .1 );

	//wait getAnimLength( %corner_standR_death_grenade_hit ) * 0.2;
	self waittillmatch( "corner_grenade_pain", "dropgun" );
	self animscripts\shared::DropAllAIWeapons();
	
	self waittillmatch( "corner_grenade_pain", "anim_pose = \"back\"" );
	self.a.pose = "back";
	
	self waittillmatch( "corner_grenade_pain", "grenade_left" );
	model = getWeaponModel( "fraggrenade" );
	self attach( model, "tag_inhand" );
	self.deathFunction = ::prematureCornerGrenadeDeath;
	
	self waittillmatch( "corner_grenade_pain", "end" );
	
	
	desiredDeathTime = gettime() + randomintrange( 25000, 60000 );
	
	self setFlaggedAnimKnobAllRestart( "corner_grenade_idle", %corner_standR_death_grenade_idle, %body, 1, .2 );
	
	self thread watchEnemyVelocity();
	while( !enemyIsApproaching() )
	{
		if ( gettime() >= desiredDeathTime )
			break;
		
		self animscripts\shared::DoNoteTracksForTime( 0.1, "corner_grenade_idle" );
	}
	
	dropAnim = %corner_standR_death_grenade_slump;
	self setFlaggedAnimKnobAllRestart( "corner_grenade_release", dropAnim, %body, 1, .2 );
	
	dropTimeArray = getNotetrackTimes( dropAnim, "grenade_drop" );
	assert( dropTimeArray.size == 1 );
	dropTime = dropTimeArray[0] * getAnimLength( dropAnim );
	
	wait dropTime - 1.0;
	
	self animscripts\death::PlayDeathSound();
	
	wait 0.7;
	
	self.deathFunction = ::waitTillGrenadeDrops;
	
	velocity = (0,0,30) - anglesToRight( self.angles ) * 70;
	self CornerDeathReleaseGrenade( velocity, randomfloatrange( 2.0, 3.0 ) );
	
	wait .05;
	self detach( model, "tag_inhand" );
	
	self thread killSelf();
}

CornerDeathReleaseGrenade( velocity, fusetime )
{
	releasePoint = self getTagOrigin( "tag_inhand" );
	
	// avoid dropping under the floor.
	releasePointLifted = releasePoint + (0,0,20);
	releasePointDropped = releasePoint - (0,0,20);
	trace = bullettrace( releasePointLifted, releasePointDropped, false, undefined );
	
	if ( trace["fraction"] < .5 )
		releasePoint = trace["position"];
	
	surfaceType = "default";
	if ( trace["surfacetype"] != "none" )
		surfaceType = trace["surfacetype"];
	
	// play the grenade drop sound because we're probably not dropping it with enough velocity for it to play it normally
	thread playSoundAtPoint( "grenade_bounce_" + surfaceType, releasePoint );
	
	self.grenadeWeapon = "fraggrenade";
	self magicGrenadeManual( releasePoint, velocity, fusetime );
}

playSoundAtPoint( alias, origin )
{
	org = spawn( "script_origin", origin );
	org playsound( alias, "sounddone" );
	org waittill( "sounddone" );
	org delete();
}

killSelf()
{
	self.a.nodeath = true;
	self doDamage( self.health + 5, (0,0,0) );
	self startragdoll();
	wait .1;
	self notify("grenade_drop_done");
}

enemyIsApproaching()
{
	if ( !isValidEnemy( self.enemy ) )
		return false;
	if ( distanceSquared( self.origin, self.enemy.origin ) > 384 * 384 )
		return false;
	if ( distanceSquared( self.origin, self.enemy.origin ) < 128 * 128 )
		return true;
	
	predictedEnemyPos = self.enemy.origin + self.enemyVelocity * 3.0;
	
	nearestPos = self.enemy.origin;
	if ( self.enemy.origin != predictedEnemyPos )
		nearestPos = pointOnSegmentNearestToPoint( self.enemy.origin, predictedEnemyPos, self.origin );
	
	if ( distanceSquared( self.origin, nearestPos ) < 128 * 128 )
		return true;
	
	return false;
}

prematureCornerGrenadeDeath()
{
	deathArray = array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 );
	deathAnim = deathArray[ randomint( deathArray.size ) ];
	
	self animscripts\death::PlayDeathSound();
	
	self setFlaggedAnimKnobAllRestart( "corner_grenade_die", deathAnim, %body, 1, .2 );
	
	velocity = getGrenadeDropVelocity();
	self CornerDeathReleaseGrenade( velocity, 3.0 );
	
	model = getWeaponModel( "fraggrenade" );
	self detach( model, "tag_inhand" );
	
	wait .05;
	
	self startragdoll();
	
	self waittillmatch( "corner_grenade_die", "end" );
}

waitTillGrenadeDrops()
{
	self waittill("grenade_drop_done");
}

watchEnemyVelocity()
{
	self endon ( "kill_long_death" );
	self endon ( "death" );
	
	self.enemyVelocity = (0,0,0);
	
	prevenemy = undefined;
	prevpos = self.origin;

	interval = .15;
	
	while(1)
	{
		if ( isdefined( self.enemy ) && isdefined( prevenemy ) && self.enemy == prevenemy )
		{
			curpos = self.enemy.origin;
			self.enemyVelocity = vectorScale( curpos - prevpos, 1 / interval );
			prevpos = curpos;
		}
		else
		{
			if ( isdefined( self.enemy ) )
				prevpos = self.enemy.origin;
			else
				prevpos = self.origin;
			prevenemy = self.enemy;
			
			self.shootEntVelocity = (0,0,0);
		}
		
		wait interval;
	}
}

