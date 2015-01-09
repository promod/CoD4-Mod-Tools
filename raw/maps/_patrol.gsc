#include maps\_utility;
#include maps\_anim;

#using_animtree( "generic_human" );
patrol( start_target )
{
	if ( isdefined( self.enemy ) )
		return;

	self endon( "death" );
	self endon( "end_patrol" );
	level endon( "_stealth_spotted" );
	level endon( "_stealth_found_corpse" );

//	self.old_walkdist = self.walkdist;
//	self.walkdist = 9999;
	self thread waittill_combat();
	self thread waittill_death();
	assert( !isdefined( self.enemy ) );
	self endon( "enemy" );
	self.goalradius = 32;
	self allowedStances( "stand" );
	self.disableArrivals = true;
	self.disableExits = true;
	self.allowdeath = true;
	self.script_patroller = 1;

/********************************************************************************************************

					//THE FOLLOWING SHOULD BE ADDED TO YOUR LEVEL ANIM FILE AND FAST FILE
			
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;
	
*********************************************************************************************************/

	walkanim = "patrol_walk";
	if( isdefined( self.patrol_walk_anim ) )
			walkanim = self.patrol_walk_anim;
			
	self set_generic_run_anim( walkanim, true );
	self thread patrol_walk_twitch_loop();
	
	// NOTE add combat call back and force patroller to walk

	// 1st boolean, true is for origins, false is for nodes
	// 2nd boolean, true is for targetname linking, false is for linkto
	get_goal_func[ true ][ true ] = ::get_target_ents;
	get_goal_func[ true ][ false ] = ::get_linked_ents;
	get_goal_func[ false ][ true ] = ::get_target_nodes;
	get_goal_func[ false ][ false ] = ::get_linked_nodes;
	set_goal_func[ true ] = ::set_goal_ent;
	set_goal_func[ false ] = ::set_goal_node;
	
	if ( isdefined( start_target ) )
		self.target = start_target;

	assertEx( isdefined( self.target ) || isdefined( self.script_linkto ), "Patroller with no target or script_linkto defined." );

	if ( isdefined( self.target ) )
	{
		link_type = true;
		ents = self get_target_ents();
		nodes = self get_target_nodes();
		
		if ( ents.size )
		{
			currentgoal = random( ents );
			goal_type = true;
		}
		else
		{
			currentgoal = random( nodes );
			goal_type = false;
		}
	}
	else
	{
		link_type = false;
		ents = self get_linked_ents();
		nodes = self get_linked_nodes();

		if ( ents.size )
		{
			currentgoal = random( ents );
			goal_type = true;
		}
		else
		{			
			currentgoal = random( nodes );
			goal_type = false;
		}
	}
	
	assertex( isdefined( currentgoal ), "Initial goal for patroller is undefined" );

	nextgoal = currentgoal;
	for ( ;; )
	{
		while ( isdefined( nextgoal.patrol_claimed ) )
		{
			// self animscripted( "scripted_animdone", self.origin, self.angles, getGenericAnim( "pause" ) );
			// self waittill( "scripted_animdone" );
			wait 0.05;
		}

		currentgoal.patrol_claimed = undefined;
		currentgoal = nextgoal;
		self notify( "release_node" );

		assertex( !isdefined( currentgoal.patrol_claimed ), "Goal was already claimed" );
		currentgoal.patrol_claimed = true;
		// self thread showclaimed( currentgoal );
		
		//this is for stealth code...so we can send him back to his patrol node if need be
		self.last_patrol_goal = currentgoal;
				
		[[ set_goal_func[ goal_type ] ]]( currentgoal );
		//check for both defined and size - because ents dont have radius defined by 
		//default - but nodes do - and that radius is 0 by default.
		if( isdefined( currentgoal.radius ) && currentgoal.radius > 0 )
			self.goalradius = currentgoal.radius;
		else
			self.goalradius = 32;
			
		self waittill( "goal" );
		currentgoal notify( "trigger", self );

		if ( isdefined( currentgoal.script_animation ) )
		{
			//assert( currentgoal.script_animation == "pause" || currentgoal.script_animation == "turn180" || currentgoal.script_animation == "smoke" );
			
			stop = "patrol_stop";
			self anim_generic_custom_animmode( self, "gravity", stop ); 
			switch( currentgoal.script_animation )
			{
				case "pause":
					idle = "patrol_idle_" + randomintrange(1,6);
					self anim_generic( self, idle );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
				case "turn180":
					turn = "patrol_turn180";
					self anim_generic_custom_animmode( self, "gravity", turn );
					break;
				case "smoke":
					anime = "patrol_idle_smoke";
					self anim_generic( self, anime );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
				case "stretch":
					anime = "patrol_idle_stretch";
					self anim_generic( self, anime );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
				case "checkphone":
					anime = "patrol_idle_checkphone";
					self anim_generic( self, anime );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
				case "phone":
					anime = "patrol_idle_phone";
					self anim_generic( self, anime );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
			} 
		}

		currentgoals = currentgoal [[ get_goal_func[ goal_type ][ link_type ] ]]();
		
		if ( !currentgoals.size )
		{
			self notify( "reached_path_end" );
			break;
		}

		nextgoal = random( currentgoals );
	}
}

patrol_walk_twitch_loop()
{
	self endon( "death" );
	self endon( "enemy" );
	self endon( "end_patrol" );
	level endon( "_stealth_spotted" );
	level endon( "_stealth_found_corpse" );
	
	self notify( "patrol_walk_twitch_loop" );
	self endon( "patrol_walk_twitch_loop" );
	
	if( isdefined( self.patrol_walk_anim ) && !isdefined( self.patrol_walk_twitch ) )
		return;
	
	while(1)
	{
		wait randomfloatrange(8,20);
		
		walkanim = "patrol_walk_twitch";	
		if( isdefined( self.patrol_walk_twitch ) )
			walkanim = self.patrol_walk_twitch;
					
		self set_generic_run_anim( walkanim, true );
		length = getanimlength( getanim_generic( walkanim ) );
		wait length;
		
		walkanim = "patrol_walk";
		if( isdefined( self.patrol_walk_anim ) )
			walkanim = self.patrol_walk_anim;
			
		self set_generic_run_anim( walkanim, true );
	}
}

waittill_combat_wait()
{
	self endon( "end_patrol" );
	level endon( "_stealth_spotted" );
	level endon( "_stealth_found_corpse" );
	self waittill( "enemy" );
}

waittill_death()
{
	self waittill( "death" );	
	
	if( !isdefined( self ) )
		return;
	
	self notify( "release_node" );
	
	if( !isdefined( self.last_patrol_goal ) )
		return;
	
	self.last_patrol_goal.patrol_claimed = undefined;
}

waittill_combat()
{
	self endon( "death" );
		
	assert( !isdefined( self.enemy ) );
	
	waittill_combat_wait();
	
//	self.walkdist = self.old_walkdist;
	
	if( !isdefined( self._stealth ) )
	{
		self clear_run_anim();
		self allowedStances( "stand", "crouch", "prone" );
		self.disableArrivals = false;
		self.disableExits = false;
		self stopanimscripted();
		self notify( "stop_animmode" );
	}
	self.allowdeath = false;
	
	
	if( !isdefined( self ) )
		return;
	
	self notify( "release_node" );
	
	if( !isdefined( self.last_patrol_goal ) )
		return;
	
	self.last_patrol_goal.patrol_claimed = undefined;
}

get_target_ents()
{
	array = [];

	if ( isdefined( self.target ) )
		array = getentarray( self.target, "targetname" );

	return array;
}

get_target_nodes()
{
	array = [];
	
	if ( isdefined( self.target ) )
		array = getnodearray( self.target, "targetname" );
	
	return array;
}

get_linked_nodes()
{
	array = [];

	if ( isdefined( self.script_linkto ) )
	{
		linknames = strtok( self.script_linkto, " " );
		for ( i = 0; i < linknames.size; i ++ )
		{
			ent = getnode( linknames[ i ], "script_linkname" );
			if ( isdefined( ent ) )
				array[ array.size ] = ent;
		}
	}
	
	return array;
}

showclaimed( goal )
{
	self endon( "release_node" );
	
	 /#
	for ( ;; )
	{
		entnum = self getentnum();
		print3d( goal.origin, entnum, ( 1.0, 1.0, 0.0 ), 1 );
		wait 0.05;
	}
	#/ 
}