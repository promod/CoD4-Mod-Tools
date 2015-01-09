#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "bm21", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_bm21_mobile" , "vehicle_bm21_mobile_dstry", 2.6 );

	precachemodel("projectile_bm21_missile");

	//	build_deathfx( effect, 								tag, 					sound, 								bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "explosions/small_vehicle_explosion",	"tag_fx_tank",			"explo_metal_rand",					undefined,			undefined,		undefined,		0 );
	build_deathfx( "fire/firelp_med_pm",					"tag_deathfx",			"fire_metal_medium",				undefined,			undefined,		true,			0 );
	build_deathfx( "fire/firelp_med_pm",					"tag_fx_cab",			undefined,							undefined,			undefined,		undefined,		0 );
	build_deathfx( "explosions/grenadeexp_default",			"tag_missile18",		"explo_metal_rand",					undefined,			undefined,		undefined,		0.5 );
	build_deathfx( "explosions/grenadeexp_default",			"tag_fx_tank",			"explo_metal_rand",					undefined,			undefined,		undefined,		0.8 );
	build_deathfx( "explosions/grenadeexp_default",			"tag_missile14",		"explo_metal_rand",					undefined,			undefined,		undefined,		1.0 );
	build_deathfx( "explosions/grenadeexp_default",			"tag_flash",			"explo_metal_rand",					undefined,			undefined,		undefined,		1.4 );
	
	build_deathfx( "explosions/vehicle_explosion_bm21",		undefined,				"car_explode",						undefined,			undefined,		undefined,		2.6 );
	build_deathfx( "explosions/vehicle_explosion_bm21_tires", "tag_deathfx",		undefined,							undefined,			undefined,		undefined,		2.6 );
	build_deathfx( "fire/firelp_med_pm",					"tag_fx_tire_right_r",	undefined,							undefined,			undefined,		undefined,		2.7 );

	
	build_life( 999, 500, 1500 );
	
	build_team( "allies" );
	build_drive( %bm21_driving_idle_forward, %bm21_driving_idle_backward, 10 );

	
	build_light( model, "headlight_bm21_left", 			"tag_headlight_left", 		"misc/car_headlight_bm21", 		"headlights" );
	build_light( model, "headlight_bm21_right", 		"tag_headlight_right", 		"misc/car_headlight_bm21", 		"headlights" );
	build_light( model, "parkinglight_bm21_left_f",		"tag_parkinglight_left_f", 	"misc/car_parkinglight_bm21", 	"headlights" );
	build_light( model, "parkinglight_bm21_right_f", 	"tag_parkinglight_right_f", "misc/car_parkinglight_bm21",	"headlights" );
	build_light( model, "taillight_bm21_right",	 		"tag_taillight_right", 		"misc/car_taillight_bm21", 		"headlights" );
	build_light( model, "taillight_bm21_left",		 	"tag_taillight_left", 		"misc/car_taillight_bm21", 		"headlights" );

	build_light( model, "breaklight_bm21_right", 		"tag_taillight_right", 		"misc/car_brakelight_bm21", 	"brakelights" );
	build_light( model, "breaklight_bm21_left", 		"tag_taillight_left", 		"misc/car_brakelight_bm21", 	"brakelights" );

}

init_local()
{
	
//	maps\_vehicle::lights_on( "headlights" );
//	maps\_vehicle::lights_on( "brakelights" );

	self.missileModel = "projectile_bm21_missile";
	self.missileTags = [];
	self.missileTags[ 0 ] = "tag_missile1";
	self.missileTags[ 1 ] = "tag_missile2";
	self.missileTags[ 2 ] = "tag_missile3";
	self.missileTags[ 3 ] = "tag_missile4";
	self.missileTags[ 4 ] = "tag_missile5";
	self.missileTags[ 5 ] = "tag_missile6";
	self.missileTags[ 6 ] = "tag_missile7";
	self.missileTags[ 7 ] = "tag_missile8";
	self.missileTags[ 8 ] = "tag_missile9";
	self.missileTags[ 9 ] = "tag_missile10";
	self.missileTags[ 10 ] = "tag_missile11";
	self.missileTags[ 11 ] = "tag_missile12";
	self.missileTags[ 12 ] = "tag_missile13";
	self.missileTags[ 13 ] = "tag_missile14";
	self.missileTags[ 14 ] = "tag_missile15";
	self.missileTags[ 15 ] = "tag_missile16";
	self.missileTags[ 16 ] = "tag_missile17";
	self.missileTags[ 17 ] = "tag_missile18";
	self.missileTags[ 18 ] = "tag_missile19";
	self.missileTags[ 19 ] = "tag_missile20";
	self.missileTags[ 20 ] = "tag_missile21";
	self.missileTags[ 21 ] = "tag_missile22";
	self.missileTags[ 22 ] = "tag_missile23";
	self.missileTags[ 23 ] = "tag_missile24";
	self.missileTags[ 24 ] = "tag_missile25";
	self.missileTags[ 25 ] = "tag_missile26";
//	self.missileTags[ 26 ] = "tag_missile27";
//	self.missileTags[ 27 ] = "tag_missile28";
//	self.missileTags[ 28 ] = "tag_missile29";
//	self.missileTags[ 29 ] = "tag_missile30";
//	self.missileTags[ 30 ] = "tag_missile31";
//	self.missileTags[ 31 ] = "tag_missile32";
//	self.missileTags[ 32 ] = "tag_missile33";
//	self.missileTags[ 33 ] = "tag_missile34";
//	self.missileTags[ 34 ] = "tag_missile35";
//	self.missileTags[ 35 ] = "tag_missile36";
	
	thread maps\_vehicle_missile::main();
}

