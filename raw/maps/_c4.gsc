/*
	Radiant:
		Create as many trigger_use with targetname "generic_use_trigger" as you might need. 8x8x8 units or so.
		Make sure to place them where the player can't get to them, they will be moved to the correct loctaion in script.
		They will be reused so you only have to do as many as you might have C4 objectivs active at the same time.
	
	Script:
		maps\_c4::main(); // Add in you main() function.
		<entity> maps\_c4::c4_location( tag, origin_offset, angles_offset, org );

		org => optional parameter if you want to plant on an origin instead of a tag

		<entity>.multiple_c4 = true;
		Set .multiple_c4 on the entity if more then one C4 in required before the detonator is given to the player.
		This must be set before <entity> maps\_c4::c4_location( ... ); is called.

	Example:
		technical = maps\_vehicle::waittill_vehiclespawn( "technical" );
		technical maps\_c4::c4_location( "tag_origin", (76, 15, 55.5), (11, 0, 1.5) );
		technical waittill( "c4_detonation" );
		technical notify( "death" ); // this does the explosion and model swap for a vehicle. Other entities might need other ways to do the model swap.

	If the target gets destroyed by something elese then the C4:
		<entity> notify( "clear_c4" ); // this will remove the c4 without detonation.

	You can have more then one c4_location on any one entity. Once one is triggered the others will be deleted.

*/
#include maps\_utility;

main()
{
	precacheModel( "weapon_c4" );
	precacheModel( "weapon_c4_obj" );
	precacheItem( "c4" );
	level._effect["c4_explosion"] = loadfx ("explosions/grenadeExp_metal");
}

c4_location( tag, origin_offset, angles_offset, org )
{
	tag_origin = undefined;

	if ( !isdefined( origin_offset ) )
		origin_offset = ( 0, 0, 0 );
	if ( !isdefined( angles_offset ) )
		angles_offset = ( 0, 0, 0 );

	if ( isdefined(tag) )
		tag_origin = self gettagorigin( tag );
	else if ( isdefined(org) )
		tag_origin = org;
	else
		assertmsg( "need to specify either a 'tag' or an 'org' parameter to attach the c4 to" );

	c4_model = spawn( "script_model", tag_origin + origin_offset );
	c4_model setmodel( "weapon_c4_obj" );
	
	if ( isdefined(tag) )
		c4_model linkto( self, tag, origin_offset, angles_offset );
	else
		c4_model.angles = self.angles;

	c4_model.trigger = get_use_trigger();
	c4_model.trigger sethintstring( &"SCRIPT_PLATFORM_HINT_PLANTEXPLOSIVES" );

	if ( isdefined(tag) )
	{
		c4_model.trigger linkto( self, tag, origin_offset, angles_offset );
		c4_model.trigger.islinked = true;		
	}
	else
		c4_model.trigger.origin = c4_model.origin;

	c4_model thread handle_use( self );
	if ( !isdefined( self.multiple_c4 ) )
		c4_model thread handle_delete( self );
	c4_model thread handle_clear_c4( self );
	
	return c4_model;
}

playC4Effects()
{
	self endon("death");
	
	wait .1;
	
	playFXOnTag( getfx( "c4_light_blink" ), self, "tag_fx" );
}

handle_use( c4_target )
{
	c4_target endon( "clear_c4" );

	if ( !isdefined( c4_target.multiple_c4 ) )
		c4_target endon( "c4_planted" );

	if ( !isdefined( c4_target.c4_count ) )
		c4_target.c4_count = 0;

	c4_target.c4_count++;

	self.trigger usetriggerrequirelookat();
	self.trigger waittill( "trigger" );

    level notify ("c4_in_place", self );

	self.trigger unlink();
	self.trigger release_use_trigger();

	self playsound("detpack_plant");
	self setmodel( "weapon_c4" );
	
	self thread playC4Effects();
	
	c4_target.c4_count--;

	if ( !isdefined( c4_target.multiple_c4 ) || !c4_target.c4_count )
		level.player switch_to_detonator();

	self thread handle_detonation( c4_target );

	c4_target notify( "c4_planted", self );
}

handle_delete( c4_target )
{
	c4_target endon( "clear_c4" );
	self.trigger endon( "trigger" );

	c4_target waittill( "c4_planted", c4_model );
	self.trigger unlink();
	self.trigger release_use_trigger();
	self delete();
}

handle_detonation( c4_target )
{
	c4_target endon( "clear_c4" );

	level.player waittill( "detonate" );
	playfx( level._effect["c4_explosion"], self.origin );
	
	soundPlayer = spawn( "script_origin", self.origin );
	
	if( isdefined( level.c4_sound_override ) )
		soundPlayer playsound( "detpack_explo_main", "sound_done" );
		
	self radiusdamage( self.origin, 256, 200, 50);
	earthquake (0.4, 1, self.origin, 1000);
	
	if (isdefined( self ) ) 
		self delete();
	
	level.player thread remove_detonator();

	c4_target notify( "c4_detonation" );
	
	soundPlayer waittill( "sound_done" ); // not working?
	soundPlayer delete();
}

handle_clear_c4( c4_target )
{
	c4_target endon("c4_detonation");

	c4_target waittill( "clear_c4" );

	if ( !isdefined( self ) )
		return;
		
	if ( isdefined( self.trigger.inuse ) && self.trigger.inuse )
		self.trigger release_use_trigger();

	if ( isdefined( self ) )
		self delete();

	level.player thread remove_detonator();
}

remove_detonator()
{
	level endon( "c4_in_place" );

    wait 1;

    if ( "c4" == self getcurrentweapon() && (isdefined(self.old_weapon)) )
    {
		if ( self HasWeapon( self.old_weapon ) )
			self switchtoweapon( self.old_weapon );
		else
	        self switchtoweapon( self GetWeaponsListPrimaries()[0] );
    }

	self.old_weapon = undefined;

    if ( 0 != self getammocount( "c4") )
        return;

    self waittill( "weapon_change" );
    self takeweapon( "c4" );
}

switch_to_detonator()
{
	c4_weapon = undefined;
	self.old_weapon = self getcurrentweapon();

	// if the player doesn't have the C4 weapon give it to him.
	weapons = self GetWeaponsList();
	for ( i=0; i<weapons.size; i++ )
	{
		if ( weapons[i] != "c4" )
			continue;
		c4_weapon = weapons[i];
	}
	if ( !isdefined( c4_weapon ) )
	{
		self giveWeapon("c4");
		self SetWeaponAmmoClip( "c4", 0 );
		self SetActionSlot( 2, "weapon" , "c4" );
	}

	self switchtoweapon( "c4" );
}

get_use_trigger()
{
	ents = getentarray( "generic_use_trigger", "targetname" );
	assertex( isdefined( ents ) && ents.size > 0, "Missing use trigger with targetname: generic_use_trigger." );
	for ( i=0; i<ents.size; i++ )
	{
		if ( isdefined( ents[i].inuse ) && ents[i].inuse )
			continue;
		if ( !isdefined( ents[i].inuse ) )
			ents[i] enablelinkto();
		ents[i].inuse = true;
		ents[i].oldorigin = ents[i].origin;
		return ents[i];
	}
	assertmsg( "all generic use triggers are in use. Place more of them in the map." );
}

release_use_trigger()
{
	
	if (isdefined(self.islinked))
		self unlink();
	self.islinked = undefined;
	self.origin = self.oldorigin;
	self.inuse = false;
}