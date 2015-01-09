start()
{
	self.codePredictCmd = [];
}

end()
{
	self.codePredictCmd = undefined;
}

addEntry(entry)
{
	self.codePredictCmd[self.codePredictCmd.size] = entry;
	handler = entry["handler"];
	[[handler]](entry);
}

addEntryPlaybackOnly(entry)
{
	self.codePredictCmd[self.codePredictCmd.size] = entry;
}

_setAnim(animation, goalWeight, goalTime, rate)
{
	entry["handler"] = ::setAnimH;
	entry["animation"] = animation;
	entry["goalWeight"] = goalWeight;
	entry["goalTime"] = goalTime;
	entry["rate"] = rate;
	addEntry(entry);
}

_setAnimKnobAll(animation, root, goalWeight, goalTime, rate)
{
	entry["handler"] = ::setAnimKnobAllH;
	entry["animation"] = animation;
	entry["root"] = root;
	entry["goalWeight"] = goalWeight;
	entry["goalTime"] = goalTime;
	entry["rate"] = rate;
	addEntry(entry);
}

_setFlaggedAnimKnobAll(notifyName, animation, root, goalWeight, goalTime, rate)
{
	entry["handler"] = ::setFlaggedAnimKnobAllH;
	entry["notifyName"] = notifyName;
	entry["animation"] = animation;
	entry["root"] = root;
	entry["goalWeight"] = goalWeight;
	entry["goalTime"] = goalTime;
	entry["rate"] = rate;
	addEntry(entry);
}

setAnimH(entry)
{
	self setAnim(entry["animation"], entry["goalWeight"], entry["goalTime"], entry["rate"]);
}

setAnimKnobAllH(entry)
{
	self setAnimKnobAll(entry["animation"], entry["root"], entry["goalWeight"], entry["goalTime"], entry["rate"]);
}

setFlaggedAnimKnobAllH(entry)
{
	self setFlaggedAnimKnobAll(entry["notifyName"], entry["animation"], entry["root"], entry["goalWeight"], entry["goalTime"], entry["rate"]);
}

stumbleWall(maxTime)
{
	maxFrames = maxTime / 0.05;
	for (i = 0; i < maxFrames; i++)
	{
		self PredictAnim(false);

		self PredictOriginAndAngles();

		entry["handler"] = ::moveH;
		entry["origin"] = self.origin;
		entry["angles"] = self.angles;
		addEntryPlaybackOnly(entry);

		switch (self getHitEntType())
		{
		case "world":
			self OrientMode("face angle", self getHitYaw());
			return true;

		case "obstacle":
			return false;
		}
	}

	return false;
}

tumbleWall(notifyName)
{
	for (;;)
	{
		for (;;)
		{
			thread getNotetrack(notifyName);
			bPredictMore = self PredictAnim(true);
			self notify(notifyName); // make notetrack be undefined if no anim notify occurs
			self waittill("predictGetNotetrack", notetrack); // wait for getNotetrack thread
			if (isdefined(notetrack))
			{
				if (notetrack == "end")
					return true;
			}
			
			if (!bPredictMore)
				break;
		}

		self PredictOriginAndAngles();
		if (self isDeflected())
			return false;

		entry["handler"] = ::moveH;
		entry["origin"] = self.origin;
		entry["angles"] = self.angles;
		addEntryPlaybackOnly(entry);
	}

	return false;
}

getNotetrack(notifyName)
{
	self waittill(notifyName, notetrack);
	self notify("predictGetNotetrack", notetrack);
}

moveH(entry)
{
	self PredictAnim(false);
	self lerpposition(entry["origin"], entry["angles"]);
	wait(0.05);
}

playback()
{
	self animMode("nophysics");
	count = self.codePredictCmd.size;
	for (i = 0; i < count; i++)
	{
		entry = self.codePredictCmd[i];
		handler = entry["handler"];
		[[handler]](entry);
		self.codePredictCmd[i] = undefined; // greedy garbage collect
	}
	self animMode("none");
}
