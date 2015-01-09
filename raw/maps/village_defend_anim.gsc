#include maps\_anim;
#using_animtree("generic_human");

main()
{	
	dialogue();
	run_anims();
}

dialogue()
{	
	//******* SOUTHERN HILL ********

	//"Ignore that load of bollocks. Their counterattack is imminent. Spread out and cover the southern approach."
	level.scr_sound[ "price" ][ "spreadout" ]			= "villagedef_pri_counterattackimminent";

	//"Bell tower here. Two enemy squads forming up to the south."
	level.scr_radio[ "belltowerhere" ]					= "villagedef_sas1_belltowerhere";
	
	//"Sir, they're slowly coming up the hill. Just say when."
	level.scr_radio[ "justsaywhen" ]					= "villagedef_sas2_justsaywhen";
	
	//"Do it."
	level.scr_radio[ "doit" ]							= "villagedef_pri_doit";
	
	//"Ka-boom."
	level.scr_radio[ "kaboom" ]						= "villagedef_sas2_kaboom";
	
	//"OOOPEN FIRRRRRRE!!!!"
	level.scr_sound[ "price" ][ "openfire" ]			= "villagedef_pri_openfire";
	
	//"Target down."
	level.scr_radio[ "targetdown" ]					= "villagedef_sas3_targetdown";
	
	//"Got him."
	level.scr_radio[ "gothim" ]						= "villagedef_sas3_gothim";
	
	//"Target eliminated."
	level.scr_radio[ "targeteliminated" ]				= "villagedef_sas3_targeteliminated";
	
	//"Goodbye."
	level.scr_radio[ "goodbye" ]						= "villagedef_sas3_goodbye";
	
	//"Sir, Ivan's bringin' in a recreational vehicle…"
	level.scr_radio[ "recreationalvehicle" ]			= "villagedef_sas2_rv";
	
	//"Take it out."
	level.scr_radio[ "takeitout" ]					= "villagedef_pri_takeitout";
	
	//"With pleasure sir. Firing Javelin."
	level.scr_radio[ "firingjavelin" ]				= "villagedef_sas2_firingjavelin";
	
	//"Nice shot mate."
	level.scr_radio[ "niceshotmate" ]					= "villagedef_sas3_niceshot";
	
	//"Blast, I can't get a lock on the other one. Someone else'll have to do it."
	level.scr_radio[ "blastnolock" ]					= "villagedef_sas2_cantgetlock";
	
	//"Squad, hold your ground, they think we're a larger force than we really are."
	level.scr_radio[ "largerforce" ]					= "villagedef_pri_holdground";
	
	//"Copy."	
	level.scr_radio[ "copy" ]							= "villagedef_sas3_copy";
	
	//"They're putting up smokescreens. Mac - you see anything?"
	level.scr_radio[ "smokescreensmac" ]				= "villagedef_sas2_smokescreens";
	
	//"Not much movement on the road. They might be moving to our west."
	level.scr_radio[ "notmuchmovement" ]				= "villagedef_sas4_toourwest";

	//"They're targeting our position with mortars. It's time to fall back."
	level.scr_radio[ "targetingour" ]				= "villagedef_gaz_fallback";
	
	
	
	//******* MINIGUN ********
	
	//"Right. Soap, get to the minigun and cover the western flank. Go."
	level.scr_radio[ "minigunflank" ]					= "villagedef_pri_coverwestflank";
	
	//"Soap, get to the minigun! Move! It's attached to the crashed helicopter."
	level.scr_radio[ "miniguncrashed" ]				= "villagedef_pri_gettominigun";
	
	//"Soap, I need you to operate the minigun! Get your arse moving!"
	level.scr_radio[ "minigunarse" ]					= "villagedef_pri_arsemoving";
	
	//"Two, falling back."
	level.scr_radio[ "twofallingback" ]				= "villagedef_sas2_fallingback";
	
	//"Three, on the move."
	level.scr_radio[ "threeonthemove" ]				= "villagedef_sas3_onmove";
	
	//"Three here. Two's in the far eastern building. We've got the eastern road locked down."
	level.scr_radio[ "easternroadlocked" ]			= "villagedef_sas3_roadlocked";
	
	//"Soap. Keep the minigun spooled up. Fire in bursts, 30 seconds max."
	level.scr_radio[ "spooledup" ]					= "villagedef_pri_fireinbursts";
	
	//Soap, get inside the crashed helicopter and use the minigun!
	level.scr_sound[ "gaz" ][ "gazuseminigun" ]		= "villagedef_gaz_usethminigun";
	
	//Soap. The minigun is inside the crashed helicopter.
	level.scr_radio[ "priceminiguninheli" ]					= "villagedef_pri_insidecrashed";
	
	//Get on the minigun in the helicopter. Move!
	level.scr_radio[ "priceminiguninhelimove" ]					= "villagedef_pri_getonminigunheli";
	
	//Soap, the minigun's online. It's in the crashed helicopter.
	level.scr_radio[ "gazminigunonline" ]					= "villagedef_gaz_minigunsonline";
	
	//"Here they come lads!"
	level.scr_radio[ "heretheycome" ]					= "villagedef_pri_heretheycome";
	
	//"We've got a problem here...heads up!"
	level.scr_radio[ "headsup" ]						= "villagedef_sas2_headsup";
	
	//"Bloody hell, that's a lot of helis innit?"
	level.scr_radio[ "lotofhelis" ]					= "villagedef_sas3_lotofhelis";
	
	
	
	//******* DETONATORS ********
	
	//"Soap, fall back to the tavern and man the detonators."
	level.scr_radio[ "tavern" ]					= "villagedef_pri_backtotavern";
	
	//"The rest of us will keep them busy from the next defensive line. Everyone move!"
	level.scr_radio[ "nextdefensiveline" ] 		= "villagedef_pri_defensiveline";
	
	//PRICE: Soap! Fall back to the next phase line! You're going to get overrun!
	level.scr_radio[ "detfallbackremind3" ]					= "villagedef_pri_getoverrun";
	
	//GAZ: Soap! Use the detonators! There's four of them in the tavern! Move!
	level.scr_radio[ "detuseremind1" ]		= "villagedef_gaz_fourintavern";
	
	//GAZ: The detonators are on the second floor of the tavern! Check your compass and move! We'll try to hold them off!
	level.scr_radio[ "detuseremind2" ]					= "villagedef_gaz_checkcompass";
	
	//GAZ: Soap! We're falling back to the next phase line! Let's go! Let's go! You're gonna be left behind!!
	level.scr_radio[ "detfallbackremind1" ]		= "villagedef_gaz_nextphaseline";
	
	//GAZ: Let's gooo!!! Fall back now!!!
	level.scr_radio[ "detfallbackremind2" ]		= "villagedef_gaz_fallbacknow";
	
	//GAZ: Soaap!!! Get off the miniguun! We're faalling baack!
	level.scr_radio[ "detminigunfallbackremind1" ]		= "villagedef_gaz_getoffminigun";
	
	//GAZ: Forget the minigun! We've go to go! NOW!
	level.scr_radio[ "detminigunfallbackremind2" ]		= "villagedef_gaz_forgetminigun";

	
	//******* FALL BACK TO FARM *********
	
	//PRICE: "Fall back to the farm at the top of the hill. Let's go. Now."
	level.scr_radio[ "fallbacktofarm1" ]					= "villagedef_pri_topofthehill";
	
	//PRICE: "Soap! You wanna be left behind? Fall back to the farm. Move!"
	level.scr_radio[ "fallbacktofarm2" ]					= "villagedef_pri_wannabeleft";
	
	//GAZ: "Soap! They're going to overrun your position! Fall back now!"
	level.scr_radio[ "tavernoverrunsoon" ]					= "villagedef_gaz_overrunyourpos";
	
	//GAZ: "Head for the farm to the north! Go! Go! Go!"
	level.scr_sound[ "gaz" ][ "fallbacktofarm3" ]	= "villagedef_gaz_headfforfarm";
	
	//GAZ: "FALL BAAACK!!! FAALLL BAACK!!!"
	level.scr_sound[ "gaz" ][ "fallbackgeneric" ]	= "villagedef_gaz_fallbackfallback";
	
	
	
	//******* TANK ARRIVAL *********
	
	//"We have enemy tanks approaching from the north! (sounds of fighting for a second) Bloody hell I'm hit! Arrrgh - (static)"
	level.scr_radio[ "enemytanksnorth" ]				= "villagedef_sas4_imhit";
	
	//"Mac's in trouble! Soap! Get to the barn at the northern end of the village and stop those tanks! Use the Javelins in the barn!"
	level.scr_radio[ "gettothebarn" ]					= "villagedef_pri_stoptanks";
	
	
	//******* JAVELIN NAGS *********
	
	//PRICE: "Soap, get the Javelin from the barn and take out those tanks!"
	level.scr_sound[ "price" ][ "javelinorder1" ]			= "villagedef_pri_getjavelinbarn";
	
	//GAZ: "Soap! The Javelin's in the barn! Move! Move!"
	level.scr_radio[ "javelinorder2" ]	= "villagedef_gaz_javelinsinbarn";
	
	//GAZ: "Take 'em out with the Javelin! Hurry!"
	level.scr_sound[ "gaz" ][ "javelinorder3" ]	= "villagedef_gaz_javelinhurry";
	
	
	//******* CLOSE AIR SUPPORT *********
	
	//"Bravo Six, this is Falcon One standing by to provide close air support. Gimme a target over."
	level.scr_radio[ "casready" ]				= "villagedef_fpp_standingby";
	
	//"Roger that, we're coming in hot."
	level.scr_radio[ "airstrikewarning" ] 			= "villagedef_fpp_airstrike";	
	
	//"Roger, standby for airstrike."
	level.scr_radio[ "airstrikewarning" ] 			= "villagedef_fpp_airstrike"; 	
	
	//"Target confirmed. Standby for airstrike."
	level.scr_radio[ "airstrikewarning" ] 			= "villagedef_fpp_airstrike";	
	
	
	
	//******* THE LZ *********
	
	//MHP: Bravo Six, this is Gryphon Two-Seven. We've just crossed into Azerbaijani airspace. E.T.A. is four minutes. Be ready for pickup. *MISSING*
	level.scr_radio[ "etafourminutes" ]				= "villagedef_hp2_beready";
	
	//MHP: Bravo Six, The LZ is too hot! We cannot land at the farm! I repeat, we CANNOT land at the farm! We're picking up SAM sites all over these mountains!
	level.scr_radio[ "pickingupSAMs" ]				= "villagedef_hp2_samsites";
	
	//GAZ: That's just great!! Where the hell are they gonna land now?
	level.scr_sound[ "gaz" ][ "thatsjustgreat" ]	= "villagedef_gaz_justgreat";
	
	//MHP: "Bravo Six, we're getting' a lot of enemy radar signatures, we'll try to land closer to the bottom of the hill to avoid a lock-on."
	level.scr_radio[ "lzbottomhill" ]					= "villagedef_hp2_enemyradar";
	
	//PRICE: They can't land on the high ground without getting shot down! We've got to get to the bottom of the hill!
	level.scr_radio[ "cantlandhigh" ]				= "villagedef_pri_cantlandhigh";
	
	//GAZ: Is he takin' the piss? We just busted our arses to get to this LZ and now they want us to go all the way back down?!
	level.scr_radio[ "takingthepiss" ]		= "villagedef_gaz_takinthepiss";
	
	//PRICE: Forget it Gaz! We've got to get to the new LZ at the bottom of the hill! Now! Soap! Take point! Go!
	level.scr_radio[ "thenewlz" ]		= "villagedef_pri_forgetitgaz";
	
	//MHP: Bravo Six, be advised, we're gonna come in low from the south across the river. Recommend you haul ass to LZ Foxtrot at the base of the hill. Out.
	level.scr_radio[ "lzfoxtrot" ]					= "villagedef_hp2_acrossriver";
	
	
	
	//******* GET TO THE CHOPPAH *********
	
	//"Copy Two-Seven! Everyone - head for the landing zone! It's our last chance! Move!"
	level.scr_radio[ "headlandingzone" ]				= "villagedef_pri_lastchance";
	
	//PRICE: "Get to the bottom of the hill!!! Move move!!!" *MISSING*
	level.scr_radio[ "bottomofthehill" ]					= "villagedef_pri_gettobottom";
	
	//GAZ: "We're gonna get left behind! We've got to get to the landing zone!"
	level.scr_radio[ "gettolandingzone" ]					= "villagedef_gaz_gonnagetleft";
	
	//PRICE: "We've got to break through their lines to reach the LZ! Keep pushing downhill!"
	level.scr_radio[ "breakthroughtolz" ]					= "villagedef_pri_breakthru";

	//GAZ: Let's go! Let's go! Get down the hill!!
	level.scr_radio[ "getdownthehill" ]	= "villagedef_gaz_getdownthehill";
	
	//GAZ: Get to the LZ! Go! Go!
	level.scr_radio[ "gettothelzgogo" ]	= "villagedef_gaz_gettolzgo";
	
	//******* PILOT NAGGING *********
	
	//Bravo Six, be advised we are almost there but we're low on fuel. You guys have three minutes before we have to leave without you, over.
	level.scr_radio[ "almosttherethree" ]					= "villagedef_hp2_3minutes";
	
	//You got two minutes, over!
	level.scr_radio[ "twominutesleft" ]				= "villagedef_hp2_2minutes";
	
	//PRICE: Copy that, we're on our way!
	level.scr_radio[ "copywereonourway" ]					= "villagedef_pri_copythat";
	
	//"Ninety seconds to dustoff."
	level.scr_radio[ "ninetysecondsleft" ]			= "villagedef_hp2_ninetysecs";
	
	//"One minute to bingo fuel."
	level.scr_radio[ "oneminutebingo" ]				= "villagedef_hp2_1mintobingo";
	
	//"Thirty seconds."
	level.scr_radio[ "thirtyseconds" ]				= "villagedef_hp2_30seconds";
	
	//"Ok we're outta here."
	level.scr_radio[ "outtahere" ]					= "villagedef_hp2_outtahere";
	
	//"Baseplate this is Gryphon Two-Seven. We got 'em and we're comin' home. Out."
	level.scr_radio[ "cominhome" ]					= "villagedef_hp2_cominhome";
	

	//******* LEAVING ON A HELICOPTER *********

	//"Heard you guys needed a ride outta here!"
	level.scr_sound[ "griggs" ][ "needaride" ]	= "villagedef_grg_needaride";
	
	//"Get on board! Move! Move!!"
	level.scr_sound[ "griggs" ][ "getonboard" ]	= "villagedef_grg_getonboard";
	
	//"Let's go! Let's go!"
	level.scr_sound[ "griggs" ][ "griggsletsgo" ]	= "villagedef_grg_letsgo";
	
	//"All right we're all aboard!!! Go! Go!"
	level.scr_sound[ "griggs" ][ "wereallaboard" ]	= "villagedef_grg_wereallaboard";


	//******* UNUSED *********
	
	//MHP: "Bravo Six, we'll try to land in the fields at the northern end of the village."
	//level.scr_radio[ "lzfields" ]						= "villagedef_hp2_landinfields";
	
	//HCC: Taking fire! Taking fire!  *MISSING*
	//level.scr_radio[ "takingfire" ]				= "villagedef_hcc_takingfire";
	
	//HCC: We're goin down!  We're goin- (BOOM) *MISSING*
	//level.scr_radio[ "weregoingdown" ]				= "villagedef_hcc_goindown";
	
	//MHP: This is Gryphon Two Five, we just lost our wingman. *MISSING*
	//level.scr_radio[ "lostwingman" ]				= "villagedef_hp2_lostwingman";
	
	//MHP: "Bravo Six, this is Gryphon Two-Seven. We've just crossed into Azerbaijani airspace. E.T.A. is six minutes. Be ready for pickup."
	//level.scr_radio[ "etasixminutes" ]				= "villagedef_hp2_etasixmins";
	
	//This is Gryphon Two-Seven. We're almost at bingo fuel. We gotta leave in one minute.
	//level.scr_radio[ "bingofueloneminute" ]			= "villagedef_hp2_1minute";
	
	//You're cuttin' it close Bravo Six! I can give you two more minutes, over!
	//level.scr_radio[ "twominutesleft" ]				= "villagedef_hp2_cuttinitclose";
	
	//"Bravo Six, be advised we are almost there but we're low on fuel. You guys have three minutes before we have to leave without you."
	//level.scr_radio[ "threeminutesleft" ]				= "villagedef_hp2_lowonfuel";
	
	//"Spread out. Don't stay in one spot too long and don't forget about the detonators at the windows. There's at least one in each building tied to a specific killzone."
	//level.scr_radio[ "detonators" ]					= "villagedef_pri_spreadout";
	
	//"And one more thing - don't forget about the Mark-19. It's on the wall beneath the water tower."
	//level.scr_radio[ "mark19" ]						= "villagedef_pri_onthewall";
	
	//"Enemy attack helicopter! Get to cover!!!"
	//level.scr_radio[ "enemyattackhelo" ]				= "villagedef_pri_attackheli";
	
	//"Soap! Grab a Stinger missile and take it down!!!"
	//level.scr_radio[ "grabstinger" ]					= "villagedef_pri_takeitdown";
	
	//"Attack helicopter moving in!!! Take cover!!!"
	//level.scr_radio[ "attackhelomoving" ]				= "villagedef_pri_takecover";
	
	//"I've got him. Taking the shot!"
	//level.scr_radio[ "takingtheshot" ]				= "villagedef_sas2_ivegothim";
	
	//"Enemy helicopter inbound! Take it out!"
	//level.scr_radio[ "heloinbound" ]					= "villagedef_pri_heliinbound";
	
	//"Ah!!!! I'm hit!!! Bloody hell I'm hit!"
	//level.scr_radio[ "bloodyhellimhit" ]				= "villagedef_sas2_imhim";
	
	//"We've got a man down! He's still alive! He's activated his transponder!"
	//level.scr_radio[ "transponder" ]					= "villagedef_sas3_mandown";
	
	//"Soap! Gaz! Try to get him back! We'll defend the helicopter and buy you some time!"
	//level.scr_radio[ "buyyoutime" ]					= "villagedef_pri_gettohim";
	
	//"You're cuttin' it close Bravo Six! I can give you two more minutes, over!"
	//level.scr_radio[ "cuttingclose" ]				= "null";
	
	//"You've got two minutes, go!"
	//level.scr_radio[ "twominutesgo" ]				= "null";
	
	//"Bravo Six, we're gonna try and touch down at the eastern tip of the village."
	//level.scr_radio[ "lzeast" ]						= "villagedef_hp2_touchdown";
	
	//"Two minutes people! We're already takin' some fire."
	//level.scr_radio[ "twominutesleft" ]				= "villagedef_hp2_twomins";
	
	//You're cuttin' it close Bravo Six! I can give you two more minutes, over!
	
	//"This is Gryphon Two-Seven. We're at bingo fuel. We gotta leave in one minute."
	//level.scr_radio[ "bingofueloneminute" ]			= "villagedef_hp2_bingofuel";
	
	//This is Gryphon Two-Five. Change of plans Bravo Six. Get your team to the bottom of the hill. We'll rendezvous with you at the low ground. You've got four minutes. *MISSING*
	//level.scr_radio[ "changeofplans" ]				= "villagedef_hp2_lowground";
	
	//"Forget about me! You won't make it back in time! Just go!"
	//level.scr_radio[ "forgetaboutme" ]				= "villagedef_sas2_justgo";
	
	//GAZ: Are we ever glad to see you! *MISSING*	
	//level.scr_radio[ "gladtoseeyou" ]					= "null";
	
	//GAZ: Engaging!!! *MISSING*
	//level.scr_sound[ "gaz" ][ "gettothelzgogo" ]	= "null";
	
	//"Soap, they're already in the graveyard! Get on that bloody gun!"
	//level.scr_radio[ "graveyard" ]					= "villagedef_pri_ingraveyard";
	
	//"Negative. Wait - oh shit! Harris get ouuuuutt- (BOOM)"
	//level.scr_radio[ "negativewait" ]						= "villagedef_sas1_negativewait";
	
	//"Shite! Parker and Harris are dead."
	//level.scr_radio[ "parkerharrisdead" ]					= "villagedef_sas2_parkerandharrisdead";
	
	//PRICE: Comin' through!! Comin' through!!! *MISSING*
	//level.scr_sound[ "price" ][ "pricecominthrough" ]		= "villagedef_pri_cominthru";
	
	//GAZ: Coming through! Coming through!! *MISSING*
	//level.scr_sound[ "gaz" ][ "gazcominthrough" ]	= "villagedef_gaz_cominthru";
	
	//"Any vehicles?"
	//level.scr_sound[ "price" ][ "anyvehicles" ]		= "villagedef_pri_anyvehicles";
	
	//"Grrrrraaaahhh!!!! Aaagh!"
	//level.scr_sound[ "woundedguy" ][ "painscreams" ]	= "villagedef_sas2_agh";
	
	//"I owe you one mate. Thanks for comin' back for me."
	//level.scr_sound[ "woundedguy" ][ "oweyouone" ]	= "villagedef_sas2_oweyouone";
	
	level.scr_anim[ "generic" ][ "ch46_load_1" ]					= %ch46_load_1;
	level.scr_anim[ "generic" ][ "ch46_load_2" ]					= %ch46_load_2;		
	level.scr_anim[ "generic" ][ "ch46_load_3" ]					= %ch46_load_3;
	level.scr_anim[ "generic" ][ "ch46_load_4" ]					= %ch46_load_4;	
	
	script_models();
	player_boarding();
	seaknight_anims();
}

run_anims()
{
	level.scr_anim[ "axis" ][ "patrolwalk_1" ] =			%patrol_bored_patrolwalk; 		//active_patrolwalk_v1
	level.scr_anim[ "axis" ][ "patrolwalk_2" ] =			%patrol_bored_patrolwalk;		//active_patrolwalk_v2
	level.scr_anim[ "axis" ][ "patrolwalk_3" ] =			%patrol_bored_patrolwalk;		//active_patrolwalk_v3
	level.scr_anim[ "axis" ][ "patrolwalk_4" ] =			%patrol_bored_patrolwalk;		//active_patrolwalk_v4
	level.scr_anim[ "axis" ][ "patrolwalk_5" ] =			%patrol_bored_patrolwalk;		//active_patrolwalk_v5
	level.scr_anim[ "axis" ][ "patrolwalk_pause" ] =		%patrol_bored_react_walkstop;		//active_patrolwalk_pause
}

player_boarding()
{
	level.scr_anim[ "player_carry" ][ "village_player_getin" ]		= %village_player_getin;
	level.scr_animtree[ "player_carry" ] 							= #animtree;	
	level.scr_model[ "player_carry" ] 								= "viewhands_player_sas_woodland";
}

#using_animtree( "script_model" );
script_models()
{
	level.scr_anim[ "minigun" ][ "spin_idle" ][ 0 ]		= %minigun_spin_idle;
	level.scr_anim[ "minigun" ][ "spin_loop" ][ 0 ]		= %minigun_spin_loop;
	level.scr_anim[ "minigun" ][ "spin" ]				= %minigun_spin_loop;
	level.scr_anim[ "minigun" ][ "spin_start" ]			= %minigun_spin_start;
	level.scr_animtree[ "minigun" ] 					= #animtree;	
	level.scr_model[ "minigun" ] 						= "weapon_minigun";
}

/*
#using_animtree( "player" );
player_boarding()
{
	//level.scr_anim[ "player_carry" ][ "wounded_seaknight_putdown" ]		= %airlift_player_putdown;
}
*/

#using_animtree( "vehicles" );
seaknight_anims()
{
	level.scr_anim[ "generic" ][ "ch46_doors_open" ]				= %ch46_doors_open;	
}