#include common_scripts\utility;
#include maps\_utility;

// This function never returns.
flickerLight( color0, color1, minDelay, maxDelay )
{
	toColor = color0;
	delay = 0.0;

	for ( ;; )
	{
		fromColor = toColor;
		toColor = color0 + ( color1 - color0 ) * randomfloat( 1.0 );

		if ( minDelay != maxDelay )
			delay += randomfloatrange( minDelay, maxDelay );
		else
			delay += minDelay;

		colorDeltaPerTime = ( fromColor - toColor ) * ( 1 / delay );
		while ( delay > 0 )
		{
			self setLightColor( toColor + colorDeltaPerTime * delay );
			wait 0.05;
			delay -= 0.05;
		}
	}
}

generic_pulsing()
{
	//ChrisC wants the lights off when probes are done
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		self setLightIntensity( 0 );
		return;
	}
		
	on = self getLightIntensity();
	off = .05;
	curr = on;
	transition_on = .3;
	transition_off = .6;
	increment_on = ( on - off ) / ( transition_on / .05 );
	increment_off = ( on - off ) / ( transition_off / .05 );
	
	for ( ;; )
	{
		//ramp down
		time = 0;
		while ( ( time < transition_off ) )
		{
			curr -= increment_off;
			self setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}
		
		//off wait time
		wait( 1 );
		
		//ramp up
		time = 0;
		while ( time < transition_on )
		{
			curr += increment_on;
			self setLightIntensity( curr );
			time += .05;
			wait( .05 );
		}
		
		//on wait time
		wait( .5 );
	}	
}


generic_double_strobe()
{
	//ChrisC wants the lights off when probes are done
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		self setLightIntensity( 0 );
		return;
	}
		
	on = self getLightIntensity();
	off = .05;
	linked_models = false;
	lit_model = undefined;
	unlit_model = undefined;
	linked_lights = false;
	linked_light_ents = [];
	
	if (isdefined ( self.script_noteworthy ) )
	{
		linked_things = getentarray ( self.script_noteworthy, "targetname" );
		for ( i = 0; i < linked_things.size; i++ )
		{
			if ( linked_things[ i ].classname == "light" )
			{
				linked_lights = true;
				linked_light_ents[ linked_light_ents.size ] = linked_things[ i ];
			}
			if ( linked_things[ i ].classname == "script_model" )
			{
				lit_model = linked_things[ i ];
				unlit_model = getent ( lit_model.target, "targetname" );
				linked_models = true;
			}
		}
		//if (! isdefined ( lit_model ) )
		//	assertmsg( "primary light has lit model but not unlit model ( " + lit_model.origin + " ) " );
	}
	
	for ( ;; )
	{
		//off wait time
		self setLightIntensity( off );
		if ( linked_models )
		{
			lit_model hide();
			unlit_model show();
		}
		wait( .8 );
		
		//first flash
		self setLightIntensity( on );
		if ( linked_models )
		{
			lit_model show();
			unlit_model hide();
		}
		wait( .1 );
		
		//pause
		self setLightIntensity( off );
		if ( linked_models )
		{
			lit_model hide();
			unlit_model show();
		}
		wait( .12 );
		
		//second flash
		self setLightIntensity( on );
		if ( linked_models )
		{
			lit_model show();
			unlit_model hide();
		}
		wait( .1 );
	}	
}

getclosests_flickering_model( origin )
{
	//stuff in prefabs bleh. non of this script_noteworthy or linkto stuff works there. so doing closest thing with the light_flicker_model targetname
	array = getentarray("light_flicker_model","targetname");
	return_array = [];
	model = getclosest( origin, array );
	if(isdefined(model))
		return_array[0] = model;
	return return_array; //I'm losing my mind
	
}

generic_flickering()
{
	//ChrisC wants the lights off when probes are done
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		self setLightIntensity( 0 );
		return;
	}
		
	min_flickerless_time = .2;
	max_flickerless_time = 1.5;
	
	on = self getLightIntensity();
	off = 0;
	curr = on;
	num = 0;
	linked_models = false;
	lit_model = undefined;
	unlit_model = undefined;
	linked_lights = false;
	linked_light_ents = [];


	linked_things = [];
	
	if( isdefined( self.script_noteworthy ) )	
		linked_things = getentarray ( self.script_noteworthy, "targetname" );

	if( ! linked_things.size )
		linked_things = getclosests_flickering_model( self.origin );
			
	for ( i = 0; i < linked_things.size; i++ )
	{
		if ( linked_things[ i ].classname == "light" )
		{
			linked_lights = true;
			linked_light_ents[ linked_light_ents.size ] = linked_things[ i ];
		}
		if ( linked_things[ i ].classname == "script_model" )
		{
			lit_model = linked_things[ i ];
			unlit_model = getent ( lit_model.target, "targetname" );
			linked_models = true;
		}
	}
		//if (! isdefined ( lit_model ) )
		//	assertmsg( "primary light has lit model but not unlit model ( " + lit_model.origin + " ) " );
		
	for ( ;; )
	{
		num = randomintrange( 1, 10 );
		while ( num )
		{
			wait( randomfloatrange( .05, .1 ) );
			if ( curr > .2 )
			{
				curr = randomfloatrange( 0, .3 );
				if ( linked_models )
				{
					lit_model hide();
					unlit_model show();
				}
			}
			else
			{
				curr = on;
				if ( linked_models )
				{
					lit_model show();
					unlit_model hide();
				}
			}
					
			self setLightIntensity( curr );
			if ( linked_lights)
			{
				for ( i = 0; i < linked_light_ents.size; i++ )
					linked_light_ents[ i ] setLightIntensity( curr );
			}
			num -- ;			
		}
		
		self setLightIntensity( on );
		if ( linked_lights)
		{
			for ( i = 0; i < linked_light_ents.size; i++ )
				linked_light_ents[ i ] setLightIntensity( on );
		}
		if ( linked_models )
		{
			lit_model show();
			unlit_model hide();
		}
		wait( randomfloatrange( min_flickerless_time, max_flickerless_time ) );
	}	
}


flickerLightIntensity( minDelay, maxDelay )
{
	on = self getLightIntensity();
	off = 0;
	curr = on;
	num = 0;
	
	for ( ;; )
	{
		num = randomintrange( 1, 10 );
		while ( num )
		{
			wait( randomfloatrange( .05, .1 ) );
			if ( curr > .2 )
				curr = randomfloatrange( 0, .3 );
			else
				curr = on;
					
			self setLightIntensity( curr );
			num -- ;			
		}
		
		self setLightIntensity( on );	
		wait( randomfloatrange( minDelay, maxDelay ) );
	}	
}

burning_trash_fire()
{
	full = self getLightIntensity();
	
	old_intensity = full;
	
	for ( ;; )
	{
		intensity = randomfloatrange( full * 0.7, full * 1.2 );
		timer = randomfloatrange( 0.3, 0.6 );
		timer *= 20;

		for ( i = 0; i < timer; i ++ )
		{
			new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
			
			self setLightIntensity( new_intensity );
			wait( 0.05 );
		}
		
		old_intensity = intensity;
	}	
}

// This function never returns.
strobeLight( intensity0, intensity1, period )
{
	frequency = 360 / period;
	time = 0;

	for ( ;; )
	{
		interpolation = sin( time * frequency ) * 0.5 + 0.5;
		self setLightIntensity( intensity0 + ( intensity1 - intensity0 ) * interpolation );
		wait 0.05;
		time += 0.05;
		if ( time > period )
			time -= period;
	}
}


// This function is non - blocking.  It will probably need to be moved to code if scripted lights are needed in multiplayer.
changeLightColorTo( targetColor, totalTime, accelTime, decelTime )
{
	if ( !isdefined( accelTime ) )
		accelTime = 0;
	if ( !isdefined( decelTime ) )
		decelTime = 0;
	self thread changeLightColorToWorkerThread( targetColor, totalTime, accelTime, decelTime );
}


// Don't call directly; use 'changeLightColorTo' instead
changeLightColorToWorkerThread( targetColor, totalTime, accelTime, decelTime )
{
	// Interpolation goes from 0 to 1 over totalTime, with const acceleration and deceleration given by their respective times.
	// The descriptive equations are:
	//   midTime = totalTime - accelTime - decelTime
	//   fracAccel = 0.5 * accelRate * accelTime^2
	//   fracConst = velConst * midTime
	//   fracDecel = velConst * decelTime - 0.5 * decelRate * decelTime^2
	//   fracAccel + fracConst + fracDecel = 1
	//   velConst = accelRate * accelTime
	//   velConst = decelRate * decelTime
	// The unknowns are fracAccel, fracConst, fracDecel, accelRate, decelRate, and velConst.  We have six equations and six unknowns.
	// So, these can be solved to give the following:
	//   accelRate = 2 / ( accelTime * ( totalTime + midTime ) )
	//   decelRate = 2 / ( decelTime * ( totalTime + midTime ) )
	//   velConst = 2 / ( totalTime + midTime )
	//   fracAccel = accelTime / ( totalTime + midTime )
	//   fracDecel = decelTime / ( totalTime + midTime )
	//   fracConst = 2 * midTime / ( totalTime + midTime )

	startColor = self getLightColor();
	timeFactor = 1 / ( totalTime * 2 - ( accelTime + decelTime ) );
	time = 0;

	if ( time < accelTime )
	{
		halfRate = timeFactor / accelTime;
		
		while ( time < accelTime )
		{
			fraction = halfRate * time * time;
			self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
			wait 0.05;
			time += 0.05;
		}
	}

	while ( time < totalTime - decelTime )
	{
		fraction = timeFactor * ( 2 * time - accelTime );
		self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
		wait 0.05;
		time += 0.05;
	}

	time = totalTime - time;
	if ( time > 0 )
	{
		halfRate = timeFactor / decelTime;

		while ( time > 0 )
		{
			fraction = 1 - halfRate * time * time;
			self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
			wait 0.05;
			time -= 0.05;
		}
	}

	self setLightColor( targetColor );
}


television()
{
	thread tv_changes_intensity();
	thread tv_changes_color();
}
	
tv_changes_intensity()
{
	self endon( "light_off" );
	full = self getLightIntensity();
	old_intensity = full;

	for ( ;; )
	{
		intensity = randomfloatrange( full * 0.7, full * 1.2 );
		timer = randomfloatrange( 0.3, 1.2 );
		timer *= 20;

		for ( i = 0; i < timer; i ++ )
		{
			new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
			
			self setLightIntensity( new_intensity );
			wait( 0.05 );
		}
		
		old_intensity = intensity;
	}	
}
	
tv_changes_color()
{
	self endon( "light_off" );

	range = 0.5;
	base = 0.5;
	rgb = [];
	old_rgb = [];

	for ( i = 0; i < 3; i++ )
	{
		rgb[ i ] = 0;
		old_rgb[ i ] = 0;
	}
	
	for ( ;; )
	{
		for ( i = 0; i < rgb.size; i++ )
		{
			old_rgb[ i ] = rgb[ i ];
			rgb[ i ] = randomfloat( range ) + base;
		}

		timer = randomfloatrange( 0.3, 1.2 );
		timer *= 20;

		for ( i = 0; i < timer; i ++ )
		{
			new_rgb = [];
			for ( p = 0; p < rgb.size; p++ )
			{
				new_rgb[ p ] = rgb[ p ] * ( i / timer ) + old_rgb[ p ] * ( ( timer - i ) / timer );
			}

			self setLightColor( ( new_rgb[ 0 ], new_rgb[ 1 ], new_rgb[ 2 ] ) );
			wait( 0.05 );
		}
	}	
}
