// 200 participation points are given to the player for killing an enemy
// 800 participation points are taken from the player for killing a friendly
// friendly damage removes points based on amount of damage done and distance
// a max of 1000 points is allowed
// the player will fail the mission when level.friendlyfire["min_participation"] is reached
#include maps\_utility;
main()
{
	level.friendlyfire[ "min_participation" ] 	= -200;		// when the player hit this number of participation points the mission is failed
	level.friendlyfire[ "max_participation" ]	= 1000;		// the player will stop gaining participation points once this amount is earned
	level.friendlyfire[ "enemy_kill_points" ]	= 250;		// this many participation points are earned for killing an enemy
	level.friendlyfire[ "friend_kill_points" ] 	= -600;		// participation point penalty for killing a friendly
	level.friendlyfire[ "point_loss_interval" ] = 1.25;		// amount of time a point lasts
	
	level.player.participation = 0;

	level.friendlyFireDisabled = 0;
	if ( getdvar( "friendlyfire_dev_disabled" ) == "" )
		setdvar( "friendlyfire_dev_disabled", "0" );
	
	thread debug_friendlyfire();
	thread participation_point_flattenOverTime();
}

debug_friendlyfire()
{
	if ( getdvar( "debug_friendlyfire" ) == "" )
		setdvar( "debug_friendlyfire", "0" );
	
	friendly_fire = newHudElem();
	friendly_fire.alignX = "right";
	friendly_fire.alignY = "middle";
	friendly_fire.x = 620;
	friendly_fire.y = 100;
	friendly_fire.fontScale = 2;
	friendly_fire.alpha = 0;
	
	for (;;)
	{
		if ( getdvar( "debug_friendlyfire" ) == "1" )
			friendly_fire.alpha = 1;
		else
			friendly_fire.alpha = 0;
		
		friendly_fire setValue( level.player.participation );
		wait 0.25;
	}
}

// every entity that influences friedly fire should run this thread (ai of both teams, vehicles of both teams)
friendly_fire_think( entity )
{
	if ( !isdefined( entity ) )
		return;
	if ( !isdefined( entity.team ) )
		entity.team = "allies";

	// if the mission is failed from another entity running this function then end this one
	level endon( "mission failed" );
	
	// wait until this entity dies
	level thread notifyDamage( entity );
	level thread notifyDamageNotDone( entity );
	level thread notifyDeath( entity );
	
	for (;;)
	{
		if ( !isdefined( entity ) )
			return;
		
		if ( entity.health <= 0 )
			return;
		
		entity waittill ( "friendlyfire_notify", damage, attacker, direction, point, method );
		
		if ( !isdefined( entity ) )
			return;

		if ( ( isdefined( entity.NoFriendlyfire ) ) && ( entity.NoFriendlyfire == true ) ) 
			continue;
			
		// if we dont know who the attacker is we can't do much, so ignore it. This is seldom to happen, but not impossible
		if ( !isdefined( attacker ) )
			continue;
		
		// check to see if the death was caused by the player or the players turret
		bPlayersDamage = false;
		
		if ( attacker == level.player )
		{
			bPlayersDamage = true;
		}
		else 
		if ( ( isdefined( attacker.classname ) ) && ( attacker.classname == "script_vehicle" ) )
		{
			owner = attacker getVehicleOwner();
			if ( ( isdefined( owner ) ) && ( owner == level.player ) )
				bPlayersDamage = true;
		}
		
		// if the player didn't cause the damage then disregard
		if ( !bPlayersDamage )
			continue;
		
		if ( !isdefined( entity.team ) )
			continue;
			
		same_team = entity.team == level.player.team;
		killed = damage == -1;
		
		// if an enemy was killed then incriment the players participation score
		if ( !same_team )
		{
			if ( killed )
			{
				level.player.participation += level.friendlyfire[ "enemy_kill_points" ];
				participation_point_cap();
			}
			return;
		}
		
		//player killed/damaged a friendly
		if ( isdefined( entity.no_friendly_fire_penalty ) )
			continue;
			
		if ( killed )
		{
			level.player.participation += level.friendlyfire[ "friend_kill_points" ];
		}
		else
		{
			// friendly was damaged - figure out how many participation points to remove
			level.player.participation -= damage;
		}
		
		participation_point_cap();
		
		// dont fail the mission if death was caused by a grenade that was cooking durring an autosave
		if ( check_grenade( entity, method ) && savecommit_afterGrenade() )
		{
			if ( killed )
				return;
			else
				continue;
		}
		
		// fail the mission if the players participation has reached the minimum
		friendly_fire_checkPoints();
	}
}

friendly_fire_checkPoints()
{
	if ( level.player.participation <= ( level.friendlyfire[ "min_participation" ] ) )
		level thread missionfail();
}

check_grenade( entity, method )
{
	if ( !isdefined( entity ) )
		return false;
	
	// check if the entity was killed by a grenade
	wasGrenade = false;
	if ( ( isdefined( entity.damageweapon ) ) && ( entity.damageweapon == "none" ) )
		wasGrenade = true;
	if ( ( isdefined( method ) ) && ( method == "MOD_GRENADE_SPLASH" ) )
		wasGrenade = true;
	
	// if the entity was not killed by a grenade then exit
	return wasGrenade;
}

savecommit_afterGrenade()
{
	currentTime = gettime();
	if ( currentTime < 4500 )
	{
		println( "^3aborting friendly fire because the level just loaded and saved and could cause a autosave grenade loop" );
		return true;
	}
	else
	if ( ( currentTime - level.lastAutoSaveTime ) < 4500 )
	{
		println( "^3aborting friendly fire because it could be caused by an autosave grenade loop" );
		return true;
	}
	return false;
}

participation_point_cap()
{
	if ( level.player.participation > level.friendlyfire[ "max_participation" ] )
		level.player.participation = level.friendlyfire[ "max_participation" ];
	if ( level.player.participation < level.friendlyfire[ "min_participation" ] )
		level.player.participation = level.friendlyfire[ "min_participation" ];
}

participation_point_flattenOverTime()
{
	level endon( "mission failed" );
	for (;;)
	{
		if ( level.player.participation > 0 )
		{
			level.player.participation--;
		}
		else if ( level.player.participation < 0 )
		{
			level.player.participation++;
		}
		wait level.friendlyfire[ "point_loss_interval" ];
	}
}


TurnBackOn()
{
	level.friendlyFireDisabled = 0;
}


TurnOff()
{
	level.friendlyFireDisabled = 1;
}


missionfail()
{
	if ( level.friendlyFireDisabled == 1 )
		return;
	if ( getdvar( "friendlyfire_dev_disabled" ) == "1" )
		return;
	
	level.player endon ( "death" );
	level endon ( "mine death" );
	level notify ( "mission failed" );
	
	waittillframeend;

	setsaveddvar( "hud_missionFailed", 1 );
		
	if ( isdefined( level.player.failingMission ) )
		return;
	
	// friendly fire will not be tolerated
	if ( isdefined( level.custom_friendly_fire_message ) )
		setdvar( "ui_deadquote", level.custom_friendly_fire_message );
	else if ( level.campaign == "british" )
		setdvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH" );
	else if ( level.campaign == "russian" )
		setdvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN" );
	else
		setdvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN" );
	
	// shader if specified
	if ( isdefined( level.custom_friendly_fire_shader ) )
		thread maps\_load::special_death_indicator_hudelement( level.custom_friendly_fire_shader, 64, 64, 0 );
	
	logString( "failed mission: Friendly fire" );
	
	maps\_utility::missionFailedWrapper();
}

notifyDamage( entity )
{
	level endon( "mission failed" );
	entity endon( "death" );
	for (;;)
	{
		entity waittill( "damage", damage, attacker, direction, point, method );
		entity notify( "friendlyfire_notify", damage, attacker, direction, point, method );
	}
}

notifyDamageNotDone( entity )
{
	level endon( "mission failed" );
	entity waittill( "damage_notdone", damage, attacker, direction, point, method );
	entity notify( "friendlyfire_notify", -1, attacker, undefined, undefined, method );
}

notifyDeath( entity )
{
	level endon( "mission failed" );
	entity waittill( "death", attacker, method );
	entity notify( "friendlyfire_notify", -1, attacker, undefined, undefined, method );
}

detectFriendlyFireOnEntity( entity )
{
	/*
	if ( !isdefined( entity ) )
		return;
	assertEx( isdefined( entity.team ), "You must set .team to allies or axis for an entity calling detectFriendlyFire()" );
	
	entity setCanDamage( true );
	level thread friendly_fire_think( entity );
	*/
}
