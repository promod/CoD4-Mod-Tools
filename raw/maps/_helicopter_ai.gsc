#include maps\_vehicle;
#include maps\_utility;
#include maps\_helicopter_globals;
#include common_scripts\utility;

evasive_think( vehicle )
{
	vehicle endon( "death" );
	while( vehicle.health > 0 )
	{
		vehicle waittill( "missile_lock", enemyVehicle );
		
		points = evasive_createManeuvers( vehicle, "random" );
		evasive_startManeuvers( vehicle, points );
		
		wait 0.05;
	}
}

evasive_createManeuvers( vehicle, maneuverName )
{
	assert( isdefined( maneuverName ) );
	
	/* evasive_addPoint params:
	forward			- units forward/back
	side			- units left/right
	up				- units up/down
	goalYawMethod	- can be "average", "forward", or "none"
						none (default): always points towards the next point
						average: finds an angle between the forward direction and the goal direction
						forward: chopper will always face the direction it was originally moving
	*/
	
	switch( maneuverName )
	{
		case"strafe_left_right":
			// swerve & strafe ( right then left )
			vehicle evasive_addPoint(  3000, -1500,  500, "average" );
			vehicle evasive_addPoint(  6000,  3000, -700, "average" );
			vehicle evasive_addPoint(  3000, -1500,  200, "average" );
			break;
		
		case "strafe_right_left":
			// swerve & strafe ( right then left )
			vehicle evasive_addPoint(  3000,  1500,  500, "average" );
			vehicle evasive_addPoint(  6000, -3000, -700, "average" );
			vehicle evasive_addPoint(  3000,  1500,  200, "average" );
			break;
		
		case "360_clockwise":
			// 360 circle back around ( clockwise )
			vehicle evasive_addPoint(  1500,  1500,  200, "none" );
			vehicle evasive_addPoint(     0,  1500,  200, "none" );
			vehicle evasive_addPoint( -1500,  1500,  200, "none" );
			vehicle evasive_addPoint( -1500,     0,    0, "none" );
			vehicle evasive_addPoint( -1000, -1000, -200, "none" );
			vehicle evasive_addPoint(     0, -1000, -200, "none" );
			vehicle evasive_addPoint(  1000, -1000, -200, "none" );
			break;
		
		case "360_counter_clockwise":
			vehicle evasive_addPoint(  1500, -1500,  200, "none" );
			vehicle evasive_addPoint(     0, -1500,  200, "none" );
			vehicle evasive_addPoint( -1500, -1500,  200, "none" );
			vehicle evasive_addPoint( -1500,     0,    0, "none" );
			vehicle evasive_addPoint( -1000,  1000, -200, "none" );
			vehicle evasive_addPoint(     0,  1000, -200, "none" );
			vehicle evasive_addPoint(  1000,  1000, -200, "none" );
			break;
		
		case "random":
			maneuverNameList = [];
			maneuverNameList[0] = "strafe_left_right";
			maneuverNameList[1] = "strafe_right_left";
			maneuverNameList[2] = "360_clockwise";
			maneuverNameList[3] = "360_counter_clockwise";
			return evasive_createManeuvers( vehicle, maneuverNameList[ randomint( maneuverNameList.size ) ] );
	}
	
	points = evasive_getAllPoints( vehicle );
	return points;
}

evasive_startManeuvers( vehicle, points )
{
	vehicle notify( "taking_evasive_actions" );
	vehicle endon( "taking_evasive_actions" );
	vehicle endon( "death" );
	
	vehicle notify( "evasive_action_done" );
	
	thread evasive_endManeuvers( vehicle );
	
	if ( getdvar( "cobrapilot_debug") == "1" )
		vehicle evasive_drawPoints( points );
	
	vehicle setNearGoalNotifyDist( 1500 );
	vehicle setSpeed( 100, 30, 30 );
	
	forwardYaw = vehicle.angles[1];
	
	for( i = 1 ; i < points.size ; i++ )
	{
		//prof_begin( "cobrapilot_ai" );
		
		if ( isdefined( points[ i + 1 ] ) )
			evadeDirectionYaw = vectorToAngles( points[ i + 1 ]["pos"] - points[ i ]["pos"] );
		else
			evadeDirectionYaw = ( 0, forwardYaw, 0 );
		
		// determine goal yaw angle
		goalYawAngle = evadeDirectionYaw[1];
		if ( points[ i ]["goalYawMethod"] == "average" )
			goalYawAngle = ( ( evadeDirectionYaw[1] + forwardYaw ) / 2 );
		else if ( points[ i ]["goalYawMethod"] == "forward" )
			goalYawAngle = vehicle.angles[1];
		
		//prof_end( "cobrapilot_ai" );
		
		//draw line to represent target yaw
		if ( getdvar( "cobrapilot_debug") == "1" )
			thread draw_line_until_notify( points[ i ]["pos"], points[ i ]["pos"] + ( vectorScale( anglesToForward( ( 0, goalYawAngle, 0 ) ), 250 ) ), 1.0, 1.0, 0.2, vehicle, "evasive_action_done" );
		
		vehicle setTargetYaw( goalYawAngle );
		
		vehicle thread setvehgoalpos_wrap( points[ i ]["pos"], false );
		vehicle waittill( "near_goal" );
	}
	
	vehicle notify( "evasive_action_done" );
	
	vehicle thread vehicle_resumepath();
}

evasive_endManeuvers( vehicle )
{
	vehicle notify( "end_maneuvers" );
	vehicle endon( "end_maneuvers" );
	vehicle endon( "evasive_action_done" );
	vehicle endon( "death" );
	
	vehicle waittill( "missile_lock_ended" );
	vehicle thread vehicle_resumepath();
}

evasive_addPoint( forward, side, up, goalYawMethod )
{
	if ( !isdefined( self.evasive_points ) )
	{
		self.evasive_points = [];
		self.evasive_points[0]["pos"] = self.origin;
		self.evasive_points[0]["ang"] = ( 0, self.angles[1], 0 );
	}
	
	index = self.evasive_points.size;
	
	if ( !isdefined( goalYawMethod ) )
		goalYawMethod = "none";
	
	if ( !isdefined( up ) )
		up = 0;
	
	self.evasive_points[index]["forward"] = forward;
	self.evasive_points[index]["side"] = side;
	self.evasive_points[index]["up"] = up;
	
	//prof_begin( "cobrapilot_ai" );
	
	vec_forward = anglesToForward( self.evasive_points[ 0 ][ "ang" ] );
	vec_right = anglesToRight( self.evasive_points[ 0 ][ "ang" ] );
	
	self.evasive_points[ index ]["pos"] = self.evasive_points[ index - 1 ]["pos"] + ( vectorScale( vec_forward, self.evasive_points[ index ][ "forward" ] ) ) + ( vectorScale( vec_right, self.evasive_points[ index ][ "side" ] ) ) + ( 0, 0, up );
	self.evasive_points[ index ]["goalYawMethod"] = goalYawMethod;
	
	//prof_end( "cobrapilot_ai" );
}

evasive_getAllPoints( vehicle )
{
	points = vehicle.evasive_points;
	vehicle.evasive_points = undefined;
	return points;
}

evasive_drawPoints( points )
{
	for( i = 1 ; i < points.size ; i++ )
		thread draw_line_until_notify( points[ i - 1 ]["pos"], points[ i ]["pos"], 1.0, 0.2, 0.2, self, "evasive_action_done" );
}

wingman_think( vehicle )
{
	vehicle endon( "death" );
	level.playervehicle endon( "death" );
	
	dist_forward = 2200;
	dist_side 	 = 1500;
	dist_up 	 = 0;
	
	goalPosUpdateTime = 1.0;
	
	wingmanSpeedScale = 1.2;
	wingmanBaseAcceleration = 50;
	wingmanBaseDeceleration = 60;
	
	vehHelicopter_GetSpeedTime = 2000;
	vehHelicopter_CurrentSpeed = getPlayerHeliSpeed();
	vehHelicopter_OldSpeed = 0.0;
	vehHelicopter_OldSpeedTime = getTime();
	
	// put the wingman at it's goal at the start of the level
	goalPos = wingman_getGoalPos( dist_forward, dist_side, dist_up );
	vehicle setSpeed( 30, 20, 20 );
	vehicle setTargetYaw( level.playervehicle.angles[1] );		
	vehicle setVehGoalPos( goalPos, true );
	
	for(;;)
	{
		//prof_begin( "cobrapilot_ai" );
		
		/*******************************************************/
		/*** get the point where the wingman should hang out ***/
		/*******************************************************/
		
		goalPos = wingman_getGoalPos( dist_forward, dist_side, dist_up );
		
		if ( getdvar( "cobrapilot_debug") == "1" )
		{
			thread draw_line_for_time( level.playervehicle.origin, goalPos, 0, 1, 0, goalPosUpdateTime );
			thread draw_line_for_time( level.playervehicle.origin, vehicle.origin, 0, 0, 1, goalPosUpdateTime );
			thread draw_line_for_time( vehicle.origin, goalPos, 1, 1, 0, goalPosUpdateTime );
		}
		
		/************************************************************************************************/
		/*** save records of what the players speed was 3 seconds ago to that the wingman can keep up ***/
		/************************************************************************************************/
		time = getTime();
		if ( time >= vehHelicopter_OldSpeedTime + vehHelicopter_GetSpeedTime )
		{
			vehHelicopter_OldSpeedTime = time;
			vehHelicopter_OldSpeed = vehHelicopter_CurrentSpeed;
			vehHelicopter_CurrentSpeed = getPlayerHeliSpeed();
		}
		
		/***********************************************************************************************/
		/*** set wingmans goal position and target yaw here based on the players speed from the past ***/
		/***********************************************************************************************/
		bGoToGoal = false;
		wingmanSpeed = 0;
		
		if ( vehHelicopter_OldSpeed > 20 )
		{
			wingmanSpeed = vehHelicopter_OldSpeed;
			bGoToGoal = true;
		}
		else if ( ( vehHelicopter_OldSpeed <= 20 ) && ( getPlayerHeliSpeed() > 20 ) )
		{
			wingmanSpeed = getPlayerHeliSpeed();
			bGoToGoal = true;
		}
		
		if ( bGoToGoal && ( wingmanSpeed > 0 ) )
		{
			wingmanSpeed *= wingmanSpeedScale;
			accel = wingmanBaseAcceleration;
			decel = wingmanBaseDeceleration;
			if ( accel >= wingmanSpeed / 2 )
				accel = ( wingmanSpeed / 2 );
			if ( decel >= wingmanSpeed / 2 )
				decel = ( wingmanSpeed / 2 );
			
			vehicle setSpeed( wingmanSpeed, accel, decel );
			
			vehicle setTargetYaw( level.playervehicle.angles[1] );
			
			bStop = false;
			if ( getPlayerHeliSpeed() <= 30 )
				bStop = true;
			
			if ( getdvar( "cobrapilot_debug") == "1" )
				iprintln( "wingman speed: " + wingmanSpeed + " : " + bStop );
			
			vehicle setVehGoalPos( goalPos, bStop );
		}
		
		/***********************************************************************************************/
		/***********************************************************************************************/
		/***********************************************************************************************/
		
		//prof_end( "cobrapilot_ai" );
		
		wait goalPosUpdateTime;
	}
}

wingman_getGoalPos( dist_forward, dist_side, dist_up )
{
	vec_forward = anglesToForward( flat_angle( level.playervehicle.angles ) );
	vec_right = anglesToRight( flat_angle( level.playervehicle.angles ) );
	goalPos = level.playervehicle.origin + ( vectorScale( vec_forward, dist_forward ) ) + ( vectorScale( vec_right, dist_side ) ) + ( 0, 0, dist_up );
	return goalPos;
}

getPlayerHeliSpeed()
{
	return level.playervehicle getSpeedMPH();
}