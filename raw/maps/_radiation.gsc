#include maps\_hud_util;
#include maps\_utility;
#include common_scripts\utility;


/************************************************************************************************************/
/*												RADIATION EFFECT											*/
/************************************************************************************************************/
main()
{
	flag_init( "_radiation_poisoning" );
	precacheString( &"SCOUTSNIPER_MRHR" );
	precacheString( &"SCRIPT_RADIATION_DEATH" );
	precacheShellShock( "radiation_low" );
	precacheShellShock( "radiation_med" );
	precacheShellShock( "radiation_high" );

	level.player_took_super_radiation_dose = false;
	run_thread_on_targetname( "radiation", ::updateRadiationTriggers );
	run_thread_on_targetname( "super_radiation", ::super_radiation_trigger );
	
	thread updateRadiationDosage();
	thread updateRadiationDosimeter();
	thread updateRadiationShock();
	thread updateRadiationBlackOut();
	thread updateRadiationSound();
	thread updateRadiationFlag();
	thread first_radiation_dialogue();
//	thread updateRadiationRatePercent();
}

updateRadiationTriggers()
{
	for( ;; )
	{
		self waittill( "trigger" );

		level.radiation_triggers[ level.radiation_triggers.size ] = self;

		while( level.player isTouching( self ) )
			wait 0.05;

		level.radiation_triggers = array_remove( level.radiation_triggers, self );
	}
}

super_radiation_trigger()
{
	self waittill( "trigger" );
	level.player_took_super_radiation_dose = true;
}

updateRadiationDosage()
{
	level.radiation_triggers = [];
	level.radiation_rate = 0;
	level.radiation_ratepercent = 0;
	level.radiation_total = 0;
	level.radiation_totalpercent = 0;
	
	update_frequency = 1;
	min_rate = 0;
	max_rate = 1100000 /( 60 * update_frequency );	// 60 REM/PH
	max_total = 200000;	// 200 REM
	
	range = max_rate - min_rate;
	
	for( ;; )
	{
		rates = [];
		for( i = 0 ; i < level.radiation_triggers.size ; i++ )
		{
			trigger = level.radiation_triggers[ i ];
			
			dist =( distance( level.player.origin , trigger.origin ) - 15 );
			rates[ i ] = max_rate -( max_rate / trigger.radius ) * dist;
		}
		
		rate = 0;
		for( i = 0 ; i < rates.size ; i++ )
			rate = rate + rates[ i ];

		if( rate < min_rate )
			rate = min_rate;

		if( rate > max_rate )
			rate = max_rate;
			
		level.radiation_rate = rate;
		level.radiation_ratepercent =( rate - min_rate ) / range * 100;
		
		if ( level.player_took_super_radiation_dose )
		{
			rate = max_rate;
			level.radiation_ratepercent = 100;
		}

		if( level.radiation_ratepercent > 25 )
		{
			level.radiation_total += rate;
			level.radiation_totalpercent = level.radiation_total / max_total * 100;
		}
	
		wait update_frequency;
	}
}

updateRadiationShock()
{
	update_frequency = 1;
	
	for( ;; )
	{
		if( level.radiation_ratepercent >= 75 )
			level.player shellshock( "radiation_high", 5 );
		else if( level.radiation_ratepercent >= 50 )
			level.player shellshock( "radiation_med", 5 );
		else if( level.radiation_ratepercent > 25 )
			level.player shellshock( "radiation_low", 5 );

		wait update_frequency;
	}
}

updateRadiationSound()
{
	level.player thread playRadiationSound();
	
	for( ;; )
	{
		if( level.radiation_ratepercent >= 75 )
			level.player.radiation_sound = "item_geigercouner_level4";
		else if( level.radiation_ratepercent >= 50 )
			level.player.radiation_sound = "item_geigercouner_level3";
		else if( level.radiation_ratepercent >= 25 )
			level.player.radiation_sound = "item_geigercouner_level2";
		else if( level.radiation_ratepercent > 0 )
			level.player.radiation_sound = "item_geigercouner_level1";
		else
			level.player.radiation_sound = "none";

		wait 0.05;
	}
}

updateRadiationFlag()
{
	for( ;; )
	{
		if( level.radiation_ratepercent > 25 )
			flag_set( "_radiation_poisoning" );
		else
			flag_clear( "_radiation_poisoning" );

		wait 0.05;
	}
}

playRadiationSound()
{
	wait .05;
	
	orgin = spawn( "script_origin", ( 0, 0, 0 ) );
	orgin.origin = self.origin;
	orgin.angles = self.angles;
	orgin linkto( self );

	temp = self.radiation_sound;
	
	for( ;; )
	{
		if( temp != self.radiation_sound )
		{
			orgin stoploopsound();
			
			if( isdefined( self.radiation_sound ) && self.radiation_sound != "none" )
				orgin playloopsound( self.radiation_sound );
		}

		temp = self.radiation_sound;
		
		wait 0.05;
	}
}

updateRadiationRatePercent()
{
	update_frequency = 0.05;
	
	ratepercent = newHudElem();
	ratepercent.fontScale = 1.2;
	ratepercent.x = 670;
	ratepercent.y = 350;
	ratepercent.alignX = "right";
	ratepercent.label = "";
	//if you wanna put back in - delete this line
	ratepercent.alpha = 0;
	
	for( ;; )
	{
		ratepercent.label = level.radiation_ratepercent;

		wait update_frequency;
	}
}

// set an update rate
// add variance so it is never stuck at a single value
// add background radiation
// add a radiation icon
updateRadiationDosimeter()
{
	min_rate = 0.028;
	max_rate = 100;
	update_frequency = 1;

	range = max_rate - min_rate;
	last_origin = level.player.origin;

	dosimeter = newHudElem();
	dosimeter.fontScale = 1.2;
	dosimeter.x = 676;
	dosimeter.y = 360;
	//if you wanna put back in - delete this line
	dosimeter.alpha = 0;
	
	dosimeter.alignX = "right";
	dosimeter.label = &"SCOUTSNIPER_MRHR";

	dosimeter thread updateRadiationDosimeterColor();

	for( ;; )
	{
		if( level.radiation_rate <= min_rate )
		{
			variance = randomfloatrange( -0.001, 0.001 );
			dosimeter setValue( min_rate + variance );
			//println( "min_rate: ", min_rate, "variance: ", variance );
		}
		else if( level.radiation_rate > max_rate )
		{
			dosimeter setValue( max_rate );
			// TODO: Display a warning icon that the meter is beyond it's range
		}
		else
			dosimeter setValue( level.radiation_rate );

		wait update_frequency;
	}
}

updateRadiationDosimeterColor()
{
	update_frequency = 0.05;
	
	for( ;; )
	{
		colorvalue = 1;
		stepamount = 0.13;
		
		while( level.radiation_rate >= 100 )
		{
			if( colorvalue <= 0 || colorvalue >= 1 )
				stepamount = stepamount * -1;

			colorvalue = colorvalue + stepamount;

			if( colorvalue <= 0 )
				colorvalue = 0;

			if( colorvalue >= 1 )
				colorvalue = 1;

			self.color =( 1, colorvalue, colorvalue );
			//println( "colorvalue: ", colorvalue );
			
			wait update_frequency;
		}
		
		self.color =( 1, 1, 1 );
		
		wait update_frequency;
	}
}

// this is to indicate you are near your limit of radiation and are about to pass out
// as you near the last 33%( maybe 50% or 75% ) of your max dosage this will be visible while taking more radiation above a TBD threshold
// doing blurring at the same time as darkening
// should pulse, pulses should get longer closer to death and more frequent
// ramp up intensity and frequency
// smooth out pulsing, sin/cos?
// ramp up the low end of alpha somehow
// change pulse to pulse in/out, check some new values to determine what level to pulse out to
updateRadiationBlackOut()
{
	level.player endon( "death" );

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	min_length = 1;
	max_length = 4;
	min_alpha = .25;
	max_alpha = 1;

	min_percent = 25;
	max_percent = 100;
	
	fraction = 0;

	for( ;; )
	{
		while( level.radiation_totalpercent > 25 && level.radiation_ratepercent > 25 )
		{
			percent_range = max_percent - min_percent;
			fraction =( level.radiation_totalpercent - min_percent ) / percent_range;

			if( fraction < 0 )
				fraction = 0;
			else if( fraction > 1 )
				fraction = 1;

			length_range = max_length - min_length;
			length = min_length +( length_range *( 1 - fraction ) );
			
			alpha_range = max_alpha - min_alpha;
			alpha = min_alpha +( alpha_range * fraction );

			blur = 7.2 * alpha;
			end_alpha = fraction * 0.5;
			end_blur = 7.2 * end_alpha;

			println( "fraction: ", fraction, " length: ", length, " alpha: ", alpha, " blur: ", blur );
			
			if( fraction == 1 )
				break;
			
			duration = length / 2;

			overlay fadeinBlackOut( duration, alpha, blur );
			overlay fadeoutBlackOut( duration, end_alpha, end_blur );

			// wait a variable amount based on level.radiation_totalpercent, this is the space in between pulses
			//wait 1;
			wait( fraction * 0.5 );
		}

		if( fraction == 1 )
			break;
		
		if( overlay.alpha != 0 )
			overlay fadeoutBlackOut( 1, 0, 0 );
		
		wait 0.05;
	}
	overlay fadeinBlackOut( 2, 1, 6 );
	thread radiation_kill();
}
radiation_kill()
{
	level.player.specialDamage = true;
	level.player.specialDeath = true;
	damage = 10 * level.player.health / getdvarfloat( "player_DamageMultiplier" );
	
	level.player setcandamage( true );
	level.player dodamage( damage , level.player.origin );
	waittillframeend;
	
	assert( !isAlive( level.player ) );
	quote = &"SCRIPT_RADIATION_DEATH";
	setdvar( "ui_deadquote", quote );
}

fadeinBlackOut( duration, alpha, blur )
{
	//target_blur = 7.2 * alpha;
	
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}

fadeoutBlackOut( duration, alpha, blur )
{
	//target_blur = 7.2 * alpha;
	
	self fadeOverTime( duration );
	self.alpha = alpha;
	setblur( blur, duration );
	wait duration;
}


first_radiation_dialogue()
{
	while( 1 )
	{
		flag_wait( "_radiation_poisoning" );
		
		if( level.script == "scoutsniper" )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_youdaft" );
		level notify( "radiation_warning" );
		
		flag_waitopen( "_radiation_poisoning" );
		wait( 10 );
	}
}
