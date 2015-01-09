main()
{
}

setup_names()
{
	assert( !isdefined( level.names ) );

	nationalities = [];
	nationalities[0] = "american";
	nationalities[1] = "british";
	nationalities[2] = "arab";
	nationalities[3] = "russian";
	
	for ( i = 0; i < nationalities.size; i++ )
		level.names[ nationalities[i] ] = [];
	

	add_name( "american", "Abrahamsson" );
	add_name( "american", "Alavi" );
	add_name( "american", "Alderman" );
	add_name( "american", "Allen" );
	add_name( "american", "Arya" );
	add_name( "american", "Baker" );
	add_name( "american", "Barb" );
	add_name( "american", "Bartolucci" );
	add_name( "american", "Bell" );
	add_name( "american", "Blumel" );
	add_name( "american", "Boon" );
	add_name( "american", "Bowling" );
	add_name( "american", "Campbell" );
	add_name( "american", "Chen" );
	add_name( "american", "Cherubini" );
	add_name( "american", "Collier" );
	add_name( "american", "Cotterell" );
	add_name( "american", "Davis" );
	add_name( "american", "Eady" );
	add_name( "american", "Emslie" );
	add_name( "american", "Field" );
	add_name( "american", "Fukuda" );
	add_name( "american", "Gaines" );
	add_name( "american", "Ganus" );
	add_name( "american", "Gigliotti" );
	add_name( "american", "Gillis" );
	add_name( "american", "Glasco" );
	add_name( "american", "Glenn" );
	add_name( "american", "Gompert" );
	add_name( "american", "Grenier" );
	add_name( "american", "Griffen" );
	add_name( "american", "Haggerty" );
	add_name( "american", "Hammon" );
	add_name( "american", "Harmer" );
	add_name( "american", "Harris" );
	add_name( "american", "Hatch" );
	add_name( "american", "Hawkins" );
	add_name( "american", "Heath" );
	add_name( "american", "James" );
	add_name( "american", "Kar" );
	add_name( "american", "Keating" );
	add_name( "american", "Kriegler" );
	add_name( "american", "Kuhn" );
	add_name( "american", "Lastimosa" );
	add_name( "american", "Lopez" );
	add_name( "american", "Lor" );
	add_name( "american", "Louie" );
	add_name( "american", "Lowis" );
	add_name( "american", "Luo" );
	add_name( "american", "Massey" );
	add_name( "american", "McCandlish" );
	add_name( "american", "McCoy" );
	add_name( "american", "McLeod" );
	add_name( "american", "Messerly" );
	add_name( "american", "Miller" );
	add_name( "american", "Niebel" );
	add_name( "american", "Oh" );
	add_name( "american", "Ojeda" );
	add_name( "american", "Onur" );
	add_name( "american", "Peas" );
	add_name( "american", "Pelayo" );
	add_name( "american", "Pierce" );
	add_name( "american", "Porter" );
	add_name( "american", "Rieke" );
	add_name( "american", "Rosemeier" );
	add_name( "american", "Roycewicz" );
	add_name( "american", "Rubin" );
	add_name( "american", "Rule" );
	add_name( "american", "Sharrigan" );
	add_name( "american", "Shiring" );
	add_name( "american", "Sue" );
	add_name( "american", "Turner" );
	add_name( "american", "Vinson" );
	add_name( "american", "Volker" );
	add_name( "american", "Wang" );
	add_name( "american", "West" );
	add_name( "american", "Yang" );
	add_name( "american", "Zampella" );
	
	add_name( "american", "Mejia" );
	add_name( "american", "Becerra" );
	add_name( "american", "Castillo" );
	add_name( "american", "Childress" );
	add_name( "american", "Germann" );
	add_name( "american", "Lara" );
	add_name( "american", "Ovando" );
	add_name( "american", "Slanchik" );
	add_name( "american", "Vo" );
	add_name( "american", "Garnett" );
	add_name( "american", "Smith" );

	add_name( "american", "Troy" );
	add_name( "american", "Carson" );
	

	add_name( "british", "Abbot" );
	add_name( "british", "Adams" );
	add_name( "british", "Bartlett" );
	add_name( "british", "Boyd" );
	add_name( "british", "Boyle" );
	add_name( "british", "Bremner" );
	add_name( "british", "Carlyle" );
	add_name( "british", "Carver" );
	add_name( "british", "Cheek" );
	add_name( "british", "Clarke" );
	add_name( "british", "Collins" );
	add_name( "british", "Compton" );
	add_name( "british", "Connolly" );
	add_name( "british", "Cook" );
	add_name( "british", "Dowd" );
	add_name( "british", "Field" );
	add_name( "british", "Fleming" );
	add_name( "british", "Fletcher" );
	add_name( "british", "Flynn" );
	add_name( "british", "Grant" );
	add_name( "british", "Greaves" );
	add_name( "british", "Griffin" );
	add_name( "british", "Harris" );
	add_name( "british", "Harrison" );
	add_name( "british", "Heath" );
	add_name( "british", "Henderson" );
	add_name( "british", "Hopkins" );
	add_name( "british", "Hoyt" );
	add_name( "british", "Kent" );
	add_name( "british", "Lewis" );
	add_name( "british", "Lipton" );
	add_name( "british", "Macdonald" );
	add_name( "british", "Maxwell" );
	add_name( "british", "McQuarrie" );
	add_name( "british", "Miller" );
	add_name( "british", "Mitchell" );
	add_name( "british", "Moore" );
	add_name( "british", "Murphy" );
	add_name( "british", "Murray" );
	add_name( "british", "Pearce" );
	add_name( "british", "Plumber" );
	add_name( "british", "Pritchard" );
	add_name( "british", "Rankin" );
	add_name( "british", "Reed" );
	add_name( "british", "Ritchie" );
	add_name( "british", "Ross" );
	add_name( "british", "Roth" );
	add_name( "british", "Smith" );
	add_name( "british", "Stevenson" );
	add_name( "british", "Stuart" );
	add_name( "british", "Sullivan" );
	add_name( "british", "Thompson" );
	add_name( "british", "Veale" );
	add_name( "british", "Wallace" );
	add_name( "british", "Wallcroft" );
	add_name( "british", "Wells" );
	add_name( "british", "Welsh" );

	add_name( "russian", "Sasha Ivanov" );
	add_name( "russian", "Aleksei Vyshinskiy" );
	add_name( "russian", "Boris Ryzhkov" );
	add_name( "russian", "Dima Tikhonov" );
	add_name( "russian", "Oleg Kosygin" );
	add_name( "russian", "Pyotr Bulganin" );
	add_name( "russian", "Petya Malenkov" );
	add_name( "russian", "Alyosha Tarkovsky" );
	add_name( "russian", "Sergei Grombyo" );
	add_name( "russian", "Viktor Kuznetsov" );
	add_name( "russian", "Misha Podgorniy" );
	add_name( "russian", "Borya Mikoyan" );
	add_name( "russian", "Anatoly Voroshilov" );
	add_name( "russian", "Kolya Shvernik" );
	add_name( "russian", "Nikolai Kalinin" );
	add_name( "russian", "Vladimir Brezhnev" );
	add_name( "russian", "Pavel Chernenko" );
	add_name( "russian", "Volodya Andropov" );
	add_name( "russian", "Yuri Nikitin" );
	add_name( "russian", "Dmitri Petrenko" );
	add_name( "russian", "Vanya Gerasimov" );
	add_name( "russian", "Mikhail Zhuravlev" );
	add_name( "russian", "Ivan Lukin" );
	add_name( "russian", "Kostya Golubev" );
	add_name( "russian", "Konstantin Lebedev" );
	add_name( "russian", "Aleksandr Vasilev" );
	add_name( "russian", "Yakov Glushenko" );
	add_name( "russian", "Sasha Semenov" );
	add_name( "russian", "Aleksei Ulyanov" );
	add_name( "russian", "Boris Yefremov" );
	add_name( "russian", "Dima Chernyshenko" );
	add_name( "russian", "Oleg Stepanoshvili" );
	add_name( "russian", "Pyotr Demchenko" );
	add_name( "russian", "Petya Avagimov" );
	add_name( "russian", "Alyosha Murzaev" );
	add_name( "russian", "Sergei Shkuratov" );
	add_name( "russian", "Viktor Yakimenko" );
	add_name( "russian", "Misha Masijashvili" );
	add_name( "russian", "Borya Shapovalov" );
	add_name( "russian", "Anatoly Ivashenko" );
	add_name( "russian", "Kolya Dovzhenko" );
	add_name( "russian", "Nikolai Turdyev" );
	add_name( "russian", "Vladimir Sabgaida" );
	add_name( "russian", "Pavel Svirin" );
	add_name( "russian", "Volodya Sarayev" );
	add_name( "russian", "Yuri Kiselev" );
	add_name( "russian", "Dmitri Bondarenko" );
	add_name( "russian", "Vanya Chernogolov" );
	add_name( "russian", "Mikhail Voronov" );
	add_name( "russian", "Ivan Afanasyev" );
	add_name( "russian", "Kostya Gridin" );
	add_name( "russian", "Konstantin Petrov" );
	add_name( "russian", "Aleksandr Rykov" );
	add_name( "russian", "Yakov Shvedov" );

	add_name( "arab", "Abdulaziz" );
	add_name( "arab", "Abdullah" ); 
	add_name( "arab", "Ali" );      
	add_name( "arab", "Amin" );     
	add_name( "arab", "Bassam" );   
	add_name( "arab", "Fahd" );     
	add_name( "arab", "Faris" );    
	add_name( "arab", "Fouad" );    
	add_name( "arab", "Habib" );    
	add_name( "arab", "Hakem" );    
	add_name( "arab", "Hassan" );   
	add_name( "arab", "Ibrahim" );  
	add_name( "arab", "Imad" );     
	add_name( "arab", "Jabbar" );   
	add_name( "arab", "Kareem" );   
	add_name( "arab", "Khalid" );   
	add_name( "arab", "Malik" );    
	add_name( "arab", "Muhammad" ); 
	add_name( "arab", "Nasir" );    
	add_name( "arab", "Omar" );     
	add_name( "arab", "Rafiq" );    
	add_name( "arab", "Rami" );     
	add_name( "arab", "Said" );     
	add_name( "arab", "Salim" );    
	add_name( "arab", "Samir" );    
	add_name( "arab", "Talib" );    
	add_name( "arab", "Tariq" );    
	add_name( "arab", "Youssef" );  
	add_name( "arab", "Ziad" );

	for ( i = 0; i < nationalities.size; i++ )
	{
		randomize_name_list( nationalities[i] );
		level.nameIndex[ nationalities[i] ] = 0;
	}
}

add_name( nationality, thename )
{
	level.names[ nationality ][ level.names[ nationality ].size ] = thename;
}

randomize_name_list( nationality )
{
	size = level.names[ nationality ].size;
	for ( i = 0; i < size; i++ )
	{
		switchwith = randomint( size );
		temp = level.names[ nationality ][i];
		level.names[ nationality ][i] = level.names[ nationality ][switchwith];
		level.names[ nationality ][switchwith] = temp;
	}
}

get_name(override)
{
	if ( !isdefined( override ) && level.script == "credits" )
	{
		self.airank = "private";
		return;
	}
	
	if ( isdefined( self.script_friendname ) )
	{
		if (self.script_friendname == "none")
			return;
		self.name = self.script_friendname;
		getRankFromName( self.name );
		self notify ("set name and rank");
		return;
	}
	
	assert( isdefined( level.names ) );
	
	get_name_for_nationality( self.voice );
	
	self notify ("set name and rank");
}

get_name_for_nationality( nationality )
{
	assertex( isdefined( level.nameIndex[ nationality ] ), nationality );
	
	level.nameIndex[ nationality ] = (level.nameIndex[ nationality ] + 1) % level.names[ nationality ].size;
	lastname = level.names[ nationality ][ level.nameIndex[ nationality ] ];

	rank = randomint (10);
	if (rank > 5)
	{
		fullname = "Pvt. " + lastname;
		self.airank = "private";
	}
	else if (rank > 2)
	{
		fullname = "Cpl. " + lastname;
		self.airank = "private";
	}
	else
	{
		fullname = "Sgt. " + lastname;
		self.airank = "sergeant";
	}
	
	if ( self.team == "axis" )
		self.ainame = fullname;
	else
		self.name = fullname;
}

getRankFromName( name )
{
	if (!isdefined (name))
		self.airank = ("private");
	
	tokens = strtok( name, " " );
	assert ( tokens.size );
	shortRank = tokens[0];

	switch (shortRank)
	{
	case "Pvt.":
		self.airank = "private";
		break;
	case "Pfc.":
		self.airank = "private";
		break;
	case "Cpl.":
		self.airank = "private";
		break;
	case "Sgt.":
		self.airank = "sergeant";
		break;
	case "Lt.":
		self.airank = "lieutenant";
		break;
	case "Cpt.":
		self.airank = "captain";
		break;
	default:
		println("sentient has invalid rank " + shortRank + "!");
		self.airank = "private";
		break;
	}
}
