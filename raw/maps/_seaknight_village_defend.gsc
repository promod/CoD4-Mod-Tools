#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	build_template( "seaknight", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_ch46e");

	build_deathfx( "explosions/large_vehicle_explosion",undefined,"explo_metal_rand");
	
	build_treadfx();

	build_life ( 999, 500, 1500 );
	
	build_team( "allies");
	build_aianims( ::setanims , ::set_vehicle_anims );
	
	build_drive( %sniper_escape_ch46_rotors, undefined, 0 );

	build_unload_groups( ::Unload_Groups );

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
	/*
	positions[ 1 ].vehicle_getoutanim = %ch46_doors_open;
	positions[ 1 ].vehicle_getoutanim_clear = false;
	positions[ 1 ].vehicle_getinanim = %ch46_doors_close;
	positions[ 1 ].vehicle_getinanim_clear = false;
	
	positions[ 1 ].vehicle_getoutsound = "seaknight_door_open";
	positions[ 1 ].vehicle_getinsound = "seaknight_door_close";
	*/

	//positions[ 1 ].delay = getanimlength( %ch46_doors_open )-1.7;
	//positions[ 2 ].delay = getanimlength( %ch46_doors_open )-1.7;
	//positions[ 3 ].delay = getanimlength( %ch46_doors_open )-1.7;
	//positions[ 4 ].delay = getanimlength( %ch46_doors_open )-1.7;
	
	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<6;i++)
		positions[i] = spawnstruct();
		
	positions[ 0 ].idle[0] = %SeaKnight_Pilot_idle;
	positions[ 0 ].idle[1] = %SeaKnight_Pilot_switches;
	positions[ 0 ].idle[2] = %SeaKnight_Pilot_twitch;
	positions[ 0 ].idleoccurrence[0] = 1000;
	positions[ 0 ].idleoccurrence[1] = 400;
	positions[ 0 ].idleoccurrence[2] = 200;
	
	positions[ 0 ].bHasGunWhileRiding = false;	
	positions[ 5 ].bHasGunWhileRiding = false;	

	positions[ 1 ].idle = %ch46_unload_1_idle; //these guys don't have an idle animation so I'm using copilot.
	positions[ 2 ].idle = %ch46_unload_2_idle; //these guys don't have an idle animation so I'm using copilot.
	positions[ 3 ].idle = %ch46_unload_3_idle; //these guys don't have an idle animation so I'm using copilot.
	positions[ 4 ].idle = %ch46_unload_4_idle; //these guys don't have an idle animation so I'm using copilot.

	positions[ 5 ].idle[0] = %SeaKnight_coPilot_idle;
	positions[ 5 ].idle[1] = %SeaKnight_coPilot_switches;
	positions[ 5 ].idle[2] = %SeaKnight_coPilot_twitch;
	
	positions[ 5 ].idleoccurrence[0] = 1000;
	positions[ 5 ].idleoccurrence[1] = 400;
	positions[ 5 ].idleoccurrence[2] = 200;

	positions[ 0 ].sittag = "tag_detach";
	positions[ 1 ].sittag = "tag_detach";
	positions[ 2 ].sittag = "tag_detach";
	positions[ 3 ].sittag = "tag_detach";
	positions[ 4 ].sittag = "tag_detach";
	positions[ 5 ].sittag = "tag_detach";

//	positions[ 1 ].getoutstance = "crouch";
//	positions[ 2 ].getoutstance = "crouch";
//	positions[ 3 ].getoutstance = "crouch";
//	positions[ 4 ].getoutstance = "crouch";

	positions[ 1 ].getout = %ch46_unload_1;
	positions[ 2 ].getout = %ch46_unload_2;
	positions[ 3 ].getout = %ch46_unload_3;
	positions[ 4 ].getout = %ch46_unload_4;
	
	

	positions[ 1 ].getin = %ch46_load_1;
	positions[ 2 ].getin = %ch46_load_2;
	positions[ 3 ].getin = %ch46_load_3;
	positions[ 4 ].getin = %ch46_load_4;
	
	return positions;

}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "passengers" ][ unload_groups[ "passengers" ].size ] = 1;
	unload_groups[ "passengers" ][ unload_groups[ "passengers" ].size ] = 2;
	unload_groups[ "passengers" ][ unload_groups[ "passengers" ].size ] = 3;
	unload_groups[ "passengers" ][ unload_groups[ "passengers" ].size ] = 4;
	unload_groups[ "default" ] = unload_groups[ "passengers" ];
	return unload_groups;
}

set_attached_models()
{

}