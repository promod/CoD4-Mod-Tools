#include maps\_utility;
#include common_scripts\utility;
#include animscripts\shared;
#include animscripts\utility;
#include animscripts\face;

 /* 
ANIM_LOOP: Makes an array of actors and / or script_models do looping animations in sync on a specific node or tag.
anim_loop( guy, anime, tag, ender, node, tag_entity )
	guy = An array containing actors or script models or both.
	anime = a string index for an animation, ie "run" in this var: level.scr_anim[ "gun guy" ][ "run" ][ 0 ] = ( %tigertank_runup_gunguy );
	tag = The tag to start the animation from. You'll want to link the AI if he's meant to be linked to the tag.
	ender = A string to end the looping animation. The entity that called anim_loop will received the notify.
	node = The node referenced in the animation
	tag_entity = The entity that has the tag mentioned above. Normally the entity that calls anim_loop is the tag_entity, 
				but if for some reason you need to call anim_loop with a different entity, then you can override with tag_entity.

	
ANIM_SINGLE:	Makes an array of actors and / or script_models do a single animation in sync on a specific node or tag.
				The thread continues after the completion of the animation.
anim_single( guy, anime, tag, node, tag_entity )
	guy = An array containing actors or script models or both.
	anime = a string index for an animation, ie "run" in this var: level.scr_anim[ "gun guy" ][ "run" ] = ( %tigertank_runup_gunguy );
	tag = The tag to start the animation from. You'll want to link the AI if he's meant to be linked to the tag.
	node = The node referenced in the animation
	tag_entity = The entity that has the tag mentioned above. Normally the entity that calls anim_single is the tag_entity, 
				but if for some reason you need to call anim_single with a different entity, then you can override with tag_entity.


ANIM_REACH:	Makes an array of AI all get into position to do a specific animation, after which the thread will continue.
anim_reach( guy, anime, tag, node, tag_entity )


ANIM_TELEPORT:	Forces AI and script_models to teleport to the propert starting position for an animation. Note that teleport will fail
				if the player can see the AI in question( the script_models will properly jump regardless ).
anim_teleport( guy, anime, tag, node, tag_entity )

	
ANIM_SPAWNER_TELEPORT:	Meant for moving an array of spawners into position so you can then spawn the AI at the right position for
						doing their animation.
anim_teleport( guy, anime, tag, node, tag_entity )


GET_ANIMTREE:	Assigns the proper animtree to every AI / script_model in the array. Be sure to set the .animname for the entities in 
				the array.	
get_animtree( guy )
	
 */ 

init()
{
	if ( !isDefined( level.scr_special_notetrack ) )
		level.scr_special_notetrack = [];
	if ( !isDefined( level.scr_notetrack ) )
		level.scr_notetrack = [];
	if ( !isDefined( level.scr_face ) )
		level.scr_face = [];
	if ( !isDefined( level.scr_look ) )
		level.scr_look = [];
	if ( !isDefined( level.scr_animSound ) )
		level.scr_animSound = [];
	if ( !isDefined( level.scr_sound ) )
		level.scr_sound = [];
	if ( !isDefined( level.scr_radio ) )
		level.scr_radio = [];
	if ( !isDefined( level.scr_text ) )
		level.scr_text = [];
	if ( !isDefined( level.scr_anim ) )
		level.scr_anim[ 0 ][ 0 ] = 0;
	if ( !isDefined( level.scr_radio ) )
		level.scr_radio = [];
}

endonRemoveAnimActive( endonString, guyPackets )
{
	self endon( "newAnimActive" );
	self waittill( endonString );
	for ( i = 0; i < guyPackets.size; i ++ )
	{
		guy = guyPackets[ i ][ "guy" ];
		if ( !isdefined( guy ) )
			continue;
	
		guy._animActive -- ;
		guy._lastAnimTime = getTime();
		assert( guy._animactive >= 0 );
	}
}


 /* 
 ============= 
///ScriptDocBegin
"Name: anim_first_frame( <guys> , <scene> , <tag> )"
"Summary: Puts the animating models or AI or vehicles into the first frame of the animated scene. The animation is played relative to the entity that calls the scene"
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <array of things that animate> : An array of AI or vehicles or script_models, mixed or homogenous."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ animname ][ anime ]."
"OptionalArg: <optional tag to attach to> : A tag that the root entity has that the animating entities are attached to."
"Example: node anim_first_frame( guys, "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 

anim_first_frame( guys, anime, tag )
{
	array = get_anim_position( tag );
	org = array[ "origin" ];
	angles = array[ "angles" ];
	
	array_levelthread( guys, ::anim_first_frame_on_guy, anime, org, angles );
}

/* 
============= 
///ScriptDocBegin
"Name: anim_generic_first_frame( <guys> , <scene> , <tag> )"
"Summary: Puts the animating model or AI or vehicle into the first frame of the animated scene. The animation is played relative to the entity that calls the scene"
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <thing that animates> : An AI or vehicle or script_model."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ animname ][ anime ]."
"OptionalArg: <optional tag to attach to> : A tag that the root entity has that the animating entities are attached to."
"Example: node anim_generic_first_frame( guy, "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

anim_generic_first_frame( guy, anime, tag )
{
	array = get_anim_position( tag );
	org = array[ "origin" ];
	angles = array[ "angles" ];
	
	thread anim_first_frame_on_guy( guy, anime, org, angles, "generic" );
}


/* 
============= 
///ScriptDocBegin
"Name: anim_generic( <guys>, <scene> , <optinal tag to animate relative to> )"
"Summary: Makes an AI play a generic anim. The calling ent notifies itself the name of the animation scene when it completes."
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <thing that will animate> AI, model, or vehicle."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ generic ][ anime ]."
"OptionalArg: <optional tag to animate relative to> : A tag that the root entity has that the animating entities are attached to."
"Example: node anim_generic( guy, "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

anim_generic( guy, anime, tag )
{
	guys = [];
	guys[ 0 ] = guy;
	anim_single( guys, anime, tag, undefined, undefined, "generic" );
}

/* 
============= 
///ScriptDocBegin
"Name: anim_generic_reach( <guys>, <scene> , <optinal tag to animate relative to> )"
"Summary: Makes an AI move to the position to start an animation. The calling ent notifies itself the name of the animation scene when it completes."
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <thing that will animate> AI that will move."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ generic ][ anime ]."
"OptionalArg: <optional tag to animate relative to> : A tag that the root entity has that the animating entities are attached to."
"Example: node anim_reach( guy, "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

anim_generic_reach( guy, anime, tag )
{
	guys = [];
	guys[ 0 ] = guy;
	anim_reach( guys, anime, tag, undefined, undefined, "generic" );
}

/* 
============= 
///ScriptDocBegin
"Name: anim_generic_reach_and_arrive( <guys>, <scene> , <optinal tag to animate relative to> )"
"Summary: Makes an AI move to the position to start an animation, with arrivals. The calling ent notifies itself the name of the animation scene when it completes."
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <thing that will animate> AI that will move."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ generic ][ anime ]."
"OptionalArg: <optional tag to animate relative to> : A tag that the root entity has that the animating entities are attached to."
"Example: node anim_reach_and_arrive( guy, "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

anim_generic_reach_and_arrive( guy, anime, tag )
{
	guys = [];
	guys[ 0 ] = guy;
	anim_reach_with_funcs( guys, anime, tag, undefined, undefined, "generic", ::reach_with_arrivals_begin, ::reach_with_standard_adjustments_end );
}

/* 
============= 
///ScriptDocBegin
"Name: anim_reach_and_plant( <guys>, <scene> , <optinal tag to animate relative to> )"
"Summary: Makes an AI move to the position to start an animation, with arrivals, and plants the point to the ground so you can do an animmode gravity after the reach. The calling ent notifies itself the name of the animation scene when it completes."
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <thing that will animate> AI that will move."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ generic ][ anime ]."
"OptionalArg: <optional tag to animate relative to> : A tag that the root entity has that the animating entities are attached to."
"Example: node anim_reach_and_plant( guy, "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

anim_reach_and_plant( guys, anime, tag )
{
	anim_reach_with_funcs( guys, anime, tag, undefined, undefined, undefined, ::reach_with_planting, ::reach_with_standard_adjustments_end );
}

/* 
============= 
///ScriptDocBegin
"Name: anim_generic_loop( <guys>, <scene> , <optinal tag to animate relative to> , <optional ender notify> )"
"Summary: Makes an AI play a generic looping anim. The calling ent notifies itself the name of the animation scene when it completes."
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <thing that will animate> AI, model, or vehicle."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ generic ][ anime ]."
"OptionalArg: <optional tag to animate relative to> : A tag that the root entity has that the animating entities are attached to."
"OptionalArg: <optional ender notify> : Ends the loop on notify."
"Example: node anim_generic_loop( guy, "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

anim_generic_loop( guy, anime, tag, ender )
{
	// package him off nicely for anim_loop_packet
	packet = [];
	packet[ "guy" ] = guy;
	packet[ "entity" ] = self;
	packet[ "tag" ] = tag;
	guyPackets[ 0 ] = packet;

	anim_loop_packet( guyPackets, anime, ender, "generic" );
}


/* 
============= 
///ScriptDocBegin
"Name: anim_custom_animmode( <guys>, <animmode> , <scene> , <tag> )"
"Summary: Makes an AI play an anim using a specific animmode."
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <array of things that animate> : An array of AI."
"MandatoryArg: <animmode> : The preferred animmode."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ animname ][ anime ]."
"OptionalArg: <optional tag to attach to> : A tag that the root entity has that the animating entities are attached to."
"Example: node anim_custom_animmode( guys, "gravity", "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 

anim_custom_animmode( guys, custom_animmode, anime, tag )
{
	array = get_anim_position( tag );
	org = array[ "origin" ];
	angles = array[ "angles" ];
	
	for ( i = 0; i < guys.size; i ++ )
	{
		thread anim_custom_animmode_on_guy( guys[ i ], custom_animmode, anime, org, angles );
	}
	
	assertex( isdefined( guys[ 0 ] ), "anim_custom_animmode called without a guy in the array" );
	guys[ 0 ] wait_until_anim_finishes( anime );
	
	self notify( anime );
}

wait_until_anim_finishes( anime )
{
	self endon( "finished_custom_animmode" + anime );
	self waittill( "death" );
}

/*
=============
///ScriptDocBegin
"Name: anim_generic_custom_animmode( <guy> , <custom_animmode> , <anime> , <tag> )"
"Summary: Runs a custom animmode on a level.scr_anim["generic"]  anim."
"Module: _Anim"
"CallOn: An ai"
"MandatoryArg: <guy>: The guy that animates "
"MandatoryArg: <custom_animmode>: The animmode "
"MandatoryArg: <anime>: The anim scene"
"OptionalArg: <tag>: An optional tag that the guy should already be linked to"
"Example: anim_generic_custom_animmode( guy, custom_animmode, anime, tag );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

anim_generic_custom_animmode( guy, custom_animmode, anime, tag )
{
	array = get_anim_position( tag );
	org = array[ "origin" ];
	angles = array[ "angles" ];
	
	thread anim_custom_animmode_on_guy( guy, custom_animmode, anime, org, angles, "generic" );
	guy wait_until_anim_finishes( anime );
	self notify( anime );
}

anim_custom_animmode_solo( guy, custom_animmode, anime, tag )
{
	guys = [];
	guys[ 0 ] = guy;
	anim_custom_animmode( guys, custom_animmode, anime, tag );
}


 /* 
 ============= 
///ScriptDocBegin
"Name: anim_first_frame_solo( <guy> , <scene> , <tag> )"
"Summary: Puts the animating model or AI or vehicle into the first frame of the animated scene. The animation is played relative to the entity that calls the scene"
"Module: _Anim"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <a single thing that animates> : An AI or vehicle or script_model that can animate."
"MandatoryArg: <name of animation scene> : The anime in level.scr_anim[ animname ][ anime ]."
"OptionalArg: <optional tag to attach to> : A tag that the root entity has that the animating entity is attached to."
"Example: node anim_first_frame_solo( guy, "rappel_sequence" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 

anim_first_frame_solo( guy, anime, tag )
{
	guys = [];
	guys[ 0 ] = guy;
	anim_first_frame( guys, anime, tag );
}

assert_existance_of_anim( anime, animname )
{
	if ( !isdefined( animname ) )
		animname = self.animname;
		
	assertex( isdefined( animname ), "Animating character of type " + self.classname + " has no animname." );

	has_anim = false;
	if ( isdefined( level.scr_anim[ animname ] ) )
	{
		has_anim = true;
		if ( isdefined( level.scr_anim[ animname ][ anime ] ) )
		{
			return;
		}
	}
	
	has_sound = false;
	if ( isdefined( level.scr_sound[ animname ] ) )
	{
		has_sound = true;
		if ( isdefined( level.scr_sound[ animname ][ anime ] ) )
		{
			return;
		}
	}

	if ( has_anim || has_sound )
	{	
		if ( has_anim )
		{
			array = getarraykeys( level.scr_anim[ animname ] );
			println( "Legal anime scenes for " + animname + ":" );
			for ( i = 0; i < array.size; i++ )
			{
				println( array[ i ] );
			}
		}
		if ( has_sound )
		{
			array = getarraykeys( level.scr_sound[ animname ] );
			println( "Legal scr_sound scenes for " + animname + ":" );
			for ( i = 0; i < array.size; i++ )
			{
				println( array[ i ] );
			}
		}
		println( "Guy with animname " + animname + " is trying to do scene " + anime + " there is no level.scr_anim or level.scr_sound for that animname" );
		assertmsg( "That scene doesn't exist! See above in console log for details." );
		return;	
	}
	
	keys = getarraykeys( level.scr_anim );
	keys = array_combine( keys, getarraykeys( level.scr_sound ) );
	for ( i = 0; i < keys.size; i++ )
	{
		println( keys[ i ] );
	}
	assertmsg( "Animname " + animname + " is not setup to do animations. See above for list of legal animnames." );
}


anim_first_frame_on_guy( guy, anime, org, angles, animname_override )
{

	guy.first_frame_time = gettime();
	

	if ( isdefined( animname_override ) )
		animname = animname_override;
	else
		animname = guy.animname;

	guy set_start_pos( anime, org, angles, animname );

	/#
	guy assert_existance_of_anim( anime, animname );
	#/
	
	if ( isai( guy ) )
	{
		// ai run a special animscript so they dont bust out
// 		guy teleport( org, angles );
		guy._first_frame_anim = anime;
		guy._animname = animname;
		guy animcustom( animscripts\first_frame::main );
	}
	else
	{
// 		guy.origin = org;
// 		guy.angles = angles;
		guy setanimknob( level.scr_anim[ animname ][ anime ], 1, 0, 0 );
	}
	
	
// 	guy setanim( level.scr_anim[ guy.animname ][ anime ], 1, 0, 0 );
}

anim_custom_animmode_on_guy( guy, custom_animmode, anime, org, angles, animname_override )
{
	animname = undefined;
	if ( isdefined( animname_override ) )
		animname = animname_override;
	else
		animname = guy.animname;

	/#	
	guy assert_existance_of_anim( anime, animname );
	#/

	assertEx( isai( guy ), "Tried to do custom_animmode on a non ai" );
	
	guy set_start_pos( anime, org, angles, animname_override );
	guy._animmode = custom_animmode;
	guy._custom_anim = anime;
	guy._tag_entity = self;
	guy._anime = anime;
	guy._animname = animname;
	guy animcustom( animscripts\animmode::main );
}

anim_loop( guys, anime, tag, ender, entity )
{
	guyPackets = [];
	for ( i = 0; i < guys.size; i ++ )
	{
		packet = [];
		packet[ "guy" ] = guys[ i ];
		packet[ "entity" ] = entity;
		packet[ "tag" ] = tag;
		guyPackets[ guyPackets.size ] = packet;
	}

	anim_loop_packet( guyPackets, anime, ender );
}

anim_loop_packet_solo( singleGuyPacket, anime, ender )
{
	loopPacket = [];
	loopPacket[ 0 ] = singleGuyPacket;
	anim_loop_packet( loopPacket, anime, ender );
}

anim_loop_packet( guyPackets, anime, ender, animname_override )
{
	// disable BCS if we're doing a scripted sequence.
	for ( i = 0; i < guyPackets.size; i ++ )
	{
		guy = guyPackets[ i ][ "guy" ];
		if ( !isdefined( guy ) )
			continue;
			
		if ( !isdefined( guy._animActive ) )
			guy._animActive = 0;// script models cant get their animactive set by init
		
		guy endon( "death" );
		guy._animActive ++ ;
	}
	
	baseGuy = guyPackets[ 0 ][ "guy" ];
 /#
	if ( !isdefined( baseGuy.loops ) )
	{
		baseGuy.loops = 0;
	}

	thread printloops( baseGuy, anime );
#/ 

	if ( !isdefined( ender ) )
		ender = "stop_loop";
		
	// kills notetracks on the guys doing looping anims
	thread endonRemoveAnimActive( ender, guyPackets );
	
	self endon( ender );
/#
	self thread looping_anim_ender( baseGuy, ender );
#/ 
	
	anim_string = "looping anim";

	base_animname = undefined;
	if ( isdefined( animname_override ) )
		base_animname = animname_override;
	else
		base_animname = baseGuy.animname;
	
		
	idleanim = 0;
	lastIdleanim = 0;
	while ( 1 )
	{
		idleanim = anim_weight( base_animname, anime );
		while ( ( idleanim == lastIdleanim ) && ( idleanim != 0 ) )
			idleanim = anim_weight( base_animname, anime );
		lastIdleanim = idleanim;
			
		scriptedAnimationIndex = -1;
		scriptedAnimationTime = 999999;
		
		scriptedSoundIndex = -1;
		for ( i = 0; i < guyPackets.size; i ++ )
		{
			guy = guyPackets[ i ][ "guy" ];
			pos = get_anim_position( guyPackets[ i ][ "tag" ], guyPackets[ i ][ "entity" ] );
			org = pos[ "origin" ];
			angles = pos[ "angles" ];
			entity = guyPackets[ i ][ "entity" ];
			
			doFacialanim = false;
			doDialogue = false;
			doAnimation = false;
			doText = false;
			facialAnim = undefined;
			dialogue = undefined;
			animname = undefined;
			if ( isdefined( animname_override ) )
				animname = animname_override;
			else
				animname = guy.animname;
			
			if ( ( isdefined( level.scr_face[ animname ] ) ) && 
				( isdefined( level.scr_face[ animname ][ anime ] ) ) && 
				( isdefined( level.scr_face[ animname ][ anime ][ idleanim ] ) ) )
			{
				doFacialanim = true;
				facialAnim = level.scr_face[ animname ][ anime ][ idleanim ];
			}
	
			if ( ( isdefined( level.scr_sound[ animname ] ) ) && 
				( isdefined( level.scr_sound[ animname ][ anime ] ) ) && 
				( isdefined( level.scr_sound[ animname ][ anime ][ idleanim ] ) ) )
			{
				doDialogue = true;
				dialogue = level.scr_sound[ animname ][ anime ][ idleanim ];
			}
	
			if ( isdefined( level.scr_animSound[ animname ] ) && 
				 isdefined( level.scr_animSound[ animname ][ idleanim + anime ] ) )
			{
				guy playsound( level.scr_animSound[ animname ][ idleanim + anime ] );
			}
			 /* 
			 /#
			if ( getdebugdvar( "animsound" ) == "on" )
			{
				guy thread animsound_start_tracker( anime );
			}
			#/ 
			 */ 

			 /#
			if ( getdebugdvar( "animsound" ) == "on" )
			{
				guy thread animsound_start_tracker_loop( anime, idleanim, animname );
			}
// 			guy thread animsound_start_tracker( anime );
			#/ 

			if ( ( isdefined( level.scr_anim[ animname ] ) ) && 
				( isdefined( level.scr_anim[ animname ][ anime ] ) ) )
				doAnimation = true;

			 /#
			if ( ( isdefined( level.scr_text[ animname ] ) ) && 
				( isdefined( level.scr_text[ animname ][ anime ] ) ) )
				doText = true;
			#/ 
				
			
			if ( doAnimation )
			{
				if ( guy.classname == "script_vehicle" )
				{
					// vehicles use generic anim commands
					guy.origin = org;
					guy.angles = angles;
					guy setflaggedanimknob( anim_string, level.scr_anim[ animname ][ anime ][ idleanim ], 1, 0.2, 1 );
				}
				else
				{
					// ai and models use animscripted
					guy last_anim_time_check();
					guy animscripted( anim_string, org, angles, level.scr_anim[ animname ][ anime ][ idleanim ] );
				}
				
				animtime = getanimlength( level.scr_anim[ animname ][ anime ][ idleanim ] );
				if ( animtime < scriptedAnimationTime )
				{
					scriptedAnimationTime = animtime;
					scriptedAnimationIndex = i;
				}
	
				thread start_notetrack_wait( guy, anim_string, anime, animname );

				thread animscriptDoNoteTracksThread( guy, anim_string, anime );
			}

			if ( ( doFacialanim ) || ( doDialogue ) )
			{
// 				println( "dofacialanim: ", dofacialanim, " and dodialogue: ", dodialogue );
// 				println( "^3 Animname: ", guy[ i ].animname, " doing animation ", anime, " facial: ", facialanim, " dialogue: ", dialogue );

				if ( isai( guy ) )
				{
					if ( doAnimation )
						guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );
					else
						guy SaySpecificDialogue( facialAnim, dialogue, 1.0, anim_string );
				}
				else
				{
					guy play_sound_on_entity( dialogue );
				}
					
				scriptedSoundIndex = i;
			}
			
			/#
			if ( doText && !doDialogue )
				iprintlnBold( level.scr_text[ animname ][ anime ] );
	
// 			add_animation( animname, anime );
			#/ 
		}
	
		if ( scriptedAnimationIndex != -1 )
			guyPackets[ scriptedAnimationIndex ][ "guy" ] waittillmatch( anim_string, "end" );
		else
		if ( scriptedSoundIndex != -1 )
			guyPackets[ scriptedSoundIndex ][ "guy" ] waittill( anim_string );
	}
}

start_notetrack_wait( guy, anim_string, anime, animname )
{
	guy notify( "stop_sequencing_notetracks" );
	
	thread notetrack_wait( guy, anim_string, self, anime, animname );
}

anim_single_failsafeOnGuy( owner, anime )
{
	 /#
	if ( getdebugdvar( "debug_grenadehand" ) != "on" )
		return;

	owner endon( anime );
	owner endon( "death" );
	self endon( "death" );
	name = self.classname;
	num = self getentnum();
	wait( 60 );
	println( "Guy had classname " + name + " and entnum " + num );
	waittillframeend;
	assertEx( 0, "Animation '" + anime + "' did not finish after 60 seconds. See note above" );
	#/ 
	
}

anim_single_failsafe( guy, anime )
{
// 	 /#
// 	self endon( anime );
// 	self endon( "death" );
	for ( i = 0;i < guy.size;i ++ )
		guy[ i ] thread anim_single_failsafeOnGuy( self, anime );
	 /* 
	guyName = [];
	guyNum = [];
	for ( i = 0;i < guy.size;i ++ )
	{
		guyName[ i ] = guy[ i ].classname;
		guyNum[ i ] = guy[ i ] getentnum();
	}
	
	wait( 60 );
	println( " ============ solo ran > 60 seconds from anim: ", anime );
	for ( i = 0;i < guy.size;i ++ )
	{
		println( "Guy with classname " + guyName[ i ] + " and entnum " + guyNum[ i ] );
	}
	assertEx( 0, "Animation '" + anime + "' did not finish after 60 seconds. See note above" );
	#/ 
	 */ 
}


anim_single( guys, anime, tag, node, tag_entity, animname_override )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	
	 /#
	thread anim_single_failsafe( guys, anime );
	#/ 
	// disable BCS if we're doing a scripted sequence.
	for ( i = 0;i < guys.size;i ++ )
	{
		if ( !isdefined( guys[ i ] ) )
			continue;
		if ( !isdefined( guys[ i ]._animActive ) )
			guys[ i ]._animActive = 0;// script models cant get their animactive set by init
		guys[ i ]._animActive ++ ;
	}

	pos = get_anim_position( tag, entity );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	scriptedAnimationIndex = -1;
	scriptedAnimationTime = 999999;
	
	scriptedSoundIndex = -1;
	scriptedFaceIndex = -1;
	anim_string = "single anim";
	
	for ( i = 0; i < guys.size; i++ )
	{
		guy = guys[ i ];
		doFacialanim = false;
		doDialogue = false;
		doAnimation = false;
		doText = false;
		doLook = false;

		dialogue = undefined;
		facialAnim = undefined;
		
		animname = undefined;
		if ( isdefined( animname_override ) )
			animname = animname_override;
		else
			animname = guy.animname;
		
		/#
		guy assert_existance_of_anim( anime, animname );
		#/

		if ( ( isdefined( level.scr_face[ animname ] ) ) && 
			( isdefined( level.scr_face[ animname ][ anime ] ) ) )
		{
			doFacialanim = true;
			facialAnim = level.scr_face[ animname ][ anime ];
		}
 /* 			
		if ( animname  == "sniper" )
			println( "anime ", anime, " facial: ", level.scr_face[ animname ][ anime ] ); 
		println( facialanim );
 */ 

		if ( ( isdefined( level.scr_sound[ animname ] ) ) && 
			( isdefined( level.scr_sound[ animname ][ anime ] ) ) )
		{
			doDialogue = true;
			dialogue = level.scr_sound[ animname ][ anime ];
		}

		if ( ( isdefined( level.scr_anim[ animname ] ) ) && 
			( isdefined( level.scr_anim[ animname ][ anime ] ) ) )
			doAnimation = true;

		if ( ( isdefined( level.scr_look[ animname ] ) ) && 
			( isdefined( level.scr_look[ animname ][ anime ] ) ) )
			doLook = true;

		if ( isdefined( level.scr_animSound[ animname ] ) && 
			 isdefined( level.scr_animSound[ animname ][ anime ] ) )
		{
			guy playsound( level.scr_animSound[ animname ][ anime ] );
		}

		 /#
		if ( getdebugdvar( "animsound" ) == "on" )
		{
			guy thread animsound_start_tracker( anime, animname );
		}
		#/ 
		

		 /#
		if ( ( isdefined( level.scr_text[ animname ] ) ) && 
			( isdefined( level.scr_text[ animname ][ anime ] ) ) )
			doText = true;
		#/ 
	
		if ( doAnimation )
		{
			if ( guy.classname == "script_vehicle" )
			{
				veh_org = getstartorigin( org, angles, level.scr_anim[ animname ][ anime ] );
				veh_ang = getstartangles( org, angles, level.scr_anim[ animname ][ anime ] );
				// vehicles use generic anim commands
				guy.origin = veh_org;
				guy.angles = veh_ang;
				guy setflaggedanimknob( anim_string, level.scr_anim[ animname ][ anime ], 1, 0.2, 1 );
			}
			else
			{
				// ai and models use animscripted
				guy last_anim_time_check();
				guy animscripted( anim_string, org, angles, level.scr_anim[ animname ][ anime ] );
			}
			
			animtime = getanimlength( level.scr_anim[ animname ][ anime ] );
			if ( animtime < scriptedAnimationTime )
			{
				scriptedAnimationTime = animtime;
				scriptedAnimationIndex = i;
			}

			thread start_notetrack_wait( guy, anim_string, anime, animname );
			thread animscriptDoNoteTracksThread( guy, anim_string, anime );
		}
		if ( doLook )
		{
			assertEx( doAnimation, "Look animation " + anime + " for animname " +  animname  + " does not have a base animation" );
			// blend 2 animations so the guy can look at the player
			thread anim_look( guy, anime, level.scr_look[ animname ][ anime ] );
		}

		
// 		println( "^a SOUND time ", dialogue );
		if ( ( doFacialanim ) || ( doDialogue ) )
		{
// 			println( animname, " facialanim ", facialanim );
			if ( doFacialAnim )
			{
				if ( doDialogue )
					guy thread delayedDialogue( anime, doFacialanim, dialogue, level.scr_face[ animname ][ anime ] );
				assertEx( !doanimation, "Can't play a facial anim and fullbody anim at the same time. The facial anim should be in the full body anim. Occurred on animation " + anime );
				thread anim_facialAnim( guy, anime, level.scr_face[ animname ][ anime ] );
				scriptedFaceIndex = i;
			}
			else
			{
				if ( isai( guy ) )
				{
					if ( doAnimation )
						guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );
					else
					{
						guy thread anim_facialFiller( "single dialogue" );
						guy SaySpecificDialogue( facialAnim, dialogue, 1.0, "single dialogue" );
					}
				}
				else
				{
					guy play_sound_on_entity( dialogue );
				}
			}
			
			scriptedSoundIndex = i;
// 			println( "facial sound ", dialogue );
		}
		assertEx( doAnimation || doLook || doFacialanim || doDialogue || doText, "Tried to do anim scene " + anime + " on guy with animname " + animname + ", but he didn't have that anim scene." );

// 		add_animation( animname, anime );

		 /#
		if ( doText && !doDialogue )
		{
			iprintlnBold( level.scr_text[ animname ][ anime ] );
			wait 1.5;
		}
		#/ 
	}


	if ( scriptedAnimationIndex != -1 )
	{
// 		guy[ scriptedAnimationIndex ] endon( "death" );	
		ent = spawnstruct();
		ent thread anim_deathNotify( guys[ scriptedAnimationIndex ], anime );
		ent thread anim_animationEndNotify( guys[ scriptedAnimationIndex ], anime );
		ent waittill( anime );
// 		guy[ scriptedAnimationIndex ] waittillmatch( "single anim", "end" );
	}
	else
	if ( scriptedFaceIndex != -1 )
	{
		ent = spawnstruct();
		ent thread anim_deathNotify( guys[ scriptedFaceIndex ], anime );
		ent thread anim_facialEndNotify( guys[ scriptedFaceIndex ], anime );
		ent waittill( anime );
	}
	else
	if ( scriptedSoundIndex != -1 )
	{
// 		guy[ scriptedSoundIndex ] endon( "death" );
		ent = spawnstruct();
		ent thread anim_deathNotify( guys[ scriptedSoundIndex ], anime );
		ent thread anim_dialogueEndNotify( guys[ scriptedSoundIndex ], anime );
		ent waittill( anime );
// 		guy[ scriptedSoundIndex ] waittill( "single dialogue" );
	}
		
	for ( i = 0;i < guys.size;i ++ )
	{
		if ( !isdefined( guys[ i ] ) )
			continue;
		guys[ i ]._animActive -- ;
		guys[ i ]._lastAnimTime = getTime();
		assert( guys[ i ]._animactive >= 0 );
	}
	self notify( anime );
}

anim_deathNotify( guy, anime )
{
	self endon( anime );
	guy waittill( "death" );
	self notify( anime );
}


anim_facialEndNotify( guy, anime )
{
	self endon( anime );
	guy waittillmatch( "face_done_" + anime, "end" );
	self notify( anime );
}

anim_dialogueEndNotify( guy, anime )
{
	self endon( anime );
	guy waittill( "single dialogue" );
	self notify( anime );
}

anim_animationEndNotify( guy, anime )
{
	self endon( anime );
	guy waittillmatch( "single anim", "end" );
	self notify( anime );
}

animscriptDoNoteTracksThread( guy, animstring, anime )
{
	guy endon( "stop_sequencing_notetracks" );
	guy endon( "death" );
	guy DoNoteTracks( animstring );
}

add_animsound( newSound )
{
	// find a vacant slot in the array
	for ( i = 0; i < level.animsound_hudlimit; i ++ )
	{
		if ( isdefined( self.animsounds[ i ] ) )
		{
			continue;
		}
		self.animSounds[ i ] = newSound;
		return;
	}

	// replace the oldest one
	keys = getarraykeys( self.animsounds );
	index = keys[ 0 ];
	timer = self.animsounds[ index ].end_time;
	for ( i = 1; i < keys.size; i ++ )
	{
		key = keys[ i ];
		
		if ( self.animsounds[ key ].end_time < timer )
		{
			timer = self.animsounds[ key ].end_time;
			index = key;
		}
	}
	
	self.animSounds[ index ] = newSound;
}

animSound_exists( anime, notetrack )
{
	keys = getarraykeys( self.animSounds );
	for ( i = 0; i < keys.size; i ++ )
	{
		key = keys[ i ];
		if ( self.animSounds[ key ].anime != anime )
			continue;
		if ( self.animSounds[ key ].notetrack != notetrack )
			continue;
		// up its time since it was hit again
		self.animSounds[ key ].end_time = gettime() + 60000;
		return true;
	}
	return false;
}


animsound_tracker( anime, notetrack, animname )
{
	add_to_animsound();
		
	if ( notetrack == "end" )
		return;
	
	if ( animSound_exists( anime, notetrack ) )
		return;
	
	newTrack = spawnStruct();
	newTrack.anime = anime;
	newTrack.notetrack = notetrack;
	newTrack.animname = animname;
	newTrack.end_time = gettime() + 60000;
	
	add_animsound( newTrack );
}

animsound_start_tracker( anime, animname )
{
	// tracks the start of every animation or sound call
	// so sound can attach a sound at that time

	add_to_animsound();
	
	newSound = spawnStruct();
	newSound.anime = anime;
	newSound.notetrack = "#" + anime;
	newSound.animname = animname;
	newSound.end_time = gettime() + 60000;

	if ( animSound_exists( anime, newSound.notetrack ) )
		return;
	
	add_animsound( newSound );
}

animsound_start_tracker_loop( anime, loop, animname )
{
	// tracks the start of every animation or sound call
	// so sound can attach a sound at that time

	add_to_animsound();

	anime = loop + anime;
	newSound = spawnStruct();
	newSound.anime = anime;
	newSound.notetrack = "#" + anime;
	newSound.animname = animname;
	newSound.end_time = gettime() + 60000;

	if ( animSound_exists( anime, newSound.notetrack ) )
		return;
	
	add_animsound( newSound );
}

notetrack_wait( guy, msg, tag_entity, anime, animname_override )
{
	guy endon( "stop_sequencing_notetracks" );
	guy endon( "death" );
	
// 	self endon( ender );
	if ( isdefined( tag_entity ) )
		tag_owner = tag_entity;
	else
		tag_owner = self;

	animname = undefined;
	if ( isdefined( animname_override ) )
		animname = animname_override;
	else
		animname = guy.animname;

	dialogue_array = [];
	has_scripted_notetracks = isdefined( level.scr_notetrack[ animname ] );
	if ( has_scripted_notetracks )
	{
		for ( i = 0; i < level.scr_notetrack[ animname ].size; i ++ )
		{
			scr_notetrack = level.scr_notetrack[ animname ][ i ];
			if ( isdefined( scr_notetrack[ "dialog" ] ) )
				dialogue_array[ scr_notetrack[ "dialog" ] ] = true;
		}
	}

	while ( 1 )
	{
		dialogueNotetrack = false;

		guy waittill( msg, notetrack );
		
		/#
		if ( getdebugdvar( "animsound" ) == "on" )
		{
			guy thread animsound_tracker( anime, notetrack, animname );
		}
		#/ 
		
		if ( notetrack == "end" )
			return;

		if ( has_scripted_notetracks )
		{
			for ( i = 0;i < level.scr_notetrack[ animname ].size;i ++ )
			{
				scr_notetrack = level.scr_notetrack[ animname ][ i ];
				if ( notetrack == scr_notetrack[ "notetrack" ] )
				{
					if ( scr_notetrack[ "anime" ] != "any" && scr_notetrack[ "anime" ] != anime )
					{
						// only play the sound if the notetrack is the same or if its "any"
						continue;
					}
				
					if ( isdefined( scr_notetrack[ "function" ] ) )
						self thread [[ scr_notetrack[ "function" ] ]]( guy );
				
					if ( isdefined( level.scr_notetrack[  animname  ][ i ][ "flag" ] ) )
					{
						flag_set( level.scr_notetrack[  animname  ][ i ][ "flag" ] );
					}
				
					if ( isdefined( scr_notetrack[ "attach gun left" ] ) )
					{
						guy gun_pickup_left();
						continue;
					}
		
					if ( isdefined( scr_notetrack[ "attach gun right" ] ) )
					{
						guy gun_pickup_right();
						continue;
					}
					
					if ( isdefined( scr_notetrack[ "detach gun" ] ) )
					{
						self gun_leave_behind( guy, scr_notetrack );
						continue;
					}
	
					if ( isdefined( scr_notetrack[ "swap from" ] ) )
					{
						guy detach( guy.swapWeapon, scr_notetrack[ "swap from" ] );
						guy attach( guy.swapWeapon, scr_notetrack[ "self tag" ] );
						continue;
					}
	
					if ( isdefined( scr_notetrack[ "attach model" ] ) )
					{
						if ( isdefined( scr_notetrack[ "selftag" ] ) )
							guy attach( scr_notetrack[ "attach model" ], scr_notetrack[ "selftag" ] );
						else
							tag_owner attach( scr_notetrack[ "attach model" ], scr_notetrack[ "tag" ] );
	
						continue;
					}
	
					if ( isdefined( scr_notetrack[ "detach model" ] ) )
					{
						waittillframeend;// because this should come after any attachs that happen on the same frame
						if ( isdefined( scr_notetrack[ "selftag" ] ) )
							guy detach( scr_notetrack[ "detach model" ], scr_notetrack[ "selftag" ] );
						else
							tag_owner detach( scr_notetrack[ "detach model" ], scr_notetrack[ "tag" ] );
					}
	
					if ( isdefined( scr_notetrack[ "sound" ] ) )
						guy thread play_sound_on_tag( scr_notetrack[ "sound" ], undefined, true );
	
					// dialogueNotetrack keeps it from playing more then one dialogue on a "dialog" notetrack at the same time.
					// it will play the next dialogue on the next "dialog" notetrack if there are more then one in the animation.
					if ( !dialogueNotetrack )
					{
						if ( isdefined( scr_notetrack[ "dialog" ] ) &&  isdefined( dialogue_array[ scr_notetrack[ "dialog" ] ] ) )
						{
							anim_facial( guy, i, "dialog", animname );
							dialogue_array[ scr_notetrack[ "dialog" ] ] = undefined;
							dialogueNotetrack = true;
						}
					}
	
	 /* 				if ( !dialogueNotetrack )
					{
						if ( isdefined( scr_notetrack[ "dialog" ] ) )
						{
							anim_facial( guy, i, "dialog", animname );
							dialogueNotetrack = true;
						}
					}
	 */ 
					if ( isdefined( scr_notetrack[ "create model" ] ) )
						anim_addModel( guy, scr_notetrack );
					else
					if ( isdefined( scr_notetrack[ "delete model" ] ) )
						anim_removeModel( guy, scr_notetrack );
	
					if ( ( isdefined( scr_notetrack[ "selftag" ] ) ) && 
					( isdefined( scr_notetrack[ "effect" ] ) ) )
					{
						playfxOnTag( 
						level._effect[ scr_notetrack[ "effect" ] ], guy, 
						scr_notetrack[ "selftag" ] );
					}
	
					if ( isdefined( scr_notetrack[ "tag" ] ) && isdefined( scr_notetrack[ "effect" ] ) )
					{
						playfxOnTag( level._effect[ scr_notetrack[ "effect" ] ], tag_owner, scr_notetrack[ "tag" ] );
					}
					
					if ( isdefined( level.scr_special_notetrack[ animname ] ) )
					{
						tag = random( level.scr_special_notetrack[ animname ] );
						if ( isdefined( tag[ "tag" ] ) )
							playfxOnTag( level._effect[ tag[ "effect" ] ], tag_owner, tag[ "tag" ] );
						else
						if ( isdefined( tag[ "selftag" ] ) )
							playfxOnTag( level._effect[ tag[ "effect" ] ], self, 	tag[ "tag" ] );
					}				
				}
			}
		}

		prefix = getsubstr( notetrack, 0, 3 );
	
		if ( prefix == "ps_" )
		{
			alias = getsubstr( notetrack, 3 );
		
			guy thread play_sound_on_tag( alias, undefined, true );
		}
	}
}

anim_addModel( guy, array )
{
	if ( !isdefined( guy.ScriptModel ) )
		guy.ScriptModel = [];
		
	index = guy.ScriptModel.size;
	guy.ScriptModel[ index ] = spawn( "script_model", ( 0, 0, 0 ) );
	guy.ScriptModel[ index ] setmodel( array[ "create model" ] );
	guy.ScriptModel[ index ].origin = guy gettagOrigin( array[ "selftag" ] );
	guy.ScriptModel[ index ].angles = guy gettagAngles( array[ "selftag" ] );
}	

anim_removeModel( guy, array )
{
 /#
	if ( !isdefined( guy.ScriptModel ) )
		assertMsg( "Tried to remove a model with delete model before it was create model'd on guy: " + guy.animname );
#/ 

	for ( i = 0;i < guy.ScriptModel.size;i ++ )
	{
		if ( isdefined( array[ "explosion" ] ) )
		{
			forward = anglesToForward( guy.scriptModel[ i ].angles );
			forward = vectorScale( forward, 120 );
			forward += guy.scriptModel[ i ].origin;
			playfx( level._effect[ array[ "explosion" ] ], guy.scriptModel[ i ].origin );// , guy.scriptModel.origin, forward );
			radiusDamage( guy.scriptModel[ i ].origin, 350, 700, 50 );
		}
		guy.scriptModel[ i ] delete();
	}
}

anim_facial( guy, i, dialogueString, animname )
{
	facialAnim = undefined;
	if ( isdefined( level.scr_notetrack[ animname ][ i ][ "facial" ] ) )
		facialAnim = level.scr_notetrack[ animname ][ i ][ "facial" ];

	dialogue = level.scr_notetrack[ animname ][ i ][ dialogueString ];
		
	guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );
}

gun_pickup_left()
{
	if ( !isdefined( self.gun_on_ground ) )
		return;

	self.gun_on_ground delete();
	self.dropWeapon = true;
// 	println( "dropweapon is ", self.dropweapon );

	self animscripts\shared::placeWeaponOn( self.weapon, "left" );
}

gun_pickup_right()
{
	if ( !isdefined( self.gun_on_ground ) )
		return;

	self.gun_on_ground delete();
	self.dropWeapon = true;
// 	println( "dropweapon is ", self.dropweapon );
	
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}

gun_leave_behind( guy, scr_notetrack )
{
	if ( isdefined( guy.gun_on_ground ) )
		return;

	link = true;

	if ( self == guy )
		link = false;

	gun = spawn( "weapon_" + guy.weapon, ( 0, 0, 0 ) );
	
	guy.gun_on_ground = gun;
	gun.origin = self gettagOrigin( scr_notetrack[ "tag" ] );
	gun.angles = self gettagAngles( scr_notetrack[ "tag" ] );

	if ( link )
		gun linkto( self, scr_notetrack[ "tag" ], ( 0, 0, 0 ), ( 0, 0, 0 ) );
	else
	{
		org = spawn( "script_origin", ( 0, 0, 0 ) );
		org.origin = gun.origin;
		org.angles = gun.angles;
		level thread gun_killOrigin( gun, org );
	}
	
	guy animscripts\shared::placeWeaponOn( self.weapon, "none" );
	guy.dropWeapon = false;
}

gun_killOrigin( gun, org )
{
	gun waittill( "death" );
	org delete();
}



anim_weight( animname, anime )
{
	total_anims = level.scr_anim[ animname ][ anime ].size;
	idleanim = randomint( total_anims );
	if ( total_anims > 1 )
	{
		weights = 0;
		anim_weight = 0;
		
		for ( i = 0;i < total_anims;i ++ )
		{
			if ( isdefined( level.scr_anim[ animname ][ anime + "weight" ] ) )
			{
				if ( isdefined( level.scr_anim[ animname ][ anime + "weight" ][ i ] ) )
				{
					weights ++ ;
					anim_weight += level.scr_anim[ animname ][ anime + "weight" ][ i ];
				}
			}
		}
		
		if ( weights == total_anims )
		{
			anim_play = randomfloat( anim_weight );
			anim_weight	 = 0;
			
			for ( i = 0;i < total_anims;i ++ )
			{
				anim_weight += level.scr_anim[ animname ][ anime + "weight" ][ i ];
				if ( anim_play < anim_weight )
				{
					idleanim = i;
					break;
				}
			}
		}
	}
	
	return idleanim;
}		

convert_tagent_to_ent( node, tag_entity )
{
	if ( isdefined( tag_entity ) )
	{
		return tag_entity;
	}
	return node;
}

anim_reach_and_idle( guy, anime, anime_idle, ender, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	thread anim_reach( guy, anime, tag, entity );
	
	ent = spawnstruct();
	ent.reachers = 0;
	for ( i = 0; i < guy.size; i ++ )
	{
		ent.reachers ++ ;
		thread idle_on_reach( guy[ i ], anime_idle, ender, tag, entity, ent );
	}
	
	for ( ;; )
	{
		ent waittill( "reached_position" );
		if ( ent.reachers <= 0 )
			return;
	}
}

wait_for_guy_to_die_or_get_in_position()
{
	self endon( "death" );
	self waittill( "anim_reach_complete" );
}

idle_on_reach( guy, anime_idle, ender, tag, entity, ent )
{
	guy wait_for_guy_to_die_or_get_in_position();
	ent.reachers -- ;
	ent notify( "reached_position" );

	if ( isalive( guy ) )	
		anim_loop_solo( guy, anime_idle, tag, ender, entity );
}

get_anim_position( tag, entity )
{
	org = undefined;
	angles = undefined;
	if ( isdefined( tag ) )
	{
		if ( isdefined( entity ) )
		{
			org = entity gettagOrigin( tag );
			angles = entity gettagAngles( tag );
		}
		else
		{
			org = self gettagOrigin( tag );
			angles = self gettagAngles( tag );
		}
	}
	else
	if ( isdefined( entity ) )
	{
		org = entity.origin;
		angles = entity.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}
	
	array = [];
	array[ "angles" ] = angles;
	array[ "origin" ] = org;
	return array;
}



anim_reach( guys, anime, tag, node, tag_entity, animname_override )
{
	// include the standard begin and end reach functions
	anim_reach_with_funcs( guys, anime, tag, node, tag_entity, animname_override, ::reach_with_standard_adjustments_begin, ::reach_with_standard_adjustments_end );
}
	
anim_reach_with_funcs( guys, anime, tag, node, tag_entity, animname_override, start_func, end_func )
{
	entity = convert_tagent_to_ent( node, tag_entity );
// 	println( guy[ 0 ].animname, " doing animation ", anime );
	array = get_anim_position( tag, entity );
	org = array[ "origin" ];
	angles = array[ "angles" ];

	ent = spawnstruct();
	debugStartpos = false;
	 /#
	debugStartpos = getdebugdvar( "debug_animreach" ) ==  "on";
	#/ 
	threads = 0;
	for ( i = 0; i < guys.size; i ++ )
	{
		// If there is an animation with this anime then reach the starting spot for that animation
		// otherwise run to the node
		
		guy = guys[ i ];

		if ( isdefined( animname_override ) )
			animname = animname_override;
		else
			animname = guy.animname;
		
		if ( isdefined( level.scr_anim[ animname ][ anime ] ) )
		{
			startorg = getstartOrigin( org, angles, level.scr_anim[ animname ][ anime ] );
		}
		else
		{
			startorg = org;
		}
			
		 /#
		if ( debugStartpos )
			thread debug_message_clear( "x", startorg, 1000, "clearAnimDebug" );
		#/ 
		threads ++ ;
		guy thread begin_anim_reach( ent, startOrg, start_func, end_func );
	}
	
	while ( threads )
	{
		ent waittill( "reach_notify" );
		threads -- ;
	}
	 /#
	if ( debugStartpos )
		level notify( "x" + "clearAnimDebug" );
	#/ 
	
	for ( i = 0;i < guys.size;i ++ )
	{
		if ( isalive( guys[ i ] ) )
			guys[ i ].goalradius = guys[ i ].oldgoalradius;
	}
}

anim_teleport( guy, anime, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	pos = get_anim_position( tag, entity );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	ent = spawnstruct();

	for ( i = 0;i < guy.size;i ++ )
	{
		startorg = getstartOrigin( org, angles, level.scr_anim[ guy[ i ].animname ][ anime ] );
		if ( isSentient( guy[ i ] ) )
			guy[ i ] teleport( startorg );
		else
			guy[ i ].origin = startorg;
	}
}

anim_spawner_teleport( guy, anime, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	pos = get_anim_position( tag, entity );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	ent = spawnstruct();

	for ( i = 0; i < guy.size; i ++ )
	{
		startorg = getstartOrigin( org, angles, level.scr_anim[ guy[ i ].animname ][ anime ] );
		guy[ i ].origin = startorg;
	}
}

reach_death_notify( ent )
{
	self waittill_either( "death", "goal" );
	ent notify( "reach_notify" );
}

begin_anim_reach( ent, startOrg, start_func, end_func )
{
	self endon( "death" );
	self endon( "new_anim_reach" );
	thread reach_death_notify( ent );
	startorg = [[ start_func ]]( startorg );

	self set_goal_pos( startorg );
	self.goalradius = 0;

	self waittill( "goal" );

	self notify( "anim_reach_complete" );
	
	[[ end_func ]]();
	
	self notify( "new_anim_reach" );
}

reach_with_standard_adjustments_begin( startorg )
{
	self.oldgoalradius = self.goalradius;
	self.oldpathenemyFightdist = self.pathenemyFightdist;
	self.oldpathenemyLookahead = self.pathenemyLookahead;
	self.pathenemyFightdist = 128;
	self.pathenemyLookahead = 128;
	disable_ai_color();
	self pushPlayer( true );
	self.nododgemove = true;
	self.fixedNodeWasOn = self.fixedNode;
	self.fixedNode = false;
	self.disableArrivals = true;
	return startorg;
}

reach_with_standard_adjustments_end()
{
	self pushPlayer( false );
	self.nododgemove = false;
	self.fixedNode = self.fixedNodeWasOn;
	self.fixedNodeWasOn = undefined;
	
	self.pathenemyFightdist = self.oldpathenemyFightdist;
	self.pathenemyLookahead = self.oldpathenemyLookahead;
	self.disableArrivals = false;
}

reach_with_arrivals_begin( startorg )
{
	startorg = reach_with_standard_adjustments_begin( startorg );
	self.disableArrivals = false;
	return startorg;
}

reach_with_planting( startorg )
{
	startorg = PhysicsTrace( startorg + (0,0,5 ), startorg + (0,0,-64 ) );
	startorg = reach_with_standard_adjustments_begin( startorg );
	self.disableArrivals = false;
	return startorg;
}

 /#
printloops( guy, anime )
{
// 	wait( 0.05 );
	if ( !isdefined( guy ) )
		return;

	guy endon( "death" );// could die during the frame
	waittillframeend;// delay a frame so if you end a loop with a notify then start a new loop, this guarentees that 
	                 // the 2nd loop doesnt start before the loop decrementer receives the same notify that ended the first loop
	guy.loops ++ ;
	if ( guy.loops > 1 )
		assertMsg( "guy with name " + guy.animname + " has " + guy.loops + " looping animations played, anime: " + anime );
}

looping_anim_ender( guy, ender )
{
	guy endon( "death" );
	self waittill( ender );
	guy.loops -- ;
}
#/ 

get_animtree( guy )
{
	for ( i = 0;i < guy.size;i ++ )
		guy[ i ] UseAnimTree( level.scr_animtree[ guy[ i ].animname ] );
}

SetAnimTree()
{
	self UseAnimTree( level.scr_animtree[ self.animname ] );
}

/*
=============
///ScriptDocBegin
"Name: anim_single_solo( <guy> , <anime> , <tag> , <entity> , <tag_entity> )"
"Summary: Do an anim on a guy from level.scr_anim[ animname ][ anime ]"
"Module: Anim"
"CallOn: The base for an animation scene, such as a node"
"MandatoryArg: <guy>: Guy that animates"
"MandatoryArg: <anime>: Animation scene Scene"
"OptionalArg: <tag>: A tag to animate relative to"
"OptionalArg: <entity>: Overwrite the scene base"
"OptionalArg: <tag_entity>: Overwrite the base for the tag"
"Example: level.price anim_single_solo( level.price, "whip_it_good" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
anim_single_solo( guy, anime, tag, entity, tag_entity )
{
	if ( isdefined( tag_entity ) )
	{
		entity = tag_entity;
	}
	
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_single( newguy, anime, tag, entity );
}

anim_reach_and_idle_solo( guy, anime, anime_idle, ender, tag, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_reach_and_idle( newguy, anime, anime_idle, ender, tag, node, tag_entity );
}

anim_reach_solo( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_reach( newguy, anime, tag, node, tag_entity );
}

anim_reach_and_approach_solo( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_reach_and_approach( newguy, anime, tag, node, tag_entity );
}

anim_reach_and_approach( guys, anime, tag, node, tag_entity )
{
	self endon( "death" );

	anim_reach_with_funcs( guys, anime, tag, node, tag_entity, undefined, ::reach_with_arrivals_begin, ::reach_with_standard_adjustments_end );
}

enable_arrivals()
{
	self endon( "death" );
	// wait until after reach has turned arrivals off
	waittillframeend;
	self.disableArrivals = undefined;
}


anim_loop_solo( guy, anime, tag, ender, entity )
{
	self endon( "death" );
	guy endon( "death" );

	newguy[ 0 ] = guy;
	anim_loop( newguy, anime, tag, ender, entity );
}

anim_teleport_solo( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );
	
	newguy[ 0 ] = guy;
	anim_teleport( newguy, anime, tag, node, tag_entity );
}

anim_single_solo_debug( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_single_debug( newguy, anime, tag, node, tag_entity );
}

anim_loop_solo_debug( guy, anime, tag, ender, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_loop_debug( newguy, anime, tag, ender, node, tag_entity );
}

anim_loop_debug( guy, anime, tag, ender, node, tag_entity )
{
	println( "^cDebugging looping animation ", anime, ":" );
	println( "Tag: ", tag );
	println( "Ender: ", ender );
	println( "Node: ", node );
	println( "Tag_entity: ", tag_entity );
	println( "Entity calling loop: ", self, ", classname: ", self.classname );
	
	for ( i = 0;i < guy.size;i ++ )
	{
		if ( isdefined( guy[ i ] ) )
			continue;
			
		println( "Array entree ", i, " was undefined, can't completel looping animation" );
	}
	
	if ( isdefined( tag ) )
	{
		if ( isdefined( tag_entity ) )
		{
			org = tag_entity gettagOrigin( tag );
			angles = tag_entity gettagAngles( tag );
		}
		else
		{
			org = self gettagOrigin( tag );
			angles = self gettagAngles( tag );
		}
	}
	else
	if ( isdefined( node ) )
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}
	
	if ( !isdefined( angles ) )
		println( "No ANGLES, means you probably have the world calling this thread, meaning you probably misspelled your node." );
	anim_loop( guy, anime, tag, ender, node, tag_entity );
}

anim_single_debug( guy, anime, tag, node, tag_entity )
{
	println( "^cDebugging single animation ", anime, ":" );
	println( "Tag: ", tag );
	println( "Node: ", node );
	println( "Tag_entity: ", tag_entity );
	println( "Entity calling loop: ", self, ", classname: ", self.classname );
	
	for ( i = 0;i < guy.size;i ++ )
	{
		if ( isdefined( guy[ i ] ) )
			continue;
			
		println( "Array entree ", i, " was undefined, can't completel looping animation" );
	}
	
	if ( isdefined( tag ) )
	{
		if ( isdefined( tag_entity ) )
		{
			org = tag_entity gettagOrigin( tag );
			angles = tag_entity gettagAngles( tag );
		}
		else
		{
			org = self gettagOrigin( tag );
			angles = self gettagAngles( tag );
		}
	}
	else
	if ( isdefined( node ) )
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}
	
	if ( !isdefined( angles ) )
		println( "No ANGLES, means you probably have the world calling this thread, meaning you probably misspelled your node." );
	anim_single( guy, anime, tag, node, tag_entity );
}

add_animation( animname, anime )
{
	if ( !isdefined( level.completedAnims ) )
		level.completedAnims[ animname ][ 0 ] = anime;
	else
	{
		if ( !isdefined( level.completedAnims[ animname ] ) )
			level.completedAnims[ animname ][ 0 ] = anime;
		else
		{
			for ( i = 0;i < level.completedAnims[ animname ].size;i ++ )
			{
				if ( level.completedAnims[ animname ][ i ] == anime )
					return;
			}
			
			level.completedAnims[ animname ][ level.completedAnims[ animname ].size ] = anime;
		}
	}
}

anim_single_queue( guy, anime, tag, node, tag_entity )
{
	assertex( isdefined( anime ), "Tried to do anim_single_queue without passing a scene name (anime)" );
	
	if ( isdefined( guy.last_queue_time ) )
	{
		wait_for_buffer_time_to_pass( guy.last_queue_time, 0.5 );
	}
	
	function_stack( ::anim_single_solo, guy, anime, tag );
	guy.last_queue_time = gettime();
	/*
	// thread off so if the calling thread gets killed we dont get stuck with a queue on the guy
	thread anim_single_queue_thread( guy, anime, tag, node, tag_entity );

	for ( ;; )
	{
		if ( !isdefined( self._anim_solo_queue ) )
			break;
			
		self waittill( "finished anim solo" );
	}
	*/
}


// internal don't call directly
anim_single_queue_thread( guy, anime, tag, node, tag_entity )
{
	guy endon( "death" );
	queueTime = gettime();
	while ( 1 )
	{
		if ( !isdefined( self._anim_solo_queue ) )
			break;
			
		self waittill( "finished anim solo" );
		if ( gettime() > queueTime + 5000 )
			return;
			
		wait( 0.5 );
	}

	self._anim_solo_queue = true;	
	newguy[ 0 ] = guy;
	anim_single( newguy, anime, tag, node, tag_entity );
	self._anim_solo_queue = undefined;
	self notify( "finished anim solo" );
}

anim_dontPushPlayer( guy )
{
	for ( i = 0;i < guy.size;i ++ )
	{
		guy[ i ] pushPlayer( false );
	}
}

anim_pushPlayer( guy )
{
	for ( i = 0;i < guy.size;i ++ )
	{
		guy[ i ] pushPlayer( true );
	}
}

/*
=============
///ScriptDocBegin
"Name: addNotetrack_dialogue( <animname> , <notetrack> , <scene> , <soundalias> )"
"Summary: Makes a dialogue sound play on a certain notetrack. If you put multiple dialogue notetracks in an anim, it will play them in the order you do addNotetrack."
"Module: Anim"
"MandatoryArg: <animname>: The animname of the character, or generic. "
"MandatoryArg: <notetrack>: The notetrack in the anim, usual dialog. "
"MandatoryArg: <scene>: The scene the sound plays in. "
"MandatoryArg: <soundalias>: The soundalias. "
"Example: addNotetrack_dialogue( "price", "dialog", "wounded_begins", "sniperescape_mcm_choppergetback" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
addNotetrack_dialogue( animname, notetrack, anime, soundalias )
{
	num = 0;
	if ( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		 = notetrack;
	level.scr_notetrack[ animname ][ num ][ "dialog" ]		 = soundalias;
	level.scr_notetrack[ animname ][ num ][ "anime" ]			 = anime;
}

removeNotetrack_dialogue( animname, notetrack, anime, soundalias )
{
	assertex( isdefined( level.scr_notetrack[ animname ] ), "Animname not found in scr_notetrack." );

	tmp_array = [];

	for ( i = 0; i < level.scr_notetrack[ animname ].size; i ++ )
	{
		if ( level.scr_notetrack[ animname ][ i ][ "notetrack" ] == notetrack )
		{
			dialog = level.scr_notetrack[ animname ][ i ][ "dialog" ];
			if ( !isdefined( dialog ) )
				dialog = level.scr_notetrack[ animname ][ i ][ "dialogue" ];

			if ( isdefined( dialog ) && dialog == soundalias )
			{
				if ( isdefined( anime ) && isdefined( level.scr_notetrack[ animname ][ i ][ "anime" ] ) )
				{
					if ( level.scr_notetrack[ animname ][ i ][ "anime" ] == anime )
						continue;
				}
				else
					continue;
			}
		}

		num = tmp_array.size;
		tmp_array[ num ] = level.scr_notetrack[ animname ][ i ];
	}

	assertex( tmp_array.size < level.scr_notetrack[ animname ].size, "Notetrack not found." );

	level.scr_notetrack[ animname ] = tmp_array;
}

addNotetrack_sound( animname, notetrack, anime, soundalias )
{
	array = [];
	array[ "notetrack" ]		 = notetrack;
	array[ "sound" ]			 = soundalias;
	if ( !isdefined( anime ) )
	{
		anime = "any";
	}
	array[ "anime" ]			 = anime;

	if ( !isdefined( level.scr_notetrack ) )
	{
		level.scr_notetrack = [];
		level.scr_notetrack[ animname ] = [];
	}
	else
	{
		if ( !isdefined( level.scr_notetrack[ animname ] ) )
			level.scr_notetrack[ animname ] = [];
	}
	
	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = array;
}

addOnStart_animSound( animname, anime, soundalias )
{
	// only sounds generated by animSound should call this
	if ( !isdefined( level.scr_animSound[ animname ] ) )
		level.scr_animSound[ animname ] = [];

	level.scr_animSound[ animname ][ anime ] = soundalias;
}

addNotetrack_animSound( animname, anime, notetrack, soundalias )
{
	// only sounds generated by animSound should call this
	if ( !isdefined( level.scr_notetrack[ animname ] ) )
		level.scr_notetrack[ animname ] = [];

	array = [];	
	array[ "notetrack" ] = notetrack;
	array[ "sound" ] = soundalias;
	array[ "created_by_animSound" ] = true;
	array[ "anime" ] = anime;
	
	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = array;
}

addNotetrack_attach( animname, notetrack, model, tag, anime )
{
	num = 0;
	if ( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		 = notetrack;
	level.scr_notetrack[ animname ][ num ][ "attach model" ]	 = model;
	level.scr_notetrack[ animname ][ num ][ "selftag" ]		 = tag;
	
	if ( !isdefined( anime ) )
	{
		anime = "any";
	}
	
	level.scr_notetrack[ animname ][ num ][ "anime" ]	 = anime;
}

addNotetrack_detach( animname, notetrack, model, tag, anime )
{
	num = 0;
	if ( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		 = notetrack;
	level.scr_notetrack[ animname ][ num ][ "detach model" ]	 = model;
	level.scr_notetrack[ animname ][ num ][ "selftag" ]		 = tag;
	
	if ( !isdefined( anime ) )
	{
		anime = "any";
	}
	
	level.scr_notetrack[ animname ][ num ][ "anime" ]	 = anime;
}

/*
=============
///ScriptDocBegin
"Name: addNotetrack_customFunction( <animname>, <notetrack> , <function> , <anime> )"
"Summary: Makes the function run when this notetrack is hit. The SELF of the function is the scene base, the PARM of the function is the guy that hit the notetrack."
"Module: Anim"
"MandatoryArg: <animname>: Animname of the scene "
"MandatoryArg: <notetrack>: Duh"
"MandatoryArg: <function>: Duh part 2 "
"OptionalArg: <anime>: The scene. If left blank, will occur on all scenes."
"Example: 	addNotetrack_customFunction( "zpu_gun", "fire_1", ::zpu_shoot1 ); "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
addNotetrack_customFunction( animname, notetrack, function, anime )
{
	num = 0;
	if ( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		 = notetrack;
	level.scr_notetrack[ animname ][ num ][ "function" ]		 = function;
	
	if ( !isdefined( anime ) )
	{
		anime = "any";
	}
	
	level.scr_notetrack[ animname ][ num ][ "anime" ]	 = anime;
}

addNotetrack_flag( animname, notetrack, flag, anime )
{
	if ( !isdefined( level.scr_notetrack[ animname ] ) )
	{
		level.scr_notetrack[ animname ] = [];
	}
	
	addNote = [];
	addNote[ "notetrack" ] = notetrack;
	addNote[ "flag" ] = flag;
	if ( !isdefined( anime ) )
	{
		anime = "any";
	}
	addNote[ "anime" ] = anime;
		
	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = addNote;
	
	if ( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
}

#using_animtree( "generic_human" );

anim_look( guy, anime, array )
{
	guy endon( "death" );
	self endon( anime );
	changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
	wait( 0.05 );
	
	guy setflaggedanimknobrestart( "face_done_" + anime, array[ "left" ], 1, 0.2, 1 );
	thread clearFaceAnimOnAnimdone( guy, "face_done_" + anime, anime );
	guy setanimknobrestart( array[ "right" ], 1, 0.2, 1 );
	guy setanim( %scripted, 0.01, 0.3, 1 );
// 	guy setanim( %scripted_look_straight, 	0, 	changeTime );

	closeToZero = 0.01;
	for ( ;; )
	{
		destYaw = guy GetYawToOrigin( level.player.origin );
		if ( destYaw <= array[ "left_angle" ] )
		{
			animWeights[ "left" ] = 1;
			animWeights[ "right" ] = closeToZero;
		}
		else 
		if ( destYaw < array[ "right_angle" ] )
		{
			middleFraction = ( array[ "right_angle" ] - destYaw ) / ( array[ "right_angle" ] - array[ "left_angle" ] );
			if ( middleFraction < closeToZero )	middleFraction = closeToZero;
			if ( middleFraction > 1 - closeToZero )	middleFraction = 1 - closeToZero;
			animWeights[ "left" ] = middleFraction;
			animWeights[ "right" ] = ( 1 - middleFraction );
		}
		else
		{
			animWeights[ "left" ] = closeToZero;
			animWeights[ "right" ] = 1;
		}
		// these anims no longer exist asof 2 / 28 / 07
		// guy setanim( %scripted_look_left, 		animWeights[ "left" ], 	changeTime );	// anim, weight, blend - time
		// guy setanim( %scripted_look_right, 		animWeights[ "right" ], 	changeTime );
		wait( changeTime );
	}	
}

anim_facialAnim( guy, anime, faceanim )
{

	guy endon( "death" );
	self endon( anime );
	changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
// 	guy setanim( %scripted, 0.01, 0.3, 1 );
	
	guy notify( "newLookTarget" );		

	waittillframeend;// in case another facial animation just ended, so its clear doesnt overwrite us
	closeToZero = 0.3;
	// guy clearanim( %scripted_look_left, 		changeTime );	// anim, weight, blend - time
	// guy clearanim( %scripted_look_right, 	changeTime );
	guy setanim( %scripted_look_straight, 	0, 0 );
	guy setanim( %scripted_look_straight, 	1, 0.5 );
	guy setflaggedanimknobrestart( "face_done_" + anime, faceanim, 1, 0, 1 );
	thread clearFaceAnimOnAnimdone( guy, "face_done_" + anime, anime );
}

anim_facialFiller( msg, lookTarget )
{
	self endon( "death" );
	
	changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
// 	guy setanim( %scripted, 0.01, 0.3, 1 );

	self notify( "newLookTarget" );		
	self endon( "newLookTarget" );		
	
	waittillframeend;// in case another facial animation just ended, so its clear doesnt overwrite us
	closeToZero = 0.3;
	// self clearanim( %scripted_look_left, 		changeTime );	// anim, weight, blend - time
	// self clearanim( %scripted_look_right, 		changeTime );
	
	 /* 
	quick = false;
	if ( !isdefined( looktarget ) )
	{
		guy[ 0 ] = self;
		lookTarget = get_closest_ai_exclude( self.origin, self.team, guy );
		if ( isdefined( looktarget ) )
			quick = true;
	}
	 */ 
	if ( !isdefined( looktarget ) && isdefined( self.looktarget ) )
		looktarget = self.looktarget;

	talkAnim = %generic_talker_allies;
	if ( self.team == "axis" )
		talkAnim = %generic_talker_axis;

	self setanimknobrestart( talkAnim, 1, 0, 1 );
	self setanim( %scripted_talking, 5, 0.1 );
	
	if ( isdefined( looktarget ) )
	{
// 		self setanim( %scripted_look_straight, 	0, 0 );
// 		self setanim( %scripted_look_straight, 	1, 1 );
		thread chatAtTarget( msg, lookTarget );
		return;
	}

// 	self setanim( %scripted_look_straight, 	0, 0 );
// 	self setanim( %scripted_look_straight, 	1, 0.5 );
	self set_talker_until_msg( msg, talkanim );

	changeTime = 0.3;
	self clearanim( %scripted_talking, 0.1 );
	// self clearanim( %scripted_look_left, 		changeTime );
	// self clearanim( %scripted_look_right, 		changeTime );
	self clearanim( %scripted_look_straight, 	changeTime );
}

set_talker_until_msg( msg, talkanim )
{
	self endon( msg );
	for ( ;; )
	{
		self setanimknob( talkAnim, 1, 0, 1 );
		self setanim( %scripted_talking, 5, 0.1 );
		wait( 0.05 );
	}
}


talk_for_time( timer )
{
	self endon( "death" );
	talkAnim = %generic_talker_allies;
	if ( self.team == "axis" )
		talkAnim = %generic_talker_axis;

	self setanimknobrestart( talkAnim, 1, 0, 1 );
	self setanim( %scripted_talking, 5, 0.1 );

	wait( timer );
	changeTime = 0.3;
	self clearanim( %scripted_talking, 0.1 );
	self clearanim( %scripted_look_straight, 	changeTime );
}

GetYawAngles( angles1, angles2 )
{
	yaw = angles1[ 1 ] - angles2[ 1 ];
	yaw = AngleClamp180( yaw );
	return yaw;
}

chatAtTarget( msg, lookTarget )
{
	self endon( msg );
	self endon( "death" );


	self thread lookRecenter( msg );
	
	array[ "right" ] = %generic_lookupright;
	array[ "left" ] = %generic_lookupleft;
	
	array[ "left_angle" ] = -65;
	array[ "right_angle" ] = 65;
	

	closeToZero = 0.01;
	org = looktarget.origin;

	moveRange = 2.0;
	changeTime = 0.3;

	for ( ;; )
	{
		if ( isalive( looktarget ) )
			org = looktarget.origin;
		 /#
		if ( getdebugdvar( "debug_chatlook" ) == "on" )
			thread lookLine( org, msg );
		#/ 
// 		destYaw = self GetEyeYawToOrigin( org );
// 		destYaw = self GetYawToOrigin( org );
		angles = anglestoright( self gettagangles( "J_Spine4" ) );
		angles = vectorScale( angles, 10 );
		angles = vectortoangles( ( 0, 0, 0 ) - angles );
// 		destYaw = self GetYawToTag( "J_Spine4", org );
	
		yaw = angles[ 1 ] - GetYaw( org );
		destyaw = AngleClamp180( yaw );

		
		moveRange = abs( destYaw - self.a.lookAngle ) * 1;
		
		if ( destYaw > self.a.lookangle + moveRange )
			self.a.lookangle += moveRange;
		else
		if ( destYaw < self.a.lookangle - moveRange )
			self.a.lookangle -= moveRange;
		else
			self.a.lookangle = destYaw;
			
		destYaw = self.a.lookangle;
			
		if ( destYaw <= array[ "left_angle" ] )
		{
			animWeights[ "left" ] = 1;
			animWeights[ "right" ] = closeToZero;
		}
		else 
		if ( destYaw < array[ "right_angle" ] )
		{
			middleFraction = ( array[ "right_angle" ] - destYaw ) / ( array[ "right_angle" ] - array[ "left_angle" ] );
			if ( middleFraction < closeToZero )	middleFraction = closeToZero;
			if ( middleFraction > 1 - closeToZero )	middleFraction = 1 - closeToZero;
			animWeights[ "left" ] = middleFraction;
			animWeights[ "right" ] = ( 1 - middleFraction );
		}
		else
		{
			animWeights[ "left" ] = closeToZero;
			animWeights[ "right" ] = 1;
		}
		
		self setanim( array[ "left" ], 		animWeights[ "left" ], 	changeTime );	// anim, weight, blend - time
		self setanim( array[ "right" ], 		animWeights[ "right" ], 	changeTime );
		wait( changeTime );
	}
}

lookRecenter( msg )
{
	// recenter the look angle so the head doesnt jerk back to where he used to be looking
	self endon( "newLookTarget" );	
	self endon( "death" );
	self waittill( msg );
	self clearanim( %scripted_talking, 0.1 );

	self setanim( %generic_lookupright, 		1, 		0.3 );	// anim, weight, blend - time
	self setanim( %generic_lookupleft, 		1, 		0.3 );
	self setanim( %scripted_look_straight, 	0.2, 	0.1 );
	wait( 0.2 );
	self clearanim( %scripted_look_straight, 0.2 );
}

lookLine( org, msg )
{
	self notify( "lookline" );
	self endon( "lookline" );
	self endon( msg );
	self endon( "death" );
	for ( ;; )
	{
		line( self geteye(), org + ( 0, 0, 60 ), ( 1, 1, 0 ), 1 );
		wait( 0.05 );
	}
}

anim_reach_idle( guy, anime, idle )
{
	// Makes an array of guys go to the right spot relative to an animation
	// all but the last guy will idle there, so you do anim_reach_idle then anim_loop
	ent = spawnstruct();
	ent.count = guy.size;
	for ( i = 0;i < guy.size;i ++ )
		thread reachIdle( guy[ i ], anime, idle, ent );
	while ( ent.count )
		ent waittill( "reached_goal" );

	self notify( "stopReachIdle" );
}

reachIdle( guy, anime, idle, ent )
{
	anim_reach_solo( guy, anime );
	ent.count -- ;
	ent notify( "reached_goal" );
	if ( ent.count > 0 )
		anim_loop_solo( guy, idle, undefined, "stopReachIdle" );
}

delayedDialogue( anime, doAnimation, dialogue, animationName )
{
	assertEx( animhasnotetrack( animationName, "dialog" ), "Animation " + anime + " does not have a dialog notetrack." );
	
	self waittillmatch( "face_done_" + anime, "dialog" );
	if ( doAnimation )
		self SaySpecificDialogue( undefined, dialogue, 1.0 );
	else
		self SaySpecificDialogue( undefined, dialogue, 1.0, "single dialogue" );
}

clearFaceAnimOnAnimdone( guy, msg, anime )
{
	guy endon( "death" );
// 	self waittill( anime );
	guy waittillmatch( msg, "end" );
	changeTime = 0.3;
	// guy clearanim( %scripted_look_left, 			changeTime );
	// guy clearanim( %scripted_look_right, 		changeTime );
	guy clearanim( %scripted_look_straight, 		changeTime );
}

anim_single_solo_delayed( delay, guy, anime, tag, node, tag_entity )
{
	wait( delay );
	anim_single_solo( guy, anime, tag, node, tag_entity );
}

queue_anim( anime, node, tag, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	if ( isdefined( tag ) || isdefined( entity ) )
	{
		queue_anim_single_solo_with_reach( self, anime, tag, entity );
		return;
	}
	
	
	queue_anim_single_solo( self, anime );
}

queue_anim_single_solo_with_reach( guy, anime, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );

	animePacket = spawnstruct();
	animePacket.reach = true;
	animePacket process_queue_packet( guy, anime, tag, entity );
}

queue_anim_single_solo( guy, anime )
{
	animePacket = spawnstruct();
	animePacket.reach = false;
	animePacket process_queue_packet( guy, anime );
}

process_queue_packet( guy, anime, tag, entity )
{
	guy endon( "death" );
	self.guy = guy;
	self.anime = anime;
	self.tag = tag;
	self.entity = entity;
	self.anime_base = self.guy;
	
	// self.anime_base is used to run anim_reach and anim_solo, it should be the base of the animation / scene.
	// thats normally the node or tag entity but if neither exist then its the guy.
	if ( isdefined( entity ) )
		self.anime_base = entity;
		
	
	if ( !isdefined( guy.anime_queue ) )
		guy.anime_queue = [];

	guy.anime_queue[ guy.anime_queue.size ] = self;
	
	for ( ;; )
	{
		if ( guy.anime_queue[ 0 ] != self )
		{
			guy waittill( "finished_queued_animation" );
			continue;
		}
		
		packet = guy.anime_queue[ 0 ];

		lastBattleChatter = packet.guy.battlechatter;
		packet.guy set_battleChatter( false );
		if ( packet.reach )
			packet.anime_base anim_reach_solo( packet.guy, packet.anime, packet.tag, packet.entity );
	
		packet.anime_base anim_single_solo( packet.guy, packet.anime, packet.tag, packet.entity );

		packet.guy set_battleChatter( lastBattleChatter );


		// remove the first entree from the queue
		newQueue = [];
		for ( i = 1; i < guy.anime_queue.size; i ++ )
		{
			newQueue[ newQueue.size ] = guy.anime_queue[ i ];
		}
		
		guy.anime_queue = newQueue;

		if ( guy.anime_queue.size <= 0 )
		{
			guy notify( "finished_queued_animation" );
			guy.anime_queue = undefined;
			return;
		}

		wait( 1 );// debounce
		guy notify( "finished_queued_animation" );
		break;
	}
}

waittill_empty_queue()
{
	self endon( "death" );
	if ( !isdefined( self.anim_queue ) )
		return;
		
	for ( ;; )
	{
		if ( self.anime_queue.size <= 0 )
			return;
			
		self waittill( "finished_queued_animation" );
	}
}

anim_start_pos( guyArray, anime, tag, entity )
{
	pos = get_anim_position( tag, entity );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];
	
	array_thread( guyArray, ::set_start_pos, anime, org, angles );
}

anim_start_pos_solo( guy, anime, tag, entity )
{
	newguy[ 0 ] = guy;
	anim_start_pos( newguy, anime, tag, entity );
}

set_start_pos( anime, org, angles, animname_override )
{
	animname = undefined;
	if ( isdefined( animname_override ) )
		animname = animname_override;
	else
		animname = self.animname;

	
	if ( isSentient( self ) )
	{
		neworg = getstartOrigin( org, angles, level.scr_anim[ animname ][ anime ] );
		newangles = getstartAngles( org, angles, level.scr_anim[ animname ][ anime ] );
		self teleport( neworg, newangles );
	}
	else
	{
		self.origin = getstartOrigin( org, angles, level.scr_anim[ animname ][ anime ] );
		self.angles = getstartAngles( org, angles, level.scr_anim[ animname ][ anime ] );
	}
}


anim_at_self( entity, tag )
{
	packet = [];
	packet[ "guy" ] = self;
	packet[ "entity" ] = self;
	return packet;
}

anim_at_entity( entity, tag )
{
	packet = [];
	packet[ "guy" ] = self;
	packet[ "entity" ] = entity;
	packet[ "tag" ] = tag;
	return packet;
}

add_to_animsound()
{
	if ( !isdefined( self.animSounds ) )
	{
		self.animSounds = [];
	}

	isInArray = false;
	for ( i = 0; i < level.animSounds.size; i ++ )
	{
		if ( self == level.animSounds[ i ] )
		{
			isInArray = true;
			break;
		}
	}
	if ( !isInArray )
	{
		level.animSounds[ level.animSounds.size ] = self;
	}
}

/*
=============
///ScriptDocBegin
"Name: anim_set_rate_single( <guy> , <anime> , <rate> )"
"Summary: Sets the rate that guy is playing an animation"
"Module: Anim"
"MandatoryArg: <guys>: Stuff that is doing anim_single, anim_generic, or anim_single_solo"
"MandatoryArg: <anime>: The scene being played"
"MandatoryArg: <rate>: The rate to change to"
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

anim_set_rate_single( guy, anime, rate )
{
	guy thread anim_set_rate_internal( anime, rate );
}

/*
=============
///ScriptDocBegin
"Name: anim_set_rate( <guys> , <anime> , <rate> )"
"Summary: Sets the rate that guys are playing an animation"
"Module: Anim"
"MandatoryArg: <guys>: Stuff that is doing anim_single, anim_generic, or anim_single_solo"
"MandatoryArg: <anime>: The scene being played"
"MandatoryArg: <rate>: The rate to change to"
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
anim_set_rate( guys, anime, rate )
{
	array_thread( guys, ::anim_set_rate_internal, anime, rate );
}

anim_set_rate_internal( anime, rate, animname_override )
{
	animname = undefined;
	if ( isdefined( animname_override ) )
		animname = animname_override;
	else
		animname = self.animname;

	self setflaggedanim( "single anim", getanim_from_animname( anime, animname ), 1, 0, rate );
}

/*
=============
///ScriptDocBegin
"Name: anim_set_time( <guys> , <anime> , <time> )"
"Summary: Sets the current time of an anim, but should be done at least 0.05 seconds after the anim is calle"
"Module: Anim"
"CallOn: Array of guys animating"
"MandatoryArg: <guys>: Guys animating"
"MandatoryArg: <amime>: Scene name"
"MandatoryArg: <time>: Time to set to"
"Example: delaythread( 0.05, ::anim_set_time, guy_and_door, "fire_3", 1.0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
anim_set_time( guys, anime, time )
{
	array_thread( guys, ::anim_self_set_time, anime, time );
}

anim_self_set_time( anime, time )
{
	self setanimtime( self getanim( anime ), time );
}

last_anim_time_check()
{
	
	if ( !isdefined( self.last_anim_time ) )
	{
		self.last_anim_time	= gettime();
		return;
	}
	
	time = gettime();
//	assertex( self.last_anim_time != time, "Tried to do animscripted twice in one frame. This is not supported." );
	if ( self.last_anim_time == time )
	{
		// can't call 2 animscripteds on one frame
		// check this in after e3 build
		wait( 0.05 );
	}
	self.last_anim_time = time;
}