/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
_breach global script

NOTE: Load \test\breach.d3dbsp to test all supported breaches

 -- -- -- -- -- -- -- -- -- -- -- -- -- 
Currently supported breaches( sBreachType )
 -- -- -- -- -- -- -- -- -- -- -- -- -- 
"explosive_breach_left"
"shotgunhinges_breach_left":
"flash_breach_no_door_right":


 -- -- -- -- -- -- -- -- -- -- -- -- -- 
How to use
 -- -- -- -- -- -- -- -- -- -- -- -- -- 

1 )  Add any of the following above _load:::main();

	maps\_breach_explosive_left::main(); 
	maps\_breach_flash_right::main(); 
	maps\_breach_hinges_left::main(); 
	
	
	 * * * * AND * * * * * 
	
	maps\_breach::main(); 
   
 

2 ) ROOM VOLUME: Create an info_volume that encompasses the room being assaulted.
				( used to stun enemies during explosive breaches, determine where AI throws flash grenades, 
				and to detect when the room is cleared )

3 ) DOOR: 		Have the room volume script_linkTo a door( script_model or script_brushmodel ) with an origin that
				points in towards the interior of the room( all stacking / breaching anims play on this origin ). 
				see model com_door_01_handleleft for an example.
				
				If you use a script_brushmodel, you will need to manually target it to a script_origin on the
				lower right corner of the door frame that points in towards the interior of the room.
				
4 ) NO DOOR: 	If the breach does not require a door( like for flashbang only breaches ), you need to have the 
				room volume script_linkTo a script_origin on the edge of the door frame pointing in towards the room.
				
5 ) BLOCKER: 	The model door needs to target a script_brushmodel blocker( not necessary if you use 
				a script_brushmodel door instead )

5 ) EXPLODER: 	All doors must script_linkTo a script_origin in the center of the door with a 'script_exploder' key 
				of any number. Used to play default fx and will later by used by fx artists for additional
				smoke or custom effects in the room
				
 -- -- -- -- -- -- -- -- -- -- -- -- -- 
Function arguments
 -- -- -- -- -- -- -- -- -- -- -- -- -- 
 < volume > thread breach_think( aBreachers, sBreachType, sHintString, bSpawnHostiles, bPlayDefaultFx, bShoot );

 < volume > 	 = The room volume being breached
aBreachers	 = The array of friendlies performing the breach( can not be more than 2 )
sBreachType	 = which breach to perform. See / test / breach to see currently supported breaches
sHintString	 = Pass a hintstrig to display if you trigger the breach with a "use" trigger
bSpawnHostiles = true / false value if you want to spawn hostiles inside right before the breach is started
bPlayDefaultFx = defaults to true. Set to false and add effects to the exploder instead if you like
bShoot = some breaches have the AI firing randomly as they storm into a room while they are still playing the scripted anim. True by default

 -- -- -- -- -- -- -- -- -- -- -- -- -- 
PROPERTIES
 -- -- -- -- -- -- -- -- -- -- -- -- -- 
.firstBreacher - to have a specific guy be the first to a breach. If undefined, will choose whichever AI is closest to the door at the time the breach script is called
 
 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/ 

#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#using_animtree( "generic_human" );

main()
{
	level._effect[ "_breach_doorbreach_detpack" ] 	 = loadfx( "explosions/exp_pack_doorbreach" );
	level._effect[ "_breach_doorbreach_kick" ] 		 = loadfx( "explosions/grenadeExp_wood" );
	level.scr_sound[ "breach_wooden_door" ] 		 = "detpack_explo_main";
	level.scr_sound[ "breach_wood_door_kick" ] 		 = "wood_door_kick";	
	flag_init( "begin_the_breach" );
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    BREACH CORE FUNCTIONS
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/ 

breach_think( aBreachers, sBreachType, sHintString, bSpawnHostiles, bPlayDefaultFx, bShoot )
{
	// self == > the room volume being breached
	self endon( "breach_abort" );

	// Changing core function called when any scripted sequence calls a fire notetrack
	// used to determine whether "fire" notetracks should be obeyed or not	
	if ( isdefined( bShoot ) && ( bShoot == false ) )
	{
		anim.fire_notetrack_functions[ "scripted" ] = ::breach_fire_straight;
	}

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	VARIABLE SETUP
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
	self.flashthrown = false;
	self.closestAI = undefined;
	self.animEnt = undefined;
	self.breached = false;
	self.breachers = 0;
	self.breachersReady = false;
	self.singleBreacher = false;
	self.readyToBreach = false;
	self.AIareInTheRoom = false;
	self.aboutToBeBreached = false;
	self.cleared = false;
	self.hasDoor = true;
	self.hasFlashbangs = false;
	self.hostilesSpawned = false;
	assertEx( ( aBreachers.size <= 2 ), "You cannot send more than 2 AI to perform a breach" );
	assertEx( ( isdefined( self.targetname ) ), "Room volume must have a targetname to use the breach fuctions" );
	aVolumes = getentarray( self.targetname, "targetname" );
	assertEx( ( aVolumes.size == 1 ), "There are multiple room volumes with the same targetname: " + self.targetname );
	sRoomName = self.targetname;
	self.sBadplaceName = "badplace_" + sRoomName;
	self.badplace = getent( "badplace_" + sRoomName, "targetname" );
	if ( isdefined( self.badplace ) )
		assertEx( ( self.badplace.classname == "script_origin" ), "The badplace entity for volume " + self.targetname + " needs to be a script_origin" );
	self.breachtrigger = getent( "trigger_" + sRoomName, "targetname" );
	if ( !isdefined( bPlayDefaultFx ) )
		bPlayDefaultFx = true;
	if ( isdefined( self.breachtrigger ) )
	{
		switch( self.breachtrigger.classname )
		{
			case "trigger_use":
				assertEx( ( isdefined( sHintString ) ), "You need to pass a hintstring to the function 'breach_think' for the trigger_use " + self.breachtrigger.targetname );
				self.triggerHintString = sHintString;
				break;
			case "trigger_use_touch":
				assertEx( ( isdefined( sHintString ) ), "You need to pass a hintstring to the function 'breach_think' for the trigger_use " + self.breachtrigger.targetname );
				self.triggerHintString = sHintString;
				break;
			case "trigger_radius":
				break;
			case "trigger_multiple":
				break;
			default:
				assertmsg( "entity with targetname '" + self.breachtrigger.targetname + "' must be a trigger_multiple, trigger_radius, trigger_use or trigger_use_touch" );
				break;
		}
	}
	switch( sBreachType )
	{
		case "explosive_breach_left":
			break;
		case "shotgunhinges_breach_left":
			break;		
		case "flash_breach_no_door_right":
			self.hasDoor = false;
			self.hasFlashbangs = true;
			break;
		default:
			assertmsg( sBreachType + " is not a valid breachType" );
			break;
	}
	if ( self.hasDoor == true )
	{
		self.eDoor = getent( self.script_linkto, "script_linkname" );
		assertEx( ( isdefined( self.eDoor ) ), "Explosive breach room volume " + self.targetname + " needs to scriptLinkto a single door" );
		if ( self.eDoor.classname == "script_model" )
		{
			self.animEnt = spawn( "script_origin", self.eDoor.origin );
			self.animEnt.angles = self.eDoor.angles;
		}
		else if ( self.eDoor.classname == "script_brushmodel" )
		{
			self.animEnt = getent( self.eDoor.target, "targetname" );
			assertEx( ( isdefined( self.animEnt ) ), "Room volume " + self.targetname + " needs it's script_brushmodel door door to target a script_origin in the lower right hand corner of the door frame. Make this script_origin point in towards the room being breached." );
			assertEx( ( self.animEnt.classname == "script_origin" ), "Room volume " + self.targetname + " needs it's script_brushmodel door door to target a script_origin in the lower right hand corner of the door frame. Make this script_origin point in towards the room being breached." );	
			self.eDoor.vector = anglestoforward( self.animEnt.angles );
		}		
		self.eExploderOrigin = getent( self.eDoor.script_linkto, "script_linkname" );
		assertex( isdefined( self.eExploderOrigin ), "A script_brushmodel / script_model door needs to script_linkTo an exploder( script_origin ) to play particles when opened. Targetname:  " + self.targetname );
		assertEx( ( self.eExploderOrigin.classname == "script_origin" ), "The exploder for this room volume needs to be a script_origin: " + self.targetname );
		self.iExploderNum = self.eExploderOrigin.script_exploder;
		assertEx( ( isdefined( self.iExploderNum ) ), "There is no exploder number in the key 'script_exploder' for volume " + self.targetname );	
	}
	else if ( self.hasDoor == false )
	{
		self.animEnt = getent( self.script_linkto, "script_linkname" );
		assertEx( ( isdefined( self.animEnt ) ), "If there is no door to be breached, you must have the room volume scriptLinkTo a script_origin instead where the AI will play their idle and enter anims." );
	}
	if ( self.hasFlashbangs == true )
	{
		self.grenadeOrigin = getent( "flashthrow_" + sRoomName, "targetname" );
		assertEx( ( isdefined( self.grenadeOrigin ) ), "Breaches that have AI throwing flashbangs need a script origin in the center of the door frame with a targetname of: flashthrow_" + sRoomName );
		self.grenadeDest = getent( self.grenadeOrigin.target, "targetname" );
		assertEx( ( isdefined( self.grenadeDest ) ), "script_origin 'flashthrow_" + sRoomName + "' needs to target another script_origin where you want the flashbang to be thrown to" );
	}

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	CLEANUP AND FX
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
	self thread breach_abort( aBreachers );
	self thread breach_cleanup( aBreachers );
	self thread breach_play_fx( sBreachType, bPlayDefaultFx );




	/* -- -- -- -- -- -- -- -- -- -- -- - 
	DECIDE WHO WILL TAKE UP FIRST POSITION
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/
	iFirstBreachers = 0;
	for(i=0;i<aBreachers.size;i++)
	{
		if ( isdefined( aBreachers[i].firstBreacher ) )
		{
			iFirstBreachers ++;
			self.closestAI = aBreachers[i];
		}
	}
	if ( iFirstBreachers > 0 )
		assertEx( iFirstBreachers == 1, ".firstBreacher property has been set on " + iFirstBreachers + " AI. Max is one AI " );
	else
		self.closestAI = getClosest( self.animEnt.origin, aBreachers );


	/* -- -- -- -- -- -- -- -- -- -- -- - 
	SEND EACH AI TO IDLE
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	if ( aBreachers.size == 1 )
		self.singleBreacher = true;
	for ( i = 0;i < aBreachers.size;i++ )
		aBreachers[ i ] thread breacher_think( self, sBreachType, bShoot );
	
	while ( self.breachers < aBreachers.size )
		wait( 0.05 );
	
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	AI IS READY TO BREACH
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	self notify( "ready_to_breach" );
	self.readyToBreach = true;
	if ( isdefined( self.breachtrigger ) )
	{
		self.breachtrigger thread breach_trigger_think( self );
		self waittill( "execute_the_breach" );
	}
	else
	{
		self notify( "execute_the_breach" );
	}
	
	flag_set( "begin_the_breach" );
	self.aboutToBeBreached = true;
	
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	SPAWN HOSTILES RIGHT AS ROOM IS BEING BREACHED( IF SPECIFIED IN ARGUMENT )
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	
	if ( isdefined( bSpawnHostiles ) && ( bSpawnHostiles == true ) )
	{
		spawners = getentarray( "hostiles_" + sRoomName, "targetname" );
		assertEx( ( isdefined( spawners ) ), "Could not find spawners with targetname of hostiles_" + sRoomName + " for room volume " + self.targetname );
		// wait for the AI to start breaching the room before spawning hostiles
		self waittill( "spawn_hostiles" );
		spawnBreachHostiles( spawners );
		self.hostilesSpawned = true;
	}

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	GET ARRAY OF ALL HOSTILES TOUCHING THE ROOM VOLUME
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	// badplace to get AI out of the way of the door
	if ( isdefined( self.badplace ) )
		badplace_cylinder( self.sBadplaceName, -1, self.badplace.origin, self.badplace.radius, 200, "axis" );
	
	
	ai = getaiarray( "axis" );
	aHostiles = [];
	for ( i = 0;i < ai.size;i++ )
	{
		if ( ai[ i ] isTouching( self ) )
			aHostiles[ aHostiles.size ] = ai[ i ];
	}	
	if ( aHostiles.size > 0 )
		array_thread( aHostiles, ::breach_enemies_stunned, self );
	
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	WAIT FOR ALL THE AI TO BE IN THE ROOM
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
	while ( !self.AIareInTheRoom )
		wait( 0.05 );

	self notify( "breach_complete" );
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	WAIT FOR ROOM TO BE CLEARED
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
	if ( !aHostiles.size )
		return;
		
	while ( !self.cleared )
	{
		wait( 0.05 );
		for ( i = 0;i < aHostiles.size;i++ )
		{
			if ( !isalive( aHostiles[ i ] ) )
				aHostiles = array_remove( aHostiles, aHostiles[ i ] );
			if ( aHostiles.size == 0 )
				self.cleared = true;
		}		
	}
}

breach_dont_fire()
{
	while ( self.breaching == true )
	{
		
		self waittillmatch( "single anim", "fire" );
		self.a.lastShootTime = gettime();
	}
}

breacher_think( eVolume, sBreachType, bShoot )
{
	// self == > the AI doing the breaching
	self.breaching = true;
	self.breachDoNotFire = undefined;
	if ( !isdefined( bShoot ) )
		bShoot = true;
	// self disable_ai_color();
	// self breach_set_animname( "generic" );// dont need to make people animname generic anymore
	self pushplayer( true );
	self thread give_infinite_ammo();
	
	eVolume endon( "breach_abort" );
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	VARIABLE SETUP
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
	self.ender = "stop_idle_" + self getentitynumber();
	AInumber = undefined;
	sAnimStart = undefined;
	sAnimIdle = undefined;
	sAnimBreach = undefined;
	sAnimFlash = undefined;



	if ( self == eVolume.closestAI )
		AInumber = "01";
	else
		AInumber = "02";


	/* -- -- -- -- -- -- -- -- -- -- -- - 
	SPECIAL CASE: SINGLE EXPLOSIVVE GUY NEEDS TO BE NUMBER TWO IN THE STACK
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	if ( ( eVolume.singleBreacher == true ) && ( sBreachType == "explosive_breach_left" ) )
		AInumber = "02";
	
	switch( sBreachType )
	{
		case "explosive_breach_left":
			if ( ( isdefined( self.usebreachapproach ) ) && ( self.usebreachapproach == false ) )
				sAnimStart = "detcord_stack_left_start_no_approach_" + AInumber;
			else
				sAnimStart = "detcord_stack_left_start_" + AInumber;
			sAnimIdle = "detcord_stack_leftidle_" + AInumber;
			sAnimBreach = "detcord_stack_leftbreach_" + AInumber;
			break;		
		case "shotgunhinges_breach_left":
			sAnimStart = "shotgunhinges_breach_left_stack_start_" + AInumber;
			sAnimIdle = "shotgunhinges_breach_left_stack_idle_" + AInumber;
			sAnimBreach = "shotgunhinges_breach_left_stack_breach_" + AInumber;
			break;
		case "flash_breach_no_door_right":
			if ( eVolume.singleBreacher == true )
			{
				sAnimStart = "flash_stack_right_start_single";
				sAnimIdle = "flash_stack_right_idle_single";
				sAnimBreach = "flash_stack_right_breach_single";
				sAnimFlash = "flash_stack_right_flash_single";				
			}
			else
			{
				sAnimStart = "flash_stack_right_start_" + AInumber;
				sAnimIdle = "flash_stack_right_idle_" + AInumber;
				sAnimBreach = "flash_stack_right_breach_" + AInumber;
				sAnimFlash = "flash_stack_right_flash_" + AInumber;				
			}
			break;
		default:
			assertmsg( sBreachType + " is not a valid breachType" );
			break;
	}
	
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	AI TO BREACH IDLE
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
	self breach_set_goaladius( 64 );
	eVolume.animEnt anim_generic_reach( self, sAnimStart );
	eVolume.animEnt anim_generic( self, sAnimStart );
	eVolume.animEnt thread anim_generic_loop( self, sAnimIdle, undefined, self.ender );
	self.setGoalPos = self.origin;
	eVolume.breachers++ ;
	
	eVolume waittill( "execute_the_breach" );
	
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	AI FLASHES THE ROOM
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
	if ( ( !eVolume.flashthrown ) && ( isdefined( sAnimFlash ) ) )
	{
		eVolume.animEnt notify( self.ender );
		eVolume.animEnt thread anim_generic( self, sAnimFlash );
		wait( 1 );

		// magic grenade from second guy
		if ( ( AInumber == "02" ) || ( eVolume.singleBreacher == true ) )
		{
			sHandTag = "J_Mid_LE_1";
			self attach( "projectile_m84_flashbang_grenade", sHandTag );
			oldGrenadeWeapon = self.grenadeWeapon;
			self.grenadeWeapon = "flash_grenade";
			self.grenadeAmmo++ ;
			if ( AInumber == "02" )
				self waittillmatch( "single anim", "grenade_throw" );	
			if ( ( eVolume.singleBreacher == true ) && ( AInumber == "01" ) )
				self waittillmatch( "single anim", "fire" );	
			self magicgrenade( eVolume.grenadeOrigin.origin, eVolume.grenadeDest.origin, level.iFlashFuse );
			self detach( "projectile_m84_flashbang_grenade", sHandTag );
			self.grenadeWeapon = oldGrenadeWeapon;
			self.grenadeAmmo = 0;			
		}

		self waittillmatch( "single anim", "end" );
		eVolume.animEnt thread anim_generic_loop( self, sAnimIdle, undefined, self.ender );
		wait( .1 );			
	}

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	PLAY BREACH ANIMS ON BOTH AI
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	eVolume.animEnt notify( self.ender );
	
	if ( bShoot == false )
		self.breachDoNotFire = true;	
	eVolume.animEnt thread anim_generic( self, sAnimBreach );	
	// eVolume.animEnt anim_generic( self, sAnimBreach );	
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	CONDITIONAL: EXPLOSIVE BREACH
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	if ( sBreachType == "explosive_breach_left" )
	{
		/* -- -- -- -- -- -- -- -- -- -- -- - 
		BLOW THE DOOR
		 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
		if ( AInumber == "02" )
		{
			self thread detcord_logic( eVolume );
			self waittillmatch( "single anim", "pull fuse" );
			wait( 1 );
			eVolume notify( "spawn_hostiles" );
			eVolume notify( "detpack_about_to_blow" );
			self waittillmatch( "single anim", "explosion" );
			eVolume notify( "detpack_detonated" );
			eVolume.breached = true;
			eVolume.eDoor thread door_open( "explosive", eVolume );
			eVolume notify( "play_breach_fx" );
		}
	}

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	CONDITIONAL: SHOTGUN BREACH A
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	else if ( sBreachType == "shotgunhinges_breach_left" )
	{
		/* -- -- -- -- -- -- -- -- -- -- -- - 
		SHOOT THE DOOR
		 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
		if ( AInumber == "01" )
		{
			eVolume notify( "spawn_hostiles" );
			self waittillmatch( "single anim", "kick" );
			eVolume.eDoor thread door_open( "shotgun", eVolume );
			eVolume notify( "play_breach_fx" );
		}
	}
		
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	CONDITIONAL: SHACK BREACH
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	else if ( sBreachType == "flash_breach_no_door_right" )
	{
		// Nothing conditional to do for this breach yet
	}

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	AI FINISHES ENTERING
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	self waittillmatch( "single anim", "end" );
	self notify ( "breach_complete" );
	if ( bShoot == false )
		self.breachDoNotFire = undefined;
		
	if ( isdefined( level.friendly_breach_thread ) )
		self thread [[ level.friendly_breach_thread ]]( eVolume );

	eVolume.AIareInTheRoom = true;
	// self setgoalvolume( eVolume );
	self pushplayer( false );
	self breach_reset_animname();
	
	while ( !eVolume.cleared )
		wait( 0.05 );
	
	self.breaching = false;
}

breach_fire_straight()
{
	// Changing core function called when any scripted sequence calls a fire notetrack
    if ( isdefined( self.breachDoNotFire ) )
		return;
	animscripts\shared::fire_straight();
}

detcord_logic( eVolume )
{
	// self == > the AI placing the detcord
	self thread sound_effect_play( eVolume );
	self waittillmatch( "single anim", "attach prop right" );
	sHandTag = "TAG_INHAND";
	// spawn detcord model and attach to guy's hand

	// attach detcord to AI hand
	self attach( "weapon_detcord", sHandTag );
	self waittillmatch( "single anim", "detach prop right" );
	// spawn detcord model and delete other one
	org_hand = self gettagorigin( sHandTag );
	angles_hand = self gettagangles( sHandTag );
	self detach( "weapon_detcord", sHandTag );
	model_detcord = spawn( "script_model", org_hand );
	model_detcord setmodel( "weapon_detcord" );
	model_detcord.angles = angles_hand;		

	// delete once door is breached
	eVolume waittill( "detpack_detonated" );
	radiusdamage( model_detcord.origin, 64, 50, 25 );
	model_detcord delete();
}			

sound_effect_play( eVolume )
{
	self waittillmatch( "single anim", "sound effect" );
	thread play_sound_in_space ( "detpack_plant_arming", eVolume.animEnt.origin );	
}

breach_enemies_stunned( eRoomVolume )
{
	// self == > the room volume being breached
	self endon( "death" );
	eRoomVolume endon( "breach_aborted" );
	
	eRoomVolume waittill( "detpack_detonated" );
	if ( distance( self.origin, eRoomVolume.animEnt.origin ) <= level.detpackStunRadius )
	{
		// self setFlashBanged( true, 0.25 );
		level.stunnedAnimNumber++ ;
		if ( level.stunnedAnimNumber > 2 )
			level.stunnedAnimNumber = 1;
		sStunnedAnim = "exposed_flashbang_v" + level.stunnedAnimNumber;
		// self breach_set_animname( "generic" );// dont need to make people animname generic anymore
		self.allowdeath = true;
		self anim_generic_custom_animmode( self, "gravity", sStunnedAnim );
		//self anim_generic( self, sStunnedAnim );
		self breach_reset_animname();
	}
}

breach_trigger_think( eRoomVolume )
{
	// self == > the trigger 
	eRoomVolume endon( "execute_the_breach" );
	eRoomVolume endon( "breach_aborted" );
	
	self thread breach_trigger_cleanup( eRoomVolume );
	// self trigger_on();// wtf is this for?
	if ( ( self.classname == "trigger_use" ) || ( self.classname == "trigger_use_touch" ) )
	{
		self setHintString( eRoomVolume.triggerHintString );
		if ( isdefined( eRoomVolume.eDoor ) )
		{
			// spawn a flashing objective on door frame
			eRoomVolume.eBreachmodel = spawn( "script_model", eRoomVolume.eDoor.origin );
			eRoomVolume.eBreachmodel.angles = eRoomVolume.eDoor.angles;
			eRoomVolume.eBreachmodel setmodel( level.door_objmodel );	
		}
	}
	self waittill( "trigger" );
	eRoomVolume notify( "execute_the_breach" );
}

breach_trigger_cleanup( eRoomVolume )
{
	eRoomVolume waittill( "execute_the_breach" );
	self trigger_off();
	if ( isdefined( eRoomVolume.eBreachmodel ) )
		eRoomVolume.eBreachmodel delete();
	
}
breach_abort( aBreachers )
{
	// self == > the room volume being breached
	self endon( "breach_complete" );
	self waittill( "breach_abort" );
	
	self.cleared = true;
	self thread breach_cleanup( aBreachers );	
}

breach_cleanup( aBreachers )
{
	// self == > the room volume being breached
	while ( !self.cleared )
		wait( 0.05 );
	if ( isdefined( self.badplace ) )
		badplace_delete( self.sBadplaceName );	
	
	while ( !self.cleared )
		wait( 0.05 );

	array_thread( aBreachers, ::breach_AI_reset, self );
}

breach_AI_reset( eVolume )
{
	self endon( "death" );
	
	self breach_reset_animname();
	self breach_reset_goaladius();
	eVolume.animEnt notify( self.ender );
	self notify( "stop_infinite_ammo" );
	
	self pushplayer( false );
}

breach_play_fx( sBreachType, bPlayDefaultFx )
{
	// self == > the room volume being breached
	self endon( "breach_aborted" );
	self endon( "breach_complete" );

	switch( sBreachType )
	{
		case "explosive_breach_left":
			self waittill( "play_breach_fx" );
			exploder( self.iExploderNum );
			thread play_sound_in_space( level.scr_sound[ "breach_wooden_door" ], self.eExploderOrigin.origin );
			if ( bPlayDefaultFx )
				playfx( level._effect[ "_breach_doorbreach_detpack" ], self.eExploderOrigin.origin, anglestoforward( self.eExploderOrigin.angles ) );
			break;
		case "shotgunhinges_breach_left":
			self waittill( "play_breach_fx" );
			exploder( self.iExploderNum );
			if ( bPlayDefaultFx )
				playfx( level._effect[ "_breach_doorbreach_kick" ], self.eExploderOrigin.origin, anglestoforward( self.eExploderOrigin.angles ) );			
			break;		
		case "flash_breach_no_door_right":
			// no effects since there is no door
			break;
		default:
			assertmsg( sBreachType + " is not a valid breachType" );
			break;
	}
}


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    BREACH UTILITY FUNCTIONS
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/ 

spawnHostile( eEntToSpawn )
{
	spawnedGuy = eEntToSpawn dospawn();
	spawn_failed( spawnedGuy );
	assert( isDefined( spawnedGuy ) );
	return spawnedGuy;
}

spawnBreachHostiles( arrayToSpawn )
{
	assertEx( ( arrayToSpawn.size > 0 ), "The array passed to spawnBreachHostiles function is empty" );
	spawnedGuys = [];
	for ( i = 0;i < arrayToSpawn.size;i++ )
	{
		guy = spawnHostile( arrayToSpawn[ i ] );
		spawnedGuys[ spawnedGuys.size ] = guy;
		
	}
	// check to ensure all the guys were spawned
	assertEx( ( arrayToSpawn.size == spawnedGuys.size ), "Not all guys were spawned successfully from spawnBreachHostiles" );
	
	// Return an array containing all the spawned guys
	return spawnedGuys;
}

give_infinite_ammo()
{
	self endon( "death" );
	self endon( "stop_infinite_ammo" );
	while ( true )
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
		wait( .5 );
	}
}

door_open( sType, eVolume, bPlaySound )
{
	if ( !isDefined( bPlaySound ) )
		bPlaySound = true;
		
	if ( bPlaysound == true )
		self playsound( level.scr_sound[ "breach_wood_door_kick" ] );

	
	switch( sType )
	{
		case "explosive":
			self thread door_fall_over( eVolume.animEnt );
			self door_connectpaths();
			self playsound( level.scr_sound[ "breach_wooden_door" ] );
			earthquake( 0.4, 1, self.origin, 1000 );
			radiusdamage( self.origin, 56, level.maxDetpackDamage, level.minDetpackDamage );
			break;
		case "shotgun":
			self thread door_fall_over( eVolume.animEnt );
			self door_connectpaths();
			self playsound( level.scr_sound[ "breach_wooden_door" ] );
			break;
	}
}

door_connectpaths()
{

	if ( self.classname == "script_brushmodel" )
		self connectpaths();
	else
	{
		blocker = getent( self.target, "targetname" );
		assertex( isdefined( blocker ), "A script_model door needs to target a script_brushmodel that blocks the door." );
		blocker hide();
		blocker notsolid();
		blocker connectpaths();	
	}
}

door_fall_over( animEnt )
{
	assert( isdefined( animEnt ) );
	vector = undefined;
	if ( self.classname == "script_model" )
		vector = anglestoforward( self.angles );
	else if ( self.classname == "script_brushmodel" )
		vector = self.vector;
	else
		assertmsg( "door needs to be either a script_model or a script_brushmodel" );
	dist = ( vector[ 0 ] * 20, vector[ 1 ] * 20, vector[ 2 ] * 20 );

	self moveto( self.origin + dist, .5, 0, .5 );
	
	rotationDummy = spawn( "script_origin", ( 0, 0, 0 ) );
	rotationDummy.angles = animEnt.angles;
	rotationDummy.origin = ( self.origin[ 0 ], self.origin[ 1 ], animEnt.origin[ 2 ] );
	
	self linkTo( rotationDummy );
	
	rotationDummy rotatepitch( 90, 0.45, 0.40 );
	wait 0.45;
	rotationDummy rotatepitch( - 4, 0.2, 0, 0.2 );
	wait 0.2;
	rotationDummy rotatepitch( 4, 0.15, 0.15 );
	wait 0.15;
	self unlink();
	rotationDummy delete();
}

breach_set_goaladius( fRadius )
{
	if ( !isdefined( self.old_goalradius ) )
		self.old_goalradius = self.goalradius;
	self.goalradius = fRadius;
}

breach_reset_goaladius()
{
	if ( isdefined( self.old_goalradius ) )
		self.goalradius = self.old_goalradius;
	self.old_goalradius = undefined;
}


breach_set_animname( animname )
{
	if ( !isdefined( self.old_animname ) )
		self.old_animname = self.animname;
	self.animname = animname;
}

breach_reset_animname()
{
	if ( isdefined( self.old_animname ) )
		self.animname = self.old_animname;
	self.old_animname = undefined;
}
