init()
{
	precacheShader("damage_feedback");
	precacheShader("damage_feedback_j");

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.hud_damagefeedback = newClientHudElem(player);
		player.hud_damagefeedback.horzAlign = "center";
		player.hud_damagefeedback.vertAlign = "middle";
		player.hud_damagefeedback.x = -12;
		player.hud_damagefeedback.y = -12;
		player.hud_damagefeedback.alpha = 0;
		player.hud_damagefeedback.archived = true;
		player.hud_damagefeedback setShader("damage_feedback", 24, 48);
	}
}

updateDamageFeedback( hitBodyArmor )
{
	if ( !isPlayer( self ) )
		return;
	
	if ( hitBodyArmor )
	{
		self.hud_damagefeedback setShader("damage_feedback_j", 24, 48);
		self playlocalsound("MP_hit_alert"); // TODO: change sound?
	}
	else
	{
		self.hud_damagefeedback setShader("damage_feedback", 24, 48);
		self playlocalsound("MP_hit_alert");
	}
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}