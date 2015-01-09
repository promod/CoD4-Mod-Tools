#include animscripts\utility;
#include maps\_utility;
#using_animtree ("generic_human");

// Deprecated. only used for old traverses that will be deleted.
advancedTraverse(traverseAnim, normalHeight)
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self.old_anim_movement = self.a.movement;
	self.old_anim_alertness = self.a.alertness;
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip"); // So he doesn't get stuck if the wall is a little too high
	
	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	realHeight = startnode.traverse_height - startnode.origin[2];
	
	self thread teleportThread( realHeight - normalHeight );
	
	blendTime = 0.15;
	
	self clearAnim( %body, blendTime );
	self setFlaggedAnimKnoballRestart( "traverse", traverseAnim, %root, 1, blendTime, 1 );
	
	gravityToBlendTime = 0.2;
	endBlendTime = 0.2;
	
	self thread animscripts\shared::DoNoteTracksForever( "traverse", "no clear" );
	if ( !animHasNotetrack( traverseAnim, "gravity on" ) )
	{
		magicWhateverTime_WhereTheHeckDidWeGetThisNumberAnyway = 1.23;
		wait ( magicWhateverTime_WhereTheHeckDidWeGetThisNumberAnyway - gravityToBlendTime );
		self traverseMode( "gravity" );
		wait ( gravityToBlendTime );
	}
	else
	{
		self waittillmatch( "traverse", "gravity on" );
		self traverseMode( "gravity" );
		if ( !animHasNotetrack( traverseAnim, "blend" ) )
			wait ( gravityToBlendTime );
		else
			self waittillmatch( "traverse", "blend" );
	}

	self.a.movement = self.old_anim_movement;
	self.a.alertness = self.old_anim_alertness;
	
	runAnim = animscripts\run::GetRunAnim();
	
	self setAnimKnobAllRestart( runAnim, %body, 1, endBlendTime, 1 );
	wait (endBlendTime);
	thread animscripts\run::MakeRunSounds ( "killSoundThread" );

	/*
	for (;;)
	{
		self waittill ("traverse",notetrack);
		println ("notetrack ", notetrack);
	}
	*/
}

teleportThread( verticalOffset )
{
	self endon ("killanimscript");
	self notify("endTeleportThread");
	self endon("endTeleportThread");
	
	reps = 5;
	offset = ( 0, 0, verticalOffset / reps);
	
	for ( i = 0; i < reps; i++ )
	{
		self teleport( self.origin + offset );
		wait .05;
	}
}


teleportThreadEx( verticalOffset, delay, frames )
{
	self endon ("killanimscript");
	self notify("endTeleportThread");
	self endon("endTeleportThread");

	if ( verticalOffset == 0 )
		return;

	wait delay;
	
	amount = verticalOffset / frames;
	if ( amount > 10.0 )
		amount = 10.0;
	else if ( amount < -10.0 )
		amount = -10.0;
	
	offset = ( 0, 0, amount );
	
	for ( i = 0; i < frames; i++ )
	{
		self teleport( self.origin + offset );
		wait .05;
	}
}


DoTraverse( traverseData )
{
 	self endon( "killanimscript" );
 	
	// do not do code prone in this script
	self.desired_anim_pose = "stand";
	animscripts\utility::UpdateAnimPose();
	
	// orient to the Negotiation start node
    startnode = self getNegotiationStartNode();
 	endNode = self getNegotiationEndNode();
 	
    assert( isDefined( startnode ) );
    assert( isDefined( endNode ) );
    
    self OrientMode( "face angle", startnode.angles[1] );
	
	self.traverseHeight = traverseData[ "traverseHeight" ];
	self.traverseStartNode = startnode;
	
	traverseAnim = traverseData[ "traverseAnim" ];
	traverseToCoverAnim = traverseData[ "traverseToCoverAnim" ];
	
	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );
	
	self.traverseStartZ = self.origin[2];
	if ( !animHasNotetrack( traverseAnim, "traverse_align" ) )
	{
		/# println( "^1Warning: animation ", traverseAnim, " has no traverse_align notetrack" ); #/
		self handleTraverseAlignment();
	}
	
	toCover = false;
	if ( isDefined( traverseToCoverAnim ) && isDefined( self.node ) && self.node.type == traverseData[ "coverType" ] && distanceSquared( self.node.origin, endNode.origin ) < 25 * 25 )
	{
		if ( AbsAngleClamp180( self.node.angles[1] - endNode.angles[1] ) > 160 )
		{
			toCover = true;
			traverseAnim = traverseToCoverAnim;
		}
	}
	
	self thread TraverseRagdollDeath( traverseAnim );

	if ( toCover )
	{	
		if ( isdefined( traverseData[ "traverseToCoverSound" ] ) )
		{
			self thread play_sound_on_entity( traverseData[ "traverseToCoverSound" ] );
		}
	}
	else
	{
		if ( isdefined( traverseData[ "traverseSound" ] ) )
		{
			self thread play_sound_on_entity( traverseData[ "traverseSound" ] );
		}
	}
	self.traverseAnim = traverseAnim;
	self setFlaggedAnimKnoballRestart( "traverseAnim", traverseAnim, %body, 1, .2, 1 );
	//self thread animscripts\utility::ragdollDeath( traverseAnim );
	
	self.traverseDeathIndex = 0;
	self.traverseDeathAnim = traverseData[ "interruptDeathAnim" ];
	self animscripts\shared::DoNoteTracks( "traverseAnim", ::handleTraverseNotetracks );
	self traverseMode( "gravity" );
	
	if ( self.delayedDeath )
		return;
	
	self.a.nodeath = false;
	if ( toCover && isDefined( self.node ) && distanceSquared( self.origin, self.node.origin ) < 16 * 16 )
	{
		self.a.movement = "stop";
		self teleport( self.node.origin );
	}
	else
	{
		self.a.movement = "run";
		self.a.alertness = "casual";
		self setAnimKnobAllRestart( animscripts\run::GetRunAnim(), %body, 1, 0.0, 1 );
	}
}

handleTraverseNotetracks( note )
{
	if ( note == "traverse_death" )
		return handleTraverseDeathNotetrack();
	else if ( note == "traverse_align" )
		return handleTraverseAlignment();
	else if ( note == "traverse_drop" )
		return handleTraverseDrop();
}

handleTraverseDeathNotetrack()
{
	self endon( "killanimscript" );
	
	if ( self.delayedDeath )
	{
		self.a.noDeath = true;
		self.exception["move"] = ::doNothingFunc;
		self traverseDeath();
		return true;
	}
	self.traverseDeathIndex++;
}

handleTraverseAlignment()
{
	self traverseMode( "nogravity" );
	self traverseMode( "noclip" );
	if ( isDefined( self.traverseHeight ) && isDefined( self.traverseStartNode.traverse_height ) )
	{
		currentHeight = self.traverseStartNode.traverse_height - self.traverseStartZ;
		self thread teleportThread( currentHeight - self.traverseHeight );
	}
}

handleTraverseDrop()
{
	startpos = self.origin + (0,0,32);
	trace = bullettrace( startpos, self.origin + (0,0,-512), false, undefined );
	endpos = trace["position"];
	dist = distance( startpos, endpos );
	realDropHeight = dist - 32 - 0.5; // 0.5 makes sure we end up above the ground a bit
	
	remainingAnimDelta = getMoveDelta( self.traverseAnim, self getAnimTime( self.traverseAnim ), 1);
	animDropHeight = 0-remainingAnimDelta[2];
	assertEx( animDropHeight >= 0, animDropHeight );
	
	dropOffset = animDropHeight - realDropHeight;
	/#
	if ( getdvarint("scr_traverse_debug") )
	{
		thread animscripts\utility::debugLine(startpos, endpos, (1,1,1), 2 * 20);
		thread animscripts\utility::drawStringTime("drop offset: " + dropOffset, endpos, (1,1,1), 2);
	}
	#/
	
	self thread teleportThread( dropOffset );
	self thread finishTraverseDrop( endpos[2] );
}

finishTraverseDrop( finalz )
{
	self endon("killanimscript");
	
	finalz += 4.0;
	while(1)
	{
		if ( self.origin[2] < finalz )
		{
			self traverseMode( "gravity" );
			break;
		}
		wait .05;
	}
}

doNothingFunc()
{
	self animMode( "zonly_physics" );
	self waittill ( "killanimscript" );
}

traverseDeath()
{
	self notify("traverse_death");
	
	if ( !isDefined( self.triedTraverseRagdoll ) )
		self animscripts\death::PlayDeathSound();
	
	deathAnimArray = self.traverseDeathAnim[ self.traverseDeathIndex ];
	deathAnim = deathAnimArray[ randomint( deathAnimArray.size ) ];
	
	animscripts\death::playDeathAnim( deathAnim );
	self doDamage( self.health + 5, self.origin );
}

TraverseRagdollDeath( traverseAnim )
{
	self endon("traverse_death");
	self endon("killanimscript");
	
	while(1)
	{
		self waittill("damage");
		if ( !self.delayedDeath )
			continue;

		scriptedDeathTimes = getNotetrackTimes( traverseAnim, "traverse_death" );
		currentTime = self getAnimTime( traverseAnim );
		scriptedDeathTimes[ scriptedDeathTimes.size ] = 1.0;
		
		/#
		if ( getDebugDvarInt( "scr_forcetraverseragdoll" ) == 1 )
			scriptedDeathTimes = [];
		#/
		
		for ( i = 0; i < scriptedDeathTimes.size; i++ )
		{
			if ( scriptedDeathTimes[i] > currentTime )
			{
				animLength = getAnimLength( traverseAnim );
				timeUntilScriptedDeath = (scriptedDeathTimes[i] - currentTime) * animLength;
				if ( timeUntilScriptedDeath < 0.5 )
					return;
				break;
			}
		}
		
		self.deathFunction = ::postTraverseDeathAnim;
		self.exception["move"] = ::doNothingFunc;
		
		self animscripts\death::PlayDeathSound();
		
		self animscripts\shared::DropAllAIWeapons();
		
		behindMe = self.origin + (0,0,30) - anglesToForward( self.angles ) * 20;
		self startRagdoll();
		thread physExplosionForRagdoll( behindMe );
		
		self.a.triedTraverseRagdoll = true;
		break;
	}
}

physExplosionForRagdoll( pos )
{
	wait .1;
	physicsExplosionSphere( pos, 55, 35, 1 );
}

postTraverseDeathAnim()
{
	self endon( "killanimscript" );
	if ( !isdefined( self ) )
		return;
	// in case the ragdoll failed
	deathAnim = animscripts\death::getDeathAnim();
	self setFlaggedAnimKnobAllRestart( "deathanim", deathAnim, %body, 1, .1 );
}

deathWait()
{
	self endon("killanimscript");
	wait 2;
}

#using_animtree ("dog");

dog_wall_and_window_hop( traverseName, height )
{
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	realHeight = startnode.traverse_height - startnode.origin[2];
	self thread teleportThread( realHeight - height );
		
	self clearanim(%root, 0.2);
	self setflaggedanimrestart( "dog_traverse", anim.dogTraverseAnims[ traverseName ], 1, 0.2, 1);
	
	self animscripts\shared::DoNoteTracks( "dog_traverse" );
	
	self.traverseComplete = true;
}


dog_jump_down( height, frames )
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self thread teleportThreadEx( 40.0 - height, 0.1, frames );

	self clearanim(%root, 0.2);
	self setflaggedanimrestart( "traverse", anim.dogTraverseAnims["jump_down_40"], 1, 0.2, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );
	
	self clearanim(anim.dogTraverseAnims["jump_down_40"], 0);	// start run immediately
	self traverseMode("gravity");
	self.traverseComplete = true;
}

dog_jump_up( height, frames )
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self thread teleportThreadEx( height - 40.0, 0.2, frames );

	self clearanim(%root, 0.25);
	self setflaggedanimrestart( "traverse", anim.dogTraverseAnims["jump_up_40"], 1, 0.2, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );
	
	self clearanim(anim.dogTraverseAnims["jump_up_40"], 0);	// start run immediately
	self traverseMode("gravity");
	self.traverseComplete = true;
}
