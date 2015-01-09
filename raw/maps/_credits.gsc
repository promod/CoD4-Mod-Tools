#include common_scripts\utility;
#include maps\_utility;

initCredits()
{
	level.linesize = 1.35;
	level.headingsize = 1.75;
	level.linelist = [];
	
	set_console_status();
	initIWCredits();
	initActivisionCredits();
}

initIWCredits()
{
	if( getdvar( "mapname" ) == "ac130" )
	{
		addLeftImage( "logo_infinityward", 256, 128, 4.375 ); //3.5
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_PROJECT_LEAD" );
		addSpaceSmall();
		addLeftName( &"CREDIT_JASON_WEST_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_ENGINEERING_LEADS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_RICHARD_BAKER_CAPS" );
		addLeftName( &"CREDIT_ROBERT_FIELD_CAPS" );
		addLeftName( &"CREDIT_FRANCESCO_GIGLIOTTI_CAPS" );
		addLeftName( &"CREDIT_EARL_HAMMON_JR_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ENGINEERING" );
		addSpaceSmall();
		addLeftName( &"CREDIT_CHAD_BARB_CAPS" );
		addLeftName( &"CREDIT_ALESSANDRO_BARTOLUCCI_CAPS" );
		addLeftName( &"CREDIT_JON_DAVIS_CAPS" );
		addLeftName( &"CREDIT_JOEL_GOMPERT_CAPS" );
		addLeftName( &"CREDIT_JOHN_HAGGERTY_CAPS" );
		addLeftName( &"CREDIT_JON_SHIRING_CAPS" );
		addLeftName( &"CREDIT_JIESANG_SONG_CAPS" );
		addLeftName( &"CREDIT_RAYME_VINSON_CAPS" );
		addLeftName( &"CREDIT_ANDREW_WANG_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_DESIGN_LEADS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_TODD_ALDERMAN_CAPS" );
		addLeftName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		addLeftName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		addLeftName( &"CREDIT_ZIED_RIEKE_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_DESIGN_AND_SCRIPTING" );
		addSpaceSmall();
		addLeftName( &"CREDIT_ROGER_ABRAHAMSSON_CAPS" );
		addLeftName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
		addLeftName( &"CREDIT_KEITH_BELL_CAPS" );
		addLeftName( &"CREDIT_PRESTON_GLENN_CAPS" );
		addLeftName( &"CREDIT_CHAD_GRENIER_CAPS" );
		addLeftName( &"CREDIT_JAKE_KEATING_CAPS" );
		addLeftName( &"CREDIT_JULIAN_LUO_CAPS" );
		addLeftName( &"CREDIT_STEVE_MASSEY_CAPS" );
		addLeftName( &"CREDIT_BRENT_MCLEOD_CAPS" );
		addLeftName( &"CREDIT_JON_PORTER_CAPS" );
		addLeftName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
		addLeftName( &"CREDIT_NATHAN_SILVERS_CAPS" );
		addLeftName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_ART_DIRECTOR" );
		addSpaceSmall();
		addLeftName( &"CREDIT_RICHARD_KRIEGLER_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_TECHNICAL_ART_DIRECTOR" );
		addSpaceSmall();
		addLeftName( &"CREDIT_MICHAEL_BOON_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ART_LEADS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_CHRIS_CHERUBINI_CAPS" );
		addLeftName( &"CREDIT_JOEL_EMSLIE_CAPS" );
		addLeftName( &"CREDIT_ROBERT_GAINES_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ART" );
		addSpaceSmall();
		addLeftName( &"CREDIT_BRAD_ALLEN_CAPS" );
		addLeftName( &"CREDIT_PETER_CHEN_CAPS" );
		addLeftName( &"CREDIT_JEFF_HEATH_CAPS" );
		addLeftName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
		addLeftName( &"CREDIT_OSCAR_LOPEZ_CAPS" );
		addLeftName( &"CREDIT_HERBERT_LOWIS_CAPS" );
		addLeftName( &"CREDIT_TAEHOON_OH_CAPS" );
		addLeftName( &"CREDIT_SAMI_ONUR_CAPS" );
		addLeftName( &"CREDIT_VELINDA_PELAYO_CAPS" );
		addLeftName( &"CREDIT_RICHARD_SMITH_CAPS" );
		addLeftName( &"CREDIT_THEERAPOL_SRISUPHAN_CAPS" );
		addLeftName( &"CREDIT_TODD_SUE_CAPS" );
		addLeftName( &"CREDIT_SOMPOOM_TANGCHUPONG_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_ANIMATION_LEADS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		addLeftName( &"CREDIT_PAUL_MESSERLY_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ANIMATION" );
		addSpaceSmall();
		addLeftName( &"CREDIT_CHANCE_GLASCO_CAPS" );
		addLeftName( &"CREDIT_EMILY_RULE_CAPS" );
		addLeftName( &"CREDIT_ZACH_VOLKER_CAPS" );
		addLeftName( &"CREDIT_LEI_YANG_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_TECHNICAL_ANIMATION_LEAD" );
		addSpaceSmall();
		addLeftName( &"CREDIT_ERIC_PIERCE_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_TECHNICAL_ANIMATION" );
		addSpaceSmall();
		addLeftName( &"CREDIT_NEEL_KAR_CAPS" );
		addLeftName( &"CREDIT_CHENG_LOR_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_AUDIO_LEAD" );
		addSpaceSmall();
		addLeftName( &"CREDIT_MARK_GANUS_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_AUDIO" );
		addSpaceSmall();
		addLeftName( &"CREDIT_CHRISSY_ARYA_CAPS" );
		addLeftName( &"CREDIT_STEPHEN_MILLER_CAPS" );
		addLeftName( &"CREDIT_LINDA_ROSEMEIER_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_WRITTEN_BY" );
		addSpaceSmall();
		addLeftName( &"CREDIT_JESSE_STERN_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_WRITING" );
		addSpaceSmall();
		addLeftName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_STORY_BY" );
		addSpaceSmall();
		addLeftName( &"CREDIT_TODD_ALDERMAN_CAPS" );
		addLeftName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		addLeftName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		addLeftName( &"CREDIT_ZIED_RIEKE_CAPS" );
		addLeftName( &"CREDIT_JESSE_STERN_CAPS" );
		addLeftName( &"CREDIT_JASON_WEST_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_STUDIO_HEADS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_GRANT_COLLIER_CAPS" );
		addLeftName( &"CREDIT_JASON_WEST_CAPS" );
		addLeftName( &"CREDIT_VINCE_ZAMPELLA_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_PRODUCER" );
		addSpaceSmall();
		addLeftName( &"CREDIT_MARK_RUBIN_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ASSOCIATE_PRODUCER" );
		addSpaceSmall();
		addLeftName( &"CREDIT_PETE_BLUMEL_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_OFFICE_MANAGER" );
		addSpaceSmall();
		addLeftName( &"CREDIT_JANICE_TURNER_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_HUMAN_RESOURCES_GENERALIST" );
		addSpaceSmall();
		addLeftName( &"CREDIT_KRISTIN_COTTERELL_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_EXECUTIVE_ASSISTANT" );
		addSpaceSmall();
		addLeftName( &"CREDIT_NICOLE_SCATES_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ADMINISTRATIVE_ASSISTANT" );
		addSpaceSmall();
		addLeftName( &"CREDIT_CARLY_GILLIS_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_COMMUNITY_RELATIONS_MANAGER" );
		addSpaceSmall();
		addLeftName( &"CREDIT_ROBERT_BOWLING_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_INFORMATION_TECHNOLOGY_LEAD" );
		addSpaceSmall();
		addLeftName( &"CREDIT_BRYAN_KUHN_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_INFORMATION_TECHNOLOGY" );
		addSpaceSmall();
		addLeftName( &"CREDIT_DREW_MCCOY_CAPS" );
		addLeftName( &"CREDIT_ALEXANDER_SHARRIGAN_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_QUALITY_ASSURANCE_LEADS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_JEMUEL_GARNETT_CAPS" );
		addLeftName( &"CREDIT_ED_HARMER_CAPS" );
		addLeftName( &"CREDIT_JUSTIN_HARRIS_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_QUALITY_ASSURANCE" );
		addSpaceSmall();
		addLeftName( &"CREDIT_BRYAN_ANKER_CAPS" );
		addLeftName( &"CREDIT_ADRIENNE_ARRASMITH_CAPS" );
		addLeftName( &"CREDIT_ESTEVAN_BECERRA_CAPS" );
		addLeftName( &"CREDIT_REILLY_CAMPBELL_CAPS" );
		addLeftName( &"CREDIT_DIMITRI_DEL_CASTILLO_CAPS" );
		addLeftName( &"CREDIT_SHAMENE_CHILDRESS_CAPS" );
		addLeftName( &"CREDIT_WILLIAM_CHO_CAPS" );
		addLeftName( &"CREDIT_RICHARD_GARCIA_CAPS" );
		addLeftName( &"CREDIT_DANIEL_GERMANN_CAPS" );
		addLeftName( &"CREDIT_EVAN_HATCH_CAPS" );
		addLeftName( &"CREDIT_TAN_LA_CAPS" );
		addLeftName( &"CREDIT_RENE_LARA_CAPS" );
		addLeftName( &"CREDIT_STEVE_LOUIS_CAPS" );
		addLeftName( &"CREDIT_ALEX_MEJIA_CAPS" );
		addLeftName( &"CREDIT_MATT_MILLER_CAPS" );
		addLeftName( &"CREDIT_CHRISTIAN_MURILLO_CAPS" );
		addLeftName( &"CREDIT_GAVIN_NIEBEL_CAPS" );
		addLeftName( &"CREDIT_NORMAN_OVANDO_CAPS" );
		addLeftName( &"CREDIT_JUAN_RAMIREZ_CAPS" );
		addLeftName( &"CREDIT_ROBERT_RITER_CAPS" );
		addLeftName( &"CREDIT_BRIAN_ROYCEWICZ_CAPS" );
		addLeftName( &"CREDIT_TRISTEN_SAKURADA_CAPS" );
		addLeftName( &"CREDIT_KEANE_TANOUYE_CAPS" );
		addLeftName( &"CREDIT_JASON_TOM_CAPS" );
		addLeftName( &"CREDIT_MAX_VO_CAPS" );
		addLeftName( &"CREDIT_BRANDON_WILLIS_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_INTERNS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_MICHAEL_ANDERSON_CAPS" );
		addLeftName( &"CREDIT_JASON_BOESCH_CAPS" );
		addLeftName( &"CREDIT_ARTURO_CABALLERO_CAPS" );
		addLeftName( &"CREDIT_DERRIC_EADY_CAPS" );
		addLeftName( &"CREDIT_DANIEL_EDWARDS_CAPS" );
		addLeftName( &"CREDIT_ALDRIC_SAUCIER_CAPS" );
		addSpace();
		addSpace();		
		addLeftTitle( &"CREDIT_VOICE_TALENT" );
		addSpaceSmall();
		addLeftName( &"CREDIT_BILLY_MURRAY_CAPS" );
		addLeftName( &"CREDIT_CRAIG_FAIRBRASS_CAPS" );
		addLeftName( &"CREDIT_DAVID_SOBOLOV_CAPS" );
		addLeftName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		addLeftName( &"CREDIT_ZACH_HANKS_CAPS" );
		addLeftName( &"CREDIT_FRED_TOMA_CAPS" );
		addLeftName( &"CREDIT_EUGENE_LAZAREB_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_VOICE_TALENT" );
		addSpaceSmall();
		addLeftName( &"CREDIT_GABRIEL_ALRAJHI_CAPS" );
		addLeftName( &"CREDIT_SARKIS_ALBERT_CAPS" );
		addLeftName( &"CREDIT_DESMOND_ASKEW_CAPS" );
		addLeftName( &"CREDIT_DAVID_NEIL_BLACK_CAPS" );
		addLeftName( &"CREDIT_MARCUS_COLOMA_CAPS" );
		addLeftName( &"CREDIT_MICHAEL_CUDLITZ_CAPS" );
		addLeftName( &"CREDIT_GREG_ELLIS_CAPS" );
		addLeftName( &"CREDIT_GIDEON_EMERY_CAPS" );
		addLeftName( &"CREDIT_JOSH_GILMAN_CAPS" );
		addLeftName( &"CREDIT_MICHAEL_GOUGH_CAPS" );
		addLeftName( &"CREDIT_ANNA_GRAVES_CAPS" );
		addLeftName( &"CREDIT_SVEN_HOLMBERG_CAPS" );
		addLeftName( &"CREDIT_MARK_IVANIR_CAPS" );
		addLeftName( &"CREDIT_QUENTIN_JONES_CAPS" );
		addLeftName( &"CREDIT_ARMANDO_VALDESKENNEDY_CAPS" );
		addLeftName( &"CREDIT_BORIS_KIEVSKY_CAPS" );
		addLeftName( &"CREDIT_RJ_KNOLL_CAPS" );
		addLeftName( &"CREDIT_KRISTOF_KONRAD_CAPS" );
		addLeftName( &"CREDIT_DAVE_MALLOW_CAPS" );
		addLeftName( &"CREDIT_JORDAN_MARDER_CAPS" );
		addLeftName( &"CREDIT_SAM_SAKO_CAPS" );
		addLeftName( &"CREDIT_HARRY_VAN_GORKUM_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_MODELS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_MUNEER_ABDELHADI_CAPS" );
		addLeftName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
		addLeftName( &"CREDIT_JESUS_ANGUIANO_CAPS" );
		addLeftName( &"CREDIT_CHAD_BAKKE_CAPS" );
		addLeftName( &"CREDIT_PETER_CHEN_CAPS" );
		addLeftName( &"CREDIT_KEVIN_COLLINS_CAPS" );
		addLeftName( &"CREDIT_HUGH_DALY_CAPS" );
		addLeftName( &"CREDIT_DERRIC_EADY_CAPS" );
		addLeftName( &"CREDIT_SUREN_GAZARYAN_CAPS" );
		addLeftName( &"CREDIT_CHAD_GRENIER_CAPS" );
		addLeftName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		addLeftName( &"CREDIT_JUSTIN_HARRIS_CAPS" );
		addLeftName( &"CREDIT_CLIVE_HAWKINS_CAPS" );
		addLeftName( &"CREDIT_STEVEN_JONES_CAPS" );
		addLeftName( &"CREDIT_DAVID_KLEC_CAPS" );
		addLeftName( &"CREDIT_JOSHUA_LACROSSE_CAPS" );
		addLeftName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
		addLeftName( &"CREDIT_JAMES_LITTLEJOHN_CAPS" );
		addLeftName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		addLeftName( &"CREDIT_TOM_MINDER_CAPS" );
		addLeftName( &"CREDIT_SAMI_ONUR_CAPS" );
		addLeftName( &"CREDIT_VELINDA_PELAYO_CAPS" );
		addLeftName( &"CREDIT_MARTIN_RESOAGLI_CAPS" );
		addLeftName( &"CREDIT_ZIED_RIEKE_CAPS" );
		addLeftName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
		addLeftName( &"CREDIT_JOSE_RUBEN_AGUILAR_JR_CAPS" );
		addLeftName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
		addLeftName( &"CREDIT_TODD_SUE_CAPS" );
		addLeftName( &"CREDIT_EID_TOLBA_CAPS" );
		addLeftName( &"CREDIT_ZACH_VOLKER_CAPS" );
		addLeftName( &"CREDIT_JASON_WEST_CAPS" );
		addLeftName( &"CREDIT_HENRY_YORK_CAPS" );
		addSpace();
		addSpace();
		/*addLeftTitle( &"CREDIT_ORIGINAL_SCORE" );
		addSpace();
		addSubLeftTitle( &"CREDIT_THEME_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_HARRY_GREGSONWILLIAMS_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PRODUCED_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_HARRY_GREGSONWILLIAMS_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_MUSIC_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_STEPHEN_BARTON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORE_SUPERVISOR" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ALLISON_WRIGHT_CLARK_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_AMBIENT_MUSIC_DESIGN" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_MEL_WESSON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORE_PERFORMED_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_THE_LONDON_SESSION_ORCHESTRA_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORING_ENGINEER" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_JONATHAN_ALLEN_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORING_MIXER" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_MALCOLM_LUKER_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PROTOOLS_ENGINEERS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_JAMIE_LUKER_CAPS" );
		addSubLeftName( &"CREDIT_SCRAP_MARSHALL_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ORCHESTRA_CONTRACTORS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ISOBEL_GRIFFITHS_CAPS" );
		addSubLeftName( &"CREDIT_CHARLOTTE_MATTHEWS_CAPS" );
		addSubLeftName( &"CREDIT_TODD_STANTON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ORCHESTRATIONS_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_DAVID_BUCKLEY_CAPS" );
		addSubLeftName( &"CREDIT_STEPHEN_BARTON_CAPS" );
		addSubLeftName( &"CREDIT_LADD_MCINTOSH_CAPS" );
		addSubLeftName( &"CREDIT_HALLI_CAUTHERY_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_COPYISTS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ANN_MILLER_CAPS" );
		addSubLeftName( &"CREDIT_TED_MILLER_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_STRING_OVERDUBS_BY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_THE_CZECH_PHILHARMONIC_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ARTISTIC_DIRECTOR" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_PAVEL_PRANTL_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_GUITARS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_COSTA_KOTSELAS_CAPS" );
		addSubLeftName( &"CREDIT_PETER_DISTEFANO_CAPS" );
		addSubLeftName( &"CREDIT_JOHN_PARRICELLI_CAPS" );
		addSubLeftName( &"CREDIT_TOBY_CHU_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ELECTRIC_VIOLIN" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_HUGH_MARSH_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_OUD_BOUZOUKI" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_STUART_HALL_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_HURDY_GURDY" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_NICHOLAS_PERRY" );
		addSpace();
		addSubLeftTitle( &"CREDIT_HORN_SOLOS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_RICHARD_WATKINS_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PERCUSSION" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_FRANK_RICOTTI_CAPS" );
		addSubLeftName( &"CREDIT_GARY_KETTEL_CAPS" );
		addSubLeftName( &"CREDIT_PAUL_CLARVIS_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SCORE_RECORDED_AT_ABBEY" );
		addSpaceSmall();
		addSubLeftTitle( &"CREDIT_MUSIC_MIXED_AT_THE_BLUE" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_MILITARY_TECHNICAL_ADVISORS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_LT_COL_HANK_KEIRSEY_US" );
		addLeftName( &"CREDIT_MAJ_KEVIN_COLLINS_USMC" );
		addLeftName( &"CREDIT_EMILIO_CUESTA_USMC_CAPS" );
		addLeftName( &"CREDIT_SGT_MAJ_JAMES_DEVER_1" );
		addLeftName( &"CREDIT_M_SGT_TOM_MINDER_1_FORCE" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_SOUND_EFFECTS_RECORDING" );
		addSpaceSmall();
		addLeftName( &"CREDIT_JOHN_FASAL_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_VIDEO_EDITING" );
		addSpaceSmall();
		addLeftName( &"CREDIT_PETE_BLUMEL_CAPS" );
		addLeftName( &"CREDIT_DREW_MCCOY_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_DESIGN_AND" );
		addSpaceSmall();
		addLeftName( &"CREDIT_BRIAN_GILMAN_CAPS" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_ART" );
		addSpaceSmall();
		addLeftName( &"CREDIT_ANDREW_CLARK_CAPS" );
		addLeftName( &"CREDIT_JAVIER_OJEDA_CAPS" );
		addLeftName( &"CREDIT_JIWON_SON_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_TRANSLATIONS" );
		addSpaceSmall();
		addLeftName( &"CREDIT_APPLIED_LANGUAGES" );
		addLeftName( &"CREDIT_WORLD_LINGO" );
		addLeftName( &"CREDIT_UNIQUE_ARTISTS" );
		addSpace();
		addLeftTitle( &"CREDIT_WEAPON_ARMORERS_AND_RANGE" );
		addSpaceSmall();
		addLeftName( &"CREDIT_GIBBONS_LTD" );
		addLeftName( &"CREDIT_LONG_MOUNTAIN_OUTFITTERS" );
		addLeftName( &"CREDIT_BOB_MAUPIN_RANCH" );
		addSpace();
		addSpace();

		if( level.console && !level.xenon ) // PS3 only
		{
			addLeftTitle( &"CREDIT_ADDITIONAL_PROGRAMMING_DEMONWARE" );
			addSpaceSmall();
			addLeftName( &"CREDIT_SEAN_BLANCHFIELD_CAPS" );
			addLeftName( &"CREDIT_MORGAN_BRICKLEY_CAPS" );
			addLeftName( &"CREDIT_DYLAN_COLLINS_CAPS" );
			addLeftName( &"CREDIT_MICHAEL_COLLINS_CAPS" );
			addLeftName( &"CREDIT_MALCOLM_DOWSE_CAPS" );
			addLeftName( &"CREDIT_STEFFEN_HIGELS_CAPS" );
			addLeftName( &"CREDIT_TONY_KELLY_CAPS" );
			addLeftName( &"CREDIT_JOHN_KIRK_CAPS" );
			addLeftName( &"CREDIT_CRAIG_MCINNES_CAPS" );
			addLeftName( &"CREDIT_ALEX_MONTGOMERY_CAPS" );
			addLeftName( &"CREDIT_EOIN_OFEARGHAIL_CAPS" );
			addLeftName( &"CREDIT_RUAIDHRI_POWER_CAPS" );
			addLeftName( &"CREDIT_TILMAN_SCHAFER_CAPS" );
			addLeftName( &"CREDIT_AMY_SMITH_CAPS" );
			addLeftName( &"CREDIT_EMMANUEL_STONE_CAPS" );
			addLeftName( &"CREDIT_ROB_SYNNOTT_CAPS" );
			addLeftName( &"CREDIT_VLAD_TITOV_CAPS" );
			addSpace();
			addSpace();
		}
		
		addLeftTitle( &"CREDIT_ADDITIONAL_ART_PROVIDED_ANT_FARM" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PRODUCER" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_SCOTT_CARSON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_SENIOR_EDITOR" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_SCOTT_COOKSON_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ASSOCIATE_PRODUCER" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_SETH_HENDRIX_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_EXECUTIVE_CREATIVE_DIRECTORS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_LISA_RIZNIKOVE_CAPS" );
		addSubLeftName( &"CREDIT_ROB_TROY_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_VOICE_RECORDING_FACILITIES" );
		addSpace();
		addSubLeftTitle( &"CREDIT_PCB_PRODUCTIONS" );
		addSubLeftTitle( &"CREDIT_SIDEUK" );
		addSpace();
		addSubLeftTitle( &"CREDIT_VOICE_DIRECTIONDIALOG" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_KEITH_AREM_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ADDITIONAL_DIALOG_ENGINEERING" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ANT_HALES_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_ADDITIONAL_VOICE_DIRECTION" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		addSubLeftName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_MOTION_CAPTURE_PROVIDED" );
		addSpace();
		addSubLeftTitle( &"CREDIT_MOTION_CAPTURE_LEAD" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_KRISTINA_ADELMEYER_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_MOTION_CAPTURE_TECHNICIANS" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_KRISTIN_GALLAGHER_CAPS" );
		addSubLeftName( &"CREDIT_JEFF_SWENTY_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_MOTION_CAPTURE_INTERN" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_JORGE_LOPEZ_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_STUNT_ACTION_DESIGNED" );
		addSpace();
		addSubLeftTitle( &"CREDIT_STUNT_COORDINATOR" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_DANNY_HERNANDEZ_CAPS" );
		addSpace();
		addSubLeftTitle( &"CREDIT_STUNTSMOTION_CAPTURE" );
		addSpaceSmall();
		addSubLeftName( &"CREDIT_ROBERT_ALONSO_CAPS" );
		addSubLeftName( &"CREDIT_DANNY_HERNANDEZ_CAPS" );
		addSubLeftName( &"CREDIT_ALLEN_JO_CAPS" );
		addSubLeftName( &"CREDIT_DAVID_LEITCH_CAPS" );
		addSubLeftName( &"CREDIT_MIKE_MUKATIS_CAPS" );
		addSubLeftName( &"CREDIT_RYAN_WATSON_CAPS" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_CINEMATIC_MOVIES_PROVIDED" );
		addSpace();
		addLeftTitle( &"CREDIT_VEHICLES_PROVIDED_BY" );
		addSpace();

		if( !level.console ) // PC only
		{
			addLeftTitle( &"CREDIT_ADDITIONAL_PROGRAMMING_EVEN_BALANCE" );
			addSpace();
		}
		
		addLeftTitle( &"CREDIT_ADDITIONAL_ART_PROVIDED" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_SOUND_DESIGN" );
		addSpace();
		addLeftTitle( &"CREDIT_ADDITIONAL_AUDIO_ENGINEERING_DIGITAL_SYNAPSE" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_PRODUCTION_BABIES" );
		addSpaceSmall();
		addLeftName( &"CREDIT_BABY_COLIN_ALDERMAN" );
		addLeftName( &"CREDIT_BABY_LUKE_SMITH" );
		addLeftName( &"CREDIT_BABY_JOHN_GALT_WEST_JACK" );
		addLeftName( &"CREDIT_BABY_COURTNEY_ZAMPELLA" );
		addSpace();
		addSpace();
		addLeftTitle( &"CREDIT_INFINITY_WARD_SPECIAL" );
		addSpaceSmall();
		addLeftName( &"CREDIT_USMC_PUBLIC_AFFAIRS_OFFICE" );
		addLeftName( &"CREDIT_USMC_1ST_TANK_BATTALION" );
		addLeftName( &"CREDIT_MARINE_LIGHT_ATTACK_HELICOPTER" );
		addLeftName( &"CREDIT_USMC_5TH_BATTALION_14TH" );
		addLeftName( &"CREDIT_ARMY_1ST_CAVALRY_DIVISION" );
		addSpace();
		addLeftName( &"CREDIT_DAVE_DOUGLAS_CAPS" );
		addLeftName( &"CREDIT_DAVID_FALICKI_CAPS" );
		addLeftName( &"CREDIT_ROCK_GALLOTTI_CAPS" );
		addLeftName( &"CREDIT_MICHAEL_GIBBONS_CAPS" );
		addLeftName( &"CREDIT_LAWRENCE_GREEN_CAPS" );
		addLeftName( &"CREDIT_ANDREW_HOFFACKER_CAPS" );
		addLeftName( &"CREDIT_JD_KEIRSEY_CAPS" );
		addLeftName( &"CREDIT_ROBERT_MAUPIN_CAPS" );
		addLeftName( &"CREDIT_BRIAN_MAYNARD_CAPS" );
		addLeftName( &"CREDIT_LARRY_ZANOFF_CAPS" );
		addLeftName( &"CREDIT_CALEB_BARNHART_CAPS" );
		addLeftName( &"CREDIT_JOHN_BUDD_CAPS" );
		addLeftName( &"CREDIT_SCOTT_CARPENTER_CAPS" );
		addLeftName( &"CREDIT_JOSHUA_CARRILLO_CAPS" );
		addLeftName( &"CREDIT_DAVID_COFFEY_CAPS" );
		addLeftName( &"CREDIT_CHRISTOPHER_DARE_CAPS" );
		addLeftName( &"CREDIT_NICK_DUNCAN_CAPS" );
		addLeftName( &"CREDIT_JOSE_GO_JR_CAPS" );
		addLeftName( &"CREDIT_JEREMY_HULL_CAPS" );
		addLeftName( &"CREDIT_GORDON_JAMES_CAPS" );
		addLeftName( &"CREDIT_STEVEN_JONES_CAPS" );
		addLeftName( &"CREDIT_MICHAEL_LISCOTTI_CAPS" );
		addLeftName( &"CREDIT_STEPHANIE_MARTINEZ_CAPS" );
		addLeftName( &"CREDIT_C_ANTHONY_MARQUEZ_CAPS" );
		addLeftName( &"CREDIT_CODY_MAUTER_CAPS" );
		addLeftName( &"CREDIT_JOSEPH_MCCREARY_CAPS" );
		addLeftName( &"CREDIT_GREG_MESSINGER_CAPS" );
		addLeftName( &"CREDIT_MICHAEL_RETZLAFF_CAPS" );
		addLeftName( &"CREDIT_ANGEL_SANCHEZ_CAPS" );
		addLeftName( &"CREDIT_KYLE_SMITH_CAPS" );
		addLeftName( &"CREDIT_ALAN_STERN_CAPS" );
		addLeftName( &"CREDIT_ANGEL_TORRES_CAPS" );
		addLeftName( &"CREDIT_OSCAR_VILLAMOR" );
		addLeftName( &"CREDIT_LARRY_ZENG_CAPS" );
		addSpace();
		addSpace();
		addSpace();
		addSpace();*/
	}
	else
	{
		addCenterImage( "logo_infinityward", 256, 128, 4.375 ); //3.5
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_PROJECT_LEAD", &"CREDIT_JASON_WEST_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_ENGINEERING_LEADS", &"CREDIT_RICHARD_BAKER_CAPS" );
		addCenterName( &"CREDIT_ROBERT_FIELD_CAPS" );
		addCenterName( &"CREDIT_FRANCESCO_GIGLIOTTI_CAPS" );
		addCenterName( &"CREDIT_EARL_HAMMON_JR_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_ENGINEERING", &"CREDIT_CHAD_BARB_CAPS" );
		addCenterName( &"CREDIT_ALESSANDRO_BARTOLUCCI_CAPS" );
		addCenterName( &"CREDIT_JON_DAVIS_CAPS" );
		addCenterName( &"CREDIT_JOEL_GOMPERT_CAPS" );
		addCenterName( &"CREDIT_JOHN_HAGGERTY_CAPS" );
		addCenterName( &"CREDIT_JON_SHIRING_CAPS" );
		addCenterName( &"CREDIT_JIESANG_SONG_CAPS" );
		addCenterName( &"CREDIT_RAYME_VINSON_CAPS" );
		addCenterName( &"CREDIT_ANDREW_WANG_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_DESIGN_LEADS", &"CREDIT_TODD_ALDERMAN_CAPS" );
		addCenterName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		addCenterName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		addCenterName( &"CREDIT_ZIED_RIEKE_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_DESIGN_AND_SCRIPTING", &"CREDIT_ROGER_ABRAHAMSSON_CAPS" );
		addCenterName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
		addCenterName( &"CREDIT_KEITH_BELL_CAPS" );
		addCenterName( &"CREDIT_PRESTON_GLENN_CAPS" );
		addCenterName( &"CREDIT_CHAD_GRENIER_CAPS" );
		addCenterName( &"CREDIT_JAKE_KEATING_CAPS" );
		addCenterName( &"CREDIT_JULIAN_LUO_CAPS" );
		addCenterName( &"CREDIT_STEVE_MASSEY_CAPS" );
		addCenterName( &"CREDIT_BRENT_MCLEOD_CAPS" );
		addCenterName( &"CREDIT_JON_PORTER_CAPS" );
		addCenterName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
		addCenterName( &"CREDIT_NATHAN_SILVERS_CAPS" );
		addCenterName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_ART_DIRECTOR", &"CREDIT_RICHARD_KRIEGLER_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_TECHNICAL_ART_DIRECTOR", &"CREDIT_MICHAEL_BOON_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_ART_LEADS", &"CREDIT_CHRIS_CHERUBINI_CAPS" );
		addCenterName( &"CREDIT_JOEL_EMSLIE_CAPS" );
		addCenterName( &"CREDIT_ROBERT_GAINES_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_ART", &"CREDIT_BRAD_ALLEN_CAPS" );
		addCenterName( &"CREDIT_PETER_CHEN_CAPS" );
		addCenterName( &"CREDIT_JEFF_HEATH_CAPS" );
		addCenterName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
		addCenterName( &"CREDIT_OSCAR_LOPEZ_CAPS" );
		addCenterName( &"CREDIT_HERBERT_LOWIS_CAPS" );
		addCenterName( &"CREDIT_TAEHOON_OH_CAPS" );
		addCenterName( &"CREDIT_SAMI_ONUR_CAPS" );
		addCenterName( &"CREDIT_VELINDA_PELAYO_CAPS" );
		addCenterName( &"CREDIT_RICHARD_SMITH_CAPS" );
		addCenterName( &"CREDIT_THEERAPOL_SRISUPHAN_CAPS" );
		addCenterName( &"CREDIT_TODD_SUE_CAPS" );
		addCenterName( &"CREDIT_SOMPOOM_TANGCHUPONG_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_ANIMATION_LEADS", &"CREDIT_MARK_GRIGSBY_CAPS" );
		addCenterName( &"CREDIT_PAUL_MESSERLY_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_ANIMATION", &"CREDIT_CHANCE_GLASCO_CAPS" );
		addCenterName( &"CREDIT_EMILY_RULE_CAPS" );
		addCenterName( &"CREDIT_ZACH_VOLKER_CAPS" );
		addCenterName( &"CREDIT_LEI_YANG_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_TECHNICAL_ANIMATION_LEAD", &"CREDIT_ERIC_PIERCE_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_TECHNICAL_ANIMATION", &"CREDIT_NEEL_KAR_CAPS" );
		addCenterName( &"CREDIT_CHENG_LOR_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_AUDIO_LEAD", &"CREDIT_MARK_GANUS_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_AUDIO", &"CREDIT_CHRISSY_ARYA_CAPS" );
		addCenterName( &"CREDIT_STEPHEN_MILLER_CAPS" );
		addCenterName( &"CREDIT_LINDA_ROSEMEIER_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_WRITTEN_BY", &"CREDIT_JESSE_STERN_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_ADDITIONAL_WRITING", &"CREDIT_STEVE_FUKUDA_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_STORY_BY", &"CREDIT_TODD_ALDERMAN_CAPS" );
		addCenterName( &"CREDIT_STEVE_FUKUDA_CAPS" );
		addCenterName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		addCenterName( &"CREDIT_ZIED_RIEKE_CAPS" );
		addCenterName( &"CREDIT_JESSE_STERN_CAPS" );
		addCenterName( &"CREDIT_JASON_WEST_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_STUDIO_HEADS", &"CREDIT_GRANT_COLLIER_CAPS" );
		addCenterName( &"CREDIT_JASON_WEST_CAPS" );
		addCenterName( &"CREDIT_VINCE_ZAMPELLA_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_PRODUCER", &"CREDIT_MARK_RUBIN_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_ASSOCIATE_PRODUCER", &"CREDIT_PETE_BLUMEL_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_OFFICE_MANAGER", &"CREDIT_JANICE_TURNER_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_HUMAN_RESOURCES_GENERALIST", &"CREDIT_KRISTIN_COTTERELL_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_EXECUTIVE_ASSISTANT", &"CREDIT_NICOLE_SCATES_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_ADMINISTRATIVE_ASSISTANT", &"CREDIT_CARLY_GILLIS_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_COMMUNITY_RELATIONS_MANAGER", &"CREDIT_ROBERT_BOWLING_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_INFORMATION_TECHNOLOGY_LEAD", &"CREDIT_BRYAN_KUHN_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_INFORMATION_TECHNOLOGY", &"CREDIT_DREW_MCCOY_CAPS" );
		addCenterName( &"CREDIT_ALEXANDER_SHARRIGAN_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_QUALITY_ASSURANCE_LEADS", &"CREDIT_JEMUEL_GARNETT_CAPS" );
		addCenterName( &"CREDIT_ED_HARMER_CAPS" );
		addCenterName( &"CREDIT_JUSTIN_HARRIS_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_QUALITY_ASSURANCE", &"CREDIT_BRYAN_ANKER_CAPS" );
		addCenterName( &"CREDIT_ADRIENNE_ARRASMITH_CAPS" );
		addCenterName( &"CREDIT_ESTEVAN_BECERRA_CAPS" );
		addCenterName( &"CREDIT_REILLY_CAMPBELL_CAPS" );
		addCenterName( &"CREDIT_DIMITRI_DEL_CASTILLO_CAPS" );
		addCenterName( &"CREDIT_SHAMENE_CHILDRESS_CAPS" );
		addCenterName( &"CREDIT_WILLIAM_CHO_CAPS" );
		addCenterName( &"CREDIT_RICHARD_GARCIA_CAPS" );
		addCenterName( &"CREDIT_DANIEL_GERMANN_CAPS" );
		addCenterName( &"CREDIT_EVAN_HATCH_CAPS" );
		addCenterName( &"CREDIT_TAN_LA_CAPS" );
		addCenterName( &"CREDIT_RENE_LARA_CAPS" );
		addCenterName( &"CREDIT_STEVE_LOUIS_CAPS" );
		addCenterName( &"CREDIT_ALEX_MEJIA_CAPS" );
		addCenterName( &"CREDIT_MATT_MILLER_CAPS" );
		addCenterName( &"CREDIT_CHRISTIAN_MURILLO_CAPS" );
		addCenterName( &"CREDIT_GAVIN_NIEBEL_CAPS" );
		addCenterName( &"CREDIT_NORMAN_OVANDO_CAPS" );
		addCenterName( &"CREDIT_JUAN_RAMIREZ_CAPS" );
		addCenterName( &"CREDIT_ROBERT_RITER_CAPS" );
		addCenterName( &"CREDIT_BRIAN_ROYCEWICZ_CAPS" );
		addCenterName( &"CREDIT_TRISTEN_SAKURADA_CAPS" );
		addCenterName( &"CREDIT_KEANE_TANOUYE_CAPS" );
		addCenterName( &"CREDIT_JASON_TOM_CAPS" );
		addCenterName( &"CREDIT_MAX_VO_CAPS" );
		addCenterName( &"CREDIT_BRANDON_WILLIS_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_INTERNS", &"CREDIT_MICHAEL_ANDERSON_CAPS" );
		addCenterName( &"CREDIT_JASON_BOESCH_CAPS" );
		addCenterName( &"CREDIT_ARTURO_CABALLERO_CAPS" );
		addCenterName( &"CREDIT_DERRIC_EADY_CAPS" );
		addCenterName( &"CREDIT_DANIEL_EDWARDS_CAPS" );
		addCenterName( &"CREDIT_ALDRIC_SAUCIER_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_VOICE_TALENT", &"CREDIT_BILLY_MURRAY_CAPS" );
		addCenterName( &"CREDIT_CRAIG_FAIRBRASS_CAPS" );
		addCenterName( &"CREDIT_DAVID_SOBOLOV_CAPS" );
		addCenterName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		addCenterName( &"CREDIT_ZACH_HANKS_CAPS" );
		addCenterName( &"CREDIT_FRED_TOMA_CAPS" );
		addCenterName( &"CREDIT_EUGENE_LAZAREB_CAPS" );
		addSpaceSmall();
		addCenterDual( &"CREDIT_ADDITIONAL_VOICE_TALENT", &"CREDIT_GABRIEL_ALRAJHI_CAPS" );
		addCenterName( &"CREDIT_SARKIS_ALBERT_CAPS" );
		addCenterName( &"CREDIT_DESMOND_ASKEW_CAPS" );
		addCenterName( &"CREDIT_DAVID_NEIL_BLACK_CAPS" );
		addCenterName( &"CREDIT_MARCUS_COLOMA_CAPS" );
		addCenterName( &"CREDIT_MICHAEL_CUDLITZ_CAPS" );
		addCenterName( &"CREDIT_GREG_ELLIS_CAPS" );
		addCenterName( &"CREDIT_GIDEON_EMERY_CAPS" );
		addCenterName( &"CREDIT_JOSH_GILMAN_CAPS" );
		addCenterName( &"CREDIT_MICHAEL_GOUGH_CAPS" );
		addCenterName( &"CREDIT_ANNA_GRAVES_CAPS" );
		addCenterName( &"CREDIT_SVEN_HOLMBERG_CAPS" );
		addCenterName( &"CREDIT_MARK_IVANIR_CAPS" );
		addCenterName( &"CREDIT_QUENTIN_JONES_CAPS" );
		addCenterName( &"CREDIT_ARMANDO_VALDESKENNEDY_CAPS" );
		addCenterName( &"CREDIT_BORIS_KIEVSKY_CAPS" );
		addCenterName( &"CREDIT_RJ_KNOLL_CAPS" );
		addCenterName( &"CREDIT_KRISTOF_KONRAD_CAPS" );
		addCenterName( &"CREDIT_DAVE_MALLOW_CAPS" );
		addCenterName( &"CREDIT_JORDAN_MARDER_CAPS" );
		addCenterName( &"CREDIT_SAM_SAKO_CAPS" );
		addCenterName( &"CREDIT_HARRY_VAN_GORKUM_CAPS" );
		addSpace();
		addSpace();
		addCenterDual( &"CREDIT_MODELS", &"CREDIT_MUNEER_ABDELHADI_CAPS" );
		addCenterName( &"CREDIT_MOHAMMAD_ALAVI_CAPS" );
		addCenterName( &"CREDIT_JESUS_ANGUIANO_CAPS" );
		addCenterName( &"CREDIT_CHAD_BAKKE_CAPS" );
		addCenterName( &"CREDIT_PETER_CHEN_CAPS" );
		addCenterName( &"CREDIT_KEVIN_COLLINS_CAPS" );
		addCenterName( &"CREDIT_HUGH_DALY_CAPS" );
		addCenterName( &"CREDIT_DERRIC_EADY_CAPS" );
		addCenterName( &"CREDIT_SUREN_GAZARYAN_CAPS" );
		addCenterName( &"CREDIT_CHAD_GRENIER_CAPS" );
		addCenterName( &"CREDIT_MARK_GRIGSBY_CAPS" );
		addCenterName( &"CREDIT_JUSTIN_HARRIS_CAPS" );
		addCenterName( &"CREDIT_CLIVE_HAWKINS_CAPS" );
		addCenterName( &"CREDIT_STEVEN_JONES_CAPS" );
		addCenterName( &"CREDIT_DAVID_KLEC_CAPS" );
		addCenterName( &"CREDIT_JOSHUA_LACROSSE_CAPS" );
		addCenterName( &"CREDIT_RYAN_LASTIMOSA_CAPS" );
		addCenterName( &"CREDIT_JAMES_LITTLEJOHN_CAPS" );
		addCenterName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
		addCenterName( &"CREDIT_TOM_MINDER_CAPS" );
		addCenterName( &"CREDIT_SAMI_ONUR_CAPS" );
		addCenterName( &"CREDIT_VELINDA_PELAYO_CAPS" );
		addCenterName( &"CREDIT_MARTIN_RESOAGLI_CAPS" );
		addCenterName( &"CREDIT_ZIED_RIEKE_CAPS" );
		addCenterName( &"CREDIT_ALEXANDER_ROYCEWICZ_CAPS" );
		addCenterName( &"CREDIT_JOSE_RUBEN_AGUILAR_JR_CAPS" );
		addCenterName( &"CREDIT_GEOFFREY_SMITH_CAPS" );
		addCenterName( &"CREDIT_TODD_SUE_CAPS" );
		addCenterName( &"CREDIT_EID_TOLBA_CAPS" );
		addCenterName( &"CREDIT_ZACH_VOLKER_CAPS" );
		addCenterName( &"CREDIT_JASON_WEST_CAPS" );
		addCenterName( &"CREDIT_HENRY_YORK_CAPS" );
		addSpace();
		addSpace();
	}

	addCenterHeading( &"CREDIT_ORIGINAL_SCORE" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_THEME_BY", &"CREDIT_HARRY_GREGSONWILLIAMS_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PRODUCED_BY", &"CREDIT_HARRY_GREGSONWILLIAMS_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MUSIC_BY", &"CREDIT_STEPHEN_BARTON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SCORE_SUPERVISOR", &"CREDIT_ALLISON_WRIGHT_CLARK_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_AMBIENT_MUSIC_DESIGN", &"CREDIT_MEL_WESSON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SCORE_PERFORMED_BY", &"CREDIT_THE_LONDON_SESSION_ORCHESTRA_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SCORING_ENGINEER", &"CREDIT_JONATHAN_ALLEN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SCORING_MIXER", &"CREDIT_MALCOLM_LUKER_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PROTOOLS_ENGINEERS", &"CREDIT_JAMIE_LUKER_CAPS" );
	addCenterName( &"CREDIT_SCRAP_MARSHALL_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ORCHESTRA_CONTRACTORS", &"CREDIT_ISOBEL_GRIFFITHS_CAPS" );
	addCenterName( &"CREDIT_CHARLOTTE_MATTHEWS_CAPS" );
	addCenterName( &"CREDIT_TODD_STANTON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ORCHESTRATIONS_BY", &"CREDIT_DAVID_BUCKLEY_CAPS" );
	addCenterName( &"CREDIT_STEPHEN_BARTON_CAPS" );
	addCenterName( &"CREDIT_LADD_MCINTOSH_CAPS" );
	addCenterName( &"CREDIT_HALLI_CAUTHERY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_COPYISTS", &"CREDIT_ANN_MILLER_CAPS" );
	addCenterName( &"CREDIT_TED_MILLER_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_STRING_OVERDUBS_BY", &"CREDIT_THE_CZECH_PHILHARMONIC_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ARTISTIC_DIRECTOR", &"CREDIT_PAVEL_PRANTL_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_GUITARS", &"CREDIT_COSTA_KOTSELAS_CAPS" );
	addCenterName( &"CREDIT_PETER_DISTEFANO_CAPS" );
	addCenterName( &"CREDIT_JOHN_PARRICELLI_CAPS" );
	addCenterName( &"CREDIT_TOBY_CHU_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ELECTRIC_VIOLIN", &"CREDIT_HUGH_MARSH_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_OUD_BOUZOUKI", &"CREDIT_STUART_HALL_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_HURDY_GURDY", &"CREDIT_NICHOLAS_PERRY" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_HORN_SOLOS", &"CREDIT_RICHARD_WATKINS_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PERCUSSION", &"CREDIT_FRANK_RICOTTI_CAPS" );
	addCenterName( &"CREDIT_GARY_KETTEL_CAPS" );
	addCenterName( &"CREDIT_PAUL_CLARVIS_CAPS" );
	addSpace();
	addCenterHeading( &"CREDIT_SCORE_RECORDED_AT_ABBEY" );
	addSpaceSmall();
	addCenterHeading( &"CREDIT_MUSIC_MIXED_AT_THE_BLUE" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_MILITARY_TECHNICAL_ADVISORS", &"CREDIT_LT_COL_HANK_KEIRSEY_US" );
	addCenterName( &"CREDIT_MAJ_KEVIN_COLLINS_USMC" );
	addCenterName( &"CREDIT_EMILIO_CUESTA_USMC_CAPS" );
	addCenterName( &"CREDIT_SGT_MAJ_JAMES_DEVER_1" );
	addCenterName( &"CREDIT_M_SGT_TOM_MINDER_1_FORCE" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_SOUND_EFFECTS_RECORDING", &"CREDIT_JOHN_FASAL_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_VIDEO_EDITING", &"CREDIT_PETE_BLUMEL_CAPS" );
	addCenterName( &"CREDIT_DREW_MCCOY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ADDITIONAL_DESIGN_AND", &"CREDIT_BRIAN_GILMAN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ADDITIONAL_ART", &"CREDIT_ANDREW_CLARK_CAPS" );
	addCenterName( &"CREDIT_JAVIER_OJEDA_CAPS" );
	addCenterName( &"CREDIT_JIWON_SON_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_TRANSLATIONS" );
	addSpaceSmall();
	addCenterHeading( &"CREDIT_APPLIED_LANGUAGES" );
	addCenterHeading( &"CREDIT_WORLD_LINGO" );
	addCenterHeading( &"CREDIT_UNIQUE_ARTISTS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_WEAPON_ARMORERS_AND_RANGE" );
	addSpaceSmall();
	addCenterHeading( &"CREDIT_GIBBONS_LTD" );
	addCenterHeading( &"CREDIT_LONG_MOUNTAIN_OUTFITTERS" );
	addCenterHeading( &"CREDIT_BOB_MAUPIN_RANCH" );
	addSpace();
	addSpace();

	if( level.console && !level.xenon ) // PS3 only
	{

		addCenterHeading( &"CREDIT_ADDITIONAL_PROGRAMMING_DEMONWARE" );
		addSpaceSmall();
		addCenterNameDouble( &"CREDIT_SEAN_BLANCHFIELD_CAPS", &"CREDIT_MORGAN_BRICKLEY_CAPS" );
		addCenterNameDouble( &"CREDIT_DYLAN_COLLINS_CAPS", &"CREDIT_MICHAEL_COLLINS_CAPS" );
		addCenterNameDouble( &"CREDIT_MALCOLM_DOWSE_CAPS", &"CREDIT_STEFFEN_HIGELS_CAPS" );
		addCenterNameDouble( &"CREDIT_TONY_KELLY_CAPS", &"CREDIT_JOHN_KIRK_CAPS" );
		addCenterNameDouble( &"CREDIT_CRAIG_MCINNES_CAPS", &"CREDIT_ALEX_MONTGOMERY_CAPS" );
		addCenterNameDouble( &"CREDIT_EOIN_OFEARGHAIL_CAPS", &"CREDIT_RUAIDHRI_POWER_CAPS" );
		addCenterNameDouble( &"CREDIT_TILMAN_SCHAFER_CAPS", &"CREDIT_AMY_SMITH_CAPS" );
		addCenterNameDouble( &"CREDIT_EMMANUEL_STONE_CAPS", &"CREDIT_ROB_SYNNOTT_CAPS" );
		addCenterNameDouble( &"CREDIT_VLAD_TITOV_CAPS", &"" );
		addSpace();
		addSpace();
	}
	
	addCenterHeading( &"CREDIT_ADDITIONAL_ART_PROVIDED_ANT_FARM" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PRODUCER", &"CREDIT_SCOTT_CARSON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_EDITOR", &"CREDIT_SCOTT_COOKSON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ASSOCIATE_PRODUCER", &"CREDIT_SETH_HENDRIX_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_EXECUTIVE_CREATIVE_DIRECTORS", &"CREDIT_LISA_RIZNIKOVE_CAPS" );
	addCenterName( &"CREDIT_ROB_TROY_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_VOICE_RECORDING_FACILITIES" );
	addSpaceSmall();
	addCenterHeading( &"CREDIT_PCB_PRODUCTIONS" );
	addCenterHeading( &"CREDIT_SIDEUK" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_VOICE_DIRECTIONDIALOG", &"CREDIT_KEITH_AREM_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ADDITIONAL_DIALOG_ENGINEERING", &"CREDIT_ANT_HALES_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ADDITIONAL_VOICE_DIRECTION", &"CREDIT_STEVE_FUKUDA_CAPS" );
	addCenterName( &"CREDIT_MACKEY_MCCANDLISH_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_MOTION_CAPTURE_PROVIDED" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MOTION_CAPTURE_LEAD", &"CREDIT_KRISTINA_ADELMEYER_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MOTION_CAPTURE_TECHNICIANS", &"CREDIT_KRISTIN_GALLAGHER_CAPS" );
	addCenterName( &"CREDIT_JEFF_SWENTY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MOTION_CAPTURE_INTERN", &"CREDIT_JORGE_LOPEZ_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_STUNT_ACTION_DESIGNED" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_STUNT_COORDINATOR", &"CREDIT_DANNY_HERNANDEZ_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_STUNTSMOTION_CAPTURE", &"CREDIT_ROBERT_ALONSO_CAPS" );
	addCenterName( &"CREDIT_DANNY_HERNANDEZ_CAPS" );
	addCenterName( &"CREDIT_ALLEN_JO_CAPS" );
	addCenterName( &"CREDIT_DAVID_LEITCH_CAPS" );
	addCenterName( &"CREDIT_MIKE_MUKATIS_CAPS" );
	addCenterName( &"CREDIT_RYAN_WATSON_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_CINEMATIC_MOVIES_PROVIDED" );
	addSpace();
	addCenterHeading( &"CREDIT_VEHICLES_PROVIDED_BY" );
	addSpace();

	if( !level.console ) // PC only
	{
		addCenterHeading( &"CREDIT_ADDITIONAL_PROGRAMMING_EVEN_BALANCE" );
		addSpace();
	}
	
	addCenterHeading( &"CREDIT_ADDITIONAL_ART_PROVIDED" );
	addSpace();
	addCenterHeading( &"CREDIT_ADDITIONAL_SOUND_DESIGN" );
	addSpace();
	addCenterHeading( &"CREDIT_ADDITIONAL_AUDIO_ENGINEERING_DIGITAL_SYNAPSE" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_PRODUCTION_BABIES" );
	addSpaceSmall();
	addCenterHeading( &"CREDIT_BABY_COLIN_ALDERMAN" );
	addCenterHeading( &"CREDIT_BABY_LUKE_SMITH" );
	addCenterHeading( &"CREDIT_BABY_JOHN_GALT_WEST_JACK" );
	addCenterHeading( &"CREDIT_BABY_COURTNEY_ZAMPELLA" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_INFINITY_WARD_SPECIAL" );
	addSpaceSmall();
	addCenterHeading( &"CREDIT_USMC_PUBLIC_AFFAIRS_OFFICE" );
	addCenterHeading( &"CREDIT_USMC_1ST_TANK_BATTALION" );
	addCenterHeading( &"CREDIT_MARINE_LIGHT_ATTACK_HELICOPTER" );
	addCenterHeading( &"CREDIT_USMC_5TH_BATTALION_14TH" );
	addCenterHeading( &"CREDIT_ARMY_1ST_CAVALRY_DIVISION" );
	addSpace();
	addCenterNameDouble( &"CREDIT_DAVE_DOUGLAS_CAPS", &"CREDIT_DAVID_FALICKI_CAPS" );
	addCenterNameDouble( &"CREDIT_ROCK_GALLOTTI_CAPS", &"CREDIT_MICHAEL_GIBBONS_CAPS" );
	addCenterNameDouble( &"CREDIT_LAWRENCE_GREEN_CAPS", &"CREDIT_ANDREW_HOFFACKER_CAPS" );
	addCenterNameDouble( &"CREDIT_JD_KEIRSEY_CAPS", &"CREDIT_ROBERT_MAUPIN_CAPS" );
	addCenterNameDouble( &"CREDIT_BRIAN_MAYNARD_CAPS", &"CREDIT_LARRY_ZANOFF_CAPS" );
	addCenterNameDouble( &"CREDIT_CALEB_BARNHART_CAPS", &"CREDIT_JOHN_BUDD_CAPS" );
	addCenterNameDouble( &"CREDIT_SCOTT_CARPENTER_CAPS", &"CREDIT_JOSHUA_CARRILLO_CAPS" );
	addCenterNameDouble( &"CREDIT_DAVID_COFFEY_CAPS", &"CREDIT_CHRISTOPHER_DARE_CAPS" );
	addCenterNameDouble( &"CREDIT_NICK_DUNCAN_CAPS", &"CREDIT_JOSE_GO_JR_CAPS" );
	addCenterNameDouble( &"CREDIT_JEREMY_HULL_CAPS", &"CREDIT_GORDON_JAMES_CAPS" );
	addCenterNameDouble( &"CREDIT_STEVEN_JONES_CAPS", &"CREDIT_MICHAEL_LISCOTTI_CAPS" );
	addCenterNameDouble( &"CREDIT_STEPHANIE_MARTINEZ_CAPS", &"CREDIT_C_ANTHONY_MARQUEZ_CAPS" );
	addCenterNameDouble( &"CREDIT_CODY_MAUTER_CAPS", &"CREDIT_JOSEPH_MCCREARY_CAPS" );
	addCenterNameDouble( &"CREDIT_GREG_MESSINGER_CAPS", &"CREDIT_MICHAEL_RETZLAFF_CAPS" );
	addCenterNameDouble( &"CREDIT_ANGEL_SANCHEZ_CAPS", &"CREDIT_KYLE_SMITH_CAPS" );
	addCenterNameDouble( &"CREDIT_ALAN_STERN_CAPS", &"CREDIT_ANGEL_TORRES_CAPS" );
	addCenterNameDouble( &"CREDIT_OSCAR_VILLAMOR", &"CREDIT_LARRY_ZENG_CAPS" );
	addSpace();
	addSpace();
	addSpace();
	addSpace();
}

initActivisionCredits()
{
	addCenterImage( "logo_activision", 256, 128, 3.875 ); // 3.1
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_PRODUCTION" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PRODUCER", &"CREDIT_SAM_NOURIANI_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ASSOCIATE_PRODUCERS", &"CREDIT_NEVEN_DRAVINSKI_CAPS" );
	addCenterName( &"CREDIT_DEREK_RACCA_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PRODUCTION_COORDINATORS", &"CREDIT_RHETT_CHASSEREAU_CAPS" );
	addCenterName( &"CREDIT_VINCENT_FENNEL_CAPS" );
	addCenterName( &"CREDIT_ANDREW_HOFFACKER_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PRODUCTION_TESTER", &"CREDIT_WINYAN_JAMES_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PRODUCTION_INTERN", &"CREDIT_JACOB_THOMPSON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_EXECUTIVE_PRODUCER", &"CREDIT_MARCUS_IREMONGER_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_VICE_PRESIDENT_PRODUCTION", &"CREDIT_STEVE_ACKRICH_CAPS" );
	addCenterName( &"CREDIT_THAINE_LYMAN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_HEAD_OF_PRODUCTION", &"CREDIT_LAIRD_MALAMED_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_GLOBAL_BRAND_MANAGEMENT" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_BRAND_MANAGER", &"CREDIT_TABITHA_HAYES_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ASSOCIATE_BRAND_MANAGER", &"CREDIT_JON_DELODDER_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MARKETING_ASSOCIATE", &"CREDIT_MIKE_RUDIN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_DIRECTOR_GLOBAL_BRAND_MANAGEMENT", &"CREDIT_TOM_SILK_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_PUBLIC_RELATIONS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_PR_MANAGER", &"CREDIT_MIKE_MANTARRO_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_PUBLICIST", &"CREDIT_KATHY_BRICAUD_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_JUNIOR_PUBLICIST", &"CREDIT_ROBERT_TAYLOR_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_PR_DIRECTOR", &"CREDIT_MICHELLE_SCHRODER_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_EUROPEAN_PR_DIRECTOR", &"CREDIT_TIM_PONTING_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_STEP_3", &"CREDIT_WIEBKE_HESS_CAPS" );
	addCenterName( &"CREDIT_JON_LENAWAY_CAPS" );
	addCenterName( &"CREDIT_NEIL_WOOD_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_CENTRAL_LOCALIZATIONS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_DIRECTOR_OF_PRODUCTION", &"CREDIT_BARRY_KEHOE_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_LOCALIZATION_PROJECT", &"CREDIT_FIONA_EBBS_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_LOCALIZATION_CONSULTANT", &"CREDIT_STEPHANIE_OMALLEY_DEMING_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_LOCALIZATION_COORDINATOR", &"CREDIT_CHRIS_OSBERG_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_LOCALIZATION_ENGINEER", &"CREDIT_PHIL_COUNIHAN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_BRAND_MANAGER_EUROPE", &"CREDIT_STEFAN_SEIDEL_CAPS" );
	addSpace();
	addCenterHeading( &"CREDIT_LOCALIZATION_TOOLS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_MARKETING_COMMUNICATIONS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_VICE_PRESIDENT_OF_MARKETING", &"CREDIT_DENISE_WALSH_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_DIRECTOR_OF_MARKETING", &"CREDIT_SUSAN_HALLOCK_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MARKETING_COMMUNICATIONS_MANAGER", &"CREDIT_KAREN_STARR_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MARKETING_COMMUNICATIONS_COORDINATOR", &"CREDIT_KRISTINA_JOLLY_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_BUSINESS_AND_LEGAL_AFFAIRS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_DIRECTOR_GOVERNMENT_AND", &"CREDIT_PHIL_TERZIAN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_TRANSACTIONAL_ATTORNEY", &"CREDIT_TRAVIS_STANSBURY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_PARALEGAL", &"CREDIT_KAP_KANG_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_OPERATIONS_AND_STUDIO" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_DIRECTOR_OF_PRODUCTION", &"CREDIT_SUZAN_RUDE_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_CENTRAL_TECHNOLOGY" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_MANGER_CENTRAL", &"CREDIT_ED_CLUNE_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_JUNIOR_SOFTWARE_ENGINEER", &"CREDIT_RYAN_FORD_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_TECHNICAL_DIRECTOR", &"CREDIT_PAT_GRIFFITH_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_DIRECTOR_TECHNOLOGY", &"CREDIT_JOHN_BOJORQUEZ_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_CENTRAL_AUDIO" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_DIRECTOR_CENTRAL_AUDIO", &"CREDIT_ADAM_LEVENSON_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_MUSIC_DEPARTMENT" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_WORLDWIDE_EXECUTIVE", &"CREDIT_TIM_RILEY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MUSIC_SUPERVISORS", &"CREDIT_SCOTT_MCDANIEL_CAPS" );
	addCenterName( &"CREDIT_BRANDON_YOUNG" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MUSIC_DEPARTMENT_COORDINATOR", &"CREDIT_JONATHAN_BODELL_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_MUSIC" );
	addSpace();
	addCenterHeading( &"CREDIT_CHURCH" );
	addCenterHeading( &"CREDIT_WRITTEN_BY_SEAN_PRICE" );
	addCenterHeading( &"CREDIT_PERFORMED_BY_SEAN_PRICE" );
	addCenterHeading( &"CREDIT_COURTESY_OF_DUCK_DOWN" );
	addSpace();
	addCenterHeading( &"CREDIT_NATIONAL_ANTHEM_OF_THE" );
	addCenterHeading( &"CREDIT_WRITTEN_BY_ANATOLIJ_N" );
	addCenterHeading( &"CREDIT_PERFORMED_BY_THE_RED" );
	addCenterHeading( &"CREDIT_PUBLISHED_BY_G_SCHIRMER" );
	addCenterHeading( &"CREDIT_COURTESY_OF_SILVA_SCREEN" );
	addSpace();
	addCenterHeading( &"CREDIT_RESCUED" );
	addCenterHeading( &"CREDIT_WRITTEN_BY_ABRAHAM_LASS" );
	addCenterHeading( &"CREDIT_PUBLISHED_BY_TRF_MUSIC" );
	addCenterHeading( &"CREDIT_USED_BY_PERMISSION" );
	addSpace();
	addCenterHeading( &"CREDIT_DEEP_AND_HARD" );
	addCenterHeading( &"CREDIT_WRITTEN_BY_MARK_GRIGSBY" );
	addCenterHeading( &"CREDIT_PERFORMED_BY_MARK_GRIGSBY" );
	addCenterHeading( &"CREDIT_MIXED_BY_STEPHEN_MILLER" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_FINANCE" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MANAGER_CONTROLLER", &"CREDIT_JASON_DALBOTTEN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_FINANCE_MANAGER", &"CREDIT_HARJINDER_SINGH_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_FINANCE_ANALYST", &"CREDIT_ADRIAN_GOMEZ_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_ACTIVISION_SPECIAL_THANKS" );
	addSpaceSmall();
	addCenterNameDouble( &"CREDIT_MIKE_GRIFFITH_CAPS", &"CREDIT_ROBIN_KAMINSKY_CAPS" );
	addCenterNameDouble( &"CREDIT_BRIAN_WARD_CAPS", &"CREDIT_DAVE_STOHL_CAPS" );
	addCenterNameDouble( &"CREDIT_STEVE_PEARCE_CAPS", &"CREDIT_WILL_KASSOY_CAPS" );
	addCenterNameDouble( &"CREDIT_DUSTY_WELCH_CAPS", &"CREDIT_LAIRD_MALAMED_CAPS" );
	addCenterNameDouble( &"CREDIT_NOAH_HELLER_CAPS", &"CREDIT_GEOFF_CARROLL_CAPS" );
	addCenterNameDouble( &"CREDIT_SASHA_GROSS_CAPS", &"CREDIT_JEN_FOX_CAPS" );
	addCenterNameDouble( &"CREDIT_MARCHELE_HARDIN_CAPS", &"CREDIT_JB_SPISSO_CAPS" );
	addCenterNameDouble( &"CREDIT_RIC_ROMERO_CAPS", &"" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_QUALITY_ASSURANCE" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_LEAD_QA_FUNCTIONALITY", &"CREDIT_MARIO_HERNANDEZ_CAPS" );
	addCenterName( &"CREDIT_ERIK_MELEN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_LEAD_QA_FUNCTIONALITY", &"CREDIT_EVAN_BUTTON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MANAGER_QA_FUNCTIONALITY", &"CREDIT_GLENN_VISTANTE_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_FLOOR_LEADS_QA_FUNCTIONALITY", &"CREDIT_VICTOR_DURLING_CAPS" );
	addCenterName( &"CREDIT_CHAD_SCHMIDT_CAPS" );
	addCenterName( &"CREDIT_PETER_VON_OY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_QA_DATABASE_ADMINISTRATORS", &"CREDIT_RICH_PEARSON_CAPS" );
	addCenterName( &"CREDIT_CHRIS_SHANLEY_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_QA_TEST_TEAM" );
	addSpaceSmall();
	addCenterTriple( &"CREDIT_DANIEL_ALFARO_CAPS", &"CREDIT_STEVE_ARAUJO_CAPS", &"CREDIT_MIKE_AZAMI_CAPS" );
	addCenterTriple( &"CREDIT_STEFFEN_BOEHME_CAPS", &"CREDIT_JORDAN_BONDHUS_CAPS", &"CREDIT_BRYAN_CHAMCHOUM_CAPS" );
	addCenterTriple( &"CREDIT_DILLON_CHANCE_CAPS", &"CREDIT_RYAN_CHANN_CAPS", &"CREDIT_ERIC_CHEVEZ_CAPS" );
	addCenterTriple( &"CREDIT_CHRISTOPHER_CODDING_CAPS", &"CREDIT_RYAN_DEAL_CAPS", &"CREDIT_JON_EARNEST_CAPS" );
	addCenterTriple( &"CREDIT_ISAAC_FISCHER_CAPS", &"CREDIT_DEVIN_GEE_CAPS", &"CREDIT_GIOVANNI_FUNES_CAPS" );
	addCenterTriple( &"CREDIT_MIKE_GENADRY_CAPS", &"CREDIT_MARC_GOGOSHIAN_CAPS", &"CREDIT_ERIC_GOLDIN_CAPS" );
	addCenterTriple( &"CREDIT_SHON_GRAY_CAPS", &"CREDIT_JONATHON_HAMNER_CAPS", &"CREDIT_SHAWN_HESTLEY_CAPS" );
	addCenterTriple( &"CREDIT_DEMETRIUS_HOSTON_CAPS", &"CREDIT_CARSON_KEENE_CAPS", &"CREDIT_NATE_KINNEY_CAPS" );
	addCenterTriple( &"CREDIT_DEVIN_MCGOWAN_CAPS", &"CREDIT_MICHAEL_LOYD_CAPS", &"CREDIT_JULIO_MEDINA_CAPS" );
	addCenterTriple( &"CREDIT_JULIAN_NAYDICHEV_CAPS", &"CREDIT_KENNETH_OLIPHANT_CAPS", &"CREDIT_RODOLFO_ORTEGA_CAPS" );
	addCenterTriple( &"CREDIT_DAVID_PARKER_CAPS", &"CREDIT_ADRIAN_PEREZ_CAPS", &"CREDIT_BRIAN_PUSCHELL_CAPS" );
	addCenterTriple( &"CREDIT_CRYSTAL_PUSCHELL_CAPS", &"CREDIT_JASON_RALYA_CAPS", &"CREDIT_JUSTIN_REID_CAPS" );
	addCenterTriple( &"CREDIT_MATTHEW_RICHARDSON_CAPS", &"CREDIT_JOHN_RIGGS_CAPS", &"CREDIT_JESSE_RIOS_CAPS" );
	addCenterTriple( &"CREDIT_ERNIE_RITTACCO_CAPS", &"CREDIT_HEATHER_RIVERA_CAPS", &"CREDIT_MARVIN_RIVERA_CAPS" );
	addCenterTriple( &"CREDIT_HOWARD_RODELO_CAPS", &"CREDIT_PEDRO_RODRIGUEZ_CAPS", &"CREDIT_DAN_ROHAN_CAPS" );
	addCenterTriple( &"CREDIT_JEFF_ROPER_CAPS", &"CREDIT_JONATHAN_SANCHEZ_CAPS", &"CREDIT_MICHAEL_SANCHEZ_CAPS" );
	addCenterTriple( &"CREDIT_JUSTIN_SCHUBER_CAPS", &"CREDIT_ANTHONY_SEALES_CAPS", &"CREDIT_SPENCER_SHERMAN_CAPS" );
	addCenterTriple( &"CREDIT_CHRISTOPHER_SIAPERAS_CAPS", &"CREDIT_JEREMY_SMITH_CAPS", &"CREDIT_MICHAEL_STEFFAN_CAPS" );
	addCenterTriple( &"CREDIT_JASON_STRAUMAN_CAPS", &"CREDIT_BYRON_TAYLOR_CAPS", &"CREDIT_JASON_VEGA_CAPS" );
	addCenterTriple( &"CREDIT_JOHN_VINSON_CAPS", &"CREDIT_BYRON_WEDDERBURN_CAPS", &"CREDIT_BRIAN_WILLIAMS_CAPS" );
	addCenterTriple( &"CREDIT_CHRIS_WOLF_CAPS", &"CREDIT_ROSS_YANCEY_CAPS", &"CREDIT_ROBERT_YI_CAPS" );
	addCenterTriple( &"CREDIT_MOISES_ZET_CAPS", "", &"CREDIT_GREG_ZHENG_CAPS" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_NIGHT_SHIFT_LEAD_QA_FUNCTIONALITY", &"CREDIT_BARO_JUNG_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_NIGHT_SHIFT_PROJECT_LEAD", &"CREDIT_TOM_CHUA_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_NIGHT_SHIFT_SENIOR_LEAD", &"CREDIT_PAUL_COLBERT_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_NIGHT_SHIFT_MANAGER_QA", &"CREDIT_ADAM_HARTSFIELD_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_NIGHT_SHIFT_FLOOR_LEADS", &"CREDIT_JULIUS_HIPOLITO_CAPS" );
	addCenterName( &"CREDIT_ELIAS_JIMENEZ_CAPS" );
	addCenterName( &"CREDIT_JAY_MENCONI_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_NIGHT_SHIFT_QA_TEST_TEAM" );
	addSpaceSmall();
	addCenterNameDouble( &"CREDIT_KEVIN_ARREAGA_CAPS", &"CREDIT_TIFFANY_BEHJOHN_ASGHARY" );
	addCenterNameDouble( &"CREDIT_BENJAMIN_BARBER_CAPS", &"CREDIT_GERALD_BECKER_CAPS" );
	addCenterNameDouble( &"CREDIT_NIYA_GREEN_CAPS", &"CREDIT_RANDALL_HERMAN_CAPS" );
	addCenterNameDouble( &"CREDIT_ANDREW_JONES_CAPS", &"CREDIT_JEFF_MITCHELL_CAPS" );
	addCenterNameDouble( &"CREDIT_JIMMIE_POTTS_CAPS", &"CREDIT_ARON_SCHOOLING_CAPS" );
	addCenterNameDouble( &"CREDIT_AARON_SMITH_CAPS", &"CREDIT_DENNIS_SOH_CAPS" );
	addCenterNameDouble( &"CREDIT_JORGE_VALLADARES_CAPS", &"CREDIT_JIMMY_YANG_CAPS" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_TRG_SENIOR_MANAGER", &"CREDIT_CHRISTOPHER_WILSON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_TRG_SUBMISSIONS_LEAD", &"CREDIT_DAN_NICHOLS_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_TRG_PLATFORM_LEAD", &"CREDIT_MARC_VILLANUEVA_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_TRG_PROJECT_LEAD", &"CREDIT_JOAQUIN_MEZA_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_CRG_PROJECT_LEAD", &"CREDIT_JEF_SEDIVY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_TRG_FLOOR_LEADS", &"CREDIT_JARED_BACA_CAPS" );
	addCenterName( &"CREDIT_TEAK_HOLLEY_CAPS" );
	addCenterName( &"CREDIT_DAVID_WILKINSON_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_TRG_TESTERS" );
	addSpaceSmall();
	addCenterNameDouble( &"CREDIT_WILLIAM_CAMACHO_CAPS", &"CREDIT_PISOTH_CHHAM_CAPS" );
	addCenterNameDouble( &"CREDIT_JASON_GARZA_CAPS", &"CREDIT_CHRISTIAN_HAILE_CAPS" );
	addCenterNameDouble( &"CREDIT_ALEX_HIRSCH_CAPS", &"CREDIT_MARTIN_QUINN_CAPS" );
	addCenterNameDouble( &"CREDIT_RHONDA_RAMIREZ_CAPS", &"CREDIT_JAMES_ROSE_CAPS" );
	addCenterNameDouble( &"CREDIT_MARK_RUZICKA_CAPS", &"CREDIT_JACOB_ZWIRN_CAPS" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_TRG_PLATFORM_LEAD", &"CREDIT_KYLE_CAREY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_TRG_PROJECT_LEAD", &"CREDIT_JASON_HARRIS_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_TRG_FLOOR_LEADS", &"CREDIT_KEITH_KODAMA_CAPS" );
	addCenterName( &"CREDIT_JON_SHELTMIRE_CAPS" );
	addCenterName( &"CREDIT_TOMO_SHIKAMI_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_TRG_TESTERS" );
	addSpaceSmall();
	addCenterNameDouble( &"CREDIT_BENJAMIN_ABEL_CAPS", &"CREDIT_MELVIN_ALLEN_CAPS" );
	addCenterNameDouble( &"CREDIT_ADAM_AZAMI_CAPS", &"CREDIT_BRIAN_BAKER_CAPS" );
	addCenterNameDouble( &"CREDIT_BRYAN_BERRI_CAPS", &"CREDIT_SCOTT_BORAKOVE_CAPS" );
	addCenterNameDouble( &"CREDIT_COLIN_KAWAKAMI_CAPS", &"CREDIT_RYAN_MCCULLOUGH_CAPS" );
	addCenterNameDouble( &"CREDIT_JOHN_MCCURRY_CAPS", &"CREDIT_KIRT_SANCHEZ_CAPS" );
	addCenterNameDouble( &"CREDIT_EDGAR_SUNGA_CAPS", &"" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_LEAD_MULTIPLAYER_LAB", &"CREDIT_GARRETT_OSHIRO_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_FLOOR_LEADS_MULTIPLAYER", &"CREDIT_DOV_CARSON_CAPS" );
	addCenterName( &"CREDIT_LEONARD_RODRIGUEZ_CAPS" );
	addCenterName( &"CREDIT_MICHAEL_THOMSEN_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_MULTIPLAYER_LAB_TESTERS" );
	addSpaceSmall();
	addCenterNameDouble( &"CREDIT_MIKE_ASHTON_CAPS", &"CREDIT_JAN_ERICKSON_CAPS" );
	addCenterNameDouble( &"CREDIT_MATTHEW_FAWBUSH_CAPS", &"CREDIT_FRANCO_FERNANDO_CAPS" );
	addCenterNameDouble( &"CREDIT_ARMOND_GOODIN_CAPS", &"CREDIT_MARIO_IBARRA_CAPS" );
	addCenterNameDouble( &"CREDIT_JESSIE_JONES_CAPS", &"CREDIT_JAEMIN_KANG_CAPS" );
	addCenterNameDouble( &"CREDIT_BRIAN_LAY_CAPS", &"CREDIT_LUKE_LOUDERBACK_CAPS" );
	addCenterNameDouble( &"CREDIT_KAGAN_MAEVERS_CAPS", &"CREDIT_MATT_RYAN_CAPS" );
	addCenterNameDouble( &"CREDIT_JONATHAN_SADKA_CAPS", &"" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_ASSISTED_NETWORK_LAB", &"CREDIT_SEAN_OLSON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_LEAD_NETWORK_LAB", &"CREDIT_FRANCIS_JIMENEZ_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_LEAD_NETWORK_LAB", &"CREDIT_CHRIS_KEIM_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_COMPATIBILITY_TESTERS", &"CREDIT_KEITH_WEBER_CAPS" );
	addCenterName( &"CREDIT_WILLIAM_WHALEY_CAPS" );
	addCenterName( &"CREDIT_BRANDON_GILBRECH_CAPS" );
	addCenterName( &"CREDIT_MIKE_SALWET_CAPS" );
	addCenterName( &"CREDIT_DAMON_COLLAZO_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_COMPATIBILITY_SPECIALIST", &"CREDIT_JON_AN_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_COMPATIBILITY", &"CREDIT_NEAL_BARIZO_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_LEAD_COMPATIBILITY", &"CREDIT_CHRIS_NEAL_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MANAGER_QA_LOCALIZATIONS", &"CREDIT_DAVID_HICKEY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_QA_LOCALIZATION_LEAD", &"CREDIT_CONOR_HARLOW_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_QA_LOCALIZATION_TESTERS" );
	addSpaceSmall();
	addCenterNameDouble( &"CREDIT_ANDREA_APRILE_CAPS", &"CREDIT_SANDRO_ARAFA_CAPS" );
	addCenterNameDouble( &"CREDIT_HUGO_BELLET_CAPS", &"CREDIT_DANIELE_CELEGHIN_CAPS" );
	addCenterNameDouble( &"CREDIT_CARLOS_MARTIN_CHIRINO_CAPS", &"CREDIT_ADRIAN_ECHEGOYEN_CAPS" );
	addCenterNameDouble( &"CREDIT_JORGE_FERNANDEZ_CAPS", &"CREDIT_DANIEL_GARCIA_CAPS" );
	addCenterNameDouble( &"CREDIT_CHRISTOPHE_GEVERT_CAPS", &"CREDIT_FRANZ_HEINRICH_CAPS" );
	addCenterNameDouble( &"CREDIT_CHRISTIAN_HELD_CAPS", &"CREDIT_JACK_OHARA_CAPS" );
	addCenterNameDouble( &"CREDIT_CLEMENT_PRIM_CAPS", &"CREDIT_DENNIS_STIFFEL_CAPS" );
	addCenterNameDouble( &"CREDIT_IGNAZIO_IVAN_VIRGILIO_CAPS", &"" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_BURN_ROOM_COORDINATOR", &"CREDIT_JOULE_MIDDLETON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_BURN_ROOM_STAFF", &"CREDIT_DANNY_FENG_CAPS" );
	addCenterName( &"CREDIT_KAI_HSU_CAPS" );
	addCenterName( &"CREDIT_SEAN_KIM_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MANAGER_CSQA_TECHNOLOGY", &"CREDIT_INDRA_YEE_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_SENIOR_LEAD_QA_MIS", &"CREDIT_DAVE_GARCIAGOMEZ_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_QA_MIS_TECHNICIANS", &"CREDIT_TEDDY_HWANG_CAPS" );
	addCenterName( &"CREDIT_BRIAN_MARTIN_CAPS" );
	addCenterName( &"CREDIT_JEREMY_TORRES_CAPS" );
	addCenterName( &"CREDIT_LAWRENCE_WEI_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_EQUIPMENT_COORDINATORS", &"CREDIT_KARLENE_BROWN_CAPS" );
	addCenterName( &"CREDIT_LONG_LE_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PROJECT_LEAD_DATABASE", &"CREDIT_JEREMY_RICHARD_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_FLOOR_LEAD_DATABASE_GROUP", &"CREDIT_KELLY_HUFFINE_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_DATABASE_GROUP_ADMINISTRATORS", &"CREDIT_JACOB_PORTER_CAPS" );
	addCenterName( &"CREDIT_TIMOTHY_TOLEDO_CAPS" );
	addCenterName( &"CREDIT_GEOFF_OLSEN_CAPS" );
	addCenterName( &"CREDIT_CHRISTOPHER_SHANLEY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_STAFFING_SUPERVISOR", &"CREDIT_JENNIFER_VITIELLO_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_QA_OPERATIONS_COORDINATOR", &"CREDIT_JEREMY_SHORTELL_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_MANAGER_RESOURCE_ADMINISTRATION", &"CREDIT_NADINE_THEUZILLOT_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_ADMINISTRATIVE_ASSISTANT", &"CREDIT_NIKKI_GUILLOTE_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_STAFFING_ASSISTANT", &"CREDIT_LORI_LORENZO_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_VOLT_ONSITE_PROGRAM_MANAGER", &"CREDIT_RACHEL_OVERTON_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_VOLT_ONSITE_PROGRAM_COORDINATOR", &"CREDIT_AILEEN_GALEAS_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_CUSTOMER_SUPPORT_MANAGERS", &"CREDIT_GARY_BOLDUC_CAPS" );
	addCenterName( &"CREDIT_MICHAEL_HILL_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_DIRECTOR_QA_FUNCTIONALITY", &"CREDIT_MARILENA_RIXFORD_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_DIRECTOR_TECHNICAL_REQUIREMENTS", &"CREDIT_JAMES_GALLOWAY_CAPS" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_VICE_PRESIDENT_QUALITY", &"CREDIT_RICH_ROBINSON_CAPS" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_ACTIVISION_QA_SPECIAL" );
	addSpaceSmall();
	addCenterNameDouble( &"CREDIT_MATT_MCCLURE_CAPS", &"CREDIT_JOHN_ROSSER_CAPS" );
	addCenterNameDouble( &"CREDIT_ANTHONY_KOROTKO_CAPS", &"CREDIT_BRAD_SAAVEDRA_CAPS" );
	addCenterNameDouble( &"CREDIT_JASON_POTTER_CAPS", &"CREDIT_HENRY_VILLANUEVA_CAPS" );
	addCenterNameDouble( &"CREDIT_PAUL_WILLIAMS_CAPS", &"CREDIT_THOM_DENICK_CAPS" );
	addCenterNameDouble( &"CREDIT_FRANK_SO_CAPS", &"CREDIT_WILLIE_BOLTON_CAPS" );
	addCenterNameDouble( &"CREDIT_ALEX_COLEMAN_CAPS", &"CREDIT_JEREMY_SHORTELL_CAPS" );
	addSpace();
	addSpace();
	addCenterDual( &"CREDIT_MANUAL_DESIGN", &"CREDIT_IGNITED_MINDS_LLC" );
	addSpaceSmall();
	addCenterDual( &"CREDIT_PACKAGING_DESIGN", &"CREDIT_PETROL" );
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_USES_BINK_VIDEO_COPYRIGHT" );
	addSpace();
	
	if( level.console && !level.xenon )
		addCenterHeading( &"CREDIT_THIS_PRODUCT_USES_FMOD" ); // PS3 only
	else
		addCenterHeading( &"CREDIT_USES_MILES_SOUND_SYSTEM" ); // PC and 360 only
		
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_FONTS_LICENSED_FROM" );
	addSpaceSmall();
	addCenterHeading( &"CREDIT_T26_DIGITAL_TYPE_FOUNDRY" );
	addCenterHeading( &"CREDIT_INTERNATIONAL_TYPEFACE" );
	addCenterHeading( &"CREDIT_MONOTYPE_IMAGING" );
	addSpace();
	addSpace();
	addSpace();
	addSpace();
	addSpace();
	addSpace();
	addCenterHeading( &"CREDIT_THE_CHARACTERS_AND_EVENTS1" );
	addCenterHeading( &"CREDIT_THE_CHARACTERS_AND_EVENTS2" );
}

addLeftTitle( title, textscale )
{
	precacheString( title );

	if( !isdefined( textscale ) )
		textscale = level.linesize;
	
	temp = spawnstruct();
	temp.type = "lefttitle";
	temp.title = title;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addLeftName( name, textscale )
{
	precacheString( name );

	if( !isdefined( textscale ) )
		textscale = level.linesize;
	
	temp = spawnstruct();
	temp.type = "leftname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSubLeftTitle( title, textscale )
{
	addLeftName( title, textscale );
}

addSubLeftName( name, textscale )
{
	precacheString( name );

	if( !isdefined( textscale ) )
		textscale = level.linesize;
	
	temp = spawnstruct();
	temp.type = "subleftname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addRightTitle( title, textscale )
{
	precacheString( title );

	if( !isdefined( textscale ) )
		textscale = level.linesize;
	
	temp = spawnstruct();
	temp.type = "righttitle";
	temp.title = title;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addRightName( name, textscale )
{
	precacheString( name );

	if( !isdefined( textscale ) )
		textscale = level.linesize;
	
	temp = spawnstruct();
	temp.type = "rightname";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterHeading( heading, textscale )
{
	precacheString( heading );

	if( !isdefined( textscale ) )
		textscale = level.linesize;
	
	temp = spawnstruct();
	temp.type = "centerheading";
	temp.heading = heading;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterName( name, textscale )
{
	precacheString( name );

	if( !isdefined( textscale ) )
		textscale = level.linesize;
	
	temp = spawnstruct();
	temp.type = "centername";
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterNameDouble( name1, name2, textscale )
{
	precacheString( name1 );
	precacheString( name2 );

	if( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centernamedouble";
	temp.name1 = name1;
	temp.name2 = name2;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterDual( title, name, textscale )
{
	precacheString( title );
	precacheString( name );

	if( !isdefined( textscale ) )
		textscale = level.linesize;
	
	temp = spawnstruct();
	temp.type = "centerdual";
	temp.title = title;
	temp.name = name;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addCenterTriple( name1, name2, name3, textscale )
{
	precacheString( name1 );
	precacheString( name2 );
	precacheString( name3 );

	if( !isdefined( textscale ) )
		textscale = level.linesize;

	temp = spawnstruct();
	temp.type = "centertriple";
	temp.name1 = name1;
	temp.name2 = name2;
	temp.name3 = name3;
	temp.textscale = textscale;

	level.linelist[ level.linelist.size ] = temp;
}

addSpace()
{
	temp = spawnstruct();
	temp.type = "space";

	level.linelist[ level.linelist.size ] = temp;
}

addSpaceSmall()
{
	temp = spawnstruct();
	temp.type = "spacesmall";

	level.linelist[ level.linelist.size ] = temp;
}

addCenterImage( image, width, height, delay )
{
	precacheShader( image );
	
	temp = spawnstruct();
	temp.type = "centerimage";
	temp.image = image;
	temp.width = width;
	temp.height = height;
	
	if ( isdefined( delay ) )
		temp.delay = delay;

	level.linelist[ level.linelist.size ] = temp;
}

addLeftImage( image, width, height, delay )
{
	precacheShader( image );
	
	temp = spawnstruct();
	temp.type = "leftimage";
	temp.image = image;
	temp.width = width;
	temp.height = height;

	if ( isdefined( delay ) )
		temp.delay = delay;

	level.linelist[ level.linelist.size ] = temp;
}

playCredits()
{
	for ( i = 0; i < level.linelist.size; i++ )
	{
		delay = 0.5; //0.4
		type = level.linelist[ i ].type;
		
		if ( type == "centerimage" )
		{
			image = level.linelist[ i ].image;
			width = level.linelist[ i ].width;
			height = level.linelist[ i ].height;
			
			temp = newHudElem();
			temp SetShader( image, width, height );
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = 0;
			temp.y = 480;
			temp.sort = 2;
	
			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
			
			if ( isdefined( level.linelist[ i ].delay) )
				delay = level.linelist[ i ].delay;
			else
				delay = ( ( 0.037 * height ) );
				//delay = ( ( 0.0296 * height ) );
		}
		else if ( type == "leftimage" )
		{
			image = level.linelist[ i ].image;
			width = level.linelist[ i ].width;
			height = level.linelist[ i ].height;
			
			temp = newHudElem();
			temp SetShader( image, width, height );
			temp.alignX = "center";
			temp.horzAlign = "left";
			temp.x = 128;
			temp.y = 480;
			temp.sort = 2;
	
			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
			
			delay = ( ( 0.037 * height ) );
			//delay = ( ( 0.0296 * height ) );
		}
		else if ( type == "lefttitle" )
		{
			title = level.linelist[ i ].title;
			textscale = level.linelist[ i ].textscale;
			
			temp = newHudElem();
			temp setText( title );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 28;
			temp.y = 480;
			
			if( !level.console )
				temp.font = "default";
			else
				temp.font = "small";
				
			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;
	
			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "leftname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;
			
			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 60;
			temp.y = 480;

			if( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;
	
			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "subleftname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;
			
			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "left";
			temp.x = 92;
			temp.y = 480;

			if( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;
	
			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "righttitle" )
		{
			title = level.linelist[ i ].title;
			textscale = level.linelist[ i ].textscale;
			
			temp = newHudElem();
			temp setText( title );
			temp.alignX = "left";
			temp.horzAlign = "right";
			temp.x = -132;
			temp.y = 480;

			if( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;
	
			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "rightname" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "right";
			temp.x = -100;
			temp.y = 480;

			if( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;
	
			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "centerheading" )
		{
			heading = level.linelist[ i ].heading;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( heading );
			temp.alignX = "center";
			temp.horzAlign = "center";
			temp.x = 0;
			temp.y = 480;

			if( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;

			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "centerdual" )
		{
			title = level.linelist[ i ].title;
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( title );
			temp1.alignX = "right";
			temp1.horzAlign = "center";
			temp1.x = -8;
			temp1.y = 480;

			if( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name );
			temp2.alignX = "left";
			temp2.horzAlign = "center";
			temp2.x = 8;
			temp2.y = 480;

			if( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;
	
			temp1 thread delayDestroy( 22.5 );
			temp1 moveOverTime( 22.5 );
			temp1.y = -120;

			temp2 thread delayDestroy( 22.5 );
			temp2 moveOverTime( 22.5 );
			temp2.y = -120;
		}
		else if ( type == "centertriple" )
		{
			name1 = level.linelist[ i ].name1;
			name2 = level.linelist[ i ].name2;
			name3 = level.linelist[ i ].name3;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( name1 );
			temp1.alignX = "center";
			temp1.horzAlign = "center";
			temp1.x = -160;
			temp1.y = 480;

			if( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name2 );
			temp2.alignX = "center";
			temp2.horzAlign = "center";
			temp2.x = 0;
			temp2.y = 480;

			if( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;

			temp3 = newHudElem();
			temp3 setText( name3 );
			temp3.alignX = "center";
			temp3.horzAlign = "center";
			temp3.x = 160;
			temp3.y = 480;

			if( !level.console )
				temp3.font = "default";
			else
				temp3.font = "small";

			temp3.fontScale = textscale;
			temp3.sort = 2;
			temp3.glowColor = ( 0.3, 0.6, 0.3 );
			temp3.glowAlpha = 1;
	
			temp1 thread delayDestroy( 22.5 );
			temp1 moveOverTime( 22.5 );
			temp1.y = -120;

			temp2 thread delayDestroy( 22.5 );
			temp2 moveOverTime( 22.5 );
			temp2.y = -120;

			temp3 thread delayDestroy( 22.5 );
			temp3 moveOverTime( 22.5 );
			temp3.y = -120;
		}
		else if ( type == "centername" )
		{
			name = level.linelist[ i ].name;
			textscale = level.linelist[ i ].textscale;

			temp = newHudElem();
			temp setText( name );
			temp.alignX = "left";
			temp.horzAlign = "center";
			temp.x = 8;
			temp.y = 480;

			if( !level.console )
				temp.font = "default";
			else
				temp.font = "small";

			temp.fontScale = textscale;
			temp.sort = 2;
			temp.glowColor = ( 0.3, 0.6, 0.3 );
			temp.glowAlpha = 1;
	
			temp thread delayDestroy( 22.5 );
			temp moveOverTime( 22.5 );
			temp.y = -120;
		}
		else if ( type == "centernamedouble" )
		{
			name1 = level.linelist[ i ].name1;
			name2 = level.linelist[ i ].name2;
			textscale = level.linelist[ i ].textscale;

			temp1 = newHudElem();
			temp1 setText( name1 );
			temp1.alignX = "center";
			temp1.horzAlign = "center";
			temp1.x = -80;
			temp1.y = 480;

			if( !level.console )
				temp1.font = "default";
			else
				temp1.font = "small";

			temp1.fontScale = textscale;
			temp1.sort = 2;
			temp1.glowColor = ( 0.3, 0.6, 0.3 );
			temp1.glowAlpha = 1;

			temp2 = newHudElem();
			temp2 setText( name2 );
			temp2.alignX = "center";
			temp2.horzAlign = "center";
			temp2.x = 80;
			temp2.y = 480;

			if( !level.console )
				temp2.font = "default";
			else
				temp2.font = "small";

			temp2.fontScale = textscale;
			temp2.sort = 2;
			temp2.glowColor = ( 0.3, 0.6, 0.3 );
			temp2.glowAlpha = 1;
	
			temp1 thread delayDestroy( 22.5 );
			temp1 moveOverTime( 22.5 );
			temp1.y = -120;

			temp2 thread delayDestroy( 22.5 );
			temp2 moveOverTime( 22.5 );
			temp2.y = -120;
		}
		else if ( type == "spacesmall" )
			delay = 0.1875; //0.15
		else
			assert( type == "space" );
		
		//wait 0.65;
		wait delay;
	}
	
	flag_set( "credits_ended" );
}

delayDestroy( duration )
{
	wait duration;
	self destroy();
}