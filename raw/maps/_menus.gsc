// Need to seperate layout from functionality more for more flexibility

// Create a thread which processes left and right. This will be passed to addItemSetting so it can be different per itemDef
// 		This should attempt to change the dvar value if in range
//		Should also automatically update the associated hud elem

#include maps\_utility;
#include maps\_hud_util;

init()
{
	precacheMenu( "uiScript_startMultiplayer" );
	
	precacheShader( "black" );
	precacheShader( "white" );

	precacheShader( "menu_button" );
	precacheShader( "menu_button_selected" );
	precacheShader( "menu_button_fade" );
	precacheShader( "menu_button_fade_selected" );
	precacheShader( "menu_button_faderight" );
	precacheShader( "menu_button_faderight_selected" );
	precacheShader( "menu_caret_open" );
	precacheShader( "menu_caret_closed" );
	
	thread initThumbstickLayout();
	thread initButtonLayout();
	thread initSensitivity();
	thread initInversion();
	thread initAutoaim();
	thread initVibration();

	level.menuStack = [];

	levelMenu = createMenu( "levels" );
	action = setupAction(::loadMap, "cqb_1");
	description = spawnStruct();
	description.display = &"MENU_1ST_PASS";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_CQB_TEST", action, "loadmap", description );

	action = setupAction(::loadMap, "descent");
	description = spawnStruct();
	description.display = &"MENU_1ST_PASS";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_BUNKER", action, "loadmap", description );

	action = setupAction(::loadMap, "aftermath");
	description = spawnStruct();
	description.display = &"MENU_100_INITIAL_GEO";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_AFTERMATH", action, "loadmap", description );
	
	action = setupAction(::loadMap, "chechnya_escape");
	description = spawnStruct();
	description.display = &"MENU_40_INITIAL_GEO";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_CHECHNYA_ESCAPE", action, "loadmap", description );

	action = setupAction(::loadMap, "marksman");
	description = spawnStruct();
	description.display = &"MENU_25_SCRIPTED";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_MARKSMAN", action, "loadmap", description );

	action = setupAction(::loadMap, "seaknight_defend");
	description = spawnStruct();
	description.display = &"MENU_PROTOTYPE_LEVEL_30_SCRIPTED";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_SEAKNIGHT_DEFEND", action, "loadmap", description );

	action = setupAction(::loadMap, "wetwork");
	description = spawnStruct();
	description.display = &"MENU_100_INITIAL_GEO";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_WETWORK", action, "loadmap", description );

	action = setupAction(::loadMap, "cargoship");
	description = spawnStruct();
	description.display = &"MENU_10_SCRIPTED";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_CARGOSHIP", action, "loadmap", description );

	action = setupAction(::loadMap, "bog");
	description = spawnStruct();
	description.display = &"MENU_35_INITIAL_GEO";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_BOG", action, "loadmap", description );

	action = setupAction(::loadMap, "training");
	description = spawnStruct();
	description.display = &"MENU_5_SCRIPTED";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_TRAINING1", action, "loadmap", description );

	action = setupAction(::loadMap, "ac130");
	description = spawnStruct();
	description.display = &"MENU_30";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_AC130", action, "loadmap", description );

	action = setupAction(::loadMap, "seaknight_assault");
	description = spawnStruct();
	description.display = &"MENU_INITIAL_GEO_IN_PROGRESS";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_SEAKNIGHT_ASSAULT", action, "loadmap", description );

	action = setupAction(::loadMap, "pilotcobra");
	description = spawnStruct();
	description.display = &"MENU_INITIAL_GEO_IN_PROGRESS";
	description.xPos = 240;
	description.yPos = 100;
	levelMenu addItem( &"MENU_PILOT_COBRA", action, "loadmap", description );

	controlsMenu = createMenu_Controls( "controls" );
	setting = spawnStruct();
	setting.index = 0;
	setting.dvar = "controls_sticksConfig";
	setting.value[0] = "thumbstick_default";
	setting.value[1] = "thumbstick_southpaw";
	setting.value[2] = "thumbstick_legacy";
	setting.value[3] = "thumbstick_legacysouthpaw";
	setting.display[0] = "Default";
	setting.display[1] = "Southpaw";
	setting.display[2] = "Legacy";
	setting.display[3] = "Legacy Southpaw";
	controlsMenu addItemSetting( &"MENU_THUMBSTICK_LAYOUT", undefined, undefined, undefined, setting );

	setting = spawnStruct();
	setting.index = 0;
	setting.dvar = "controls_buttonConfig";
	setting.value[0] = "buttons_default";
	setting.value[1] = "buttons_experimental";
	setting.value[2] = "buttons_lefty";
	setting.value[3] = "buttons_finesthour";
	setting.display[0] = "Default";
	setting.display[1] = "Experimental";
	setting.display[2] = "Lefty";
	setting.display[3] = "Finest Hour";	
	controlsMenu addItemSetting( &"MENU_BUTTON_LAYOUT", undefined, undefined, undefined, setting );
	
	setting = spawnStruct();
	setting.index = 1;
	setting.dvar = "controls_sensitivityConfig";
	setting.value[0] = "sensitivity_low";
	setting.value[1] = "sensitivity_medium";
	setting.value[2] = "sensitivity_high";
	setting.value[3] = "sensitivity_veryhigh";
	setting.display[0] = "Low";
	setting.display[1] = "Medium";
	setting.display[2] = "High";
	setting.display[3] = "Very High";			
	controlsMenu addItemSetting( &"MENU_LOOK_SENSITIVITY", undefined, undefined, undefined, setting );
	
	setting = spawnStruct();
	setting.index = 0;
	setting.dvar = "controls_inversionConfig";
	setting.value[0] = "inversion_disabled";
	setting.value[1] = "inversion_enabled";
	setting.display[0] = "Disabled";
	setting.display[1] = "Enabled";
	controlsMenu addItemSetting( &"MENU_LOOK_INVERSION", undefined, undefined, undefined, setting );

	setting = spawnStruct();
	setting.index = 1;
	setting.dvar = "controls_autoaimConfig";
	setting.value[0] = "autoaim_disabled";
	setting.value[1] = "autoaim_enabled";
	setting.display[0] = "Disabled";
	setting.display[1] = "Enabled";
	controlsMenu addItemSetting( &"MENU_AUTOAIM", undefined, undefined, undefined, setting );

	setting = spawnStruct();
	setting.index = 1;
	setting.dvar = "controls_vibrationConfig";
	setting.value[0] = "vibration_disabled";
	setting.value[1] = "vibration_enabled";
	setting.display[0] = "Disabled";
	setting.display[1] = "Enabled";
	controlsMenu addItemSetting( &"MENU_CONTROLLER_VIBRATION", undefined, undefined, undefined, setting );
	
	//optionsMenu = createMenu();
	//optionsMenu addItem( &"MENU_CONTROLS", ::pushMenu, controlsMenu );
	//optionsMenu addItem( &"MENU_SUBTITLES", ::void );
	//optionsMenu addItem( &"MENU_SAVE_DEVICE", ::void );
	
	mainMenu = createMenu( "main" );
	action = setupAction(::pushMenu, levelMenu);
	mainMenu addItem( &"MENU_SELECT_LEVEL", action, "openmenu_levels" );
	subMenu = mainMenu addSubMenu( "options", &"MENU_OPTIONS" );
		action = setupAction(::pushMenu, controlsMenu);
		subMenu addItem( &"MENU_CONTROLS", action );
		subMenu addItem( &"MENU_SUBTITLES" );
		subMenu addItem( &"MENU_SAVE_DEVICE" );
	mainMenu addItem( &"MENU_CREDITS" );
	
	action = setupAction(::loadMultiplayer);
	mainMenu addItem( &"MENU_MULTIPLAYER", action );

	pushMenu( mainMenu );

	getEnt( "player", "classname" ) thread menuResponse();
}


void()
{
}

loadMap( map )
{
	changelevel( map );
}

loadMultiplayer()
{
	level.player openMenu( "uiScript_startMultiplayer" );
}

pushMenu( menuDef )
{
	level.menuStack[level.menuStack.size] = menuDef;

	oldMenu = level.curMenu;
	level.curMenu = menuDef;

	if ( menuDef.menuType == "fullScreen" )
	{
		if ( isDefined( oldMenu ) )
			oldMenu thread hideMenu( 0.2, true );

		menuDef thread showMenu( 0.2, true );	
		level notify ( "open_menu", level.curMenu.name );
	}
	else
	{
		menuDef thread expandMenu( 0.2 );
	}
	
	level.player playsound("mouse_click");
}


popMenu()
{
	if ( level.menuStack.size == 1 )
		return;

	level.menuStack[level.menuStack.size - 1] = undefined;
	oldMenu = level.curMenu;
	level.curMenu = level.menuStack[level.menuStack.size - 1];
	
	if ( oldMenu.menuType == "subMenu" )
	{
		oldMenu thread collapseMenu( 0.2 );
		level.curMenu updateMenu( 0.2, true );
	}
	else
	{
		oldMenu thread hideMenu( 0.2, false );
		level.curMenu thread showMenu( 0.2, false );
		level notify ( "close_menu", level.menuStack.size );
	}
	
	level.player playsound("mouse_click");
}


createMenu( name )
{
	menuDef = spawnStruct();
	menuDef.name = name;
	menuDef.menuType = "fullScreen";
	menuDef.itemDefs = [];
	menuDef.itemWidth = 120;
	menuDef.itemHeight = 20;
	menuDef.itemPadding = 0;
	menuDef.selectedIndex = 0;
	menuDef.xPos = 80;
	menuDef.yPos = 100;
	menuDef.xOffset = 0;
	menuDef.yOffset = 0;
	
	return menuDef;
}


createMenu_Controls( name )
{
	menuDef = spawnStruct();
	menuDef.name = name;
	menuDef.menuType = "fullScreen";
	menuDef.itemDefs = [];
	menuDef.itemWidth = 420;
	menuDef.itemHeight = 20;
	menuDef.itemPadding = 0;
	menuDef.selectedIndex = 0;
	menuDef.xPos = 80;
	menuDef.yPos = 100;
	menuDef.xOffset = 0;
	menuDef.yOffset = 0;
	
	return menuDef;
}


createSubMenu( name )
{
	subMenuDef = spawnStruct();
	subMenuDef.name = name;
	subMenuDef.menuType = "subMenu";
	subMenuDef.itemDefs = [];
	subMenuDef.itemWidth = 120;
	subMenuDef.itemHeight = 20;
	subMenuDef.itemPadding = 0;
	subMenuDef.selectedIndex = 0;
	subMenuDef.isExpanded = false;
	
	return subMenuDef;
}


addItem( text, action, event, description )
{
	precacheString(text);

	itemDef = spawnStruct();
	itemDef.itemType = "item";	
	itemDef.bgShader = "menu_button_selected";
	itemDef.fgText = text;
	itemDef.xPos = 0;
	itemDef.yPos = 0;
	itemDef.xOffset = 0;
	itemDef.yOffset = 0;
	itemDef.action = action;
	itemDef.event = event;
	itemDef.description = description;
	itemDef.parentDef = self;
	itemDef.index = self.itemDefs.size;

	self.itemDefs[self.itemDefs.size] = itemDef;
}


addItemSetting( text, action, event, description, setting )
{
	precacheString(text);

	itemDef = spawnStruct();
	itemDef.itemType = "settingMenu";	
	itemDef.bgShader = "menu_button_selected";
	itemDef.fgText = text;
	itemDef.xPos = 0;
	itemDef.yPos = 0;
	itemDef.xOffset = 0;
	itemDef.yOffset = 0;
	itemDef.action = action;
	itemDef.event = event;
	itemDef.description = description;
	itemDef.setting = setting;
	itemDef.parentDef = self;
	itemDef.index = self.itemDefs.size;

	self.itemDefs[self.itemDefs.size] = itemDef;
}


addSubMenu( name, text )
{
	itemDef = createSubMenu(name);
	itemDef.itemType = "subMenu";
	itemDef.bgShader = "menu_button_selected";
	itemDef.fgText = text;
	itemDef.xPos = 0;
	itemDef.yPos = 0;
	itemDef.xOffset = 20;
	itemDef.yOffset = (self.itemHeight + self.itemPadding) ;
	itemDef.parentDef = self;
	itemDef.index = self.itemDefs.size;

	self.itemDefs[self.itemDefs.size] = itemDef;

	return itemDef;
}


createItemElems()
{
	self.bgIcon = createIcon( self.bgShader, self.parentDef.itemWidth, self.parentDef.itemHeight );
	self.bgIcon.alpha = 0;
	self.bgIcon.sort = 0;

	self.fontString = createFontString( "default", 1.5 );
	self.fontString.alpha = 0;
	self.fontString.sort = 100;
	self.fontString setText( self.fgText );

	if ( self.itemType == "settingMenu" )
	{
		self.settingValue = createFontString( "default", 1.5 );
		self.settingValue.alpha = 0;
		self.settingValue.sort = 100;
		self updateDisplayValue();
	}
	
	if ( self.itemType == "subMenu" )
	{
		self.caretIcon = createIcon( "menu_caret_closed", self.parentDef.itemHeight, self.parentDef.itemHeight );	
		self.caretIcon.alpha = 0;
		self.caretIcon.sort = 100;
	}

	if ( isdefined ( self.description ) )
	{
		self.descriptionValue = createFontString( "default", 1.5 );
		self.descriptionValue.alpha = 0;
		self.descriptionValue.sort = 100;
		self.descriptionValue setText( self.description.display );
	}
}


destroyItemElems()
{
	if ( self.itemType == "subMenu" )
		self.caretIcon destroyElem();

	if ( self.itemType == "settingMenu" )
		self.settingValue destroyElem();

	if ( isdefined ( self.descriptionValue ) )
		self.descriptionValue destroyElem();

	self.bgIcon destroyElem();
	self.fontString destroyElem();
}		


setElemPoints( point, relativePoint, xPos, yPos, transTime )
{
	xOffset = 3;
	self.bgIcon setPoint( point, relativePoint, xPos, yPos, transTime );

	if ( self.itemType == "subMenu" )
	{
		self.caretIcon setPoint( point, relativePoint, xPos, yPos, transTime );
		xOffset += 16;
	}

	if ( self.itemType == "settingMenu" )
	{
		self.settingValue setPoint( "TOPRIGHT", relativePoint, xPos + xOffset + 400, yPos, transTime );
	}

	if ( isdefined ( self.descriptionValue ) )
	{
		self.descriptionValue setPoint( "TOPLEFT", relativePoint, self.description.xPos, self.description.yPos, transTime );
	}

	self.fontString setPoint( point, relativePoint, xPos + xOffset, yPos, transTime );
}

showMenu( transTime, isNew )
{
	yOffset = 0;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];

		itemDef createItemElems();

		if ( isNew )
		{
			itemDef setElemPoints( "TOPLEFT", "TOPRIGHT", self.xPos, self.yPos + yOffset );
		}
		else
		{
			itemDef setElemPoints( "TOPRIGHT", "TOPLEFT", self.xPos, self.yPos + yOffset );
		}
		
		itemDef.xPos = self.xPos;
		itemDef.yPos = self.yPos + yOffset;

		yOffset += (self.itemHeight + self.itemPadding);
		
		if ( itemDef.itemType == "subMenu" && itemDef.isExpanded )
		{
			yOffset += itemDef getMenuHeight();
//			itemDef thread showMenu( transTime, isNew );
		}
	}

	if ( self.menuType == "subMenu" )
		self.parentDef showMenu( transTime, isNew );
			
	self updateMenu( transTime, true );
}


hideMenu( transTime, isNew )
{
	yOffset = 0;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];

		xOffset = -1 * self.itemWidth;

		if ( isNew )
		{
			itemDef setElemPoints( "TOPRIGHT", "TOPLEFT", self.xPos, self.yPos + yOffset, transTime );
			itemDef.bgIcon fadeOverTime( transTime );
			itemDef.bgIcon.alpha = 0;
			itemDef.fontString fadeOverTime( transTime );
			itemDef.fontString.alpha = 0;			

			if ( itemDef.itemType == "settingMenu" )
			{
				itemDef.settingValue fadeOverTime( transTime );
				itemDef.settingValue.alpha = 0;
			}

			if ( itemDef.itemType == "subMenu" )
			{
				itemDef.caretIcon fadeOverTime( transTime );
				itemDef.caretIcon.alpha = 0;
			}
		}
		else
		{
			itemDef setElemPoints( "TOPLEFT", "TOPRIGHT", self.xPos, self.yPos + yOffset, transTime );
			itemDef.bgIcon fadeOverTime( transTime );
			itemDef.bgIcon.alpha = 0;
			itemDef.fontString fadeOverTime( transTime );
			itemDef.fontString.alpha = 0;			

			if ( itemDef.itemType == "settingMenu" )
			{
				itemDef.settingValue fadeOverTime( transTime );
				itemDef.settingValue.alpha = 0;
			}

			if ( itemDef.itemType == "subMenu" )
			{
				itemDef.caretIcon fadeOverTime( transTime );
				itemDef.caretIcon.alpha = 0;
			}
		}

		itemDef.xPos = self.xPos;
		itemDef.yPos = self.yPos + yOffset;

		yOffset += (self.itemHeight + self.itemPadding);
		
		if ( itemDef.itemType == "subMenu" && itemDef.isExpanded )
		{
			yOffset += itemDef getMenuHeight();
//			itemDef thread hideMenu( transTime, isNew );
		}
	}
	
	if ( self.menuType == "subMenu" )
		self.parentDef thread hideMenu( transTime, isNew );
	
	wait transTime;
	
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];
		itemDef destroyItemElems();
	}	
}


collapseMenu( transTime )
{
	self.isExpanded = false;
	self.caretIcon setShader( "menu_caret_closed", self.parentDef.itemHeight, self.parentDef.itemHeight );

	yOffset = 0;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];

		itemDef setElemPoints( "TOPLEFT", "TOPLEFT", self.xPos, self.yPos, transTime );
		itemDef.bgIcon fadeOverTime( transTime );
		itemDef.bgIcon.alpha = 0;
		itemDef.fontString fadeOverTime( transTime );
		itemDef.fontString.alpha = 0;

		if ( itemDef.itemType == "subMenu" )
		{
			itemDef.caretIcon fadeOverTime( transTime );
			itemDef.caretIcon.alpha = 0;
		}
		
		itemDef.xPos = self.xPos;
		itemDef.yPos = self.yPos;
	}
	
	wait transTime;
	
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];
		
		itemDef.bgIcon destroyElem();
		itemDef.fontString destroyElem();
		
		if ( itemDef.itemType == "subMenu" )	
			itemDef.caretIcon destroyElem();
	}
	
}


expandMenu( transTime )
{
	self.isExpanded = true;
	self.caretIcon setShader( "menu_caret_open", self.parentDef.itemHeight, self.parentDef.itemHeight );
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];

		itemDef createItemElems();

		itemDef setElemPoints( "TOPLEFT", "TOPLEFT", self.xPos + self.xOffset, self.yPos + self.yOffset );
		
		itemDef.xPos = self.xPos + self.xOffset;
		itemDef.yPos = self.yPos + self.yOffset;
	}
	self updateMenu( transTime, true );
}


updateMenu( transTime, forceRedraw )
{
	xOffset = self.xOffset;
	yOffset = self.yOffset;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];
		itemDef setSelected( transTime, index == self.selectedIndex );

		lastXPos = itemDef.xPos;
		lastYPos = itemDef.yPos;

		if ( forceRedraw || (self.xPos + xOffset != lastXPos) || (self.yPos + yOffset != lastYPos) )
		{
			itemDef setElemPoints( "TOPLEFT", "TOPLEFT", self.xPos + xOffset, self.yPos + yOffset, transTime );
	
			itemDef.xPos = self.xPos + xOffset;
			itemDef.yPos = self.yPos + yOffset;
		}

		yOffset += (self.itemHeight + self.itemPadding);

		if ( itemDef.itemType == "subMenu" && itemDef.isExpanded )
		{
			assert( level.curMenu != self );
			yOffset += itemDef getMenuHeight();
		}
	}
	
	if ( isDefined( self.parentDef ) )
		self.parentDef thread updateMenu( transTime, forceRedraw );
}


setSelected( transTime, isSelected )
{
	self.bgIcon fadeOverTime( transTime );
	self.fontString fadeOverTime( transTime );
	
	if ( isdefined( self.settingValue ) )
		self.settingValue fadeOverTime( transTime );

	if ( isdefined( self.descriptionValue ) )
		self.descriptionValue fadeOverTime( transTime );
	
	/*
	self setElemAlpha( 0.85 );
	if ( isSelected )
	{
		if ( self.parentDef == level.curMenu )
			self setElemColor( (1,1,1) );
		else
			self setElemColor( (0.85,0.85,0.85) );
	}
	else
	{
		if ( self.parentDef == level.curMenu )
			self setElemColor( (0.75,0.75,0.75) );
		else
			self setElemColor( (0.5,0.5,0.5) );
	}
	*/

	if ( isSelected )
	{
		if ( self.parentDef == level.curMenu )
			self setElemAlpha( 1 );
		else
			self setElemAlpha( 0.5 );

		if ( isdefined ( self.descriptionValue ) )
			self.descriptionValue.alpha = 1;
	}
	else
	{
		if ( self.parentDef == level.curMenu )
			self setElemAlpha( 0.5 );
		else
			self setElemAlpha( 0.25 );

		if ( isdefined ( self.descriptionValue ) )
			self.descriptionValue.alpha = 0;
	}
}


setElemAlpha( alpha )
{
	self.bgIcon.alpha = alpha;
	self.fontString.alpha = alpha;
	
	if ( self.itemType == "settingMenu" )
		self.settingValue.alpha = alpha;
	
	if ( self.itemType == "subMenu" )
		self.caretIcon.alpha = alpha;	

//	if ( isdefined ( self.descriptionValue ) )
//		self.descriptionValue.alpha = alpha;
}


setElemColor( color )
{
	self.fontString.color = color;
}


getMenuHeight()
{
	menuHeight = 0;
	for ( index = 0; index < self.itemDefs.size; index++ )
	{
		itemDef = self.itemDefs[index];

		menuHeight += (self.itemHeight + self.itemPadding);
		if ( itemDef.itemType == "subMenu" && itemDef.isExpanded )
			menuHeight += itemDef getMenuHeight();
	}
	
	return menuHeight;
}


onDPadUp()
{
	self.selectedIndex--;
	
	if ( self.selectedIndex	< 0 )
		self.selectedIndex = self.itemDefs.size - 1;
		
	self updateMenu( 0.1, false );
	
	level.player playsound("mouse_over");
}


onDPadDown()
{
	self.selectedIndex++;
	
	if ( self.selectedIndex	>= self.itemDefs.size )
		self.selectedIndex = 0;
		
	self updateMenu( 0.1, false );
	
	level.player playsound("mouse_over");
}


onButtonB()
{
	popMenu();
}


onButtonA()
{
	focusedItem = self.itemDefs[self.selectedIndex];
	
	if ( focusedItem.itemType == "subMenu" )
		pushMenu( focusedItem );
	else if ( focusedItem.itemType == "item" )
	{
/*		if ( isdefined( focusedItem.argument ) )
			level thread [[focusedItem.callback]]( focusedItem.argument );
		else
			level thread [[focusedItem.callback]]();*/
			
		focusedItem thread runAction();
	}
}


onDPadLeft()
{
	focusedItem = self.itemDefs[self.selectedIndex];
	
	if ( focusedItem.itemType == "settingMenu" )
	{
		dvarCurrent = getdvar( focusedItem.setting.dvar );
		dvarValues = focusedItem.setting.value;
		
		indexNew = 0;
		for ( i = 0; i < dvarValues.size; i++ )
		{
		    dvarValue = dvarValues[i];
		    
		    if(dvarValue != dvarCurrent)
		    	continue;

			indexNew = i - 1;
	
			if(indexNew >= 0)
			{
				focusedItem.setting.index = indexNew;
				
				setdvar( focusedItem.setting.dvar, dvarValues[indexNew] );
				focusedItem updateDisplayValue();
				println( "Setting: " + focusedItem.setting.dvar + " to " + dvarValues[indexNew] );
				level.player playsound("mouse_over");
			}

	    	break;
		}	
	}
}


onDPadRight()
{
	focusedItem = self.itemDefs[self.selectedIndex];
	
	if ( focusedItem.itemType == "settingMenu" )
	{
		dvarCurrent = getdvar( focusedItem.setting.dvar );
		dvarValues = focusedItem.setting.value;
		
		indexNew = 0;
		for ( i = 0; i < dvarValues.size; i++ )
		{
		    dvarValue = dvarValues[i];
		    
		    if(dvarValue != dvarCurrent)
		    	continue;

			indexNew = i + 1;
	
			if(indexNew <= focusedItem.setting.value.size - 1)
			{
				focusedItem.setting.index = indexNew;
				
				setdvar( focusedItem.setting.dvar, dvarValues[indexNew] );
				focusedItem updateDisplayValue();
				level.player playsound("mouse_over");
				println( "Setting: " + focusedItem.setting.dvar + " to " + dvarValues[indexNew] );
			}

	    	break;
		}	
	}
}


initThumbstickLayout()
{
	// update to use the real dvars when code will allow it
	setdvar( "controls_sticksConfig", "thumbstick_default" );
}

initButtonLayout()
{
	// update to use the real dvars when code will allow it
	setdvar( "controls_buttonConfig", "buttons_default" );
}

initSensitivity()
{
	// update to use the real dvars when code will allow it
	setdvar( "controls_sensitivityConfig", "sensitivity_medium" );
}

initInversion()
{
	// update to use the real dvars when code will allow it
	setdvar( "controls_inversionConfig", "inversion_disabled" );
}

initAutoAim()
{
	// update to use the real dvars when code will allow it
	setdvar( "controls_autoaimConfig", "autoaim_enabled" );
}

initVibration()
{
	// update to use the real dvars when code will allow it
	setdvar( "controls_vibrationConfig", "vibration_enabled" );
}


updateDisplayValue()
{
	self.settingValue setText( self.setting.display[self.setting.index] );
}


setupAction(name, arg1, arg2)
{
	action = spawnStruct();
	action.name = name;
	
	if ( isdefined ( arg1 ) )
		action.arg1 = arg1;
	
	if ( isdefined ( arg2 ) )
		action.arg2 = arg2;
		
	return action;
}


runAction()
{
	if ( isdefined ( self.action ) )
	{
		if ( isdefined ( self.action.arg1 ) )
			thread [[self.action.name]]( self.action.arg1 );
		else
			thread [[self.action.name]]();
	}		
	
	if ( isdefined ( self.event ) )
		level notify ( self.event );
}

testAction()
{
	level.marine setgoalnode(getnode("node2", "targetname"));
	level.camera attachpath(getvehiclenode( "path2", "targetname" ));
	thread maps\_vehicle::gopath(level.camera);
}



menuResponse()
{
	for ( ;; )
	{
		self waittill( "menuresponse", menu, response );
		println( response );

		switch ( response )
		{
			case "DPAD_UP":
				level.curMenu onDPadUp();
			break;
			case "DPAD_DOWN":
				level.curMenu onDPadDown();
			break;
			case "DPAD_LEFT":
				level.curMenu onDPadLeft();
			break;
			case "DPAD_RIGHT":
				level.curMenu onDPadRight();
			break;
			case "BUTTON_A":
				level.curMenu onButtonA();
			break;
			case "BUTTON_B":
				level.curMenu onButtonB();
			break;
		}
	}
}

