/*
	- each trigger_use has the same target name
	trigger_use must have origin brush or it will be usable even if activate_notify is set
	also needs that so the use icon goes away after use
	- each trigger_use targets the script_model of the documents
	- add script call, example script call: 
	thread maps\_documents::main(1, "Capture the enemy documents", "documents_triggers");
	The "objective_number" parameter is the number of this objective, 
	the "array_targetname" parameter is the target name of the trigger_use(s)
	The "activate_notify" parameter is the notify the bombs wait for before becoming usable
*/


main(objective_number, objective_text, array_targetname, activate_notify)
{
	documents = getentarray (array_targetname, "targetname");
	println (array_targetname, " documents.size: ", documents.size);

	for (i=0;i<documents.size;i++)
	{
		documents[i].document = getent(documents[i].target, "targetname");
		documents[i].used = 0;
		documents[i] thread document_think(activate_notify, array_targetname);
	}
	
	if (documents.size != 0)
	{
		remaining_documents = documents.size;
		//obj_text = (objective_text1 + remaining_documents + objective_text2);

		closest = get_closest_document (documents);
		if (isdefined (closest))
		{
			objective_add(objective_number, "active", objective_text, (closest.document.origin));
			objective_string(objective_number, objective_text, remaining_documents);
		}

		while (1)
		{
			level waittill (array_targetname + " gotten");

			remaining_documents --;
			objective_string(objective_number, objective_text, remaining_documents);

			closest = get_closest_document (documents);
			if (isdefined (closest))
			{
				objective_position(objective_number, (closest.document.origin));
				objective_ring(objective_number);
			}
			else
			{
				objective_state(objective_number, "done");
				temp = ("objective_complete" + objective_number);
				println (temp);
				level notify (temp);
			}
		}
	}
}

get_closest_document(array)
{
	range = 500000000;
	ent = undefined;
	for (i=0;i<array.size;i++)
	{
		if (!array[i].used)
		{
			newrange = distance (level.player getorigin(), array[i].document.origin);
			if (newrange < range)
			{
				range = newrange;
				ent = i;
			}
		}
	}
	if (isdefined (ent) )
		return array[ent];
	else
		return;
}

document_think (activate_notify, array_targetname)
{
//	println ("waittill trigger");

	self setHintString (&"SCRIPT_PLATFORM_HINTSTR_DOCUMENTS");
	
	if (isdefined (activate_notify))
	{
		self maps\_utility::trigger_off();
		self.document hide();

		level waittill (activate_notify);

		self.document show();
		self maps\_utility::trigger_off();
	}
	self waittill("trigger");
	println ("triggered");
	//self.document playsound ("paper_pickup");
	level thread maps\_utility::play_sound_in_space("paper_pickup",self.document.origin);

	self.used = 1;
	self.document hide();
	level notify (array_targetname + " gotten");
//	self playsound ("explo_plant_rand");
	self maps\_utility::trigger_off();
}