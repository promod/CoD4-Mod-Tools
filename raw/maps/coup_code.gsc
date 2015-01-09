#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\coup;
#include common_scripts\utility;

fadeOverlay( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}

blackOut( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 1, blur );
}

restoreVision( duration, blur )
{
	//wait duration;
	self fadeOverlay( duration, 0, blur );
}

initDOF()
{
    setsaveddvar( "scr_dof_enable", 0 );

    for ( ;; )
    {
        setdefaultdepthoffield();
        wait 0.05;
    }
}

setdefaultdepthoffield()
{
	level.player setDepthOfField( level.dofDefault[ "nearStart" ], level.dofDefault[ "nearEnd" ], level.dofDefault[ "farStart" ], level.dofDefault[ "farEnd" ], level.dofDefault[ "nearBlur" ], level.dofDefault[ "farBlur" ] );
}

setDOF( nearStart, nearEnd, nearBlur, farStart, farEnd, farBlur, duration )
{
	if ( isdefined( duration ) && duration > 0 )
	{
		duration = int( duration * 1000 );
		
	    startTime = getTime();
	    curTime = getTime();
	    
	    while ( curTime <= startTime + duration )
	    {
	    	lerpAmount = ( ( curTime - startTime ) / duration );
	
			lerpDoFValue( "nearStart", nearStart, lerpAmount );
			lerpDoFValue( "nearEnd", nearEnd, lerpAmount );
			lerpDoFValue( "nearBlur", nearBlur, lerpAmount );
			lerpDoFValue( "farStart", farStart, lerpAmount );
			lerpDoFValue( "farEnd", farEnd, lerpAmount );
			lerpDoFValue( "farBlur", farBlur, lerpAmount );
	
	    	wait 0.05;
	    	curTime = getTime();
	    }
	}

    level.dof[ "nearStart" ] = nearStart;
    level.dof[ "nearEnd" ] = nearEnd;
    level.dof[ "nearBlur" ] = nearBlur;
    level.dof[ "farStart" ] = farStart;
    level.dof[ "farEnd" ] = farEnd;
    level.dof[ "farBlur" ] = farBlur;
}

lerpDoFValue( valueName, targetValue, lerpAmount )
{
	level.dofDefault[ valueName ] = level.dof[ valueName ] + ( ( targetValue - level.dof[ valueName ] ) * lerpAmount ) ;	
}

scripted_array_spawn( value, key, stalingrad )
{
	spawner = getentarray( value, key );
	ai = [];

	for ( i = 0; i < spawner.size; i++ )
		ai[ i ] = scripted_spawn2( value, key, stalingrad, spawner[ i ] );
	return ai;
}

scripted_spawn2( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

	assertEx( isdefined( spawner ), "Spawner with " + key + " " + value + " does not exist." );
	
	if ( isdefined( spawner.script_drone ) )
	{
		drone = dronespawn( spawner );
		drone thread [[ level.drone_spawn_func ]]();
		
		//ghetto hack
		if ( spawner.classname == "actor_enemy_arab_AR_ak47" )
		{
			if( spawner.targetname == "carexit_rightguard" )
				drone SetCurbStompCharacter();
			else
				drone RandomizeGuardCharacter();
		}
		
		return drone;
	}
	else
	{
		if ( isdefined( stalingrad ) )
			ai = spawner stalingradSpawn();
		else
			ai = spawner dospawn();
		spawn_failed( ai );
		assert( isDefined( ai ) );
		return ai;
	}
}

DeleteCharacterTriggers()
{
	triggers = getentarray( "deleteai", "targetname" );
	for ( i = 0; i < triggers.size; i++ )
	{
		trigger = triggers[ i ];
		
		if ( isdefined( trigger.script_deleteai ) )
			trigger thread DeleteCharacter();
	}
}

DeleteCharacter()
{
	self waittill( "trigger" );
	
	aiarray = getaiarray();
	for ( i = 0; i < aiarray.size; i++ )
	{
		ai = aiarray[ i ];
		if ( isdefined( ai.script_deleteai ) && ai.script_deleteai == self.script_deleteai )
			ai delete();
	}
	
	teams[ 0 ] = "axis";
	teams[ 1 ] = "allies";
	teams[ 2 ] = "neutral";

	for ( i = 0; i < teams.size; i++ )
	{
		dronearray = level.drones[ teams[ i ] ].array;
		
		for ( k = 0; k < dronearray.size; k++ )
		{
			drone = dronearray[ k ];
			if ( isdefined( drone.script_deleteai ) && drone.script_deleteai == self.script_deleteai )
				drone delete();
		}
	}
}

// change so full fraction of 1 will not break
// handle initialization and changing of level.vision_totalpercent
// make sure we aren't doing vision stuff all through the whole level
// updateBlackOutOverlay()
pulseFadeVision( duration, value )
{
	level.player endon( "death" );

	level.vision_totalpercent = 100;
	thread updatePulseFadeAmount( duration, value );

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	min_length = 1;
	max_length = 4;
	min_alpha = .25;
	max_alpha = 1;

	min_percent = 0;
	max_percent = 100;
	
	fraction = 0;

	for ( ;; )
	{
		while ( level.vision_totalpercent > min_percent )
		{
			percent_range = max_percent - min_percent;
			fraction = ( level.vision_totalpercent - min_percent ) / percent_range;

			if ( fraction < 0 )
				fraction = 0;
			else if ( fraction > 1 )
				fraction = 1;

			length_range = max_length - min_length;
			length = min_length + ( length_range * ( 1 - fraction ) );
			
			alpha_range = max_alpha - min_alpha;
			alpha = min_alpha + ( alpha_range * fraction );

			blur = 7.2 * alpha;
			end_alpha = fraction * 0.5;
			end_blur = 7.2 * end_alpha;

			// println( "fraction: ", fraction, " length: ", length, " alpha: ", alpha, " blur: ", blur );
			
			// if ( fraction == 1 )
				// break;
			
			duration = length / 2;

			overlay fadeOverlay( duration, alpha, blur );
			overlay fadeOverlay( duration, end_alpha, end_blur );

			// wait a variable amount based on level.vision_totalpercent, this is the space in between pulses
			wait( fraction * 0.5 );
		}

		// if ( fraction == 1 )
			// break;
		
		// if ( overlay.alpha != 0 )
			// overlay fadeOverlay( 1, 0, 0 );
		
		wait 0.05;
	}

	// overlay fadeOverlay( 2, 1, 6 );
}

updatePulseFadeAmount( duration, value )
{
	frequency = 0.05;
	steps = int( duration / frequency );

	while ( steps > 1 )
    {
	    level.vision_totalpercent = level.vision_totalpercent + ( value - level.vision_totalpercent ) / steps;
	    steps -- ;
	 // println( "level.vision_totalpercent: ", level.vision_totalpercent, " steps: ", steps );

	    wait frequency;
	}

	level.vision_totalpercent = value;
}

dropdead()
{
	self waittill( "death", other );

	self animscripts\shared::DropAllAIWeapons();
	self startragdoll();	
	org = self.origin;
	org = org + ( 0, 16, 0 );
	forward = AnglesToForward( ( 0, 270, 0 ) );
	force = vectorScale( forward, 2 );
	//thread maps\_debug::drawArrowForever( org, ( 0, 270, 0 ) );
	PhysicsJolt( org, 250, 250, force );
}

DeleteEntity( entity )
{
	if ( isdefined( entity ) )
	{
		if ( isdefined( entity.magic_bullet_shield ) )
			entity stop_magic_bullet_shield();
	
		entity delete();
	}
}

DeleteOnGoal()
{
	self waittill( "goal" );
	DeleteEntity( self );
}

DeleteOnFlag( flag, delay )
{
	flag_wait( flag );
	wait delay;
	
	self delete();
}

printslowmo( string )
{
	if ( isdefined( level.debug_slowmo ) && level.debug_slowmo )
		println( "SLOWMO: " + string );
}

printspeech( string )
{
	if ( isdefined( level.debug_speech ) && level.debug_speech )
		println( "SPEECH: " + string );
}

playspeech( soundalias, string )
{
	if ( isdefined( string ) )
		printspeech( string );

	level.player thread play_sound_on_entity( soundalias );
}

RandomizeGuardCharacter()
{
	size = self getattachsize();
	models = [];
	tags = [];
	
	for ( i = 0;i < size;i++ )
	{
		models[i] = self getattachmodelname( i );
		tags[i] = self getattachtagname( i );
	}

	for ( i = 0;i < size;i++ )
	{
		if (  tags[i] != "tag_weapon_right" )
			self Detach( models[i], tags[i] );
	}

	switch( randomint( 6 ) )
	{
	case 0:
		character\character_sp_arab_regular_asad::main();
		break;
	case 1:
		character\character_sp_arab_regular_sadiq::main();
		break;
	case 2:
		character\character_sp_arab_regular_ski_mask::main();
		break;
	case 3:
		character\character_sp_arab_regular_ski_mask2::main();
		break;
	case 4:
		character\character_sp_arab_regular_suren::main();
		break;
	case 5:
		character\character_sp_arab_regular_yasir::main();
		break;
	}
}

SetCurbStompCharacter()
{
	size = self getattachsize();
	models = [];
	tags = [];
	
	for ( i = 0;i < size;i++ )
	{
		models[i] = self getattachmodelname( i );
		tags[i] = self getattachtagname( i );
	}

	for ( i = 0;i < size;i++ )
	{
		if (  tags[i] != "tag_weapon_right" )
			self Detach( models[i], tags[i] );
	}

	character\character_sp_arab_regular_yasir::main();
}

lerpShadowDetail( l2, duration )
{
	l1 = getdvarint( "sm_sunSampleSizeNear" );
	duration = duration * 20;
	suncolor = [];
	
	for ( i = 0; i < duration; i++ )
	{
		dif = i / duration;
		ld = l2 * dif + l1 * ( 1 - dif );
		
		setsaveddvar( "sm_sunSampleSizeNear", ld );
		wait( 0.05 );
	}
	
	setsaveddvar( "sm_sunSampleSizeNear", l2 );
}

PlayLinkedSound( soundalias )
{
	org = spawn( "script_origin", ( 0, 0, 0 ) );
	org.origin = self.origin;
	org.angles = self.angles;
	org linkto( self );
	
	org thread play_sound_on_tag( soundalias, undefined, true );

	return org;
}

fake_tag( tag, origin_offset, angles_offset )
{
	if( !isdefined( origin_offset ) )
		origin_offset =	(0, 0, 0);

	if( !isdefined( angles_offset ) )
		angles_offset =	(0, 0, 0);

	ent = spawn( "script_model", self.origin);
	ent setmodel( "tag_origin" );
	ent hide();
	ent linkto( self, tag, origin_offset, angles_offset );
	self thread fake_tag_destroy( ent );
	return ent;
}

fake_tag_destroy( fake_tag )
{
	self waittill( "death" );
	fake_tag delete();
}