#include maps\_utility;

/*
psource_editmode = ""; //toggles value, edit or view default to view.
psource_image = ""; //sets image
psource_select_next = ""; // selects next psourceposition;
psource_select_prev = ""; // selects prev psourceposition
psource_setview = "";  // sets the view of the currently selected position.
psource_help ""; //prints to console some help text
psource_dump ""; //dumps view list to the console to be cut and pasted into script somewhere



*/

init()
{
	flag_init("psource_Notviewing");
	flag_init("psource_refresh");
		
}

main()
{
	/#

	if(!isdefined(level.flag) || !isdefined(level.flag["psource_refresh"]))
	{
		flag_init("psource_refresh");
		flag_init("psource_Notviewing");
	}

	level.psource_selectrad = 12;
	precacheshader("case");	
	precacheshader("psourcecreate");	
	precacheshader("psourcemodify");	

	
	setdvar("psource_image","");
	setdvar("psource_delete","");

	setdvar("psource_editmode","");
	setdvar("psource_image","");
	setdvar("psource_select_next","");
	setdvar("psource_select_prev","");
	setdvar("psource_setview","");
	setdvar("psource_help","");
	setdvar("psource_dump","");
	setdvar("psource_select_new","");
	setdvar("psource_enable","0");


	level.photosourcemodsize = 35;
	level.photosourcemod = newhudelem();
	level.photosourcemod.alignX = "center";
	level.photosourcemod.alignY = "top";	
	level.photosourcemod.horzAlign = "center";
	level.photosourcemod.vertAlign = "top";	
	level.photosourcemod.x = 0;
	level.photosourcemod.y = 0;
	level.photosourcemod.alpha = .5;
	level.photosourcemod setshader("psourcemodify",level.photosourcemodsize*2,level.photosourcemodsize);

	level.photosource = newhudelem();
	level.photosource.alignX = "left";
	level.photosource.alignY = "top";	
	level.photosource.horzAlign = "left";
	level.photosource.vertAlign = "top";	
	level.photosource.x = 0;
	level.photosource.y = 0;
	level.photosource.alpha = 0;
	level.photosource setshader("case",640,480);
	
	level.psource_editmode = false;
	
	
	if(!isdefined(level.psource_views))
		level.psource_views = [];
	
	if(!isdefined(level.psource_selectindex))
		level.psource_selectindex = level.psource_views.size;
	level.psource_viewindex = undefined;
	thread psource_viewmode();

	// this handles all of the dvar settings
	while(1)
	{
		psource_enable();  // pauses if not enabled.
		psource_image_update();
		psource_editmode_update();
		psource_select_next();
		psource_select_prev();
		psource_select_new();
		psource_setview();
		psource_delete();
		psource_dump();
		psource_help();
		wait .05;
	}
	#/
}

psource_enable()
{
	if(getdvar("psource_enable") != "1")
	{
		flag_set("psource_refresh");  // makes everything stop drawing.
		level.photosourcemod.alpha = 0;
		level.photosource.alpha = 0;
	}
	psource_waittill_enable();
	level.photosourcemod.alpha = 1;
}

psource_waittill_enable()
{
	while(getdvar("psource_enable") != "1")
		wait .1;	
}

psource_viewmode()
{
	wait .1;
	
	while(1)
	{
		psource_waittill_enable();
		flag_set("psource_Notviewing");
		flag_clear("psource_refresh");
		for(i=0;i<level.psource_views.size;i++)
			level.psource_views[i] thread psource_viewwait(i);
		thread psource_hud_preview();
		thread psource_activatebutton();
		thread psource_handleselectindex();
		flag_wait("psource_refresh");
		flag_wait("psource_Notviewing");
	}
}

psource_activatebutton()
{
	level endon ("psource_refresh");
	while(1)
	{
		while(!level.player usebuttonpressed())
			wait .05;
		pick = psource_getvisible();
		if(isdefined(pick))
		{
			level.psource_selectindex = pick;
			level.psource_views[pick] thread psource_hudshow();
			
		}
		while(level.player usebuttonpressed())
			wait .05;
	}
}

psource_handleselectindex()
{
	level endon ("psource_refresh");
	lastselect = level.psource_selectindex;
	while(1)
	{
		if(!isdefined(level.psource_views[lastselect]))
			level.photosourcemod setshader("psourcecreate",level.photosourcemodsize*2,level.photosourcemodsize);
			
		if(lastselect == level.psource_selectindex)
		{
			wait .05;
			continue;
		}
		lastselect = level.psource_selectindex;
		if(isdefined(level.psource_views[lastselect]))
			level.psource_views[lastselect] thread psource_hudshow();

	}
}

psource_hud_preview()
{
	level endon ("psource_refresh");
	while(1)
	{
		pick = psource_getvisible();
		if(!isdefined(pick))
		{
			level.photosource fadeovertime(1);
			level.photosource.alpha = 0;
			level.psource_viewindex = undefined;
			wait .05;
			continue;
		}
		level.psource_viewindex = pick;
		view = level.psource_views[pick];
		if(isdefined(view.temp_image))
			level.photosource setshader(view.temp_image,200,150);
		else
			level.photosource setshader(view.image,200,150);
		level.photosource.alpha = 1;
		while(isdefined(psource_getvisible()) && psource_getvisible() == pick)
			wait .05;			
		flag_set("psource_refresh");
	}
}

psource_getvisible()
{
	index = undefined;
	dist = 1000000;
	for(i=0;i<level.psource_views.size;i++)
	{
		if(level.player islookingorg(level.psource_views[i]))
		{
			newdist = distance(level.player geteye(),level.psource_views[i].origin);
			if(newdist < dist)
			{
				dist = newdist;
				index  = i;
				
			}
		}
	}
	return index;
}

psource_viewwait(index)
{
	level endon ("psource_refresh");
	arrowlength = 55;
	viewradexpandmax = 8;
	viewradexpandcount = 0;
	viewraddir = 1;
	frametime = .05;
	while(1)
	{
		if(distance(flat_origin(self.origin),flat_origin(level.player.origin)) < 32)
		{
			wait .05;
			continue;
		}
		thread draw_arrow_time(self.origin,self.origin+vector_multiply(anglestoforward(self.angles),arrowlength),(0,1,1),frametime);

		if(level.psource_selectindex == index)
			thread plot_circle_star_fortime(level.psource_selectrad,frametime,(1,1,0));
		else
			thread plot_circle_fortime(level.psource_selectrad,frametime,(0,1,0));
		if(isdefined(level.psource_viewindex) && level.psource_viewindex == index)
		{
			thread debug_message("image: "+self.image,self.origin,frametime);
			if(viewradexpandcount > viewradexpandmax)
				viewraddir = -1;
			else if(viewradexpandcount < 0)
				viewraddir = 1;
			viewradexpandcount+=viewraddir;
			viewrad = level.psource_selectrad+3+viewradexpandcount;
			viewcolor = (0,1,1);
		}
		else
		{
			viewrad = level.psource_selectrad+3;
			viewcolor = (0,1,0);
		}
		thread plot_circle_fortime(viewrad,frametime,viewcolor);
		wait .05;
	}
}

plot_circle_star_fortime (radius,time,color)
{
	if(!isdefined(color))
		color = (0,1,0);
	hangtime = .05;
	circleres = 16;
	hemires = circleres/2;
	circleinc = 360/circleres;
	circleres++;
	plotpoints = [];
	rad = 0;

	plotpoints = [];
	rad = 0.000;
	timer = gettime()+(time*1000);
	while(gettime()<timer)
	{
		angletoplayer = vectortoangles(self.origin-level.player geteye());
		for(i=0;i<circleres;i++)
		{
			plotpoints[plotpoints.size] = self.origin+vector_multiply(anglestoforward((angletoplayer+(rad,90,0))),radius);
			rad+=circleinc;
		}
		for(i=0;i<plotpoints.size;i++)
			line(plotpoints[i],self.origin,color,1);
		plotpoints = [];
		wait hangtime;
	}
}

plot_circle_fortime(radius,time,color)
{
	if(!isdefined(color))
		color = (0,1,0);
	hangtime = .05;
	circleres = 16;
	hemires = circleres/2;
	circleinc = 360/circleres;
	circleres++;
	plotpoints = [];
	rad = 0;

	plotpoints = [];
	rad = 0.000;
	timer = gettime()+(time*1000);
	while(gettime()<timer)
	{
		angletoplayer = vectortoangles(self.origin-level.player geteye());
		for(i=0;i<circleres;i++)
		{
			plotpoints[plotpoints.size] = self.origin+vector_multiply(anglestoforward((angletoplayer+(rad,90,0))),radius);
			rad+=circleinc;
		}
		plot_points(plotpoints,color[0],color[1],color[2],hangtime);
		plotpoints = [];
		wait hangtime;
	}
}

psource_hudshow()
{
	flag_clear("psource_Notviewing");
	level.photosourcemod setshader("psourcemodify",level.photosourcemodsize*2,level.photosourcemodsize);
	if(isdefined(self.temp_image))
		level.photosource setshader(self.temp_image,640,480);
	else
		level.photosource setshader(self.image,640,480);
	level.player freezecontrols(true);
	level.player setorigin( self.origin+(level.player.origin-level.player geteye()) - vector_multiply(anglestoforward(self.angles),3));
	level.player setplayerangles(self.angles);
	level.photosource.alpha = 1;
	flag_set ("psource_refresh");
	while(level.player islookingorg(self) && level.player usebuttonpressed())
		wait .05;
	level.player freezecontrols(false);

	level.photosource.alpha = 0;
	flag_set("psource_Notviewing");
}

psource_select_next()
{
	if(getdvar("psource_select_next") == "")
		return;
	if(!(level.psource_selectindex == level.psource_views.size))
		level.psource_selectindex++;
		
	setdvar("psource_select_next","");		
	
}

psource_select_prev()
{
	if(getdvar("psource_select_prev") == "")
		return;
	if(!(level.psource_selectindex == 0))
		level.psource_selectindex--;
	setdvar("psource_select_prev","");		
	
}

psource_select_new()
{
	if(getdvar("psource_select_new") == "")
		return;
	level.psource_selectindex = level.psource_views.size;
	setdvar("psource_select_new","");		
	
}

psource_setview()
{
	if(getdvar("psource_setview") == "")
		return;
	view = psource_getcurrentview();
//	view.temp_image = "case";
	psource_setvieworgang(view);
	setdvar("psource_setview","");	
}

psource_setvieworgang ( view )
{
	view.origin = level.player geteye();
	view.angles = level.player getplayerangles();
}

psource_dump ()
{
	if(getdvar("psource_dump") == "")
		return;
	println (" ");
	println (" ");
	println (" ");
	println ("--------******--------");
	println ("   photo source dump  (paste these to your level script before maps\_load::main() ) ");
	println ("--------******--------");
	println (" ");
	println (" ");
//	println ("thread maps\\\_photosource::photosource_init();");
	for(i=0;i<level.psource_views.size;i++)
		println ("maps\\\_photosource::psource_create(\""+level.psource_views[i].image+"\","+level.psource_views[i].origin+","+level.psource_views[i].angles+");");
//	println ("thread maps\\\_photosource::photosource_main();");
	println (" ");
	println (" ");
	println (" ");
	setdvar("psource_dump","");		
	
}

psource_help ()
{
	if(getdvar("psource_help") == "")
		return;
	println(" ");
	println(" ");
	println("Photo refrenence - Help ");
	println(" ");
	println(" photo reference is a tool to help communicate art direction within the level ");
	println(" An artist or a level designer can run this tool to place images of photo ");
	println(" source like a gallery throughout the level.");
	println(" ");
	println(" before starting do /exec psource.cfg");
	println(" ");
	println("psource_enable ( 7 Key ) - toggles psource on and off");
	println("psource_setview ( 8 Key ) - sets the view of the currently selected position.");
	println("psource_select_prev ( [ Key ) - selects prev psourceposition");
	println("psource_select_next ( ] Key ) - selects next psourceposition");
	println("psource_select_new ( \\ Key ) - selects NEW psourceposition, used to create a new position on setview");
	println("psource_help ( h Key ) - prints to console this help text");
	println("psource_dump ( u Key ) - dumps view list to the console to be cut and pasted into script somewhere");
	println("psource_delete ( del Key ) - deletes the currently selected view (yellow star in circle)");
	println(" ");
	println("Pressing the usebutton on a sphere will teleport you so that you can see ");
	println("the desired angle of the piece of reference, this also selects the view");
	println("and highlights it yellow");
	println(" ");
	println("To change the image of the currently selected view go to the console and enter this dvar");
	println("psource_image <materialname>");
	println(" ");
	println("Once you have all your views press the dump button, open your console.log and paste the script to your level script");
	setdvar("psource_help","");		
}



psource_delete()
{
	if(getdvar("psource_delete") == "")
		return;
	newarray = [];
	for(i=0;i<level.psource_views.size;i++)
		if(i != level.psource_selectindex)
			newarray[newarray.size] = level.psource_views[i];
	level.psource_views = newarray;
	flag_set ("psource_refresh");
	setdvar("psource_delete","");		
}

psource_select_template()
{
	if(getdvar("psource_select_template") == "")
		return;
	setdvar("psource_select_template","");		
}

psource_editmode_update()
{
	if(getdvar("psource_editmode") == "")
		return;
	if(!level.psource_editmode)
		level.psource_editmode = true;
	else
		level.psource_editmode = false;
	setdvar("psource_editmode","");		
}

psource_image_update()
{
	if(getdvar("psource_image") == "")
		return;
	view = psource_getcurrentview();
	view.image =  getdvar("psource_image");
	view.temp_image = "case"; //this is what will show when a new material is created (can't load mid level)
	setdvar("psource_image","");	
}

psource_getcurrentview()
{
	view = undefined;
	if(isdefined(level.psource_views[level.psource_selectindex]))
		view = level.psource_views[level.psource_selectindex];
	else
		view = psource_newview(false);
	return view;	 
}

psource_newview(bScriptAdded)
{
	if(!bScriptAdded)
		level.photosourcemod setshader("psourcemodify",level.photosourcemodsize*2,level.photosourcemodsize);

	view = spawnstruct();
	view.image = "case";
	if(!bScriptAdded)
	{
		view.temp_image = "case";
		psource_setvieworgang(view);
		
	}
	if(isdefined(level.psource_views[level.psource_selectindex]))
		level.psource_views[level.psource_selectindex] delete();
	level.psource_views[level.psource_selectindex] = view;
	if(!bScriptAdded)
		flag_set("psource_refresh");
	return view;
}

//use this in level file to initialize all the stuff.
psource_create ( image , position, angle )
{
	/#
	if(!isdefined(level.flag))
		level.flag = [];
	if(!isdefined(level.flag["psource_Notviewing"]))	
		init();
	if(!isdefined(level.psource_selectindex))
		level.psource_selectindex = 0;
	if(!isdefined(level.psource_views))
		level.psource_views = [];
	view = psource_newview(true);
	view.origin = position;
	view.angles = angle;
	precacheshader(image);
	view.image = image;
	level.psource_selectindex++;
	#/
}

islookingorg(view)
{
	normalvec = vectorNormalize(view.origin-self getShootAtPos());
	veccomp = vectorNormalize((view.origin-(0,0,level.psource_selectrad*2))-self getShootAtPos());
	insidedot = vectordot(normalvec,veccomp);
	
	anglevec = anglestoforward(self getplayerangles());
	vectordot = vectordot(anglevec,normalvec);
	if(vectordot > insidedot)
		return true;
	else
		return false;
}