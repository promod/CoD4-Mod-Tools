#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

//need to be able to save select dvar in menu (spending points while in the menu)
//need to be able to save select dvar from script (dvars track which items are found)
main()
{
	//assert_if_identical_origins();
	precachestring( &"SCRIPT_INTELLIGENCE_OF_THIRTY");
	level.intel_items = create_array_of_intel_items();
	println ("intelligence.gsc:             intelligence items:", level.intel_items.size);
	
	setDvar( "ui_level_cheatpoints", level.intel_items.size ); 
	
	level.table_origins = create_array_of_origins_from_table();
	
	initialize_intel();
	
	level.intel_counter = 0;	// intel_counter for collected intel points for this mission
	setDvar( "ui_level_player_cheatpoints", level.intel_counter ); 
	
	remove_found_intel();
}

remove_found_intel()
{
	while( true )
	{
		for (i=0;i<level.intel_items.size;i++)
		{
			if ( !isdefined( level.intel_items[i].removed ) && level.intel_items[i] check_item_found() )
			{
				level.intel_items[i].removed = true;
				level.intel_items[i].item hide();
				level.intel_items[i].item notsolid();
				level.intel_items[i] trigger_off();
				level.intel_items[i] notify( "end_trigger_thread" );
				println( "^3Removed Intel: " + level.intel_items[i].num );

				level.intel_counter++;
				setDvar( "ui_level_player_cheatpoints", level.intel_counter ); 
			}
		}
		wait 0.1;
	}
}

initialize_intel()
{
	for (i=0;i<level.intel_items.size;i++)
	{
		trigger = level.intel_items[ i ];
		origin = trigger.origin;
		level.intel_items[i].num = get_nums_from_origins( origin ); 
		level.intel_items[i].dvarstring = get_dvar_string( level.intel_items[i].num ); 
		level.intel_items[i].bitOffset = get_bit_offset( level.intel_items[i].num ); 
		
		if ( level.intel_items[i] check_item_found() )
		{
			trigger.item hide();
			trigger.item notsolid();
			trigger trigger_off();
			level.intel_items[i].found = true;
		}
		else
		{
			level.intel_items[i] thread wait_for_pickup();
		}
	}
}

get_dvar_string ( num )
{
	// dvarString needs to be looked up from the stats table
	//intel_table_lookup( get_col, with_col, with_data )
	dvarString = intel_table_lookup( 1, 0, num );
	
	return dvarString;
}

get_bit_offset ( num )
{
	// bitOffset needs to be looked up from the stats table
	//intel_table_lookup( get_col, with_col, with_data )
	bitOffset = int ( intel_table_lookup( 2, 0, num ) );
	
	return bitOffset;
}

check_item_found()
{
	curValue = getDvarInt( self.dvarString );
	
	//println ( "dvarString " + dvarString );
	//println ( "curValue " + curValue );
	//println ( "bitOffset " + bitOffset );
	
	//(x & y) returns y if y is in x
	return ( (curValue & self.bitOffset) == self.bitOffset );
}

create_array_of_intel_items()
{
	intelligence_items = getentarray ("intelligence_item", "targetname");
	for (i=0;i<intelligence_items.size;i++)
	{
		println ( intelligence_items[ i ].origin );
		intelligence_items[i].item = getent(intelligence_items[i].target, "targetname");
		intelligence_items[i].found = false;
	}
	return intelligence_items;
}

create_array_of_origins_from_table()
{
	//tablelookup( "maps/_intel_items.csv", with_col, with_data, get_col );
	origins = [];
	for (num=1;num<65;num++)
	{
		location = tablelookup( "maps/_intel_items.csv", 0, num, 4 );
		if ( isdefined ( location ) && ( location != "undefined" ) )
		{
			locArray = strTok( location, "," );
			assert( locArray.size == 3 );
			for (i=0;i<locArray.size;i++)
				locArray[i] = int ( locArray[i] );
			origins [ num ] = (locArray[0], locArray[1], locArray[2]);
		}
		else 
			origins [ num ] = undefined;
	}
	return origins;
}

wait_for_pickup()
{
	self setHintString (&"SCRIPT_INTELLIGENCE_PICKUP");
	self usetriggerrequirelookat();
	
	self endon( "end_trigger_thread" );
	self waittill("trigger");

	self.found = true;
	self trigger_off();
	save_that_item_is_found();
	give_points();
	UpdateGamerProfile();
	self intel_feedback();
}

save_that_item_is_found()
{
	// dvarString needs to be looked up from the stats table
	//intel_table_lookup( get_col, with_col, with_data )
	dvarString = intel_table_lookup( 1, 0, self.num );
	
	curValue = getDvarInt( dvarString );
	
	// bitOffset needs to be looked up from the stats table
	bitOffset = int ( intel_table_lookup( 2, 0, self.num ) );
	
	// make sure we haven't already found this item
	assert( (curValue & bitOffset) != bitOffset );

	curValue = (curValue | bitOffset);	//add the bit to the dvar
	
	setDvar( dvarString, curValue );  //make setSavedDvar
	
	logString( "found intel item " + bitOffset );
	
	//(x & y) returns y if y is in x
	return ( (curValue & bitOffset) == bitOffset );
}


give_points()
{
	curValue = getDvarInt( "cheat_points" );
	
	curValue += 1;
	
	setDvar( "cheat_points", curValue );
}



get_nums_from_origins( origin )
{
	for (i=1;i<level.table_origins.size+1;i++)
	{
		if ( !isdefined ( level.table_origins [ i ] ) )
			continue;
		if ( distancesquared( origin, level.table_origins[ i ] ) < 25 )
			return i;
	}
	assertmsg( "Add the origin of this intel item ( " + origin + " ) to maps/_intel_items.csv file" );
		
	//tablelookup( "maps/_intel_items.csv", with_col, with_data, get_col );
	/*
	return_value = tablelookup( "maps/_intel_items.csv", 4, origin, 0 );//column 0 is the number and column 3 is the origin
	assertex( isdefined( return_value ), "Add the origin of this intel item ( " + origin + " ) to maps/_intel_items.csv file");
	if (return_value == "" )
		assertmsg( "Add the origin of this intel item ( " + origin + " ) to maps/_intel_items.csv file" );
	if (return_value == "undefined" )
		assertmsg( "Add the origin of this intel item ( " + origin + " ) to maps/_intel_items.csv file" );
	return return_value;
	*/
}



intel_table_lookup( get_col, with_col, with_data )
{
	return_value = tablelookup( "maps/_intel_items.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;	
}

intel_feedback()
{
	self.item hide();
	self.item notsolid();
	level thread maps\_utility::play_sound_in_space("intelligence_pickup",self.item.origin);
	
	display_time = 3000;
	fade_time = 700;

	remaining_print = createFontString( "objective", 1.5 );
	remaining_print.glowColor = ( 0.7, 0.7, 0.3 );
	remaining_print.glowAlpha = 1;
	remaining_print setup_hud_elem();
	remaining_print.y = -60;
	remaining_print SetPulseFX( 60, display_time, fade_time );
	remaining_print.label = &"SCRIPT_INTELLIGENCE_OF_THIRTY";
	intel_found = getDvarInt( "cheat_points" );
	remaining_print setValue ( intel_found );
	
	if( intel_found == 15 )
		maps\_utility::giveachievement_wrapper( "LOOK_SHARP" );
	
	if( intel_found == 30 )
		maps\_utility::giveachievement_wrapper( "EARS_AND_EYES" );
	

	wait display_time + fade_time / 1000;

	remaining_print Destroy();
}

setup_hud_elem()
{	
	self.color = ( 1, 1, 1 );
	self.alpha = 1;
	self.x = 0;
	self.alignx = "center";
	self.aligny = "middle";
	self.horzAlign = "center";
	self.vertAlign = "middle";
	self.foreground = true;
}

assert_if_identical_origins()
{
	//tablelookup( "maps/_intel_items.csv", with_col, with_data, get_col );
	origins = [];
	for (i=1;i<65;i++)
	{
		location = tablelookup( "maps/_intel_items.csv", 0, i, 4 );
		locArray = strTok( location, "," );
		//assert( locArray.size == 3 );
		for (i=0;i<locArray.size;i++)
			locArray[i] = int ( locArray[i] );
		origins [ i ] = (locArray[0], locArray[1], locArray[2]);
		
		
		//if ( distancesquared( first.origin, second.origin ) < 4 );
	}
	
	for (i=0;i<origins.size;i++)
	{
		if ( ! isdefined ( origins [ i ] ) )
			continue;
		if ( origins [ i ] == "undefined" )
			continue;
		for (j=0;j<origins.size;j++)
		{
			if ( ! isdefined ( origins [ j ] ) )
				continue;
			if ( origins [ j ] == "undefined" )
				continue;
			if ( i == j )
				continue;
			if ( origins [ i ] == origins[ j ] )
				assertmsg( "intel items in maps/_intel_items.csv with identical origins (" + origins[ i ] + ") " );
		}
	}
}
