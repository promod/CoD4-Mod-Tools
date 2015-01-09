//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "5500");
	setdvar("scr_fog_nearplane", "2000");
	setdvar("scr_fog_red", "0.462618");
	setdvar("scr_fog_green", "0.478346");
	setdvar("scr_fog_blue", "0.455313");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 8000;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 5;
	level.dofDefault["farBlur"] = 0;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "8");
	setdvar("visionstore_glowTweakRadius1", "");
	setdvar("visionstore_glowTweakBloomCutoff", "0.92");
	setdvar("visionstore_glowTweakBloomDesaturation", "0.75");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "");
	setdvar("visionstore_filmTweakEnable", "1");
	setdvar("visionstore_filmTweakContrast", "1.3");
	setdvar("visionstore_filmTweakBrightness", "0.19");
	setdvar("visionstore_filmTweakDesaturation", "0.2");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1 1 1");
	setdvar("visionstore_filmTweakDarkTint", "1 1 1");

	//

	setExpFog(2000, 5500, .462618, .478346, .455313, 0);
	maps\_utility::set_vision_set( "ambush", 0 );

}
