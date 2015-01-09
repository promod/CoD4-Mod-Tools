main()
{
	level._effect[ "wood" ]				 		= loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]				 		= loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ]			 		= loadfx( "explosions/grenadeExp_concrete_1" );
	level._effect[ "coolaidmanbrick" ]	 		= loadfx( "explosions/grenadeExp_concrete_1" );

	level._effect[ "launchtube_steam" ]	 		= loadfx( "smoke/launchTube_steam" );
	level._effect[ "smoke_missile_launched" ] 	= loadfx("smoke/smoke_launchtubes");
	level._effect[ "ground_smoke_launch_a" ]	= loadfx("smoke/ground_smoke_launch_a");

	//ambientFX();
/#	
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_countdown_fx::main();
#/
}

ambientFX()
{
	// temp tube smoke
	
	ent = maps\mp\_utility::createOneshotEffect("smoke_missile_launched");
    ent.v["origin"] = (632, 936, -200);
    ent.v["angles"] = (270,0,0);
    ent.v["delay"] = -120;
	
	ent = maps\mp\_utility::createOneshotEffect("smoke_missile_launched");
    ent.v["origin"] = (632, -24, -200);
    ent.v["angles"] = (270,0,0);
    ent.v["delay"] = -120;
    
    ent = maps\mp\_utility::createOneshotEffect("smoke_missile_launched");
    ent.v["origin"] = (-600, -24, -200);
    ent.v["angles"] = (270,0,0);
    ent.v["delay"] = -120;	
    
    ent = maps\mp\_utility::createOneshotEffect("launchtube_steam");
    ent.v["origin"] = (-656, 1052, 0);
    ent.v["angles"] = (0,0,0);
    ent.v["delay"] = -120;	
}