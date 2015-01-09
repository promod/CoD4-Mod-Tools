main (notifyname, character, node, scr_thread, bitflags)
{
	if (getdvar ("debug") == "1")
	{
		println ("------------------------------------------------");
		println ("Notifyname ^c", notifyname);
		println ("character ", character);
		println ("node ", node);
		println ("scr_thread ", scr_thread);
		println ("bitflags ", bitflags);
		println ("------------------------------------------------");
	}
		
	if (!isdefined (level.scr_anim[notifyname][character]["animation"]))
	{
		self.scripted_notifyname = notifyname;
		self.scriptedFacialAnim = level.scr_anim[notifyname][character]["facial"];
		self.scriptedFacialSound = level.scr_anim[notifyname][character]["sound"][0];
		self playsound (self.scriptedFacialSound);
		println ("^bPlayed friendly chat sound " + self.scriptedFacialSound);
		self notify ("ScriptedFacial");
		return;
	}

	self thread abrupt_end(notifyname);
		
	if (isdefined (self.notifyname))
		maps\_utility::error (character + " tried to do scripted sequence " + notifyname + " but was in the middle of doing sequence " + self.notifyname);

	self.notifyname = notifyname;
	self notify ("new_sequence");	
	
	if ((!isdefined (level.scripted_animation_slot)) || (!isdefined (level.scripted_animation_slot[notifyname])))
		level.scripted_animation_slot[notifyname] = 1;
	else
		level.scripted_animation_slot[notifyname]++;
	
	/*
	if (isdefined (node))
	{
		newnode = getnode (node,"targetname");
		
		if (!isdefined (newnode))
		{
			newnode = getent (node,"targetname");
			if (!isdefined (newnode))
				maps\_utility::error ("Node " + node+ " for scripted sequence " + notifyname + " does not exist as a node or entity.");
		}

		node = newnode;
	
		if (level.scripted_animation_slot[notifyname] == 1)
		{
			level.scripted_animation_counter [notifyname] = 0;
			self thread wait_notify (notifyname);
		}
	}
	*/

	if (isdefined (node))
	{
		node = getnode (node,"targetname");
		self.seeknode = node;
	
		if (level.scripted_animation_slot[notifyname] == 1)
		{
			level.scripted_animation_counter [notifyname] = 0;
			self thread wait_notify (notifyname);
		}
	}

	self.character = character;
	level.scripted_animation [notifyname][level.scripted_animation_slot[notifyname]-1] = self;
	
	if (isdefined (scr_thread))
		self.scripted_thread = scr_thread;

	
	if (isdefined (level.scr_anim[notifyname][self.character]["animation"]))
	{
		//self.walkdist = 32;	
		org = getStartOrigin (node.origin, node.angles, level.scr_anim[notifyname][self.character]["animation"]);
		self.oldhealth = self.health;
		self.health = 5000;
			
		self setgoalpos (org);
		self.goalradius = (25);
		teleport = false;
		if (isdefined (bitflags))
		{
			if (bitflags & level.teleport)
			{
				self teleport (org);
				teleport = true;
			}
		}

//		println (self.targetname, ": gettin to goal");
		level.scripted_animation_counter [notifyname]++;
		if (!teleport)
		{
//			self thread reach_queue();
			self waittill ("goal");
//			self waittill (("goal" + self.notify));
		}
//		else
//			println ("Teleporting! at time", gettime());

		level.scripted_animation_counter [notifyname]--;
	}
	else
	{
		doscriptedanim (notifyname);
		return;
	}
		
//	println (self.targetname, ": ready to start anim..");
	if (isdefined (level.scr_anim[notifyname][self.character]["idle"]))
		self thread idle_anim(node, notifyname, self.character);

	if ((isdefined (node)) && (!level.scripted_animation_counter [notifyname]))
		level.scripted_animation [notifyname][0] notify ("anim_notify" + notifyname);
	else
	if (getdvar ("debug") == "1")
		println ("Counter for sequence ", notifyname," was ", level.scripted_animation_counter [notifyname]);
}

/*
reach_queue()
{
	if (!isdefined (self.reach_queue))
	{
		self.reach_queue[0] = notifyname;
	}
}
*/

checkanim ( notifyname, total )
{
	doanim = true;
	
	for (i=0;i<total;i++)
	{
		if (!isalive (level.scripted_animation [notifyname][i]))
			donanim = false;
	}
	
	return doanim;
}

wait_notify (notifyname)
{	
	if (getdvar ("debug") == "1")
		println ("Preparing wait-notify for sequence ", notifyname);
	self waittill ("anim_notify" + notifyname);
	if (getdvar ("debug") == "1")
		println ("Wait-notify reached for sequence ", notifyname);

	total = 0;
	allai = getaiarray("axis","allies");
	for (i=0;i<allai.size;i++)
	{
		if ((isdefined (allai[i].notifyname)) && (allai[i].notifyname == notifyname))
			total++;
	}

	if (!checkanim ( notifyname, total ))
	{
		println ("Cancelling scripted animation because one of the members of the scripted sequence has died.");
		return;
	}

	for (i=0;i<total;i++)
		level.scripted_animation[notifyname][i] thread doscriptedanim (notifyname);
		
	level.scripted_animation_slot[notifyname] = undefined;
}

idle_anim (node, notifyname, character, bitflags)
{
	self endon("g_scripted_idle_anim");

	if (isdefined (node.classname))
		org = node.origin;
	else
		org = getStartOrigin (node.origin, node.angles, level.scr_anim[notifyname][character]["idle"][0]);

	if ((isdefined (bitflags)) && (bitflags & level.teleport))
		self teleport (org);
	else
	{
		oldradius = self.goalradius;
		self.goalradius = 0;
		self setgoalpos (org);
		self waittill ("goal");
		self.goalradius = oldradius;
	}

	while (isalive (self))
	{
//		if (isdefined (self.animname))
//			println ("guy is ", self.animname);
		
//		println ("animation is ", level.scr_anim[notifyname][character]["idle"][0]);
		self animscripted("scriptedanimdone", node.origin, node.angles,  
		level.scr_anim[notifyname][character]["idle"][randomint(level.scr_anim[notifyname][character]["idle"].size)] );
		self waittillmatch ("scriptedanimdone", "end");
	}
}

abort_sequence (notifyname)
{
	self waittill ("new_sequence");	
	if (getdvar ("debug") == "1")
		println ("^d Finished scripted sequence:", notifyname);
	self notify (notifyname);
}

doscriptedanim (notifyname)
{
	self notify ("g_scripted_idle_anim");
	if (isdefined (self.scripted_thread))
		thread [[self.scripted_thread]]();


/*
	if (isdefined (level.scr_anim[notifyname][self.character]["animation"]))
	{
*/
		if (isdefined (level.scr_anim[notifyname][self.character]["facial"]))
			self.facial_animation = level.scr_anim[notifyname][self.character]["facial"];
		self animscripted("scriptedanimdone", self.seeknode.origin, self.seeknode.angles, level.scr_anim[notifyname][self.character]["animation"]);
/*	
	}
	else
	{
		self.notifyname = notifyname;
		self.scriptedFacialAnim = level.scr_anim[notifyname][self.character]["facial"];
		self.scriptedFacialSound = level.scr_anim[notifyname][self.character]["sound"][0];
		self notify ("ScriptedFacial");
		return;
	}
*/

	thread abort_sequence (notifyname);
	soundnum = undefined;
	while (1)
	{
		self waittill ("scriptedanimdone", notetrack);
		if ((notetrack == "sound") || (notetrack == "dialogue") || (notetrack == "dialog"))
		{
			if (!isdefined (soundnum))
				soundnum = 0;
				

			if ((isdefined (level.scr_anim[notifyname][self.character]["sound"])) && (isdefined (level.scr_anim[notifyname][self.character]["sound"][soundnum])))
			{
//				if (getdvar ("debug") == "1")
				println ("^bPlayed friendly chat sound " + level.scr_anim[notifyname][self.character]["sound"][soundnum]);
				self playsound (level.scr_anim[notifyname][self.character]["sound"][soundnum]);
			}
			else
//			if (getdvar ("debug") == "1")
				println ("sound ", notifyname, " ", self.character, " ", soundnum , " was undefined");
			soundnum++;
		}
		else
		if (notetrack == "end")
			break;
		else
			println ("Notetrack was ", notetrack);
	}
	if (getdvar ("debug") == "1")
		println ("Sequence ", notifyname, " complete");
//	self notify ("new_sequence");	
	self notify (notifyname);
//	println ("notifyname is ", self.notifyname);
	self.notifyname = undefined;
}

abrupt_end(notifyname)
{
	self waittill ("end_sequence");
	if (!isdefined (self.notifyname))
		return;
	
	if (self.notifyname == notifyname)
	{
		self notify (notifyname);
		self.notifyname = undefined;
	}
}
