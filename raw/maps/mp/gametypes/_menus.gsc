init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_class_allies"] = "class_marines";
	game["menu_changeclass_allies"] = "changeclass_marines";
	game["menu_initteam_allies"] = "initteam_marines";
	game["menu_class_axis"] = "class_opfor";
	game["menu_changeclass_axis"] = "changeclass_opfor";
	game["menu_initteam_axis"] = "initteam_opfor";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "changeclass";
	game["menu_changeclass_offline"] = "changeclass_offline";

	if ( !level.console )
	{
		game["menu_callvote"] = "callvote";
		game["menu_muteplayer"] = "muteplayer";
		precacheMenu(game["menu_callvote"]);
		precacheMenu(game["menu_muteplayer"]);
		
		// ---- back up one folder to access game_summary.menu ----
		// game summary menu file precache
		game["menu_eog_main"] = "endofgame";
		
		// menu names (do not precache since they are in game_summary_ingame which should be precached
		game["menu_eog_unlock"] = "popup_unlock";
		game["menu_eog_summary"] = "popup_summary";
		game["menu_eog_unlock_page1"] = "popup_unlock_page1";
		game["menu_eog_unlock_page2"] = "popup_unlock_page2";
		
		precacheMenu(game["menu_eog_main"]);
		precacheMenu(game["menu_eog_unlock"]);
		precacheMenu(game["menu_eog_summary"]);
		precacheMenu(game["menu_eog_unlock_page1"]);
		precacheMenu(game["menu_eog_unlock_page2"]);
	
	}
	else
	{
		game["menu_controls"] = "ingame_controls";
		game["menu_options"] = "ingame_options";
		game["menu_leavegame"] = "popup_leavegame";

		if(level.splitscreen)
		{
			game["menu_team"] += "_splitscreen";
			game["menu_class_allies"] += "_splitscreen";
			game["menu_changeclass_allies"] += "_splitscreen";
			game["menu_class_axis"] += "_splitscreen";
			game["menu_changeclass_axis"] += "_splitscreen";
			game["menu_class"] += "_splitscreen";
			game["menu_changeclass"] += "_splitscreen";
			game["menu_controls"] += "_splitscreen";
			game["menu_options"] += "_splitscreen";
			game["menu_leavegame"] += "_splitscreen";
		}

		precacheMenu(game["menu_controls"]);
		precacheMenu(game["menu_options"]);
		precacheMenu(game["menu_leavegame"]);
	}

	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_class_allies"]);
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_initteam_allies"]);
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_class"]);
	precacheMenu(game["menu_changeclass"]);
	precacheMenu(game["menu_initteam_axis"]);
	precacheMenu(game["menu_changeclass_offline"]);
	precacheString( &"MP_HOST_ENDED_GAME" );
	precacheString( &"MP_HOST_ENDGAME_RESPONSE" );

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player setClientDvar("ui_3dwaypointtext", "1");
		player.enable3DWaypoints = true;
		player setClientDvar("ui_deathicontext", "1");
		player.enableDeathIcons = true;
		
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		//println( self getEntityNumber() + " menuresponse: " + menu + " " + response );
		
		//iprintln("^6", response);
		/*if(response == "open_changeclass_menu" )
		{
			if( getDvarInt( "onlinegame" ) )
				self openMenu( "changeclass" );
			else
				self openMenu( "changeclass_offline" );
		}
		*/
			
		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();

			if ( level.console )
			{
				if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"] )
				{
//					assert(self.pers["team"] == "allies" || self.pers["team"] == "axis");
	
					if( self.pers["team"] == "allies" )
						self openMenu( game["menu_class_allies"] );
					if( self.pers["team"] == "axis" )
						self openMenu( game["menu_class_axis"] );
				}
			}
			continue;
		}
		
		if(response == "changeteam")
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
	
		if(response == "changeclass_marines" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if(response == "changeclass_opfor" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_axis"] );
			continue;
		}

		if(response == "changeclass_marines_splitscreen" )
			self openMenu( "changeclass_marines_splitscreen" );

		if(response == "changeclass_opfor_splitscreen" )
			self openMenu( "changeclass_opfor_splitscreen" );
					
		// rank update text options
		if(response == "xpTextToggle")
		{
			self.enableText = !self.enableText;
			if (self.enableText)
				self setClientDvar( "ui_xpText", "1" );
			else
				self setClientDvar( "ui_xpText", "0" );
			continue;
		}

		// 3D Waypoint options
		if(response == "waypointToggle")
		{
			self.enable3DWaypoints = !self.enable3DWaypoints;
			if (self.enable3DWaypoints)
				self setClientDvar( "ui_3dwaypointtext", "1" );
			else
				self setClientDvar( "ui_3dwaypointtext", "0" );
//			self maps\mp\gametypes\_objpoints::updatePlayerObjpoints();
			continue;
		}

		// 3D death icon options
		if(response == "deathIconToggle")
		{
			self.enableDeathIcons = !self.enableDeathIcons;
			if (self.enableDeathIcons)
				self setClientDvar( "ui_deathicontext", "1" );
			else
				self setClientDvar( "ui_deathicontext", "0" );
			self maps\mp\gametypes\_deathicons::updateDeathIconsEnabled();
			continue;
		}
		
		if(response == "endgame")
		{
			// TODO: replace with onSomethingEvent call 
			if(level.splitscreen)
			{
				if ( level.console )
					endparty();
				level.skipVote = true;

				if ( !level.gameEnded )
				{
					level thread maps\mp\gametypes\_globallogic::forceEnd();
				}
			}
				
			continue;
		}

		if ( response == "endround" && level.console )
		{
			if ( !level.gameEnded )
			{
				level thread maps\mp\gametypes\_globallogic::forceEnd();
			}
			else
			{
				self closeMenu();
				self closeInGameMenu();
				self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
			}			
			continue;
		}

		if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.allies]]();
				break;

			case "axis":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.axis]]();
				break;

			case "autoassign":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.autoassign]]();
				break;

			case "spectator":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.spectator]]();
				break;
			}
		}	// the only responses remain are change class events
		else if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] )
		{
			self closeMenu();
			self closeInGameMenu();

			self.selectedClass = true;
			self [[level.class]](response);
		}
		else if ( !level.console )
		{
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
		}
		
		// ======== catching response for create-a-class events ========
		/*
		responseTok = strTok( response, "," );
		
		if( isdefined( responseTok ) && responseTok.size > 1 )
		{
			if( responseTok[0] == "primary" )
			{	
				// primary weapon selection
				assertex( responseTok.size != 2, "Primary weapon selection in create-a-class-ingame is sending bad response:" + response );
				
				stat_offset = cacMenuStatOffset( menu, response );
				self setstat( stat_offset+201, ( int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) - 3000 ) );
			}
			else if( responseTok[0] == "attachment" )
			{	
				// primary or secondary weapon attachment selection
				assertex( responseTok.size != 3, "Weapon attachment selection in create-a-class-ingame is sending bad response:" + response );
				
				stat_offset = cacMenuStatOffset( menu, response );
				if( responseTok[1] == "primary" )
					self setstat( stat_offset+202, int( tableLookup( "mp/attachmentTable.csv", 4, responseTok[2], 9 ) ) );
				else if( responseTok[1] == "secondary" )
					self setstat( stat_offset+204, int( tableLookup( "mp/attachmentTable.csv", 4, responseTok[2], 9 ) ) );
			}
			else if( responseTok[0] == "secondary" )
			{
				// secondary weapon selection
				assertex( responseTok.size != 2, "Secondary weapon selection in create-a-class-ingame is sending bad response:" + response );
				
				stat_offset = cacMenuStatOffset( menu, response );
				self setstat( stat_offset+203, ( int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) - 3000 ) );
			}
			else if( responseTok[0] == "perk" )
			{
				// all 3 perks selection
				assertex( responseTok.size != 3, "Perks selection in create-a-class-ingame is sending bad response:" + response );
				
				stat_offset = cacMenuStatOffset( menu, response );
				self setstat( stat_offset+200+int(responseTok[1]), int( tableLookup( "mp/statsTable.csv", 4, responseTok[2], 1 ) ) );
			}
			else if( responseTok[0] == "sgrenade" )
			{
				assertex( responseTok.size != 2, "Special grenade selection in create-a-class-ingame is sending bad response:" + response );
				
				stat_offset = cacMenuStatOffset( menu, response );
				self setstat( stat_offset+208, ( int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) - 3000 ) );
			}
			else if( responseTok[0] == "camo" )
			{
				assertex( responseTok.size != 2, "Primary weapon camo skin selection in create-a-class-ingame is sending bad response:" + response );
				
				stat_offset = cacMenuStatOffset( menu, response );
				self setstat( stat_offset+209, int( tableLookup( "mp/attachmentTable.csv", 4, responseTok[2], 11 ) ) );					
			}
		}
		*/
	}
}

/*
// sort response message from CAC menu
cacMenuStatOffset( menu, response )
{
	stat_offset = -1;
	
	if( menu == "menu_cac_assault" )
		stat_offset = 0;
	else if( menu == "menu_cac_specops" )
		stat_offset = 10;
	else if( menu == "menu_cac_heavygunner" )
		stat_offset = 20;
	else if( menu == "menu_cac_demolitions" )
		stat_offset = 30;
	else if( menu == "menu_cac_sniper" )
		stat_offset = 40;
	
	assertex( stat_offset >= 0, "The response: " + response + " came from non-CAC menu" );	
	
	return stat_offset;
}
*/