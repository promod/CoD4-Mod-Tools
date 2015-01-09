// Note that this script is called from the level script command animscripted, only for AI.  If animscripted 
// is done on a script model, this script is not called - startscriptedanim is called directly.

#using_animtree ("generic_human");
main()
{
	//thread [[anim.println]]("Entering animscripts\\scripted. anim: ",self.codeScripted["anim"],",  notify: ",self.codeScripted["notifyName"],", dialogue: ",self.scripted_dialogue,", facial: ",self.facial_animation, "root: ", self.codeScripted["root"]);#/
	self endon ("death");
//	animscripts\utility::handleSuppressingEnemy();
//	wait (0);
	self notify ("killanimscript");
	self notify ("clearSuppressionAttack");
	self.a.suppressingEnemy = false;
	

	self.codeScripted["root"] = %body;	// TEMP!

    self trackScriptState( "Scripted Main", "code" );
	self endon ("end_sequence");
//	Causes potential variable overflow in Stalingrad
//	self thread DebugPrintEndSequence();
	self startscriptedanim(self.codeScripted["notifyName"], self.codeScripted["origin"], self.codeScripted["angles"], self.codeScripted["anim"], self.codeScripted["animMode"], self.codeScripted["root"]);

	self.a.script = "scripted";
	self.codeScripted = undefined;
//	if (isdefined (self.facial_animation))
//	{
//		self SetFlaggedAnimRestart("scripted_anim_facedone", self.facial_animation, 1, .1, 1);
//		self.facial_animation = undefined;
//	}
	if ( isdefined (self.scripted_dialogue) || isdefined (self.facial_animation) )
	{
		self animscripts\face::SaySpecificDialogue(self.facial_animation, self.scripted_dialogue, 0.9, "scripted_anim_facedone");
		self.facial_animation = undefined;
		self.scripted_dialogue = undefined;
	}

	if (isdefined (self.deathstring_passed))
		self.deathstring = self.deathstring_passed;

	self waittill("killanimscript");
}

#using_animtree ("generic_human");
init(notifyName, origin, angles, theAnim, animMode, root)
{
	self.codeScripted["notifyName"] = notifyName;
	self.codeScripted["origin"] = origin;
	self.codeScripted["angles"] = angles;
	self.codeScripted["anim"] = theAnim;
	if (isDefined(animMode))
		self.codeScripted["animMode"] = animMode;
	else
		self.codeScripted["animMode"] = "normal";
	if (isDefined(root))
		self.codeScripted["root"] = root;
	else
		self.codeScripted["root"] = %body;
}

// Causes potential variable overflow in Stalingrad

/*
DebugPrintEndSequence()
{
	self endon ("death");
	self waittill ("end_sequence");
	/#thread [[anim.println]]("scripted.gsc: \"end_sequence\" was notified.  Time: ",GetTime(),".");#/
}
*/