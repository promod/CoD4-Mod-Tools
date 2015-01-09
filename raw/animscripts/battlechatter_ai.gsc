/****************************************************************************
 
 battleChatter_ai.gsc
		
*****************************************************************************/

#include animscripts\utility;
#include maps\_utility;
#include animscripts\battlechatter;

/****************************************************************************
 initialization
*****************************************************************************/

addToSystem (squadName)
{
	self endon ("death");
	
	//prof_begin("addToSystem");

	if ( !bcsEnabled() )
		return;
	
	if ( self.chatInitialized )
		return;
	
	assert( isdefined( self.squad ) );

	// initialize battlechatter data for this AI's squad if it hasn't been already
	if ( !isdefined( self.squad.chatInitialized ) || !self.squad.chatInitialized )
		self.squad init_squadBattleChatter();
	
	self.enemyClass = "infantry";
	self.calledOut = [];

	if ( isPlayer( self ) )
	{
		self.battleChatter = false;
		self.type = "human";
		return;
	}

	if ( self.type == "dog" )
	{
		self.enemyClass = undefined;
		self.battlechatter = false;
		return;
	}

	self.countryID = anim.countryIDs[self.voice];
	
	if ( isdefined( self.script_friendname ) )
	{
		friendname = tolower(self.script_friendname);
		if ( issubstr( friendname, "grigsby" ) )
			self.npcID = "grg";
		else if ( issubstr( friendname, "griggs" ) )
			self.npcID = "grg";
		else if ( issubstr( friendname, "price" ) )
			self.npcID = "pri";
		else if ( issubstr( friendname, "gaz" ) )
			self.npcID = "gaz";
		else
			self setNPCID();
	}
	else
	{
		self setNPCID();
	}

	self thread aiNameAndRankWaiter();
		
	self init_aiBattleChatter();	
	self thread aiThreadThreader();

	//prof_end("addToSystem");
}

// semi hackish way to make large numbers of ai spawning take less time
aiThreadThreader()
{
	self endon ( "death" );
	self endon ( "removed from battleChatter" );
	
	waitTime = 0.5;
	// readd individual ai threat waiter here if needed
	wait ( waitTime );
	self thread aiGrenadeDangerWaiter();
	self thread aiFollowOrderWaiter();
	
	if (self.team == "allies" )
	{
		wait ( waitTime );
		self thread aiFlankerWaiter();
		self thread aiDisplaceWaiter();
	}
	
	wait ( waitTime );
	self thread aiBattleChatterLoop();

//	if (issubstr(self.classname, "mgportable"))
//		self thread portableMG42Waiter();
}



setNPCID()
{
	//prof_begin("setNPCID");
	assert (!isDefined( self.npcID ) );
	
	usedIDs = anim.usedIDs[self.voice];
	numIDs = usedIDs.size;
	
	startIndex = randomIntRange( 0, numIDs );
	
	lowestID = startIndex;
	for ( index = 0; index <= numIDs; index++ )
	{
		if ( usedIDs[(startIndex+index)%numIDs].count < usedIDs[lowestID].count )
			lowestID = ( startIndex + index ) % numIDs;
	}
	
	self thread npcIDTracker( lowestID );
	self.npcID = usedIDs[lowestID].npcID;
	//prof_end("setNPCID");
}


npcIDTracker( lowestID )
{
//	self endon ("removed from battleChatter");
	
	anim.usedIDs[self.voice][lowestID].count++;
	self waittill ( "death" );
	if ( !bcsEnabled() )
		return;
		
	anim.usedIDs[self.voice][lowestID].count--;
}


aiBattleChatterLoop()
{
	self endon ( "death" );
	self endon ( "removed from battleChatter" );
	
	while ( true )
	{
		//prof_begin( "aiBattleChatterLoop" );
		self playBattleChatter();
		//prof_end( "aiBattleChatterLoop" );
		
		wait ( 0.3 + randomfloat( 0.2 ) );
	}
}

aiNameAndRankWaiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	while (1)
	{	
		self.bcName = self animscripts\battlechatter::getName();
		self.bcRank = self animscripts\battlechatter::getRank();
		self waittill ("set name and rank");
	}
	
}

removeFromSystem (squadName)
{
	if (!isalive (self) && bcsEnabled() )
	{
		self aiDeathFriendly();
		self aiDeathEnemy();
	}

	if (isdefined (self))
	{
		self.battleChatter = false;
		self.chatInitialized = false;
	}

	self notify ("removed from battleChatter");

	if (isdefined (self))
	{
		self.chatQueue = undefined;
		self.nextSayTime = undefined;
		self.nextSayTimes = undefined;
		self.isSpeaking = undefined;
		self.enemyClass = undefined;
		self.calledOut = undefined;
		self.countryID = undefined;
		self.npcID = undefined;
	}
}

init_aiBattleChatter ()
{
	//prof_begin("init_aiBattleChatter");
	self.chatQueue = [];
	self.chatQueue["threat"] = spawnstruct();
	self.chatQueue["threat"].expireTime = 0;
	self.chatQueue["threat"].priority = 0.0;
	self.chatQueue["response"] = spawnstruct();
	self.chatQueue["response"].expireTime = 0;
	self.chatQueue["response"].priority = 0.0;
	self.chatQueue["reaction"] = spawnstruct();
	self.chatQueue["reaction"].expireTime = 0;
	self.chatQueue["reaction"].priority = 0.0;
	self.chatQueue["inform"] = spawnstruct();
	self.chatQueue["inform"].expireTime = 0;
	self.chatQueue["inform"].priority = 0.0;
	self.chatQueue["order"] = spawnstruct();
	self.chatQueue["order"].expireTime = 0;
	self.chatQueue["order"].priority = 0.0;
	self.chatQueue["custom"] = spawnstruct();
	self.chatQueue["custom"].expireTime = 0;
	self.chatQueue["custom"].priority = 0.0;

	self.nextSayTime = getTime() + 50;
	self.nextSayTimes["threat"] = 0;
	self.nextSayTimes["reaction"] = 0;
	self.nextSayTimes["response"] = 0;
	self.nextSayTimes["inform"] = 0;
	self.nextSayTimes["order"] = 0;
	self.nextSayTimes["custom"] = 0;
	
	self.isSpeaking = false;
	self.bcs_minPriority = 0.0;

	if (isdefined (self.script_battlechatter) && !self.script_battlechatter)
		self.battleChatter = false;
	else
		self.battleChatter = level.battlechatter[self.team];
	
	self.chatInitialized = true;
	//prof_end("init_aiBattleChatter");
}

/****************************************************************************
 ai event queue
*****************************************************************************/

// adds a threat callout to this AIs queue
addThreatEvent (eventType, threat, priority)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	assertex (isdefined (eventType), "addThreatEvent called with undefined eventType");

	if (!self canSay("threat", eventType, priority))
		return;
		
	// threat has already been called out by someone in our squad
	if (isdefined (threat.calledOut) && isdefined (threat.calledOut[self.squad.squadName]))
		return;

	chatEvent = self createChatEvent ("threat", eventType, priority);

	// may require createstructs for non sentient threats later
	switch (eventType)
	{
	case "infantry":
		chatEvent.threat = threat;
		break;
	case "emplacement":
		chatEvent.threat = threat;
		break;
	case "vehicle":
		chatEvent.threat = threat;
		break;
	}
	
	if (isdefined (threat.squad))
		self.squad updateContact(threat.squad.squadName, self);
	
	self.chatQueue["threat"] = undefined;
	self.chatQueue["threat"] = chatEvent;
}

// adds a response to this AIs queue
addResponseEvent (eventType, modifier, respondTo, priority)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!self canSay("response", eventType, priority, modifier))
		return;
	
	if (respondTo != level.player)
	{ 
		if ((isString(respondTo.npcID) && isString(self.npcID)) && (respondTo.npcID == self.npcID))
			return;
		else if ((!isString(respondTo.npcID) && !isString(self.npcID)) && (respondTo.npcID == self.npcID))
			return;
	}
	
	chatEvent = self createChatEvent ("response", eventType, priority);
	
	switch (eventType)
	{
	case "killfirm":
		chatEvent.respondTo = respondTo;
		chatEvent.modifier = modifier;
		break;
	case "ack":
		chatEvent.respondTo = respondTo;
		chatEvent.modifier = modifier;
	}	
	
	self.chatQueue["response"] = undefined;
	self.chatQueue["response"] = chatEvent;
}

// adds a informative callout to this AIs queue
addInformEvent (eventType, modifier, informTo, priority)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!self canSay("inform", eventType, priority, modifier))
		return;

	chatEvent = self createChatEvent ("inform", eventType, priority);
		
	switch (eventType)
	{
	case "reloading":
		chatEvent.modifier = modifier;
		chatEvent.informTo = informTo;
		break;
	default:
		chatEvent.modifier = modifier;
	}	

	self.chatQueue["inform"] = undefined;
	self.chatQueue["inform"] = chatEvent;
}

// adds a response to this AIs queue
addReactionEvent (eventType, modifier, reactTo, priority)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!self canSay("reaction", eventType, priority, modifier))
		return;

	chatEvent = self createChatEvent ("reaction", eventType, priority);
	
	switch (eventType)
	{
	case "casualty":
		chatEvent.reactTo = reactTo;
		chatEvent.modifier = modifier;
		break;
	case "taunt":
		chatEvent.reactTo = reactTo;
		chatEvent.modifier = modifier;
	}	
	
	self.chatQueue["reaction"] = undefined;
	self.chatQueue["reaction"] = chatEvent;
}

// adds an order to this AIs queue
addOrderEvent (eventType, modifier, orderTo, priority)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	if (!self canSay("order", eventType, priority, modifier))
		return;

	if ( isDefined( orderTo ) && orderTo.type == "dog" )
		return;

	chatEvent = self createChatEvent ("order", eventType, priority);
	
	chatEvent.modifier = modifier; 
	chatEvent.orderTo = orderTo;
	
	switch (eventType)
	{
	}	
	
	self.chatQueue["order"] = undefined;
	self.chatQueue["order"] = chatEvent;
}

/****************************************************************************
 ai trackers/waiters
*****************************************************************************/

squadOfficerWaiter()
{
	anim endon ("battlechatter disabled");
	anim endon ("squad deleted " + self.squadName);
	
	while (1)
	{
		officer = undefined;
		
		if (self.officers.size)
			members = self.officers;
		else
			members = self.members;
			
		officers = [];
		for ( index = 0; index < members.size; index++ )
		{
			if (isalive(members[index]))
				officers[officers.size] = members[index];
		}

		if ( officers.size )
		{
			officer = getClosest(level.player.origin, officers);
			officer aiOfficerOrders();
			officer waittill ("death");
		}

		wait (3.0);
	}
}


getThreats(potentialThreats)
{
	threats = [];
	for (i = 0; i < potentialThreats.size; i++)
	{
//		if ( !isdefined( potentialThreats[i].battleChatter ) || !potentialThreats[i].battleChatter)
//			continue;

		if ( !isdefined( potentialThreats[i].enemyClass ) )
			continue;

		if (!level.player pointInFov(potentialThreats[i].origin))
			continue;
		
//		if (!isdefined (potentialThreats[i] getLocation()) && !isdefined (potentialThreats[i] getLandMark()))
//			continue;
		
		potentialThreats[i].threatID = threats.size;
		threats[threats.size] = potentialThreats[i];
	}
	return (threats);
}


squadThreatWaiter()
{
	anim endon ("battlechatter disabled");
	anim endon ("squad deleted " + self.squadName);
	
	while (1)
	{
		wait (randomfloatrange(0.25, 0.75));
		
		//prof_begin("squadThreatWaiter");

		validEnemies = getThreats(getaiarray ("axis"));
		
		if (!validEnemies.size)
			continue;
		
		addedEnemies = [];
		for (i = 0; i < self.members.size; i++)
		{
			if (!isalive (self.members[i]))
				continue;
				
			if (!validEnemies.size)
			{
				validEnemies = addedEnemies;
				addedEnemies = [];
			}
			
			for (j = 0; j < validEnemies.size; j++)
			{
				if (!isdefined (validEnemies[j]))
				{
					if (j == 0)
						validEnemies = [];
					continue;
				}

				if (!isalive(validEnemies[j]))
					continue;

				if (!self.members[i] cansee(validEnemies[j]))
					continue;
				
				self.members[i] addThreatEvent(validEnemies[j].enemyClass, validEnemies[j]);

				addedEnemies[addedEnemies.size] = validEnemies[j];
				validEnemies[j] = undefined;
				validEnemies[j] = validEnemies[validEnemies.size - 1];
				validEnemies[validEnemies.size - 1] = undefined;
				if (!isdefined (validEnemies[0]))
					validEnemies = [];
				break;					
			}
			wait (0.05);
		}
		//prof_end("squadThreatWaiter");
	}
}

flexibleThreatWaiter()
{
	anim endon ("battlechatter disabled");
	anim endon ("squad deleted " + self.squadName);
	
	while (1)
	{
		wait (0.5);

		validEnemies = filterThreats(getaiarray ("axis"));
		
		if (!validEnemies.size)
			continue;
		
		addedEnemies = [];
		for (i = 0; i < self.members.size; i++)
		{
			if (!validEnemies.size)
			{
				validEnemies = addedEnemies;
				addedEnemies = [];
			}
			
			for (j = 0; j < validEnemies.size; j++)
			{
				if (!isdefined (validEnemies[j]))
				{
					if (j == 0)
						validEnemies = [];
					continue;
				}
					
				if (getdvar ("bcs_threatLimitTargettedBySelf") == "on")
				{
					if (!isdefined (self.members[i].enemy) || validEnemies[j] != self.members[i].enemy)
						continue;
		
					if (gettime() > (self.members[i].lastEnemySightTime + 2000))
						continue;
				}
				else if (!self.members[i] cansee(validEnemies[j]))
				{
						continue;
				}

				if (getdvar ("bcs_threatLimitSpeakerDist") != "off")
				{
					maxDist = int(getdvar ("bcs_threatLimitSpeakerDist"));
					if (distance (level.player.origin, self.members[i].origin) > maxDist)
						continue;					
				}
				
				self.members[i] addThreatEvent(validEnemies[j].enemyClass, validEnemies[j]);

				addedEnemies[addedEnemies.size] = validEnemies[j];
				validEnemies[j] = undefined;
				validEnemies[j] = validEnemies[validEnemies.size - 1];
				validEnemies[validEnemies.size - 1] = undefined;
				if (!isdefined (validEnemies[0]))
					validEnemies = [];
				break;					
			}
		}
	}
}

filterThreats(potentialThreats)
{
	threats = [];
	for (i = 0; i < potentialThreats.size; i++)
	{
		if (!potentialThreats[i].battleChatter)
			continue;
		
		if (getdvar ("bcs_threatLimitTargetingPlayer") == "on")
		{
			if (!isdefined (potentialThreats[i].enemy) || potentialThreats[i].enemy != level.player)
				continue;
		}

		if (getdvar ("bcs_threatLimitInPlayerFOV") == "on")
		{
			if (!level.player pointInFov(potentialThreats[i].origin))
				continue;
		}

		if (getdvar ("bcs_threatLimitThreatDist") != "off")
		{
			maxDist = int(getdvar ("bcs_threatLimitThreatDist"));
			if (distance (level.player.origin, potentialThreats[i].origin) > maxDist)
				continue;
			
		}

		if (getdvar ("bcs_threatLimitInLocation") == "on")
		{
			if (!isdefined (potentialThreats[i] getLocation()) && !isdefined (potentialThreats[i] getLandMark()))
				continue;
		}
		
		
		potentialThreats[i].threatID = threats.size;
		threats[threats.size] = potentialThreats[i];
	}
	return (threats);
}

randomThreatWaiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	anim endon ("squad deleted " + self.squadName);

	while (1)
	{
		if(getdvar("bcs_enable") == "off")
		{
			wait (1.0);
			continue;
		}

		time = gettime();
		for (i = 0; i < self.members.size; i++)
		{
		
			if (!isdefined (self.members[i].enemy))
				continue;
				
			threat = self.members[i].enemy;
				
			if (!threat.battleChatter)
				continue;
			
			if (!isdefined (threat getLocation()) && !isdefined (threat getLandMark()))
				continue;

			if (time > (self.members[i].lastEnemySightTime + 2000))
				continue;

			// hack to remove contact messages for now				
			self.squadList[threat.squad.squadName].calledOut = true;
			
			self.members[i] addThreatEvent(threat.enemyClass, threat);

			/*
			if (isdefined (self.members[i].enemy) && 
				self.members[i].enemy.battleChatter && 
				!isdefined (self.members[i].enemy.calledOut[self.squadName]) && 
				gettime() < (self.members[i].lastEnemySightTime + 2000))
			{
			}
			*/
		}
		wait (1.0);
	}
}

// we saw an enemy
aiThreatWaiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");
/*	
	while (1)
	{
		self waittill ("enemy");
		
		if (isdefined (self.enemy))
			self addThreatEvent (self.enemy.enemyClass, self.enemy);
	}
*/
}

aiDeathFriendly ()
{
	attacker = self.attacker;
	// reaction event
	if (isdefined (self))
	{
		for (i = 0; i < self.squad.members.size; i++)
		{
			// distance checked, cansee checks on 
			// dead guy vs. member
			// need origin, name, etc... these may not be available	
			
			// self is incorrect to use here... it's just temp for now
			
			// this should not be needed but is.  members can't be reliably counted on to only contain living members
			// because of the recent change that disallows setting variables on entities.
			if (isalive(self.squad.members[i]))
				self.squad.members[i] thread aiDeathEventThread();
		}
	}

	// at some point, this should change to make things like tanks, etc... get called out properly
	if (isalive (attacker) && issentient (attacker) && isdefined (attacker.squad) && attacker.battleChatter)
	{
		if (isdefined (attacker.calledOut[attacker.squad.squadName]))
			attacker.calledOut[attacker.squad.squadName] = undefined;

		// re-add this attacker as a threat
		for (i = 0; i < self.squad.members.size; i++)
		{
			// distance checked, cansee checks on 
			// and dead guy vs. attacker
			if (!isdefined (attacker.enemyClass))
				return;
				
			if (!isdefined (attacker getLocation()) && !isdefined (attacker getLandMark()))
				continue;

			if (gettime() > (self.squad.members[i].lastEnemySightTime + 2000))
				continue;

			self.squad.members[i] addThreatEvent (attacker.enemyClass, attacker);
		}		
	}
}

aiDeathEventThread()
{
	self endon ( "death" );
	self endon ( "removed from battleChatter" );
	
	wait ( 1.5 );
	self addReactionEvent("casualty", "generic", self, 0.9);
}

aiDeathEnemy ()
{
	attacker = self.attacker;

	if (!isalive (attacker) || !issentient (attacker) || !isdefined (attacker.squad))
		return;

	// if we've been called out by someone in the squad of our attacker
	// and the one who did so is still alive
	// and he's not the one who killed us
	// and the callout happened recently enough
	if (isdefined (self.calledOut[attacker.squad.squadName]) && 
		isalive (self.calledOut[attacker.squad.squadName].spotter) &&
		self.calledOut[attacker.squad.squadName].spotter != attacker &&
		gettime() < self.calledOut[attacker.squad.squadName].expireTime)
	{
		if (attacker == level.player)
		{
			// nice shot, good work, etc...
		}
		else
		{
			// response event
			// attacker says "got him" or something similar ... check threatType
			// TODO: maybe add generic for this ... "Tango down!" etc...
//			attacker addResponseEvent ("killfirm", "infantry", self.calledOut[attacker.squad.squadName].spotter);
		}
	}
	else if (attacker != level.player)
	{
		// attacker says "got one" or something similar ... check threatType
		attacker thread aiKillEventThread();
	}
}

aiKillEventThread()
{
	self endon ( "death" );
	self endon ("removed from battleChatter");
	
	wait ( 1.5 );
	self addInformEvent ("killfirm", "infantry");
}

aiOfficerOrders()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	if (!isdefined (self.squad.chatInitialized))
		self.squad waittill ("squad chat initialized");
	
	while (1)
	{
		if(getdvar("bcs_enable") == "off")
		{
			wait (1.0);
			continue;
		}

		self addSituationalOrder();
		
		wait (randomfloatrange (3.0, 6.0));
	}
}

aiGrenadeDangerWaiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	while (1)
	{
		self waittill ("grenade danger", grenade);

		if(getdvar("bcs_enable") == "off")
			continue;

		if ( !isdefined( grenade ) || grenade.model != "projectile_m67fraggrenade" )
			continue;		

		if (distance (grenade.origin, level.player.origin) < 512) // grenade radius is 220
			self addInformEvent ("incoming", "grenade");
	}
}


aiFlankerWaiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	while ( true )
	{
		level waittill ("flanker", side);

		if(getdvar("bcs_enable") == "off")
			continue;

		if ( isDefined( self.customChatEvent ) )
			return;

		self beginCustomEvent();
		self addThreatAliasEx( "infantry", "generic" );
		self addGenericAliasEx( "direction", "relative", side );
		// direction_inbound_left/right/front/rear
		self endCustomEvent( 2000 );
	}
}


aiFlankerOrderWaiter()
{
	
}


aiDisplaceWaiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	while ( true )
	{
		self waittill ("trigger");

		if(getdvar("bcs_enable") == "off")
			continue;

		// no acknowledgement if you just took pain, looks dumb
		if (gettime() < self.a.painTime + 4000)
			continue;
		
		self addResponseEvent( "ack", "yes", level.player, 1.0 );
	}
}

portableMG42Waiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	while (1)
	{
		self waittill ("bcs_portable_turret_setup");

		if(getdvar("bcs_enable") == "off")
			continue;
		
		soldiers = getaiarray("allies");
		for (index = 0; index < soldiers.size; index++)
		{
			soldiers[index] addThreatEvent ("emplacement", self, 0.9);
		}
	}
}

evaluateMoveEvent (leavingCover)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
		return;

	// temp
	if (!isdefined (self.node))
		return;
	
//	if (self.combatTime < 0.0)
//		return;	
	
	dist = distance (self.origin, self.node.origin);
	if (dist < 250)
		return;

	if (!self isNodeCover())
		return;
		
	soldier = getClosestSpeaker ("order", false);
	
	if (!isdefined (soldier) || distance (self.origin, soldier.origin) > 800)
		soldier = getClosestSpeaker ("order");
	
	if (isdefined (soldier) && distance (self.origin, soldier.origin) < 800 && self.combatTime > 0.0)
	{
		anim.moveOrigin.origin = self.node.origin;
		landmark = anim.moveOrigin getLandmark();
		
		self.squad animscripts\squadmanager::updateStates();
		if (isdefined (landmark) && soundExists( soldier.countryID + "_" + soldier.npcID + "_order_cover_" + landmark.script_landmark ) )
			soldier addOrderEvent ("cover", landmark.script_landmark, self);
		else if (self.squad.squadStates["move"].isActive)
			soldier addOrderEvent ("move", "forward", self);
		else
			soldier addOrderEvent ("cover", "generic", self);
	}
	else if (isdefined (soldier) && distance (self.origin, soldier.origin) < 600)
	{
		if (self isOfficer())
		{
			self addOrderEvent ("move", "follow", soldier);
		}
		else
		{
			if (self.combatTime < 0.0)
				return;

			self addOrderEvent ("action", "coverme", soldier);
		}
	}
	else if (distance (self.origin, level.player.origin) < 500)
	{
		if (self.combatTime < 0.0)
			return;
			
		self addOrderEvent ("action", "coverme", level.player); // dangerous to have level.player as orderTo?
	}
}


aiFollowOrderWaiter()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	while ( true )
	{
		level waittill ("follow order", speaker);
		
		if (!bcsEnabled())
			return;
			
		if (speaker.team != self.team)
			continue;

		wait (1.5);
		
		if (!isalive(speaker))
			continue;
			
		if (!self canSay("response"))
			continue;
			
		if (distance(self.origin, speaker.origin) < 600)
			self addResponseEvent("ack", "follow", speaker);
	}
}


evaluateReloadEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
		return;

	soldier = getClosestSpeaker("response");
	if (isdefined(soldier) && isdefined (soldier.a.personImMeleeing))
		soldier = undefined;

	/*
	if (distance (level.player.origin, self.origin) < 384)
		self addInformEvent ("reloading", "coverme", level.player);
	else if (isalive (soldier) && distance (soldier.origin, self.origin) < 384) // was 500
		self addInformEvent ("reloading", "coverme", soldier);
	else
	*/
		self addInformEvent ("reloading", "generic");
}

evaluateMeleeEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
		return (false);

	if (!isdefined(self.enemy))
		return (false);

//	self addReactionEvent("taunt", "generic", self.enemy);

//	return (true);
	return (false);
}

evaluateFiringEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
		return;

	if (!isdefined(self.enemy))
		return;

//	if (distance(self.origin, self.enemy.origin) > 384)
//		self addReactionEvent("taunt", "generic", self.enemy, 0.4);
}

evaluateSuppressionEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
		return;

	if (!self.suppressed)
		return;

	self addInformEvent("suppressed", "generic");
}

evaluateAttackEvent(type)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!bcsEnabled())
		return;

	switch (type)
	{
		case "grenade":
		self addInformEvent ("attack", "grenade");
		break;
	}
}

addSituationalOrder()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (self.squad.squadStates["combat"].isActive)
		self addSituationalCombatOrder();
	else
		self addSituationalIdleOrder();
}

addSituationalIdleOrder()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	squad = self.squad;
	squad animscripts\squadmanager::updateStates();

	if (squad.squadStates["move"].isActive)
		self addOrderEvent ("move", "generic");
}

addSituationalCombatOrder()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	squad = self.squad;
	squad animscripts\squadmanager::updateStates();
	
	if (squad.squadStates["suppressed"].isActive)
	{
		if (squad.squadStates["move"].isActive)
		{
			self addOrderEvent ("cover", "generic");
		}
		else if (squad.squadStates["cover"].isActive)
		{
			self addOrderEvent ("action", "grenade");
		}
		else
		{
			if (randomfloat (1) > 0.5)
				self addOrderEvent ("displace", "generic"); // need to calc specifics?
			else
				self addOrderEvent ("cover", "generic"); // need to calc specifics?
		}
	}
	else
	{
		/*
		if (squad.squadStates["move"].isActive)
		{
			if (randomfloat (1) > 0.5)
				self addOrderEvent ("cover", "generic");
			else
				self addOrderEvent ("move", "generic"); // need to calc specifics?
		}
		else */ 
		if ( self.team == "allies" )
			soldiers = getAIArray( "axis" );
		else
			soldiers = getAIArray( "allies");

		if (squad.squadStates["attacking"].isActive)
		{
			atWindow = false;
			for (index = 0; index < soldiers.size; index++)
			{
				if (soldiers[index] isClaimedNodeWindow())
					atWindow = true;
			}	

			if (atWindow)
				self addOrderEvent ("attack", "window");
			else
				self addOrderEvent ("action", "boost");
		}
		else if (squad.squadStates["combat"].isActive)
		{
			atWindow = false;
			for (index = 0; index < soldiers.size; index++)
			{
				if (soldiers[index] isClaimedNodeWindow())
					atWindow = true;
			}	

			if (atWindow)
				self addOrderEvent ("attack", "window");
			else
				self addOrderEvent ("action", "suppress");
		}
	}
}


/****************************************************************************
 custom event functions
*****************************************************************************/

beginCustomEvent ()
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase = createChatPhrase();
}

addThreatAliasEx (type, modifier)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addThreatAlias (1.0, type, modifier);
}

addInformAliasEx (type, modifier)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addInformAlias (1.0, type, modifier);
}

addResponseAliasEx (type, modifier)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addResponseAlias (1.0, type, modifier);
}

addOrderAliasEx (type, modifier)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addOrderAlias (1.0, type, modifier);
}

addAliasLandmarkEx (type, modifier)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addGenericAlias (1.0, "landmark", type, modifier);
}

addAliasLocationEx (type, modifier)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addGenericAlias (1.0, "location", type, modifier);
}

addAliasAreaEx (type, modifier)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addGenericAlias (1.0, "area", type, modifier);
}

addDirectionCompassAliasEx (origin)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addPersonalDirectionAlias(1.0, "relative", origin, undefined, "compass");
}

addDirectionFlankAliasEx (origin)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addPersonalDirectionAlias(1.0, "relative", origin, undefined, "flank");
}

addDirectionSideAliasEx (origin)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addPersonalDirectionAlias(1.0, "side", origin);
}

addGenericAliasEx (action, type, modifier)
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addGenericAlias(1.0, action, type, modifier);
}

addRankAliasEx( rank )
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addRankAlias( rank );
}

addNameAliasEx( name )
{
	if (!bcsEnabled())
		return;

	self.customChatPhrase addNameAlias( name );
}

addPersonalDirectionAlias (chance, relation, origin, vector, style)
{
	if (randomfloat (1) > chance)
		return (false);

	switch (relation)
	{
	case "side":
		{
			direction = getDirectionReferenceSide (self.owner.origin, origin, vectornormalize (anglestoforward(self.owner.angles)));
	
			if (!isdefined (self.location) || (direction != "left" && direction != "right"))
				return (false);

			direction = relation + "_" + direction;
		}
		break;		
		
	case "relative":
		if (isdefined (style))
		{
			if (style == "clock")
				directionStyle = 0;
			else if (style == "flank")
				directionStyle = 1;
			else if (style == "compass")
				directionStyle = 2;
			else
				directionStyle = randomintrange (0, 3) - 1;
		}
		else
		{
			if (distance (self.owner.origin, origin) > 2048)
				directionStyle = 2;
			else if (distance (self.owner.origin, origin) > 800)
				directionStyle = 0;
			else
				directionStyle = 1;
		}
			
		if (directionStyle == 0)
		{
			// Clock directions are disabled for now, this may be permanent
//			direction = getDirectionFacingClock (self.owner.origin, target.origin, vectornormalize (self.owner.squad.forward));
			direction = getDirectionCompass (self.owner.origin, origin);
		}
		else if (directionStyle == 1)
			direction = getDirectionFacingFlank (self.owner.origin, origin, vectornormalize (anglestoforward(self.owner.angles)));
		else
			direction = getDirectionCompass (self.owner.origin, origin);
			
		direction = relation + "_" + direction;
		break;
		
	default:
		return (false);
	}

	assert (isdefined (direction));
	self.direction = self.owner.countryID + "_" + self.owner.npcID + "_direction_" + direction;
	self.soundAliases[self.soundAliases.size] = self.direction;
	return (true);
}

endCustomEvent (eventDuration, typeOverride)
{
	if (!bcsEnabled())
		return;

	chatEvent = self createChatEvent ("custom", "generic", 1.0);
	if (isdefined (eventDuration))
		chatEvent.expireTime = gettime() + eventDuration;
	
	if ( isDefined( typeOverride ) )
		chatEvent.type = typeOverride;
	else
		chatEvent.type = "custom";
		
	self.chatQueue["custom"] = undefined;
	self.chatQueue["custom"] = chatEvent;
}

