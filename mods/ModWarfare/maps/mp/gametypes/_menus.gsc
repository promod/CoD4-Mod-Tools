init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_class_allies"] = "class_marines";
	game["menu_changeclass_allies"] = "changeclass_marines_mw";
	game["menu_class_axis"] = "class_opfor";
	game["menu_changeclass_axis"] = "changeclass_opfor_mw";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "changeclass_mw";
	game["menu_changeclass_offline"] = "changeclass_offline";

	game["menu_callvote"] = "callvote";
	game["menu_muteplayer"] = "muteplayer";
	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_muteplayer"]);
	
	// game summary popups
	game["menu_eog_unlock"] = "popup_unlock";
	game["menu_eog_summary"] = "popup_summary";
	game["menu_eog_unlock_page1"] = "popup_unlock_page1";
	game["menu_eog_unlock_page2"] = "popup_unlock_page2";
	
	precacheMenu(game["menu_eog_unlock"]);
	precacheMenu(game["menu_eog_summary"]);
	precacheMenu(game["menu_eog_unlock_page1"]);
	precacheMenu(game["menu_eog_unlock_page2"]);

	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_class_allies"]);
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_class"]);
	precacheMenu(game["menu_changeclass"]);
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
		player.classType = undefined;
		player.selectedClass = false;
		
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		println( self getEntityNumber() + " menuresponse: " + menu + " " + response );
			
		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();
			if ( menu == "changeclass" && self.pers["team"] == "allies" )
			{
				self openMenu( game["menu_changeclass_allies"] );
			}
			else if ( menu == "changeclass" && self.pers["team"] == "axis" )
			{
				self openMenu( game["menu_changeclass_axis"] );			
			}
			continue;
		}
		
		if( getSubStr( response, 0, 7 ) == "loadout" )
		{
			self maps\mp\gametypes\_modwarfare::processLoadoutResponse( response );
			continue;
		}
		
		if( response == "changeteam" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
	
		if( response == "changeclass_marines" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if( response == "changeclass_opfor" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_axis"] );
			continue;
		}
				
		if( response == "endgame" )
		{
			continue;
		}

		if( menu == game["menu_team"] )
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
		else if( menu == game["menu_changeclass_allies"] || menu == game["menu_changeclass_axis"] )
		{
			if ( !self maps\mp\gametypes\_modwarfare::verifyClassChoice( self.pers["team"], response ) )
				continue;

			self maps\mp\gametypes\_modwarfare::setClassChoice( response );
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass"] );
			continue;
		}
		else if( menu == game["menu_changeclass"] )
		{
			self closeMenu();
			self closeInGameMenu();

			self.selectedClass = true;
			self maps\mp\gametypes\_modwarfare::menuAcceptClass();
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

	}
}
