// Shared.gsc - Functions that are shared between animscripts and level scripts.  
// Functions in this file can't rely on the animscripts\init function having run, and can't call any 
// functions not allowed in level scripts.

#include maps\_utility;
#include animscripts\utility;
#include animscripts\combat_utility;
#include common_scripts\utility;

#using_animtree ("generic_human");

placeWeaponOn( weapon, position )
{	
	//prof_begin( "placeWeaponOn" );
	// make sure this it one of our weapons
	assert( AIHasWeapon( weapon ) );
	
	self notify("weapon_position_change");
	
	curPosition = self.weaponInfo[weapon].position;
	
	// make sure we're not out of sync
	assert( curPosition == "none" || self.a.weaponPos[curPosition] == weapon );
	
	// weapon already in place
	if ( position != "none" && self.a.weaponPos[position] == weapon )
	{
		//prof_end( "placeWeaponOn" );
		return;
	}
	
	self detachAllWeaponModels();
	
	// detach if we're already in a position
	if ( curPosition != "none" )
		self detachWeapon( weapon );
		
	// nothing more to do
	if ( position == "none" )
	{
		self updateAttachedWeaponModels();
		//prof_end( "placeWeaponOn" );
		return;
	}

	if ( self.a.weaponPos[position] != "none" )
		self detachWeapon( self.a.weaponPos[position] );

	// to ensure that the correct tags for the active weapon are used, we need to make sure it gets attached first
	if ( position == "left" || position == "right" )
	{
		self attachWeapon( weapon, position );
		self.weapon = weapon;
		
		self.aimThresholdYaw = 10;
		self.aimThresholdPitch = 20;
	}
	else
	{
		self attachWeapon( weapon, position );
	}

	self updateAttachedWeaponModels();
	
	// make sure we don't have a weapon in each hand
	assert( self.a.weaponPos["left"] == "none" || self.a.weaponPos["right"] == "none" );
	//prof_end( "placeWeaponOn" );
}

detachWeapon( weapon )
{
	self.a.weaponPos[self.weaponInfo[weapon].position] = "none";
	self.weaponInfo[weapon].position = "none";
}


attachWeapon( weapon, position )
{
	self.weaponInfo[weapon].position = position;
	self.a.weaponPos[position] = weapon;
}

detachAllWeaponModels()
{
	positions = [];
	positions[positions.size] = "right";
	positions[positions.size] = "left";
	positions[positions.size] = "chest";
	positions[positions.size] = "back";

	self laserOff();

	for ( index = 0; index < positions.size; index++ )
	{
		weapon = self.a.weaponPos[positions[index]];
		
		if ( weapon == "none" )
			continue;
			
		self detach( getWeaponModel( weapon ), getTagForPos( positions[index] ) );
	}	
}

updateAttachedWeaponModels()
{
	positions = [];
	positions[positions.size] = "right";
	positions[positions.size] = "left";
	positions[positions.size] = "chest";
	positions[positions.size] = "back";

	for ( index = 0; index < positions.size; index++ )
	{
		weapon = self.a.weaponPos[positions[index]];
		
		if ( weapon == "none" )
			continue;
			
		self attach( getWeaponModel( weapon ), getTagForPos( positions[index] ) );

		if ( self.weaponInfo[weapon].useClip && !self.weaponInfo[weapon].hasClip )
			self hidepart( "tag_clip" );
	}

	self updateLaserStatus();
}

updateLaserStatus()
{
	// we have no weapon so there's no laser to turn off or on
	if ( self.a.weaponPos["right"] == "none" )
		return;
		
	if( canUseLaser() )
		self laserOn();
	else
		self laserOff();
}

canUseLaser()
{
	if( !self.a.laserOn )
		return false;

	// shotguns don't have lasers
	if ( weapon_spread() )
		return false;
		
	if( !isDefined( level.player.nightVision_Enabled ) )
		return false;
	
	return isAlive( self );
}

getTagForPos( position )
{
	switch ( position )
	{
		case "chest":
			return "tag_weapon_chest";
		case "back":
			return "tag_stowed_back";
		case "left":
			return "tag_weapon_left";
		case "right":
			return "tag_weapon_right";
		case "hand":
			return "tag_inhand";
		default:
			assertMsg( "unknown weapon placement position: " + position );
		break;
	}
}



DropAIWeapon()
{
	if ( self.weapon == "none" )
		return;
	
	position = self.weaponInfo[ self.weapon ].position;
	
	if ( getdvarint( "scr_physWeaponDrop" ) != 0 )
	{
		self dropPhysWeapon();
		self.weapon = "none";
		return;
	}
	
	if( self.dropWeapon )
	{
		dropWeaponName = self.weapon;
		if ( issubstr( tolower( self.weapon ), "rpg" ) )
			dropWeaponName = "rpg_player";
		self DropWeapon( dropWeaponName, position, 0 );
	}
	animscripts\shared::placeWeaponOn( self.weapon, "none" );
	self.weapon = "none";
}


DropAllAIWeapons()
{
	positions = [];
	positions[positions.size] = "left";
	positions[positions.size] = "right";
	positions[positions.size] = "chest";
	positions[positions.size] = "back";
	
	self detachAllWeaponModels();
	
	for ( index = 0; index < positions.size; index++ )
	{
		weapon = self.a.weaponPos[ positions[ index ] ];
		
		if ( weapon == "none" )
			continue;

		self.weaponInfo[ weapon ].position = "none";
		self.a.weaponPos[ positions[ index ] ] = "none";

		if ( getdvarint( "scr_physWeaponDrop" ) != 0 )
		{
			self dropPhysWeapon( positions[index] );
		}
		else 
		{
			if ( issubstr( tolower( weapon ), "rpg" ) )
				weapon = "rpg_player";
			self DropWeapon( weapon, positions[ index ], 0 );
		}	
	}
	
	self.weapon = "none";
}


dropPhysWeapon( pos )
{
	//prof_begin( "dropPhysWeapon" );
	
	tagName = self getTagForPos( pos ); 
	tagOrigin = self getTagOrigin( tagName );
	tagAngles = self getTagAngles( tagName );
	
	physWeapon = spawn( "script_model", tagOrigin );
	physWeapon.angles = tagAngles;
	physWeapon setModel( getWeaponModel( self.a.weaponPos[pos] ) );
	physWeapon thread addPhysWeapon();
	
	animscripts\shared::placeWeaponOn( self.a.weaponPos[pos], "none" );
	
	physWeapon physicsLaunch( tagOrigin + (randomFloat(6),randomFloat(6),randomFloat(6)), (randomFloat(500)-250,randomFloat(500)-250,randomFloat(50)) );

	//prof_end( "dropPhysWeapon" );
}


addPhysWeapon()
{
	self thread deleteAtLimit();
}


deleteAtLimit()
{
	wait 30.0;
	
	self delete();
}


LookAtEntity(lookTargetEntity, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	return;
/*
	assertEX(isAI(self), "Can only call this function on an AI character");											
	assert]](self.a.targetLookInitilized == true, "LookAtEntity called on AI that lookThread was not called on");	#/
	assert]](isDefined(lookTargetEntity), "lookTargetEntity is not defined");											#/
	assert]]( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");					#/
	assert]]( !isDefined(interruptOthers) || (interruptOthers=="interrupt") || (interruptOthers=="don't interrupt") );	#/
	// If interruptOthers is set, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to "interrupt".
	if ( !isDefined(interruptOthers) || (interruptOthers=="interrupt") || (GetTime() > self.a.lookEndTime) )
	{
		if(isSentient(lookTargetEntity))
			self.a.lookTargetType = "sentient";
		else
			self.a.lookTargetType = "entity";
		self.a.lookTargetEntity = lookTargetEntity;
		self.a.lookEndTime = GetTime() + (lookDuration*1000);
		if(lookSpeed == "casual")
			self.a.lookTargetSpeed = 800;
		else // alert
			self.a.lookTargetSpeed = 1600;
		if ( isDefined(eyesOnly) && (eyesOnly=="eyes only") )
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}
*/
}

LookAtPosition(lookTargetPos, lookDuration, lookSpeed, eyesOnly, interruptOthers)
{
	assertEX(isAI(self), "Can only call this function on an AI character");											
	assertEX(self.a.targetLookInitilized == true, "LookAtPosition called on AI that lookThread was not called on");	
	assertEX( (lookSpeed == "casual") || (lookSpeed == "alert"), "lookSpeed must be casual or alert");					
	// If interruptOthers is true, and there is another lookAt playing, then don't do anything.  InterruptOthers defaults to true.
	if ( !isDefined(interruptOthers) || (interruptOthers=="interrupt others") || (GetTime() > self.a.lookEndTime) )
	{
		self.a.lookTargetPos = lookTargetPos;
		self.a.lookEndTime = GetTime() + (lookDuration*1000);
		if(lookSpeed == "casual")
			self.a.lookTargetSpeed = 800;
		else // alert
			self.a.lookTargetSpeed = 1600;
		if ( isDefined(eyesOnly) && (eyesOnly=="eyes only") )
		{
			self notify("eyes look now");
		}
		else
		{
			self notify("look now");
		}
	}

}

LookAtStop()
{
	assertEX(isAI(self), "Can only call this function on an AI character");
	assertEX(self.a.targetLookInitilized == true, "LookAtStop called on AI that lookThread was not called on");

	animscripts\look::finishLookAt();
}

LookAtAnimations(leftanim, rightanim)
{
	self.a.LookAnimationLeft = leftanim;
	self.a.LookAnimationRight = rightanim;
}


/#
showNoteTrack( note )
{
	if ( getdebugdvar("scr_shownotetracks") != "on" && getdebugdvarint("scr_shownotetracks") != self getentnum() )
		return;
	
	self endon("death");
	
	anim.showNotetrackSpeed = 30; // units/sec
	anim.showNotetrackDuration = 30; // frames
	
	if ( !isdefined( self.a.shownotetrackoffset ) )
	{
		thisoffset = 0;
		self.a.shownotetrackoffset = 10;
		self thread reduceShowNotetrackOffset();
	}
	else
	{
		thisoffset = self.a.shownotetrackoffset;
		self.a.shownotetrackoffset += 10;
	}
	
	duration = anim.showNotetrackDuration + int(20.0 * thisoffset / anim.showNotetrackSpeed);
	
	color = (.5,.75,1);
	if ( note == "end" || note == "finish" )
		color = (.25,.4,.5);
	else if ( note == "undefined" )
		color = (1,.5,.5);
	
	for ( i = 0; i < duration; i++ )
	{
		if ( duration - i <= anim.showNotetrackDuration )
			amnt = 1.0 * (i - (duration - anim.showNotetrackDuration)) / anim.showNotetrackDuration;
		else
			amnt = 0.0;
		time = 1.0 * i / 20;
		
		alpha = 1.0 - amnt*amnt;
		pos = self geteye() + (0, 0, 20 + anim.showNotetrackSpeed * time - thisoffset);
		
		print3d( pos, note, color, alpha );
		
		wait .05;
	}
}
reduceShowNotetrackOffset()
{
	self endon("death");
	while( self.a.shownotetrackoffset > 0 )
	{
		wait .05;
		self.a.shownotetrackoffset -= anim.showNotetrackSpeed * .05;
	}
	self.a.shownotetrackoffset = undefined;
}
#/

HandleDogSoundNoteTracks( note )
{
	if ( note == "sound_dogstep_run_default" )
	{
		self playsound( "dogstep_run_default" );
		return true;
	}

	prefix = getsubstr( note, 0, 5 );

	if ( prefix != "sound" )
		return false;
		
	alias = "anml" + getsubstr( note, 5 );
		
//	if ( growling() && !issubstr( alias, "growl" ) )
//		return false;

	if ( isalive( self ) )
		self thread play_sound_on_tag_endon_death( alias, "tag_eye" );
	else
		self thread play_sound_in_space( alias, self gettagorigin( "tag_eye" ) );
	return true;
}

growling()
{
	return isdefined( self.script_growl );
}

registerNoteTracks()
{
	anim.notetracks["anim_pose = \"stand\""] = ::noteTrackPoseStand;
	anim.notetracks["anim_pose = \"crouch\""] = ::noteTrackPoseCrouch;
	anim.notetracks["anim_pose = \"prone\""] = ::noteTrackPoseProne;
	anim.notetracks["anim_pose = \"crawl\""] = ::noteTrackPoseCrawl;
	anim.notetracks["anim_pose = \"back\""] = ::noteTrackPoseBack;

	anim.notetracks["anim_movement = \"stop\""] = ::noteTrackMovementStop;
	anim.notetracks["anim_movement = \"walk\""] = ::noteTrackMovementWalk;
	anim.notetracks["anim_movement = \"run\""] = ::noteTrackMovementRun;

	anim.notetracks["anim_aiming = 1"] = ::noteTrackAlertnessAiming;
	anim.notetracks["anim_aiming = 0"] = ::noteTrackAlertnessAlert;
	anim.notetracks["anim_alertness = causal"] = ::noteTrackAlertnessCasual;
	anim.notetracks["anim_alertness = alert"] = ::noteTrackAlertnessAlert;
	anim.notetracks["anim_alertness = aiming"] = ::noteTrackAlertnessAiming;
	
	anim.notetracks["gunhand = (gunhand)_left"] = ::noteTrackGunhand;
	anim.notetracks["anim_gunhand = \"left\""] = ::noteTrackGunhand;
	anim.notetracks["gunhand = (gunhand)_right"] = ::noteTrackGunhand;
	anim.notetracks["anim_gunhand = \"right\""] = ::noteTrackGunhand;	
	anim.notetracks["anim_gunhand = \"none\""] = ::noteTrackGunhand;	
	anim.notetracks["gun drop"] = ::noteTrackGunDrop;
	anim.notetracks["dropgun"] = ::noteTrackGunDrop;

	anim.notetracks["gun_2_chest"] = ::noteTrackGunToChest;	
	anim.notetracks["gun_2_back"] = ::noteTrackGunToBack;	
	anim.notetracks["pistol_pickup"] = ::noteTrackPistolPickup;
	anim.notetracks["pistol_putaway"] = ::noteTrackPistolPutaway;
	anim.notetracks["drop clip"] = ::noteTrackDropClip;
	anim.notetracks["refill clip"] = ::noteTrackRefillClip;
	anim.notetracks["reload done"] = ::noteTrackRefillClip;
	anim.notetracks["load_shell"] = ::noteTrackLoadShell;
	anim.notetracks["pistol_rechamber"] = ::noteTrackPistolRechamber;
	
	anim.notetracks["gravity on"] = ::noteTrackGravity;
	anim.notetracks["gravity off"] = ::noteTrackGravity;

	anim.notetracks["bodyfall large"] = ::noteTrackBodyFall;
	anim.notetracks["bodyfall small"] = ::noteTrackBodyFall;
	
	anim.notetracks["footstep"] = ::noteTrackFootStep;
	anim.notetracks["step"] = ::noteTrackFootStep;
	anim.notetracks["footstep_right_large"] = ::noteTrackFootStep;
	anim.notetracks["footstep_right_small"] = ::noteTrackFootStep;
	anim.notetracks["footstep_left_large"] = ::noteTrackFootStep;
	anim.notetracks["footstep_left_small"] = ::noteTrackFootStep;
	anim.notetracks["footscrape"] = ::noteTrackFootScrape;
	anim.notetracks["land"] = ::noteTrackLand;
	
	anim.notetracks["laser_on"] = ::noteTrackLaser;
	anim.notetracks["laser_off"] = ::noteTrackLaser;
	
	anim.notetracks["start_ragdoll"] = ::noteTrackStartRagdoll;

	anim.notetracks["fire"] = ::noteTrackFire;
	anim.notetracks["fire_spray"] = ::noteTrackFireSpray;
}

noteTrackFire( note, flagName )
{
	if ( isdefined( anim.fire_notetrack_functions[ self.a.script ] ) )
		thread [[ anim.fire_notetrack_functions[ self.a.script ] ]]();
	else
		thread [[ animscripts\shared::shootNotetrack ]]();
}

noteTrackLaser( note, flagName )
{
	if ( isSubStr( note, "on" ) )
		self.a.laserOn = true;
	else
		self.a.laserOn = false;
	self animscripts\shared::updateLaserStatus();
}


noteTrackStopAnim( note, flagName )
{
}

noteTrackStartRagdoll( note, flagName )
{
	if( isdefined( self.noragdoll ) ) 
		return; // Nate - hack for armless zakhaev who doesn't do ragdoll
	self unlink();
	self startRagdoll(); 
}

noteTrackMovementStop( note, flagName )
{
	self.a.movement = "stop";
}

noteTrackMovementWalk( note, flagName )
{
	self.a.movement = "walk";
}

noteTrackMovementRun( note, flagName )
{
	self.a.movement = "run";
}


noteTrackAlertnessAiming( note, flagName )
{
	self.a.alertness = "aiming";
}

noteTrackAlertnessCasual( note, flagName )
{
	self.a.alertness = "casual";
}

noteTrackAlertnessAlert( note, flagName )
{
	self.a.alertness = "alert";
}


noteTrackPoseStand( note, flagName )
{
	if (self.a.pose == "prone")
	{
		self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}
	self.a.pose = "stand";
	self notify ("entered_pose" + "stand");
}

noteTrackPoseCrouch( note, flagName )
{
	if (self.a.pose == "prone")
	{
		self OrientMode ("face default");	// We were most likely in "face current" while we were prone.
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}
	self.a.pose = "crouch";
	self notify ("entered_pose" + "crouch");
	if (self.a.crouchPain)
	{
		// for dying pain
		self.a.crouchPain = false;
		self.health = 150;
	}
}

noteTrackPoseProne( note, flagName )
{
	self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
	self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
	self.a.pose = "prone";
	self notify ("entered_pose" + "prone");
}


noteTrackPoseCrawl( note, flagName )
{
	self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
	self EnterProneWrapper(1.0); // make code start lerping in the prone orientation to ground
	self.a.pose = "prone";
	self notify ("entered_pose" + "prone");
}


noteTrackPoseBack( note, flagName )
{
	if (self.a.pose == "prone")
	{
		self ExitProneWrapper(1.0); // make code stop lerping in the prone orientation to ground
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	}
	self.a.pose = "back";
	self notify ("entered_pose" + "back");
	self.a.movement = "stop";
}


noteTrackGunHand( note, flagName )
{
	if ( isSubStr( note, "left" ) )
		animscripts\shared::placeWeaponOn( self.weapon, "left" );
	else if ( isSubStr( note, "right" ) )
		animscripts\shared::placeWeaponOn( self.weapon, "right" );
	else if ( isSubStr( note, "none" ) )
		animscripts\shared::placeWeaponOn( self.weapon, "none" );
}


noteTrackGunDrop( note, flagName )
{
	self animscripts\shared::DropAIWeapon();
	
	if ( self.weapon == self.primaryweapon )
		self.weapon = self.secondaryweapon;
	else if ( self.weapon == self.secondaryweapon )
		self.weapon = self.primaryweapon;
		
	self.lastWeapon = self.weapon;
}


noteTrackGunToChest( note, flagName )
{
	//assert( !usingSidearm() );
	animscripts\shared::placeWeaponOn( self.weapon, "chest" );
}


noteTrackGunToBack( note, flagName )
{
	animscripts\shared::placeWeaponOn( self.weapon, "back" );
	// TODO: more asserts and elegant handling of weapon switching here
	self.weapon = self getPreferredWeapon();
	self.bulletsInClip = weaponClipSize( self.weapon );
}


noteTrackPistolPickup( note, flagName )
{
	animscripts\shared::placeWeaponOn( self.sidearm, "right" );
	self.bulletsInClip = weaponClipSize( self.weapon );
	self notify ( "weapon_switch_done" );
}

	
noteTrackPistolPutaway( note, flagName )
{
	animscripts\shared::placeWeaponOn( self.weapon, "none" );
	// TODO: more asserts and elegant handling of weapon switching here
	self.weapon = self getPreferredWeapon();
	self.bulletsInClip = weaponClipSize( self.weapon );
}

	
noteTrackDropClip( note, flagName )
{
	self thread handleDropClip( flagName );
}


noteTrackRefillClip( note, flagName )
{
	if ( weaponClass( self.weapon ) == "rocketlauncher" )
		self showRocket();
	self animscripts\weaponList::RefillClip();
	self.a.needsToRechamber = 0;
}

noteTrackLoadShell( note, flagName )
{
	self playSound("weap_reload_shotgun_loop_npc");
}

noteTrackPistolRechamber( note, flagName )
{
	self playSound("weap_reload_pistol_chamber_npc");
}

noteTrackGravity( note, flagName )
{
	if ( isSubStr( note, "on" ) )
        self animMode( "gravity" );
	else if ( isSubStr( note, "off" ) )
		self animMode( "nogravity" );
}


noteTrackBodyFall( note, flagName )
{
	if ( isDefined( self.groundType ) )
		groundType = self.groundType;
	else
		groundType = "dirt";
		
	if ( isSubStr( note, "large" ) )
		self playsound ("bodyfall_" + groundType + "_large");
	else if ( isSubStr( note, "small" ) )
		self playsound ("bodyfall_" + groundType + "_small");
}


noteTrackFootStep( note, flagName )
{
	if ( isSubStr( note, "left" ) )
		playFootStep( "J_Ball_LE" );
	else
		playFootStep( "J_BALL_RI" );
	
	self playSound( "gear_rattle_run" );		
}


noteTrackFootScrape( note, flagName )
{
	if ( isDefined( self.groundType ) )
		groundType = self.groundType;
	else
		groundType = "dirt";
		
	self playsound ("step_scrape_" + groundType );
}

	
noteTrackLand( note, flagName )
{
	if ( isDefined( self.groundType ) )
		groundType = self.groundType;
	else
		groundType = "dirt";
		
	self playsound ("land_" + groundType );
}		



HandleNoteTrack( note, flagName, customFunction )
{
	/#
	self thread showNoteTrack( note );
	#/
	
	if ( isAI( self ) && self.type == "dog" )
		if ( HandleDogSoundNoteTracks( note ) )
			return;
	
	notetrackFunc = anim.notetracks[note];
	if ( isDefined( notetrackFunc ) )
	{
		return [[notetrackFunc]]( note, flagName );
	}
	
	switch ( note )
	{
	case "end":
	case "finish":
	case "undefined":
		if ( isAI(self) && self.a.pose=="back" ) 
		{
			//("HACK!  Changing pose \"back\" to \"crouch\" in DoNoteTracks");#/
//			self.a.pose = "crouch";
		}
		return note;


	case "swish small":
		self thread play_sound_in_space ("melee_swing_small", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
//		case "melee":
	case "swish large":
		self thread play_sound_in_space ("melee_swing_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		//self thread play_sound_in_space ("melee_swing_large", self gettagorigin ("TAG_WEAPON_RIGHT"));
		break;
// SOUNDS END

	case "rechamber":
		if ( self usingShotgun() )
			self playSound("weap_reload_shotgun_pump_npc");
		self.a.needsToRechamber = 0;
		break;
	case "no death":
		// does not play a death anim when he dies
		self.a.nodeath = true;
		break;
	case "no pain":
		self.allowpain = false;
		break;		
	case "allow pain":
		self.allowpain = true;
		break;
	case "anim_melee = right":
	case "anim_melee = \"right\"":
		self.a.meleeState = "right";
		break;
	case "anim_melee = left":
	case "anim_melee = \"left\"":
		self.a.meleeState = "left";
		break;
	case "weapon_retrieve":
	/*
		assertEx( isdefined( self.oldWeapon ), "Tried to do notetrack weapon_retrieve but pistol_pickup had never been used" );
		self.secondaryWeapon = self.weapon;
		self.weapon = self.oldWeapon;
		self animscripts\shared::PutGunInHand("right");
		*/
		break;
	case "swap taghelmet to tagleft":
		if ( isDefined ( self.hatModel ) )
		{
			if (isdefined(self.helmetSideModel))
			{
				self detach(self.helmetSideModel, "TAG_HELMETSIDE");
				self.helmetSideModel = undefined;
			}
			self detach ( self.hatModel, "");
			self attach ( self.hatModel, "TAG_WEAPON_LEFT");
			self.hatModel = undefined;
		}
		break;
	case "stop anim":
		anim_stopanimscripted();
		return note;
//		break;
	default:
		if (isDefined(customFunction))
			return [[customFunction]] (note);
		break;
	}
}

// DoNoteTracks waits for and responds to standard noteTracks on the animation, returning when it gets an "end" or a "finish"
// For level scripts, a pointer to a custom function should be passed as the second argument, which handles notetracks not
// already handled by the generic function. This call should take the form DoNoteTracks(flagName, ::customFunction);
// The custom function will be called for each notetrack not recognized, and will pass the notetrack name. Note that this
// function could be called multiple times for a single animation.
DoNoteTracks( flagName, customFunction, debugIdentifier ) // debugIdentifier isn't even used. we should get rid of it.
{
	for (;;)
	{
		self waittill (flagName, note);

		if ( !isDefined( note ) )
			note = "undefined";

		//prof_begin("HandleNoteTrack");
		val = self HandleNoteTrack( note, flagName, customFunction );
		//prof_end("HandleNoteTrack");
		
		if ( isDefined( val ) )
			return val;
	}
}


DoNoteTracksIntercept( flagName, interceptFunction, debugIdentifier ) // debugIdentifier isn't even used. we should get rid of it.
{
	assert( isDefined( interceptFunction ) );
	
	for (;;)
	{
		self waittill ( flagName, note );

		if ( !isDefined( note ) )
			note = "undefined";

		intercepted = [[interceptFunction]]( note );
		if ( isDefined( intercepted ) && intercepted )
			continue;

		//prof_begin("HandleNoteTrack");
		val = self HandleNoteTrack( note, flagName );
		//prof_end("HandleNoteTrack");
		
		if ( isDefined( val ) )
			return val;
	}
}


DoNoteTracksPostCallback( flagName, postFunction )
{
	assert( isDefined( postFunction ) );
	
	for (;;)
	{
		self waittill ( flagName, note );

		if ( !isDefined( note ) )
			note = "undefined";

		//prof_begin("HandleNoteTrack");
		val = self HandleNoteTrack( note, flagName );
		//prof_end("HandleNoteTrack");
		
		[[postFunction]]( note );
		
		if ( isDefined( val ) )
			return val;
	}
}

// Don't call this function except as a thread you're going to kill - it lasts forever.
DoNoteTracksForever(flagName, killString, customFunction, debugIdentifier)
{
	DoNoteTracksForeverProc( ::DoNoteTracks, flagName, killString, customFunction, debugIdentifier);
}

DoNoteTracksForeverIntercept(flagName, killString, interceptFunction, debugIdentifier)
{
	DoNoteTracksForeverProc( ::DoNoteTracksIntercept, flagName, killString, interceptFunction, debugIdentifier );
}

DoNoteTracksForeverProc( notetracksFunc, flagName, killString, customFunction, debugIdentifier )
{
	if (isdefined (killString))
		self endon (killString);
	self endon ("killanimscript");
	if (!isDefined(debugIdentifier))
		debugIdentifier = "undefined";

	for (;;)
	{
		//prof_begin( "DoNoteTracksForeverProc" );
		time = GetTime();
		//prof_begin( "notetracksFunc" );
		returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
		//prof_end( "notetracksFunc" );
		timetaken = GetTime() - time;
		if ( timetaken < 0.05)
		{
			time = GetTime();
			//prof_begin( "notetracksFunc" );
			returnedNote = [[notetracksFunc]](flagName, customFunction, debugIdentifier);
			//prof_end( "notetracksFunc" );
			timetaken = GetTime() - time;
			if ( timetaken < 0.05)
			{
				println (GetTime()+" "+debugIdentifier+" animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim "+flagName+", returned "+returnedNote+".");
				wait ( 0.05 - timetaken );
			}
		}
		//(GetTime()+" "+debugIdentifier+" DoNoteTracksForever returned in "+timetaken+" ms.");#/
		//prof_end( "DoNoteTracksForeverProc" );
	}
}

// Designed for using DoNoteTracks on looping animations, so you can wait for a time instead of the "end" parameter
DoNoteTracksForTime(time, flagName, customFunction, debugIdentifier)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc( ::DoNoteTracksForever, time, flagName, customFunction, debugIdentifier, ent);
}

DoNoteTracksForTimeIntercept( time, flagName, interceptFunction, debugIdentifier)
{
	ent = spawnstruct();
	ent thread doNoteTracksForTimeEndNotify(time);
	DoNoteTracksForTimeProc( ::DoNoteTracksForeverIntercept, time, flagName, interceptFunction, debugIdentifier, ent);
}

DoNoteTracksForTimeProc( doNoteTracksForeverFunc, time, flagName, customFunction, debugIdentifier, ent)
{
	ent endon ("stop_notetracks");
	[[doNoteTracksForeverFunc]](flagName, undefined, customFunction, debugIdentifier);
}

doNoteTracksForTimeEndNotify(time)
{
	wait (time);
	self notify ("stop_notetracks");
}

playFootStep(foot)
{
	if (! isAI(self) )
	{
		self playsound ("step_run_dirt");	
		return;
	}

	groundType = undefined;
	// gotta record the groundtype in case it goes undefined on us
	if (!isdefined(self.groundtype))
	{
		if (!isdefined(self.lastGroundtype))
		{
			self playsound ("step_run_dirt");	
			return;
		}

		groundtype = self.lastGroundtype;
	}
	else
	{
		groundtype = self.groundtype;
		self.lastGroundtype = self.groundType;
	}
	
	self playsound ("step_run_" + groundType);
	[[anim.optionalStepEffectFunction]](foot, groundType);
}


playFootStepEffect(foot, groundType)
{
	for (i=0;i<anim.optionalStepEffects.size;i++)
	{
		if (groundType != anim.optionalStepEffects[i])
			continue;
		org = self gettagorigin(foot);
		playfx(level._effect["step_" + anim.optionalStepEffects[i]], org, org + (0,0,100));
		return;
	}
}

shootNotetrack()
{
	waittillframeend; // this gives a chance for anything else waiting on "fire" to shoot
	if ( gettime() > self.a.lastShootTime ) 
	{
		self shootEnemyWrapper();
		self decrementBulletsInClip();
		if ( weaponClass( self.weapon ) == "rocketlauncher" )
			self.a.rockets--;
	}
}

fire_straight()
{
	if ( self.a.weaponPos[ "right" ] == "none" )
		return;
		
	if ( isdefined( self.dontShootStraight ) )
	{
		shootNotetrack();
		return;
	}
	
	weaporig = self gettagorigin( "tag_weapon" );
	dir = anglestoforward( self gettagangles( "tag_weapon" ) );
	pos = weaporig + vectorScale( dir, 1000 );
	// note, shootwrapper is not called because shootwrapper applies a random spread, and shots
	// fired in a scripted sequence need to go perfectly straight so they get the same result each time.
	self shoot( 1, pos );
	self decrementBulletsInClip();
}

noteTrackFireSpray( note, flagName )
{
	// TODO: make AI not use anims with this notetrack if they don't have a weapon
	if ( self.a.weaponPos["right"] == "none" )
		return;
	
	//prof_begin( "noteTrackFireSpray" );

	weaporig = self gettagorigin("tag_weapon");
	dir = anglestoforward( self gettagangles( "tag_weapon" ) );
	
	hitenemy = false;
	// check if we're aiming closish to our enemy
	if ( issentient(self.enemy) && isalive(self.enemy) && self canShoot( self.enemy getShootAtPos() ) )
	{
		enemydir = vectornormalize(self.enemy geteye() - weaporig);
		if ( vectordot(dir, enemydir) > cos(10) )
		{
			hitenemy = true;
		}
	}
	
	if ( hitenemy )
	{
		self shootEnemyWrapper();
	}
	else
	{
		dir += ((randomfloat(2)-1) * .1, (randomfloat(2)-1) * .1, (randomfloat(2)-1) * .1);
		pos = weaporig + vectorScale(dir, 1000);
		
		self shootPosWrapper( pos );
	}
	
	self decrementBulletsInClip();
	
	//prof_end( "noteTrackFireSpray" );
}


getPredictedAimYawToShootEntOrPos(time)
{
	if ( !isdefined( self.shootEnt ) )
	{
		if ( !isdefined( self.shootPos ) )
			return 0;
		
		return getAimYawToPoint( self.shootPos );
	}
	
	predictedPos = self.shootEnt.origin + vectorScale( self.shootEntVelocity, time );
	return getAimYawToPoint( predictedPos );
}

getAimYawToShootEntOrPos()
{
	// make use of the fact that shootPos = shootEnt getShootAtPos() if shootEnt is defined
	if ( !isdefined( self.shootEnt ) )
	{
		if ( !isdefined( self.shootPos ) )
			return 0;
		
		return getAimYawToPoint( self.shootPos );
	}
	
	return getAimYawToPoint( self.shootEnt getShootAtPos() );
}

getAimPitchToShootEntOrPos()
{
	pitch = getPitchToShootEntOrPos();
	if ( self.a.script == "cover_crouch" && isdefined( self.a.coverMode ) && self.a.coverMode == "lean" )
		pitch -= anim.coverCrouchLeanPitch;
	return pitch;
}

getPitchToShootEntOrPos()
{
	if ( !isdefined( self.shootEnt ) )
	{
		// make use of the fact that shootPos = shootEnt getShootAtPos() if shootEnt is defined
		if ( !isdefined( self.shootPos ) )
			return 0;
		
		return animscripts\combat_utility::getPitchToSpot( self.shootPos );
	}
	
	return animscripts\combat_utility::getPitchToSpot( self.shootEnt getShootAtPos() );
}

getAimYawToPoint(point)
{
	yaw = GetYawToSpot(point);

	// need to have fudge factor because the gun's origin is different than our origin,
	// the closer our distance, the more we need to fudge. 
	dist = distance(self.origin,point);
	if(dist > 3)
	{
		angleFudge = asin(-3/dist);
		yaw += angleFudge; 
	}
	yaw = AngleClamp180( yaw );
	return yaw;
}

trackShootEntOrPos()
{
	self endon("killanimscript");
	self endon("stop tracking");
	self endon("melee");

	trackLoop( %aim_2, %aim_4, %aim_6, %aim_8 );
}

trackLoop( aim2, aim4, aim6, aim8 )
{
	//prof_begin("trackLoopInit");
	deltaChangePerFrame = 5;
	
	aimBlendTime = .05;
	
	prevYawDelta = 0;
	prevPitchDelta = 0;
	maxYawDeltaChange = 5; // max change in yaw in 1 frame
	maxPitchDeltaChange = 5;
	
	pitchAdd = 0;
	yawAdd = 0;
	
	if ( self.type == "dog" )
	{
		doMaxAngleCheck = false;
		self.shootEnt = self.enemy;
	}
	else
	{
		doMaxAngleCheck = true;
		if ( self.a.script == "cover_crouch" && isdefined( self.a.coverMode ) && self.a.coverMode == "lean" )
			pitchAdd = -1 * anim.coverCrouchLeanPitch;
		if ( (self.a.script == "cover_left" || self.a.script == "cover_right") && isdefined( self.a.cornerMode ) && self.a.cornerMode == "lean" )
			yawAdd = self.coverNode.angles[1] - self.angles[1];
	}
	
	yawDelta = 0;
	pitchDelta = 0;
	
	firstFrame = true;
	
	//prof_end("trackLoopInit");
	
	for(;;)
	{
		//prof_begin("trackLoop");
	
		incrAnimAimWeight();
		
		selfShootAtPos = (self.origin[0], self.origin[1], self getEye()[2]);

		shootPos = self.shootPos;
		if ( isdefined( self.shootEnt ) )
			shootPos = self.shootEnt getShootAtPos();

		if ( !isdefined( shootPos ) && self animscripts\cqb::shouldCQB() )
		{
			selfForward = anglesToForward( self.angles );
			if ( isdefined( self.cqb_target ) )
			{
				shootPos = self.cqb_target getShootAtPos();
				if ( vectorDot( vectorNormalize( shootPos - selfShootAtPos ), selfForward ) < 0.643 ) // 0.643 = cos50
					shootPos = undefined;
			}
			if ( !isdefined( shootPos ) && isdefined( self.cqb_point_of_interest ) )
			{
				shootPos = self.cqb_point_of_interest;
				if ( vectorDot( vectorNormalize( shootPos - selfShootAtPos ), selfForward ) < 0.643 ) // 0.643 = cos50
					shootPos = undefined;
			}
		}
		
		if ( !isdefined( shootPos ) )
		{
			assert( !isdefined( self.shootEnt ) );
			
			if ( isdefined( self.node ) && self.node.type == "Guard" && distanceSquared(self.origin, self.node.origin) < 16 )
			{
				yawDelta = AngleClamp180( self.angles[1] - self.node.angles[1] );
				pitchDelta = 0;
			}
			else
			{
				likelyEnemyDir = self getAnglesToLikelyEnemyPath();
				if ( isdefined( likelyEnemyDir ) )
				{
					yawDelta = AngleClamp180( self.angles[1] - likelyEnemyDir[1] );
					pitchDelta = AngleClamp180( 360 - likelyEnemyDir[0] );
				}
				else
				{
					yawDelta = 0;
					pitchDelta = 0;
				}
			}
		}
		else
		{
			vectorToShootPos = shootPos - selfShootAtPos;
			anglesToShootPos = vectorToAngles( vectorToShootPos );
			
			pitchDelta = 360 - anglesToShootPos[0];
			pitchDelta = AngleClamp180( pitchDelta + pitchAdd );
			
			yawDelta = self.angles[1] - anglesToShootPos[1];
			
			yawDelta = AngleClamp180( yawDelta + yawAdd );
		}
		
		if ( doMaxAngleCheck && ( abs( yawDelta ) > 60 || abs( pitchDelta ) > 60 ) )
		{
			yawDelta = 0;
			pitchDelta = 0;
		}
		else
		{
			if ( yawDelta > self.rightAimLimit )
				yawDelta = self.rightAimLimit;
			else if ( yawDelta < self.leftAimLimit )
				yawDelta = self.leftAimLimit;
			if ( pitchDelta > self.upAimLimit )
				pitchDelta = self.upAimLimit;
			else if ( pitchDelta < self.downAimLimit )
				pitchDelta = self.downAimLimit;
		}
		
		if ( firstFrame )
		{
			firstFrame = false;
		}
		else
		{
			yawDeltaChange = yawDelta - prevYawDelta;
			if ( abs( yawDeltaChange ) > maxYawDeltaChange )
				yawDelta = prevYawDelta + maxYawDeltaChange * sign( yawDeltaChange );
			
			pitchDeltaChange = pitchDelta - prevPitchDelta;
			if ( abs( pitchDeltaChange ) > maxPitchDeltaChange )
				pitchDelta = prevPitchDelta + maxPitchDeltaChange * sign( pitchDeltaChange );
		}
		
		prevYawDelta = yawDelta;
		prevPitchDelta = pitchDelta;
		
		if ( yawDelta > 0 )
		{
			assert( yawDelta <= self.rightAimLimit );
			weight = yawDelta / self.rightAimLimit * self.a.aimweight;
			self setAnimLimited( aim4, 0, aimBlendTime );
			self setAnimLimited( aim6, weight, aimBlendTime );
		}
		else if ( yawDelta < 0 )
		{
			assert( yawDelta >= self.leftAimLimit );
			weight = yawDelta / self.leftAimLimit * self.a.aimweight;
			self setAnimLimited( aim6, 0, aimBlendTime );
			self setAnimLimited( aim4, weight, aimBlendTime );
		}
		
		if ( pitchDelta > 0 )
		{
			assert( pitchDelta <= self.upAimLimit );
			weight = pitchDelta / self.upAimLimit * self.a.aimweight;
			self setAnimLimited( aim2, 0, aimBlendTime );			
			self setAnimLimited( aim8, weight, aimBlendTime );
		}
		else if ( pitchDelta < 0 )
		{
			assert( pitchDelta >= self.downAimLimit );
			weight = pitchDelta / self.downAimLimit * self.a.aimweight;
			self setAnimLimited( aim8, 0, aimBlendTime );
			self setAnimLimited( aim2, weight, aimBlendTime );
		}
		
		//prof_end("trackLoop");
		wait( 0.05 );
	}
}

//setAnimAimWeight works just like setanimlimited on an imaginary anim node that affects the four aiming directions.
setAnimAimWeight(goalweight, goaltime)
{
	if ( !isdefined( goaltime ) || goaltime <= 0 )
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = goalweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = 0;
	}
	else
	{
		self.a.aimweight = goalweight;
		self.a.aimweight_start = self.a.aimweight;
		self.a.aimweight_end = goalweight;
		self.a.aimweight_transframes = int(goaltime * 20);
	}
	self.a.aimweight_t = 0;
}
incrAnimAimWeight()
{
	if ( self.a.aimweight_t < self.a.aimweight_transframes )
	{
		self.a.aimweight_t++;
		t = 1.0 * self.a.aimweight_t / self.a.aimweight_transframes;
		self.a.aimweight = self.a.aimweight_start * (1 - t) + self.a.aimweight_end * t;
	}
}

// decides on the number of shots to do in a burst.
decideNumShotsForBurst()
{
	numShots = 0;
	if ( animscripts\weaponList::usingSemiAutoWeapon() )
		numShots = anim.semiFireNumShots[ randomint( anim.semiFireNumShots.size ) ];
	else if ( self.fastBurst )
		numShots = anim.fastBurstFireNumShots[ randomint( anim.fastBurstFireNumShots.size ) ];
	else
		numShots = anim.burstFireNumShots[ randomint( anim.burstFireNumShots.size ) ];

	if ( numShots <= self.bulletsInClip )
		return numShots;
	
	assertex( self.bulletsInClip >= 0, self.bulletsInClip );
	
	if ( self.bulletsInClip <= 0 )
		return 1;
	
	return self.bulletsInClip;
}

decideNumShotsForFull()
{
	numShots = self.bulletsInClip;
	if ( weaponClass( self.weapon ) == "mg" )
	{
		choice = randomfloat(10);
		if ( choice < 3 )
			numShots = randomIntRange( 2, 6 );
		else if ( choice < 8 )
			numShots = randomIntRange( 6, 12 );
		else
			numShots = randomIntRange( 12, 20 );
	}
	
	return numShots;
}

handleDropClip( flagName )
{
	self endon ( "killanimscript" );
	self endon ( "abort_reload" );
	
	//prof_begin( "handleDropClip" );
	
	clipModel = undefined;
	
	if ( self.weaponInfo[self.weapon].useClip )
	{
		clipModel = getWeaponClipModel( self.weapon );
		
		if ( !isDefined( level.weaponClipModelsLoaded ) || !isDefined( anim._effect[ clipModel ] ) )
		{
			println("^1Warning: Couldn't drop clip model " + clipModel + " because it is not in level.weaponClipModels so it probably wasn't precached.");
			println("^1Set dvar scr_generateClipModels to 1 and map_restart, then follow instructions in console.");
			
			clipModel = undefined;
		}
	}
	
	if ( self.weaponInfo[self.weapon].hasClip )
	{
		if ( weaponAnims() == "pistol" )
			self playsound( "weap_reload_pistol_clipout_npc" );
		else
			self playsound( "weap_reload_smg_clipout_npc" );
		
		if ( isDefined( clipModel ) )
		{
			self hidepart( "tag_clip" );
			assert( isDefined( anim._effect[clipModel] ) );
			playFxOnTag( anim._effect[clipModel], self, "tag_clip" );
			self.weaponInfo[self.weapon].hasClip = false;
			
			self thread resetClipOnAbort( clipModel );
		}
	}
	
	//prof_end( "handleDropClip" );
	
	for ( ;; )
	{
		self waittill( flagName, noteTrack );
		
		switch ( noteTrack )
		{
 		case "attach clip left":
 		case "attach clip right":
 			if ( isdefined( clipModel ) )
 			{
				self attach( clipModel, "tag_inhand" );
				self hidepart( "tag_clip" ); // attach() resets hidden parts, so we must re-hide the clip
				self thread resetClipOnAbort( clipModel, "tag_inhand" );
			}
			
			// if we abort the reload after this point, we don't want to have to do it again
			self animscripts\weaponList::RefillClip();
 			
 			break;
//		case "end":
//		case "finish":
//		case "undefined":
 		case "detach clip right":
 		case "detach clip left":
  			if ( isdefined( clipModel ) )
 			{
				self detach( clipModel, "tag_inhand" );
				self showpart( "tag_clip" );
 				self notify ( "clip_detached" );
				self.weaponInfo[self.weapon].hasClip = true;
			}
			
			if ( weaponAnims() == "pistol" )
				self playsound( "weap_reload_pistol_clipin_npc" );
			else
				self playsound( "weap_reload_smg_clipin_npc" );
 			
			self.a.needsToRechamber = 0;
 			
 			return;
		}
	}
}


resetClipOnAbort( clipModel, currentTag )
{
	self notify ( "clip_detached" );
	self endon ( "clip_detached" );
	//self endon ( "death" ); // don't end on death or we won't delete the clip when we die!
	
	self waittill_any( "killanimscript", "abort_reload" );
	
	// we can be dead but still defined. if we're undefined we got deleted.
	if ( !isDefined( self ) )
		return;
	
	if ( isDefined( currentTag ) )
		self detach( clipModel, currentTag );
	
	if ( isAlive( self ) )
	{
		self showpart( "tag_clip" );
		self.weaponInfo[self.weapon].hasClip = true;
	}
	else
	{
		if ( isDefined( currentTag ) && isDefined( anim._effect[clipModel] ) )
			playFxOnTag( anim._effect[clipModel], self, currentTag );
	}
}


moveToOriginOverTime( origin, time )
{
	self endon("killanimscript");
	
	if ( distanceSquared( self.origin, origin ) > 16*16 && !self mayMoveToPoint( origin ) )
	{
		/# println("^1Warning: AI starting behavior for node at " + origin + " but could not move to that point."); #/
		return;
	}
	
	self.keepClaimedNodeInGoal = true;
	
	offset = self.origin - origin;
	
	frames = int(time * 20);
	offsetreduction = vectorScale( offset, 1.0 / frames );
	
	for ( i = 0; i < frames; i++ )
	{
		offset -= offsetreduction;
		self teleport( origin + offset );
		wait .05;
	}
	
	self.keepClaimedNodeInGoal = false;
}

returnTrue() { return true; }

playLookAnimation( lookAnim, lookTime, canStopCallback )
{
	if ( !isdefined( canStopCallback ) )
		canStopCallback = ::returnTrue;
	
	for ( i = 0; i < lookTime * 10; i++ )
	{
		// Break out if you saw somebody lately
		if ( isalive( self.enemy ) )
		{
			if ( self canSeeEnemy() && [[ canStopCallback ]]() )
				return;
		}
		if ( self isSuppressedWrapper() && [[ canStopCallback ]]() )
			return;
		
		self setAnimKnobAll( lookAnim, %body, 1, .1 );
		wait (0.1);
	}
}


throwDownWeapon( swapAnim )
{
	self endon ( "killanimscript" );

	// Too many issues right now
//	self animMode( "angle deltas" );
//	self setFlaggedAnimKnobAllRestart( "weapon swap", swapAnim, %body, 1, .1, 1 );
//	self DoNoteTracks( "weapon swap" );

	self animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
	
	self maps\_gameskill::didSomethingOtherThanShooting();
}

