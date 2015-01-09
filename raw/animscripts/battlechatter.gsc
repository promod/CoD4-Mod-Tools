/****************************************************************************
 
 battleChatter.gsc
 
 Basic concepts: Battle chatter events work on a queue system.  Events are 
   added the AI's queue, and script calls to playBattleChatter(), scattered
   throughout the animscripts, give the AI oppurtunities to play the events.
   Events have an expiration time; if there are no calls to playBattleChatter
   before an event expires, it will not play.
     Script calls, usually within animscripts or battleChatter_ai::*Waiter() 
   functions, call the add*Event(); functions to add a voice event to the 
   AI's queue.
     Since an AI can have multiple events in it's queue at a give time, there
   is a priority system in place to help the AI choose which events get added
   to the queue and which events it will play.  Events with a priority of 1
   will always be added to the queue (unless battlechatter is disabled on the
   AI)
		
*****************************************************************************/

#include common_scripts\utility;
#include animscripts\utility;
#include maps\_utility;
#include animscripts\battlechatter_ai;

/****************************************************************************
 initialization
*****************************************************************************/

// Initializes the battle chatter system
init_battleChatter()
{
	if (isdefined (anim.chatInitialized) && anim.chatInitialized)
		return;

	if (getdvar ("bcs_enable") == "")
		setdvar ("bcs_enable", "on");

	if (getdvar ("bcs_enable") == "off")
	{
		anim.chatInitialized = false;
		anim.player.chatInitialized = false;
		return;
	}
	
	anim.chatInitialized = true;
	anim.player.chatInitialized = false;

	if (getdvar ("bcs_filterThreat") == "")
		setdvar ("bcs_filterThreat", "off");
	if (getdvar ("bcs_filterInform") == "")
		setdvar ("bcs_filterInform", "off");
	if (getdvar ("bcs_filterOrder") == "")
		setdvar ("bcs_filterOrder", "off");
	if (getdvar ("bcs_filterReaction") == "")
		setdvar ("bcs_filterReaction", "off");
	if (getdvar ("bcs_filterResponse") == "")
		setdvar ("bcs_filterResponse", "off");

	if (getdvar ("bcs_threatLimitTargettedBySelf") == "")
		setdvar ("bcs_threatLimitTargettedBySelf", "off");
	if (getdvar ("bcs_threatLimitTargetingPlayer") == "")
		setdvar ("bcs_threatLimitTargetingPlayer", "off");
	if (getdvar ("bcs_threatLimitInPlayerFOV") == "")
		setdvar ("bcs_threatLimitInPlayerFOV", "on");
	if (getdvar ("bcs_threatLimitInLocation") == "")
		setdvar ("bcs_threatLimitInLocation", "on");
	if (getdvar ("bcs_threatLimitSpeakerDist") == "")
		setdvar ("bcs_threatLimitSpeakerDist", "512");
	if (getdvar ("bcs_threatLimitThreatDist") == "")
		setdvar ("bcs_threatLimitThreatDist", "2048");

	if (getdvar ("bcs_threatPlayerRelative") == "")
		setdvar ("bcs_threatPlayerRelative", "off");

	if (getdvar("debug_bcprint") == "")
		setdvar("debug_bcprint", "off");
	if (getdvar("debug_bcshowqueue") == "")
		setdvar("debug_bcshowqueue", "off");
/#
	if (getdvar("debug_bcthreat") == "")
		setdvar("debug_bcthreat", "off");
	if (getdvar("debug_bcresponse") == "")
		setdvar("debug_bcresponse", "off");
	if (getdvar("debug_bcorder") == "")
		setdvar("debug_bcorder", "off");
	if (getdvar("debug_bcinform") == "")
		setdvar("debug_bcinform", "off");
	if (getdvar("debug_bcdrawobjects") == "")
		setdvar("debug_bcdrawobjects", "off");
	if (getdvar("debug_bcinteraction") == "")
		setdvar("debug_bcinteraction", "off");
#/
	
	anim.countryIDs["british"] = "UK";
	anim.countryIDs["american"] = "US";
	anim.countryIDs["russian"] = "RU";
	anim.countryIDs["arab"] = "AB";
	
	anim.usedIDs = [];
	anim.usedIDs["russian"] = [];
		anim.usedIDs["russian"][0] = spawnstruct();
		anim.usedIDs["russian"][0].count = 0;
		anim.usedIDs["russian"][0].npcID = "0";
		anim.usedIDs["russian"][1] = spawnstruct();
		anim.usedIDs["russian"][1].count = 0;
		anim.usedIDs["russian"][1].npcID = "1";
		anim.usedIDs["russian"][2] = spawnstruct();
		anim.usedIDs["russian"][2].count = 0;
		anim.usedIDs["russian"][2].npcID = "3";
	anim.usedIDs["british"] = [];
		anim.usedIDs["british"][0] = spawnstruct();
		anim.usedIDs["british"][0].count = 0;
		anim.usedIDs["british"][0].npcID = "0";
		anim.usedIDs["british"][1] = spawnstruct();
		anim.usedIDs["british"][1].count = 0;
		anim.usedIDs["british"][1].npcID = "1";
		anim.usedIDs["british"][2] = spawnstruct();
		anim.usedIDs["british"][2].count = 0;
		anim.usedIDs["british"][2].npcID = "2";
		anim.usedIDs["british"][3] = spawnstruct();
		anim.usedIDs["british"][3].count = 0;
		anim.usedIDs["british"][3].npcID = "3";
	anim.usedIDs["american"] = [];
		anim.usedIDs["american"][0] = spawnstruct();
		anim.usedIDs["american"][0].count = 0;
		anim.usedIDs["american"][0].npcID = "0";
		anim.usedIDs["american"][1] = spawnstruct();
		anim.usedIDs["american"][1].count = 0;
		anim.usedIDs["american"][1].npcID = "1";
		anim.usedIDs["american"][2] = spawnstruct();
		anim.usedIDs["american"][2].count = 0;
		anim.usedIDs["american"][2].npcID = "2";
	anim.usedIDs["arab"] = [];
		anim.usedIDs["arab"][0] = spawnstruct();
		anim.usedIDs["arab"][0].count = 0;
		anim.usedIDs["arab"][0].npcID = "0";
		anim.usedIDs["arab"][1] = spawnstruct();
		anim.usedIDs["arab"][1].count = 0;
		anim.usedIDs["arab"][1].npcID = "1";
		anim.usedIDs["arab"][2] = spawnstruct();
		anim.usedIDs["arab"][2].count = 0;
		anim.usedIDs["arab"][2].npcID = "2";
		anim.usedIDs["arab"][3] = spawnstruct();
		anim.usedIDs["arab"][3].count = 0;
		anim.usedIDs["arab"][3].npcID = "3";
	
	anim.eventTypeMinWait = [];
	anim.eventTypeMinWait["threat"] = [];
	anim.eventTypeMinWait["response"] = [];
	anim.eventTypeMinWait["reaction"] = [];
	anim.eventTypeMinWait["order"] = [];
	anim.eventTypeMinWait["inform"] = [];
	anim.eventTypeMinWait["custom"] = [];
	anim.eventTypeMinWait["direction"] = [];

// If you want to tweak how often battlechatter messages happen,
// this is place to do it.
// A priority of 1 will force an event to be added to the queue, and 
// will make it override pre-existing events of the same type.

	// times are in milliseconds
	/*
	anim.eventActionMinWait["threat"]["self"] 		= 12000;
	anim.eventActionMinWait["threat"]["squad"] 		= 6000;
	anim.eventActionMinWait["response"]["self"] 	= 1000;
	anim.eventActionMinWait["response"]["squad"] 	= 1000;
	anim.eventActionMinWait["reaction"]["self"] 	= 1000;
	anim.eventActionMinWait["reaction"]["squad"] 	= 1000;
	anim.eventActionMinWait["order"]["self"] 		= 16000;
	anim.eventActionMinWait["order"]["squad"] 		= 12000;
	anim.eventActionMinWait["inform"]["self"] 		= 12000;
	anim.eventActionMinWait["inform"]["squad"] 		= 6000;
	anim.eventActionMinWait["custom"]["self"] 		= 0;
	anim.eventActionMinWait["custom"]["squad"] 		= 0;
	*/
	if ( isDefined( level._stealth ) )
	{
		anim.eventActionMinWait["threat"]["self"] 		= 20000;
		anim.eventActionMinWait["threat"]["squad"] 		= 30000;
	}
	else
	{
		anim.eventActionMinWait["threat"]["self"] 		= 12000;
		anim.eventActionMinWait["threat"]["squad"] 		= 8000;
	}
	anim.eventActionMinWait["response"]["self"] 	= 1000;
	anim.eventActionMinWait["response"]["squad"] 	= 1000;
	anim.eventActionMinWait["reaction"]["self"] 	= 1000;
	anim.eventActionMinWait["reaction"]["squad"] 	= 1000;
	anim.eventActionMinWait["order"]["self"] 		= 8000;
	anim.eventActionMinWait["order"]["squad"] 		= 40000;
	anim.eventActionMinWait["inform"]["self"] 		= 6000;
	anim.eventActionMinWait["inform"]["squad"] 		= 8000;
	anim.eventActionMinWait["custom"]["self"] 		= 0;
	anim.eventActionMinWait["custom"]["squad"] 		= 5000;
	
	anim.eventTypeMinWait["reaction"]["casualty"]	= 20000;
	anim.eventTypeMinWait["reaction"]["taunt"]		= 200000;
	anim.eventTypeMinWait["inform"]["reloading"]	= 20000;
	
	anim.eventPriority["threat"]["infantry"] 		= 0.5;
	anim.eventPriority["threat"]["emplacement"] 	= 0.6;
	anim.eventPriority["threat"]["vehicle"] 		= 0.7;
	anim.eventPriority["response"]["killfirm"] 	= 0.8;
	anim.eventPriority["response"]["ack"] 	= 0.9;
	anim.eventPriority["reaction"]["casualty"] 		= 0.5;
	anim.eventPriority["reaction"]["taunt"] 		= 0.9;
	anim.eventPriority["order"]["cover"] 			= 0.9;
	anim.eventPriority["order"]["action"] 			= 0.5;
	anim.eventPriority["order"]["move"] 			= 0.9;
	anim.eventPriority["order"]["displace"] 		= 0.5;
	anim.eventPriority["inform"]["killfirm"] 	= 0.6;
	anim.eventPriority["inform"]["attack"] 		= 0.9;
	anim.eventPriority["inform"]["incoming"] 		= 0.8;
	anim.eventPriority["inform"]["reloading"] 		= 0.2;
	anim.eventPriority["inform"]["suppressed"] 		= 0.2;
	anim.eventPriority["custom"]["generic"]			= 1.0;
	
	anim.eventDuration["threat"]["emplacement"] 	= 1000;
	anim.eventDuration["threat"]["infantry"] 		= 1000;
	anim.eventDuration["threat"]["vehicle"]			= 1000;
	anim.eventDuration["response"]["killfirm"] 	= 3000;
	anim.eventDuration["response"]["ack"]   = 2000;
	anim.eventDuration["reaction"]["casualty"] 		= 2000;
	anim.eventDuration["reaction"]["taunt"] 		= 2000;
	anim.eventDuration["order"]["cover"] 			= 3000;
	anim.eventDuration["order"]["action"] 			= 3000;
	anim.eventDuration["order"]["move"] 			= 3000;
	anim.eventDuration["order"]["displace"] 		= 3000;
	anim.eventDuration["inform"]["killfirm"] 	= 1000;
	anim.eventDuration["inform"]["attack"] 		= 1000;
	anim.eventDuration["inform"]["incoming"] 		= 1000;
	anim.eventDuration["inform"]["reloading"] 		= 1000;
	anim.eventDuration["inform"]["suppressed"] 		= 2000;
	anim.eventDuration["custom"]["generic"]			= 1000;

	anim.chatCount = 0;
	
	anim.moveOrigin = spawn ("script_origin", (0, 0, 0));

	anim.areas = getentarray ("trigger_location", "targetname");
	anim.locations = getentarray ("trigger_location", "targetname");
	anim.landmarks = getentarray ("trigger_landmark", "targetname");
	
/#
	if (getdvar("debug_bcdrawobjects") == "on")
		thread bcDrawObjects();
#/
	
	anim.squadCreateFuncs[anim.squadCreateFuncs.size] = ::init_squadBattleChatter;
	anim.squadCreateStrings[anim.squadCreateStrings.size] = "::init_squadBattleChatter";

	anim.isTeamSpeaking["allies"] = false;
	anim.isTeamSaying["allies"]["threat"] = false;
	anim.isTeamSaying["allies"]["order"] = false;
	anim.isTeamSaying["allies"]["reaction"] = false;
	anim.isTeamSaying["allies"]["response"] = false;
	anim.isTeamSaying["allies"]["inform"] = false;
	anim.isTeamSaying["allies"]["custom"] = false;

	anim.isTeamSpeaking["axis"] = false;
	anim.isTeamSaying["axis"]["threat"] = false;
	anim.isTeamSaying["axis"]["order"] = false;
	anim.isTeamSaying["axis"]["reaction"] = false;
	anim.isTeamSaying["axis"]["response"] = false;
	anim.isTeamSaying["axis"]["inform"] = false;
	anim.isTeamSaying["axis"]["custom"] = false;

	anim.isTeamSpeaking["neutral"] = false;
	anim.isTeamSaying["neutral"]["threat"] = false;
	anim.isTeamSaying["neutral"]["order"] = false;
	anim.isTeamSaying["neutral"]["reaction"] = false;
	anim.isTeamSaying["neutral"]["response"] = false;
	anim.isTeamSaying["neutral"]["inform"] = false;
	anim.isTeamSaying["neutral"]["custom"] = false;

	if (!isdefined(level.battlechatter))
	{
		level.battlechatter = [];
		level.battlechatter["allies"] = true;
		level.battlechatter["axis"] = true;
		level.battlechatter["neutral"] = true;
	}
	
	anim.lastTeamSpeakTime = [];
	anim.lastTeamSpeakTime["allies"] = -5000; // so it doesnt pause if nobody has ever spoken
	anim.lastTeamSpeakTime["axis"] = -5000;

	for (index = 0; index < anim.squadIndex.size; index++)
	{
		if (isdefined(anim.squadIndex[index].chatInitialized) && anim.squadIndex[index].chatInitialized )
			continue;

		anim.squadIndex[index] init_squadBattleChatter();
	}

	level notify ("battlechatter initialized");
	anim notify ("battlechatter initialized");
	
}

shutdown_battleChatter()
{
	anim.countryIDs = undefined;
	anim.eventTypeMinWait = undefined;
	anim.eventActionMinWait = undefined;	
	anim.eventTypeMinWait = undefined;	
	anim.eventPriority = undefined;
	anim.eventDuration = undefined;

	anim.chatCount = undefined;
	
	anim.moveOrigin = undefined;

	anim.areas = undefined;
	anim.locations = undefined;
	anim.landmarks = undefined;

	anim.usedIDs = undefined;

	anim.chatInitialized = false;
	anim.player.chatInitialized = false;

	level.battlechatter = undefined;
	
	for (i = 0; i < anim.squadCreateFuncs.size; i++)
	{
		if (anim.squadCreateStrings[i] != "::init_squadBattleChatter")
			continue;
		
		if (i != (anim.squadCreateFuncs.size - 1))
		{
			anim.squadCreateFuncs[i] = anim.squadCreateFuncs[anim.squadCreateFuncs.size - 1];
			anim.squadCreateStrings[i] = anim.squadCreateStrings[anim.squadCreateStrings.size - 1];
		}

		anim.squadCreateFuncs[anim.squadCreateFuncs.size - 1] = undefined;
		anim.squadCreateStrings[anim.squadCreateStrings.size - 1] = undefined;
	}

	level notify ("battlechatter disabled");
	anim notify ("battlechatter disabled");
}

// initializes battlechatter data that resides in the squad manager
// this is done to keep the squad management system free from clutter
init_squadBattleChatter()
{
	squad = self;

	// tweakables
	squad.numSpeakers = 0;
	squad.maxSpeakers = 1;

	// non tweakables
	squad.nextSayTime = getTime() + 50;
	squad.nextSayTimes["threat"] = getTime() + 50;
	squad.nextSayTimes["order"] = getTime() + 50;
	squad.nextSayTimes["reaction"] = getTime() + 50;
	squad.nextSayTimes["response"] = getTime() + 50;
	squad.nextSayTimes["inform"] = getTime() + 50;
	squad.nextSayTimes["custom"] = getTime() + 50;
	
	squad.nextTypeSayTimes["threat"] = [];
	squad.nextTypeSayTimes["order"] = [];
	squad.nextTypeSayTimes["reaction"] = [];
	squad.nextTypeSayTimes["response"] = [];
	squad.nextTypeSayTimes["inform"] = [];
	squad.nextTypeSayTimes["custom"] = [];

	squad.isMemberSaying["threat"] = false;
	squad.isMemberSaying["order"] = false;
	squad.isMemberSaying["reaction"] = false;
	squad.isMemberSaying["response"] = false;
	squad.isMemberSaying["inform"] = false;
	squad.isMemberSaying["custom"] = false;
	squad.lastDirection = "";
	
	squad.memberAddFuncs[squad.memberAddFuncs.size] = ::addToSystem;
	squad.memberAddStrings[squad.memberAddStrings.size] = "::addToSystem";
	squad.memberRemoveFuncs[squad.memberRemoveFuncs.size] = ::removeFromSystem;
	squad.memberRemoveStrings[squad.memberRemoveStrings.size] = "::removeFromSystem";
	squad.squadUpdateFuncs[squad.squadUpdateFuncs.size] = ::initContact;
	squad.squadUpdateStrings[squad.squadUpdateStrings.size] = "::initContact";

	for (i = 0; i < anim.squadIndex.size; i++)
		squad thread initContact (anim.squadIndex[i].squadName);

//	squad thread randomThreatWaiter();
	squad thread squadThreatWaiter();
	squad thread squadOfficerWaiter();
	squad.chatInitialized = true;
	
	squad notify ("squad chat initialized");
}

// initializes battlechatter data that resides in the squad manager
// this is done to keep the squad management system free from clutter
shutdown_squadBattleChatter()
{
	squad = self;

	// tweakables
	squad.numSpeakers = undefined;
	squad.maxSpeakers = undefined;

	// non tweakables
	squad.nextSayTime = undefined;
	squad.nextSayTimes = undefined;
	
	squad.nextTypeSayTimes = undefined;

	squad.isMemberSaying = undefined;
	
	for (i = 0; i < squad.memberAddFuncs.size; i++)
	{
		if (squad.memberAddStrings[i] != "::addToSystem")
			continue;
		
		if (i != (squad.memberAddFuncs.size - 1))
		{
			squad.memberAddFuncs[i] = squad.memberAddFuncs[squad.memberAddFuncs.size - 1];
			squad.memberAddStrings[i] = squad.memberAddStrings[squad.memberAddStrings.size - 1];
		}
			
		squad.memberAddFuncs[squad.memberAddFuncs.size - 1] = undefined;
		squad.memberAddStrings[squad.memberAddStrings.size - 1] = undefined;
	}

	for (i = 0; i < squad.memberRemoveFuncs.size; i++)
	{
		if (squad.memberRemoveStrings[i] != "::removeFromSystem" )
			continue;
		
		if (i != (squad.memberRemoveFuncs.size - 1))
		{
			squad.memberRemoveFuncs[i] = squad.memberRemoveFuncs[squad.memberRemoveFuncs.size - 1];
			squad.memberRemoveStrings[i] = squad.memberRemoveStrings[squad.memberRemoveStrings.size - 1];
		}
			
		squad.memberRemoveFuncs[squad.memberRemoveFuncs.size - 1] = undefined;
		squad.memberRemoveStrings[squad.memberRemoveStrings.size - 1] = undefined;
	}
	
	for (i = 0; i < squad.squadUpdateFuncs.size; i++)
	{
		if (squad.squadUpdateStrings[i] != "::initContact")
			continue;
		
		if (i != (squad.squadUpdateFuncs.size - 1))
		{
			squad.squadUpdateFuncs[i] = squad.squadUpdateFuncs[squad.squadUpdateFuncs.size - 1];
			squad.squadUpdateStrings[i] = squad.squadUpdateStrings[squad.squadUpdateStrings.size - 1];
		}
			
		squad.squadUpdateFuncs[squad.squadUpdateFuncs.size - 1] = undefined;
		squad.squadUpdateStrings[squad.squadUpdateStrings.size - 1] = undefined;
	}
	
	for (i = 0; i < anim.squadIndex.size; i++)
		squad shutdownContact (anim.squadIndex[i].squadName);

	squad.chatInitialized = false;
}

bcsEnabled()
{
	return anim.chatInitialized;
}

bcsDebugWaiter()
{
	lastState = getdvar ("bcs_enable");

	while (1)
	{
		state = getdvar ("bcs_enable");
		
		if (state != lastState)
		{
			switch (state)
			{
				case "on":
					if (!anim.chatInitialized)
						enableBattleChatter();
					break;
				case "off":
					if (anim.chatInitialized)
						disableBattleChatter();
					break;
			}
			lastState = state;
		}

		wait (1.0);
	}
}

enableBattleChatter()
{
	init_battleChatter();

	anim.player thread animscripts\battleChatter_ai::addToSystem();
	
	ai = getaiarray();
	for (i = 0; i < ai.size; i++)
	{
		ai[i] addToSystem();
	}
}

disableBattleChatter()
{
	shutdown_battleChatter();
	
	ai = getaiarray();
	for (i = 0; i < ai.size; i++)
	{
		if (isdefined (ai[i].squad) && ai[i].squad.chatInitialized)
			ai[i].squad shutdown_squadBattleChatter();

		ai[i] removeFromSystem();
	}
}

/****************************************************************************
 processing
*****************************************************************************/

playBattleChatter()
{
	if (!bcsEnabled())
		return;

	if (!self.battleChatter)
		return;

 	if (self.isSpeaking)
 		return;
 		
 	if (self._animActive > 0)
 		return;

	if (self.squad.numSpeakers >= self.squad.maxSpeakers)
		return;
		
	if (anim.isTeamSpeaking[self.team])
		return;

	// might need an optimized quick out here since this function will be called frequently
	// stance checks... bail out if the voice/anim combo we're trying to play would block to abruptly

	if (!isalive(self))
		return;

	self endon ("death");

	/# self thread debugQueueEvents(); #/
	/# self thread debugPrintEvents(); #/

	event = self getHighestPriorityEvent();
	
	if ( !isdefined( event ) )
		return;
	
	switch ( event )
	{
	case "custom":
		self thread playCustomEvent();
		break;
	case "response":
		self thread playResponseEvent();
		break;
	case "order":
		self thread playOrderEvent();
		break;
	case "threat":
		self thread playThreatEvent();
		break;
	case "reaction":
		self thread playReactionEvent();
		break;
	case "inform":
		self thread playInformEvent();
		break;
	}
}

//// threat events functions
playThreatEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	self endon ("cancel speaking");
	self.curEvent = self.chatQueue["threat"];
	
	threat = self.chatQueue["threat"].threat;
	
	if (!isalive(threat) || (isdefined (threat.calledOut) && isdefined (threat.calledOut[self.squad.squadName])))
		return;

	anim thread lockAction (self, "threat");
	
	/#
	if (getdvar("debug_bcinteraction") == "on")
		animscripts\utility::showDebugLine( self.origin + (0,0,50), threat.origin + (0,0,50), (1,0,0), 1.5 );
	#/
		
	switch (self.chatQueue["threat"].eventType)
	{
	case "infantry":
		if (threat == level.player || !isdefined (threat getturret()))
			self threatInfantry (threat);
//		else
//			self threatEmplacement (threat);
		break;
	case "dog":
		self threatDog (threat );
	case "emplacement":
			self threatEmplacement (threat);		
		break;
	case "vehicle":
		break;
	}
	
	self notify ("done speaking");

	if (!isalive(threat))
		return;

	threat.calledOut[self.squad.squadName] = spawnstruct();
	threat.calledOut[self.squad.squadName].spotter = self;
	threat.calledOut[self.squad.squadName].threatType = self.chatQueue["threat"].eventType;
	threat.calledOut[self.squad.squadName].expireTime = gettime() + 3000;

	if (isdefined (threat.squad))
		self.squad.squadList[threat.squad.squadName].calledOut = true;
}

threatInfantry (threat, forceDetail)
{
	self endon ("cancel speaking");
	chatPhrase = self createChatPhrase();
	
	chatPhrase.master = true;

	if (!isdefined (forceDetail))
		chatPhrase.forceDetail = false;
	else
		chatPhrase.forceDetail = forceDetail;

	chatPhrase.threatEnt = threat;
	
//	if (isdefined (threat.squad) && self.squad.squadList[threat.squad.squadName].calledOut == false && self.combatTime < 1.0)
//		chatPhrase threatInfantryContact (threat);
//	else if (threat bcIsSniper())
	if ( self.voice == "british" )
	{
		if ( threat weaponAnims() == "rocketlauncher" )
		{
			chatPhrase threatInfantryRPG( threat );
		}
		else
		{
			direction = getDirectionCompass( self.origin, threat.origin );

			switch( direction )
			{
				case "northwest":
					direction = "nthwest";
					if ( direction == self.squad.lastDirection )
						direction = "generic";
					break;
				case "northeast":
					direction = "ntheast";
					if ( direction == self.squad.lastDirection )
						direction = "generic";
					break;
				case "southwest":
					direction = "sthwest";
					if ( direction == self.squad.lastDirection )
						direction = "generic";
					break;
				case "southeast":
					direction = "stheast";
					if ( direction == self.squad.lastDirection )
						direction = "generic";
					break;
				case "impossible":
					direction = "generic";
			}
			
			self.squad.lastDirection = direction;
			chatPhrase addThreatAlias (1.0, "infantry", direction);
		}
	}
	else if ( threat weaponAnims() == "rocketlauncher" )
	{
		chatPhrase threatInfantryRPG( threat );
	}
	else if ( threat weaponAnims() == "mg" )
	{
		chatPhrase threatInfantryMG( threat );
	}
	else if (threat isExposed() && !isdefined (threat getLandmark()))
	{
		chatPhrase threatInfantryExposed (threat);
	}
	else
	{
		if (!isdefined (threat getLocation()) && !isdefined (threat getLandMark()))
		{
			chatPhrase addThreatAlias (1.0, "infantry", "generic");		
			chatPhrase addDirectionAlias (1.0, "relative", threat);
			chatPhrase addAreaAlias (0.5, threat);
		}
		else
		{
			chatPhrase addThreatAlias (1.0, "infantry", "generic");
			if (chatPhrase addLocationAlias (1.0, threat))
			{
				orderTo = getTargettingAI (threat);

				if (isdefined (orderTo))
				{
					if (isdefined (orderTo.bcName) && self canSayName(orderTo.bcName))
					{
						chatPhrase addNameAlias (orderTo.bcName);
						chatPhrase.lookTarget = orderTo;
					}
					else if (isdefined (orderTo.bcRank))
					{
						chatPhrase addRankAlias (orderTo.bcRank);
						chatPhrase.lookTarget = orderTo;
					}
					chatPhrase addOrderAlias (1.0, "attack", "infantry");
					if (self isOfficer())
						orderTo addResponseEvent("ack", "yes", self, 0.9);
					else
						orderTo addResponseEvent("ack", "norankyes", self, 0.9);
				}
				else
				{
					if (randomfloat(1) > 0.3)
					{
						chatPhrase addDirectionAlias (1.0, "side", threat, chatPhrase.locationEnt getOrigin());
					}
					else
					{
						chatPhrase addAreaAlias (0.5, threat);
						chatPhrase addOrderAlias (1.0, "attack", "infantry");
					}
				}
			}
			else if (chatPhrase addLandmarkAlias (1.0, threat))
			{
				orderTo = getTargettingAI (threat);

				if (isdefined (orderTo))
				{					
					if (isdefined (orderTo.bcName) && self canSayName(orderTo.bcName))
					{
						chatPhrase addNameAlias (orderTo.bcName);
						chatPhrase.lookTarget = orderTo;
					}
					else if (isdefined (orderTo.bcRank))
					{
						chatPhrase addRankAlias (orderTo.bcRank);
						chatPhrase.lookTarget = orderTo;
					}
					chatPhrase addOrderAlias (1.0, "attack", "infantry");
					if (self isOfficer())
						orderTo addResponseEvent("ack", "yes", self, 0.9);
					else
						orderTo addResponseEvent("ack", "norankyes", self, 0.9);
				}
				else
				{
					if (randomfloat(1) > 0.3)
					{
						chatPhrase addDirectionAlias (1.0, "relative", threat);
					}
					else
					{
						chatPhrase addAreaAlias (0.5, threat);
						chatPhrase addOrderAlias (1.0, "attack", "infantry");
					}
				}
			}
		}		
	}
	
	self playPhrase (chatPhrase);
}


threatDog (threat, forceDetail)
{
	self endon ("cancel speaking");
	chatPhrase = self createChatPhrase();
	
	chatPhrase.master = true;

	if (!isdefined (forceDetail))
		chatPhrase.forceDetail = false;
	else
		chatPhrase.forceDetail = forceDetail;

	chatPhrase.threatEnt = threat;

	if ( self.voice == "british" )
	{
		direction = getDirectionCompass( self.origin, threat.origin );

		switch( direction )
		{
			case "northwest":
				direction = "nthwest";
				break;
			case "northeast":
				direction = "ntheast";
				break;
			case "southwest":
				direction = "sthwest";
				break;
			case "southeast":
				direction = "stheast";
				break;
			case "impossible":
				direction = "generic";				
		}
		chatPhrase addThreatAlias (1.0, "dog", direction);
	}
	else
	{	
		chatPhrase addThreatAlias (1.0, "dog", "generic");		
		chatPhrase addDirectionAlias (1.0, "relative", threat);
	}
	
	self playPhrase (chatPhrase);
}


threatInfantryContact (threat)
{
	self addInformAlias (1.0, "contact", "generic");
	
	if (threat bcIsSniper())
		self addThreatAlias (1.0, "infantry", "sniper");
	else if (threat isExposed() && !isdefined (threat getLandmark()))
		self addThreatAlias (1.0, "infantry", "exposed");
	else
		self addThreatAlias (1.0, "infantry", "generic");
		
	self.forceDetail = true;
	if (!self addLandmarkAlias(0.5, threat))
		self addDirectionAlias (1.0, "relative", threat);
}

threatInfantrySniper (threat)
{
	self addThreatAlias (1.0, "infantry", "sniper");
	
	if (self addAreaAlias (0.5, threat) && self.areaDetail)
		return;

	if (self addLocationAlias (0.5, threat))
		self addDirectionAlias (0.5, "side", threat, self.locationEnt getOrigin());
	else if (self addLandmarkAlias (0.5, threat))
		self addDirectionAlias (0.5, "relative", threat);
}

threatInfantryExposed (threat)
{
	
	if (!isdefined (threat getLandmark()))
		self addThreatAlias (1.0, "infantry", "exposed");
	else
		self addThreatAlias (1.0, "infantry", "generic");
	
	if (self addLandmarkAlias (1.0, threat))
		self addDirectionAlias (0.5, "relative", threat);
	else
		self addDirectionAlias (1.0, "relative", threat);
}

threatInfantryRPG (threat)
{
	self addThreatAlias (1.0, "rpg", "generic");
	
	if (self addAreaAlias (0.5, threat) && self.areaDetail)
		return;

	if (self addLocationAlias (0.5, threat))
		self addDirectionAlias (0.5, "side", threat, self.locationEnt getOrigin());
	else if (self addLandmarkAlias (0.5, threat))
		self addDirectionAlias (0.5, "relative", threat);
}

threatInfantryMG (threat)
{
	self addThreatAlias (1.0, "mg", "generic");
	
	if (self addAreaAlias (0.5, threat) && self.areaDetail)
		return;

	if (self addLocationAlias (0.5, threat))
		self addDirectionAlias (0.5, "side", threat, self.locationEnt getOrigin());
	else if (self addLandmarkAlias (0.5, threat))
		self addDirectionAlias (0.5, "relative", threat);
}


threatEmplacement (threat, forceDetail)
{
	chatPhrase = self createChatPhrase();

//	if (level.player canSeePoint(threat.origin))
		chatPhrase.master = true;

	if (!isdefined (forceDetail))
		chatPhrase.forceDetail = false;
	else
		chatPhrase.forceDetail = forceDetail;
	
	chatPhrase addThreatAlias (1.0, "emplacement", "mg42");

	if (!isdefined (threat getLocation()) && !isdefined (threat getLandMark()))
	{
		chatPhrase addOrderAlias (1.0, "attack", "armor");
	}
	else
	{
		if (chatPhrase addLocationAlias (0.5, threat))
			chatPhrase addDirectionAlias (0.5, "side", threat, chatPhrase.locationEnt getOrigin());
		else if (chatPhrase addLandmarkAlias (0.5, threat))
			chatPhrase addDirectionAlias (0.5, "relative", threat);
		else
			chatPhrase addDirectionAlias (0.5, "relative", threat);

		chatPhrase addAreaAlias (0.5, threat);

	}
	
	self playPhrase (chatPhrase);
}

//// reaction events functions
playReactionEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	self.curEvent = self.chatQueue["reaction"];

	reactTo = self.chatQueue["reaction"].reactTo;

	anim thread lockAction (self, "reaction");
	
	switch (self.chatQueue["reaction"].eventType)
	{
	case "casualty":
		self reactionCasualty (reactTo, self.chatQueue["reaction"].modifier);
		break;
	case "taunt":
		self reactionTaunt (reactTo, self.chatQueue["reaction"].modifier);
		break;
	}

	self notify ("done speaking");
}

reactionCasualty (reactTo, modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	chatPhrase = self createChatPhrase();
	chatPhrase addReactionAlias (1.0, "casualty", "generic");

	self playPhrase (chatPhrase);
}

reactionTaunt (reactTo, modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	chatPhrase = self createChatPhrase();
	chatPhrase addTauntAlias (1.0, "taunt", "generic");

	self playPhrase (chatPhrase);
}

//// response events functions
playResponseEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	self.curEvent = self.chatQueue["response"];

	respondTo = self.chatQueue["response"].respondTo;

	if (!isalive (respondTo))
		return;

	if (self.chatQueue["response"].modifier == "follow" && self.a.state != "move" )
		return;

	anim thread lockAction (self, "response");

	/#
	if (getdvar("debug_bcinteraction") == "on" )
		animscripts\utility::showDebugLine( self.origin + (0,0,50), respondTo.origin + (0,0,50), (1,1,0), 1.5 );
	#/
	
	switch (self.chatQueue["response"].eventType)
	{
	case "killfirm":
		self responseKillConfirm (respondTo, self.chatQueue["response"].modifier);
		break;
	case "ack":
		self responseAcknowledge (respondTo, self.chatQueue["response"].modifier);
		break;
	}

	self notify ("done speaking");
}

responseAcknowledge (respondTo, modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	if (!isalive (respondTo))
		return;
		
	chatPhrase = self createChatPhrase();
	chatPhrase addResponseAlias (1.0, "ack", modifier);
	chatPhrase.lookTarget = respondTo;

	self playPhrase (chatPhrase);
}

responseKillConfirm (respondTo, modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	chatPhrase = self createChatPhrase();
	chatPhrase addResponseAlias (1.0, "killfirm", "infantry");
	chatPhrase.lookTarget = respondTo;

	self playPhrase (chatPhrase);
}

//// order events functions
playOrderEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	self.curEvent = self.chatQueue["order"];
	
	anim thread lockAction (self, "order");
	
	switch (self.chatQueue["order"].eventType)
	{
	case "action":
		self orderAction (self.chatQueue["order"].modifier);
		break;
	case "move":
		self orderMove (self.chatQueue["order"].modifier, self.chatQueue["order"].orderTo);
		break;
	case "displace":
		self orderDisplace (self.chatQueue["order"].modifier);
		break;
	case "cover":
		self orderCover (self.chatQueue["order"].modifier, self.chatQueue["order"].orderTo);
		break;
	}
	
	self notify ("done speaking");
}

orderMove (modifier, orderTo)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	chatPhrase = self createChatPhrase();

	if (modifier == "follow")
	{
		soldiers = getaiarray( self.team );

		orderTo = undefined;
		for (i = 0; i < soldiers.size; i++)
		{
			if (soldiers[i] == self)
				continue;
				
			if (distance (self.origin, soldiers[i].origin) > 500 && soldiers[i].a.state == "move" && soldiers[i] canSay("response"))
				orderTo = soldiers[i];
		}
		
		/#
		if (getdvar("debug_bcinteraction") == "on" && isDefined( orderTo ) )
			animscripts\utility::showDebugLine( self.origin + (0,0,50), orderTo.origin + (0,0,50), (0,1,0), 1.5 );
		#/
		
		if (isdefined (orderTo) && isdefined (orderTo.bcName) && self canSayName(orderTo.bcName))
		{
			chatPhrase addNameAlias (orderTo.bcName);
			chatPhrase.lookTarget = orderTo;
			orderTo addResponseEvent("ack", "follow", self, 1.0);
		}
		else if (isdefined (orderTo) && isdefined (orderTo.bcRank))
		{
			chatPhrase addRankAlias (orderTo.bcRank);
			chatPhrase.lookTarget = orderTo;
			orderTo addResponseEvent("ack", "follow", self, 1.0);
		}
		else
		{
			level notify ( "follow order", self );
		}

		chatPhrase addOrderAlias (1.0, "move", modifier);
	}
	else
	{
		chatPhrase addOrderAlias (1.0, "move", modifier);
	}
	
	self playPhrase (chatPhrase);
}


orderDisplace (modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	chatPhrase = self createChatPhrase();
	chatPhrase addOrderAlias (1.0, "displace", modifier);

	self playPhrase (chatPhrase, true);
}

orderAction (modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	chatPhrase = self createChatPhrase();
	chatPhrase addOrderAlias (1.0, "action", modifier);

	self playPhrase (chatPhrase);
}

orderCover (modifier, orderTo)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	chatPhrase = self createChatPhrase();

	/#
	if (getdvar("debug_bcinteraction") == "on" && isDefined( orderTo ) )
		animscripts\utility::showDebugLine( self.origin + (0,0,50), orderTo.origin + (0,0,50), (0,0,1), 1.5 );
	#/

	if (randomfloat(1) < 0.5 && self isOfficer())
	{
		if (isdefined (orderTo) && isdefined (orderTo.bcRank))
		{
			chatPhrase addRankAlias (orderTo.bcRank);
			chatPhrase.lookTarget = orderTo;
		}
	}
	else
	{
		if (isdefined (orderTo) && isdefined (orderTo.bcName) && self canSayName(orderTo.bcName))
		{
			chatPhrase addNameAlias (orderTo.bcName);
			chatPhrase.lookTarget = orderTo;
		}
		else if (isdefined (orderTo) && isdefined (orderTo.bcRank))
		{
			chatPhrase addRankAlias (orderTo.bcRank);
			chatPhrase.lookTarget = orderTo;
		}
	}
	chatPhrase addOrderAlias (1.0, "cover", modifier);
	
	self playPhrase (chatPhrase);
}

//// inform events functions
playInformEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");

	self.curEvent = self.chatQueue["inform"];
	
	anim thread lockAction (self, "inform");
	
	switch (self.chatQueue["inform"].eventType)
	{
	case "killfirm":
		self informKillConfirm(self.chatQueue["inform"].modifier);
		break;
	case "incoming":
		self informIncoming(self.chatQueue["inform"].modifier);
		break;
	case "attack":
		self informAttacking(self.chatQueue["inform"].modifier);
		break;
	case "reloading":
		self informReloading(self.chatQueue["inform"].informTo, self.chatQueue["inform"].modifier);
		break;
	case "suppressed":
		self informSupressed(self.chatQueue["inform"].modifier);
		break;
	}

	self notify ("done speaking");
}

Informreloading (informTo, modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	chatPhrase = self createChatPhrase();

	if (modifier == "coverme" && isalive (informTo) && isDefined( informTo.bcName ) && self canSayName(informTo.bcName))
	{
		if (informTo == level.player || self.countryID != "US")
		{
			modifier = "generic";
		}
		else
		{
			modifier = informTo.bcName;
			informTo addResponseEvent ("ack", "covering", self, 0.9);
			chatPhrase.lookTarget = informTo;
		}
	}
	else
	{
		modifier = "generic";
	}
	
	chatPhrase addInformAlias (1.0, "reloading", modifier);
	
	self playPhrase (chatPhrase);

}

informSupressed (modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");

	chatPhrase = self createChatPhrase();
	chatPhrase addInformAlias (1.0, "suppressed", modifier);
	
	self playPhrase (chatPhrase);

}

informIncoming (modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	chatPhrase = self createChatPhrase();
	if (modifier == "grenade")
		chatPhrase.master = true;

	chatPhrase addInformAlias (1.0, "incoming", modifier);

	self playPhrase (chatPhrase);
}

informAttacking (modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	chatPhrase = self createChatPhrase();	
	chatPhrase addInformAlias (1.0, "attack", modifier);

	self playPhrase (chatPhrase);
}

informKillConfirm (modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	chatPhrase = self createChatPhrase();	
	chatPhrase addInformAlias (1.0, "killfirm", "infantry");

	self playPhrase (chatPhrase);
}

//// custom events functions
playCustomEvent()
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	self.curEvent = self.chatQueue["custom"];

	anim thread lockAction (self, self.curEvent.type, true );
	
	self playPhrase (self.customChatPhrase);

	self notify ("done speaking");
	self.customChatEvent = undefined;
	self.customChatPhrase = undefined;
}

/****************************************************************************
 utility
*****************************************************************************/

playPhrase (chatPhrase, noSound)
{
	anim endon ("battlechatter disabled");
	self endon ("death");
	
	if (isdefined (noSound))
		return;

//	if ( getDvar( "bcs_stealth" ) != "" && self.voice == "british" )
	if ( isDefined( level._stealth ) && self.voice == "british" )
	{
		for (i = 0; i < chatPhrase.soundAliases.size; i++)
			chatPhrase.soundAliases[i] = chatPhrase.soundAliases[i] + "_s";
	}
		
	if (self battleChatter_canPrint())
	{
		for (i = 0; i < chatPhrase.soundAliases.size; i++)
		{
			self battleChatter_print (chatPhrase.soundAliases[i]);
		}
		self battleChatter_println ("");
	}
	
	for (i = 0; i < chatPhrase.soundAliases.size; i++)
	{
		if (!self.battleChatter)
			continue;

		if (self._animActive > 0)
			continue;

		if (isFiltered(self.curEvent.eventAction))
		{
			wait (0.85);
			continue;
		}
		
		startTime = gettime();

		if (chatPhrase.master && self.team == "allies")
		{
			if (getdvar ("bcs_threatPlayerRelative") == "on")
			{
				if (strfind (chatPhrase.soundAliases[i], "_direction_"))
				{
					if (isdefined (chatPhrase.threatEnt))
					{
						chatPhrase.soundAliases[i] = chatPhrase getDirectionAliasPlayerRelative (chatPhrase.threatEnt);
						println ("setting player relative direction");
					}
				}
			}
			
			self playsoundasmaster(chatPhrase.soundAliases[i], chatPhrase.soundAliases[i], true);
			thread maps\_anim::anim_facialFiller( chatPhrase.soundAliases[i], chatPhrase.lookTarget );
			self waittill(chatPhrase.soundAliases[i]);
		}
		else
		{
			self playsound(chatPhrase.soundAliases[i], chatPhrase.soundAliases[i], true);
			thread maps\_anim::anim_facialFiller( chatPhrase.soundAliases[i], chatPhrase.lookTarget );
			self waittill(chatPhrase.soundAliases[i]);
		}
		
//		if (gettime() < startTime + 250)
//			println ("^6Missing Sound: " + chatPhrase.soundAliases[i]);
	}
//	animscripts\shared::LookAtStop();
	
	self doTypeLimit (self.curEvent.eventAction, self.curEvent.eventType);
}

isSpeakingFailSafe( eventAction )
{
	self endon( "death" );
	wait( 45 );
	self clearIsSpeaking( eventAction );
}

clearIsSpeaking( eventAction )
{
	self.isSpeaking = false;
	self.chatQueue[eventAction].expireTime = 0;
	self.chatQueue[eventAction].priority = 0.0;
	self.nextSayTimes[eventAction] = gettime() + anim.eventActionMinWait[ eventAction ][ "self" ];
}

lockAction (speaker, eventAction, customEvent )
{
	anim endon ("battlechatter disabled");
	
	assert (!speaker.isSpeaking);

	squad = speaker.squad;
	team = speaker.team;

	speaker.isSpeaking = true;
	speaker thread isSpeakingFailSafe( eventAction );

	squad.isMemberSaying[eventAction] = true;
	squad.numSpeakers++;
	anim.isTeamSpeaking[team] = true;
	anim.isTeamSaying[team][eventAction] = true;

	message = speaker waittill_any_return("death", "done speaking", "cancel speaking");
	
	squad.isMemberSaying[eventAction] = false;
	squad.numSpeakers--;
	anim.isTeamSpeaking[team] = false;	
	anim.isTeamSaying[team][eventAction] = false;
	anim.lastTeamSpeakTime[team] = getTime();

	if (message == "cancel speaking")
		return;
	
	if (isalive (speaker))
	{
		speaker clearIsSpeaking( eventAction );
	}
	squad.nextSayTimes[eventAction] = gettime() + anim.eventActionMinWait[eventAction]["squad"];
}

updateContact (squadName, member)
{
	if (gettime() - self.squadList[squadName].lastContact > 10000)
	{
		isInContact = false;
		for (i = 0; i < self.members.size; i++)
		{
			if (self.members[i] != member && isalive (self.members[i].enemy) && isDefined( self.members[i].enemy.squad ) && self.members[i].enemy.squad.squadName == squadName)
				isInContact = true;
		}

		if (!isInContact)
		{
			self.squadList[squadName].firstContact = gettime();
			self.squadList[squadName].calledOut = false;
		}
	}
		
	self.squadList[squadName].lastContact = gettime();	
}

canSay (eventAction, eventType, priority, modifier)
{
	self endon ("death");
	self endon ("removed from battleChatter");
	
	if (self == level.player)
		return (false);
		
	// our battlechatter is disabled
	if (!isdefined( self.battlechatter ) || !self.battlechatter)
		return (false);
		
	if (isdefined (priority) && priority >= 1)
		return (true);

	// we're not allowed to call out a threat now, and won't be able to before it expires
	if ((gettime() + anim.eventActionMinWait[eventAction]["self"]) < self.nextSayTimes[eventAction])
		return (false);

	// the squad is not allowed to call out a threat yet and won't be able to before it expires
	if ((gettime() + anim.eventActionMinWait[eventAction]["squad"]) < self.squad.nextSayTimes[eventAction])
		return (false);

	if (isdefined (eventType) && typeLimited (eventAction, eventType))
		return (false);

	if (isdefined (eventType) && anim.eventPriority[eventAction][eventType] < self.bcs_minPriority)
		return (false);

	if ( self.voice == "british" )
		return britFilter( eventAction, eventType, modifier );

	return (true);
}


britFilter( action, type, modifier )
{
	if ( !isDefined( modifier ) )
		modifier = "";
		
	if ( !isDefined( type ) )
		return false;
		
	switch ( action )
	{
		case "order":
			if ( type == "action" && modifier == "coverme" )
				return true;
			break;
		case "threat":
			if ( type == "infantry" || type == "dog" || type == "rpg" )
				return true;
			break;
		case "inform":
			if ( type == "attack" && modifier == "grenade" )
				return true;
			else if ( type == "incoming" && modifier == "grenade" )
				return true;
			else if ( type == "killfirm" && modifier == "infantry" )
				return true;
			else if ( type == "reloading" && modifier == "generic" )
				return true;
			break;
		case "reaction":
			if ( type == "casualty" && modifier == "generic" )
				return true;
			break;
		default:
			return false;
	}
		
	return false;
}

getHighestPriorityEvent()
{
	best = undefined;
	bestpriority = -999999999;

	if ( self isValidEvent ("custom") )
	{
		// don't have to check priority because this is the first if
		best = "custom";
		bestpriority = self.chatQueue["custom"].priority;
	}
	if ( self isValidEvent ("response") )
	{
		if ( self.chatQueue["response"].priority > bestpriority )
		{
			best = "response";
			bestpriority = self.chatQueue["response"].priority;
		}
	}
	if ( self isValidEvent ("order") )
	{
		if ( self.chatQueue["order"].priority > bestpriority )
		{
			best = "order";
			bestpriority = self.chatQueue["order"].priority;
		}
	}
	if ( self isValidEvent ("threat") )
	{
		if ( self.chatQueue["threat"].priority > bestpriority )
		{
			best = "threat";
			bestpriority = self.chatQueue["threat"].priority;
		}
	}
	if ( self isValidEvent ("inform") )
	{
		if ( self.chatQueue["inform"].priority > bestpriority )
		{
			best = "inform";
			bestpriority = self.chatQueue["inform"].priority;
		}
	}
	if ( self isValidEvent ("reaction") )
	{
		if ( self.chatQueue["reaction"].priority > bestpriority )
		{
			best = "reaction";
			bestpriority = self.chatQueue["reaction"].priority;
		}
	}

	return best;
}

getTargettingAI(threat)
{
	squad = self.squad;
	targettingAI = [];
	for (index = 0; index < squad.members.size; index++)
	{
		if (isdefined (squad.members[index].enemy) && squad.members[index].enemy == threat)
			targettingAI[targettingAI.size] = squad.members[index];
	}
	
	if (!isdefined (targettingAI[0]))
		return (undefined);
	
	targettingSpeaker = undefined;
	for (index = 0; index < targettingAI.size; index++)
	{
		if (targettingAI[index] canSay("response"))
			return (targettingSpeaker);
	}
	return (getClosest(self.origin, targettingAI));
}

getQueueEvents()
{
	queueEvents = [];
	queueEventStates = [];
	
	queueEvents[0] = "custom";
	queueEvents[1] = "response";
	queueEvents[2] = "order";
	queueEvents[3] = "threat";
	queueEvents[4] = "inform";
	
	for (i = queueEvents.size - 1; i >= 0; i--)
	{
		for (j = 1; j <= i; j++)
		{
			if (self.chatQueue[queueEvents[j-1]].priority < self.chatQueue[queueEvents[j]].priority)
			{
				strTemp = queueEvents[j - 1];
				queueEvents[j - 1] = queueEvents[j];
				queueEvents[j] = strTemp;
			}
		}
	}
	
	validEventFound = false;
	for (i = 0; i < queueEvents.size; i++)
	{
		eventState = self getEventState (queueEvents[i]);
		
		if (eventState == " valid" && !validEventFound)
		{
			validEventFound = true;
			queueEventStates[i] = "g " + queueEvents[i] + eventState + " " + self.chatQueue[queueEvents[i]].priority;
		}
		else if (eventState == " valid")
		{
			queueEventStates[i] = "y " + queueEvents[i] + eventState + " " + self.chatQueue[queueEvents[i]].priority;
		}
		else
		{
			if (self.chatQueue[queueEvents[i]].expireTime == 0)
				queueEventStates[i] = "b " + queueEvents[i] + eventState + " " + self.chatQueue[queueEvents[i]].priority;
			else
				queueEventStates[i] = "r " + queueEvents[i] + eventState + " " + self.chatQueue[queueEvents[i]].priority;
		}
	}
	
	return queueEventStates;
}

getEventState (strAction)
{
	strState = "";
	if (self.squad.isMemberSaying[strAction])
		strState += " playing";
	if (gettime() > self.chatQueue[strAction].expireTime)
		strState += " expired";
	if (gettime() < self.squad.nextSayTimes[strAction])
		strState += " cantspeak";
	
	if (strState == "")
		strState = " valid";
		
	return (strState);
}

isFiltered (strAction)
{
	if (getdvar ("bcs_filter" + strAction) == "on" || getdvar ("bcs_filter" + strAction) == "1")
		return (true);
		
	return (false);
}

isValidEvent (strAction)
{
	if (!self.squad.isMemberSaying[strAction] && 
		!anim.isTeamSaying[self.team][strAction] && 
		gettime() < self.chatQueue[strAction].expireTime && 
		gettime() > self.squad.nextSayTimes[strAction])
	{
		// redundant?
		if (!typeLimited (strAction, self.chatQueue[strAction].eventType))
			return (true);
	}

	return (false);
}

typeLimited (strAction, strType)
{
	if (!isdefined (anim.eventTypeMinWait[strAction][strType]))
		return (false);
		
	if (!isdefined (self.squad.nextTypeSayTimes[strAction][strType]))
		return (false);

	if (gettime() > self.squad.nextTypeSayTimes[strAction][strType])
		return (false);
		
	return (true);
}

doTypeLimit(strAction, strType)
{
	if (!isdefined (anim.eventTypeMinWait[strAction][strType]))
		return;
	
	self.squad.nextTypeSayTimes[strAction][strType] = gettime() + anim.eventTypeMinWait[strAction][strType];	
}

bcIsSniper()
{
	if ( isPlayer( self ) )
		return (false);

	if (self isExposed())
		return (false);

	return animscripts\combat_utility::isSniperRifle( self.weapon );
}

isExposed()
{	
	if (isdefined (self getLocation()))
		return (false);

	node = self bcGetClaimedNode();
	
	if (!isdefined (node))
		return (true);

	if ((node.type[0] == "C") &&
		(node.type[1] == "o") &&
		(node.type[2] == "v"))
	{
		return (false);
	}
	
	return (true);
}

isClaimedNodeCover()
{
	node = self bcGetClaimedNode();
	
	if (!isdefined (node))
		return (false);

	if ((node.type[0] == "C") &&
		(node.type[1] == "o") &&
		(node.type[2] == "v"))
	{
		return (true);
	}
	
	return (false);
}

isClaimedNodeWindow()
{
	node = self bcGetClaimedNode();
	
	if (!isdefined (node))
		return (false);

	if (!isdefined (node.script_location))
		return (false);
	
	if (node.script_location == "window")
		return (true);
	
	return (false);
}

isNodeCover()
{
	node = self.node;
	
	if (!isdefined (node))
		return (false);

	if ((node.type[0] == "C") &&
		(node.type[1] == "o") &&
		(node.type[2] == "v"))
	{
		return (true);
	}
	
	return (false);
}

isOfficer()
{
	fullRank = self getRank();
	
	if (fullRank == "sergeant" || fullRank == "lieutenant" || fullRank == "captain" || fullRank == "sergeant")
		return (true);
		
	return (false);
}

bcGetClaimedNode()
{
	if ( isPlayer( self ) )
		node = self.node;
	else
		node = self GetClaimedNode();
}

getName()
{
	if ( self.team == "axis" )
		name = self.ainame;
	else if ( self.team == "allies" )
		name = self.name;
	else
		name = undefined;

	if (!isdefined (name) || self.voice == "british" )
		return ( undefined );

	tokens = strtok( name, " " );

	if ( tokens.size < 2 )
		return ( undefined );

	assert ( tokens.size > 1 );
	return ( tokens[1] );
}

getRank()
{
	return self.airank;
}

getClosestSpeaker (strAction, officerOnly)
{
	speakers = self getSpeakers (strAction, officerOnly);
	
	speaker = getClosest(self.origin, speakers);
	return (speaker);
}

getSpeakers (strAction, officersOnly)
{
	speakers = [];
	
	soldiers = getaiarray( self.team );
	
	if (isdefined (officersOnly) && officersOnly)
	{
		officers = [];
		for (i = 0; i < soldiers.size; i++)
		{
			if (soldiers[i] isOfficer())
				officers[officers.size] = soldiers[i];
		}
		soldiers = officers;
	}
	
	for (i = 0; i < soldiers.size; i++)
	{
		if (soldiers[i] == self)
			continue;
			
		if (!soldiers[i] canSay (strAction))
			continue;
			
		speakers[speakers.size] = soldiers[i];
	}
	
	return (speakers);
}
/*
getSpeakers (strAction, officersOnly)
{
	speakers = [];
	
	if (isdefined (officersOnly) && officersOnly)
		soldiers = self.squad.officers;
	else
		soldiers = self.squad.members;
	
	for (i = 0; i < soldiers.size; i++)
	{
		if (soldiers[i] == self)
			continue;
			
		if (!soldiers[i] canSay (strAction))
			continue;
			
		speakers[speakers.size] = soldiers[i];
	}
	
	return (speakers);
}
*/
getArea()
{
	areas = anim.areas;
	for (i = 0; i < areas.size; i++)
	{
		if (self istouching (areas[i]) && isdefined (areas[i].script_area))
			return (areas[i]);
	}
	return (undefined);
}

getLocation()
{
	locations = anim.locations;
	for (i = 0; i < locations.size; i++)
	{
		if (self istouching (locations[i]) && isdefined (locations[i].script_location))
			return (locations[i]);
	}
	return (undefined);
}

getLandmark()
{
	landmarks = anim.landmarks;
	for (i = 0; i < landmarks.size; i++)
	{
		if (self istouching (landmarks[i]) && isdefined (landmarks[i].script_landmark))
			return (landmarks[i]);
	}
	return (undefined);
}

getDirectionCompass (vOrigin, vPoint)
{
	angles = vectortoangles (vPoint - vOrigin);
	angle = angles[1];
	
	northYaw = getnorthyaw();
	angle -= northYaw;
	
	if (angle < 0)
		angle += 360;
	else if (angle > 360)
		angle -= 360;
	
	if (angle < 22.5 || angle > 337.5)
		direction = "north";
	else if (angle < 67.5)
		direction = "northwest";
	else if (angle < 112.5)
		direction = "west";
	else if (angle < 157.5)
		direction = "southwest";
	else if (angle < 202.5)
		direction = "south";
	else if (angle < 247.5)
		direction = "southeast";
	else if (angle < 292.5)
		direction = "east";
	else if (angle < 337.5)
		direction = "northeast";
	else 
		direction = "impossible";
		
	return (direction);
}

getDirectionReferenceSide (vOrigin, vPoint, vReference)
{
	anglesToReference = vectortoangles (vReference - vOrigin);
	anglesToPoint = vectortoangles (vPoint - vOrigin);
	
	angle = anglesToReference[1] - anglesToPoint[1];
	angle += 360;
	angle = int (angle) % 360;
	if (angle > 180)
		angle -= 360;
		
	if (angle > 2 && angle < 45)
		 side = "right";
	else if (angle < -2 && angle > -45)
		 side = "left";
	else
	{
		if (distance (vOrigin, vPoint) < distance (vOrigin, vReference))
			side = "front";
		else
			side = "rear"; 
	}
	
	return (side);		
}

getDirectionFacingFlank (vOrigin, vPoint, vFacing)
{
	anglesToFacing = vectortoangles (vFacing);
	anglesToPoint = vectortoangles (vPoint - vOrigin);
	
	angle = anglesToFacing[1] - anglesToPoint[1];
	angle += 360;
	angle = int (angle) % 360;
	
	if (angle > 315 || angle < 45)
		direction = "front";
	else if (angle < 135)
		direction = "right";
	else if (angle < 225)
		direction = "rear";
	else
		direction = "left";
		
	return (direction);
}

/*
getDirectionFacingClock (vOrigin, vPoint, vFacing)
{
	anglesToFacing = vectortoangles (vFacing);
	anglesToPoint = vectortoangles (vPoint - vOrigin);
	
	angle = anglesToFacing[1] - anglesToPoint[1];
	angle += 360;
	angle = int (angle) % 360;

	if (angle > 345 || angle < 15)
		direction = "12oclock";
	else if (angle < 45)
		direction = "1oclock";
	else if (angle < 75)
		direction = "2oclock";
	else if (angle < 105)
		direction = "3oclock";
	else if (angle < 135)
		direction = "4oclock";
	else if (angle < 165)
		direction = "5oclock";
	else if (angle < 195)
		direction = "6oclock";
	else if (angle < 225)
		direction = "7oclock";
	else if (angle < 255)
		direction = "8oclock";
	else if (angle < 285)
		direction = "9oclock";
	else if (angle < 315)
		direction = "10oclock";
	else
		direction = "11oclock";
	
	return (direction);
}
*/

getVectorRightAngle (vDir)
{
	return (vDir[1], 0 - vDir[0], vDir[2]);
}

getVectorArrayAverage (avAngles)
{
	vDominantDir = (0,0,0);
	
	for (i = 0; i < avAngles.size; i++)
		vDominantDir += avAngles[i];
	
	return (vDominantDir[0] / avAngles.size, vDominantDir[1] / avAngles.size, vDominantDir[2] / avAngles.size);
}

addNameAlias(name)
{
	self.soundAliases[self.soundAliases.size] = self.owner.countryID + "_" + self.owner.npcID + "_name_" + name;
}

addRankAlias(name)
{
	self.soundAliases[self.soundAliases.size] = self.owner.countryID + "_" + self.owner.npcID + "_rank_" + name;
}

canSayName(name)
{
	nameAlias = self.countryID + "_" + self.npcID + "_name_" + name;
	
	if ( soundExists( nameAlias ) )
		return ( true );
	else
		return ( false );
}

addAreaAlias (chance, target)
{
	if (randomfloat (1) > chance)
		return (false);

	self.areaEnt = target getArea();

	if (!isdefined (self.areaEnt))
		return (false);

	// HACK
	if ( self.areaEnt.script_area == "window" || self.areaEnt.script_area == "doorway" )
		println( "BUG: Entity has .script_area of " + self.areaEnt.script_area + ", this is not a valid area type.  See http://iwdocs/ow.asp?BattleChatterGuide for a list of valid areas." );
	// UNHACK
	
	area = self.areaEnt.script_area;

	node = target bcGetClaimedNode();
	if (isdefined (node) && isdefined (node.script_area))
	{
		area += node.script_area;
		self.areaDetail = true;
	}
	else
	{
		self.areaDetail = false;
		area += "_generic";
	}
		
	self.area = self.owner.countryID + "_" + self.owner.npcID + "_area_" + area;
	self.soundAliases[self.soundAliases.size] = self.area;
	
	return (true);
}

addLocationAlias (chance, target)
{
	if (randomfloat (1) > chance)
		return (false);
	
	self.locationEnt = target getLocation();	
	if (!isdefined (self.locationEnt))
		return (false);
		
	location = self.locationEnt.script_location;

	node = 	target bcGetClaimedNode();
	if (isdefined (node) && isdefined (node.script_location))
		location += "_" + node.script_location;
	else
		location += "_generic";
		
	self.location = self.owner.countryID + "_" + self.owner.npcID + "_location_" + location;
	self.soundAliases[self.soundAliases.size] = self.location;
	
	return (true);
}

addLandmarkAlias (chance, target)
{
	if (randomfloat (1) > chance)
		return (false);
	
	self.landmarkEnt = target getLandmark();	
	if (!isdefined (self.landmarkEnt))
		return (false);

	landmark = self.landmarkEnt.script_landmark;
	
	relation = getDirectionReferenceSide (self.owner.origin, target.origin, self.landmarkEnt.origin);
	
	if ( relation == "rear" && soundExists( self.owner.countryID + "_" + self.owner.npcID + "_landmark_behind_" + landmark ) )
		landmark = "behind_" + landmark;
	else if ( soundExists( self.owner.countryID + "_" + self.owner.npcID + "_landmark_near_" + landmark ) )
		landmark = "near_" + landmark;
	else
		return(false);
		
	self.landmark = self.owner.countryID + "_" + self.owner.npcID + "_landmark_" + landmark;
	self.soundAliases[self.soundAliases.size] = self.landmark;
	
	return (true);
}

addGenericAlias (chance, action, type, modifier)
{
	self.soundAliases[self.soundAliases.size] = self.owner.countryID + "_" + self.owner.npcID + "_" + action + "_" + type + "_" + modifier;
	
	self doTypeLimit(action, type);
}

addDirectionAlias (chance, relation, target, vector, style)
{
	if (randomfloat (1) > chance)
		return (false);

	switch (relation)
	{
	case "side":
		{
			direction = getDirectionReferenceSide (self.owner.origin, target.origin, vector);
	
			// TODO: reenable when sounds exist
//			if (!isdefined (self.location) || (direction != "left" && direction != "right"))
			if ( true )
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
			if (distance (self.owner.origin, target.origin) > 2048)
				directionStyle = 2;
			else if (distance (self.owner.origin, target.origin) > 800)
				directionStyle = 0;
			else
				directionStyle = 1;
		}
			
		if (directionStyle == 0)
		{
			// Clock directions are disabled for now; this may be permanent
//			direction = getDirectionFacingClock (self.owner.origin, target.origin, vectornormalize (self.owner.squad.forward));
			direction = getDirectionCompass (self.owner.origin, target.origin);
		}
		else if (directionStyle == 1)
			// TODO: reenable when sounds exist
			return (false);
//			direction = getDirectionFacingFlank (self.owner.origin, target.origin, vectornormalize (self.owner.squad.forward));
		else
			direction = getDirectionCompass (self.owner.origin, target.origin);
			
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

getDirectionAliasPlayerRelative (target)
{
	direction = getDirectionReferenceSide (level.player.origin, target.origin, anglesToForward(level.player.angles));
	direction = "relative" + "_" + direction;
	self.direction = self.owner.countryID + "_" + self.owner.npcID + "_direction_" + direction;
	
	return (self.direction);
}

addRelativeDirectionAlias (chance, type, modifier)
{
	assert (isdefined (type) && isdefined (modifier));
	self.direction = self.owner.countryID + "_" + self.owner.npcID + "_direction_" +  "_relative_" + modifier;
	self.soundAliases[self.soundAliases.size] = self.threat;
	return (true);
}

addSideDirectionAlias (chance, type, modifier)
{
	assert (isdefined (type) && isdefined (modifier));
	self.direction = self.owner.countryID + "_" + self.owner.npcID + "_direction_" + "_side_" + modifier;
	self.soundAliases[self.soundAliases.size] = self.threat;
	return (true);
}

addThreatAlias (chance, type, modifier)
{
	assert (isdefined (type) && isdefined (modifier));
	self.threat = self.owner.countryID + "_" + self.owner.npcID + "_threat_" + type + "_" + modifier;
	self.soundAliases[self.soundAliases.size] = self.threat;

	return (true);
}

addInformAlias (chance, type, modifier)
{
	assert (isdefined (type) && isdefined (modifier));
	self.inform = self.owner.countryID + "_" + self.owner.npcID + "_inform_" + type + "_" + modifier;
	self.soundAliases[self.soundAliases.size] = self.inform;

	return (true);
}

addResponseAlias (chance, type, modifier)
{
	assert (isdefined (type) && isdefined (modifier));
	self.response = self.owner.countryID + "_" + self.owner.npcID + "_response_" + type + "_" + modifier;
	self.soundAliases[self.soundAliases.size] = self.response;

	return (true);
}

addReactionAlias (chance, type, modifier)
{
	assert (isdefined (type) && isdefined (modifier));
	self.reaction = self.owner.countryID + "_" + self.owner.npcID + "_reaction_" + type + "_" + modifier;
	self.soundAliases[self.soundAliases.size] = self.reaction;

	return (true);
}

addTauntAlias (chance, type, modifier)
{
	assert (isdefined (type) && isdefined (modifier));
	self.reaction = self.owner.countryID + "_" + self.owner.npcID + "_taunt";
	self.soundAliases[self.soundAliases.size] = self.reaction;

	return (true);
}

addOrderAlias (chance, type, modifier)
{
	assert (isdefined (type) && isdefined (modifier));
	self.order = self.owner.countryID + "_" + self.owner.npcID + "_order_" + type + "_" + modifier;
	self.soundAliases[self.soundAliases.size] = self.order;
	
	return (true);
}

initContact (squadName)
{
	if (!isdefined (self.squadList[squadName].calledOut))
		self.squadList[squadName].calledOut = false;
		
	if (!isdefined (self.squadList[squadName].firstContact))
		self.squadList[squadName].firstContact = 2000000000;
		
	if (!isdefined (self.squadList[squadName].lastContact))
		self.squadList[squadName].lastContact = 0;
}

shutdownContact (squadName)
{
	self.squadList[squadName].calledOut = undefined;
	self.squadList[squadName].firstContact = undefined;
	self.squadList[squadName].lastContact = undefined;
}

createChatEvent (eventAction, eventType, priority)
{
	chatEvent = spawnstruct();
	chatEvent.owner = self;
	chatEvent.eventType = eventType;
	chatEvent.eventAction = eventAction;
	
	if (isdefined (priority))
		chatEvent.priority = priority;
	else
		chatEvent.priority = anim.eventPriority[eventAction][eventType];
		
	chatEvent.expireTime = gettime() + anim.eventDuration[eventAction][eventType];
	
	return chatEvent;
}

createChatPhrase()
{
	chatPhrase = spawnstruct();
	chatPhrase.owner = self;
	chatPhrase.soundAliases = [];
	chatPhrase.master = false;
	
	return chatPhrase;
}

canSeePoint(origin)
{
    forward = anglesToForward(self.angles);
    return (vectordot(forward, origin - self.origin) > 0.766); // 80 fov	
}

pointInFov(origin)
{
    forward = anglesToForward(self.angles);
    return (vectordot(forward, origin - self.origin) > 0.766); // 80 fov	
}

/****************************************************************************
 debugging functions
*****************************************************************************/

/#
debugPrintEvents()
{
	if (!isalive (self))
		return;

	if (getdvar ("debug_bcshowqueue") != self.team && getdvar ("debug_bcshowqueue") != "all")
		return;

	self endon ("death");
	self notify ("debugPrintEvents");
	self endon ("debugPrintEvents");
	
	queueEvents = self getQueueEvents();
	colors["g"] = (0,1,0);
	colors["y"] = (1,1,0);
	colors["r"] = (1,0,0);
	colors["b"] = (0,0,0);
	
	while (1)
	{
		aboveHead = self getshootatpos() + (0,0,10);
		for (i = 0; i < queueEvents.size; i++)
		{
			print3d (aboveHead, queueEvents[i], colors[queueEvents[i][0]], 1, 0.5);	// origin, text, RGB, alpha, scale
			aboveHead += (0,0,5);
		}
		wait 0.05;
	}
}	

debugQueueEvents ()
{
	if (getdvar("debug_bcresponse") == "on")
		self thread printQueueEvent ("response");
	if (getdvar("debug_bcthreat") == "on")
		self thread printQueueEvent ("threat");
	if (getdvar("debug_bcinform") == "on")
		self thread printQueueEvent ("inform");
	if (getdvar("debug_bcorder") == "on")
		self thread printQueueEvent ("order");
}

printAboveHead (string, duration, offset)
{
	self endon ("death");
	
	if (!isdefined (offset))
		offset = (0, 0, 0);
	
	for(i = 0; i < (duration * 2); i++)
	{
		if (!isalive (self))
			return;
			
		aboveHead = self getshootatpos() + (0,0,10) + offset;
		print3d (aboveHead, string, (1,0,0), 1, 0.5);	// origin, text, RGB, alpha, scale
		wait 0.05;
	}	
}

printQueueEvent (eventAction)
{
	time = gettime();
	
	if (self.chatQueue[eventAction].expireTime > 0 && !isdefined (self.chatQueue[eventAction].printed))
	{
		print ("QUEUE EVENT " + eventAction + "_" + self.chatQueue[eventAction].eventType + ": ");
		if (time > self.chatQueue[eventAction].expireTime)
			println ("^2 missed by " + (time - self.chatQueue[eventAction].expireTime) + "ms");
		else
			println ("slack of " + (self.chatQueue[eventAction].expireTime - time) + "ms");
			
		self.chatQueue[eventAction].printed = true;
	}
}

#/

battleChatter_canPrint()
{
	if (getdvar ("debug_bcprint") == self.team || getdvar ("debug_bcprint") == "all")
		return (true);

	return (false);
}

battleChatter_print (string)
{
	if (!self battleChatter_canPrint())
		return;

	if (self.team == "allies")
		print ("^5 " + string);
	else
		print ("^6 " + string);
}

battleChatter_println (string)
{
	if (!self battleChatter_canPrint())
		return;

	if (self.team == "allies")
		println ("^5 " + string);
	else
		println ("^6 " + string);
}

strfind (string, findString)
{
	for (i = 0; i < string.size; i++)
	{
		if (string[i] != findString[0])
			continue;
		
		if (findString.size > (string.size - i))
			return (false);
		
		for (p = 0; p < findString.size; p++)
		{
			if (string[i + p] != findString[p])
				break;
				
			if (p == (findString.size - 1))
				return (true);
		}
	}
}

threatTracker()
{
	while (1)
	{
		enemies = getaiarray ("axis");
		friends = getaiarray ("allies");

		shownEnemies = [];
		for (i = 0; i < enemies.size; i++)
		{
			if (!level.player pointInFov(enemies[i].origin))
				continue;
				
			if (distance (level.player.origin, enemies[i].origin) > 2048)
				continue;

			referenceName = "";
			reference = enemies[i] getLocation();
			if (!isdefined(reference))
			{
				reference = enemies[i] getLandMark();
				if (!isdefined (reference))
					continue;
					
				referenceName = reference.script_landmark;
			}
			else
			{
				referenceName = reference.script_location;
			}
				
			found = false;	
			for (j = 0; j < friends.size; j++)
			{
				if (isdefined (friends[j].enemy) && friends[j].enemy == enemies[i])
					found = true;
			}
			
			if (found)
				shownEnemies[shownEnemies.size] = "^2" + referenceName;
			else
				shownEnemies[shownEnemies.size] = "^1" + referenceName;
			
		}
		println("----------------------------");
		for (i = 0; i < shownEnemies.size; i++)
			println(shownEnemies[i]);
		wait (0.5);
	}
}


bcDrawObjects()
{
	for (i = 0; i < anim.areas.size; i++)
	{
		if (!isdefined (anim.areas[i].script_area))
			continue;

		thread drawBCObject("Area:     " + anim.areas[i].script_area, anim.areas[i] getOrigin(), (0,0,16), (1,1,1));
	}
	for (i = 0; i < anim.locations.size; i++)
	{
		if (!isdefined (anim.locations[i].script_location))
			continue;

		thread drawBCObject("Location: " + anim.locations[i].script_location, anim.locations[i] getOrigin(), (0,0,8), (1,1,1));
	}
	for (i = 0; i < anim.landmarks.size; i++)
	{
		if (!isdefined (anim.landmarks[i].script_landmark))
			continue;

		thread drawBCObject("Landmark: " + anim.landmarks[i].script_landmark, anim.landmarks[i] getOrigin(), (0,0,0), (1,1,1));
		thread drawBCDirections(anim.landmarks[i] getOrigin(), (0,0,8), (1,1,0));
	}
	
	nodes = getAllNodes();
	for (i = 0; i < nodes.size; i++)
	{
		if (!isdefined (nodes[i].script_location))
			continue;
		
		anim.moveOrigin.origin = nodes[i].origin;
		anim.moveOrigin.origin += (0,0,10);
		location = anim.moveOrigin getLocation();
		if (isdefined (location))
			thread drawBCObject(nodes[i].script_location + " @ " + location.script_location, nodes[i].origin, (0,0,0), (0,1,0));
			
		else
			thread drawBCObject(nodes[i].script_location + " @ undefined", nodes[i].origin, (0,0,0), (1,0,0));
	}				
	nodes = undefined;
}

drawBCObject ( string, origin, offset, color )
{
	while( true )
	{
		if ( distance( level.player.origin, origin) > 2048 )
		{
			wait ( 0.1 );
			continue;
		}
			
		print3d ( origin + offset, string, color, 1, 0.75);	// origin, text, RGB, alpha, scale
		wait 0.05;
	}	
}

drawBCDirections ( origin, offset, color )
{
	while( true )
	{
		if ( distance( level.player.origin, origin) > 2048 )
		{
			wait ( 0.1 );
			continue;
		}
		
		string = getDirectionCompass( level.player.origin, origin );

		print3d ( origin + offset, string, color, 1, 0.75);	// origin, text, RGB, alpha, scale
		wait 0.05;
	}	
}


resetNextSayTimes( team, action )
{
	soldiers = getAIArray( team );
	
	for ( index = 0; index < soldiers.size; index++ )
	{
		soldier = soldiers[index];
		
		if ( !isAlive( soldier ) )
			continue;
			
		if ( !isDefined( soldier.battlechatter ) )
			continue;
			 
		soldier.nextSayTimes[action] = getTime() + 350;
		soldier.squad.nextSayTimes[action] = getTime() + 350;
	}
}