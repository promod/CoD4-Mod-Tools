init()
{
	// Draws a team icon over teammates
	if(getdvar("scr_drawfriend") == "")
		setdvar("scr_drawfriend", "0");
	level.drawfriend = getdvarInt("scr_drawfriend");

	switch( game["allies"] )
	{
		case "marines":
			game["headicon_allies"] = "headicon_american";
			break;
		case "sas":
			game["headicon_allies"] = "headicon_british";
			break;
		default:
			game["headicon_allies"] = "headicon_american";
			break;
	}
	switch( game["axis"] )
	{
		case "russian":
			game["headicon_axis"] = "faction_128_ussr";
			break;
		case "arab":
		case "opfor":
			game["headicon_axis"] = "faction_128_arab";
			break;
		default:
			game["headicon_axis"] = "faction_128_arab";
			break;
	}
	precacheHeadIcon( game["headicon_allies"] );
	precacheHeadIcon( game["headicon_axis"] );

	level thread onPlayerConnect();
	
	for(;;)
	{
		updateFriendIconSettings();
		wait 5;
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self thread showFriendIcon();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");
		self.headicon = "";
	}
}	

showFriendIcon()
{
	if(level.drawfriend)
	{
		if(self.pers["team"] == "allies")
		{
			self.headicon = game["headicon_allies"];
			self.headiconteam = "allies";
		}
		else
		{
			self.headicon = game["headicon_axis"];
			self.headiconteam = "axis";
		}
	}
}
	
updateFriendIconSettings()
{
	drawfriend = getdvarFloat("scr_drawfriend");
	if(level.drawfriend != drawfriend)
	{
		level.drawfriend = drawfriend;

		updateFriendIcons();
	}
}

updateFriendIcons()
{
	// for all living players, show the appropriate headicon
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			if(level.drawfriend)
			{
				if(player.pers["team"] == "allies")
				{
					player.headicon = game["headicon_allies"];
					player.headiconteam = "allies";
				}
				else
				{
					player.headicon = game["headicon_axis"];
					player.headiconteam = "axis";
				}
			}
			else
			{
				players = level.players;
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
	
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
						player.headicon = "";
				}
			}
		}
	}
}
