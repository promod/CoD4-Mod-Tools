#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
}

anims()
{
	// PRICE
	level.scr_sound[ "price" ][ "ambush_pri_notbad" ]		= "ambush_pri_notbad";

	level.scr_sound[ "price" ][ "ambush_pri_onmymark" ]		= "ambush_pri_onmymark";
	level.scr_sound[ "price" ][ "ambush_pri_takethemout" ]	= "ambush_pri_takethemout";
	level.scr_sound[ "price" ][ "ambush_pri_cleartower" ]	= "ambush_pri_cleartower";
	level.scr_sound[ "price" ][ "ambush_pri_movemove" ]		= "ambush_pri_movemove";

	level.scr_anim[ "price" ][ "tower_briefing" ] =			%ambush_tower_briefing_guy1;
	addNotetrack_dialogue( "price", "dialog" ,"tower_briefing", "ambush_pri_sortedout" );
	addNotetrack_dialogue( "price", "dialog" ,"tower_briefing", "ambush_pri_keepbusy" );
	addNotetrack_dialogue( "price", "dialog" ,"tower_briefing", "ambush_pri_muchtime" );

	level.scr_sound[ "price" ][ "ambush_pri_copythat" ]		= "ambush_pri_copythat";
	level.scr_sound[ "price" ][ "ambush_pri_youknow" ]		= "ambush_pri_youknow";

	level.scr_sound[ "price" ][ "ambush_pri_targetinjeep" ]	= "ambush_pri_targetinjeep";

	level.scr_sound[ "price" ][ "ambush_pri_thirdfront" ]	= "ambush_pri_thirdfront";
	level.scr_sound[ "price" ][ "ambush_pri_takealive" ]	= "ambush_pri_takealive";

	level.scr_sound[ "price" ][ "ambush_pri_standby" ]		= "ambush_pri_standby";
	level.scr_sound[ "price" ][ "ambush_pri_go" ]			= "ambush_pri_go";

	level.scr_sound[ "price" ][ "ambush_pri_nobodyfires" ]	= "ambush_pri_nobodyfires";
	level.scr_sound[ "price" ][ "ambush_pri_smokeem" ]		= "ambush_pri_smokeem";
	level.scr_sound[ "price" ][ "ambush_pri_goloud" ]		= "ambush_pri_goloud";

	level.scr_sound[ "price" ][ "ambush_pri_runforit" ]		= "ambush_pri_runforit";
	level.scr_sound[ "price" ][ "ambush_pri_chasehim" ]		= "ambush_pri_chasehim";

	level.scr_sound[ "price" ][ "ambush_pri_goafterhim" ]	= "ambush_pri_goafterhim";

	level.scr_anim[ "price" ][ "roof_idle" ][0]				= %ambush_price_idle;
	level.scr_anim[ "price" ][ "roof_move" ]				= %ambush_price_shout;

	level.scr_sound[ "price" ][ "ambush_pri_cantriskit" ]	= "ambush_pri_cantriskit";

	level.scr_sound[ "price" ][ "ambush_pri_restrainhim" ]	= "ambush_pri_restrainhim";
	level.scr_sound[ "price" ][ "ambush_pri_restrainnow" ]	= "ambush_pri_restrainnow";

	level.scr_sound[ "price" ][ "ambush_pri_sonisdead" ]		= "ambush_pri_sonisdead";

	level.scr_sound[ "price" ][ "ambush_pri_2isdead" ]		= "ambush_pri_2isdead";
	level.scr_sound[ "price" ][ "ambush_pri_knowtheman" ]	= "ambush_pri_knowtheman";

	// GAZ
	level.scr_sound[ "steve" ][ "ambush_gaz_visualtarget" ]	= "ambush_gaz_visualtarget";
	level.scr_sound[ "steve" ][ "ambush_gaz_gotcompany" ]	= "ambush_gaz_gotcompany";

	level.scr_sound[ "steve" ][ "ambush_gaz_fivestory" ]	= "ambush_gaz_fivestory";
	level.scr_sound[ "steve" ][ "ambush_gaz_heavyfire" ]	= "ambush_gaz_heavyfire";

	level.scr_sound[ "steve" ][ "ambush_gaz_dropgun" ]		= "ambush_gaz_dropgun";
	level.scr_sound[ "steve" ][ "ambush_gaz_dropit" ]		= "ambush_gaz_dropit";
	level.scr_sound[ "steve" ][ "ambush_gaz_dropitnow" ]	= "ambush_gaz_dropitnow";

	level.scr_sound[ "steve" ][ "ambush_gaz_no" ]			= "ambush_gaz_no";
	level.scr_sound[ "steve" ][ "ambush_gaz_onlylead" ]		= "ambush_gaz_onlylead";

	// GRIGGS

	level.scr_anim[ "mark" ][ "sprint" ]					= %sprint1_loop;

	level.scr_sound[ "mark" ][ "ambush_grg_areasecure" ]			= "ambush_grg_areasecure";
	level.scr_sound[ "mark" ][ "ambush_grg_blackrussian" ]			= "ambush_grg_blackrussian";
	level.scr_sound[ "mark" ][ "ambush_grg_likeaclown" ]			= "ambush_grg_likeaclown";
	level.scr_sound[ "mark" ][ "ambush_grg_nothinglikerussian" ]	= "ambush_grg_nothinglikerussian";
	level.scr_sound[ "mark" ][ "ambush_grg_friendliessixoclock" ]	= "ambush_grg_friendliessixoclock";
	level.scr_sound[ "mark" ][ "ambush_grg_inhisleg" ]				= "ambush_grg_inhisleg";
	level.scr_sound[ "mark" ][ "ambush_grg_catseriousissues" ]		= "ambush_grg_catseriousissues";
	level.scr_sound[ "mark" ][ "ambush_grg_easynow" ]				= "ambush_grg_easynow";
	level.scr_sound[ "mark" ][ "ambush_grg_kidissues" ]				= "ambush_grg_kidissues";

	level.scr_sound[ "mark" ][ "ambush_grg_hittower" ]				= "ambush_grg_hittower"; //
	level.scr_sound[ "mark" ][ "ambush_grg_ohno1" ]					= "ambush_grg_ohno1"; //
	level.scr_sound[ "mark" ][ "ambush_grg_ohno2" ]					= "ambush_grg_ohno2"; //
	level.scr_sound[ "mark" ][ "ambush_grg_downboy" ]				= "ambush_grg_downboy"; //
	level.scr_sound[ "mark" ][ "ambush_grg_soapgoalley" ]			= "ambush_grg_soapgoalley";
	level.scr_sound[ "mark" ][ "ambush_grg_thisway" ]				= "ambush_grg_thisway";

	level.scr_sound[ "mark" ][ "ambush_grg_movementroof" ]			= "ambush_grg_movementroof";
	level.scr_sound[ "mark" ][ "ambush_grg_bydumpster" ]			= "ambush_grg_bydumpster";
	level.scr_sound[ "mark" ][ "ambush_grg_acrosslot" ]				= "ambush_grg_acrosslot";

	level.scr_sound[ "mark" ][ "ambush_grg_gottahustle" ]			= "ambush_grg_gottahustle";
	level.scr_sound[ "mark" ][ "ambush_grg_gettingaway" ]			= "ambush_grg_gettingaway";

	// Kamarov
	level.scr_anim[ "generic" ][ "tower_briefing" ] =		%ambush_tower_briefing_guy2;

	// HELICOPTER
	level.scr_radio[ "ambush_mhp_radiojammers" ]	= "ambush_mhp_radiojammers";

	level.scr_radio[ "ambush_mhp_enemyconvoy" ]		= "ambush_mhp_enemyconvoy";

	level.scr_radio[ "ambush_mhp_jmovesfast" ]		= "ambush_mhp_jmovesfast";
	level.scr_radio[ "ambush_mhp_junkyard" ]		= "ambush_mhp_junkyard";
	level.scr_radio[ "ambush_mhp_cityoutskirts" ]	= "ambush_mhp_cityoutskirts";
	level.scr_radio[ "ambush_mhp_hostileforces" ]	= "ambush_mhp_hostileforces";
	level.scr_radio[ "ambush_mhp_checkyourfire" ]	= "ambush_mhp_checkyourfire";
	level.scr_radio[ "ambush_mhp_watchfire" ]		= "ambush_mhp_watchfire";
	level.scr_radio[ "ambush_mhp_sidealley" ]		= "ambush_mhp_sidealley";

	// Nags
	level.scr_radio[ "ambush_mhp_cuthrualley" ]		= "ambush_mhp_cuthrualley";
	level.scr_radio[ "ambush_mhp_wrongway" ]		= "ambush_mhp_wrongway";
	level.scr_radio[ "ambush_mhp_passedalley" ]		= "ambush_mhp_passedalley";
//	level.scr_radio[ "ambush_mhp_alleyonright" ]	= "ambush_mhp_alleyonright";

	level.scr_radio[ "ambush_mhp_getaway" ]			= "ambush_mhp_getaway";
	level.scr_radio[ "ambush_mhp_betterhurry" ]		= "ambush_mhp_betterhurry";
	level.scr_radio[ "ambush_mhp_gonnalose" ]		= "ambush_mhp_gonnalose";
	level.scr_radio[ "ambush_mhp_guyshaulin" ]		= "ambush_mhp_guyshaulin";

	// Timed out
	level.scr_radio[ "ambush_mhp_losthim_0" ]		= "ambush_mhp_losthim1";
	level.scr_radio[ "ambush_mhp_losthim_1" ]		= "ambush_mhp_losttarget";
	level.scr_radio[ "ambush_mhp_losthim_2" ]		= "ambush_mhp_losthim2";
	level.scr_radio[ "ambush_mhp_losthim_3" ]		= "ambush_mhp_abortmission";

	// Morpheus alley
	level.scr_radio[ "ambush_mhp_dumpster" ]		= "ambush_mhp_dumpster";
	level.scr_radio[ "ambush_mhp_greencar" ]		= "ambush_mhp_greencar";
	level.scr_radio[ "ambush_mhp_ironfence" ]		= "ambush_mhp_ironfence";
	level.scr_radio[ "ambush_mhp_rightflank" ]		= "ambush_mhp_rightflank";
	level.scr_radio[ "ambush_mhp_rooftops" ]		= "ambush_mhp_rooftops";
	level.scr_radio[ "ambush_mhp_topright" ]		= "ambush_mhp_topright";
	level.scr_radio[ "ambush_mhp_secondfloor" ]		= "ambush_mhp_secondfloor";
	level.scr_radio[ "ambush_mhp_overturneddump" ]	= "ambush_mhp_overturneddump";
	level.scr_radio[ "ambush_mhp_deadahead" ]		= "ambush_mhp_deadahead";
	level.scr_radio[ "ambush_mhp_alleyleft" ]		= "ambush_mhp_alleyleft";

	level.scr_radio[ "ambush_mhp_gotem" ]			= "ambush_mhp_gotem";
	level.scr_radio[ "ambush_mhp_goodkill" ]		= "ambush_mhp_goodkill";
	level.scr_radio[ "ambush_mhp_niceone" ]			= "ambush_mhp_niceone";
	level.scr_radio[ "ambush_mhp_allclear" ]		= "ambush_mhp_allclear";

	// Parking lot
	level.scr_radio[ "ambush_mhp_fivestory" ]		= "ambush_mhp_fivestory";
	level.scr_radio[ "ambush_mhp_visual" ]			= "ambush_mhp_visual";
	level.scr_radio[ "ambush_mhp_firstonefree" ]	= "ambush_mhp_firstonefree";
	
	// Building
	level.scr_radio[ "ambush_mhp_northeast" ]		= "ambush_mhp_northeast";
	level.scr_radio[ "ambush_mhp_staircase" ]		= "ambush_mhp_staircase";
	level.scr_radio[ "ambush_mhp_deeperinto" ]		= "ambush_mhp_deeperinto";
	level.scr_radio[ "ambush_mhp_holdon" ]			= "ambush_mhp_holdon";
	level.scr_radio[ "ambush_mhp_goodtogo" ]		= "ambush_mhp_goodtogo";
	level.scr_radio[ "ambush_mhp_movementroof" ]	= "ambush_mhp_movementroof";
	level.scr_radio[ "ambush_mhp_onroof" ]			= "ambush_mhp_onroof";

	// RUSSIAN FRIEND
	level.scr_sound[ "kamarov" ][ "ambush_kmr_bestwayin" ]				= "ambush_kmr_bestwayin";

	level.scr_sound[ "loyalist" ][ "ambush_ru2_papersplease" ]			= "ambush_ru2_papersplease";
	level.scr_sound[ "loyalist" ][ "ambush_ru2_illdothatrightnow" ]		= "ambush_ru2_illdothatrightnow";

	// RUSSIAN ENEMY
	level.scr_sound[ "russian" ][ "ambush_ru1_paperswhatpapers" ]		= "ambush_ru1_paperswhatpapers";
	level.scr_sound[ "russian" ][ "ambush_ru1_fatpolitician" ]			= "ambush_ru1_fatpolitician";
	level.scr_sound[ "russian" ][ "ambush_ru1_whatareyouwaitingfor" ]	= "ambush_ru1_whatareyouwaitingfor";

	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;

	level.scr_anim[ "generic" ][ "sprint" ]					= %sprint1_loop;

	level.scr_anim[ "generic" ][ "death_pose_0" ]			= %death_sitting_pose_v1;
	level.scr_anim[ "generic" ][ "death_pose_1" ]			= %death_sitting_pose_v2;

	// BADGUY
	level.scr_anim[ "badguy" ][ "jump" ]					= %ambush_VIP_son_jump;
	level.scr_anim[ "badguy" ][ "quick_jump" ]				= %ambush_VIP_son_quickdeath;
	addNotetrack_dialogue( "badguy", "dialog" ,"jump", "ambush_soz_deadsoonanyway" );
}