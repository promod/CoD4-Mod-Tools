/**** LEAPFROG SYSTEM ****

	Thread maps\_leapfrog::leapfrog() on any AI that uses a chain of nodes.
	Make sure to check the NOT_CHAIN check box on each node in the chain to allow chains to merge or loop.
	You need at least two chains for this to look good.
	level.leap_delay_min and max determines how fast they try to advance.
	set script_delay on a node to have the ai use a delay instead of waiting for a leap notify.
	script_delay = 0 will make them run past that node before going to the next one.

*************************/

#include maps\_utility;

main()
{
	//	Set delays to tweak how fast the advance should be.
	level.leap_delay_min = 6;
	level.leap_delay_max = 14;
	level.leap_delay_override = false;

	// there will never be more ai on one leap node then what this is set to.
	level.leapfrog_max_node_ai = 6;

	level.leap_node_array = [];
	level.leapfrog_random_int = randomint(5);

	// lower threat threatbias group for when leaping.
	createthreatbiasgroup("leapfrog");
	setthreatbiasagainstall("leapfrog", -200);

	level thread leapfrog_masterthread();
}

leapfrog_masterthread()
{
	while ( true )
	{
		if ( !level.leap_delay_override )
			wait ( randomFloatRange( level.leap_delay_min, level.leap_delay_max ) );
		else
			wait .05;

		level.leap_delay_override = false;

		// used to make ai take the same fork in a path when script_delay is set.
		level.leapfrog_random_int = randomint(5);

		node_arr = [];
		high_weight = -1000000;

		if ( !level.leap_node_array.size )
			continue;

		for ( i=0; i<level.leap_node_array.size; i++ )
		{
			weight = level.leap_node_array[i].leap_weight;
			if ( !isdefined(node_arr[weight]) )
				node_arr[weight] = [];
			node_arr[weight][ node_arr[weight].size ] = level.leap_node_array[i];
			if ( weight > high_weight )
				high_weight = weight;
		}

		assertEx( isdefined(node_arr[high_weight]), "high_weight is: " + high_weight );
		assertEx( isdefined(high_weight >= 0), "high_weight is below zero: " + high_weight );

		node = node_arr[high_weight][ randomint( node_arr[high_weight].size ) ];

		assert ( isdefined(node.target) ); // there should always be a new node or it shouldn't be in the array.

		node_arr = getnodearray(node.target,"targetname");
		next_node = node_arr[ randomint(node_arr.size) ];

		// reset future ai count
		if ( isdefined( next_node.leapfrog_ai_count ) )
			next_node.leapfrog_future_ai_count = next_node.leapfrog_ai_count;
		else
			next_node.leapfrog_future_ai_count = 0;

		// increase the weight of all none chosen nodes.
		array_thread( level.leap_node_array, ::increment_leap_weight, node );

		new_weight =  int(node.leap_weight * -.25);

		if (isdefined(next_node.leap_weight))
			new_weight += next_node.leap_weight;

		add_leap_node(next_node, new_weight);

		node notify("leapfrog", next_node);
		remove_leap_node(node);
	}
}

increment_leap_weight(node)
{
	if (self == node)
		return;

	diff_weight = node.leap_weight - self.leap_weight;
	
	self.leap_weight += (int (diff_weight * 0.5) + 1); // old .75;
}

leapfrog()
{
	self endon("death");
	self endon("stop_leapfrog");
	self notify("stop_going_to_node");

	// get first node
	node_arr = getnodearray(self.target,"targetname");
	node = node_arr[ randomint(node_arr.size) ];

	while ( true )
	{
		if (node.radius != 0)
			self.goalradius = node.radius;
		if ( isdefined(node.height) )
			self.goalheight = node.height;
		self setgoalnode(node);

		old_maxsightdistsqrd = self.maxsightdistsqrd;
		self.maxsightdistsqrd = 350*350;
		old_group = self getthreatbiasgroup();
		self setthreatbiasgroup("leapfrog");

		self waittill("goal");

		// Notify the node and pass the guy. Might be good for something
		node notify("trigger",self);

		self.maxsightdistsqrd = old_maxsightdistsqrd;
		self setthreatbiasgroup(old_group);

		self thread leapfrog_on_death(node);

		if ( !isdefined(node.target) )
			break;

		if ( isdefined(node.script_delay) )
		{
			node script_delay();
			node_arr = getnodearray(node.target,"targetname");
			next_node = node_arr[ level.leapfrog_random_int % node_arr.size ];
		}
		else
		{
			if ( !add_leap_node(node) )
				break;

			node waittill("leapfrog", next_node);
	
			next_node.leapfrog_future_ai_count++;

			max_node_ai = level.leapfrog_max_node_ai;
			if ( isdefined(node.script_noteworthy) )
				max_node_ai = int( node.script_noteworthy );
	
			if (next_node.leapfrog_future_ai_count > max_node_ai)
			{
				level.leap_delay_override = true;
				if ( isdefined(next_node.leap_weight) )
				{
					next_node.leap_weight += 1;	// make the full node more likely to leap.
				}
				next_node = node;	// stay on old node.
			}
		}

		node = next_node;
	}

	// notify level and pass the guy that reached his final leapfrog node.
	level notify("leapfrog_completed", self);
}

leapfrog_on_death(node)
{
	node endon("leapfrog");

	if ( !isdefined( node.leapfrog_ai_count ) )
		node.leapfrog_ai_count = 0;
	node.leapfrog_ai_count++;

	self waittill("death");

	node.leapfrog_ai_count--;

	if ( isdefined(node.leap_weight) )
	{
		new_weight = node.leap_weight - 1;
		if (new_weight < 1)
			new_weight = 1;
		node.leap_weight = new_weight;
	}

	if (!node.leapfrog_ai_count)
		remove_leap_node(node);
}

add_leap_node(node, weight)
{
	if ( !isdefined(node.target) || isdefined(node.script_delay))
		return false;

	if ( getdvar("debug") == "1")
		node thread debug_leap_node();

	if ( !is_in_array (level.leap_node_array, node) )
	{
		level.leap_node_array = array_add(level.leap_node_array, node);
		node.leap_weight = 0;
	}

	if ( isdefined(weight) )
		node.leap_weight = weight;
	else
		node.leap_weight += 2;

	return true;
}

remove_leap_node(node)
{
	node.leap_weight = undefined;
	node.leapfrog_ai_count = undefined;

	level.leap_node_array = array_remove(level.leap_node_array, node);
}

/* debug stuff */

debug_leap_node()
{
	if ( isdefined(self.debug_leapnode) )
		return;
	self.debug_leapnode = true;

	while (true)
	{
		if ( isdefined(self.leap_weight) )
			self thread print3Dmessage(self.leap_weight, .5);
		if ( isdefined(self.leapfrog_ai_count) )
			self thread print3Dmessage(self.leapfrog_ai_count, 0.5 , (1,0,0), (0,0,128) , 3);
		wait .5;
	}
}

print3Dmessage(message, show_time, color, offset, scale)
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
		print3d (self.origin + offset, message, color, 1, scale);
		wait (0.05);
	}
}
