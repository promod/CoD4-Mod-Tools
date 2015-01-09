#include maps\_utility;
#include common_scripts\utility;

main()
{
	maps\_load::main();
	level.player.ignoreme = true;
	ai_count = 1;

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	triggers = getEntArray( "aitrigger", "targetname" );
	
	array_thread( triggers, ::triggerThink );
	
	thread killAIOnUse();
	
	println( "Press X (use) at any time to kill all AI" );
}

killAIOnUse()
{
	while(1)
	{
		if ( level.player useButtonPressed() )
		{
			ai = getaiarray();
			for ( i = 0; i < ai.size; i++ )
				ai[i] doDamage( ai[i].health, ai[i].origin );
		}
		wait .05;
	}
}

triggerThink()
{
	spawner = getEnt( self.target, "targetname" );
	spawner.count = 1;
	spawner.script_moveoverride = 1;

	for( ;; )
	{
		self waittill ( "trigger" );
		
		guy = spawner stalingradSpawn();
		spawner.count++;
		if ( spawn_failed( guy ) )
		{
			wait ( 0.05 );
			continue;
		}
		
		guy thread aiThink();		
		guy waittill ( "death" );
	}
}


aiThink()
{
	self endon ( "death" );
	
	self.goalradius = 64;
	node = getNode( self.target, "targetname" );
	for ( ;; )
	{
		self setGoalNode( node );
		self waittill ( "goal" );
		if ( isDefined( self.node ) )
			wait 3;
		self delete();
	}
}
