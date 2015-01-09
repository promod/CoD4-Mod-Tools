#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include maps\_anim;
#include maps\_utility;
#using_animtree ("generic_human");


initFlashed()
{
	anim.flashAnimArray[0] = %exposed_flashbang_v1;
	anim.flashAnimArray[1] = %exposed_flashbang_v2;
	anim.flashAnimArray[2] = %exposed_flashbang_v3;
	anim.flashAnimArray[3] = %exposed_flashbang_v4;
	anim.flashAnimArray[4] = %exposed_flashbang_v5;
	
	randomizeFlashAnimArray();

	anim.flashAnimIndex = 0;
}

randomizeFlashAnimArray()
{
	for ( i = 0; i < anim.flashAnimArray.size; i++ )
	{
		switchwith = randomint( anim.flashAnimArray.size );
		temp = anim.flashAnimArray[i];
		anim.flashAnimArray[i] = anim.flashAnimArray[switchwith];
		anim.flashAnimArray[switchwith] = temp;
	}
}

getNextFlashAnim()
{
	anim.flashAnimIndex++;
	if ( anim.flashAnimIndex >= anim.flashAnimArray.size )
	{
		anim.flashAnimIndex = 0;
		randomizeFlashAnimArray();
	}
	return anim.flashAnimArray[ anim.flashAnimIndex ];
}

flashBangAnim()
{
	self endon( "killanimscript" );
	self setflaggedanimknoball( "flashed_anim", getNextFlashAnim(), %body );
	self animscripts\shared::DoNoteTracks( "flashed_anim" );
}

main()
{
	self endon( "killanimscript" );

	animscripts\utility::initialize("flashed");

	if ( self.a.pose == "prone" )
		self ExitProneWrapper(1);
	self.a.pose = "stand";
	
	self startFlashBanged();
	
	self animscripts\face::SayGenericDialogue("flashbang");
	self.allowdeath = true;
	
	if ( isdefined( self.flashedanim ) )
		self setanimknoball( self.flashedanim, %body );
	else //if ( self.a.pose == "stand" ) // we have to play *something*, even if we're crouched
		self thread flashBangAnim();
	
	for(;;)
	{
		time = gettime();
		
		if ( time > self.flashendtime )
		{
			self notify("stop_flashbang_effect");
			self setFlashBanged( false );
			self.flashed = false;
			break;
		}
		wait(0.05);	
	}
}
