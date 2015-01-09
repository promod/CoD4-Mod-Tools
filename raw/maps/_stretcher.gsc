#include maps\_utility;
#include common_scripts\utility;

#using_animtree("generic_human");
main()
{



	/*

		most turn animations are broken some way so that doesn't work as it should

		the pickup and drop animations needs to move the origin of the stretcher.
		the stretchers walk animation should not lift it from the ground the way it does now.
		when the pickup animation moves the origin of the stretcher the walk animation
		should happen at the correct spot any way.
		The origin of the stretcher should be moved to where I need it to be.

	*/


	precachemodel("character_us_cod3_preview");
	precachemodel("character_usmc_grenadier_a");
	precachemodel("stretcher_animated");
	precachemodel("vehicle_stretcher");

//	level.stretcher_front_height_offset = 29.5;
//	level.stretcher_rear_height_offset = 29;
//	level.stretcher_front_height_offset = 0;
//	level.stretcher_rear_height_offset = 0;
//	level.stretcher_rear_offset = -90;
//	level.front_guy_offset = 11;
//	level.rear_guy_offset = -6;

	level.front_max_turn = 20;
	level.rear_max_turn = 45;

	level.step_dist = 24;
	level.max_angle = 15;
	level.rear_offset = -89;
	level.stretcher_front_offset = -6;
	level.stretcher_rear_offset = -11;
	level.stretcher_length = -80; // negative since it's backwards

	level.rear_distance = 100;

//	level.distover1sec = 80; // 80 is the speed that fits the animation but it's a bit slow.
	level.distover1sec = 140;
//	level.distover1sec = 40; // tmp slow speed

	level.scr_anim["front_ai"]["pickup"] = %stretcher_F_pickup;
	level.scr_anim["rear_ai"]["pickup"] = %stretcher_R_pickup;
	level.scr_anim["front_ai"]["pickup_idle"][0] = %stretcher_F_wait_idle;
	level.scr_anim["rear_ai"]["pickup_idle"][0] = %stretcher_R_wait_idle;
	level.scr_anim["front_ai"]["drop"] = %stretcher_F_drop;
	level.scr_anim["rear_ai"]["drop"] = %stretcher_R_drop;

	setup_stretcher_anim();
}

move_stretcher(front_point, front_angles, rear_point, rear_angles)
{
	flat_vector = vectornormalize( front_point - rear_point );
	rough_vector = vectornormalize( flat_origin( front_point ) - flat_origin( rear_point ) );

//	vector = vectornormalize( front_point - rear_point );

	front_point = ground_origin( front_point );

	dist = distance(self.last_point, front_point);
	step_time = dist/level.distover1sec;

	self.last_point = front_point;

//	level.stretcher_front_offset = -11;
//	level.stretcher_rear_offset = 6;

	guy_angles = flat_angle( vectortoangles( flat_vector ) );

	front_guy_origin = front_point;
	stretcher_front_origin = front_point + vector_multiply( flat_vector, level.stretcher_front_offset );

	tmp_origin = ground_origin( stretcher_front_origin + vector_multiply( rough_vector, level.rear_offset ) );
	stretcher_vector = vectornormalize( stretcher_front_origin - tmp_origin );
	stretcher_rear_origin = stretcher_front_origin + vector_multiply( stretcher_vector, level.stretcher_length );
	rear_guy_origin = stretcher_rear_origin + vector_multiply( flat_vector, level.stretcher_rear_offset );

	stretcher_angles = vectortoangles( stretcher_vector );

/*
	level thread draw_guy(front_guy_origin, stretcher_angles, step_time);
	level thread draw_guy(rear_guy_origin, stretcher_angles, step_time);
	level thread drawline(stretcher_front_origin, stretcher_rear_origin, ( .3, .3, .8 ) , step_time);
*/

	self moveto( stretcher_front_origin, step_time );
	self rotateto( stretcher_angles, step_time );

	self.drone[0] moveto( front_guy_origin, step_time );
	self.drone[0] rotateto( guy_angles, step_time );

	self.drone[1] moveto( rear_guy_origin, step_time );
	self.drone[1] rotateto( guy_angles, step_time );

	front_angle_dif = adjust_angle( front_angles[1] - guy_angles[1] );
	rear_angle_dif = adjust_angle( rear_angles[1] - guy_angles[1] );

	direction = 0;
	if ( front_angle_dif > 0 )
		direction = 1;

//	self.drone[0] drone_anim_weight( front_angle_dif, level.front_max_turn, direction, step_time);
//	self.drone[1] drone_anim_weight( rear_angle_dif, level.rear_max_turn, direction, step_time);

	wait step_time;
}

drone_anim_weight(angle, max_angle, direction, step_time)
{
	right_weight = 0;
	left_weight = 0;
	straight_weight = 1;

	angle = adjust_angle( angle );

	turn = abs( int( ( angle / max_angle ) * 100 ) / 100 );
	if ( turn > 1)
		turn = 1;

	if ( !direction )
	{
		right_weight = turn;
		straight_weight = 1 - right_weight;
	}
	else
	{
		left_weight = turn;
		straight_weight = 1 - left_weight;
	}
		
	self setAnim(level.stretcher_anim[self.animname]["walk"], straight_weight, step_time, 1.75);	// rate = 1.75
	self setAnim(level.stretcher_anim[self.animname]["right"], right_weight, step_time, 1.75);
	self setAnim(level.stretcher_anim[self.animname]["left"], left_weight, step_time, 1.75);

}

draw_guy(guy_origin, guy_angles, show_time)
{
	vector = anglestoforward( guy_angles );
	head_origin = guy_origin + vector_multiply( vector, 32 );
	thread drawline(guy_origin, guy_origin + (0,0,72) , (.7, .3, .3 ), show_time);
	thread drawline(guy_origin + (0,0,64), head_origin + (0,0,64) , (.9, .5, .5 ), show_time);
}

follow_path(start_struct)
{
	if ( isdefined( start_struct.angles ) )
		current_angles = start_struct.angles;
	else
		current_angles = self.angles;

	current_point = start_struct.origin;

	if ( !isdefined( self.last_point ) )
		self.last_point = current_point;

	next_struct = getstruct( start_struct.target,"targetname" );
	start_struct notify("trigger");

	original_origin = start_struct.origin;

	rear_data = [];

	while ( true )
	{
		data_struct = path_math(current_angles, current_point, next_struct.origin);

		rear_struct = spawnstruct();
		rear_struct = data_struct;
		rear_data = array_add( rear_data, rear_struct);
		rear_point = undefined;


		current_point = data_struct.next_point;
		current_angles = data_struct.next_angles;

		// find the rear point
		dist = 0;
		index = rear_data.size;
		while ( true )
		{
			index--;

			if ( ( dist + rear_data[ index ].dist ) > level.rear_distance || index == 0 )
			{
				vector = rear_data[ index ].vector;
				remainder = 0 - ( level.rear_distance - dist );
				rear_point = rear_data[ index ].next_point + vector_multiply( vector, remainder );
				rear_angles = rear_data[ index ].previous_angles;
				break;
			}
			dist += rear_data[ index ].dist;
		}
		if ( index )
			rear_data = array_remove_first( rear_data );

		// move the stretcher to the next location
		self move_stretcher( current_point, current_angles, rear_point, rear_angles );

		if ( !data_struct.goal )
		{
			// notify when reached.
			next_struct notify("trigger");

			if ( !isdefined( next_struct.target ) )
				break;
			original_origin = next_struct.origin;
			next_struct = getstruct( next_struct.target,"targetname" );
			step = 0;
		}
	}
}

draw_path(start_struct, line_color, knot_color)
{
	/*
		THIS DOES THE SAME AS FOLLOW_PATH
		ONLY IT DRAWS THE PATH INSTEAD OF MOVING THE STRETCHER DOWN IT.
	*/
	
	if ( isdefined( start_struct.angles ) )
		current_angles = start_struct.angles;
	else
		current_angles = self.angles;

	current_point = start_struct.origin;

	next_struct = getstruct( start_struct.target,"targetname" );
	start_struct notify("trigger");

	original_origin = start_struct.origin;

	rear_data = [];

	while ( true )
	{
		data_struct = path_math(current_angles, current_point, next_struct.origin);

		rear_struct = spawnstruct();
		rear_struct = data_struct;
		rear_data = array_add( rear_data, rear_struct);
		rear_point = undefined;

		// calculate the rear point
		dist = 0;
		index = rear_data.size;

		while ( true )
		{
			index--;

			if ( ( dist + rear_data[ index ].dist ) > level.rear_distance || index == 0 )
			{
				vector = rear_data[ index ].vector;
				remainder = 0 - ( level.rear_distance - dist );
				rear_point = rear_data[ index ].next_point + vector_multiply( vector, remainder );
				break;
			}
			dist += rear_data[ index ].dist;
		}
		if ( index )
			rear_data = array_remove_first( rear_data );

		level thread drawline(current_point, data_struct.next_point, line_color );
//		level thread drawline(data_struct.next_point, data_struct.next_point + (0,0,32), knot_color );
//		level thread drawline(rear_point, rear_point + (0,0,32), (.9,.4,.5));
		level thread drawline(data_struct.next_point + (0,0,32), rear_point + (0,0,32), (1,1,1));

		wait .1;

		current_point = data_struct.next_point;
		current_angles = data_struct.next_angles;

		if ( !data_struct.goal )
		{
			if ( !isdefined( next_struct.target ) )
				break;
			original_origin = next_struct.origin;
			next_struct = getstruct( next_struct.target,"targetname" );
			step = 0;
		}
	}
}

path_math(current_angles, current_point, next_point, main_dist)
{
	// Returns a data_struct with the next origin and angle etc. to move to.
	// Doesn't care about elevation though.

	data_struct = spawnstruct();
	data_struct.goal = false;
	data_struct.previous_angles = current_angles;

	// adjust the speed of the curve depending on the distance.
/*	curve_speed = 1 - ( 256/main_dist );

	if ( curve_speed < .45 )
		curve_speed = .45;
	if ( curve_speed > .65 )
		curve_speed = .65;
*/
	curve_speed = .65;

	dist = distance( flat_origin( current_point ), flat_origin( next_point ) );

	// flaten next point;
	height_dif = next_point[2] - current_point[2];
	next_point = ( next_point[0], next_point[1], current_point[2] );

	vector = vectornormalize(next_point - current_point);
	next_angles = vectortoangles(vector);
	angle_dif = adjust_angle( ( vectortoangles(vector) - current_angles )[1] );

	angle = level.max_angle;

	fraction = 1;
	if ( abs(angle_dif) )
		fraction = angle / abs(angle_dif);

	if ( fraction < 1 )
	{
		data_struct.goal = true;

		angle_add = angle_dif * fraction;
		next_angles = current_angles + (0, angle_add, 0 );
		vector = anglestoforward( next_angles );
		dist = distance( current_point, next_point ) * fraction;
		dist = dist * curve_speed;

		if ( dist > level.step_dist )
			dist = level.step_dist;

		next_point =  current_point + vector_multiply(vector, dist);
		height_dif = height_dif * (1 - fraction);
	}
	else
	{
		if ( dist > level.step_dist )
		{
			fraction = level.step_dist / dist;

			dist = level.step_dist;

			next_point =  current_point + vector_multiply(vector, dist);
			height_dif = height_dif * fraction;

			data_struct.goal = true;
		}
	}

	next_point = next_point + (0, 0, height_dif);

	data_struct.dist = dist;
	data_struct.vector = vector;
	data_struct.next_point = next_point;
	data_struct.next_angles = next_angles;

//	level thread print3Dmessage(next_point, next_angles, 100, (.5,.5,1), (0,0,15), .5);
//	level thread print3Dmessage(next_point, dist , 100, (.5,.5,1), (0,0,15), .5);

	return data_struct;
}

walk_stretcher()
{
	self.stretcher thread stretcher_anim_loop("walk");
	self.drone[0] thread drone_anim_loop();
	self.drone[1] thread drone_anim_loop();
}

halt_stretcher()
{
	self.stretcher thread stop_stretcher_anim_loop("walk");
	self.drone[0] thread stop_anim_loop();
	self.drone[1] thread stop_anim_loop();
}

ground_origin(origin)
{
	ground = physicstrace( origin + (0,0,48), origin + (0,0,-96));
	return (origin[0],origin[1],ground[2]);
}

vector_divide(vec, n)
{
	vec = (vec[0] / n, vec[1] / n, vec[2] / n);
	return vec;
}

adjust_angle(angle)
{
	if (angle > 180)
		return angle-360;
	if (angle < -180)
		return angle+360;
	return angle;
}

moving_badpath()
{
	self endon("stop_badplace");
	while ( true )
	{
		badplace_cylinder("", .5, self.origin, 96, 72, "allies", "axis" );
		wait .5;
	}
}

array_remove_first( array )
{
	new_array = [];
	for ( i = 1; i<array.size; i++ )
	{
		new_array[ new_array.size ] = array[ i ];
	}

	return new_array;
}

/********/

#using_animtree("stretcher");
spawn_stretcher(point, start_angles)
{
	ground = ground_origin( point );
	ent = spawn( "script_origin", ground);
	anim_ent = spawn( "script_origin", ground - (44,0,0) );
	anim_ent.angles = (0,0,0);

	model = spawn( "script_model", ground - (44,0,0));
//	model.angles = (0,90,0);
	model setmodel("vehicle_stretcher");
//	model setmodel("stretcher_animated");
	model UseAnimTree(#animtree);
	model.animname = "stretcher";

	stretcher_clip = getent( "stretcher_clip", "targetname");
	stretcher_clip.origin = model.origin;
	stretcher_clip linkto( model );

	ent.stretcher = model;
	ent.stretcher linkto( ent );
	anim_ent linkto( ent );
	ent.angles = start_angles;
	ent.a.ent = anim_ent;
	wait .1;
	stretcher_clip linkto( ent.a.ent );
	return ent;
}

create_drone(ai, animname)
{
	model = ai.model;
	name = ai.name;
	weapon = ai.weapon;

	drone = spawn("script_model", ai.origin );
	drone setmodel(model);
	drone hide();
	drone.angles = flat_angle(ai.angles);
	drone.animname = animname;

	drone linkto(ai);

	if ( isdefined( weapon ) )
	{
		weapon_model = getweaponmodel(weapon);
		drone attach(weapon_model, "TAG_WEAPON_RIGHT");
	}

	drone UseAnimTree(#animtree);
	return drone;
}

setup_stretcher_anim()
{
	level.stretcher_anim = [];
	level.stretcher_anim["stretcher"]["walk"]	= %stretcher_walk_Forward;
	level.stretcher_anim["stretcher"]["pickup"]	= %stretcher_pickup;
	level.stretcher_anim["stretcher"]["drop"]	= %stretcher_drop;

	level.stretcher_anim["front"]["walk"]		= %stretcher_F_walk_Forward;
	level.stretcher_anim["front"]["right"]		= %stretcher_F_walk_Right;
	level.stretcher_anim["front"]["left"]		= %stretcher_F_walk_Left;

	level.stretcher_anim["rear"]["walk"]		= %stretcher_R_walk_Forward;
	level.stretcher_anim["rear"]["right"]		= %stretcher_R_walk_Right;
	level.stretcher_anim["rear"]["left"]		= %stretcher_R_walk_Left;
}

stretcher_anim_single(animation)
{
	self setflaggedanimrestart( animation, level.stretcher_anim[self.animname][animation] );
	self waittillmatch( animation, "end" );
	self clearanim( level.stretcher_anim[self.animname][animation], 0 );
}

stretcher_anim_loop(animation)
{
	self setAnimRestart(level.stretcher_anim[self.animname][animation], 1, 0, .5); 	// rate = 1.75
}

drone_anim_loop(animation)
{
	self setAnimRestart(level.stretcher_anim[self.animname]["walk"], 1, 0, 1.75);	// rate = 1.75
	self setAnimRestart(level.stretcher_anim[self.animname]["right"], 0, 0, 1.75);
	self setAnimRestart(level.stretcher_anim[self.animname]["left"], 0, 0, 1.75);
}

stop_stretcher_anim_loop(animation)
{
	self clearanim(level.stretcher_anim[self.animname][animation], 0);
}

stop_anim_loop(animation)
{
	self clearanim(%root, 0);
}

#using_animtree("generic_human");
drop_stretcher()
{
	self.drone[0] delete();
	self.drone[1] delete();

	self thaw( self.stretcher_ai[0] );
	self thaw( self.stretcher_ai[1] );

	self.a.ent thread maps\_anim::anim_single(self.stretcher_ai, "drop");
	self.stretcher stretcher_anim_single("drop");

	self.stretcher_ai[0] stop_magic_bullet_shield();
	self.stretcher_ai[1] stop_magic_bullet_shield();

	if ( self.stretcher_ai[0].script_noteworthy == "stretcher" )
		self.stretcher_ai[0].script_noteworthy = undefined;
	if ( self.stretcher_ai[1].script_noteworthy == "stretcher" )
		self.stretcher_ai[1].script_noteworthy = undefined;

	self notify( "stop_badplace" );

	self notify("dropped");
}

pickup_stretcher(ai, reach)
{
	self.stretcher_ai = ai;

	self.stretcher_ai[0] thread magic_bullet_shield();
	self.stretcher_ai[1] thread magic_bullet_shield();

	if ( !isdefined( self.stretcher_ai[0].script_noteworthy ) )
		self.stretcher_ai[0].script_noteworthy = "stretcher";
	if ( !isdefined( self.stretcher_ai[1].script_noteworthy ) )
		self.stretcher_ai[1].script_noteworthy = "stretcher";
		
	self.stretcher_ai[0].animname = "front_ai";
	self.stretcher_ai[1].animname = "rear_ai";

	if ( !isdefined(reach) || reach )
	{
		self.a.ent maps\_anim::anim_reach_idle(self.stretcher_ai, "pickup", "pickup_idle");
	}

	self.drone[0] = create_drone( self.stretcher_ai[0], "front" );
	self.drone[1] = create_drone( self.stretcher_ai[1], "rear" );

	self.a.ent thread maps\_anim::anim_single(self.stretcher_ai, "pickup");
	self.stretcher stretcher_anim_single("pickup");

	self.drone[0] show();
	self.drone[1] show();
	self.drone[0] unlink();
	self.drone[1] unlink();

	self thread freeze( self.stretcher_ai[0] );
	self thread freeze( self.stretcher_ai[1] );

	self thread moving_badpath();

	self notify("pickedup");
}

freeze(ai)
{
	ai endon("thaw");
	ai hide();
	ai linkto(self);
	while (true)
	{
		ai animscripted("frozen", ai.origin, ai.angles, %standunarmed_idle_loop);
		ai waittillmatch("frozen","end");

	}
}

thaw(ai)
{
	ai notify("thaw");
	ai stopanimscripted();
	ai unlink();
	ai show();
}


/**** DEBUG FUNCTIONS ****/

draw_structs(struct)
{
	while ( true )
	{
		level thread drawline(struct.origin, struct.origin + (0,0,-32), (1,0,0) );

		if ( !isdefined( struct.target ) )
			break;
		struct = getstruct( struct.target,"targetname" );
	}
}

drawline(p1, p2, color, show_time)
{
	if ( !isdefined(show_time) )
		show_time = 100;

	show_time = gettime() + (show_time * 1000);
	while ( gettime() < show_time)
	{
		line( p1, p2, color);
		wait 0.05;
	}
}

print3Dmessage(info_origin, message, show_time, color, offset, scale)
{
	if ( !isdefined(color) )
		color = (0.5,1,0.5);

	if ( !isdefined(offset) )
		offset = (0,0,56);

	if ( !isdefined(scale) )
		scale = 6;

	show_time = gettime() + (show_time * 1000);
	while ( gettime() < show_time)
	{
		print3d (info_origin + offset, message, color, 1, scale);
		wait (0.05);
	}
}