#include maps\_utility;
main()
{
	//Crew standby, do not engage, do not engage, just monitor. Do not engage the moving targets.
	level.scr_sound["fco"]["ac130_fco_donotengage"] 			= "ac130_fco_donotengage";
	
	//Wildfire, we are moving up the road towards a town to the east. Confirm you have a visual on us.
	level.scr_sound["price"]["ac130_pri_towntoeast"] 		= "ac130_pri_towntoeast";
	
	//Got eyes on friendlies!
	level.scr_sound["tvo"]["ac130_tvo_eyesonfriendlies"]	= "ac130_tvo_eyesonfriendlies";
	
	//Crew, do not fire on any target marked by a strobe, those are friendlies.
	level.scr_sound["fco"]["ac130_fco_nofirestrobe"] 		= "ac130_fco_nofirestrobe";
	
	//-------------------------------------------------------------------------------------------------
	
	//Uh, TV, confirm you see the church in the town.
	level.scr_sound["nav"]["ac130_nav_confirmchurch"] 		= "ac130_nav_confirmchurch";
	
	//We see it, start the clock.
	level.scr_sound["tvo"]["ac130_tvo_weseeit"] 			= "ac130_tvo_weseeit";
	
	//Roger that we're there, start talking.
	level.scr_sound["fco"]["ac130_fco_rogerwerethere"] 		= "ac130_fco_rogerwerethere";
	
	//You are not authorized to level the church. Do not fire directly on the church.
	level.scr_sound["nav"]["ac130_nav_notauthorizedchurch"] = "ac130_nav_notauthorizedchurch";
	
	//-------------------------------------------------------------------------------------------------
	
	//Got a vehicle moving now!
	level.scr_sound["tvo"]["ac130_tvo_vehiclemovingnow"] 	= "ac130_tvo_vehiclemovingnow";
	
	//One of the vehicles is moving right now.
	level.scr_sound["fco"]["ac130_fco_onevehiclemoving"] 	= "ac130_fco_onevehiclemoving";
	
	//Personnel coming out of the church.
	level.scr_sound["tvo"]["ac130_tvo_personnelchurch"] 	= "ac130_tvo_personnelchurch";
	
	//We have armed personnel approaching from the church, request permission to engage.
	level.scr_sound["fco"]["ac130_fco_armedpersonnelchurch"]= "ac130_fco_armedpersonnelchurch";
	
	//Copy. You are cleared to engage the moving vehicle, and any personnel around you see.
	level.scr_sound["pilot"]["ac130_plt_cleartoengage"]		= "ac130_plt_cleartoengage";
	
	//Affirmative. Crew you are cleared to engage but do not fire on the church.
	level.scr_sound["fco"]["ac130_fco_cleartoengage"] 		= "ac130_fco_cleartoengage";
	
	//-------------------------------------------------------------------------------------------------
	
	//Wildfire, this is Bravo Six, be advised, we're passing a large church and continuing towards the main highway! Keep up the fire! Bravo Six out!
	level.scr_sound["pri"]["ac130_pri_passingchurch"] 		= "ac130_pri_passingchurch";
	
	//Roger that. Engage anything without a flashing strobe light. Those are all hostiles.
	level.scr_sound["plt"]["ac130_plt_woutstrobe"] 			= "ac130_plt_woutstrobe";
	
	//We're banking towards the village. Stand by to engage ground targets.
	level.scr_sound["plt"]["ac130_plt_bankingtovillage"] 	= "ac130_plt_bankingtovillage";
	
	// Targets in the village are confirmed as hostile. Cleared to engage. Smoke 'em.
	level.scr_sound["plt"]["ac130_plt_smokem"] 				= "ac130_plt_smokem";
	
	//-------------------------------------------------------------------------------------------------
	
	// We got a moving vehicle here.
	level.scr_sound["fco"]["ac130_fco_movingvehicle"] 		= "ac130_fco_movingvehicle";
	
	// Negative negative. Do not engage, I repeat do not engage any vehicles on the main highway.
	level.scr_sound["fco"]["ac130_fco_donoengage"] 			= "ac130_fco_donoengage";
	
	//Crew, do not engage any vehicles traveling on the highway, those are civilians.
	level.scr_sound["fco"]["ac130_fco_civilianvehicles"] 	= "ac130_fco_civilianvehicles";
	
	//Ground units are acquiring alternate transport at this time. Do not engage any vehicles on the highway unless cleared to do so.
	level.scr_sound["fco"]["ac130_fco_alttransport"] 		= "ac130_fco_alttransport";
	
	//I bet that guy’s pissed! That’s a nice truck!
	level.scr_sound["tvo"]["ac130_tvo_nicetruck"] 			= "ac130_tvo_nicetruck";
	
	//Nah, hehe, he’s scared shitless.
	level.scr_sound["fco"]["ac130_fco_nahscared"] 			= "ac130_fco_nahscared";
	
	//Wildfire, we’re marking the vehicles! Confirm you see the beacons!
	level.scr_sound["pri"]["ac130_pri_confirmyousee"] 		= "ac130_pri_confirmyousee";
	
	//Roger, we see the beacons. Crew, do not fire on the vehicles marked with the flashing beacons. I repeat, do NOT fire on the vehicles with the flashing beacons, those are friendlies.
	level.scr_sound["fco"]["ac130_fco_seebeacons"] 			= "ac130_fco_seebeacons";
	
	//Wildfire, we're going to commandeer civilian transports on the main highway. Cover us!
	level.scr_sound["pri"]["ac130_pri_coverus"] 			= "ac130_pri_coverus";
	
	//-------------------------------------------------------------------------------------------------
	
	//Heads up. Hostile forces are setting up ambush points along the curved road.
	level.scr_sound["nav"]["ac130_nav_ambushroad"] 			= "ac130_nav_ambushroad";
	
	//Uh, navigation, which one's the curved road over?
	level.scr_sound["fco"]["ac130_fco_whichcurved"] 		= "ac130_fco_whichcurved";
	
	//Fire control, do you see the water tower, over?
	level.scr_sound["nav"]["ac130_nav_seewatertower"] 		= "ac130_nav_seewatertower";
	
	//TV, confirm you see the water tower.
	level.scr_sound["fco"]["ac130_fco_confirmyousee"] 		= "ac130_fco_confirmyousee";
	
	//Are you talking about the uh, water tower near the intersection?
	level.scr_sound["tvo"]["ac130_tvo_nearintersection"] 	= "ac130_tvo_nearintersection";
	
	//Roger, that's the one.
	level.scr_sound["nav"]["ac130_nav_thatstheone"] 		= "ac130_nav_thatstheone";
	
	//And next to that water tower is a curved road, do you see that?
	level.scr_sound["nav"]["ac130_nav_doyouseethat"] 		= "ac130_nav_doyouseethat";
	
	//Roger that.
	level.scr_sound["fco"]["ac130_fco_rogerthat"] 			= "ac130_fco_rogerthat";
	
	//Track that road into the next village. You should be able to see another water tower in the village further down that road.
	level.scr_sound["nav"]["ac130_nav_trackthatroad"] 		= "ac130_nav_trackthatroad";
	
	//Uh, we're having a bit of trouble acquiring the village. How far up the road is it?
	level.scr_sound["fco"]["ac130_fco_howfar"] 				= "ac130_fco_howfar";
	
	//Approximately…uh, hang on…
	level.scr_sound["nav"]["ac130_nav_uhhangon"] 			= "ac130_nav_uhhangon";
	
	//It's about 2 klicks metres along the curved road, going away from the highway.
	level.scr_sound["nav"]["ac130_nav_600meters"] 			= "ac130_nav_2klicks";
	
	//Roger that.
	level.scr_sound["tvo"]["ac130_tvo_rogerthat"] 			= "ac130_tvo_rogerthat";
	
	//We got hostiles setting up along the curved road.
	level.scr_sound["tvo"]["ac130_tvo_hostilescurved"] 		= "ac130_tvo_hostilescurved";
	
	//Hostiles preparing to ambush along the curved road.  They're partially concealed by the trees.
	level.scr_sound["fco"]["ac130_fco_partiallyconcealed"] 	= "ac130_fco_partiallyconcealed";
	
	//Request permission to engage targets in the village.
	level.scr_sound["fco"]["ac130_fco_requestpermission"] 	= "ac130_fco_requestpermission";
	
	//Roger that. Crew, go ahead and take out everything in that village.
	level.scr_sound["fco"]["ac130_fco_takeout"] 			= "ac130_fco_takeout";
	
	//Got an armored vehicle moving out of the barn!
	level.scr_sound["tvo"]["ac130_tvo_armoredvehicle"] 		= "ac130_tvo_armoredvehicle";
	
	//Uh, we got small groups taking up positions along the edge of the curved road. Cleared to engage those as well?
	level.scr_sound["fco"]["ac130_fco_smallgroups"] 		= "ac130_fco_smallgroups";
	
	//Whoa, someone just fired an RPG!
	level.scr_sound["tvo"]["ac130_tvo_firedrpg"] 			= "ac130_tvo_firedrpg";
	
	//Wildfire, we're under attack. We could use some help here.
	level.scr_sound["pri"]["ac130_pri_underattack"] 		= "ac130_pri_underattack";
	
	//Crew, track those smoke trails and take 'em out at the source. Clear a path for our guys.
	level.scr_sound["fco"]["ac130_fco_smoketrails"] 		= "ac130_fco_smoketrails";
	
	//Personnel on the roof of that U-shaped building.
	level.scr_sound["tvo"]["ac130_tvo_ushaped"] 			= "ac130_tvo_ushaped";
	
	//Uh, U-shaped building?
	level.scr_sound["fco"]["ac130_fco_ushaped"] 			= "ac130_fco_ushaped";
	
	//Roger, it's the one with the square structure on the roof. It's the one with a flat roof.
	level.scr_sound["tvo"]["ac130_tvo_flatroof"] 			= "ac130_tvo_flatroof";
	
	//Armored vehicle right there! Right there, coming out of the barn.
	level.scr_sound["fco"]["ac130_fco_outofbarn"] 			= "ac130_fco_outofbarn";
	
	//-------------------------------------------------------------------------------------------------
	
	//Wildfie, we're approaching the LZ at the junkyard and leaving the vehicles.
	level.scr_sound["pri"]["ac130_pri_junkyard"] 			= "ac130_pri_junkyard";
	
	//Roger that Bravo Six. Crew, friendlies are leaving the vehicles and moving on foot towards the LZ. Do not fire on any personnel marked by a flashing strobe.
	level.scr_sound["fco"]["ac130_fco_flashingstrobe"] 		= "ac130_fco_flashingstrobe";
	
	// Affirmative. Keep watching for those strobe lights. Those are friendlies.
	level.scr_sound["fco"]["ac130_fco_watchstrobe"] 		= "ac130_fco_watchstrobe";
	
	//Enemy personnel in the junkyard. 
	level.scr_sound["tvo"]["ac130_tvo_enemyjunkyard"] 		= "ac130_tvo_enemyjunkyard";
	
	//Crew, go ahead and smoke ‘em.
	level.scr_sound["fco"]["ac130_fco_smokeem"] 			= "ac130_fco_smokeem";

	//Man these guys are goin' to town!
	level.scr_sound["fco"]["ac130_fco_gointotown"] 			= "ac130_fco_gointotown";
	
	//-------------------------------------------------------------------------------------------------
	
	//Wildfire, we've reached the LZ, but we're taking fire from all sides!! Request fire support on all sides of the LZ, danger close!!!
	level.scr_sound["pri"]["ac130_pri_fireallsides"] 		= "ac130_pri_fireallsides";

	//Enemy personnel closing on the LZ from multiple sides. Danger close. Recommend you stick to the 25 millimeter in the vicinity of the LZ. 
	level.scr_sound["nav"]["ac130_nav_dangerclose"] 		= "ac130_nav_dangerclose";
	
	//Crew, be advised, friendly helicopters entering the area. Watch your fire.
	level.scr_sound["fco"]["ac130_fco_friendliesentering"] 	= "ac130_fco_friendliesentering";

	//Copy.
	level.scr_sound["tvo"]["ac130_tvo_copy"] 				= "ac130_tvo_copy";
	
	//Wildfire, we've moving towards the helicopters now. Thanks for the assist. Bravo Six out.
	level.scr_sound["pri"]["ac130_pri_thanksforassist"] 	= "ac130_pri_thanksforassist";
	
	//Hehe, this is gonna be one helluva highlight reel.
	level.scr_sound["fco"]["ac130_fco_highlightreel"] 		= "ac130_fco_highlightreel";
	
	//I heard that!
	level.scr_sound["tvo"]["ac130_tvo_heardthat"] 			= "ac130_tvo_heardthat";
	
	//Crew, VIP is secure and in custody. Good job everyone.
	level.scr_sound["nav"]["ac130_nav_vipsecure"] 			= "ac130_nav_vipsecure";
	
	// Roger that. Returning to base.
	level.scr_sound["plt"]["ac130_plt_returningbase"] 		= "ac130_plt_returningbase";
	
	//-------------------------------------------------------------------------------------------------
	
	// 1 ) Check your fire, you're shootin' at friendlies - watch for the blinking strobes those are our guys!
	// 2 ) Uh, you're firing too close to the friendlies, I repeat, you're firing too close to the friendlies. Watch for those IR strobes.
	// 3 ) Be careful! You almost killed our guys there!
	level.scr_sound["fco"]["ac130_fco_firingtoclose"] 		= "ac130_fco_firingtoclose";
	
	//-------------------------------------------------------------------------------------------------
	
	//CONTEXT SENSATIVE DIALOG
	//-------------------------------------------------------------------------------------------------
	
	add_context_sensative_dialog( "ai", "in_sight", 0, "ac130_fco_moreenemy" );			// More enemy personnel.
	add_context_sensative_dialog( "ai", "in_sight", 1, "ac130_fco_getthatguy" );		// Get that guy.
	add_context_sensative_dialog( "ai", "in_sight", 2, "ac130_fco_guymovin" );			// Roger, guy movin'.
	add_context_sensative_dialog( "ai", "in_sight", 3, "ac130_fco_getperson" );			// Get that person.
	add_context_sensative_dialog( "ai", "in_sight", 4, "ac130_fco_guyrunnin" );			// Guy runnin'.
	add_context_sensative_dialog( "ai", "in_sight", 5, "ac130_fco_gotarunner" );		// Uh, we got a runner here.
	add_context_sensative_dialog( "ai", "in_sight", 6, "ac130_fco_backonthose" );		// Get back on those guys.
	add_context_sensative_dialog( "ai", "in_sight", 7, "ac130_fco_gonnagethim" );		// You gonna get him?
	add_context_sensative_dialog( "ai", "in_sight", 8, "ac130_fco_personnelthere" );	// Personnel right there.
	add_context_sensative_dialog( "ai", "in_sight", 9, "ac130_fco_nailthoseguys" );		// Nail those guys.
	add_context_sensative_dialog( "ai", "in_sight", 10, "ac130_fco_clearedtoengage" );	// Cleared to engage enemy personnel.
	add_context_sensative_dialog( "ai", "in_sight", 11, "ac130_fco_lightemup" );		// Light ‘em up.
	add_context_sensative_dialog( "ai", "in_sight", 12, "ac130_fco_takehimout" );		// Yeah take him out.
	add_context_sensative_dialog( "ai", "in_sight", 13, "ac130_plt_clearedtoengage" );	// Cleared to engage all of those.
	add_context_sensative_dialog( "ai", "in_sight", 14, "ac130_plt_yeahcleared" );		// Yeah, cleared to engage.
	add_context_sensative_dialog( "ai", "in_sight", 15, "ac130_plt_copysmoke" );		// Copy, smoke ‘em.
	add_context_sensative_dialog( "ai", "in_sight", 16, "ac130_fco_rightthere" );		// Right there...tracking.
	add_context_sensative_dialog( "ai", "in_sight", 17, "ac130_fco_tracking" );			// Tracking.
	
	add_context_sensative_dialog( "ai", "wounded_crawl", 0, "ac130_fco_movingagain" );		// Ok he’s moving again.
	add_context_sensative_timeout( "ai", "wounded_crawl", undefined, 6 );
	
	add_context_sensative_dialog( "ai", "wounded_pain", 0, "ac130_fco_doveonground" );		// Yeah, he just dove on the ground.	
	add_context_sensative_dialog( "ai", "wounded_pain", 1, "ac130_fco_knockedwind" );		// Probably just knocked the wind out of him.
	add_context_sensative_dialog( "ai", "wounded_pain", 2, "ac130_fco_downstillmoving" );	// That guy's down but still moving.
	add_context_sensative_dialog( "ai", "wounded_pain", 3, "ac130_fco_gettinbackup" );		// He's gettin' back up.
	add_context_sensative_dialog( "ai", "wounded_pain", 4, "ac130_fco_yepstillmoving" );	// Yep, that guy’s still moving.
	add_context_sensative_dialog( "ai", "wounded_pain", 5, "ac130_fco_stillmoving" );		// He's still moving.
	add_context_sensative_timeout( "ai", "wounded_pain", undefined, 12 );
	
	add_context_sensative_dialog( "weapons", "105mm_ready", 0, "ac130_gnr_gunready1" );
	
	add_context_sensative_dialog( "weapons", "105mm_fired", 0, "ac130_gnr_shot1" );
	
	add_context_sensative_dialog( "plane", "rolling_in", 0, "ac130_plt_rollinin" );
	
	add_context_sensative_dialog( "explosion", "secondary", 0, "ac130_nav_secondaries1" );
	add_context_sensative_dialog( "explosion", "secondary", 1, "ac130_tvo_directsecondary1" );
	add_context_sensative_dialog( "explosion", "secondary", 1, "ac130_tvo_directsecondary2" );
	add_context_sensative_timeout( "explosion", "secondary", undefined, 7 );
	
	add_context_sensative_dialog( "kill", "single", 0, "ac130_plt_gottahurt" );			// Ooo that's gotta hurt.
	add_context_sensative_dialog( "kill", "single", 1, "ac130_fco_iseepieces" );		// Yeah, good kill. I see lots of little pieces down there.
	add_context_sensative_dialog( "kill", "single", 2, "ac130_fco_oopsiedaisy" );		// (chuckling) Oopsie-daisy.
	add_context_sensative_dialog( "kill", "single", 3, "ac130_fco_goodkill" );			// Good kill good kill.
	add_context_sensative_dialog( "kill", "single", 4, "ac130_fco_yougothim" );			// You got him.
	add_context_sensative_dialog( "kill", "single", 5, "ac130_fco_yougothim2" );		// You got him!
	add_context_sensative_dialog( "kill", "single", 6, "ac130_fco_thatsahit" );			// That's a hit.
	add_context_sensative_dialog( "kill", "single", 7, "ac130_fco_directhit" );			// Direct hit.
	add_context_sensative_dialog( "kill", "single", 8, "ac130_fco_rightontarget" );		// Yep, that was right on target.
	add_context_sensative_dialog( "kill", "single", 9, "ac130_fco_okyougothim" );		// Ok, you got him. Get back on the other guys.
	add_context_sensative_dialog( "kill", "single", 10, "ac130_fco_within2feet" );		// All right you got the guy. That might have been within two feet of him.
	
	add_context_sensative_dialog( "kill", "small_group", 0, "ac130_fco_nice" );			// (chuckling) Niiiice.
	add_context_sensative_dialog( "kill", "small_group", 1, "ac130_fco_directhits" );	// Yeah, direct hits right there.
	add_context_sensative_dialog( "kill", "small_group", 2, "ac130_fco_iseepieces" );	// Yeah, good kill. I see lots of little pieces down there.
	add_context_sensative_dialog( "kill", "small_group", 3, "ac130_fco_goodkill" );		// Good kill good kill.
	add_context_sensative_dialog( "kill", "small_group", 4, "ac130_fco_yougothim" );	// You got him.
	add_context_sensative_dialog( "kill", "small_group", 5, "ac130_fco_yougothim2" );	// You got him!
	add_context_sensative_dialog( "kill", "small_group", 6, "ac130_fco_thatsahit" );	// That's a hit.
	add_context_sensative_dialog( "kill", "small_group", 7, "ac130_fco_directhit" );	// Direct hit.
	add_context_sensative_dialog( "kill", "small_group", 8, "ac130_fco_rightontarget" );// Yep, that was right on target.
	add_context_sensative_dialog( "kill", "small_group", 9, "ac130_fco_okyougothim" );	// Ok, you got him. Get back on the other guys.
	
	add_context_sensative_dialog( "kill", "large_group", 0, "ac130_fco_hotdamn1" );		// Hot damn!
	add_context_sensative_dialog( "kill", "large_group", 0, "ac130_fco_hotdamn2" );		// Hot damn!
	add_context_sensative_dialog( "kill", "large_group", 0, "ac130_fco_hotdamn3" );		// Hot damn!
	add_context_sensative_dialog( "kill", "large_group", 1, "ac130_tvo_whoa1" );		// Whoa!!!
	add_context_sensative_dialog( "kill", "large_group", 1, "ac130_tvo_whoa2" );		// Whoa!!!
	add_context_sensative_dialog( "kill", "large_group", 1, "ac130_tvo_whoa3" );		// Whoa!!!
	add_context_sensative_dialog( "kill", "large_group", 2, "ac130_fco_kaboom" );		// Ka-boom.
	
	add_context_sensative_dialog( "location", "car", 0, "ac130_fco_guybycar" );			//There’s a guy by that car.
	add_context_sensative_timeout( "location", "car", undefined, 40 );
	
	add_context_sensative_dialog( "location", "truck", 0, "ac130_fco_guybytruck" );		// There’s one by that truck.
	add_context_sensative_timeout( "location", "truck", undefined, 12 );
	
	add_context_sensative_dialog( "location", "building", 0, "ac130_fco_nailbybuilding1" );
	add_context_sensative_timeout( "location", "building", undefined, 20 );
	
	add_context_sensative_dialog( "location", "wall", 0, "ac130_tvo_coverbywall1" );
	add_context_sensative_timeout( "location", "wall", undefined, 20 );
	
	add_context_sensative_dialog( "location", "field", 0, "ac130_fco_crossingfield" );	// Enemies crossing the field.
	add_context_sensative_timeout( "location", "field", undefined, 20 );
	
	add_context_sensative_dialog( "location", "road", 0, "ac130_fco_enemyonroad" );		// Enemy personnel on the road.
	add_context_sensative_timeout( "location", "road", undefined, 20 );
	
	add_context_sensative_dialog( "location", "church", 0, "ac130_fco_outofchurch" );	// There's armed personnel running out of the church.
	add_context_sensative_timeout( "location", "church", undefined, 20 );
	
	add_context_sensative_dialog( "location", "ditch", 0, "ac130_fco_headinforditch" );	// Yeah, he’s headin’ for the ditch.
	add_context_sensative_timeout( "location", "ditch", undefined, 20 );
	
	add_context_sensative_dialog( "vehicle", "incoming", 0, "ac130_fco_movingvehicle" );	// We got a moving vehicle here.
	add_context_sensative_dialog( "vehicle", "incoming", 1, "ac130_fco_vehicleonmove" );	// We got a vehicle on the move.
	add_context_sensative_dialog( "vehicle", "incoming", 2, "ac130_plt_engvehicle" );		// You are cleared to engage the moving vehicle.
	add_context_sensative_dialog( "vehicle", "incoming", 3, "ac130_fco_getvehicle" );		// Crew, get the moving vehicle.
	
	add_context_sensative_dialog( "vehicle", "death", 0, "ac130_fco_confirmed" );	// Confirmed, vehicle neutralized.
	add_context_sensative_dialog( "vehicle", "death", 1, "ac130_fco_fulltank" );	// (chuckling) Shit, must've been a full tank of gas.
	
	add_context_sensative_dialog( "misc", "action", 0, "ac130_plt_scanrange" );		// Set scan range.
	add_context_sensative_timeout( "misc", "action", 0, 70 );
	
	add_context_sensative_dialog( "misc", "action", 1, "ac130_plt_cleanup" );		// Clean up that signal.
	add_context_sensative_timeout( "misc", "action", 1, 80 );
	
	add_context_sensative_dialog( "misc", "action", 2, "ac130_plt_targetreset" );	// Target reset.
	add_context_sensative_timeout( "misc", "action", 2, 55 );
	
	add_context_sensative_dialog( "misc", "action", 3, "ac130_plt_azimuthsweep" );	// Recalibrate azimuth sweep angle. Adjust elevation scan.
	add_context_sensative_timeout( "misc", "action", 3, 100 );
}

add_context_sensative_dialog( name1, name2, group, soundAlias )
{
	assert( isdefined( name1 ) );
	assert( isdefined( name2 ) );
	assert( isdefined( group ) );
	assert( isdefined( soundAlias ) );
	assert( soundexists( soundAlias ) == true );
	
	if( ( !isdefined( level.scr_sound[ name1 ] ) ) || ( !isdefined( level.scr_sound[ name1 ][ name2 ] ) ) || ( !isdefined( level.scr_sound[ name1 ][ name2 ][group] ) ) )
	{
		// creating group for the first time
		level.scr_sound[ name1 ][ name2 ][group] = spawnStruct();
		level.scr_sound[ name1 ][ name2 ][group].played = false;
		level.scr_sound[ name1 ][ name2 ][group].sounds = [];
	}
	
	//group exists, add the sound to the array
	index = level.scr_sound[ name1 ][ name2 ][group].sounds.size;
	level.scr_sound[ name1 ][ name2 ][group].sounds[index] = soundAlias;
}

add_context_sensative_timeout( name1, name2, groupNum, timeoutDuration )
{
	if( !isdefined( level.context_sensative_dialog_timeouts ) )
		level.context_sensative_dialog_timeouts = [];
	
	createStruct = false;
	if ( !isdefined( level.context_sensative_dialog_timeouts[ name1 ] ) )
		createStruct = true;
	else if ( !isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ] ) )
		createStruct = true;
	if ( createStruct )
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ] = spawnStruct();
	
	if ( isdefined( groupNum ) )
	{
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups = [];
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ] = spawnStruct();
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["timeoutDuration"] = timeoutDuration * 1000;
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v["lastPlayed"] = ( timeoutDuration * -1000 );
	}
	else
	{
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["timeoutDuration"] = timeoutDuration * 1000;
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v["lastPlayed"] = ( timeoutDuration * -1000 );
	}
}