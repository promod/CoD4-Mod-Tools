main()
{
	thread setVictoryQuote();
	thread setDeadQuote();
}

setVictoryQuote()
{
	victoryquotes[ 0 ] = "@VICTORYQUOTE_WHEN_YOU_HAVE_TO_KILL";
	victoryquotes[ 1 ] = "@VICTORYQUOTE_BATTLES_ARE_WON_BY_SLAUGHTER";
	victoryquotes[ 2 ] = "@VICTORYQUOTE_HISTORY_WILL_BE_KIND";
	victoryquotes[ 3 ] = "@VICTORYQUOTE_NOTHING_IN_LIFE_IS_SO";
	victoryquotes[ 4 ] = "@VICTORYQUOTE_SUCCESS_IS_NOT_FINAL";
	victoryquotes[ 5 ] = "@VICTORYQUOTE_WE_SHALL_DEFEND_OUR_ISLAND";
	victoryquotes[ 6 ] = "@VICTORYQUOTE_WHEN_YOU_GET_TO_THE_END";
	victoryquotes[ 7 ] = "@VICTORYQUOTE_THE_REAL_AND_LASTING";
	victoryquotes[ 8 ] = "@VICTORYQUOTE_A_HERO_IS_NO_BRAVER_THAN";
	victoryquotes[ 9 ] = "@VICTORYQUOTE_OUR_GREATEST_GLORY_IS";
	victoryquotes[ 10 ] = "@VICTORYQUOTE_THE_CHARACTERISTIC_OF";
	victoryquotes[ 11 ] = "@VICTORYQUOTE_IF_THE_OPPOSITION_DISARMS";
	victoryquotes[ 12 ] = "@VICTORYQUOTE_THE_OBJECT_OF_WAR_IS";
	victoryquotes[ 13 ] = "@VICTORYQUOTE_BETTER_TO_FIGHT_FOR_SOMETHING";
	victoryquotes[ 14 ] = "@VICTORYQUOTE_COURAGE_IS_FEAR_HOLDING";
	victoryquotes[ 15 ] = "@VICTORYQUOTE_IF_A_MAN_DOES_HIS_BEST";
	victoryquotes[ 16 ] = "@VICTORYQUOTE_IT_IS_FOOLISH_AND_WRONG";
	victoryquotes[ 17 ] = "@VICTORYQUOTE_EVERY_MANS_LIFE_ENDS";
	victoryquotes[ 18 ] = "@VICTORYQUOTE_ALL_WARS_ARE_CIVIL_WARS";
	victoryquotes[ 19 ] = "@VICTORYQUOTE_I_HAVE_NEVER_ADVOCATED";
	victoryquotes[ 20 ] = "@VICTORYQUOTE_WE_HAPPY_FEW_WE_BAND";
	victoryquotes[ 21 ] = "@VICTORYQUOTE_COWARDS_DIE_MANY_TIMES";
	victoryquotes[ 22 ] = "@VICTORYQUOTE_NEVER_INTERRUPT_YOUR";
	victoryquotes[ 23 ] = "@VICTORYQUOTE_THERE_ARE_ONLY_TWO_FORCES";
	victoryquotes[ 24 ] = "@VICTORYQUOTE_THERE_WILL_ONE_DAY_SPRING";
	victoryquotes[ 25 ] = "@VICTORYQUOTE_THERE_ARE_NO_ATHEISTS";
	victoryquotes[ 26 ] = "@VICTORYQUOTE_IF_WE_DONT_END_WAR_WAR";
	victoryquotes[ 27 ] = "@VICTORYQUOTE_LIVE_AS_BRAVE_MEN_AND";
	victoryquotes[ 28 ] = "@VICTORYQUOTE_COURAGE_AND_PERSEVERANCE";
	victoryquotes[ 29 ] = "@VICTORYQUOTE_COURAGE_IS_BEING_SCARED";
	victoryquotes[ 30 ] = "@VICTORYQUOTE_ABOVE_ALL_THINGS_NEVER";
	victoryquotes[ 31 ] = "@VICTORYQUOTE_I_HAVE_NEVER_MADE_BUT";
	victoryquotes[ 32 ] = "@VICTORYQUOTE_SAFEGUARDING_THE_RIGHTS";
	victoryquotes[ 33 ] = "@VICTORYQUOTE_HE_CONQUERS_WHO_ENDURES";
	victoryquotes[ 34 ] = "@VICTORYQUOTE_IT_IS_BETTER_TO_DIE_ON";
	victoryquotes[ 35 ] = "@VICTORYQUOTE_YOU_KNOW_THE_REAL_MEANING";
	victoryquotes[ 36 ] = "@VICTORYQUOTE_IN_WAR_THERE_IS_NO_SUBSTITUTE";
	victoryquotes[ 37 ] = "@VICTORYQUOTE_WAR_IS_A_SERIES_OF_CATASTROPHES";
	victoryquotes[ 38 ] = "@VICTORYQUOTE_THOSE_WHO_HAVE_LONG_ENJOYED";

	i = randomInt( victoryquotes.size );

	setdvar( "ui_victoryquote", victoryquotes[ i ] );
}

setDeadQuote()
{
	level endon( "mine death" );

	// kill any deadquotes already running
	level notify( "new_quote_string" );
	level endon( "new_quote_string" );
	
	// player can be dead if the player died at the same point that setDeadQuote was called from another script
	if ( isalive( level.player ) )
		level.player waittill( "death" );

	if ( !level.missionfailed )
	{
		deadquotes[ 0 ]  = "@DEADQUOTE_IT_IS_FATAL_TO_ENTER";
		deadquotes[ 1 ]  = "@DEADQUOTE_IN_WAR_YOU_WIN_OR_LOSE";
		deadquotes[ 2 ]  = "@DEADQUOTE_SO_LONG_AS_THERE_ARE";
		deadquotes[ 3 ]  = "@DEADQUOTE_OLDER_MEN_DECLARE_WAR";
		deadquotes[ 4 ]  = "@DEADQUOTE_WAR_DOES_NOT_DETERMINE";
		deadquotes[ 5 ]  = "@DEADQUOTE_PATRIOTS_ALWAYS_TALK";
		deadquotes[ 6 ]  = "@DEADQUOTE_ALL_THAT_IS_NECESSARY";
		deadquotes[ 7 ]  = "@DEADQUOTE_THE_REAL_AND_LASTING";
		deadquotes[ 8 ]  = "@DEADQUOTE_WAR_IS_DELIGHTFUL_TO";
		deadquotes[ 9 ]  = "@DEADQUOTE_YOU_CANT_SAY_CIV";
		deadquotes[ 10 ] = "@DEADQUOTE_IF_YOU_KNOW_THE_ENEMY";
		deadquotes[ 11 ] = "@DEADQUOTE_COST_B2_BOMBER";
		deadquotes[ 12 ] = "@DEADQUOTE_COST_AC130U";
		deadquotes[ 13 ] = "@DEADQUOTE_COST_F22";
		deadquotes[ 14 ] = "@DEADQUOTE_COST_F117A";
		deadquotes[ 15 ] = "@DEADQUOTE_COST_TOMAHAWK";
		deadquotes[ 16 ] = "@DEADQUOTE_COST_JAVELIN";
		deadquotes[ 17 ] = "@DEADQUOTE_FROM_TIME_TO_TIME_THE";
		deadquotes[ 18 ] = "@DEADQUOTE_DIPLOMATS_ARE_JUST_AS";
		deadquotes[ 19 ] = "@DEADQUOTE_THE_TYRANT_ALWAYS_TALKS";
		deadquotes[ 20 ] = "@DEADQUOTE_NOTHING_IN_LIFE_IS_SO";
		deadquotes[ 21 ] = "@DEADQUOTE_EVERY_TYRANT_WHO_HAS";
		deadquotes[ 22 ] = "@DEADQUOTE_TYRANTS_HAVE_ALWAYS_SOME";
		deadquotes[ 23 ] = "@DEADQUOTE_IN_WAR_TRUTH_IS_THE_FIRST";
		deadquotes[ 24 ] = "@DEADQUOTE_ALL_WARFARE_IS_BASED";
		deadquotes[ 25 ] = "@DEADQUOTE_A_LEADER_LEADS_BY_EXAMPLE";
		deadquotes[ 26 ] = "@DEADQUOTE_LET_YOUR_PLANS_BE_DARK";
		deadquotes[ 27 ] = "@DEADQUOTE_WE_SLEEP_SAFELY_IN_OUR";
		deadquotes[ 28 ] = "@DEADQUOTE_IF_A_MAN_DOES_HIS_BEST";
		deadquotes[ 29 ] = "@DEADQUOTE_THE_BURSTING_RADIUS_OF";
		deadquotes[ 30 ] = "@DEADQUOTE_WHEN_THE_PIN_IS_PULLED";
		deadquotes[ 31 ] = "@DEADQUOTE_SOME_PEOPLE_LIVE_AN_ENTIRE";
		deadquotes[ 32 ] = "@DEADQUOTE_FREEDOM_IS_NOT_FREE_BUT";
		deadquotes[ 33 ] = "@DEADQUOTE_THE_DEADLIEST_WEAPON";
		deadquotes[ 34 ] = "@DEADQUOTE_IT_IS_GENERALLY_INADVISABLE";
		deadquotes[ 35 ] = "@DEADQUOTE_THERE_ARE_ONLY_TWO_KINDS";
		deadquotes[ 36 ] = "@DEADQUOTE_FIVE_SECOND_FUSES_ONLY";
		deadquotes[ 37 ] = "@DEADQUOTE_ANYONE_WHO_TRULY_WANTS";
		deadquotes[ 38 ] = "@DEADQUOTE_AIM_TOWARDS_THE_ENEMY";
		deadquotes[ 39 ] = "@DEADQUOTE_TRACERS_WORK_BOTH_WAYS";
		deadquotes[ 40 ] = "@DEADQUOTE_CLUSTER_BOMBING_FROM";
		deadquotes[ 41 ] = "@DEADQUOTE_IF_THE_ENEMY_IS_IN_RANGE";
		deadquotes[ 42 ] = "@DEADQUOTE_TRY_TO_LOOK_UNIMPORTANT";
		deadquotes[ 43 ] = "@DEADQUOTE_WHOEVER_SAID_THE_PEN";
		deadquotes[ 44 ] = "@DEADQUOTE_IF_YOUR_ATTACK_IS_GOING";
		deadquotes[ 45 ] = "@DEADQUOTE_THE_TRUTH_OF_THE_MATTER";
		deadquotes[ 46 ] = "@DEADQUOTE_ANY_SOLDIER_WORTH_HIS";
		deadquotes[ 47 ] = "@DEADQUOTE_IF_WE_CANT_PERSUADE_NATIONS";
		deadquotes[ 48 ] = "@DEADQUOTE_IN_THE_END_IT_WAS_LUCK";
		deadquotes[ 49 ] = "@DEADQUOTE_I_THINK_THE_HUMAN_RACE";
		deadquotes[ 50 ] = "@DEADQUOTE_THE_INDEFINITE_COMBINATION";
		deadquotes[ 51 ] = "@DEADQUOTE_A_SHIP_WITHOUT_MARINES";
		deadquotes[ 52 ] = "@DEADQUOTE_ANY_MILITARY_COMMANDER";
		deadquotes[ 53 ] = "@DEADQUOTE_THEYLL_BE_NO_LEARNING";
		deadquotes[ 54 ] = "@DEADQUOTE_IF_THE_WINGS_ARE_TRAVELING";
		deadquotes[ 55 ] = "@DEADQUOTE_THE_PRESS_IS_OUR_CHIEF";
		deadquotes[ 56 ] = "@DEADQUOTE_KEEP_LOOKING_BELOW_SURFACE";
        deadquotes[ 57 ] = "@DEADQUOTE_IT_DOESNT_TAKE_A_HERO";
		deadquotes[ 58 ] = "@DEADQUOTE_INCOMING_FIRE_HAS_THE";
        deadquotes[ 59 ] = "@DEADQUOTE_CONCENTRATED_POWER_HAS";
        deadquotes[ 60 ] = "@DEADQUOTE_I_THINK_THAT_TECHNOLOGIES";
        deadquotes[ 61 ] = "@DEADQUOTE_THE_COMMANDER_IN_THE";
        deadquotes[ 62 ] = "@DEADQUOTE_NO_BATTLE_PLAN_SURVIVES";
        deadquotes[ 63 ] = "@DEADQUOTE_THE_MORE_MARINES_I_HAVE";
        deadquotes[ 64 ] = "@DEADQUOTE_HEROES_MAY_NOT_BE_BRAVER";
        deadquotes[ 65 ] = "@DEADQUOTE_WHETHER_YOU_LIKE_IT_OR";
        deadquotes[ 66 ] = "@DEADQUOTE_THE_WORLD_WILL_NOT_ACCEPT";
        deadquotes[ 67 ] = "@DEADQUOTE_YOU_CAN_MAKE_A_THRONE";
        deadquotes[ 68 ] = "@DEADQUOTE_A_MAN_MAY_DIE_NATIONS";
		deadquotes[ 69 ] = "@DEADQUOTE_TEAMWORK_IS_ESSENTIAL";
        deadquotes[ 70 ] = "@DEADQUOTE_WHOEVER_DOES_NOT_MISS";
        deadquotes[ 71 ] = "@DEADQUOTE_WERE_IN_A_NEW_WORLD_WERE";
		deadquotes[ 72 ] = "@DEADQUOTE_FRIENDLY_FIRE_ISNT_UNKNOWN";
        deadquotes[ 73 ] = "@DEADQUOTE_WHOEVER_STANDS_BY_A_JUST";
		deadquotes[ 74 ] = "@DEADQUOTE_IF_YOU_CANT_REMEMBER";
        deadquotes[ 75 ] = "@DEADQUOTE_IF_AT_FIRST_YOU_DONT";
		deadquotes[ 76 ] = "@DEADQUOTE_NEVER_FORGET_THAT_YOUR";
		deadquotes[ 77 ] = "@DEADQUOTE_I_KNOW_NOT_WITH_WHAT";
		deadquotes[ 78 ] = "@DEADQUOTE_MANKIND_MUST_PUT_AN_END";
		deadquotes[ 79 ] = "@DEADQUOTE_MY_FIRST_WISH_IS_TO_SEE";
		deadquotes[ 80 ] = "@DEADQUOTE_NEARLY_ALL_MEN_CAN_STAND";

		// Disabled until we can find a way to safely include
		// "@DEADQUOTE_DEMORALIZE_THE_ENEMY";
		// "@DEADQUOTE_SUCCESS_IS_THE_SOLE_EARTHLY";

		// Too long
		// "@DEADQUOTE_THERE_ARE_ONLY_TWO_FORCES";
		// "@DEADQUOTE_IS_IT_RIGHT_AND_PROPER";
		// "@DEADQUOTE_THERES_A_WONDERFUL_PHRASE";
       	// "@DEADQUOTE_OURS_IS_A_WORLD_OF_NUCLEAR";
       	// "@DEADQUOTE_IT_WOULD_BE_NAIVE_TO";
       	// "@DEADQUOTE_WAR_SHOULD_BE_THE_POLITICS";
       	// "@DEADQUOTE_I_LOVE_THE_CORPS_FOR";

		// This is used for testing
		if ( getdvar( "cycle_deathquotes" ) != "" )
		{
			if ( getdvar( "ui_deadquote_index" ) == "" )
				setdvar( "ui_deadquote_index", "0" );

			i = getdvarint( "ui_deadquote_index" );

			setdvar( "ui_deadquote", deadquotes[ i ] );

			i = i + 1;
			if ( !isdefined( deadquotes[ i ] ) )
				i = 0;

			setdvar( "ui_deadquote_index", i );
		}
		else
		{
			i = randomInt( deadquotes.size );

			setdvar( "ui_deadquote", deadquotes[ i ] );
		}
	}
}