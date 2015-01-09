#include maps\_utility;
#include common_scripts\utility;

main()
{
	missionSettings = [];

	// levels and missions are listed in order 
	missionIndex = 0; // only one missionindex( vignettes in CoD2, no longer exist but I'm going to use this script anyway because it's got good stuff in it. - Nate

	missionSettings = createMission( "WAR_HARDENED" );
	missionSettings addLevel( "killhouse", false, "EARN_A_WINGED_DAGGER", true );
	missionSettings addLevel( "cargoship", false, "MAKE_THE_JUMP", true, "THE_PACKAGE" );
	missionSettings addLevel( "coup", false, undefined, true );
	missionSettings addLevel( "blackout", false, "COMPLETE_BLACKOUT", true, "THE_RESCUE" );
	missionSettings addLevel( "armada", false, undefined, true, "THE_SEARCH" );
	missionSettings addLevel( "bog_a", false, "SAVE_THE_BACON", true, "THE_BOG" );
	missionSettings addLevel( "hunted", false, undefined, true, "THE_ESCAPE" );
	missionSettings addLevel( "ac130", false, "BRING_EM_HOME", true, "THE_ESCAPE" );
	missionSettings addLevel( "bog_b", false, undefined, true, "THE_BOG" );
	missionSettings addLevel( "airlift", false, undefined, true, "THE_FIRST_HORSEMAN" );
	missionSettings addLevel( "aftermath", false, undefined, true );
	missionSettings addLevel( "village_assault", false, "COMPLETE_VILLAGE_ASSAULT", true, "THE_SECOND_HORSEMAN" );
	missionSettings addLevel( "scoutsniper", true, undefined, true, "THE_SHOT" );
	missionSettings addLevel( "sniperescape", false, "PIGGYBACK_RIDE", true, "THE_SHOT" );
	missionSettings addLevel( "village_defend", false, undefined, true, "THE_THIRD_HORSEMAN" );
	missionSettings addLevel( "ambush", false, "DESPERATE_MEASURES", true, "THE_THIRD_HORSEMAN" );
	missionSettings addLevel( "icbm", true, undefined, true, "THE_ULTIMATUM" );
	missionSettings addLevel( "launchfacility_a", true, undefined, true, "THE_ULTIMATUM" );
	missionSettings addLevel( "launchfacility_b", true, undefined, true, "THE_ULTIMATUM" );
	missionSettings addLevel( "jeepride", false, "WIN_THE_WAR", true, "THE_FOURTH_HORSEMAN" );
	missionSettings addLevel( "airplane", false, undefined, undefined,"MILE_HIGH_CLUB" );

	level.missionSettings = missionSettings;
}


_nextmission()
{
	level.nextmission = true;
	level.player enableinvulnerability();	
	
	if ( arcadeMode() )
	{
		level.arcadeMode_success = true;
		thread maps\_arcadeMode::arcadeMode_ends();
		flag_wait( "arcademode_ending_complete" );
	}
	
	levelIndex = undefined;
	
	setsaveddvar( "ui_nextMission", "1" );
	setdvar( "ui_showPopup", "0" );
	setdvar( "ui_popupString", "" );
	
	maps\_gameskill::auto_adust_zone_complete( "aa_main_" + level.script );
	
	levelIndex = level.missionSettings getLevelIndex( level.script );
	
	if ( !isDefined( levelIndex ) )
		return;
		
	if( level.script != "jeepride" && level.script != "airplane" )
		maps\_utility::level_end_save();

	// update mission difficult dvar
	level.missionSettings setLevelCompleted( levelIndex );
	
//	if( !( level.missionSettings getLowestSkill() ) && !(level.script == "jeepride") )
	
	if( getdvarint("mis_01") < levelindex+1 && (level.script == "jeepride") && getdvarint("mis_cheat") == 0 )
	{
        setdvar( "ui_sp_unlock", "0" ); // set reset value to 0
        setdvar( "ui_sp_unlock", "1" );
    }
   
	if( getdvarint("mis_01") < levelindex+1 )// && !(level.script == "jeepride") )
		_setMissionDvar( "mis_01", levelIndex+1 );
		
	UpdateGamerProfile();

	if ( level.missionSettings hasAchievement( levelIndex ) )
		maps\_utility::giveachievement_wrapper( level.missionSettings getAchievement( levelIndex ) );
		
	if ( level.missionSettings hasLevelVeteranAward( levelIndex ) && getLevelCompleted( levelIndex ) == 4
		 && level.missionSettings check_other_hasLevelVeteranAchievement( levelIndex ) )
		maps\_utility::giveachievement_wrapper( level.missionSettings getLevelVeteranAward( levelIndex ) );
	
	if ( level.missionSettings hasMissionHardenedAward() && 
		level.missionSettings getLowestSkill() > 2 )
		giveachievement_wrapper( level.missionSettings getHardenedAward() );

	nextLevelIndex = level.missionSettings.levels.size;
	if ( level.script == "airplane" )
	{
		setsaveddvar( "ui_nextMission", "0" );
		//setdvar( "ui_victoryquote", "@VICTORYQUOTE_IW_THANKS_FOR_PLAYING" );
		missionSuccess("killhouse"); // for lack of better things to do..
		return;
	}
	else
	{
		nextLevelIndex = levelIndex + 1;
	}

	if ( arcadeMode() )
	{
		if ( !getdvarint( "arcademode_full" ) )
		{
			setsaveddvar( "ui_nextMission", "0" );
			missionSuccess( level.script );
			return;
		}

		if ( level.script == "cargoship" )
		{
			changelevel( "blackout", level.missionSettings getKeepWeapons( levelIndex ) );
			return;
		}
		else
		if ( level.script == "airlift" )
		{
			changelevel( "village_assault", level.missionSettings getKeepWeapons( levelIndex ) );
			return;
		}
		else
		if ( level.script == "jeepride" )
		{
			changelevel( "airplane", level.missionSettings getKeepWeapons( levelIndex ) );
			return;
		}
	}

	if ( level.script == "jeepride" )
	{
		setdvar( "credits_load", "1" ); 
		changelevel( "ac130", level.missionSettings getKeepWeapons( levelIndex ) );
		return;
	}
	
	if ( level.missionSettings skipssuccess( levelIndex ) )
		changelevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
	else
		missionSuccess( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
}
 
//allMissionsCompleted( difficulty )
//{
//	difficulty += 10;
//	for ( index = 0; index < level.missionSettings.size; index++ )
//	{
//		missionDvar = getMissionDvarString( index );
//		if ( getdvarInt( missionDvar ) < difficulty )
//			return( false );
//	}
//	return( true );
//}

getLevelCompleted( levelIndex )
{
	return int( getdvar( "mis_difficulty" )[ levelIndex ] );
}

setLevelCompleted( levelIndex )
{
	levelOffset = levelIndex;

	missionString = getdvar( "mis_difficulty" );
	
	if ( int( missionString[ levelOffset ] ) > level.gameskill )
		return;
		
	newString = "";
	gameskill = level.gameskill;
	
	if(level.script == "killhouse" )
		gameskill = 3;  // special hack. makes killhouse complete on the highest difficulty possible since no difficulty setting is available prior.
	
	for ( index = 0; index < missionString.size; index++ )
	{
		if ( index != levelOffset )
			newString += missionString[ index ];
		else
			newString += gameskill + 1;
	}
	_setMissionDvar( "mis_difficulty", newString );	
}

_setMissionDvar( dvar, string )
{
	if( maps\_cheat::is_cheating() || flag("has_cheated") )
		return;
	if(getdvar("mis_cheat") == "1")
		return;
	setMissionDvar( dvar, string );	
}


getLevelSkill( levelIndex )
{
	levelOffset = levelIndex;
	
	missionString = getdvar( "mis_difficulty" );
	return( int( missionString[ levelOffset ] ) );
}


//updateMissionDvar( levelIndex )
//{
//	missionDvar = getMissionDvarString();
//		
//	lowestSkill = self getLowestSkill();
//
//	if ( lowestSkill )
//		setMissionDvar( missionDvar, ( lowestSkill + 9 ) );
//	else if ( levelIndex + 1 > getdvarInt( missionDvar ) )
//		setMissionDvar( missionDvar, levelIndex + 1 );
//}


getMissionDvarString( missionIndex )
{
	if ( missionIndex < 9 )
		return( "mis_0" + ( missionIndex + 1 ) );
	else
		return( "mis_" + ( missionIndex + 1 ) );
}


getLowestSkill()
{
	missionString = getdvar( "mis_difficulty" );
	lowestSkill = 4;
		

	//hack here.  excluding the last level, airplane. normally wouldn't have the -1 on the size.
	for ( index = 0; index < self.levels.size-1; index++ )
	{
		if ( int( missionString[  index ] ) < lowestSkill )
			lowestSkill = int( missionString[ index ] );
	}
	return( lowestSkill );
}


createMission( HardenedAward )
{
	mission = spawnStruct();
	mission.levels = [];
	mission.prereqs = [];
// 	mission.slideShow = slideShow;
	mission.HardenedAward = HardenedAward;
	return( mission );
}

addLevel( levelName, keepWeapons, achievement, skipsSuccess, veteran_achievement )
{
	assert(isdefined(keepweapons));
	levelIndex = self.levels.size;
	self.levels[ levelIndex ] = spawnStruct();
	self.levels[ levelIndex ].name = levelName;
	self.levels[ levelIndex ].keepWeapons = keepWeapons;
	self.levels[ levelIndex ].achievement = achievement;
	self.levels[ levelIndex ].skipsSuccess = skipsSuccess;
	self.levels[ levelIndex ].veteran_achievement = veteran_achievement;
}

addPreReq( missionIndex )
{
	preReqIndex = self.prereqs.size;
	self.prereqs[ preReqIndex ] = missionIndex;
}

getLevelIndex( levelName )
{
	for ( levelIndex = 0; levelIndex < self.levels.size; levelIndex++ )
	{
		if ( self.levels[ levelIndex ].name != levelName )
			continue;
			
		return( levelIndex );
	}
	return( undefined );
}

getLevelName( levelIndex )
{
	return( self.levels[ levelIndex ].name );
}

getKeepWeapons( levelIndex )
{
	return( self.levels[ levelIndex ].keepWeapons );
}

getAchievement( levelIndex )
{
	return( self.levels[ levelIndex ].achievement );
}

getLevelVeteranAward( levelIndex )
{
	return( self.levels[ levelIndex ].veteran_achievement );
}

hasLevelVeteranAward( levelIndex )
{
	if ( isDefined( self.levels[ levelIndex ].veteran_achievement ) )
		return( true );
	else
		return( false );
}

hasAchievement( levelIndex )
{
	if ( isDefined( self.levels[ levelIndex ].achievement ) )
		return( true );
	else
		return( false );
}

check_other_hasLevelVeteranAchievement( levelIndex )
{
	//check for other levels that have the same Hardened achievement.  
	//If they have it and other level has been completed at a hardened level check passes.
	
	for ( i = 0; i < self.levels.size; i++ )
	{
		if( i == levelIndex )
			continue;
		if( ! hasLevelVeteranAward( i ) )
			continue;
		if( self.levels[ i ].veteran_achievement == self.levels[ levelIndex ].veteran_achievement  )
			if( getLevelCompleted( i ) < 4 )
				return false;
	}
	return true;
}

skipsSuccess( levelIndex )
{
	if ( !isDefined( self.levels[ levelIndex ].skipsSuccess ) )
		return false;
	return true;
}


getHardenedAward()
{
	return( self.HardenedAward );
}


hasMissionHardenedAward()
{
	if ( isDefined( self.HardenedAward ) )
		return( true );
	else
		return( false );
}

getNextLevelIndex()
{
	for ( index = 0; index < self.levels.size; index++ )
	{
		if ( !self getLevelSkill( index ) )
			return( index );
	}
	return( 0 );
}

force_all_complete()
{
	println("tada!");
	missionString = getdvar( "mis_difficulty" );
	newString = "";
	for ( index = 0; index < missionString.size; index++ )
	{
		if(index < 20)
			newString += 2;
		else
			newstring += 0;
	}
	setMissionDvar( "mis_difficulty", newString );	
	setMissionDvar( "mis_01", 20 );	
}

clearall()
{
	setMissionDvar( "mis_difficulty", "00000000000000000000000000000000000000000000000000" );	
	setMissionDvar( "mis_01", 1 );	
}

credits_end()
{

	// hacks to make airplane not unlock untill after credits. not to include the map in the list since there are unknown issues with level.script and ac130 conflicts that I don't want to deal with.
//	levelIndex = level.missionSettings getLevelIndex( "jeepride" );
//	if( getdvarint("mis_01") < levelindex+1  )
//		_setMissionDvar( "mis_01", levelIndex+1 );
	changelevel( "airplane" , false );
}
