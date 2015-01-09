#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	build_template( "seaknight_airlift", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_ch46e");
	//build_turret( "seaknight_mark19", "tag_turret", "weapon_pickup_technical_mg50cal", true );
	build_deathfx( "explosions/large_vehicle_explosion",undefined,"explo_metal_rand");
	
	build_treadfx();

	build_life ( 999, 500, 1500 );
	
	build_team( "allies");
	build_drive( %sniper_escape_ch46_rotors, undefined, 0 );
	
	build_light ( model, "cockpit_red_cargo02", 		"tag_light_cargo02", 	"misc/aircraft_light_cockpit_red",		"interior",	0.0 );
	build_light ( model, "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue",		"interior",	0.1 );
	build_light ( model, "white_blink", 				"tag_light_belly", 		"misc/aircraft_light_red_blink",		"running", 	0.0 );
	build_light ( model, "white_blink_tail", 		"tag_light_tail", 		"misc/aircraft_light_red_blink",		"running", 	0.3 );
	build_light ( model, "wingtip_green1", 			"tag_light_L_wing1", 	"misc/aircraft_light_wingtip_green",	"running", 	0.0 );
	build_light ( model, "wingtip_green2", 			"tag_light_L_wing2", 	"misc/aircraft_light_wingtip_green",	"running", 	0.0 );
	build_light ( model, "wingtip_red1", 			"tag_light_R_wing1", 	"misc/aircraft_light_wingtip_red",		"running", 	0.2 );
	build_light ( model, "wingtip_red2", 			"tag_light_R_wing2", 	"misc/aircraft_light_wingtip_red",		"running", 	0.0 );
}

init_local()
{
	self.originheightoffset = distance( self gettagorigin( "tag_origin" ), self gettagorigin( "tag_ground" ) );
	self.fastropeoffset = 652; //TODO-FIXME: this is ugly.
	self.script_badplace = false; //All helicopters dont need to create bad places
}

set_vehicle_anims(positions)
{
	positions[ 1 ].vehicle_getoutanim = %ch46_doors_open;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getinanim = %ch46_doors_close;
	positions[ 1 ].vehicle_getinanim_clear = false;
	
	positions[ 1 ].vehicle_getoutsound = "seaknight_door_open";
	positions[ 1 ].vehicle_getinsound = "seaknight_door_close";
	
	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<0;i++)
		positions[i] = spawnstruct();
//copy from _blackhawk when anims are rigged.
	return positions;

}



unload_groups()
{

}


set_attached_models()
{

}