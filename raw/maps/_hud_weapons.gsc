#include maps\_hud_util;

registerWeaponInfo( name, string, type, clip )
{
	level.weaponInfo[name]["type"] = type;
	level.weaponInfo[name]["clip"] = clip;
	level.weaponInfo[name]["string"] = string;
	
	precacheString( string );	
}

isWeaponRegistered( name )
{
	if ( !isDefined( level.weaponInfo[name] ) )
		return false;
	
	return true;
}

getWeaponInfoType( name )
{
	return level.weaponInfo[name]["type"];
}

getWeaponInfoClip( name )
{
	return level.weaponInfo[name]["clip"];
}

getWeaponInfoString( name )
{
	return level.weaponInfo[name]["string"];
}

init()
{
	precacheShader( "hud_bullets_rifle" );
	precacheShader( "hud_bullets_pistol" );
	precacheShader( "hud_bullets_sniper" );
	precacheShader( "hud_bullets_spread" );
	precacheShader( "hud_bullets_support_front" );
	precacheShader( "hud_bullets_support_back" );

	level.bulletAlphas = [];
	level.bulletAlphas[level.bulletAlphas.size] = 1.000;
	level.bulletAlphas[level.bulletAlphas.size] = 0.996;
	level.bulletAlphas[level.bulletAlphas.size] = 0.949;
	level.bulletAlphas[level.bulletAlphas.size] = 0.909;
	level.bulletAlphas[level.bulletAlphas.size] = 0.870;
	level.bulletAlphas[level.bulletAlphas.size] = 0.835;
	level.bulletAlphas[level.bulletAlphas.size] = 0.803;
	level.bulletAlphas[level.bulletAlphas.size] = 0.776;
	level.bulletAlphas[level.bulletAlphas.size] = 0.749;
	level.bulletAlphas[level.bulletAlphas.size] = 0.721;
	level.bulletAlphas[level.bulletAlphas.size] = 0.698;
	level.bulletAlphas[level.bulletAlphas.size] = 0.674;
	level.bulletAlphas[level.bulletAlphas.size] = 0.654;
	level.bulletAlphas[level.bulletAlphas.size] = 0.635;
	level.bulletAlphas[level.bulletAlphas.size] = 0.615;
	level.bulletAlphas[level.bulletAlphas.size] = 0.596;
	level.bulletAlphas[level.bulletAlphas.size] = 0.580;
	level.bulletAlphas[level.bulletAlphas.size] = 0.564;
	level.bulletAlphas[level.bulletAlphas.size] = 0.549;
	level.bulletAlphas[level.bulletAlphas.size] = 0.537;
	level.bulletAlphas[level.bulletAlphas.size] = 0.521;
	level.bulletAlphas[level.bulletAlphas.size] = 0.509;
	level.bulletAlphas[level.bulletAlphas.size] = 0.498;

	level.weaponInfo = [];
	registerWeaponInfo( "ak47",					&"WEAPON_AK47_FULLAUTO",			"rifle",	30 );
	registerWeaponInfo( "ak47_semi",			&"WEAPON_AK47_SEMIAUTO",			"rifle",	30 );
	registerWeaponInfo( "ak47_grenadier",		&"WEAPON_AK47",			"rifle",	30 );
	registerWeaponInfo( "ak74u",				&"WEAPON_AK74U_FULLAUTO",		"rifle",	30 );
	registerWeaponInfo( "ak74u_semi",			&"WEAPON_AK74U_SEMIAUTO",		"rifle",	30 );
	registerWeaponInfo( "beretta",				&"WEAPON_BERETTA",		"pistol",	15 );
	registerWeaponInfo( "g36c",					&"WEAPON_G36C",			"rifle",	30 );
	registerWeaponInfo( "m14_scoped",			&"WEAPON_M14",			"sniper",	10 );
	registerWeaponInfo( "m16_basic",			&"WEAPON_M16A4_FULLAUTO",			"rifle",	30 );
	registerWeaponInfo( "m16_basic_semi",		&"WEAPON_M16A4_SEMIAUTO",			"rifle",	30 );
	registerWeaponInfo( "m16_grenadier",		&"WEAPON_M16",			"rifle",	30 );
	registerWeaponInfo( "m203",					&"WEAPON_M203",			"grenade",	1 );
	registerWeaponInfo( "rpg",					&"WEAPON_RPG",			"grenade",	5 );
	registerWeaponInfo( "saw",					&"WEAPON_SAW",			"support",	100 );
	registerWeaponInfo( "m4_grunt",				&"WEAPON_M4_FULLAUTO",			"rifle",	30 );
	registerWeaponInfo( "m4_grunt_semi",		&"WEAPON_M4_SEMIAUTO",			"rifle",	30 );
	registerWeaponInfo( "m4_grenadier",			&"WEAPON_M4",			"rifle",	30 );
	registerWeaponInfo( "m40a3",				&"WEAPON_M40A3",		"sniper",	10 );
	registerWeaponInfo( "mp5",					&"WEAPON_MP5",			"smg",		30 );
	registerWeaponInfo( "mp5_silencer",			&"WEAPON_MP5SD",		"smg",		30 );
	registerWeaponInfo( "usp",					&"WEAPON_USP",			"pistol",	10 );
	registerWeaponInfo( "at4",					&"WEAPON_AT4",			"rocketlauncher",	1 );
	registerWeaponInfo( "dragunov",				&"WEAPON_DRAGUNOV",		"sniper",	10 );
	registerWeaponInfo( "g3",					&"WEAPON_G3",			"rifle",	30 );
	registerWeaponInfo( "winchester1200",		&"WEAPON_WINCHESTER1200",			"shotgun",	4 );
	registerWeaponInfo( "uzi",					&"WEAPON_UZI",			"smg",	32 );

	level.player initWeaponHUD();
}

initWeaponHUD()
{
	if ( !isDefined( self.hud_bullets ) )
		self.hud_bullets = [];

	if ( !isDefined( self.hud_bullets[0] ) )
	{
		self.hud_bullets[0] = createIcon( undefined, 24, 96 );
		self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
		self.hud_bullets[0].sort = 10;
	}

	if ( !isDefined( self.hud_bullets[1] ) )
	{
		self.hud_bullets[1] = createIcon( undefined, 24, 96 );
		self.hud_bullets[1] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
		self.hud_bullets[1].color = (0.7,0.7,0.7);
		self.hud_bullets[1].sort = 9;
	}

	if ( !isDefined( self.hud_bullets[2] ) )
	{
		self.hud_bullets[2] = createIcon( undefined, 24, 96 );
		self.hud_bullets[2] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
		self.hud_bullets[2].sort = 10;
	}

	if ( !isDefined( self.hud_bullets[3] ) )
	{
		self.hud_bullets[3] = createIcon( undefined, 24, 96 );
		self.hud_bullets[3] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
		self.hud_bullets[3].color = (0.7,0.7,0.7);
		self.hud_bullets[3].sort = 9;
	}

	if ( !isDefined( self.hud_bullets[4] ) )
	{
		self.hud_bullets[4] = createIcon( undefined, 24, 96 );
		self.hud_bullets[4] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
		self.hud_bullets[4].sort = 10;
	}
	/*
	if ( !isDefined( self.hud_totalammo ) )
	{
		self.hud_totalammo = createFontString( "default", 1.5 );
		self.hud_totalammo setParent( self.hud_bullets[0] );
		self.hud_totalammo setPoint( "TOPRIGHT", "BOTTOMRIGHT", 0, 5 );
	}
	
	if ( !isDefined( self.hud_weaponname ) )
	{
		self.hud_weaponname = createFontString( "default", 1.5 );
		self.hud_weaponname setParent( self.hud_totalammo );
		self.hud_weaponname setPoint( "RIGHT", "LEFT", -40, 0 );
	}
	*/
	self thread updateBulletHudThink();
}


updateBulletHudThink()
{
	self endon ( "death" );
	lastAmmoCount = -1;
	lastWeapon = "";
	lastWeaponType = "";

	while ( true )
	{
		weapon = self getCurrentWeapon();
		if ( isWeaponRegistered( weapon ) )
		{
			weaponType = self getWeaponInfoType( weapon );
			ammoCount = self GetWeaponAmmoClip( self GetCurrentWeapon() );
			
			if ( (weapon != lastWeapon) && (weaponType != lastWeaponType ) )
			{
				self setHudWeaponType( weaponType );
				lastWeapon = weapon;
				lastWeaponType = weaponType;
				lastAmmoCount = -1;
			}

			if ( ammoCount != lastAmmoCount )
			{
				self updateHudWeaponAmmo( weapon, ammoCount );
				lastAmmoCount = ammoCount;
			}
			/*			
			self.hud_totalammo setValue( self GetWeaponAmmoStock( self GetCurrentWeapon() ) );
			if ( self getFractionMaxAmmo( weapon ) < 0.25 )
				self.hud_totalammo.color = (1,0,0);
			else
				self.hud_totalammo.color = (1,1,1);
				
			self.hud_weaponname setText( getWeaponInfoString( weapon ) );
			*/
		}

		wait ( 0.05 );
	}

}

setHudWeaponType( type )
{
	self.pers["weaponType"] = type;
	
	if ( !isDefined( self.hud_bullets ) )
		return;

	for ( index = 0; index < self.hud_bullets.size; index++ )
		self.hud_bullets[index].alpha = 0;
	
	switch( type )
	{
		case "pistol":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
			self.hud_bullets[0] setIconShader( "hud_bullets_pistol" );
			self.hud_bullets[0].alpha = 1;
		break;
		case "smg":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
			self.hud_bullets[0] setIconShader( "hud_bullets_rifle" );
			self.hud_bullets[1] setIconShader( "hud_bullets_rifle" );
			self.hud_bullets[1] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -4, -50 );
			self.hud_bullets[0].alpha = 1;
			self.hud_bullets[1].alpha = 1;
		break;
		case "rifle":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
			self.hud_bullets[0] setIconShader( "hud_bullets_rifle" );
			self.hud_bullets[1] setIconShader( "hud_bullets_rifle" );
			self.hud_bullets[1] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -4, -50 );
			self.hud_bullets[0].alpha = 1;
			self.hud_bullets[1].alpha = 1;
		break;
		case "sniper":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
			self.hud_bullets[0] setIconShader( "hud_bullets_sniper" );
			self.hud_bullets[0].alpha = 1;
		break;
		case "spread":
			self.hud_bullets[0] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6, -47 );
			self.hud_bullets[0] setIconShader( "hud_bullets_spread" );
			self.hud_bullets[0].alpha = 1;
		break;
		case "support":
			xOffset = 0;
			for ( index = 0; index < 5; index++ )
			{
				self.hud_bullets[index] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", -6 + xOffset, -70 );
				self.hud_bullets[index].alpha = 1;
				
				if ( index % 2 )
					self.hud_bullets[index] setIconShader( "hud_bullets_support_back" );
				else
					self.hud_bullets[index] setIconShader( "hud_bullets_support_front" );

				xOffset -= 14;
			}
		break;
	}
}

getHudWeaponType()
{
	return ( self.pers["weaponType"] );
}

updateHudWeaponAmmo( weapon, ammoCount )
{
	if ( !isDefined( self.hud_bullets ) )
		return;	

	switch( self getHudWeaponType() )
	{
		case "pistol":
			baseDiff = 15 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			
			self.hud_bullets[0].alpha = level.bulletAlphas[baseDiff + diff];
		break;
		case "rifle":
			diff = getWeaponInfoClip( weapon ) - ammoCount;

			col1Diff = int( diff / 2 );
			col1Diff += (diff %2);
			col2Diff = int( diff / 2 );

			self.hud_bullets[0].alpha = level.bulletAlphas[col1Diff];
			self.hud_bullets[1].alpha = level.bulletAlphas[col2Diff];
		break;
		case "smg":
			diff = getWeaponInfoClip( weapon ) - ammoCount;

			col1Diff = int( diff / 2 );
			col1Diff += (diff %2);
			col2Diff = int( diff / 2 );

			self.hud_bullets[0].alpha = level.bulletAlphas[col1Diff];
			self.hud_bullets[1].alpha = level.bulletAlphas[col2Diff];
		break;
		case "sniper":
			baseDiff = 15 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			
			self.hud_bullets[0].alpha = level.bulletAlphas[baseDiff + diff];			
		break;
		case "spread":
			baseDiff = 15 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			
			self.hud_bullets[0].alpha = level.bulletAlphas[baseDiff + diff];
		break;
		case "support":
			baseDiff = 100 - getWeaponInfoClip( weapon );
			diff = getWeaponInfoClip( weapon ) - ammoCount;
			diff = baseDiff + diff;
			
			bulletOffset = 20;
			for ( index = 4; index >= 0; index-- )
			{
				if ( diff > bulletOffset )
					self.hud_bullets[index].alpha = 0;
				else if ( (bulletOffset - diff) <= 20 )
					self.hud_bullets[index].alpha = level.bulletAlphas[diff - (bulletOffset - 20)];
				else
					self.hud_bullets[index].alpha = 1;
				
				bulletOffset += 20;
			}
		break;
	}
}
