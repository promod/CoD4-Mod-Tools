main()
{
	
}

get_name()
{
	american_names = 9;
	british_names 	= 18;
	russian_names 	= 15;

	if ( !(isdefined (game["americanvehiclenames"]) ) )
		game["americanvehiclenames"] = randomint (american_names);
	if ( !(isdefined (game["britishvehiclenames"]) ) )
		game["britishvehiclenames"] = randomint (british_names);
	if ( !(isdefined (game["russianvehiclenames"]) ) )
		game["russianvehiclenames"] = randomint (russian_names);


	if (level.campaign == "british")
	{
		game["britishvehiclenames"]++;
		get_british_name();
	}
	else
	if (level.campaign == "russian")
	{
		game["russianvehiclenames"]++;
		get_russian_name();
	}
	else
	{
		game["americanvehiclenames"]++;
		get_american_name();
	}
}

get_american_name()
{
	vehiclename = undefined;
	switch (game["americanvehiclenames"])
	{
		case  1: vehiclename = ("Marauder");break;
		case  2: vehiclename = ("Laughing Joe");break;
		case  3: vehiclename = ("Detroit Iron");break;
		case  4: vehiclename = ("Mississippi Mama");break;
		case  5: vehiclename = ("Big Bertha");break;
		case  6: vehiclename = ("Kraut-Eater");break;
		case  7: vehiclename = ("Thumper");break;
		case  8: vehiclename = ("Wicked Witch");break;
		case  9: vehiclename = ("Uncle Sam"); game["americanvehiclenames"] = 0;break;
	}
	vehiclename = add_group_name(vehiclename);
	self setvehiclelookattext (vehiclename,level.vehicletypefancy[self.vehicletype] );
}

get_british_name()
{
	vehiclename = undefined;
	switch (game["britishvehiclenames"])
	{
		case   1: vehiclename = ("Gravedigger");break;
		case   2: vehiclename = ("Angel Maker");break;
		case   3: vehiclename = ("Cannonball");break;
		case   4: vehiclename = ("Lucky Lucy");break;
		case   5: vehiclename = ("Greta Garbo");break;
		case   6: vehiclename = ("Hole in One");break;
		case   7: vehiclename = ("Smokey");break;
		case   8: vehiclename = ("Untouchable");break;
		case   9: vehiclename = ("Hellcat");break;
		case  10: vehiclename = ("Jerry's Medicine");break;
		case  11: vehiclename = ("Her Majesty");break;
		case  12: vehiclename = ("Storm Crow");break;
		case  13: vehiclename = ("Dust Devil");break;
		case  14: vehiclename = ("Homewrecker");break;
		case  15: vehiclename = ("Jack the Ripper");break;
		case  16: vehiclename = ("Divine Intervention");break;
		case  17: vehiclename = ("Bloody Mary");break;
		case  18: vehiclename = ("Pandemonium"); game["britishvehiclenames"] = 0;break;
	}
	vehiclename = add_group_name(vehiclename);
	self setvehiclelookattext (vehiclename,level.vehicletypefancy[self.vehicletype] );
}

get_russian_name()
{
	vehiclename = undefined;
	switch (game["russianvehiclenames"])
	{
		case  1: vehiclename = ("Gravedigger");break;
		case  2: vehiclename = ("Angel Maker");break;
		case  3: vehiclename = ("Cannonball");break;
		case  4: vehiclename = ("Lucky Lucy");break;
		case  5: vehiclename = ("Greta Garbo");break;
		case  6: vehiclename = ("Desert Devil");break;
		case  7: vehiclename = ("Hole in One");break;
		case  8: vehiclename = ("Smokey");break;
		case  9: vehiclename = ("Wicked Witch");break;
		case  10: vehiclename = ("Laughing Joe");break;
		case  11: vehiclename = ("Untouchable");break;
		case  12: vehiclename = ("Hellcat");break;
		case  13: vehiclename = ("Jerry's Medicine");break;
		case  14: vehiclename = ("Her Majesty");break;
		case  15: vehiclename = ("Pandemonium");game["russianvehiclenames"] = 0; break;
	}
	vehiclename = add_group_name(vehiclename);
	self setvehiclelookattext (vehiclename,level.vehicletypefancy[self.vehicletype] );
}

add_group_name(vehiclename)
{
	if(isdefined(self.script_tankgroup))
		vehiclename = self.script_tankgroup+": "+vehiclename;
	return vehiclename;	
}