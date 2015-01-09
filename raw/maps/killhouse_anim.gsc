#include maps\_anim;
#using_animtree("generic_human");

anim_main()
{
	level dialog();	
	
	level.scr_anim[ "generic" ][ "jog" ]			= %combat_jog;
	level.scr_anim[ "generic" ][ "walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_stop" ]    = %patrol_bored_walk_2_bored;
	
	level.scr_anim[ "price" ][ "reveal" ]			= %killhouse_sas_price;
	addNotetrack_dialogue( "price", "dialog" ,"reveal", "killhouse_pri_muppet" );
	addNotetrack_dialogue( "price", "dialog2" ,"reveal", "killhouse_pri_cqbtest" );
	addNotetrack_dialogue( "price", "dialog3" ,"reveal", "killhouse_pri_runsolo" );
	addNotetrack_dialogue( "price", "dialog4" ,"reveal", "killhouse_pri_record19sec" );
	//addNotetrack_dialogue( "price", "dialog5" ,"reveal", "killhouse_pri_ladderthere" );
	addNotetrack_customFunction( "price", "dialog5", maps\killhouse::reveal_dialog_ladder, "reveal" );
	
	level.scr_anim[ "price" ][ "reveal_idle" ][0]	= %killhouse_sas_price_idle;
	level.scr_anim[ "sas1" ][ "reveal" ]			= %killhouse_sas_1;
	addNotetrack_dialogue( "sas1", "dialog" ,"reveal", "killhouse_sas4_fng" );
	addNotetrack_dialogue( "sas1", "dialog" ,"reveal", "killhouse_sas4_goeasy" );
	
	
	level.scr_anim[ "sas1" ][ "reveal_idle" ][0]	= %killhouse_sas_1_idle;
	level.scr_anim[ "sas2" ][ "reveal" ]			= %killhouse_sas_2;
	level.scr_anim[ "sas2" ][ "reveal_idle" ][0]	= %killhouse_sas_2_idle;
	//addNotetrack_dialogue( "sas2", "dialog" ,"reveal", "killhouse_sas2_fingy" );
	//addNotetrack_dialogue( "sas2", "dialog" ,"reveal", "killhouse_sas4_goeasy" );
	
	
	level.scr_anim[ "sas3" ][ "reveal" ]			= %killhouse_sas_3;
	level.scr_anim[ "sas3" ][ "reveal_idle" ][0]	= %killhouse_sas_3_idle;

	
	level.scr_anim[ "generic" ][ "chair_idles" ][0]		= %killhouse_laptop_idle;
	level.scr_anim[ "generic" ][ "chair_idles" ][1]		= %killhouse_laptop_twitch;
	level.scr_anim[ "generic" ][ "chair_idles" ][2] 	= %killhouse_laptop_lookup;
	
	level.scr_anim[ "gaz" ][ "killhouse_gaz_talk_side" ]	= %killhouse_gaz_talk_side;
	level.scr_anim[ "gaz" ][ "killhouse_gaz_point_side" ]	= %killhouse_gaz_point_side;
	level.scr_anim[ "gaz" ][ "killhouse_gaz_idleB" ][0]		= %killhouse_gaz_idleB;
	level.scr_anim[ "gaz" ][ "killhouse_gaz_idleA" ]		= %killhouse_gaz_idleA;
	level.scr_anim[ "generic" ][ "killhouse_gaz_idle_arrive" ]	= %killhouse_gaz_idleB;
	
	
	

	level.scr_anim[ "gaz" ][ "intro" ]    = %killhouse_gaz_intro;
	//addNotetrack_dialogue( animname, notetrack, anime, soundalias )
	addNotetrack_dialogue( "gaz", "dialog", "intro", "killhouse_gaz_goodtosee" );
}

dialog()
{	
	level.scr_sound["gaz"]["wantstosee"] = "killhouse_gaz_wantstosee"; //Captain Price wants to see you.	X
	level.scr_sound["gaz"]["onemoretime"] = "killhouse_gaz_onemoretime";	//Okay mate, one more time while aiming down your sights. X
	level.scr_sound["gaz"]["getarifle"] = "killhouse_gaz_getarifle";	//Good to see you mate. Get a rifle from the armory.	DONT USE
	level.scr_sound["gaz"]["getasidearm"] = "killhouse_gaz_getasidearm";	//Now go get a side arm from the armory.	X
	level.scr_sound["gaz"]["snaponto"] = "killhouse_gaz_snaponto"; //As long as your aiming near the target, you can snap onto them by repeatedly popping in and out of aiming down the sight.	X
	level.scr_sound["gaz"]["evenfaster"] = "killhouse_gaz_evenfaster"; //Using your knife is even faster than switching to your pistol.	X
	level.scr_sound["gaz"]["knifewatermelon"] = "killhouse_gaz_knifewatermelon"; //Knife the watermelon.	X
	level.scr_sound["gaz"]["stopaiming"] = "killhouse_gaz_stopaiming"; //Stop aiming down your sights.	X
	level.scr_sound["gaz"]["seeyoufire"] = "killhouse_gaz_seeyoufire"; //I want to see you fire from the hip.	X


	level.scr_sound["sas2"]["fng"] = "killhouse_sas4_fng"; //It's the F.N.G. sir.	X
	level.scr_sound["sas2"]["goeasy"] = "killhouse_sas4_goeasy"; //Go easy on him sir, it's his first day in the Regiment.	X
	level.scr_sound["price"]["cqbsim"] = "killhouse_pri_cqbsim"; //Like hell I will...all right Soap, it's your turn for the CQB simulation. Everyone else head to observation. Move!	DONT USE
	level.scr_sound["price"]["muppet"] = "killhouse_pri_muppet"; //Riight. What the hell kind of name is Soap? How'd a muppet like you pass Selection, eh?	X

	level.scr_sound["price"]["cbqtest"] = "killhouse_pri_cqbtest";	//****Soap, it's your turn for the CQB test. Everyone else head to observation.
	level.scr_sound["price"]["runsolo"] = "killhouse_pri_runsolo";	//****For this test, you'll have to run the cargoship solo in less than 60 seconds.
	level.scr_sound["price"]["record19sec"] = "killhouse_pri_record19sec";	//****Gaz holds the current squadron record at 19 seconds. Good luck.
	level.scr_sound["price"]["welcome"] = "killhouse_pri_welcome";	//Ah, good to have you on board Soap. Welcome to the Regiment.
	level.scr_sound["price"]["ladderhere"] = "killhouse_pri_ladderhere";	//Climb the ladder over here.
	level.scr_sound["price"]["ladderthere"] = "killhouse_pri_ladderthere";	//Climb the ladder over there.
	
	//"Name: addNotetrack_dialogue( <animname> , <notetrack> , <scene> , <soundalias> )"
	

	level.scr_sound["price"]["wheelsup"] = "killhouse_pri_wheelsup"; //Gentlemen, the cargoship mission is a go. Get yourselves sorted out. Wheels up at 0200. Dismissed.	DONT USE
	level.scr_sound["price"]["sprint"] = "killhouse_pri_sprint"; //Sprint to the finish!	X

	//level.price execDialog( "startover" );	//That was too slow, come back to the ladder and start over. X
	//level.price execDialog( "doitagain" );	//Soap, that was way too slow. Do it again X
	level.scr_sound["price"]["tooslow"] = "killhouse_pri_tooslow"; //Too slow! Get your shite together boy! You think I'm takin' the piss? 	X

	level.scr_sound["price"]["comeback"] = "killhouse_pri_comeback"; //Now come back to the monitors for a debrief.	DONT USE



	level.scr_sound["price"]["youlldo"] = "killhouse_pri_youlldo"; //All right Soap, that's enough. You'll do.	X
	level.scr_sound["price"]["seenbetter2"] = "killhouse_pri_seenbetter"; //I've seen better, but that'll do.	X
	
	level.scr_sound["price"]["sloppy"] = "killhouse_pri_sloppy"; //Fast, but sloppy. You need to work on your accuracy.	X
	level.scr_sound["price"]["tryitagain"] = "killhouse_pri_tryitagain"; //That was an improvement, but it's not hard to improve on garbage. Try it again.	X
	level.scr_sound["price"]["notgreat"] = "killhouse_pri_notgreat"; //That was better. Not great. But better.	X

	level.scr_sound["price"]["lesstime"] = "killhouse_pri_lesstime"; //Don't waste our time Soap. The idea is to take less time, not more.	X
	level.scr_sound["price"]["letyouskip"] = "killhouse_pri_letyouskip"; //You're getting' slower. Perhaps it was a mistake to let you skip the obstacle course.   X
	





	level.scr_sound["gaz"]["illletyouin"] = "killhouse_gaz_illletyouin";	//Soap, this is Gaz. Come to the firing range and I'll let you in.
	level.scr_sound["gaz"]["smalldoor"] = "killhouse_gaz_smalldoor";	//Soap, what's the matter? Come to the small door outside the firing range.
	level.scr_sound["gaz"]["gotallday"] = "killhouse_gaz_gotallday";	//We haven't got all bloody day Soap.
	level.scr_sound["gaz"]["getamoveon"] = "killhouse_gaz_getamoveon";	//Soap... get a move on.
	level.scr_sound["gaz"]["goodtosee"] = "killhouse_gaz_goodtosee";	//Good to see you mate. Take one of the rifles and sidearms from the table.
	level.scr_sound["gaz"]["takearifle"] = "killhouse_gaz_takearifle";	//Take a rifle from the table.
	level.scr_sound["gaz"]["youknowdrill"] = "killhouse_gaz_youknowdrill";	//You know the drill. Go to station one...and aim your rifle downrange.
	level.scr_sound["gaz"]["gotostation1"] = "killhouse_gaz_gotostation1";	//Soap! Go to Station One.
	level.scr_sound["gaz"]["heygo"] = "killhouse_gaz_heygo";	//Hey. Go to Station One.
	level.scr_sound["gaz"]["getback"] = "killhouse_gaz_getback";	//Oi, where are you going? Get back to Station One…
	level.scr_sound["gaz"]["priceevaluation"] = "killhouse_gaz_priceevaluation";	//Captain Price wants an evaluation of everyone's shooting skills, so don't fuck it up mate! You may have passed Selection, but you're still on probation as far as the Regiment's concerned.
	level.scr_sound["gaz"]["rifledownrange"] = "killhouse_gaz_rifledownrange";	//Now aim your rifle down range, Soap.
	level.scr_sound["gaz"]["aimyourrifle"] = "killhouse_gaz_aimyourrifle";	//Aim your rifle.
	level.scr_sound["gaz"]["lovely"] = "killhouse_gaz_lovely";	//Lovely…
	level.scr_sound["gaz"]["shooteachtarget"] = "killhouse_gaz_shooteachtarget";	//Now. Shoot - each - target, while aiming down the sights.
	level.scr_sound["gaz"]["brilliant"] = "killhouse_gaz_brilliant";	//Brilliant. You know Soap, it might help to aim your rifle before firing.
	level.scr_sound["gaz"]["firingfromhip"] = "killhouse_gaz_firingfromhip";	//Now, shoot at the targets while firing from the hip.
	level.scr_sound["gaz"]["changessize"] = "killhouse_gaz_changessize";	//Notice that your crosshair changes size as you fire, this indicates your current accuracy blah blah blaaah…
	level.scr_sound["gaz"]["stupidtest"] = "killhouse_gaz_stupidtest";	//…uhhh, also note that you will never be as accurate when you fire from the hip, as when you aim down your sights. (Bloody hell this is a stupid test innit?) All right let's get this over with.
	level.scr_sound["gaz"]["stupidinnit"] = "killhouse_gaz_stupidinnit";
	level.scr_sound["gaz"]["overwith"] = "killhouse_gaz_overwith";
	level.scr_sound["gaz"]["blocktargets"] = "killhouse_gaz_blocktargets";	//Now I'm going to block the targets with a sheet of plywood.
	level.scr_sound["gaz"]["shoottargets"] = "killhouse_gaz_shoottargets";	//I want you to shoot the targets through the wood.
	level.scr_sound["gaz"]["good"] = "killhouse_gaz_good";	//Good.
	level.scr_sound["gaz"]["bulletspenetrate"] = "killhouse_gaz_bulletspenetrate";	//Bullets will penetrate thin, weak materials like wood, plaster and sheet metal. The larger the weapon, the more penetrating power it has. But - you already knew that. Moving on.
	level.scr_sound["gaz"]["largerweapon"] = "killhouse_gaz_largerweapon";
	level.scr_sound["gaz"]["youknewthat"] = "killhouse_gaz_youknewthat";
	level.scr_sound["gaz"]["movingon"] = "killhouse_gaz_movingon";
	level.scr_sound["gaz"]["targetspop"] = "killhouse_gaz_targetspop";	//Now I'm going make the targets pop up one at a time.
	level.scr_sound["gaz"]["hitall"] = "killhouse_gaz_hitall";	//Hit all of them as fast as you can.
	level.scr_sound["gaz"]["cansnap"] = "killhouse_gaz_cansnap";	//As long as your crosshairs are near the targets, you can snap onto them by repeatedly popping in and out of aiming down the sight. 
	level.scr_sound["gaz"]["tryagain"] = "killhouse_gaz_tryagain";	//Too slow mate! Try again!
	level.scr_sound["gaz"]["stilltooslow"] = "killhouse_gaz_stilltooslow";	//You're still too slow…
	level.scr_sound["gaz"]["again"] = "killhouse_gaz_again";	//Again.
	level.scr_sound["gaz"]["again2"] = "killhouse_gaz_again2";	//Again.
	level.scr_sound["gaz"]["walkinpark"] = "killhouse_gaz_walkinpark";	//Too slow. Come on. This should be a walk in the park for you.
	level.scr_sound["gaz"]["propergood"] = "killhouse_gaz_propergood";	//Proper good job mate!

	//SIDE ARM

	level.scr_sound["gaz"]["getsidearm"] = "killhouse_gaz_getsidearm";	//Now go get a side arm from the table.
	level.scr_sound["gaz"]["switchtorifle"] = "killhouse_gaz_switchtorifle";	//Good. Now switch to your rifle.
	level.scr_sound["gaz"]["pulloutsidearm"] = "killhouse_gaz_pulloutsidearm";	//Now pull out your side arm.
	level.scr_sound["gaz"]["switchback"] = "killhouse_gaz_switchback";	//Good. Now switch back.
	level.scr_sound["gaz"]["drawsidearm"] = "killhouse_gaz_drawsidearm";	//Good. Now draw your side arm again.
	level.scr_sound["gaz"]["switchsidearm"] = "killhouse_gaz_switchsidearm";	//Good. Now switch to your side arm again.
	level.scr_sound["gaz"]["switchingfaster"] = "killhouse_gaz_switchingfaster";	//Remember - switching to your pistol is always faster than reloading.
	level.scr_sound["gaz"]["shortofelephant"] = "killhouse_gaz_shortofelephant";	//If your caught with an empty magazine I recommend you switch to your side arm, thats what its there for. We use the USP 45 now; short of an elephant, there's nothing these pistols won't stop at close range.

	// MELEE

	level.scr_sound["gaz"]["comethisway"] = "killhouse_gaz_comethisway";	//All right Soap, come this way.
	level.scr_sound["gaz"]["fewfeet"] = "killhouse_gaz_fewfeet";	//Here's the situation. You're caught with an empty magazine and you're just a few feet from your enemy.
	level.scr_sound["gaz"]["whatdoyoudo"] = "killhouse_gaz_whatdoyoudo";	//What do you do? Easy. You gut the bastard!
	level.scr_sound["gaz"]["attackwithknife"] = "killhouse_gaz_attackwithknife";	//Pretend this watermelon is your enemy. Attack it with your knife.
	level.scr_sound["gaz"]["attackwithknife"] = "Killhouse_gaz_knifemelon"; //knife the watermelon Soap.
	level.scr_sound["gaz"]["fruitkilling"] = "killhouse_gaz_fruitkilling";	//Lovely. Your fruit killing skills are remarkable.
	level.scr_sound["gaz"]["followme"] = "killhouse_gaz_followme";	//Ok, follow me.

	level.scr_sound["gaz"]["herebymelon"] = "killhouse_gaz_herebymelon";
	level.scr_sound["gaz"]["therebymelon"] = "killhouse_gaz_therebymelon";
	level.scr_sound["gaz"]["allgoodhere"] = "killhouse_gaz_allgoodhere";
	


	//GRENADES

	level.scr_sound["nwc"]["timeforfun"] = "killhouse_nwc_timeforfun";	//It's time for some fun mate. Let's blow some shit up…
	level.scr_sound["nwc"]["pickupfrag"] = "killhouse_nwc_pickupfrag";	//Pick up those frag grenades and get in the safety pit.
	level.scr_sound["nwc"]["getinsafety"] = "killhouse_nwc_getinsafety";	//Get in the safety pit Soap.
	level.scr_sound["nwc"]["getbackin"] = "killhouse_nwc_getbackin";	//No, get back in the safety pit.
	level.scr_sound["nwc"]["stayinpit"] = "killhouse_nwc_stayinpit";	//Soap, stay in the pit.
	level.scr_sound["nwc"]["throwgrenade"] = "killhouse_nwc_throwgrenade";	//Now throw a grenade into windows two, three and four.
	level.scr_sound["nwc"]["23and4"] = "killhouse_nwc_23and4";	//Windows two, three and four, Soap.
	level.scr_sound["nwc"]["2and3"] = "killhouse_nwc_2and3";	//Good, now two and three.
	level.scr_sound["nwc"]["2and4"] = "killhouse_nwc_2and4";	//Good, now two and four.
	level.scr_sound["nwc"]["3and4"] = "killhouse_nwc_3and4";	//Good, now three and four.
	level.scr_sound["nwc"]["window2"] = "killhouse_nwc_window2";	//Now window two.
	level.scr_sound["nwc"]["window3"] = "killhouse_nwc_window3";	//Now window three.
	level.scr_sound["nwc"]["window4"] = "killhouse_nwc_window4";	//Now window four.
	level.scr_sound["nwc"]["getsomemore"] = "killhouse_nwc_getsomemore";	//If you're out of grenades, come back around the corner and get some more.	
	level.scr_sound["nwc"]["moregrenades"] = "killhouse_nwc_moregrenades";	//Go pick up some more grenades from the table.	
	level.scr_sound["nwc"]["aimabovetarget"] = "killhouse_nwc_aimabovetarget";	//These things are heavy! You'll need to aim above your target.	
	level.scr_sound["nwc"]["whereyougoing"] = "killhouse_nwc_whereyougoing";	//Where do you think you're going?!	
	level.scr_sound["nwc"]["comebackidiot"] = "killhouse_nwc_comebackidiot";	//Come back you idiot!	


	//LAUNCHER

	level.scr_sound["nwc"]["moremojo"] = "killhouse_nwc_moremojo";	//Now let's try something with a little more 'mojo'. I don't know how much experience you've got with demolitions, so just do as I say, all right?
	level.scr_sound["nwc"]["pickuplauncher"] = "killhouse_nwc_pickuplauncher";	//Come back here and pick up this grenade launcher.
	level.scr_sound["nwc"]["launcherfromtable"] = "killhouse_nwc_launcherfromtable";	//Come back around the corner and pick up a grenade launcher from the table where you got the frag grenades.
	level.scr_sound["nwc"]["icononhud"] = "killhouse_nwc_icononhud";	//Notice you now have an icon of a grenade launcher on your HUD.
	level.scr_sound["nwc"]["nowbacktopit"] = "killhouse_nwc_nowbacktopit";	//Now get back into the safety pit.
	level.scr_sound["nwc"]["equiplauncher"] = "killhouse_nwc_equiplauncher";	//Equip the grenade launcher.
	level.scr_sound["nwc"]["firewall1"] = "killhouse_nwc_firewall1";	//Fire at the wall with the number one on it.
	level.scr_sound["nwc"]["didntexplode"] = "killhouse_nwc_didntexplode";	//Notice it didn't explode.
	level.scr_sound["nwc"]["safearming"] = "killhouse_nwc_safearming";	//As you know, all grenade launchers have a minimum safe arming distance.
	level.scr_sound["nwc"]["wontexplode"] = "killhouse_nwc_wontexplode";	//The grenade wont explode unless it travels that distance.
	level.scr_sound["nwc"]["56and7"] = "killhouse_nwc_56and7";	//Right. Now pop a grenade in each window, two, three and four.
	level.scr_sound["nwc"]["switchaway"] = "killhouse_nwc_switchaway";	//Now switch away from the grenade launcher.

	//C4

	level.scr_sound["nwc"]["c4offtable"] = "killhouse_nwc_c4offtable";	//Come back around and pick up some C4 off the table.
	level.scr_sound["nwc"]["pickupc4"] = "killhouse_nwc_pickupc4";	//Good. Come over here and pick up this C4.
	level.scr_sound["nwc"]["followme2"] = "killhouse_nwc_followme2";	//Follow me.
	level.scr_sound["nwc"]["c4icon"] = "killhouse_nwc_c4icon";	//Notice you now have a C4 icon on your HUD.
	level.scr_sound["nwc"]["dpadicon"] = "killhouse_nwc_dpadicon";	//The d-pad icon shows you what equipment you have in your inventory.
	level.scr_sound["nwc"]["dpadicons"] = "killhouse_nwc_dpadicons";	//The d-pad icons show you what equipment you have in your inventory.
	level.scr_sound["nwc"]["hudinventory"] = "killhouse_nwc_hudinventory";	//These HUD icons show you what equipment you have in your inventory.
	level.scr_sound["nwc"]["equipwillchange"] = "killhouse_nwc_equipwillchange";	//This equipment will change from mission to mission so be sure to keep an eye out for new equipment.
	level.scr_sound["nwc"]["equipc4"] = "killhouse_nwc_equipc4";	//Equip the C4, Soap.
	level.scr_sound["nwc"]["hudchanges"] = "killhouse_nwc_hudchanges";	//Notice that your HUD changes to show you what inventory item you have equipped.
	level.scr_sound["nwc"]["exwifecar"] = "killhouse_nwc_exwifecar";	//It seems my ex-wife was kind enough to donate her car to furthering your education Soap.
	level.scr_sound["nwc"]["exwifeantique"] = "killhouse_nwc_exwifeantique";	//It seems my ex-wife was kind enough to donate her antique furniture to furthering your education Soap.
	level.scr_sound["nwc"]["placec4"] = "killhouse_nwc_placec4";	//Place the C4 on the indicated spot.
	level.scr_sound["nwc"]["throwc4"] = "killhouse_nwc_throwc4";	//You can also throw C4.
	level.scr_sound["nwc"]["throwc4car"] = "killhouse_nwc_throwc4car";	//Throw some C4 on the car.
	level.scr_sound["nwc"]["c4furniture"] = "killhouse_nwc_c4furniture";	//Throw some C4 on the furniture.
	level.scr_sound["nwc"]["morec4"] = "killhouse_nwc_morec4";	//Go get some more C4 from the table.
	level.scr_sound["nwc"]["behindwall"] = "killhouse_nwc_behindwall";	//Now come over here behind the safety wall.
	level.scr_sound["nwc"]["safedistance"] = "killhouse_nwc_safedistance";	//Now get to a safe distance from the explosives.
	level.scr_sound["nwc"]["fireinhole"] = "killhouse_nwc_fireinhole";	//Fire in the hole!
	level.scr_sound["nwc"]["chuckle"] = "killhouse_nwc_chuckle";	//< satisfied chuckling > 
	level.scr_sound["nwc"]["muchimproved"] = "killhouse_nwc_muchimproved";	//Much improved.
	level.scr_sound["nwc"]["passedeval"] = "killhouse_nwc_passedeval"; //All right Soap, you passed the weapons evaluation.
	level.scr_sound["nwc"]["reporttomac"] = "killhouse_nwc_reporttomac"; //Now report to Mac on the obstacle course.	
	level.scr_sound["nwc"]["justbetween"] = "killhouse_nwc_justbetween"; //I’m sure he'll be thrilled to see you.	
	level.scr_sound["nwc"]["thrilledtosee"] = "killhouse_nwc_thrilledtosee"; //Just between you and me, he's a real arsehole.	
	level.scr_sound["nwc"]["goodluck"] = "killhouse_nwc_goodluck"; //Good luck!	

	
	//MAC

	level.scr_sound["mac"]["misssoap"] = "killhouse_mcm_misssoap";	//Wellll...it seems Miss Soap here was kind enough to join us!
	level.scr_sound["mac"]["lineup"] = "killhouse_mcm_lineup";	//Line up ladies!
	level.scr_sound["mac"]["go"] = "killhouse_mcm_go";	//Go!
	level.scr_sound["mac"]["jumpobstacles"] = "killhouse_mcm_jumpobstacles";	//Jump over those obstacles!
	level.scr_sound["mac"]["isntcharitywalk"] = "killhouse_mcm_isntcharitywalk";	//This isn't a bloody charity walk - get your arses in gear! MOVE!
	level.scr_sound["mac"]["commandos"] = "killhouse_mcm_commandos";	//I've seen "Sandhurst Commandos" run faster than you lot!
	//level.scr_sound["mac"]["didntyou"] = "killhouse_mcm_didntyou";	//You thought it was going to easier once you passed Selection didn't you? Didn't you?!!!
	//level.scr_sound["mac"]["bedeadbynow"] = "killhouse_mcm_bedeadbynow";	//You're all too slow! You're all just too fucking slow!!! You'd be dead by now if this were the real thing!
	level.scr_sound["mac"]["bertud"] = "killhouse_mcm_bertud";	//Move move move!!!! What's the matter with you? You all want to be R.T.U'd?
	level.scr_sound["mac"]["youcrawllike"] = "killhouse_mcm_youcrawllike";	//You crawl like old people screw!
	level.scr_sound["mac"]["passedtest"] = "killhouse_mcm_passedtest";	//Oi! Soap! Captain Price wants to see you in Hangar 4. You passed my little test, now get out of my sight.
	level.scr_sound["mac"]["runitagain"] = "killhouse_mcm_runitagain";	//The rest of you bloody ponces are going to run it again until I'm no longer embarassed to look at you!
	
	//SAS2
	level.scr_sound["sas2"]["fingy"] = "killhouse_sas2_fingy";	//It's the fingy sir.	
	//PRICE
	level.scr_sound["price"]["ropedeck"] = "killhouse_pri_ropedeck";	//On my go, I want you to rope down to the deck and rush to position 1.
	level.scr_sound["price"]["stormstairs"] = "killhouse_pri_stormstairs";	//After that you will storm down the stairs to position 2.
	level.scr_sound["price"]["hit3and4"] = "killhouse_pri_hit3and4";	//Then hit position 3 and 4 following my precise instructions at each position.
	level.scr_sound["price"]["gogogo"] = "killhouse_pri_gogogo";	//Go go go!
	level.scr_sound["price"]["hittargets"] = "killhouse_pri_hittargets";	//Hit the targets!
	level.scr_sound["price"]["position2"] = "killhouse_pri_position2";	//Position 2 go!
	level.scr_sound["price"]["flashthrudoor"] = "killhouse_pri_flashthrudoor";	//Flashbang through the door!
	level.scr_sound["price"]["position3"] = "killhouse_pri_position3";	//Go to Position 3!
	level.scr_sound["price"]["hittargets"] = "killhouse_pri_hittargets";	//Hit the targets!
	level.scr_sound["price"]["position4"] = "killhouse_pri_position4";	//Position 4!
	level.scr_sound["price"]["hittargets"] = "killhouse_pri_hittargets";	//Hit the targets!
	level.scr_sound["price"]["startover"] = "killhouse_pri_startover";	//That was too slow, come back to the ladder and start over.
	level.scr_sound["price"]["doitagain"] = "killhouse_pri_doitagain";	//Soap, that was way too slow. Do it again.
	level.scr_sound["price"]["goodjob"] = "killhouse_pri_goodjob";	//Good job Soap. It appears you may have earned that winged dagger after all. Now get ready to deploy for the cargoship operation. We go 'wheels up' in twenty minutes.

//new
//****implemented

	level.scr_sound["price"]["pickupmp5"] = "killhouse_pri_pickupmp5";	//****Pick up that MP5 and four flashbangs.
	level.scr_sound["price"]["markcompass"] = "killhouse_pri_markcompass";	//Now move to the starting position marked on your compass.
	level.scr_sound["price"]["grabrope"] = "killhouse_pri_grabrope";	//****Grab the rope when your ready.

	level.scr_sound["price"]["waitsignal"] = "killhouse_pri_waitsignal";	//Soap! Wait until I give the signal.

	level.scr_sound["price"]["soap4flash"] = "killhouse_pri_soap4flash";	//****Soap. Pick up four flash bangs.
	level.scr_sound["price"]["replaceflash"] = "killhouse_pri_replaceflash";	//****Replace any flash bangs you used.
	level.scr_sound["price"]["getflash"] = "killhouse_pri_getflash";	//Get some flashbangs.
	level.scr_sound["price"]["moreflash"] = "killhouse_pri_moreflash";	//Pick up some more flashbangs.
	level.scr_sound["price"]["soapequipmp5"] = "killhouse_pri_soapequipmp5";	//****Soap. Equip your MP5.
	level.scr_sound["price"]["equipmp5"] = "killhouse_pri_equipmp5";	//****Equip your MP5.

	level.scr_sound["price"]["missgoback"] = "killhouse_pri_missgoback";	//You missed a target, go back!
	level.scr_sound["price"]["passgoback"] = "killhouse_pri_passgoback";	//Go back! You passed one of the targets!
	level.scr_sound["price"]["goback"] = "killhouse_pri_goback";	//Go back!
	level.scr_sound["price"]["flashroomfirst"] = "killhouse_pri_flashroomfirst";	//You need to flashbang the room first!


	level.scr_sound["price"]["notthatgood"] = "killhouse_pri_notthatgood";	//Not bad, but not that good either.
	level.scr_sound["price"]["seenbetter"] = "killhouse_pri_seenbetter";	//****Pretty good, Soap. But I've seen better.
	level.scr_sound["price"]["anothergo"] = "killhouse_pri_anothergo";	//****Climb up the ladder if you want another go.
	level.scr_sound["price"]["debrief"] = "killhouse_pri_debrief";	//****Otherwise come over to the monitors for a debrief.

	level.scr_sound["price"]["newrecord"] = "killhouse_pri_newrecord";	//That's a new squadron record Soap! Not bad at all.

	level.scr_sound["price"]["5go"] = "killhouse_pri_5go";	//****Position five go!!
	level.scr_sound["price"]["6go"] = "killhouse_pri_6go";	//****Six go!!
	level.scr_sound["price"]["finalgo"] = "killhouse_pri_finalgo";	//****Final position go!!
	level.scr_sound["price"]["flashroom"] = "killhouse_pri_flashroom";	//Flash the room!!

	level.scr_sound["price"]["flashintoroom"] = "killhouse_pri_flashintoroom";	//Get the flashbang into the room!
	level.scr_sound["price"]["missedflash"] = "killhouse_pri_missedflash";	//You missed with the flashbang!
	level.scr_sound["price"]["youmissed"] = "killhouse_pri_youmissed";	//You missed!
	level.scr_sound["price"]["followarrows"] = "killhouse_pri_followarrows";	//Follow the arrows on the floor. 

	level.scr_sound["price"]["2"] = "killhouse_pri_2position";	//Go to Position 2!
	level.scr_sound["price"]["3"] = "killhouse_pri_3position";	//Position 3!
	level.scr_sound["price"]["4"] = "killhouse_pri_4";	//Four!
	level.scr_sound["price"]["5"] = "killhouse_pri_5";	//Five go!
	level.scr_sound["price"]["finalposition"] = "killhouse_pri_finalposition";	//Final position!
	level.scr_sound["price"]["shoottarget"] = "killhouse_pri_shoottarget";	//Shoot the other target. 
	level.scr_sound["price"]["remainingtarg"] = "killhouse_pri_remainingtarg";	//Shoot the remaining targets.
	level.scr_sound["price"]["hitother"] = "killhouse_pri_hitother";	//Hit other targets.
}

