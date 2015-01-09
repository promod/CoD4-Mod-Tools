#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
main()
{
	level.scr_anim[ "dead_guy" ][ "death1" ]				= %exposed_death_nerve;
	level.scr_anim[ "dead_guy" ][ "death2" ]				= %exposed_death_falltoknees;
	level.scr_anim[ "dead_guy" ][ "death3" ]				= %exposed_death_headtwist;
	level.scr_anim[ "dead_guy" ][ "death4" ]				= %exposed_crouch_death_twist;
	level.scr_anim[ "dead_guy" ][ "death5" ]				= %exposed_crouch_death_fetal;
	level.scr_anim[ "dead_guy" ][ "death6" ]				= %death_sitting_pose_v1;
	level.scr_anim[ "dead_guy" ][ "death7" ]				= %death_sitting_pose_v2;
	level.scr_anim[ "dead_guy" ][ "death8" ]				= %death_pose_on_desk;
	level.scr_anim[ "dead_guy" ][ "death9" ]				= %death_pose_on_window;
	level.scr_animtree[ "dead_guy" ] 							= #animtree;	

	level.dead_body_count = 1;

	// 6 corpses are retained after savegame load, so make sure
	// we have room to simulate all corpses plus our deadbody counts
	maxSim = getdvarint( "ragdoll_max_simulating" ) - 6;

	if ( maxSim > 0 )
		level.max_number_of_dead_bodies = maxSim;
	else
		level.max_number_of_dead_bodies = 0;
	
	struct = spawnstruct();
	struct.bodies = [];

	// triggers can spawn bodies
	run_thread_on_targetname( "trigger_body", ::trigger_body, struct );

	// spawn preplaced bodies with no trigger
	run_thread_on_targetname( "dead_body", ::spawn_dead_body, struct );
}

trigger_body( struct )
{
	self waittill( "trigger" );
	targets = getentarray( self.target, "targetname" );
	array_thread( targets, ::spawn_dead_body, struct );
}
	
spawn_dead_body( struct )
{
	if ( !getdvarint( "ragdoll_enable" ) && isdefined( self.script_parameters ) && self.script_parameters == "require_ragdoll" )
		return;

	if ( level.max_number_of_dead_bodies == 0 )
		return;

	index = undefined;
	if ( isdefined (self.script_index))
	{
		index = self.script_index;
	}
	else
	{
		level.dead_body_count++;
		if ( level.dead_body_count >3 )
			level.dead_body_count =1;
		index= level.dead_body_count;
	}
	
	model = spawn( "script_model", (0,0,0) );
	model.origin = self.origin;
	model.angles = self.angles;
	model.animname = "dead_guy";
	model assign_animtree();

	struct que_body( model );

	model [[ level.scr_deadbody[ index ] ]]();

	assertex( isdefined( self.script_noteworthy ), "Dead guy needs script_noteworthy death1 through 5" );
	
	if ( !isdefined( self.script_trace ) )
	{
		trace = bullettrace( model.origin + (0,0,5), model.origin + (0,0,-64 ), false, undefined );
		model.origin = trace[ "position" ];
	}
	
	model setflaggedanim( "flag", model getanim( self.script_noteworthy ), 1, 0, 1 );
	model waittillmatch( "flag", "end" );
	
	if ( !isdefined( self.script_start ) )
		model startragdoll();
}	

que_body( model )
{
	self.bodies[ self.bodies.size ] = model;
	if ( self.bodies.size <= level.max_number_of_dead_bodies )
		return;
	self.bodies[0] delete();
	self.bodies = array_removeUndefined( self.bodies );
}
