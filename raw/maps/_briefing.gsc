/*
MISSION BRIEFING
*/

main()
{
	setsaveddvar("hud_drawhud",0);
	
	level.script = tolower(getdvar ("mapname"));
	if(!isdefined(level.tmpmsg))
		level.tmpmsg = [];
		
	player = getent("player", "classname");
	setsaveddvar("g_speed",0);
	player setViewmodel( "viewmodel_hands_cloth" );  //hack
	
	precacheShader("black");
	
	movieDefined = 0;
	for( index = 0; index < level.slide.size; index++)
	{
		if( isdefined(level.slide[index]["movie"]) )
		{
			movieDefined = 1;
			break;
		}
	}
	
	if ( movieDefined )
	{
		// movie
		wait 0.05;
		player gotothelevel( false );
	}
	else
	{
		// slides
		precacheString (&"SCRIPT_PLATFORM_FIRE_TO_SKIP");
		for(i=0;i<level.slide.size;i++)
			if(isdefined(level.slide[i]["image"]))
				precacheshader(level.slide[i]["image"]);
				
		player thread skipthebriefing();
		player dothebriefing();
		player gotothelevel(false);
	}
}


// Does the initial startup for a mission briefing
// iFadeTime Is the length of time it will take to transition between images. Defaults to 500 (milliseconds) Set to 0 for instant change
start(fFadeTime)
{
	level.briefing_running = true;
	level.briefing_ending = false;
	level.PlaceNextImage = "A";
	
	if (isdefined (level.imageA))
		level.imageA destroy();
	if (isdefined (level.imageB))
		level.imageB destroy();
	if (isdefined (level.blackscreen))
		level.blackscreen destroy();
	if (isdefined (level.FiretoSkip))
		level.FiretoSkip destroy();
	
	if( !isDefined(fFadeTime) || !fFadeTime )
	{
		level.briefing_fadeInTime = 0.5;
		level.briefing_fadeOutTime = 0.5;
	}
	else
	{
		level.briefing_fadeInTime = fFadeTime;
		level.briefing_fadeOutTime = fFadeTime;
	}

	self endon("briefingskip");
	self thread skipCheck();

	// Make the screen black
	level.blackscreen = newHudElem();
	level.blackscreen.sort = -1;
	level.blackscreen.alignX = "left";
	level.blackscreen.alignY = "top";
	level.blackscreen.x = 0;
	level.blackscreen.y = 0;
	level.blackscreen.horzAlign = "fullscreen";
	level.blackscreen.vertAlign = "fullscreen";
	level.blackscreen.foreground = true;

	level.blackscreen.alpha = 1;
	level.blackscreen setShader("black", 640, 480);

	// Fire to skip text
	level.FiretoSkip = newHudElem();
	level.FiretoSkip.sort = 1;
	level.FiretoSkip.alignX = "center";
	level.FiretoSkip.alignY = "top";
	level.FiretoSkip.fontScale = 2;
	level.FiretoSkip.x = 0;
	level.FiretoSkip.y = 60;
	level.FiretoSkip.horzAlign = "center";
	level.FiretoSkip.vertAlign = "fullscreen";
	level.FiretoSkip.foreground = true;
	level.FiretoSkip settext (&"SCRIPT_PLATFORM_FIRE_TO_SKIP");
	level.FiretoSkip.alpha = 0.0;

	thread fadeInFireToSkip(); 
	
	//Image A
	level.imageA = newHudElem();
	level.imageA.alignX = "center";
	level.imageA.alignY = "middle";
	level.imageA.x = 320;
	level.imageA.y = 240;
	level.imageA.alpha = 0;
	level.imageA.horzAlign = "fullscreen";
	level.imageA.vertAlign = "fullscreen";
	level.imageA setShader("black", 640, 360);
	level.imageA.foreground = true;
	
	//Image B
	level.imageB = newHudElem();
	level.imageB.alignX = "center";
	level.imageB.alignY = "middle";
	level.imageB.x = 320;
	level.imageB.y = 240;
	level.imageB.horzAlign = "fullscreen";
	level.imageB.vertAlign = "fullscreen";
	level.imageB.alpha = 0;
	level.imageB setShader("black", 640, 360);
	level.imageB.foreground = true;
	
	self freezeControls(true);
	
	wait .5;

	for(i=0;i<level.slide.size;i++)
	{
		soundplaying = false;
		if(isdefined(level.slide[i]["image"]))
		{
			if(level.script[0] != "m") //movie_ maps don't play the sound
				self soundplay ("slide_advance");
			wait .5;
			self thread image(level.slide[i]["image"]);
		}
		if(isdefined(level.slide[i]["dialog_wait"]) && self.dialogplaying[level.slide[i]["dialog_wait"]])
		{
			self waittill (level.slide[i]["dialog_wait"]+"sounddone");
		}
		if(isdefined(level.slide[i]["dialog"]))
		{
			self soundplay(level.slide[i]["dialog"], level.slide[i]["dialog"]+"sounddone");
			soundplaying = true;
		}
		if(isdefined(level.slide[i]["delay"]))
		{
			wait(level.slide[i]["delay"]);
		}
		else if(soundplaying)
		{
			self waittill (level.slide[i]["dialog"]+"sounddone");
		}

	}
}

fadeInFireToSkip()
{
	wait(1);
	thread fadeFireToSkip();	
	level.FiretoSkip fadeOverTime(level.briefing_fadeOutTime);	
	level.FiretoSkip.alpha = 1.0;	
}

// fades fire to skip after 7 seconds
fadeFireToSkip()
{
	wait 7; 
	level.FiretoSkip fadeOverTime(level.briefing_fadeOutTime);	
	level.FiretoSkip.alpha = 0.0;
}

// waits till the briefing is done
waitTillBriefingDone()
{
	self waittill("briefingend");
}

// This ends the briefing if the player says he wants to
skipCheck()
{
	self endon("briefingend");

	player = getent("player", "classname" );
	
	wait( 0.05 );
	
	maps\_utility::set_console_status();
	
	for(;;)
	{
		// we want to check if the "A" button has been pressed on xenon
		// instead of FIRE. 
		if( level.console )
		{
			if(player buttonPressed( "BUTTON_A" ))
			{
				self notify("briefingskip");			
				end();
				return;				
			}	
			wait(0.05); 
			continue; 
		}
		
		if(player attackButtonPressed())
		{
			self notify("briefingskip");			
			end();
			return;
		}
		wait(0.05);
	}
}

image(sImageShader)
{
	self endon("briefingskip");
	
	if (level.PlaceNextImage == "A")
	{
		level.PlaceNextImage = "B";
		level.imageA setShader(sImageShader, 640, 360);
		thread imageFadeOut("B");
		level.imageA fadeOverTime(level.briefing_fadeInTime);
		level.imageA.alpha = 1;
	}
	else if (level.PlaceNextImage == "B")
	{
		level.PlaceNextImage = "A";
		level.imageB setShader(sImageShader, 640, 360);
		thread imageFadeOut("A");
		level.imageB fadeOverTime(level.briefing_fadeInTime);
		level.imageB.alpha = 1;
	}
}

imageFadeOut(elem)
{
	if (elem == "A")
	{
		level.imageA fadeOverTime(level.briefing_fadeOutTime);
		level.imageA.alpha = 0;
	}
	else if (elem == "B")
	{
		level.imageB fadeOverTime(level.briefing_fadeOutTime);
		level.imageB.alpha = 0;
	}
}

endThread()
{
	// Check for the briefing already being ended
	if(!level.briefing_running)
		return;
	if(level.briefing_ending)
		return;
		
	self notify("briefingend");
	level.briefing_ending = true;
	
	// Make sure the briefing audio is ended on for slideshows
	if(level.script[0] != "m")
	{
		self playsound("stop_voice");
	}

	// Fade the screen in
	thread imageFadeOut("A");
	thread imageFadeOut("B");
	
	wait(1.5);
//	self freezeControls(false);

	level.briefing_ending = false;
}

end()
{
	self thread endThread();
}

soundplay(dialog,msg)
{
	if(isdefined(level.tmpmsg[dialog]))
		iprintlnbold(level.tmpmsg[dialog]);
	if(isdefined(msg))
	{
		thread soundplay_flag(dialog,msg);
		self playsound (dialog,msg);
	}
	else
		self playsound (dialog);
}

soundplay_flag(dialog,msg)
{
	self.dialogplaying[dialog] = true;
	self waittill (msg);
	self.dialogplaying[dialog] = false;
}

dothebriefing()
{
	self start(0.5);
	if(level.script[0] != "m") //movie_ maps don't play the sound
		self soundplay ("slide_advance");
	wait(0.5);
	end();
}

skipthebriefing()
{
	self waittill("briefingskip");
	gotothelevel(true);
}

gotothelevel(skipMovie)
{
	if ( !skipMovie )
	{
		for(i=0;i<level.slide.size;i++)
		{
			if(isdefined(level.slide[i]["movie"]))
				cinematic(level.slide[i]["movie"]);
		}
	}

	changeLevel( level.levelToLoad, false );
}

