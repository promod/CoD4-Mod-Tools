main()
{
	humans();
	dogs();	
}

#using_animtree("generic_human");
humans()
{	
	// every stealth level has this anim and it's required by stealth behavior
	level.scr_anim[ "generic" ][ "patrol_turn180" ]				= %patrol_bored_2_walk_180turn;

	level.scr_anim[ "generic" ][ "_stealth_patrol_jog" ]				= %patrol_jog;				
	level.scr_anim[ "generic" ][ "_stealth_patrol_walk" ]				= %patrol_bored_patrolwalk;	
	level.scr_anim[ "generic" ][ "_stealth_combat_jog" ]				= %combat_jog;
	
	level.scr_anim[ "generic" ][ "_stealth_patrol_search_a" ]			= %patrol_boredwalk_lookcycle_A;
	level.scr_anim[ "generic" ][ "_stealth_patrol_search_b" ]			= %patrol_boredwalk_lookcycle_B;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_0" ]			= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_1" ]			= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_2" ]			= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]			= %run_pain_stumble;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]	= %exposed_idle_twitch_v4;		
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]		= %patrol_bored_react_walkstop_short;
	
	level.scr_anim[ "generic" ][ "_stealth_look_around" ][0]			= %patrol_bored_react_look_v1;		
	level.scr_anim[ "generic" ][ "_stealth_look_around" ][1]			= %patrol_bored_react_look_v2;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_saw_corpse" ]		= %exposed_idle_twitch_v4;
	
	//1 is the animation that looks the best at the closest range (fast reaction )...and slower
	//reactions get added down the line		
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic1" ]			= %patrol_bored_react_look_advance;
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic2" ]			= %patrol_bored_react_look_retreat;
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic3" ]			= %patrol_bored_react_walkstop;
	level.scr_anim[ "generic" ][ "_stealth_behavior_generic4" ]			= %patrol_bored_react_walkstop_short;
	
	
	level.scr_anim[ "generic" ][ "_stealth_find_walk" ]					= %patrol_boredwalk_find;
	level.scr_anim[ "generic" ][ "_stealth_find_jog" ]					= %patrol_boredjog_find;
	level.scr_anim[ "generic" ][ "_stealth_find_run" ]					= %patrol_boredrun_find;
}

#using_animtree("dog");
dogs()
{
	level.scr_anim[ "generic" ][ "_stealth_dog_sleeping" ][0]		= %german_shepherd_sleeping;
	
	level.scr_anim[ "generic" ][ "_stealth_dog_wakeup_fast" ]		= %german_shepherd_wakeup_fast;
	level.scr_anim[ "generic" ][ "_stealth_dog_wakeup_slow" ]		= %german_shepherd_wakeup_slow;
}
