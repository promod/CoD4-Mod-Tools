/* 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 	
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 	

This is where all the vehicle / ai interactions happen

High level functions

	handle_attached_guys()// this is the setup for slots of guys on a vehicle threads notify handlers

	guy_runtovehicle( guy, vehicle )// this tells the guy to run to a vehicle and get in

	guy_enter( guy, vehicle, lastguy )// this puts the guy into the vehicle and tells him to idle
		
		guy_handle( guy, pos )// this handles the vehicles animation events( stand, attack, duck, turn, unload )
		
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 	
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 	
	
Lets say we want to add a "nose pick" event to the jeep passenger.
		
in _jeep  there is a thread called set_anims() where all sorts of animations and 
stuff are asigned to the positions a guy can ride in.

the element is the position where 0 is always the driver in the jeeps case 1 is the passenger.

in _jeep::set_anims() put add this

positions[ 1 ].nosepick = %jeep_passenger_nosepick;

	
in guy_handle() you have a bunch of pointers like this

	level.vehicle_aianimthread[ "idle" ] = ::guy_idle;
	level.vehicle_aianimthread[ "duck" ] = ::guy_duck;
	level.vehicle_aianimthread[ "stand" ] = ::guy_stand;

add to the list your pointer

	level.vehicle_aianimthread[ "nosepick" ] = ::guy_picknose;

then the event thread would looks something like this:

guy_picknose( guy, pos )
{
	animpos = anim_pos( self, pos );// first gets the animation struct information for the position of the guy.
	anim_endons( guy );// is the standard endons for these functions( vehicle dies, guy dies, new anim event happens )
	if ( isdefined( animpos.nosepick ) )// from there you put a check for your animation
		animontag( guy, animpos.sittag, animpos.nosepick );
	thread guy_idle( guy, pos );
}	

*/ 

#include maps\_utility;
#include common_scripts\utility;

#using_animtree( "generic_human" );

guy_enter( guy, vehicle )
{
	// do stuff that should happen BEFORE _spawner auto spawn logic below this
	assertEX( !isdefined( guy.ridingvehicle ), "ai can't ride two vehicles at the same time" );
	
	type = self.vehicletype;
	vehicleanim = level.vehicle_aianims[ type ];
	maxpos = level.vehicle_aianims[ type ].size;

	self.attachedguys[ self.attachedguys.size ] = guy;
	
	// set the position
	pos = set_pos( guy, maxpos );
	
	if ( !isdefined( pos ) )
	{
		return;		
	}
	
	if ( pos == 0 )
		guy.drivingVehicle = true;
	
	animpos = anim_pos( self, pos );
	self.usedPositions[ pos ] = true;
	guy.pos = pos;
	
	if ( isdefined( animpos.delay ) )
	{
		guy.delay = animpos.delay;
		if ( isdefined( animpos.delayinc ) )
		{
			self.delayer = guy.delay;
		}
	}
	
	if ( isdefined( animpos.delayinc ) )
	{
		self.delayer += animpos.delayinc;
		guy.delay = self.delayer;
	}
	
	guy.ridingvehicle = self;
	guy.orghealth = guy.health;
	guy.vehicle_idle = animpos.idle;			// multiple idle anims
	guy.vehicle_standattack = animpos.standattack;

//	guy.deathanim = animpos.death;

	guy.deathanimscript = animpos.deathscript;
	
	guy.standing = 0;
	
	guy.allowdeath = false;
	if ( isdefined( guy.deathanim ) && !isdefined( guy.magic_bullet_shield ) )
		guy.allowdeath = true;
		
	if ( isdefined( animpos.death ) )
		 thread guy_death( guy, animpos );
	
	if ( !isdefined( guy.vehicle_idle ) )
		guy.allowdeath = true;// these are the truck guys who are simply attached ai
	

	self.riders[ self.riders.size ] = guy;
	
	if ( !isdefined( animpos.explosion_death ) )
		thread guy_vehicle_death( guy );


	// do stuff that should happen AFTER _spawner auto spawn logic below this
	if ( guy.classname != "script_model" && spawn_failed( guy ) )
		return;

	org = self gettagorigin( animpos.sittag );
	angles = self gettagAngles( animpos.sittag );
	guy linkto( self, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );


	// some guys "holster" their weapons while operating a vehicle( flak88 guys ).
	// Some of the cod2 animations don't do anything with the weapon tag and
	// require script to remove the weapon, Ideally we would have guys who are riding
	// stash their gun to the sides( like in the jeep rider animations of cod2 )
	if ( isai( guy ) )
	{
		guy teleport( org, angles );
		
		guy.a.disablelongdeath = true;
		if ( isdefined( animpos.bHasGunWhileRiding ) && !animpos.bHasGunWhileRiding )
			guy gun_remove();  // these guys don't ever get their gun back through this script
		
		if ( isdefined( animpos.mgturret ) && !( isdefined( self.script_nomg ) && self.script_nomg > 0 ) )
 			thread guy_man_turret( guy, pos );// assumes first turret is the only turret for now
		
		// changes death anim based on speed of the vehicles
	}
	else
	{
		if ( isdefined( animpos.bHasGunWhileRiding ) && !animpos.bHasGunWhileRiding )
			detach_models_with_substr( guy, "weapon_" ); // drones shouldn't have weapon.
		guy.origin = org;
		guy.angles = angles;
	}
	
	// let the vehicle know that it should crash because the driver is dead
	if ( pos == 0 && isdefined(vehicleanim[0].death) )
		thread driverdead( guy ); 
	
	// reacts to groupedanimevent notify
	thread guy_handle( guy, pos );
	thread guy_idle( guy, pos );
	
}

handle_attached_guys()
{
	type = self.vehicletype;
	
	self.attachedguys = [];
	if ( !( isdefined( level.vehicle_aianims ) && isdefined( level.vehicle_aianims[ type ] ) ) )
		return;
		
	maxpos = level.vehicle_aianims[ type ].size;
	
	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "ai_wait_go" )
		thread ai_wait_go();
		
	self.runningtovehicle = [];
	self.usedPositions = [];
	self.getinorgs = [];
	self.delayer = 0;
	
	vehicleanim = level.vehicle_aianims[ type ];
	for ( i = 0;i < maxpos;i++ )
	{
		self.usedPositions[ i ] = false;
		if ( isdefined( self.script_nomg ) && self.script_nomg && isdefined( vehicleanim[ i ].bIsgunner ) && vehicleanim[ i ].bIsgunner )
			self.usedpositions[ 1 ] = true;// if this is a gunner position and script no mg is set then don't autoassign a guy to this position
	}
}

load_ai_goddriver( array )
{
	load_ai( array, true );
}

guy_death( guy, animpos  )
{
	waittillframeend; // override _spawner set health
	guy endon ("death");
	guy.allowdeath = false;
	guy.script_startinghealth = 100000;
	guy.health = 100000;
	guy endon ( "jumping_out" );
	guy waittill ( "damage" ); //fragile guy
	thread guy_deathimate_me( guy,animpos );
}

guy_deathimate_me( guy,animpos )
{
	animtimer = gettime()+ ( getanimlength( animpos.death )*1000 );
	angles = guy.angles;
	origin = guy.origin;
	guy = convert_guy_to_drone( guy );
	[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", origin );
	detach_models_with_substr( guy, "weapon_" );
	guy linkto ( self, animpos.sittag, (0,0,0),(0,0,0) );
	guy notsolid();
	thread animontag( guy, animpos.sittag, animpos.death );
	if(!isdefined(animpos.death_delayed_ragdoll))
		guy waittillmatch ( "animontagdone" , "start_ragdoll" );
	else
	{
		guy unlink();
		guy startragdoll();
		wait animpos.death_delayed_ragdoll;
		guy delete();
		return;
	}
	guy unlink();
	if( getdvar("ragdoll_enable") == "0" )
	{
		guy delete();
		return;
	}
	
	while( gettime() < animtimer && !guy isragdoll() )
	{
		guy startragdoll();
		wait .05;
	}
	if(!guy isragdoll())
		guy delete(); // better gone than doing random crap	
}

load_ai( array, bGoddriver )
{
	if(!isdefined(bGoddriver))
		bGoddriver = false;
	if ( !isdefined( array ) )
	{
		array = vehicle_get_riders();
	}
	
	array_levelthread( array, ::get_in_vehicle, bGoddriver );
}

is_rider( guy )
{
	for ( i = 0;i < self.riders.size;i++ )
	{
		if ( self.riders[ i ] == guy )
		{
			return true;
		}
	}
	return false;
}

vehicle_get_riders()
{
	// get the AI that are assigned to this vehicle, so either were riding in it or are riding in it
	array = [];

	ai = getaiarray( self.script_team );
	for ( i = 0;i < ai.size;i++ )
	{
		guy = ai[ i ];
		if ( !isdefined( guy.script_vehicleride ) )
			continue;
			
		if ( guy.script_vehicleride != self.script_vehicleride )
			continue;
		
		array[ array.size ] = guy;
	}

	return array;
}

get_my_vehicleride()
{
	// get the AI that are assigned to this vehicle, so either were riding in it or are riding in it
	array = [];
	
	assertex( isdefined( self.script_vehicleride ), "Tried to get my ride but I have no .script_vehicleride" );

	vehicles = getentarray( "script_vehicle", "classname" );
	for ( i = 0; i < vehicles.size; i++ )
	{
		vehicle = vehicles[ i ];
		
		if ( !isdefined( vehicle.script_vehicleride ) )
			continue;
			
		if ( vehicle.script_vehicleride != self.script_vehicleride )
			continue;
		
		array[ array.size ] = vehicle;
	}

	assertex( array.size == 1, "Tried to get my ride but there was zero or multiple rides to choose from" );
	return array[ 0 ];
}

get_in_vehicle( guy, bGoddriver )
{
	if ( is_rider( guy ) )
	{
		// this guy is already riding!
		return;
	}
		
	if ( !handle_detached_guys_check() )
	{
		// No more spots available!
		return;
	}
	
	assertEX( isalive( guy ), "tried to load a vehicle with dead guy, check your AI count to assure spawnability of ai's" );

	//TODO, next game: this is very similar to anim_reach but was done around the same time or before I knew such thing existed.  
	guy_runtovehicle( guy, self,bGoddriver );
}

handle_detached_guys_check()
{
	if ( vehicle_hasavailablespots() )
		return true;

	assertmsg( "script sent too many ai to vehicle( max is: " + level.vehicle_aianims[ self.vehicletype ].size + " )" );
}

vehicle_hasavailablespots()
{
	// spots available - spots being run to by ai
	// simple check  This could get a lot more complicated
	if ( level.vehicle_aianims[ self.vehicletype ].size - self.runningtovehicle.size )
		return true;
	else
		return false;
}

guy_runtovehicle_loaded( guy, vehicle )
{
	vehicle endon( "death" );
	guy waittill_any( "long_death", "death", "enteredvehicle" );
	vehicle.runningtovehicle = array_remove( vehicle.runningtovehicle, guy );
	if ( !vehicle.runningtovehicle.size && vehicle.riders.size && vehicle.usedpositions[0] )
		vehicle notify( "loaded" );
}

remove_magic_bullet_shield_from_guy_on_unload_or_death( guy )
{
	self waittill_any( "unload","death" );
	guy stop_magic_bullet_shield();
}

guy_runtovehicle( guy, vehicle, bGoddriver )
{
	if(!isdefined(bGoddriver))
		bGoddriver = false;
	vehicleanim = level.vehicle_aianims[ vehicle.vehicletype ];
	if ( isdefined( vehicle.runtovehicleoverride ) )
	{
		vehicle thread [[ vehicle.runtovehicleoverride ]]( guy );
		return;
	}
	vehicle endon( "death" );
	guy endon( "death" );
	vehicle.runningtovehicle[ vehicle.runningtovehicle.size ] = guy;
	thread guy_runtovehicle_loaded( guy, vehicle );
	availablepositions = [];
	chosenorg = undefined;
	origin = 0;
	
	// check for get in animations and simply stuff the guy into the vehiclee if non exist
	bIsgettin = false;
	for ( i = 0;i < vehicleanim.size;i++ )
		if ( isdefined( vehicleanim[ i ].getin ) )
			bIsgettin = true;
			
	if ( !bIsgettin )
	{
		guy notify( "enteredvehicle" );
		guy_enter_vehicle( guy, vehicle );
		return;
	}
	
	while ( vehicle getspeedmph() > 1 )
		wait .05;
		
	positions = vehicle get_availablepositions();
	if ( !vehicle.usedPositions[ 0 ] )
	{
		chosenorg = vehicle vehicle_getInstart( 0 );// driver first!
		if( bGoddriver )
		{
			assertEX( !isdefined(guy.magic_bullet_shield), "magic_bullet_shield guy told to god mode drive a vehicle, you should simply load_ai without the god function for this guy");
			guy thread magic_bullet_shield();
			thread remove_magic_bullet_shield_from_guy_on_unload_or_death( guy );
		}
	}
	else if ( positions.availablepositions.size )
		chosenorg = getclosest( guy.origin, positions.availablepositions );
	else
		chosenorg = undefined;
	
	if ( ( !positions.availablepositions.size ) && ( positions.nonanimatedpositions.size ) )
	{
		guy notify( "enteredvehicle" );
		guy_enter_vehicle( guy, vehicle );
		return;		
	}		
	else if ( !isdefined( chosenorg ) )
		return;// nothing available

	origin = chosenorg.origin;// + vector_multiply( vectornormalize( chosenorg.origin - vehicle.origin ), 15 );// move the origin out a bit sometimes the start position of the animation is just inside the colision
	angles = chosenorg.angles;

	guy.forced_startingposition = chosenorg.pos;
	// flag it so no others use it
	vehicle.usedpositions[ chosenorg.pos ] = true;


	// short circuit any _spawner auto destination behavior
	guy.script_moveoverride = true;
	guy notify( "stop_going_to_node" );
	
	guy set_forcegoal();
	guy.goalradius = 16;
	guy setgoalpos( origin );
	guy waittill( "goal" );
	guy unset_forcegoal();
	
	guy.allowdeath = false;  // they will get the allowdeath back when they get out or get it turned on if there is a death animation.

	if ( isdefined( chosenorg ) )
	{
		if ( isdefined( vehicleanim[ chosenorg.pos ].vehicle_getinanim ) )
		{
			vehicle = vehicle getanimatemodel();
			vehicle thread setanimrestart_once( vehicleanim[ chosenorg.pos ].vehicle_getinanim, vehicleanim[ chosenorg.pos ].vehicle_getinanim_clear );
		}
		
		if ( isdefined( vehicleanim[ chosenorg.pos ].vehicle_getinsoundtag ) )
			origin = 	vehicle gettagorigin( vehicleanim[ chosenorg.pos ].vehicle_getinsoundtag );
		else 
			origin = vehicle.origin;
		if ( isdefined( vehicleanim[ chosenorg.pos ].vehicle_getinsound ) )
			sound = vehicleanim[ chosenorg.pos ].vehicle_getinsound;
		else
			sound = "truck_door_open";
		thread maps\_utility::play_sound_in_space( sound, origin );
		
//		if ( isdefined( vehicleanim[ chosenorg.pos ].vehicle_getinsound ) )
//		{
//			animatemodel = vehicle getanimatemodel();
//			animatemodel thread play_sound_on_entity( vehicleanim[ chosenorg.pos ].vehicle_getinsound );
//		}
		vehicle animontag( guy, vehicleanim[ chosenorg.pos ].sittag, vehicleanim[ chosenorg.pos ].getin );
	}
	guy notify( "enteredvehicle" );
	guy_enter_vehicle( guy, vehicle );
}

driverdead( guy )
{
	if ( maps\_vehicle::isHelicopter() )
		return;

	self.driver = guy;
	self endon( "death" );
	guy waittill( "death" );
	self.deaddriver = true;// vehiclechase crash
	self setwaitspeed(0);
	self setspeed(0,4); // nothin fancy here.
	self waittill( "reached_wait_speed" );
	self notify ("unload");
}


copy_cat()
{
	model = spawn( "script_model", self.origin );
	model setmodel( self.model );
	size = self getattachsize();
	for ( i = 0;i < size;i++ )
		model attach( self getattachmodelname( i ) );
	return model;
}

anim_pos( vehicle, pos )
{
	return level.vehicle_aianims[ vehicle.vehicletype ][ pos ];
}

guy_deathhandle( guy, pos )
{
// 	self endon( "death" );
	guy waittill( "death" );
	if ( !isdefined( self ) )
		return;
	self.riders = array_remove( self.riders, guy );
	self.usedPositions[ pos ] = false;	
}

setup_aianimthreads()
{
	if ( !isdefined( level.vehicle_aianimthread ) )
		level.vehicle_aianimthread = [];
		
	if ( !isdefined( level.vehicle_aianimcheck ) )
		level.vehicle_aianimcheck = [];
		
	level.vehicle_aianimthread[ "idle" ] = ::guy_idle;
	level.vehicle_aianimthread[ "duck" ] = ::guy_duck;
	
	level.vehicle_aianimthread[ "duck_once" ] = ::guy_duck_once;
	level.vehicle_aianimcheck[ "duck_once" ] = ::guy_duck_once_check;

	level.vehicle_aianimthread[ "weave" ] = ::guy_weave;
	level.vehicle_aianimcheck[ "weave" ] = ::guy_weave_check;
	
	level.vehicle_aianimthread[ "stand" ] = ::guy_stand;

	level.vehicle_aianimthread[ "turn_right" ] = ::guy_turn_right;
	level.vehicle_aianimcheck[ "turn_right" ] = ::guy_turn_right_check;
	
	level.vehicle_aianimthread[ "turn_left" ] = ::guy_turn_left;
	level.vehicle_aianimcheck[ "turn_left" ] = ::guy_turn_right_check;
	
	level.vehicle_aianimthread[ "turn_hardright" ] = ::guy_turn_hardright;

	level.vehicle_aianimthread[ "turn_hardleft" ] = ::guy_turn_hardleft;
	level.vehicle_aianimthread[ "turret_fire" ] = ::guy_turret_fire;
	level.vehicle_aianimthread[ "turret_turnleft" ] = ::guy_turret_turnleft;
	level.vehicle_aianimthread[ "turret_turnright" ] = ::guy_turret_turnright;
	level.vehicle_aianimthread[ "unload" ] = ::guy_unload;
	level.vehicle_aianimthread[ "reaction" ] = ::guy_turret_turnright;
}

guy_handle( guy, pos )
{
	
	guy.vehicle_idling = true;
	guy.queued_anim_threads = [];
	thread guy_deathhandle( guy, pos );
	thread guy_queue_anim( guy, pos );
	guy endon( "death" );
	guy endon( "jumpedout" );
	while ( 1 )
	{
		//TODO NEXT GAME.. This shouldn't wait, should be a function but will likely be rewritten anyway to follow the anim_single conventions
		self waittill( "groupedanimevent", other );
		if ( isdefined( level.vehicle_aianimcheck[ other ] ) && ! [[ level.vehicle_aianimcheck[ other ] ]]( guy, pos ) )
			continue;// ignore this if they have a check function and this anim doesn't exist
			
		if ( isdefined( self.groupedanim_pos ) )
		{
			if(pos != self.groupedanim_pos)
				continue;
			waittillframeend;
			self.groupedanim_pos = undefined; // set before the groupedanimevent call.
		}
			
		if ( isdefined( level.vehicle_aianimthread[ other ] ) )
		{
			if ( isdefined( self.queueanim ) && self.queueanim )
			{
				add_anim_queue( guy, level.vehicle_aianimthread[ other ] );
				waittillframeend;// allows all of the guys to queue their anims if necessary.
				self.queueanim = false;
			}
			else
			{
				guy notify( "newanim" );
				guy.queued_anim_threads = [];// sorry que, this animation is more important.
				thread [[ level.vehicle_aianimthread[ other ] ]]( guy, pos );
			}
		}
		else
			println( "leaaaaaaaaaaaaaak", other );
	}
}


// attempt at fixing pops by using a que. I tried this once in CoD1 once, maybe I can make it work now.
add_anim_queue( guy, sthread )
{
	guy.queued_anim_threads[ guy.queued_anim_threads.size ] = sthread;
	 
}

guy_queue_anim( guy, pos )
{
	guy endon( "death" );
	self endon( "death" );
	lastanimframe = gettime() - 100;
	while ( 1 )
	{
		if ( guy.queued_anim_threads.size )
		{
			if ( gettime() != lastanimframe )
				guy waittill( "anim_on_tag_done" );
			if ( !guy.queued_anim_threads.size )
				continue;// there has been an interuption
			guy notify( "newanim" );
			thread [[ guy.queued_anim_threads[ 0 ] ]]( guy, pos );
			guy.queued_anim_threads = array_remove( guy.queued_anim_threads, guy.queued_anim_threads[ 0 ] );
			wait .05;
		}
		else
		{
// 			wait .05;// maybe wait on some notify.
			guy waittill( "anim_on_tag_done" );
			lastanimframe = gettime();
		}
	}
	
}

// old kubelwagons..
guy_stand( guy, pos )
{
	animpos = anim_pos( self, pos );
	vehicleanim = level.vehicle_aianims[ self.vehicletype ];
	if ( !isdefined( animpos.standup ) )
		return;
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animontag( guy, animpos.sittag, animpos.standup );
	guy_stand_attack( guy, pos );
}

guy_stand_attack( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	
	guy.standing = 1;
	mintime = 0;
	while ( 1 )
	{
		timer2 = gettime() + 2000;
		while ( gettime() < timer2 && isdefined( guy.enemy ) )
			animontag( guy, animpos.sittag, guy.vehicle_standattack, undefined, undefined, "firing" );
		rnum = randomint( 5 ) + 10;
		for ( i = 0;i < rnum;i++ )
			animontag( guy, animpos.sittag, animpos.standidle );
	}
}

guy_stand_down( guy, pos )
{
	animpos = anim_pos( self, pos );
	if ( !isdefined( animpos.standdown ) )
	{
		thread guy_stand_attack( guy, pos );
		return;
	}
	animontag( guy, animpos.sittag, animpos.standdown );
	guy.standing = 0;
	thread guy_idle( guy, pos );
}

driver_idle_speed( driver, pos )
{
	driver endon( "newanim" );
	self endon( "death" );
	driver endon( "death" );

	animpos = anim_pos( self, pos );
	while ( 1 )
	{
		if ( self getspeedmph() == 0 )
			driver.vehicle_idle = animpos.idle_animstop;
		else
			driver.vehicle_idle = animpos.idle_anim;
		wait .25;	
	}	
}

guy_reaction( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	if ( isdefined( animpos.reaction ) )
		animontag( guy, animpos.sittag, animpos.reaction );
	thread guy_idle( guy, pos );
}

guy_turret_turnleft( guy, pos )
{
	animpos = anim_pos( self, pos );
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	while ( 1 )
		animontag( guy, animpos.sittag, guy.turret_turnleft );
}

guy_turret_turnright( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	while ( 1 )
		animontag( guy, animpos.sittag, guy.turret_turnleft );
}

guy_turret_fire( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.turret_fire ) )
		animontag( guy, animpos.sittag, animpos.turret_fire );
	thread guy_idle( guy, pos );
}

guy_idle( guy, pos, ignoredeath )
{
	guy endon( "newanim" );
	if( !isdefined(ignoredeath))
		self endon( "death" );
	guy endon( "death" );
	guy.vehicle_idling = true;
	guy notify( "gotime" );

	if ( !isdefined( guy.vehicle_idle ) )
	{
//		if ( isdefined( level.whackamolethread ) )
//			thread [[ level.whackamolethread ]]( guy );
		return;// truck guys just stand there linked.. hack for Halftrack guys
	}
	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.mgturret ) )
		return;// mggunners don't idle.
	if ( isdefined( animpos.hideidle ) && animpos.hideidle )
		guy hide();
	if ( isdefined( animpos.idle_animstop ) && isdefined( animpos.idle_anim ) )// idle alternates between stopping and going
		thread driver_idle_speed( guy, pos );
	while ( 1 )
	{
		guy notify( "idle" );
		if ( isdefined( guy.vehicle_idle_override ) )
			animontag( guy, animpos.sittag, guy.vehicle_idle_override );
		else if ( isdefined( animpos.idleoccurrence ) )// kubelwagons have random idles like guy driver pointing forward
		{
			theanim = randomoccurrance( guy, animpos.idleoccurrence );
			animontag( guy, animpos.sittag, guy.vehicle_idle[ theanim ] );
		}
		else if ( isdefined( guy.playerpiggyback ) && isdefined( animpos.player_idle ) )
			animontag( guy, animpos.sittag, animpos.player_idle );
		else	// jeeps just have one idle
		{
			// animate the vehicle with this guy.( IE: driver with stearing wheel )
			if ( isdefined( animpos.vehicle_idle ) )
				self thread setanimrestart_once( animpos.vehicle_idle );
			animontag( guy, animpos.sittag, guy.vehicle_idle );
		}
	}
}

randomoccurrance( guy, occurrences )
{
	range = [];
	totaloccurrance = 0;
	for ( i = 0;i < occurrences.size;i++ )
	{
		totaloccurrance += occurrences[ i ];
		range[ i ] = totaloccurrance;
	}
	pick = randomint( totaloccurrance );
	for ( i = 0;i < occurrences.size;i++ )
		if ( pick < range[ i ] )
			return i;
}


guy_duck_once_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).duck_once );
}

guy_duck_once( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.duck_once ) )
	{
		if ( isdefined( animpos.vehicle_duck_once ) )
			self thread setanimrestart_once( animpos.vehicle_duck_once );
		animontag( guy, animpos.sittag, animpos.duck_once );
	}
	thread guy_idle( guy, pos );
}

guy_weave_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).weave );
}

guy_weave( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.weave ) )
	{
		if ( isdefined( animpos.vehicle_weave ) )
			self thread setanimrestart_once( animpos.vehicle_weave );
		animontag( guy, animpos.sittag, animpos.weave );
	}
	thread guy_idle( guy, pos );
}

guy_duck( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.duckin ) )
		animontag( guy, animpos.sittag, animpos.duckin );
	thread guy_duck_idle( guy, pos );
}

guy_duck_idle( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );

	animpos = anim_pos( self, pos );
	theanim = randomoccurrance( guy, animpos.duckidleoccurrence );
	while ( 1 )
		animontag( guy, animpos.sittag, animpos.duckidle[ theanim ] );
}

guy_duck_out( guy, pos )
{
	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.ducking ) && guy.ducking )
	{
		animontag( guy, animpos.sittag, animpos.duckout );
		guy.ducking = false;
	}
	thread guy_idle( guy, pos );
}

guy_unload_que( guy )
{
	self endon( "death" );
	self.unloadque = array_add( self.unloadque, guy );
	guy waittill_any( "death", "jumpedout" );
	self.unloadque = array_remove( self.unloadque, guy );
	if ( !self.unloadque.size )
	{
		self notify( "unloaded" );
		self.unload_group = "default";
	}
}

riders_unloadable( unload_group )
{
	if( ! self.riders.size )
		return false;
	for ( i = 0; i < self.riders.size; i++ )
	{
		assert( isdefined( self.riders[i].pos ) );
		if( check_unloadgroup( self.riders[i].pos, unload_group ) )
			return true;
	}
	return false;
}


check_unloadgroup( pos, unload_group )
{
	if( ! isdefined( unload_group ) )
		unload_group = self.unload_group;
		
	type = self.vehicletype;
	if ( !isdefined( level.vehicle_unloadgroups[ type ] ) )
		return true;// just unloads everybody 
		
	if ( !isdefined( level.vehicle_unloadgroups[ type ][ unload_group ] ) )
	{
		println( "Invalid Unload group on node at origin: " + self.currentnode.origin + " with group:( \"" + unload_group + "\" )" );
		println( "Unloading everybody" );
		return true;
	}

	group = level.vehicle_unloadgroups[ type ][ unload_group ];
	for ( i = 0;i < group.size;i++ )
		if ( pos == group[ i ] )
			return true;
	return false;
}


getoutrig_model_idle( model, tag, animation  )
{
	self endon( "unload" );
	while ( 1 )
		animontag( model, tag, animation );
}

getoutrig_model( animpos, model, tag, animation, bIdletillunload )
{

	type = self.vehicletype;
	if ( bIdletillunload )
	{
		thread getoutrig_model_idle( model, tag , level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].idleanim );
		self waittill( "unload" );
	}
	
	self.unloadque = array_add( self.unloadque, model );
	
	self thread getoutrig_abort( model, tag, animation );
	if ( !isdefined( self.crashing ) )
		animontag( model, tag, animation );
	
	model unlink();
	
	// looks like somebody deleted the helicopter while that animation was playing.  and errored so I'm throwing in this defensive fix!.
	if( !isdefined( self ) )
	{
		model delete();
		return;
	}
	
	assert( isdefined( self.unloadque ) );
	
	self.unloadque = array_remove( self.unloadque, model );
	if ( !self.unloadque.size )
		self notify( "unloaded" );
	self.getoutrig[ animpos.getoutrig ] = undefined;
	wait 10;
	model delete();// possibly do something to delete when the player is not looking at it.	
}

getoutrig_disable_abort_notify_after_riders_out()
{
	wait .05;
	while( isalive( self ) && self.unloadque.size > 2 )
		wait .05; // 1 unloadque will be there for the rope.
	if( ! isalive( self ) || ( isdefined(self.crashing) && self.crashing ) )
		return;
	self notify ( "getoutrig_disable_abort" );
}


getoutrig_abort_while_deploying()
{
	self endon ("end_getoutrig_abort_while_deploying");
	while ( !isdefined( self.crashing ) )
		wait 0.05;
	array_levelthread( self.riders, ::deleteent );
	self notify ("crashed_while_deploying");
}


getoutrig_abort( model, tag, animation )
{

	totalAnimTime = getanimlength( animation );
	ropesFallAnimTime = totalAnimTime - 1.0;
	if(self.vehicletype == "mi17")
		ropesFallAnimTime = totalAnimTime - .5; //go go ghetto numbers
		
	ropesDeployedAnimTime = 2.5;
	
	assert( totalAnimTime > ropesDeployedAnimTime );
	assert( ropesFallAnimTime - ropesDeployedAnimTime > 0 );
	
	self endon( "getoutrig_disable_abort" );
	
	thread getoutrig_disable_abort_notify_after_riders_out();
//	self thread notify_delay( "getoutrig_disable_abort", ropesFallAnimTime - ropesDeployedAnimTime );

	thread 	getoutrig_abort_while_deploying();
	
	waittill_notify_or_timeout( "crashed_while_deploying" , ropesDeployedAnimTime );
	
	self notify ("end_getoutrig_abort_while_deploying");
	
	// ropes are deployed, wait for a chopper death if it isn't dead already
	while ( !isdefined( self.crashing ) )
		wait 0.05;
	
	// make the rope fall by jumping to the end of it's animation where it falls
	thread animontag( model, tag, animation );
	waittillframeend;
	model setanimtime( animation, ropesFallAnimTime / totalAnimTime );
	
	// all the guys on the rope must fall off too
	for ( i = 0 ; i < self.riders.size ; i++ )
	{
		if ( !isdefined( self.riders[ i ] ) )
			continue;
		if ( !isdefined( self.riders[ i ].ragdoll_getout_death ) )
			continue;
		if ( self.riders[ i ].ragdoll_getout_death != 1 )
			continue;
		if ( !isdefined( self.riders[ i ].ridingvehicle ) )
			continue;
		// thread animontag_ragdoll_death( self.riders[ i ] );
		self.riders[ i ] notify( "damage", 100, self.riders[ i ].ridingvehicle );
	}
}

setanimrestart_once( vehicle_anim, bClearAnim )
{
	self endon( "death" );
	self endon( "dont_clear_anim" );
	if ( !isdefined( bClearAnim ) )
		bClearAnim = true;
	cycletime = getanimlength( vehicle_anim );
	self SetAnimRestart( vehicle_anim );
	wait cycletime;
	if ( bClearAnim )
		self clearanim( vehicle_anim, 0 );
}


getout_rigspawn( animatemodel, pos, bIdletillunload )
{
	if ( !isdefined( bIdletillunload ) )
		bIdletillunload = true;
	type = self.vehicletype;
	animpos = anim_pos( self, pos );
	
	if ( isdefined( self.attach_model_override ) && isdefined( self.attach_model_override[ animpos.getoutrig ] ) )
		overrridegetoutrig = true;
	else
		overrridegetoutrig = false;
	if ( !isdefined( animpos.getoutrig ) || isdefined( self.getoutrig[ animpos.getoutrig ] ) || overrridegetoutrig )
		return;// already one in place
	origin =  animatemodel gettagorigin( level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag );
	angles =  animatemodel gettagangles( level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag );

	self.getoutriganimating[ animpos.getoutrig ] = true;

	getoutrig_model = spawn( "script_model", origin );
	getoutrig_model.angles = angles;
	getoutrig_model.origin = origin;
	getoutrig_model setmodel( level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].model );

	self.getoutrig[ animpos.getoutrig ] = getoutrig_model;// flag this model as out
	                                        
	getoutrig_model UseAnimTree( #animtree );
// 			getoutrig_model UseAnimTree( level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].animtree );

	getoutrig_model linkto( animatemodel, level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );								
	thread getoutrig_model( animpos, getoutrig_model, level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag, level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].dropanim, bIdletillunload );
	return getoutrig_model;
}
   
check_sound_tag_dupe( soundtag )
{
	// long day. this is probably 10 times more complicated than it needs to be.
	
	if( !isdefined( self.sound_tag_dupe ) )
		self.sound_tag_dupe = [];
		
	duped = false;
	
	if( !isdefined( self.sound_tag_dupe[ soundtag ] ) )
		self.sound_tag_dupe[ soundtag ] = true;
	else
		duped = true;
	
	thread check_sound_tag_dupe_reset( soundtag );
	
	return duped;
}

check_sound_tag_dupe_reset( soundtag )
{
	wait .05;
	if( ! isdefined( self ) )
		return;
	self.sound_tag_dupe[ soundtag ] = false;
	
	keys = getarraykeys(self.sound_tag_dupe);
	
	for ( i = 0; i < keys.size; i++ )
		if( self.sound_tag_dupe[ keys[i] ] )
			return;
			
	self.sound_tag_dupe = undefined;
	
}



guy_unload( guy, pos )
{
	animpos = anim_pos( self, pos );
	type = self.vehicletype;
	// check to see if this guy is in the unload group if not then go to idle and ignore the unload call
	if ( !check_unloadgroup( pos ) )
	{
		 thread guy_idle( guy, pos );
		 return;
	}
	// no getout for this guy.
	if ( !isdefined( animpos.getout ) )
	{
		thread guy_idle( guy, pos );
		return;
	}
	if ( isdefined( animpos.hideidle ) && animpos.hideidle )
		guy show();// bleh. hacking out nonexitant idle animations on seaknight
	thread guy_unload_que( guy );
	self endon( "death" );
	if ( isai( guy ) && isalive( guy ) )
		guy endon( "death" );
	
	
	animatemodel = getanimatemodel();
		
	if ( isdefined( animpos.vehicle_getoutanim ) )
	{
		animatemodel thread setanimrestart_once( animpos.vehicle_getoutanim, animpos.vehicle_getoutanim_clear );
		sound_tag_dupped = false;
		if ( isdefined( animpos.vehicle_getoutsoundtag ) )
		{
			sound_tag_dupped = check_sound_tag_dupe( animpos.vehicle_getoutsoundtag );
			origin = 	animatemodel gettagorigin( animpos.vehicle_getoutsoundtag );
		}
		else 
			origin = animatemodel.origin;
		if ( isdefined( animpos.vehicle_getoutsound ) )
			sound = animpos.vehicle_getoutsound;
		else
			sound = "truck_door_open";
		if( ! sound_tag_dupped )
			thread maps\_utility::play_sound_in_space( sound, origin );
		sound_tag_dupped = undefined;
	}
	
	delay = 0;
	
	if ( isdefined( animpos.getout_timed_anim ) )
		delay += getanimlength( animpos.getout_timed_anim );
	if ( isdefined( animpos.delay ) )
		delay += animpos.delay;
	if ( isdefined( guy.delay ) )
		delay += guy.delay;
	if ( delay > 0 )
	{
		thread guy_idle( guy, pos );
		wait delay;
	}
	
	// handle those guys who are standing when a vehicle unloads
	hascombatjumpout = isdefined( animpos.getout_combat );
	if ( !hascombatjumpout && guy.standing )
		guy_stand_down( guy, pos );
	else if ( !hascombatjumpout && !guy.vehicle_idling && isdefined( guy.vehicle_idle ) )
		guy waittill( "idle" );

	guy.deathanim = undefined;
	guy.deathanimscript = undefined;
	
	guy notify( "newanim" );
	
	if ( isai( guy ) )
		guy pushplayer( true );
	// some vehicles don't require an unload animation like the flak88 where all the guys are animating on the ground
	// some guys don't unload at all and stick to the vehicle till death!
	
	bNoanimUnload = false;
	if ( isdefined( animpos.bNoanimUnload ) )
		bNoanimUnload = true;
	else if ( 	!isdefined( animpos.getout ) || 
				( !isdefined( self.script_unloadmgguy ) && ( isdefined( animpos.bIsgunner ) && animpos.bIsgunner ) ) || 
				isdefined( self.script_keepdriver ) && pos == 0 )
	{
		self thread guy_idle( guy, pos );
		return;
	}

	if ( guy should_give_orghealth() )
	{
		guy.health = guy.orghealth;
	}

	guy.orghealth = undefined;
	if ( isai( guy ) && isalive( guy ) )
		guy endon( "death" );
	guy.allowdeath = false;// nobody should die during the transition

	// some exits all happen at a special tag the halftrack guys all use the same tag to exit but a different tag to sit at.
	if ( isdefined( animpos.exittag ) )
		tag = animpos.exittag;
	else
		tag = animpos.sittag;
	
	if ( hascombatjumpout && guy.standing )
		animation = animpos.getout_combat;
	else if ( isdefined( guy.get_out_override ) )
		animation = guy.get_out_override;
	else if ( isdefined( guy.playerpiggyback ) && isdefined( animpos.player_getout ) )
		animation = animpos.player_getout;
	else
		animation = animpos.getout;


	if ( !bNoanimUnload )
	{
		thread guy_unlink_on_death( guy );
		
		// throw out the rope before unloading
		if ( isdefined( animpos.getoutrig ) )
		{
			if ( ! isdefined( self.getoutrig[ animpos.getoutrig ] ) )
			{
				thread guy_idle( guy, pos );// idle while rope is deploying
				getoutrig_model = self getout_rigspawn( animatemodel, guy.pos, false );
				// animontag( getoutrig_model, level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].tag, level.vehicle_attachedmodels[ type ][ animpos.getoutrig ].idleanim );
			}			
		}

		if ( isdefined( animpos.getoutsnd ) )
			guy thread play_sound_on_tag( animpos.getoutsnd, "J_Wrist_RI", true );
	
		if ( isdefined( guy.playerpiggyback ) && isdefined( animpos.player_getout_sound ) )
			guy thread play_sound_on_entity( animpos.player_getout_sound );

		if ( isdefined( animpos.getoutloopsnd ) )
			guy thread play_loop_sound_on_tag( animpos.getoutloopsnd );

		if ( isdefined( guy.playerpiggyback ) && isdefined( animpos.player_getout_sound_loop ) )
			level.player thread play_loop_sound_on_entity( animpos.player_getout_sound_loop );

		guy notify( "newanim" );
		guy notify( "jumping_out");
		
		// testing, default to this while unloading. should fix drones that die on an exploding vehicle.
		guy.ragdoll_getout_death = true;
		
		if ( isdefined( animpos.ragdoll_getout_death ) )
		{
			guy.ragdoll_getout_death = true;
			if ( isdefined( animpos.ragdoll_fall_anim ) )
				guy.ragdoll_fall_anim = animpos.ragdoll_fall_anim;
		}
		
		animontag( guy, tag, animation );
		//this is for a secondary bm21 exit animation
		if ( isdefined( animpos.getout_secondary ) )
		{
			secondaryunloadtag = tag;
			if ( isdefined( animpos.getout_secondary_tag ) )
				secondaryunloadtag = animpos.getout_secondary_tag;
			animontag( guy, secondaryunloadtag, animpos.getout_secondary);
		}
		

		// end all the loop sounds
		if ( isdefined( guy.playerpiggyback ) && isdefined( animpos.player_getout_sound_loop ) )
			level.player thread stop_loop_sound_on_entity( animpos.player_getout_sound_loop );

		if ( isdefined( animpos.getoutloopsnd ) )
			guy thread stop_loop_sound_on_entity( animpos.getoutloopsnd );
			
			
			
		if ( isdefined( guy.playerpiggyback ) && isdefined( animpos.player_getout_sound_end ) )
			level.player thread play_sound_on_entity( animpos.player_getout_sound_end );
	}
	
	self.riders = array_remove( self.riders, guy );
	self.usedPositions[ pos ] = false;
	guy.ridingvehicle = undefined;
	guy.drivingVehicle = undefined;
	
	if ( !isalive( self ) && !isdefined( animpos.unload_ondeath ) )
	{
		guy delete();
		return;
	}

	guy unlink();
	if ( !isdefined( guy.magic_bullet_shield ) )
		guy.allowdeath = true;// nobody should die during the transition
	
	if ( !isai( guy ) ) 
	{ 
		if ( guy.drone_delete_on_unload == true )
		{	
			guy delete();
			return;
		}

		guy = makerealai( guy );
	}
	
	
	if ( isalive( guy ) )
	{
		guy.a.disablelongdeath = false;
		guy.forced_startingposition = undefined;
		guy notify( "jumpedout" );
//		guy unlink();
		
		if ( isdefined( animpos.getoutstance ) )
		{
			guy.desired_anim_pose = animpos.getoutstance;	
			guy allowedstances( "crouch" );
			guy thread animscripts\utility::UpdateAnimPose();
			guy allowedstances( "stand", "crouch", "prone" );
		}

		guy pushplayer( false );
		
		// if he doesn't target a node make his new goal position his current position
		qSetGoalPos = false;

		if ( guy has_color() )
		{
			qSetGoalPos = false;
		}
		else 
		if ( !isdefined( guy.target ) )
		{
			qSetGoalPos = true;
		}
		else
		{
			// change to support script_origins or make mymapents update nodes
			targetedNodes = getNodeArray( guy.target, "targetname" );
			
			if ( targetedNodes.size == 0 )
			{
				qSetGoalPos = true;
			}
		}
		
		if ( qSetGoalPos )
		{
			guy.goalradius = 600;
			guy setGoalPos( guy.origin );
		}
	}

	if ( isdefined( animpos.getout_delete ) && animpos.getout_delete )
	{
		guy delete();
		return;	
	}
}

animontag( guy, tag, animation, notetracks, sthreads, flag )
{
	guy notify( "animontag_thread" );
	guy endon( "animontag_thread" );
	
	if ( !isdefined( flag ) )
		flag = "animontagdone";
	
	if ( isdefined( self.modeldummy ) )
		animatemodel = self.modeldummy;
	else
		animatemodel = self;
	if ( !isdefined( tag ) )
	{
		org = guy.origin;
		angles = guy.angles;
	}
	else
	{
		org = animatemodel gettagOrigin( tag );
		angles = animatemodel gettagAngles( tag );
	}
	
	if ( isdefined( guy.ragdoll_getout_death ) )
		level thread animontag_ragdoll_death( guy, self );
	
	guy animscripted( flag, org, angles, animation );
	
	// todo: make doNotetracks work on ai
	if ( isai( guy ) )
		thread DoNoteTracks( guy, animatemodel, flag );
	
	if ( isdefined( notetracks ) )
	{
		for ( i = 0;i < notetracks.size;i++ )
		{
			guy waittillmatch( flag, notetracks[ i ] );
			guy thread [[ sthreads[ i ] ]]();
		}
	}
	
	guy waittillmatch( flag, "end" );
	guy notify( "anim_on_tag_done" );
	
	guy.ragdoll_getout_death = undefined;
}

animontag_ragdoll_death( guy, vehicle )
{
	// thread draw_line_from_ent_to_ent_until_notify( level.player, guy, 1, 0, 0, guy, "anim_on_tag_done" );
	if ( isdefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield )
		return;
	if ( !isAI( guy ) )
		guy setCanDamage( true );
	
	guy endon( "anim_on_tag_done" );
	
	
	damage = undefined;
	attacker = undefined;
	vehicleallreadydead = vehicle.health <= 0;
	while ( true )
	{
		if(!vehicleallreadydead && !( isdefined( vehicle ) && vehicle.health > 0)  )
			break;
		guy waittill( "damage", damage, attacker );
		if ( !isdefined( damage ) )
			continue;
		if ( damage < 1 )
			continue;
		if ( !isdefined( attacker ) )
			continue;
		if ( ( attacker == level.player ) || ( ( isdefined( guy.ridingvehicle ) ) && ( attacker == guy.ridingvehicle ) ) )
			break;
	}

	if( !isdefined(guy) )
		return;  // guy was deleted between "damage" and the "fastrope_fall" notetrack.
	
	thread arcadeMode_kill( guy.origin, "rifle", 300 );
	
	guy.deathanim = undefined;
	guy.deathFunction = undefined;
	guy.anim_disablePain = true;
	
	if ( isdefined( guy.ragdoll_fall_anim ) )
	{
		// only do fall animation if the guy is high enough to not fall through the ground
		moveDelta = getmovedelta( guy.ragdoll_fall_anim, 0, 1 );
		groundPos = physicstrace( guy.origin + ( 0, 0, 16 ), guy.origin - ( 0, 0, 10000 ) );
		
		distanceFromGround = distance( guy.origin + ( 0, 0, 16 ), groundPos );
		if ( abs( moveDelta[ 2 ] + 16 ) <=  abs( distanceFromGround ) )
		{
			guy thread play_sound_on_entity( "generic_death_falling" );
			guy animscripted( "fastrope_fall", guy.origin, guy.angles, guy.ragdoll_fall_anim );
			guy waittillmatch( "fastrope_fall", "start_ragdoll" );
		}
	}
	if( !isdefined(guy) )
		return;  // guy was deleted between "damage" and the "fastrope_fall" notetrack.
	guy.deathanim = undefined;
	guy.deathFunction = undefined;
	guy.anim_disablePain = true;
	guy doDamage( guy.health + 100, attacker.origin, attacker );
	guy startragdoll();
}

// applies endons to donotetracks
DoNoteTracks( guy, vehicle, flag )
{
	guy endon( "newanim" );
	vehicle endon( "death" );
	guy endon( "death" );
	guy animscripts\shared::DoNoteTracks( flag );
}

animatemoveintoplace( guy, org, angles, movetospotanim )
{
	guy animscripted( "movetospot", org, angles, movetospotanim );
	guy waittillmatch( "movetospot", "end" );
}

guy_vehicle_death( guy )
{
	animpos = anim_pos( self, guy.pos );
	if ( isdefined( animpos.getout ) )
		self endon( "unload" );
	guy endon ("death");
	self endon( "forcedremoval" );// pile on teh hacks.  I need to clean this up  next game and make the vehicles simply sort through the riders and figure it out rather than thread each guy like this.
	self waittill( "death" );
//	waittillframeend;
	if ( isdefined(animpos.unload_ondeath) && isdefined( self ) )
	{
		thread guy_idle( guy, guy.pos, true ); // hack, idle gets canceled out by the death;
	 	wait animpos.unload_ondeath;
 		self.groupedanim_pos = guy.pos;
		self notify ("groupedanimevent","unload");
		return;
	}
	if ( isdefined( guy ) )
	{
		origin = guy.origin;
		guy delete();
		[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", origin );
	}
}

guy_turn_right_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).turn_right );
}

guy_turn_right( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.vehicle_turn_right ) )
		thread setanimrestart_once( animpos.vehicle_turn_right );
	animontag( guy, animpos.sittag, animpos.turn_right );
	thread guy_idle( guy, pos );
}

guy_turn_left( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = anim_pos( self, pos );
	if ( isdefined( animpos.vehicle_turn_left ) )
		self thread setanimrestart_once( animpos.vehicle_turn_left );
	animontag( guy, animpos.sittag, animpos.turn_left );
	thread guy_idle( guy, pos );
}

guy_turn_left_check( guy, pos )
{
	return isdefined( 	anim_pos( self, pos ).turn_left );
}


guy_turn_hardright( guy, pos )
{
	animpos = level.vehicle_aianims[ self.vehicletype ][ pos ];
	if ( isdefined( animpos.idle_hardright ) )
		guy.vehicle_idle_override = animpos.idle_hardright;
}

guy_turn_hardleft( guy, pos )
{
	animpos = level.vehicle_aianims[ self.vehicletype ][ pos ];
	if ( isdefined( animpos.idle_hardleft ) )
		guy.vehicle_idle_override = animpos.idle_hardleft;
}

ai_wait_go()
{
	self endon( "death" );
	self waittill( "loaded" );
	maps\_vehicle::gopath( self );
}

set_pos( guy, maxpos )
{
	pos = undefined;
	script_startingposition = isdefined(guy.script_startingposition);
	
	if ( isdefined( guy.forced_startingposition ) )
	{
		pos = guy.forced_startingposition;
		assertEx( (( pos < maxpos ) && ( pos >= 0 ) ), "script_startingposition on a vehicle rider must be between " + maxpos + " and 0" );
		return pos;
	}
	if ( script_startingposition && !self.usedpositions[ guy.script_startingposition ] )
	{
		pos = guy.script_startingposition;
		assertEx( (( pos < maxpos ) && ( pos >= 0 ) ), "script_startingposition on a vehicle rider must be between " + maxpos + " and 0" );
	}
	else
	{
		if( script_startingposition )
		{
			println("vehicle rider with script_startingposition: "+guy.script_startingposition+" and script_vehicleride: "+self.script_vehicleride+" that's been taken" );
			assertmsg("startingposition conflict, see console");
			
		}
		assert( !script_startingposition );
		// if there isn't one then set it to the lowest unused spot
		for ( j = 0;j < self.usedPositions.size;j++ )
		{
			if ( self.usedPositions[ j ] == true )
				continue;
			pos = j;
			break;
		}
	}
	return pos;
}

guy_man_turret( guy, pos )
{
	animpos = anim_pos( self, pos );
	turret = self.mgturret[ animpos.mgturret ];
	turret setdefaultdroppitch( 0 );
	wait( 0.1 );
	turret endon( "death" );
	guy endon( "death" );
	level thread maps\_mgturret::mg42_setdifficulty( turret, getdifficulty() );
	turret setmode( "auto_ai" );
	turret setturretignoregoals( true );

	while ( 1 )
	{
		if ( !isdefined( guy getturret() ) )
			guy useturret( turret );
		wait 1;
	}
}

guy_unlink_on_death( guy )
{
	guy endon( "jumpedout" );
	guy waittill( "death" );
	if ( isdefined( guy ) )
		guy unlink();
}

blowup_riders()
{
	self array_levelthread( self.riders, ::guy_blowup );
}

guy_blowup( guy )
{
	if( ! isdefined( guy.pos ) )
		return;  // the fast ropes are a rider with no .pos assigned.
	pos = guy.pos;
	anim_pos = anim_pos( self, pos );
	if ( !isdefined( anim_pos.explosion_death ) )
		return;
		
	[[ level.global_kill_func ]]( "MOD_RIFLE_BULLET", "torso_upper", guy.origin );

	guy.deathanim = anim_pos.explosion_death;
// 	guy.allowdeath = true;
	angles = self.angles;
	origin = guy.origin;
	
	// I think there's a better way to to dthis but I'm lazy
	if ( isdefined( anim_pos.explosion_death_offset ) )
	{
		origin += vector_multiply( anglestoforward( angles ), anim_pos.explosion_death_offset[ 0 ] );
		origin += vector_multiply( anglestoright( angles ), anim_pos.explosion_death_offset[ 1 ] );
		origin += vector_multiply( anglestoup( angles ), anim_pos.explosion_death_offset[ 2 ] );
	}
	guy = convert_guy_to_drone( guy );
	detach_models_with_substr( guy, "weapon_" );
	guy notsolid();
	guy.origin = origin;
	guy.angles = angles;
	
	guy animscripted( "deathanim", origin, angles, anim_pos.explosion_death );
	fraction = .3;
	if ( isdefined( anim_pos.explosion_death_ragdollfraction ) )
		fraction = anim_pos.explosion_death_ragdollfraction;
	animlength = getanimlength( anim_pos.explosion_death );
	timer = gettime() + ( animlength * 1000 );
	wait animlength * fraction;
	
	force = (0,0,1);
	org = guy.origin;
	
	if( getdvar("ragdoll_enable") == "0" )
	{
		guy delete();
		return;
	}

	
	while ( ! guy isragdoll() && gettime() < timer )
	{
		org = guy.origin;
		wait .05;
		force = guy.origin-org;
		guy startragdoll();
		
	}
	wait .05;
	force = vectorscale( force,20000 );
	for ( i = 0; i < 3; i++ )
	{
		if ( isdefined( guy ) )
			org = guy.origin;
//		PhysicsJolt( org, 250, 250, force );
		wait( 0.05 );
	}
	if ( !guy isragdoll() )
		guy delete();

}

// maybe I should make a utility out of this?. could be slow
convert_guy_to_drone( guy, bKeepguy )
{
	if ( !isdefined( bKeepguy ) )
		bKeepguy = false;
	model = spawn( "script_model", guy.origin );
	model.angles = guy.angles;
	model setmodel( guy.model );
	size = guy getattachsize();
	for ( i = 0;i < size;i++ )
	{
		model attach( guy getattachmodelname( i ), guy getattachtagname( i ) );
// 		struct.attachedtags[ i ] = guy getattachtagname( i );
	}
	model useanimtree( #animtree );
	if ( isdefined( guy.team ) )
		model.team = guy.team;
	if ( !bKeepguy )
		guy delete();
	model makefakeai();
	return model;
}

vehicle_animate( animation, animtree )
{
	self UseAnimTree( animtree );
	self setAnim( animation );	
}

vehicle_getInstart( pos )
{
	animpos = anim_pos( self, pos );
	return vehicle_getanimstart( animpos.getin, animpos.sittag, pos );
}


//TODO: anim_reach is the new and cool way.
vehicle_getanimstart( animation, tag, pos )
{
	struct = spawnstruct();

	origin = undefined;
	angles = undefined;
	assert( isdefined( animation ) );
	org = self gettagorigin( tag );
	ang = self gettagangles( tag );
	origin = getstartorigin( org, ang, animation );
	angles = getstartangles( org, ang, animation );

	struct.origin = origin;
	struct.angles = angles;
	struct.pos = pos;
	return struct;
}

get_availablepositions()
{
	vehicleanim = level.vehicle_aianims[ self.vehicletype ];
	availablepositions = [];
	nonanimatedpositions = [];
	for ( i = 0;i < self.usedPositions.size;i++ )
		if ( !self.usedPositions[ i ] )
			if ( isdefined( vehicleanim[ i ].getin ) )
				availablepositions[ availablepositions.size ] = vehicle_getInstart( i );
			else
				nonanimatedpositions[ nonanimatedpositions.size ] = i;
		
	struct = spawnstruct();
	struct.availablepositions = availablepositions;
	struct.nonanimatedpositions = nonanimatedpositions;
	return struct;
}

getanimatemodel()
{
	if ( isdefined( self.modeldummy ) )
		return self.modeldummy;
	else
		return self;	
}

animpos_override_standattack( type, pos, animation )
{
	level.vehicle_aianims[ type ][ pos ].vehicle_standattack = animation;
}

detach_models_with_substr( guy, substr )
{
	size = guy getattachsize();
	modelstodetach = [];
	tagsstodetach = [];
	index = 0;
	for ( i = 0;i < size;i++ )
	{
		modelname = guy getattachmodelname( i );
		tagname = guy getattachtagname( i );
		if ( issubstr( modelname, substr ) )
		{
			modelstodetach[ index ] = modelname;
			tagsstodetach[ index ] = tagname;
		}
	}
	for ( i = 0; i < modelstodetach.size; i++ )
		guy detach( modelstodetach[ i ], tagsstodetach[ i ] );
}

should_give_orghealth()
{
	if ( !isai( self ) )
		return false;
	if ( !isdefined( self.orghealth ) )
		return false;
	return !isdefined( self.magic_bullet_shield );
}
