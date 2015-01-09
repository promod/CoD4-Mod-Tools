//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_exp_halfplane", "2261.76");
	setdvar("scr_fog_nearplane", "0");
	setdvar("scr_fog_red", "0.621145");
	setdvar("scr_fog_green", "0.552245");
	setdvar("scr_fog_blue", "0.431437");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 350;
	level.dofDefault["farStart"] = 8000;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 4.8;
	level.dofDefault["farBlur"] = 0;
	getent("player","classname") maps\_art::setdefaultdepthoffield();
	setdvar("visionstore_glowTweakEnable", "1");
	setdvar("visionstore_glowTweakRadius0", "19.8627");
	setdvar("visionstore_glowTweakRadius1", "0");
	setdvar("visionstore_glowTweakBloomCutoff", "0.851585");
	setdvar("visionstore_glowTweakBloomDesaturation", "0");
	setdvar("visionstore_glowTweakBloomIntensity0", "0.240968");
	setdvar("visionstore_glowTweakBloomIntensity1", "0");
	setdvar("visionstore_glowTweakSkyBleedIntensity0", "0");
	setdvar("visionstore_glowTweakSkyBleedIntensity1", "0");
	setdvar("visionstore_filmTweakEnable", "1");
	setdvar("visionstore_filmTweakContrast", "1.58");
	setdvar("visionstore_filmTweakBrightness", "-0.0268923");
	setdvar("visionstore_filmTweakDesaturation", "0.447133");
	setdvar("visionstore_filmTweakInvert", "0");
	setdvar("visionstore_filmTweakLightTint", "1.20616 1.05 0.85");
	setdvar("visionstore_filmTweakDarkTint", "1.20074 1.10472 1.05002");

	//

	setExpFog(0, 2261.76, 0.621145, 0.552245, 0.431437, 0);
	maps\_utility::set_vision_set( "aftermath", 0 );

}
