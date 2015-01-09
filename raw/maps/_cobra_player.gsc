#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	maps\_cobra::main( model, "cobra_player" );
	build_localinit( ::init_local );
}

init_local()
{
	self.delete_on_death = true;
	self.script_badplace = false; //All helicopters dont need to create bad places
	self thread maps\_vehicle::helicopter_dust_kickup();
}