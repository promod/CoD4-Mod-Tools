#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

/* info:
you can have the zpu target multiple triggers, the trigger that has script_noteworthy = "dismount" will
dismount the AI and he will come after the player. the spanwner's count determines howmany times the AI
will spawn into the zpu if you trigger the zpu again assuming the previous AI is dead or dismounted.

zpu:	script_model
		targetname "zpu"

*/ 

main( model )
{
	// init: get zpu and gunners
	zpus = getentarray( "zpu", "targetname" );
	
	allZpuFlags = [];
	
	for ( i = 0; i < zpus.size; i++ )
	{
		assertEX( isdefined( zpus[ i ].script_flag ), "Each ZPU entity should have a unique script_flag string set on it." );
		allZpuFlags[ i ] = zpus[ i ].script_flag;
	}
	
	for ( j = 0; j < allZpuFlags.size; j++ )
	{
		dupeCheckSize = allZpuFlags.size - 1;
			
		for ( k = j; k < dupeCheckSize; k++ )
		{
			assertEX( allZpuFlags[ j ] != allZpuFlags[ k + 1 ], "Duplicate script_flag on different ZPUs found. Make them unique." );
			waittillframeend;
		}
	}
	
	// load anims		
	load_zpu_anims();
	load_zpugunner_anims();
	
	array_thread( zpus, ::per_zpu_init );
	
	level.zpu_fx = loadfx( "muzzleflashes/zpu_flash_wv" );
}

per_zpu_init()
{
	self endon( "death" );
	
	zpu_targets = getentarray( self.target, "targetname" );
	zpu_triggers = [];
	
	// Player cancels further respawns by hitting a trigger placed by the designer such that the player won't see the guy spawn.
	// The trigger sets the cancellation flag unique to that ZPU.

	assertEX( isdefined( self.script_flag ), "Each ZPU entity should have a unique script_flag string set on it." );
	flag_init( self.script_flag );

	zpu_gunner_spawner = undefined;
	zpu_dismount_trig = undefined;
	for ( j = 0; j < zpu_targets.size; j++ )
	{
		zpu_target = zpu_targets[ j ];
		if ( issubstr( zpu_target.classname, "actor" ) )
		{
			zpu_gunner_spawner = zpu_target;
		}
		else 
		if ( isdefined( zpu_target.script_noteworthy ) && zpu_target.script_noteworthy == "dismount" )
		{
			zpu_dismount_trig = zpu_target;
		}
		else 
		if ( isdefined( zpu_target.script_noteworthy ) && zpu_target.script_noteworthy == "kill_zpu_spawner" )
		{
			zpu_cancel_trig = zpu_target;	
			zpu_cancel_trig thread zpu_cancel( self.script_flag );
		}
		else
		{
			zpu_triggers[ zpu_triggers.size ] = zpu_target;
		}
	}
	
	waittill_trigger_array( zpu_triggers );
	
	while ( 1 )
	{
		if ( zpu_gunner_spawner.count > 0 )
		{
			zpu_gunner = zpu_gunner_spawner spawn_gunner();
			zpu_gunner linkto( self, "tag_driver", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		
			// call animation
			zpu_gunner thread zpugunner_animation_think( self );
			zpu_gunner thread monitor_gunner( self );
			zpu_gunner thread gunner_death_think( self );
			
			// either dismount of AI or death of AI will restart this loop
			if ( isdefined( zpu_dismount_trig ) )
			{
				waittill_death_or_dismount( zpu_dismount_trig, zpu_gunner, self );
			
				
				// Simulate theoretical time for reinforcements to reoccupy the ZPU and start firing it again
				// Keeping the ZPU active and firing by an AI as long as the player has not hit the 'too close' trigger
				
				zpu_recycle( self.script_flag );
				
				if ( flag( self.script_flag ) )
					break;
				else
					zpu_gunner_spawner.count = 1;
			}
		}
		else
			break;
	}
}

zpu_cancel( flag )
{
	self waittill( "trigger" );
	flag_set( flag );
	level notify( flag );
}

zpu_recycle( flag )
{
	level endon( flag );
	wait 20;	// recycle time before respawning unless stopped by player hitting the cancel trigger
}

waittill_death_or_dismount( trig, gunner, zpu )
{
	gunner endon( "death" );
	gunner endon( "damage" );
	
	trig add_wait( ::waittill_msg, "trigger" );
	gunner add_wait( ::waittill_msg, "doFlashBanged" );
	gunner add_endon( "death" );
	do_wait_any();
	zpu waittillmatch( "looping anim", "end" );
	zpu notify( "stop_looping" );
	gunner thread zpugunner_dismount( zpu );
}

monitor_gunner( zpu )
{
	self waittill( "death" );
	zpu setanim( level.scr_anim[ zpu.animName ][ "fire_loop" ][ 0 ], 1, 1, 0 );
	zpu setanim( level.scr_anim[ zpu.animName ][ "fire_loop" ][ 1 ], 1, 1, 0 );
}

gunner_death_think( zpu )
{
	self.health = 5000;
	self endon( "dismount" );
	self waittill( "damage" );
	if ( !isdefined( self ) )
		return;
	self notify( "dying_damage" );		
	self.a.nodeath = true;
	self.deathAnim = level.scr_anim[ "zpu_gunner" ][ "deathslouch" ];
	zpu thread anim_single_solo( self, "deathslouch", "tag_driver" );
	wait( 0.5 );
	self die();
}

spawn_gunner()
{
	spawn = self maps\_utility::spawn_ai();
	if ( spawn_failed( spawn ) )
	{
		assertex( 0, "spawn failed from zpu" );
		return;			
	}
	spawn endon( "death" );
	spawn.allowDeath = true;
	
	return spawn;
}

// if any trigger is activated in a trigger array
waittill_trigger_array( triggers )
{
	for ( k = 1; k < triggers.size; k++ )
		triggers[ k ] endon( "trigger" );
	triggers[ 0 ] waittill( "trigger" );
}

#using_animtree( "zpu" );
load_zpu_anims()
{
	level.scr_animtree[ "zpu_gun" ] = #animtree;
	level.scr_anim[ "zpu_gun" ][ "fire_loop" ][ 0 ] = %zpu_gun_fire_a;
	level.scr_anim[ "zpu_gun" ][ "fire_loop" ][ 1 ] = %zpu_gun_fire_b;
	
	addNotetrack_sound( "zpu_gun", "fire_1", "fire_loop", "zpu_fire1" );
	addNotetrack_sound( "zpu_gun", "fire_2", "fire_loop", "zpu_fire2" );
	
	addNotetrack_customFunction( "zpu_gun", "fire_1", ::zpu_shoot1 );
	addNotetrack_customFunction( "zpu_gun", "fire_2", ::zpu_shoot2 );
}

#using_animtree( "generic_human" );
load_zpugunner_anims()
{
	level.scr_anim[ "zpu_gunner" ][ "deathslouch" ] = %zpu_gunner_deathslouch;
	level.scr_anim[ "zpu_gunner" ][ "deathslouchidle" ] = %zpu_gunner_deathslouchidle;
	level.scr_anim[ "zpu_gunner" ][ "dismount" ] = %zpu_gunner_dismount;
	level.scr_anim[ "zpu_gunner" ][ "fire_loop" ][ 0 ] = %zpu_gunner_fire_a;
	level.scr_anim[ "zpu_gunner" ][ "fire_loop" ][ 1 ] = %zpu_gunner_fire_b;
}

zpu_shoot1( gun )
{
	playfxontag( level.zpu_fx, gun, "tag_flash" );
	playfxontag( level.zpu_fx, gun, "tag_flash2" );
}

zpu_shoot2( gun )
{
	playfxontag( level.zpu_fx, gun, "tag_flash1" );
	playfxontag( level.zpu_fx, gun, "tag_flash3" );
}

zpugunner_animation_think( zpu )
{
	// initially shooting
	self endon( "death" );// idle when dead
	self endon( "dismount gunner" );// gunner left
	zpu endon( "dismount gunner" );// gunner left
	zpu endon( "new gunner" );// new gunner
	
	self.animName = "zpu_gunner";
	zpu.animName = "zpu_gun";
	zpu assign_animtree();

	loopPacket = [];
	loopPacket[ loopPacket.size ] = self anim_at_entity( zpu, "tag_driver" );
	loopPacket[ loopPacket.size ] = zpu anim_at_self();
	zpu thread anim_loop_packet( loopPacket, "fire_loop", "stop_looping" );
}

zpugunner_dismount( zpu )
{
	self endon( "death" );
	self endon( "dying_damage" );
	
	self.animName = "zpu_gunner";
	zpu.animName = "zpu_gun";
	
	zpu assign_animtree();

	self thread anim_single_solo( self, "dismount", "tag_driver", undefined, zpu );
	wait( 0.8 );
	self.health = 100;
	self notify( "dismount" );
	self.deathAnim = undefined;
	self unlink();
}
