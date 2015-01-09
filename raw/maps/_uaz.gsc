#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, no_death )
{
	build_template( "uaz", model, type );
	build_localinit( ::init_local );
		
	build_destructible( "vehicle_uaz_hardtop_destructible", "vehicle_uaz_hardtop" );
	build_destructible( "vehicle_uaz_light_destructible", "vehicle_uaz_light" );
	build_destructible( "vehicle_uaz_open_destructible", "vehicle_uaz_open" );
	build_destructible( "vehicle_uaz_open_for_ride", "vehicle_uaz_open" );
	build_destructible( "vehicle_uaz_fabric_destructible", "vehicle_uaz_fabric" );

	build_bulletshield( true ); 
	
	if ( !isdefined( no_death ) )
	{
		build_deathmodel( "vehicle_uaz_fabric", "vehicle_uaz_fabric_dsr" );
		build_deathmodel( "vehicle_uaz_hardtop", "vehicle_uaz_hardtop_dsr" );
		build_deathmodel( "vehicle_uaz_open", "vehicle_uaz_open_dsr" );
		build_deathmodel( "vehicle_uaz_hardtop_thermal", "vehicle_uaz_hardtop_thermal" );
		build_deathmodel( "vehicle_uaz_open_for_ride" );
		build_deathfx( "explosions/small_vehicle_explosion", undefined, "explo_metal_rand" );
	}
	
	build_radiusdamage( (0,0,32) , 300, 200, 100, false );
	build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
	build_deathquake( 1, 1.6, 500 );
	
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_aianims( ::setanims , ::set_vehicle_anims );
}

init_local()
{
	self.clear_anims_on_death  = true; // hackery workaround for strange anim differences in the variety of uaz models. clears driving and possibly door openning animations upon death.
}


set_vehicle_anims( positions )
{          
//positions[ 0 ].sittag = "tag_driver";   
//positions[ 1 ].sittag = "tag_passenger";
//positions[ 2 ].sittag = "tag_guy0"; //driver_side_rear        
//positions[ 3 ].sittag = "tag_guy1";  //passenger_side_rear    
//positions[ 4 ].sittag = "tag_guy2"; //driver_far_rear         
//positions[ 5 ].sittag = "tag_guy3";  //passenger_side_far_rear
	
		positions[ 0 ].vehicle_getoutanim = %uaz_driver_exit_into_run_door;
		positions[ 1 ].vehicle_getoutanim = %uaz_passenger_exit_into_run_door;
//		positions[ 2 ].vehicle_getoutanim = %uaz_rear_driver_exit_into_run_door;                           
//		positions[ 3 ].vehicle_getoutanim = %uaz_passenger2_exit_into_run_door;                            

//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger2_exit_into_run_door.XANIM_EXPORT#1 add
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_driver_exit_into_run_door.XANIM_EXPORT#3 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger_exit_into_run_door.XANIM_EXPORT#3 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_rear_driver_exit_into_run_door.XANIM_EXPORT#1 add
		
//		positions[ 0 ].vehicle_getoutanim_clear = false;
//		positions[ 1 ].vehicle_getoutanim_clear = false;

		positions[ 0 ].vehicle_getinanim = %uaz_driver_enter_from_huntedrun_door;
		positions[ 1 ].vehicle_getinanim = %uaz_passenger_enter_from_huntedrun_door;
//		positions[ 2 ].vehicle_getinanim = %uaz_rear_driver_enter_from_huntedrun_door;
//		positions[ 3 ].vehicle_getinanim = %uaz_passenger2_enter_from_huntedrun_door;

//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_driver_enter_from_huntedrun_door.XANIM_EXPORT#3 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger2_enter_from_huntedrun_door.XANIM_EXPORT#1 add
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger_enter_from_huntedrun_door.XANIM_EXPORT#3 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_rear_driver_enter_from_huntedrun_door.XANIM_EXPORT#1 add
	
		positions[ 0 ].vehicle_getoutsoundtag = "front_door_left_jnt";
		positions[ 1 ].vehicle_getoutsoundtag = "front_door_right_jnt";
		positions[ 2 ].vehicle_getoutsoundtag = "rear_door_left_jnt";	
		positions[ 3 ].vehicle_getoutsoundtag = "rear_door_right_jnt";

		positions[ 0 ].vehicle_getinsound = "truck_door_open";
		positions[ 1 ].vehicle_getinsound = "truck_door_open";
		positions[ 2 ].vehicle_getinsound = "truck_door_open";	
		positions[ 3 ].vehicle_getinsound = "truck_door_open";
			
		positions[ 0 ].vehicle_getinsoundtag = "front_door_left_jnt";
		positions[ 1 ].vehicle_getinsoundtag = "front_door_right_jnt";
		positions[ 2 ].vehicle_getinsoundtag = "rear_door_left_jnt";	
		positions[ 3 ].vehicle_getinsoundtag = "rear_door_right_jnt";

		return positions;               
}                                       
                                        
                                        
                                        
#using_animtree( "generic_human" );     
                                        
setanims()                              
{                                       
                                        
	positions = [];                     
	for( i=0;i<6;i++ )                  
		positions[ i ] = spawnstruct(); 
                                        
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";
	positions[ 2 ].sittag = "tag_guy0"; //driver_side_rear
	positions[ 3 ].sittag = "tag_guy1";  //passenger_side_rear
	positions[ 4 ].sittag = "tag_guy2"; //driver_far_rear
	positions[ 5 ].sittag = "tag_guy3";  //passenger_side_far_rear

	positions[ 0 ].idle = %uaz_driver_idle_drive;
	positions[ 1 ].idle = %uaz_passenger_idle_drive;
	positions[ 2 ].idle = %uaz_passenger_idle_drive;
	positions[ 3 ].idle = %uaz_passenger_idle_drive;
	positions[ 4 ].idle = %uaz_passenger_idle_drive;
	positions[ 5 ].idle = %uaz_passenger_idle_drive;
	
//	positions[ 2 ].idle = %uaz_rear_driver_idle;
//	positions[ 3 ].idle = %uaz_passenger2_idle;
//	positions[ 4 ].idle = %uaz_rear_driver_idle;
//	positions[ 5 ].idle = %uaz_passenger2_idle;

//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_driver_idle_drive.XANIM_EXPORT#2 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger_idle_drive.XANIM_EXPORT#2 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger2_idle.XANIM_EXPORT#1 add
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_rear_driver_idle.XANIM_EXPORT#1 add                                        
	
	positions[ 0 ].getout = %uaz_driver_exit_into_run;
	positions[ 1 ].getout = %uaz_passenger_exit_into_run;
//	positions[ 2 ].getout = %uaz_rear_driver_exit_into_run;
//	positions[ 3 ].getout = %uaz_passenger2_exit_into_run;
	positions[ 2 ].getout = %uaz_driver_exit_into_run;
	positions[ 3 ].getout = %uaz_passenger_exit_into_run;

//cod3-un;depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_rear_driver_exit_into_run.XANIM_EXPORT#1 add
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_driver_exit_into_run.XANIM_EXPORT#2 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger2_exit_into_run.XANIM_EXPORT#1 add
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger_exit_into_run.XANIM_EXPORT#2 edit
	
	positions[ 0 ].getin = %uaz_driver_enter_from_huntedrun;
	positions[ 1 ].getin = %uaz_passenger_enter_from_huntedrun;
//	positions[ 2 ].getin = %uaz_rear_driver_enter_from_huntedrun;
//	positions[ 3 ].getin = %uaz_passenger2_enter_from_huntedrun;

//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_driver_enter_from_huntedrun.XANIM_EXPORT#2 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger2_enter_from_huntedrun.XANIM_EXPORT#1 add
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_passenger_enter_from_huntedrun.XANIM_EXPORT#2 edit
//cod3-depot/cod3/cod3/xanim_export/vehicles/uaz/uaz_rear_driver_enter_from_huntedrun.XANIM_EXPORT#1 add


	return positions;

  
} 
  
  
  
  
  
  
  
  
  
  
  