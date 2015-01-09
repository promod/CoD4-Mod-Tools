main()
{

	level._effect["bird_seagull_flock_large"]		= loadfx ("misc/bird_seagull_flock_large");
	level._effect[ "cloud_bank_far" ]				= loadfx( "weather/jeepride_cloud_bank_far" );
	level._effect["fog_bog_a"]						= loadfx ("weather/fog_bog_a");

/#		
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_shipment_fx::main();
#/		
}
