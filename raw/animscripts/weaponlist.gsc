// Weapon configuration for anim scripts.
// Supplies information for all AI weapons.
#using_animtree ("generic_human");


usingAutomaticWeapon()
{
	if ( weaponIsSemiAuto( self.weapon ) )
		return false;
		
	if ( weaponIsBoltAction( self.weapon ) )
		return false;
		
	class = weaponClass( self.weapon );
	if ( class == "rifle" || class == "mg" || class == "smg" )
		return true;

	return false;
}

usingSemiAutoWeapon()
{
	return ( weaponIsSemiAuto( self.weapon ) );
}

usingShotgunWeapon()
{
	return ( weaponClass( self.weapon ) == "spread" );
}

autoShootAnimRate()
{
	if ( usingAutomaticWeapon() )
	{
		// The auto fire animation fires 10 shots a second, so we divide the weapon's fire rate by 
		// 10 to get the correct anim playback rate.
//		return weaponFireTime( self.weapon ) * 10;
		return 0.1 / weaponFireTime( self.weapon ) * getdvarfloat("scr_ai_auto_fire_rate");
	}
	else
	{
//		println ("weaponList::standAimShootAnims: No auto fire rate for "+self.weapon);
		return 0.2;	// Equates to 2 shots a second, decent for a non-auto weapon.
	}
}

burstShootAnimRate()
{
	if (usingAutomaticWeapon())
	{
		// The auto fire animation fires 10 shots a second, so we divide the weapon's fire rate by 
		// 10 to get the correct anim playback rate.
		return 0.16 / weaponFireTime( self.weapon );
	}
	else
	{
//		println ("weaponList::standAimShootAnims: No auto fire rate for "+self.weapon);
		return 0.2;	// Equates to 2 shots a second, decent for a non-auto weapon.
	}
}

waitAfterShot()
{
	return 0.25;
}

shootAnimTime(semiAutoFire)
{
	if( !usingAutomaticWeapon() || (isdefined(semiAutofire) && (semiAutofire == true)))
	{
		// We randomize the result a little from the real time, just to make things more 
		// interesting.  In reality, the 20Hz server is going to make this much less variable.
		rand = 0.5 + randomfloat(1); // 0.8 + 0.4
		return weaponFireTime( self.weapon ) * rand;
	}
	else
	{
		return weaponFireTime( self.weapon );
	}

}

RefillClip()
{
	assertEX( isDefined( self.weapon ), "self.weapon is not defined for " + self.model );
	
	if ( self.weapon == "none" )
	{
		self.bulletsInClip = 0;
		return false;
	}
	
	if ( weaponClass( self.weapon ) == "rocketlauncher" )
	{
		if ( !self.a.rocketVisible )
			self thread animscripts\combat_utility::showRocketWhenReloadIsDone();
		/*
		// TODO: proper rocket ammo tracking
		if ( self.a.rockets < 1 )
			self animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
		*/
	}

	if ( !isDefined( self.bulletsInClip ) )
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
	}
	/*
	else if ( isDefined( self.ammoCounts[self.weapon] ) )
	{
		self.ammoCounts[self.weapon] -= weaponClipSize( self.weapon );
		if ( self.ammoCounts[self.weapon] > 0 )
			self.bulletsInClip = weaponClipSize( self.weapon ) + self.ammoCounts[self.weapon];
	}
	*/
	else
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
	}

	assertEX(isDefined(self.bulletsInClip), "RefillClip failed");
	
	if ( self.bulletsInClip <= 0 )
		return false;
	else
		return true;
}

precacheClipFx()
{
	clipEffects = [];
	
	clipEffects["weapon_m16_clip"]		= "shellejects/clip_m16";
	clipEffects["weapon_ak47_clip"]		= "shellejects/clip_ak47";
	clipEffects["weapon_saw_clip"]		= "shellejects/clip_saw";
	clipEffects["weapon_mp5_clip"]		= "shellejects/clip_mp5";
	clipEffects["weapon_dragunov_clip"]	= "shellejects/clip_dragunov";
	clipEffects["weapon_g3_clip"]		= "shellejects/clip_g3";
	clipEffects["weapon_g36_clip"]		= "shellejects/clip_g36";
	clipEffects["weapon_m14_clip"]		= "shellejects/clip_m14";
	clipEffects["weapon_ak74u_clip"]	= "shellejects/clip_ak74u";
	
	/#
	if ( getdvar( "scr_generateClipModels" ) != "" && getdvar( "scr_generateClipModels" ) != "0" )
	{
		// get array of weapons we'll need from spawners and AI (TODO)
		spawnedAITypes = [];
		level.weapons_list = [];

		spawners = getSpawnerArray();
		for ( i = 0; i < spawners.size; i++ )
		{
			spawner = spawners[i];
			if ( isDefined( spawnedAITypes[ spawner.classname ] ) )
				continue;
			spawnedAITypes[ spawner.classname ] = true;
			
			oldCount = spawner.count;
			spawner.count = 1;
			fakeai = spawner stalingradSpawn();
			if ( !isDefined( fakeai ) )
			{
				spawner.count = oldCount;
				continue;
			}
			
			if ( isdefined( fakeai.primaryWeapon ) )
				level.weapons_list[ fakeai.primaryWeapon ] = true;
			if ( isdefined( fakeai.secondaryWeapon ) )
				level.weapons_list[ fakeai.secondaryWeapon ] = true;
			if ( isdefined( fakeai.sidearm ) )
				level.weapons_list[ fakeai.sidearm ] = true;
			
			fakeai delete();
			spawner.count = oldCount;
		}
		
		ai = getAiArray();
		for ( i = 0; i < ai.size; i++ )
		{
			if ( isdefined( ai[i].primaryWeapon ) )
				level.weapons_list[ ai[i].primaryWeapon ] = true;

			if ( isdefined( ai[i].secondaryWeapon ) )
				level.weapons_list[ ai[i].secondaryWeapon ] = true;

			if ( isdefined( ai[i].sidearm ) )
				level.weapons_list[ ai[i].sidearm ] = true;
		}

		weapons = getarraykeys( level.weapons_list );
		println( "The following is a list of weapons in the level: " );
		for ( i = 0; i < weapons.size; i++ )
		{
			println( weapons[ i ] );
		}		

		println( "\n\n^1Put the following array definition before your call to maps\_load::main():" );
		println( "\n\n^1level.weaponClipModels = [];" );
		
		printIndex = 0;
		printedModel = [];
		for ( i = 0; i < weapons.size; i++ )
		{
			weapon = weapons[i];
			model = getWeaponClipModel( weapon );
			
			if ( model == "" )
				continue;
			if ( isDefined( printedModel[ model ] ) )
				continue;
			printedModel[ model ] = true;
			
			println( "^1level.weaponClipModels[" + printIndex + "] = \"" + model + "\";" );
			printIndex++;
		}

		println( "\n\n^1Put the following in your fastfile:\n" );
		
		printIndex = 0;
		printedModel = [];
		for ( i = 0; i < weapons.size; i++ )
		{
			weapon = weapons[i];
			model = getWeaponClipModel( weapon );
			
			if ( model == "" )
				continue;
			if ( isDefined( printedModel[ model ] ) )
				continue;
			printedModel[ model ] = true;
			
			println( "^1fx," + clipEffects[ model ] );
			printIndex++;
		}
		
		println( "\n\n" );
		
		missionFailed();
		return;
	}
	setdvar( "scr_generateClipModels", 0 );
	#/
	if ( !isDefined( anim._effect ) )
		anim._effect = [];
	if ( isDefined( level.weaponClipModels ) )
	{
		for ( i = 0; i < level.weaponClipModels.size; i++ )
		{
			model = level.weaponClipModels[i];
			
			assert( isDefined( model ) );
			assert( isDefined( clipEffects[ model ] ) );
			
			precacheModel( model );
			anim._effect[ model ] = loadfx( clipEffects[ model ] );
		}
		
		level.weaponClipModels = undefined;
		level.weaponClipModelsLoaded = true;
	}
	else
	{
		/#
		#/
	}
}
/#
bugLDAboutClipModels()
{
	waittillframeend; // wait for _loadout to run
	if ( isdefined( level.testmap ) )
		return;
		
	waittime = 1;
	while(1)
	{
		println("^1No weaponClipModels in this map!");
		println("^1Set dvar scr_generateClipModels to 1 and map_restart, then follow instructions in console.");
		waittime += 1;
		wait waittime;
	}
}
#/

add_weapon(name, type, time, clipsize, anims)
{
	assert (isdefined(name));
	assert (isdefined(type));
	if (!isdefined(time))
		time = 3.0;
	if (!isdefined(clipsize))
		time = 1;
	if (!isdefined(anims))
		anims = "rifle";

	name = tolower(name);
	anim.AIWeapon[name]["type"] =	type;
	anim.AIWeapon[name]["time"] 	=	time;
	anim.AIWeapon[name]["clipsize"] =	clipsize;
	anim.AIWeapon[name]["anims"] 	=	anims;
}

addTurret(turret)
{
	anim.AIWeapon[tolower(turret)]["type"] = "turret";
}
