//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "6000");
	setdvar("scr_fog_nearplane", "800");
	setdvar("scr_fog_red", "0.583");
	setdvar("scr_fog_green", "0.631569");
	setdvar("scr_fog_blue", "0.553078");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 8000;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 0;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	setdvar("visionstore_glowTweakEnable", "0");
	setdvar("visionstore_glowTweakRadius0", "5");
	setdvar("visionstore_glowTweakRadius1", "12");
	setdvar("visionstore_glowTweakBloomCutoff", "0.9");
	setdvar("visionstore_glowTweakBloomDesaturation", "0.75");
	setdvar("visionstore_glowTweakBloomIntensity0", "1");
	setdvar("visionstore_glowTweakBloomIntensity1", "1");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0.5");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0");
	setdvar("visionstore_filmTweakEnable", "1");
	setdvar("visionstore_filmTweakContrast", "1.893");
	setdvar("visionstore_filmTweakBrightness", "0.2455");
	setdvar("visionstore_filmTweakDesaturation", "0.265");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1.179 1.086 1.024");
	setdvar("visionstore_filmTweakDarkTint", "0.7 0.959 1.265");

	//

	setExpFog(800, 6000, 0.583, 0.631569, 0.553078, 0);
	maps\_utility::set_vision_set( "armada", 0 );

}
