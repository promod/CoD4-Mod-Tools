#include common_scripts\utility;
#include maps\_utility;

pickRandomPath()
{
	calcDists();
	while (1)
	{
		startNode = level.waypointHeading[randomint(level.waypointHeading.size)];
		endNode = startNode;
		
		while (endNode == startNode)
			endNode = level.waypointHeading[randomint(level.waypointHeading.size)];
			
		randomPath = generatePath (startNode, endNode);
		level thread drawPath (randomPath, 10);
		wait (10.0);
	}
}

// call function as generatePath(startNode, destNode), otherwise paths will be reversed
generatePath (destNode, startNode, blockedNodes)
{
	level.openList = [];
	level.closedList = [];
	foundPath = false;
	pathNodes = [];
	
	if (!isdefined (blockedNodes))
		blockedNodes = [];
	
	startNode.g = 0;
	startNode.h = getHValue (startNode, destNode);
	startNode.f = startNode.g + startNode.h;
	
	addToClosedList (startNode);

	curNode = startNode;
	while (1)
	{
		for (i = 0; i < curNode.link.size; i++)
		{
			checkNode = curNode.link[i];
			
			if (is_in_array (blockedNodes, checkNode))
				continue;
			
			if (is_in_array (level.closedList, checkNode))
				continue;
				
			if (!is_in_array (level.openList, checkNode))
			{
				addToOpenList (checkNode);
				checkNode.parentNode = curNode;
				checkNode.g = getGValue (checkNode, curNode);
				checkNode.h = getHValue (checkNode, destNode);
				checkNode.f = checkNode.g + checkNode.h;
				
				if (checkNode == destNode)
					foundPath = true;
			}
			else
			{
				if (checkNode.g < getGValue (curNode, checkNode))
					continue;
				
				checkNode.parentNode = curNode;
				checkNode.g = getGValue (checkNode, curNode);
				checkNode.f = checkNode.g + checkNode.h;					
			}
		}
		
		if (foundPath)
			break;
			
		addToClosedList (curNode);
		
		bestNode = level.openList[0];
		for (i = 1; i < level.openList.size; i++)
		{
			if (level.openList[i].f > bestNode.f)
				continue;

			bestNode = level.openList[i];
		}
		
		if (!isdefined (bestNode)) // no path found
			return pathNodes;	

		addToClosedList (bestNode);
		curNode = bestNode;
	}

	assert (isdefined (destNode.parentNode));
	
	curNode = destNode;
	while (curNode != startNode)
	{
		pathNodes[pathNodes.size] = curNode;
		curNode = curNode.parentNode;
	}
	pathNodes[pathNodes.size] = curNode;
	
	return pathNodes;	
}

addToOpenList (node)
{
	node.openListID = level.openList.size;
	level.openList[level.openList.size] = node;
	node.closedListID = undefined;
}

addToClosedList (node)
{
	if (isdefined (node.closedListID))
		return;
	
	node.closedListID = level.closedList.size;
	level.closedList[level.closedList.size] = node;
	
	if (!is_in_array (level.openList, node))
		return;
		
	level.openList[node.openListID] = level.openList[level.openList.size - 1];
	level.openList[node.openListID].openListID = node.openListID;
	level.openList[level.openList.size - 1] = undefined;
	node.openListID = undefined;
}

calcDists ()
{
	/*
	for (i = 0; i < level.waypointHeading.size; i++)
	{
		curNode = level.waypointHeading[i];
		
		if (!isdefined (curNode.nodeDists))
			curNode.nodeDists = [];
			
		for (j = 0; j < curNode.link.size; j++)
		{
			if (curNode getentnum() < curNode.link[j] getentnum())
			{
				storageNode = curNode;
				storageString = curNode getentnum() + " " + curNode.link[j] getentnum();
			}
			else
			{
				storageNode = curNode.link[j];
				storageString = curNode.link[j] getentnum() + " " + curNode getentnum();
			}
			
			if (!isdefined (storageNode.nodeDists) || !isdefined (storageNode.nodeDists[storageString]))
				storageNode.nodeDists[storageString] = distance (curNode.origin, curNode.link[j].origin);
		}
	}
	*/
}

getHValue (node1, node2)
{
	return (distance (node1.origin, node2.origin));
}

getGValue(node1, node2)
{
	return (node1.parentNode.g + distance (node1.origin, node2.origin));
//	return (node1.parentNode.g + getDist (node1, node2));
}

getDist(node1, node2)
{
/*
	if (node2 getentnum() < node1 getentnum())
	{
		tempNode = node2;
		node2 = node1;
		node1 = tempNode;
	}
	
	indexString = node1 getentnum() + " " + node2 getentnum();
	assert (isdefined (node1.nodeDists[indexString]));
	
	return (node1.nodeDists[indexString]);
*/
}

drawPath (pathNodes, duration, id)
{
	if (!isdefined (id))
		id = "msg";
	/*
	if (duration == -1)
	{
		for (i = 1; i < pathNodes.size; i++)
			level thread drawLinkForever (pathNodes[i].origin, pathNodes[i - 1].origin, (1,0,0));
	}
	else
	*/
	{
		level notify ("draw new path" + id);
		for (i = 1; i < pathNodes.size; i++)
			level thread drawLink (pathNodes[i].origin, pathNodes[i - 1].origin, duration, id);
	}
}

drawPathOffshoots (pathNodes, duration)
{
	level endon ("newpath");
	duration = 10;
	
	for (i=0;i<pathNodes.size-1;i++)
	{
		for (p=0;p<pathNodes[i].link.size;p++)
		{
			if (i>0 && pathNodes[i].link[p] == pathNodes[i-1])
				continue;
				
			if (pathNodes[i].link[p] == pathNodes[i+1])
				level thread drawLinkFull (pathNodes[i], pathNodes[i].link[p], (1,0,0), false, duration);
			else
				level thread drawLinkFull (pathNodes[i], pathNodes[i].link[p], (0,0,1), true, duration);
		}
	}
	
	lastLink = pathNodes[pathNodes.size-1];
	for (p=0;p<lastLink.link.size;p++)
	{
		if (lastLink.link[p] == pathNodes[pathNodes.size-2])
			continue;
		level thread drawLinkFull (lastLink, lastLink.link[p], (0,0,1), true, duration);
	}
}

drawLink (start, end, duration, id)
{
	level endon ("draw new path" + id);
	for (i = 0; i < duration * 20; i++)
	{
		line(start, end, (1, 0, 0), true);
		wait 0.05;
	}
}

drawLinkFull (start, end, color, limit, duration)
{
	level endon ("newpath");
	pts = [];
	angles = vectortoangles(start.origin - end.origin);
	right = anglestoright(angles);
	forward = anglestoforward(angles);
	pts[pts.size] = end.origin + vectorScale(right, end.radius);
	pts[pts.size] =  start.origin + vectorScale(right, start.radius);
	pts[pts.size] =  start.origin + vectorScale(right, start.radius * -1);
	pts[pts.size] =  end.origin + vectorscale(right, end.radius * -1);

	dist = distance(start.origin, end.origin);
	arrow = [];
	stages = 10;
	range = 0.15;
	for (i=0;i<stages;i++)
	{
		stage = i+1;
		arrow[i][0] =  start.origin;
		arrow[i][1] =  start.origin + vectorscale(right, dist*(range * (i/stages))) + vectorscale(forward, dist*-0.2);
		arrow[i][2] =  end.origin;
		arrow[i][3] =  start.origin + vectorscale(right, dist*(-1 * range * (i/stages))) + vectorscale(forward, dist*-0.2);
	}
	
	for (p = 0; p < duration * 20; p++)
	{
		for (i=0;i<pts.size;i++)
		{
			nextpoint = i+1;
			if (nextpoint >= pts.size)
			{
				if (limit)
					break;
				nextpoint = 0;
			}
			line(pts[i], pts[nextpoint], color, 1.0);
		}

		for (i=0;i<stages;i++)
		{
			for (p=0;p<4;p++)
			{
				nextpoint = p+1;
				if (nextpoint >= 4)
					nextpoint = 0;
				line(arrow[i][p], arrow[i][nextpoint], color, 1.0);
			}
		}
		wait 0.05;
	}
}

getPathBetweenPoints(start, end)
{
	startNode = getClosest(start, level.waypointHeading);
	endNode = getClosest(end, level.waypointHeading);

	path = generatePath (startNode, endNode);
/#
	if (getdebugdvar("debug_astar") == "on")
		level thread drawPath (path, 15);
#/
		
	return path;
}

getPathBetweenArrayOfPoints(start, orgArray)
{
	paths=[];
	array = [];
	for (i=0;i<orgArray.size;i++)
		array[i] = getClosest(orgArray[i], level.waypointHeading);
	
	startNode = getClosest(start, level.waypointHeading);
	paths[paths.size] = generatePath (startNode, array[0]);
	
	for (i=0;i<array.size-1;i++)
		paths[paths.size] = generatePath (array[i], array[i+1]);

	newpath = [];
	for (i=0;i<paths.size;i++)
	{	
		for (p=0;p<paths[i].size-1;p++)
			newpath[newpath.size] = paths[i][p];
	}

	// tag the last connection on 
	newpath[newpath.size] = paths[paths.size-1][paths[paths.size-1].size-1];
	
	
	path = newpath;
	newpath = [];
	if (!path.size)
		return newpath;
		
	// Remove duplicate path waypoints
	curpath = path[0];
	newpath[newpath.size] = curpath;
	for (i=1;i<path.size;i++)
	{
		if (path[i] == curpath)
			continue;
		newpath[newpath.size] = path[i];
	}

/#
	if (getdebugdvar("debug_astar") == "on")
		level thread drawPath (newpath, 15);
#/
	return newpath;
}

