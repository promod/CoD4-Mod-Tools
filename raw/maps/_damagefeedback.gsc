init()
{
	precacheShader( "damage_feedback" );
	
	if ( getDvar( "scr_damagefeedback" ) == "" )
		setDvar( "scr_damagefeedback", "0" );

	if ( !getDvarInt( "scr_damagefeedback" ) )
		return;

	level.player.hud_damagefeedback = newHudElem( level.player );
	level.player.hud_damagefeedback.alignX = "center";
	level.player.hud_damagefeedback.alignY = "middle";
	level.player.hud_damagefeedback.horzAlign = "center";
	level.player.hud_damagefeedback.vertAlign = "middle";
	level.player.hud_damagefeedback.alpha = 0;
	level.player.hud_damagefeedback.archived = true;
	level.player.hud_damagefeedback setShader( "damage_feedback", 24, 24 );
}

monitorDamage()
{
	if ( !getDvarInt( "scr_damagefeedback" ) )
		return;

	for ( ;; )
	{
		self waittill( "damage", amount, attacker );
		
		if ( attacker == level.player )
			level.player updateDamageFeedback();
	}
}

updateDamageFeedback()
{
	if ( !isPlayer( self ) )
		return;
	
	self playlocalsound( "SP_hit_alert" );
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime( 1 );
	self.hud_damagefeedback.alpha = 0;
}