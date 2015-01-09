#include common_scripts\utility;
main()
{	
	treebursts = getentarray("treeburst", "script_noteworthy");
	for(i = 0; i < treebursts.size; i++)
		treebursts[i] thread treeburst();
}

treeburst()
{
	self waittill("treeburst");

	if(isdefined(self.script_falldirection))
		yaw = self.script_falldirection;
	else
		yaw = randomint(360);
		
	break_angles = (self.angles[0], yaw, self.angles[2]);
	break_vector = anglesToForward(break_angles);
	break_vector = vectorScale(break_vector, 100);

	// yellow - break vector
//	thread drawline(self.origin, (self.origin + break_vector), (1, 1, 0), 1);
	
	start = (self.origin + break_vector) + (0, 0, 512);
	end = start + (0, 0, -1024);

	trace = bulletTrace(start, end, false, self);

	// orange - drop to position trace
//	thread drawline(start, trace["position"], (1, .5, 0), 1);

	dist_vector = ((self.origin + break_vector) - trace["position"]);
	dist = dist_vector[2];

	velocity = 0;
	travelled = 0;
	lasttravelled = travelled;
	count = 0;
	lastcount = count;
	
	while(travelled < dist)
	{
		//velocity = velocity + 385.8267717;
		velocity = velocity + 340;

		lasttravelled = travelled;
		travelled = travelled + velocity;

		lastcount = count;
		count++;
	}

	remainder = lasttravelled - dist;
	if(remainder < 0)
		remainder = remainder * -1;
		
	time = lastcount + (remainder / velocity);

	self moveGravity(break_vector, time);
//	self moveTo(trace["position"], time, (time / 2), 0);
	self waittill("movedone");

	vec = vectorNormalize(break_vector);
	//vec = vectorScale(vec, 150);
	vec = vectorScale(vec, 320);

	start = (self.origin + vec) + (0, 0, 512);
	end = start + (0, 0, -1024);
	trace = bulletTrace(start, end, false, self);

	ground = trace["position"];

	// blue - rotate to position trace
//	thread drawline(start, ground, (0, 0, 1), 1);

	// red - vector showing rotated position
//	thread drawline(self.origin, ground, (1, 0, 0), 1);
	
	treeup_vector = anglesToUp(self.angles);
	treeup_angles = vectortoangles(treeup_vector);
	rest_vector = ground - self.origin;
	rest_angles = vectorToAngles(rest_vector);

	treeorg = spawn("script_origin", self.origin);
	treeorg.origin = self.origin;
	treeorg.angles = (treeup_angles[0], rest_angles[1], rest_angles[2]);	
		
	self linkto(treeorg);
		
	treeorg rotateTo(rest_angles, 1.15, .5, 0);
	treeorg waittill("rotatedone");

//	treeorg rotatepitch(90,1.1,.05,.2);
//	treeorg waittill("rotatedone");
	treeorg rotatepitch(-2.5,.21,.05,.15);
	treeorg waittill("rotatedone");
	treeorg rotatepitch(2.5,.26,.15,.1);
	treeorg waittill("rotatedone");

	self unlink();

	treeorg delete();
}

drawline(start, end, color, alpha)
{
	while(1)
	{
		line(start, end, color, alpha);
		wait .05;
	}
}

draworigin(origin, color, alpha)
{
	if(!isdefined(alpha))
		alpha = 1;

	if(isdefined(color))
	{
		while(1)
		{
			line(origin + (16, 0, 0), origin + (-16, 0, 0), color, alpha);
			line(origin + (0, 16, 0), origin + (0, -16, 0), color, alpha);
			line(origin + (0, 0, 16), origin + (0, 0, -16), color, alpha);
			
			wait .05;
		}
	}
	else
	{
		while(1)
		{
			red = (1, 0, 0);
			green = (0, 1, 0);
			blue = (0, 0, 1);
			
			line(origin + (16, 0, 0), origin + (-16, 0, 0), red, alpha);
			line(origin + (0, 16, 0), origin + (0, -16, 0), green, alpha);
			line(origin + (0, 0, 16), origin + (0, 0, -16), blue, alpha);
			
			wait .05;
		}
	}
}
