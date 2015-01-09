#include maps\_vehicle_aianim;
#include maps\_vehicle;
main(model,type)
{
	if(!isdefined(type))
		type = "humvee50cal";
	maps\_humvee::main(model,type);
	level.vehicle_aianims[type] = setanims(type);
}
#using_animtree ("generic_human");
setanims(type)
{

	positions = level.vehicle_aianims[type];
	pos = positions.size;
	positions[pos] = spawnstruct();

	positions[pos].sittag = "tag_guy_turret";
	positions[pos].idle = %humvee_turret_idle;
	positions[pos].getout = %humvee_driver_climb_out;
	positions[pos].getin = %humvee_driver_climb_in;
	positions[pos].turret_fire = %humvee_turret_fire;

	return positions;
}