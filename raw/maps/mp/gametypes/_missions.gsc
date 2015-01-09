#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	if ( !mayProcessChallenges() )
		return;
	
	level.missionCallbacks = [];

	precacheString(&"MP_CHALLENGE_COMPLETED");

	registerMissionCallback( "playerKilled", ::ch_kills );	
	registerMissionCallback( "playerKilled", ::ch_vehicle_kills );		
	registerMissionCallback( "playerHardpoint", ::ch_hardpoints );
	registerMissionCallback( "playerAssist", ::ch_assists );	
	registerMissionCallback( "roundEnd", ::ch_roundwin );
	registerMissionCallback( "roundEnd", ::ch_roundplayed );
	
	level thread onPlayerConnect();
}

mayProcessChallenges()
{
	/#
	if ( getDvarInt( "debug_challenges" ) )
		return true;
	#/
	
	return level.rankedMatch;
}

// Gives the result as an angle between - 180 and 180
AngleClamp180( angle )
{
	angleFrac = angle / 360.0;
	angle = ( angleFrac - floor( angleFrac ) ) * 360.0;
	if( angle > 180.0 )
		return angle - 360.0;
	return angle;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player thread initMissionData();
		player thread monitorBombUse();
		player thread monitorSprintDistance();
		player thread monitorFallDistance();
		player thread monitorLiveTime();	
		player thread monitorStreaks();
	}
}

// round based tracking
initMissionData()
{
	self.pers["radar_mp"] = 0;
	self.pers["airstrike_mp"] = 0;
	self.pers["helicopter_mp"] = 0;
	self.pers["lastBulletKillTime"] = 0;
	self.pers["bulletStreak"] = 0;
	self.explosiveInfo = [];
}

registerMissionCallback(callback, func)
{
	if (!isdefined(level.missionCallbacks[callback]))
		level.missionCallbacks[callback] = [];
	level.missionCallbacks[callback][level.missionCallbacks[callback].size] = func;
}


getChallengeStatus( name )
{
//	return self getStat( int(tableLookup( statsTable, 7, name, 2 )) ); // too slow, instead we store the challenge status at the beginning of the game
	if ( isDefined( self.challengeData[name] ) )
		return self.challengeData[name];
	else
		return 0;
}

getChallengeLevels( baseName )
{
	if ( isDefined( level.challengeInfo[baseName] ) )
		return level.challengeInfo[baseName]["levels"];
		
	assertex( isDefined( level.challengeInfo[baseName + "1" ] ), "Challenge name " + baseName + " not found!" );
	
	return level.challengeInfo[baseName + "1"]["levels"];
}

isStrStart( string1, subStr )
{
	return ( getSubStr( string1, 0, subStr.size ) == subStr );
}

processChallenge( baseName, progressInc )
{
	if ( !mayProcessChallenges() )
		return;
		
	numLevels = getChallengeLevels( baseName );
	
	if ( numLevels > 1 )
		missionStatus = self getChallengeStatus( (baseName + "1") );
	else
		missionStatus = self getChallengeStatus( baseName );

	if ( !isDefined( progressInc ) )
		progressInc = 1;
	
	/#
	if ( getDvarInt( "debug_challenges" ) )
		println( "CHALLENGE PROGRESS - " + baseName + ": " + progressInc );
	#/
	
	if ( !missionStatus || missionStatus == 255 )
		return;
		
	assertex( missionStatus <= numLevels, "Mini challenge levels higher than max: " + missionStatus + " vs. " + numLevels );
	
	if ( numLevels > 1 )
		refString = baseName + missionStatus;
	else
		refString = baseName;

	progress = self getStat( level.challengeInfo[refString]["statid"] );

	/*
	if ( isStrStart( refString, "ch_marksman_" ) || isStrStart( refString, "ch_expert_" ) )
		progressInc = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	*/

	progress += progressInc;
	
	self setStat( level.challengeInfo[refString]["statid"], progress );

	if ( progress >= level.challengeInfo[refString]["maxval"] )
	{
		self thread challengeNotify( level.challengeInfo[refString]["name"], level.challengeInfo[refString]["desc"] );

		if ( level.challengeInfo[refString]["camo"] != "" )
			self maps\mp\gametypes\_rank::unlockCamo( level.challengeInfo[refString]["camo"] );

		if ( level.challengeInfo[refString]["attachment"] != "" )
			self maps\mp\gametypes\_rank::unlockAttachment( level.challengeInfo[refString]["attachment"] );

		if ( missionStatus == numLevels )
			missionStatus = 255;
		else
			missionStatus += 1;

		if ( numLevels > 1 )
			self.challengeData[baseName + "1"] = missionStatus;
		else
			self.challengeData[baseName] = missionStatus;

		// prevent bars from running over
		self setStat( level.challengeInfo[refString]["statid"], level.challengeInfo[refString]["maxval"] );

		self setStat( level.challengeInfo[refString]["stateid"], missionStatus );
		self maps\mp\gametypes\_rank::giveRankXP( "challenge", level.challengeInfo[refString]["reward"] );
		
		if ( level.challengeInfo[refString]["tier"] < 6 && missionStatus == 255 )
		{
			if ( tierCheck( level.challengeInfo[refString]["tier"] ) )
			{
				// unlock golden weapon for tier
				switch ( level.challengeInfo[refString]["tier"] )
				{
					case 1:
						maps\mp\gametypes\_rank::unlockCamo( "ak47 camo_gold" );
						break;
					case 2:
						maps\mp\gametypes\_rank::unlockCamo( "uzi camo_gold" );
						break;
					case 3:
						maps\mp\gametypes\_rank::unlockCamo( "m60e4 camo_gold" );
						break;
					case 4:
						maps\mp\gametypes\_rank::unlockCamo( "m1014 camo_gold" );
						break;
					case 5:
						maps\mp\gametypes\_rank::unlockCamo( "dragunov camo_gold" );
						break;
				}
			}
		}
	}
}


// check if all challenges in a tier are completed
tierCheck( tierID )
{
	challengeNames = getArrayKeys( level.challengeInfo );
	for ( index = 0; index < challengeNames.size; index++ )
	{
		challengeInfo = level.challengeInfo[challengeNames[index]];

		if ( challengeInfo["tier"] != tierID )
			continue;
			
		// multi level
		if ( challengeInfo["level"] > 1 )
			continue;
		
		// undefined means it's locked
		if ( !isDefined( self.challengeData[challengeNames[index]] ) )
			return false;
		
		// 255 means it's not completed
		if ( self.challengeData[challengeNames[index]] != 255 )
			return false;
	}

	return true;
}

challengeNotify( challengeName, challengeDesc )
{
	notifyData = spawnStruct();
	notifyData.titleText = &"MP_CHALLENGE_COMPLETED";
	notifyData.notifyText = challengeName;
//	notifyData.notifyText2 = challengeDesc;
	notifyData.sound = "mp_challenge_complete";
	
	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}


ch_assists( data )
{
	player = data.player;
	player processChallenge( "ch_assists_" );
}


ch_hardpoints( data )
{
	player = data.player;
	player.pers[data.hardpointType]++;

	if ( data.hardpointType == "radar_mp" )
	{
		player processChallenge( "ch_uav" );
		player processChallenge( "ch_exposed_" );

		if ( player.pers[data.hardpointType] >= 3 )
			player processChallenge( "ch_nosecrets" );
	}
	else if ( data.hardpointType == "airstrike_mp" )
	{
		player processChallenge( "ch_airstrike" );

		if ( player.pers[data.hardpointType] >= 2 )
			player processChallenge( "ch_afterburner" );
	}
	else if ( data.hardpointType == "helicopter_mp" )	
	{
		player processChallenge( "ch_chopper" );

		if ( player.pers[data.hardpointType] >= 2 )
			player processChallenge( "ch_airsuperiority" );
	}
}


ch_vehicle_kills( data )
{
	if ( !isDefined( data.attacker ) || !isPlayer( data.attacker ) )
		return;

	player = data.attacker;

	if ( isDefined( data.eInflictor ) && isDefined( level.chopper ) && data.eInflictor == level.chopper )
	{
		player processChallenge( "ch_choppervet_" );
	}
	// this isdefined check should not be needed... find out where these mystery explosions are coming from
	else if ( isDefined( data.sWeapon ) && data.sWeapon == "artillery_mp" )
	{
		player processChallenge( "ch_airstrikevet_" );
		
		player.pers["airstrikeStreak"]++;
		if ( player.pers["airstrikeStreak"] >= 5 )
			player processChallenge( "ch_carpetbomb" );
	}
}	


clearIDShortly( expId )
{
	self endon ( "disconnect" );
	
	self notify( "clearing_expID_" + expID );
	self endon ( "clearing_expID_" + expID );
	
	wait ( 3.0 );
	self.explosiveKills[expId] = undefined;
}

MGKill()
{
	player = self;
	if ( !isDefined( player.pers["MGStreak"] ) )
	{
		player.pers["MGStreak"] = 0;
		player thread endMGStreakWhenLeaveMG();
		if ( !isDefined( player.pers["MGStreak"] ) )
			return;
	}
	player.pers["MGStreak"]++;
	//iprintln( player.pers["MGStreak"] );
	if ( player.pers["MGStreak"] >= 5 )
		player processChallenge( "ch_mgmaster" );
}

endMGStreakWhenLeaveMG()
{
	self endon("disconnect");
	while(1)
	{
		if ( !isAlive( self ) || self useButtonPressed() )
		{
			self.pers["MGStreak"] = undefined;
			//iprintln("0");
			break;
		}
		wait .05;
	}
}

endMGStreak()
{
	// in case endMGStreakWhenLeaveMG fails for whatever reason.
	self.pers["MGStreak"] = undefined;
	//iprintln("0");
}

killedBestEnemyPlayer()
{
	if ( !isdefined( self.pers["countermvp_streak"] ) )
		self.pers["countermvp_streak"] = 0;
	
	self.pers["countermvp_streak"]++;
	
	if ( self.pers["countermvp_streak"] >= 10 )
		self processChallenge( "ch_countermvp" );
}


isHighestScoringPlayer( player )
{
	if ( !isDefined( player.score ) || player.score < 1 )
		return false;

	players = level.players;
	if ( level.teamBased )
		team = player.pers["team"];
	else
		team = "all";

	highScore = player.score;

	for( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i].score ) )
			continue;
			
		if ( players[i].score < 1 )
			continue;

		if ( team != "all" && players[i].pers["team"] != team )
			continue;
		
		if ( players[i].score > highScore )
			return false;
	}
	
	return true;
}


getWeaponClass( weapon )
{
	tokens = strTok( weapon, "_" );
	weaponClass = tablelookup( "mp/statstable.csv", 4, tokens[0], 2 );
	if ( isMG( weapon ) )
		weaponClass = "weapon_mg";
	return weaponClass;
}

ch_kills( data, time )
{
	data.victim playerDied();
	
	if ( !isDefined( data.attacker ) || !isPlayer( data.attacker ) )
		return;
	
	player = data.attacker;
	
	if ( isDefined( data.eInflictor ) && isDefined( level.chopper ) && data.eInflictor == level.chopper )
		return;
	if ( data.sWeapon == "artillery_mp" )
		return;
	
	time = data.time;
	
	if ( player isAtBrinkOfDeath() )
	{
		player.brinkOfDeathKillStreak++;
		if ( player.brinkOfDeathKillStreak >= 3 )
		{
			player processChallenge( "ch_thebrink" );
		}
	}

	if ( player.cur_kill_streak == 10 )
		player processChallenge( "ch_fearless" );

	if ( level.teamBased )
	{
		if ( level.playerCount[data.victim.pers["team"]] > 3 && player.killedPlayers.size >= level.playerCount[data.victim.pers["team"]] )
			player processChallenge( "ch_tangodown" );
	
		if ( level.playerCount[data.victim.pers["team"]] > 3 && player.killedPlayersCurrent.size >= level.playerCount[data.victim.pers["team"]] )
			player processChallenge( "ch_extremecruelty" );
	}

	if ( player.killedPlayers[""+data.victim.clientid] == 10 )
		player processChallenge( "ch_rival" );

	if ( isdefined( player.tookWeaponFrom[ data.sWeapon ] ) )
	{
		if ( player.tookWeaponFrom[ data.sWeapon ] == data.victim && data.sMeansOfDeath != "MOD_MELEE" )
			player processChallenge( "ch_cruelty" );
	}
	
	if ( data.victim.score > 0 )
	{
		if ( level.teambased )
		{
			victimteam = data.victim.pers["team"];
			if ( isdefined( victimteam ) && victimteam != player.pers["team"] )
			{
				if ( isHighestScoringPlayer( data.victim ) && level.players.size >= 6 )
					player killedBestEnemyPlayer();
			}
		}
		else
		{
			if ( isHighestScoringPlayer( data.victim ) && level.players.size >= 4 )
			{
				player killedBestEnemyPlayer();
			}
		}
	}
	
	if ( data.sMeansOfDeath == "MOD_PISTOL_BULLET" || data.sMeansOfDeath == "MOD_RIFLE_BULLET" )
	{
		weaponClass = getWeaponClass( data.sWeapon );
		ch_bulletDamageCommon( data, player, time, weaponClass );
		
		if ( isMG( data.sWeapon ) )
			player MGKill();
		else if ( isStrStart( data.sWeapon, "mp5_" ) )
			player processChallenge( "ch_marksman_mp5_" );
		else if ( isStrStart( data.sWeapon, "m16_" ) )
			player processChallenge( "ch_marksman_m16_" );
		else if ( isStrStart( data.sWeapon, "skorpion_" ) )
			player processChallenge( "ch_marksman_skorpion_" );
		else if ( isStrStart( data.sWeapon, "dragunov_" ) )
			player processChallenge( "ch_marksman_dragunov" );
		else if ( isStrStart( data.sWeapon, "m4_" ) )
			player processChallenge( "ch_marksman_m4_" );
		else if ( isStrStart( data.sWeapon, "rpd_" ) )
			player processChallenge( "ch_marksman_rpd_" );
		else if ( isStrStart( data.sWeapon, "winchester1200_" ) )
			player processChallenge( "ch_marksman_winchester1200_" );
		else if ( isStrStart( data.sWeapon, "barrett_" ) )
			player processChallenge( "ch_marksman_barrett" );
		else if ( isStrStart( data.sWeapon, "g36c_" ) )
			player processChallenge( "ch_marksman_g36c_" );
		else if ( isStrStart( data.sWeapon, "p90_" ) )
			player processChallenge( "ch_marksman_p90_" );
		else if ( isStrStart( data.sWeapon, "m60e4_" ) )
			player processChallenge( "ch_marksman_m60e4_" );
		else if ( isStrStart( data.sWeapon, "g3_" ) )
			player processChallenge( "ch_marksman_g3_" );
		else if ( isStrStart( data.sWeapon, "remington700_" ) )
			player processChallenge( "ch_marksman_remington700" );
		else if ( isStrStart( data.sWeapon, "uzi_" ) )
			player processChallenge( "ch_marksman_uzi_" );
		else if ( isStrStart( data.sWeapon, "m1014_" ) )
			player processChallenge( "ch_marksman_m1014_" );
		else if ( isStrStart( data.sWeapon, "m14_" ) )
			player processChallenge( "ch_marksman_m14_" );
		else if ( isStrStart( data.sWeapon, "ak47_" ) )
			player processChallenge( "ch_marksman_ak47_" );
		else if ( isStrStart( data.sWeapon, "ak74u_" ) )
			player processChallenge( "ch_marksman_ak74u_" );
		else if ( isStrStart( data.sWeapon, "saw_" ) )
			player processChallenge( "ch_marksman_saw_" );
		else if ( isStrStart( data.sWeapon, "m21_" ) )
			player processChallenge( "ch_marksman_m21" );
		else if ( isStrStart( data.sWeapon, "m40a3_" ) )
			player processChallenge( "ch_marksman_m40a3" );
	}
	else if ( isSubStr( data.sMeansOfDeath, "MOD_GRENADE" ) || isSubStr( data.sMeansOfDeath, "MOD_EXPLOSIVE" ) || isSubStr( data.sMeansOfDeath, "MOD_PROJECTILE" ) )
	{
		if ( isStrStart( data.sWeapon, "frag_grenade_short_" ) )
			player processChallenge( "ch_martyrdomvet_" );
		
		// this isdefined check should not be needed... find out where these mystery explosions are coming from
		if ( isDefined( data.victim.explosiveInfo["damageTime"] ) && data.victim.explosiveInfo["damageTime"] == time )
		{
			if ( data.sWeapon == "none" )
				data.sWeapon = data.victim.explosiveInfo["weapon"];
			
			expId = time + "_" + data.victim.explosiveInfo["damageId"];
			if ( !isDefined( player.explosiveKills[expId] ) )
			{
				player.explosiveKills[expId] = 0;
			}
			player thread clearIDShortly( expId );
			
			player.explosiveKills[expId]++;
			
			if ( isStrStart( data.sWeapon, "frag_" ) )
			{
				if ( player.explosiveKills[expId] > 1 )
					player processChallenge( "ch_multifrag" );
				
				player processChallenge( "ch_grenadekill_" );
				
				if ( data.victim.explosiveInfo["cookedKill"] )
					player processChallenge( "ch_masterchef_" );
				
				if ( data.victim.explosiveInfo["suicideGrenadeKill"] )
					player processChallenge( "ch_miserylovescompany_" );
				
				if ( data.victim.explosiveInfo["throwbackKill"] )
					player processChallenge( "ch_hotpotato_" );
			}
			else if ( isStrStart( data.sWeapon, "c4_" ) )
			{
				if ( player.explosiveKills[expId] > 1 )
					player processChallenge( "ch_multic4" );

				if ( data.victim.explosiveInfo["returnToSender"] )
					player processChallenge( "ch_returntosender" );				
				
				if ( data.victim.explosiveInfo["counterKill"] )
					player processChallenge( "ch_counterc4_" );
				
				if ( data.victim.explosiveInfo["bulletPenetrationKill"] )
					player processChallenge( "ch_howthe" );

				if ( data.victim.explosiveInfo["chainKill"] )
					player processChallenge( "ch_dominos" );
			}
			else if ( isStrStart( data.sWeapon, "claymore_" ) )
			{
				player processChallenge( "ch_claymoreshot" );

				if ( player.explosiveKills[expId] > 1 )
					player processChallenge( "ch_multiclaymore" );

				if ( data.victim.explosiveInfo["returnToSender"] )
					player processChallenge( "ch_returntosender" );				

				if ( data.victim.explosiveInfo["counterKill"] )
					player processChallenge( "ch_counterclaymore_" );
				
				if ( data.victim.explosiveInfo["bulletPenetrationKill"] )
					player processChallenge( "ch_howthe" );

				if ( data.victim.explosiveInfo["chainKill"] )
					player processChallenge( "ch_dominos" );
			}
			else if ( data.sWeapon == "explodable_barrel" )
			{
				//player processChallenge( "ch_redbarrelsurprise" );
			}
			else if ( data.sWeapon == "destructible_car" )
			{
				player processChallenge( "ch_carbomb" );
			}
			else if ( isStrStart( data.sWeapon, "rpg_" ) )
			{
				if ( player.explosiveKills[expId] > 1 )
					player processChallenge( "ch_multirpg" );
			}
		}
	}
	else if ( isSubStr( data.sMeansOfDeath,	"MOD_MELEE" ) )
	{
		player endMGStreak();
		
		player processChallenge( "ch_knifevet_" );
		player.pers["meleeKillStreak"]++;

		if ( player.pers["meleeKillStreak"] == 3 )
			player processChallenge( "ch_slasher" );
		
		vAngles = data.victim.anglesOnDeath[1];
		pAngles = player.anglesOnKill[1];
		angleDiff = AngleClamp180( vAngles - pAngles );
		if ( abs(angleDiff) < 30 )
			player processChallenge( "ch_backstabber" );
	}
	else if ( isSubStr( data.sMeansOfDeath,	"MOD_IMPACT" ) )
	{
		if ( isStrStart( data.sWeapon, "frag_" ) )
			player processChallenge( "ch_thinkfast" );
		else if ( isStrStart( data.sWeapon, "concussion_" ) )
			player processChallenge( "ch_thinkfastconcussion" );
		else if ( isStrStart( data.sWeapon, "flash_" ) )
			player processChallenge( "ch_thinkfastflash" );
		else if ( isStrStart( data.sWeapon, "gl_" ) )
			player processChallenge( "ch_ouch_" );
	}
	else if ( data.sMeansOfDeath == "MOD_HEAD_SHOT" )
	{
		weaponClass = getWeaponClass( data.sWeapon );
		
		ch_bulletDamageCommon( data, player, time, weaponClass );
	
		switch ( weaponClass )
		{
			case "weapon_smg":
				player processChallenge( "ch_expert_smg_" );
				break;
			case "weapon_lmg":
				player processChallenge( "ch_expert_lmg_" );
				break;
			case "weapon_assault":
				player processChallenge( "ch_expert_assault_" );
				break;
		}

		if ( isMG( data.sWeapon ) )
		{
			player MGKill();
		}
		else if ( isStrStart( data.sWeapon, "mp5_" ) )
		{
			player processChallenge( "ch_expert_mp5_" );
			player processChallenge( "ch_marksman_mp5_" );
		}
		else if ( isStrStart( data.sWeapon, "m16_" ) )
		{
			player processChallenge( "ch_expert_m16_" );
			player processChallenge( "ch_marksman_m16_" );
		}
		else if ( isStrStart( data.sWeapon, "skorpion_" ) )
		{
			player processChallenge( "ch_expert_skorpion_" );
			player processChallenge( "ch_marksman_skorpion_" );
		}
		else if ( isStrStart( data.sWeapon, "dragunov_" ) )
		{
			player processChallenge( "ch_expert_dragunov_" );
			player processChallenge( "ch_marksman_dragunov" );
		}
		else if ( isStrStart( data.sWeapon, "m4_" ) )
		{
			player processChallenge( "ch_expert_m4_" );
			player processChallenge( "ch_marksman_m4_" );
		}
		else if ( isStrStart( data.sWeapon, "rpd_" ) )
		{
			player processChallenge( "ch_expert_rpd_" );
			player processChallenge( "ch_marksman_rpd_" );
		}
		else if ( isStrStart( data.sWeapon, "winchester1200_" ) )
		{
			player processChallenge( "ch_expert_winchester1200_" );
			player processChallenge( "ch_marksman_winchester1200_" );
		}
		else if ( isStrStart( data.sWeapon, "barrett_" ) )
		{
			player processChallenge( "ch_expert_barrett_" );
			player processChallenge( "ch_marksman_barrett" );
		}
		else if ( isStrStart( data.sWeapon, "mp44_" ) )
		{
			player processChallenge( "ch_expert_mp44_" );
		}
		else if ( isStrStart( data.sWeapon, "g36c_" ) )
		{
			player processChallenge( "ch_expert_g36c_" );
			player processChallenge( "ch_marksman_g36c_" );
		}
		else if ( isStrStart( data.sWeapon, "p90_" ) )
		{
			player processChallenge( "ch_expert_p90_" );
			player processChallenge( "ch_marksman_p90_" );
		}
		else if ( isStrStart( data.sWeapon, "m60e4_" ) )
		{
			player processChallenge( "ch_expert_m60e4_" );
			player processChallenge( "ch_marksman_m60e4_" );
		}
		else if ( isStrStart( data.sWeapon, "g3_" ) )
		{
			player processChallenge( "ch_expert_g3_" );
			player processChallenge( "ch_marksman_g3_" );
		}
		else if ( isStrStart( data.sWeapon, "remington700_" ) )
		{
			player processChallenge( "ch_expert_remington700_" );
			player processChallenge( "ch_marksman_remington700" );
		}
		else if ( isStrStart( data.sWeapon, "uzi_" ) )
		{
			player processChallenge( "ch_expert_uzi_" );
			player processChallenge( "ch_marksman_uzi_" );
		}
		else if ( isStrStart( data.sWeapon, "m1014_" ) )
		{
			player processChallenge( "ch_expert_m1014_" );
			player processChallenge( "ch_marksman_m1014_" );
		}
		else if ( isStrStart( data.sWeapon, "m14_" ) )
		{
			player processChallenge( "ch_expert_m14_" );
			player processChallenge( "ch_marksman_m14_" );
		}
		else if ( isStrStart( data.sWeapon, "ak47_" ) )
		{
			player processChallenge( "ch_expert_ak47_" );
			player processChallenge( "ch_marksman_ak47_" );
		}
		else if ( isStrStart( data.sWeapon, "ak74u_" ) )
		{
			player processChallenge( "ch_expert_ak74u_" );
			player processChallenge( "ch_marksman_ak74u_" );
		}
		else if ( isStrStart( data.sWeapon, "saw_" ) )
		{
			player processChallenge( "ch_expert_saw_" );
			player processChallenge( "ch_marksman_saw_" );
		}
		else if ( isStrStart( data.sWeapon, "m21_" ) )
		{
			player processChallenge( "ch_expert_m21_" );
			player processChallenge( "ch_marksman_m21" );
		}
		else if ( isStrStart( data.sWeapon, "m40a3_" ) )
		{
			player processChallenge( "ch_expert_m40a3_" );
			player processChallenge( "ch_marksman_m40a3" );
		}
		else if ( isStrStart( data.sWeapon, "frag_" ) )
		{
			player processChallenge( "ch_thinkfast" );
		}
		else if ( isStrStart( data.sWeapon, "concussion_" ) )
		{
			player processChallenge( "ch_thinkfastconcussion" );
		}
		else if ( isStrStart( data.sWeapon, "flash_" ) )
		{
			player processChallenge( "ch_thinkfastflash" );
		}
	}
	
	if ( isDefined( data.victim.isPlanting ) && data.victim.isPlanting )
		player processChallenge( "ch_bombplanter" );		

	if ( isDefined( data.victim.isDefusing ) && data.victim.isDefusing )
		player processChallenge( "ch_bombdefender" );

	if ( isDefined( data.victim.isBombCarrier ) && data.victim.isBombCarrier )
		player processChallenge( "ch_bombdown" );
}

ch_bulletDamageCommon( data, player, time, weaponClass )
{
	if ( !isMG( data.sWeapon ) )
		player endMGStreak();
	
	if ( player.pers["lastBulletKillTime"] == time )
		player.pers["bulletStreak"]++;
	else
		player.pers["bulletStreak"] = 1;
	
	player.pers["lastBulletKillTime"] = time;

	if ( !data.victimOnGround )
		player processChallenge( "ch_hardlanding" );
	
	assert( data.attacker == player );
	if ( !data.attackerOnGround )
		player.pers["midairStreak"]++;
	
	if ( player.pers["midairStreak"] == 2 )
		player processChallenge( "ch_airborne" );
	
	
	if ( time < data.victim.flashEndTime )
		player processChallenge( "ch_flashbangvet_" );
	
	if ( time < player.flashEndTime )
		player processChallenge( "ch_blindfire" );
	
	if ( time < data.victim.concussionEndTime )
		player processChallenge( "ch_concussionvet_" );
	
	if ( time < player.concussionEndTime )
		player processChallenge( "ch_slowbutsure" );
	
	
	if ( player.pers["bulletStreak"] == 2 && weaponClass == "weapon_sniper" )
		player processChallenge( "ch_collateraldamage" );
	
	if ( weaponClass == "weapon_pistol" )
	{
		if ( isdefined( data.victim.attackerData ) && isdefined( data.victim.attackerData[player.clientid] ) )
		{
			if ( data.victim.attackerData[player.clientid] )
				player processChallenge( "ch_fastswap" );
		}
	}
	
	if ( data.victim.iDFlagsTime == time )
	{
		if ( data.victim.iDFlags & level.iDFLAGS_PENETRATION )
			player processChallenge( "ch_xrayvision_" ); 
	}
	
	if ( data.attackerInLastStand )
	{
		player processChallenge( "ch_laststandvet_" );
	}
	else if ( data.attackerStance == "crouch" )
	{
		player processChallenge( "ch_crouchshot_" );
	}
	else if ( data.attackerStance == "prone" )
	{
		player processChallenge( "ch_proneshot_" );
		if ( weaponClass == "weapon_sniper" )
			player processChallenge( "ch_invisible_" );
	}
	
	if ( isSubStr( data.sWeapon, "_silencer_" ) )
		player processChallenge( "ch_stealth_" ); 
}

ch_roundplayed( data )
{
	player = data.player;
	
	if ( isdefined( level.lastLegitimateAttacker ) && player == level.lastLegitimateAttacker )
		player processChallenge( "ch_theedge_" );
	
	if ( player.wasAliveAtMatchStart )
	{
		deaths = player.pers[ "deaths" ];
		kills = player.pers[ "kills" ];

		kdratio = 1000000;
		if ( deaths > 0 )
			kdratio = kills / deaths;
		
		if ( kdratio >= 5.0 && kills >= 5.0 )
		{
			player processChallenge( "ch_starplayer" );
		}
		
		if ( deaths == 0 && maps\mp\gametypes\_globallogic::getTimePassed() > 5 * 60 * 1000 )
			player processChallenge( "ch_flawless" );
		
		
		if ( player.score > 0 )
		{
			switch ( level.gameType )
			{
				case "dm":
					if ( data.place < 4 && level.placement["all"].size > 3 )
						player processChallenge( "ch_victor_dm_" );
					break;
			}
		}
	}
}


ch_roundwin( data )
{
	if ( !data.winner )
		return;
		
	player = data.player;
	if ( player.wasAliveAtMatchStart )
	{
		switch ( level.gameType )
		{
			case "war":
				if ( level.hardcoreMode )
				{
					player processChallenge( "ch_teamplayer_hc_" );
					if ( data.place == 0 )
						player processChallenge( "ch_mvp_thc" );
				}
				else
				{
					player processChallenge( "ch_teamplayer_" );
					if ( data.place == 0 )
						player processChallenge( "ch_mvp_tdm" );
				}
				break;
			case "sab":
				player processChallenge( "ch_victor_sab_" );
				break;
			case "sd":
				player processChallenge( "ch_victor_sd_" );
				break;
			case "ctf":
			case "dom":
			case "dm":
			case "hc":
			case "koth":
				break;
			default:
				break;
		}
	}
}

/*
char *modNames[MOD_NUM] =
{
	"MOD_UNKNOWN",
	"MOD_PISTOL_BULLET",
	"MOD_RIFLE_BULLET",
	"MOD_GRENADE",
	"MOD_GRENADE_SPLASH",
	"MOD_PROJECTILE",
	"MOD_PROJECTILE_SPLASH",
	"MOD_MELEE",
	"MOD_HEAD_SHOT",
	"MOD_CRUSH",
	"MOD_TELEFRAG",
	"MOD_FALLING",
	"MOD_SUICIDE",
	"MOD_TRIGGER_HURT",
	"MOD_EXPLOSIVE",
	"MOD_IMPACT",
};

static const char *g_HitLocNames[] =
{
	"none",
	"helmet",
	"head",
	"neck",
	"torso_upper",
	"torso_lower",
	"right_arm_upper",
	"left_arm_upper",
	"right_arm_lower",
	"left_arm_lower",
	"right_hand",
	"left_hand",
	"right_leg_upper",
	"left_leg_upper",
	"right_leg_lower",
	"left_leg_lower",
	"right_foot",
	"left_foot",
	"gun",
};

*/

// ==========================================
// Callback functions

playerDamaged( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	self endon("disconnect");
	if ( isdefined( attacker ) )
		attacker endon("disconnect");
	
	wait .05;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();

	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;
	
	data.victimOnGround = data.victim isOnGround();
	
	if ( isPlayer( attacker ) )
	{
		data.attackerInLastStand = isDefined( data.attacker.lastStand );
		data.attackerOnGround = data.attacker isOnGround();
		data.attackerStance = data.attacker getStance();
	}
	else
	{
		data.attackerInLastStand = false;
		data.attackerOnGround = false;
		data.attackerStance = "stand";
	}
	
	doMissionCallback("playerDamaged", data);
}

playerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc )
{
	self.anglesOnDeath = self getPlayerAngles();
	if ( isdefined( attacker ) )
		attacker.anglesOnKill = attacker getPlayerAngles();
	
	self endon("disconnect");

	data = spawnstruct();

	data.victim = self;
	data.eInflictor = eInflictor;
	data.attacker = attacker;
	data.iDamage = iDamage;
	data.sMeansOfDeath = sMeansOfDeath;
	data.sWeapon = sWeapon;
	data.sHitLoc = sHitLoc;
	data.time = gettime();
	
	data.victimOnGround = data.victim isOnGround();
	
	if ( isPlayer( attacker ) )
	{
		data.attackerInLastStand = isDefined( data.attacker.lastStand );
		data.attackerOnGround = data.attacker isOnGround();
		data.attackerStance = data.attacker getStance();
	}
	else
	{
		data.attackerInLastStand = false;
		data.attackerOnGround = false;
		data.attackerStance = "stand";
	}
	
	waitAndProcessPlayerKilledCallback( data );
	
	data.attacker notify( "playerKilledChallengesProcessed" );
}

waitAndProcessPlayerKilledCallback( data )
{
	if ( isdefined( data.attacker ) )
		data.attacker endon("disconnect");
	
	wait .05;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();
	
	doMissionCallback( "playerKilled", data );
}

playerAssist()
{
	data = spawnstruct();

	data.player = self;

	doMissionCallback( "playerAssist", data );
}


useHardpoint( hardpointType )
{
	wait .05;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();

	data = spawnstruct();

	data.player = self;
	data.hardpointType = hardpointType;

	doMissionCallback( "playerHardpoint", data );
}


roundBegin()
{
	doMissionCallback( "roundBegin" );
}

roundEnd( winner )
{
	data = spawnstruct();
	
	if ( level.teamBased )
	{
		team = "allies";
		for ( index = 0; index < level.placement[team].size; index++ )
		{
			data.player = level.placement[team][index];
			data.winner = (team == winner);
			data.place = index;

			doMissionCallback( "roundEnd", data );
		}
		team = "axis";
		for ( index = 0; index < level.placement[team].size; index++ )
		{
			data.player = level.placement[team][index];
			data.winner = (team == winner);
			data.place = index;

			doMissionCallback( "roundEnd", data );
		}
	}
	else
	{
		for ( index = 0; index < level.placement["all"].size; index++ )
		{
			data.player = level.placement["all"][index];
			data.winner = (isdefined( winner) && (data.player == winner));
			data.place = index;

			doMissionCallback( "roundEnd", data );
		}		
	}
}

doMissionCallback( callback, data )
{
	if ( !mayProcessChallenges() )
		return;
	
	if ( !isDefined( level.missionCallbacks[callback] ) )
		return;
	
	if ( isDefined( data ) ) 
	{
		for ( i = 0; i < level.missionCallbacks[callback].size; i++ )
			thread [[level.missionCallbacks[callback][i]]]( data );
	}
	else 
	{
		for ( i = 0; i < level.missionCallbacks[callback].size; i++ )
			thread [[level.missionCallbacks[callback][i]]]();
	}
}


monitorSprintDistance()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("sprint_begin");
		
		self.sprintDistThisSprint = 0;
		self monitorSingleSprintDistance();
		
		self processChallenge( "ch_marathon", int(self.sprintDistThisSprint) );
	}
}

monitorSingleSprintDistance()
{
	self endon("disconnect");
	self endon("death");
	self endon("sprint_end");
	
	prevpos = self.origin;
	while(1)
	{
		wait .1;

		self.sprintDistThisSprint += distance( self.origin, prevpos );
		prevpos = self.origin;
	}
}

monitorFallDistance()
{
	self endon("disconnect");

	self.pers["midairStreak"] = 0;
	
	while(1)
	{
		if ( !isAlive( self ) )
		{
			self waittill("spawned_player");
			continue;
		}
		
		if ( !self isOnGround() )
		{
			self.pers["midairStreak"] = 0;
			highestPoint = self.origin[2];
			while( !self isOnGround() )
			{
				if ( self.origin[2] > highestPoint )
					highestPoint = self.origin[2];
				wait .05;
			}
			self.pers["midairStreak"] = 0;

			falldist = highestPoint - self.origin[2];
			if ( falldist < 0 )
				falldist = 0;
			
			if ( falldist / 12.0 > 15 && isAlive( self ) )
				self processChallenge( "ch_basejump" );

			if ( falldist / 12.0 > 30 && !isAlive( self ) )
				self processChallenge( "ch_goodbye" );
			
			//println( "You fell ", falldist / 12.0, " feet");
		}
		wait .05;
	}
}

lastManSD()
{
	if ( !mayProcessChallenges() )
		return;

	if ( !self.wasAliveAtMatchStart )
		return;
	
	if ( self.teamkillsThisRound > 0 )
		return;
	
	self processChallenge( "ch_lastmanstanding" );
}

monitorBombUse()
{
	self endon("disconnect");
	
	while(1)
	{
		result = self waittill_any_return( "bomb_planted", "bomb_defused" );
		
		if ( !isDefined( result ) )
			continue;
			
		if ( result == "bomb_planted" )
		{
		}
		else if ( result == "bomb_defused" )
			self processChallenge( "ch_hero" );
	}
}


monitorLiveTime()
{
	for ( ;; )
	{
		self waittill ( "spawned_player" );
		
		self thread survivalistChallenge();
	}
}

survivalistChallenge()
{
	self endon("death");
	self endon("disconnect");
	
	wait 5 * 60;
	
	self processChallenge( "ch_survivalist" );
}


monitorStreaks()
{
	self endon ( "disconnect" );

	self.pers["airstrikeStreak"] = 0;
	self.pers["meleeKillStreak"] = 0;

	self thread monitorMisc();

	for ( ;; )
	{
		self waittill ( "death" );
		
		self.pers["meleeKillStreak"] = 0;
	}
}


monitorMisc()
{
	self thread monitorMiscSingle( "destroyed_explosive" );
	self thread monitorMiscSingle( "begin_airstrike" );
	self thread monitorMiscSingle( "destroyed_car" );
	self thread monitorMiscSingle( "destroyed_helicopter" );
	
	self waittill("disconnect");
	
	// make sure the threads end when we disconnect.
	// (this allows one disconnect waittill instead of 4 disconnect endons)
	self notify( "destroyed_explosive" );
	self notify( "begin_airstrike" );
	self notify( "destroyed_car" );
	self notify( "destroyed_helicopter" );
}

monitorMiscSingle( waittillString )
{
	// don't need to endon disconnect because we will get the notify we're waiting for when we disconnect.
	// avoiding the endon disconnect saves a lot of script variables (5 * 4 threads * 64 players = 1280)
	
	while(1)
	{
		self waittill( waittillString );
		
		if ( !isDefined( self ) )
			return;
		
		monitorMiscCallback( waittillString );
	}
}

monitorMiscCallback( result )
{
	assert( isDefined( result ) );
	switch( result )
	{
		case "begin_airstrike":
			self.pers["airstrikeStreak"] = 0;
		break;

		case "destroyed_explosive":
			self processChallenge( "ch_backdraft_" );
		break;

		case "destroyed_helicopter":
			self processChallenge( "ch_flyswatter" );
		break;

		case "destroyed_car":
			self processChallenge( "ch_vandalism_" );
		break;
	}
}


healthRegenerated()
{
	if ( !isalive( self ) )
		return;
	
	if ( !mayProcessChallenges() )
		return;
	
	self thread resetBrinkOfDeathKillStreakShortly();
	
	if ( isdefined( self.lastDamageWasFromEnemy ) && self.lastDamageWasFromEnemy )
	{
		// TODO: this isn't always getting incremented when i regen
		self.healthRegenerationStreak++;
		if ( self.healthRegenerationStreak >= 5 )
		{
			self processChallenge( "ch_invincible" );
		}
	}
}

resetBrinkOfDeathKillStreakShortly()
{
	self endon("disconnect");
	self endon("death");
	self endon("damage");
	
	wait 1;
	
	self.brinkOfDeathKillStreak = 0;
}

playerSpawned()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.pers["MGStreak"] = 0;
}

playerDied()
{
	self.brinkOfDeathKillStreak = 0;
	self.healthRegenerationStreak = 0;
	self.pers["MGStreak"] = 0;
}

isAtBrinkOfDeath()
{
	ratio = self.health / self.maxHealth;
	return (ratio <= level.healthOverlayCutoff);
}

