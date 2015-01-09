main()
{
	if (getdvar("hurtgentrees") == "")
		setdvar("hurtgentrees", "off");
	treetrigs = getentarray ("treetrig","targetname");
	for(i=0;i<treetrigs.size;i++)
	{
		treetrigs[i] thread treefall();
	}
}

treefall()
{
//	println("treefallsetup");
	if(!isdefined (self.target))
	{
		println ("notarget for tree trigger at ",self getorigin());
		return;
	}
	tree = getent(self.target, "targetname");
	if (getdvar("hurtgentrees") != "off")
		tree setmodel ("hurtgendeadtree");
	if(!isdefined (tree))
	{
		println("no tree");
		return;
	}
	treecol = undefined;
	if(isdefined(tree.target))
	{
		treecol = getent(tree.target,"targetname");
	}
	self waittill ("trigger", triggerer);

	self delete();
	treeorg = spawn("script_origin", tree.origin);
	treeorg.origin = tree.origin;
	treeorg.angles = triggerer.angles;
	treeorg playsound ("tankdrive_treefall");
	if(triggerer.classname == "script_vehicle")
		triggerer joltbody((treeorg.origin + (0,0,64)),.3,.67,11);


	//joltBody (<vec_jolt_origin>, <intensity>, <speed_frac>, <decel>);
 	treeang = tree.angles;
	ang = treeorg.angles;
	org = triggerer.origin;
	pos1 = (org[0],org[1],0);
	org = tree.origin;
	pos2 = (org[0],org[1],0);
	treeorg.angles = vectortoangles(pos1 - pos2);
	tree linkto(treeorg);
	if(isdefined(treecol))
		treecol delete();
	treeorg rotatepitch(-90,1.1,.05,.2);
	treeorg waittill("rotatedone");
	treeorg rotatepitch(5,.21,.05,.15);
	treeorg waittill("rotatedone");
	treeorg rotatepitch(-5,.26,.15,.1);
	treeorg waittill("rotatedone");
	tree unlink();
	treeorg delete();
}