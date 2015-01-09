main()
{
	if (getdvar("debug_vehiclegod") == "")
		setdvar("debug_vehiclegod", "off");
	if (getdvar("debug_vehicleplayerhealth") == "")
		setdvar("debug_vehicleplayerhealth", "off");
	if (getdvar("player_vehicle_dismountable") == "")
		setdvar("player_vehicle_dismountable", "off");
	
	precacheShader("tank_shell");
	level.playeronvehicle = false;
}

vehicle_wait(startinvehicle)
{
	if(!isdefined(startinvehicle))
		startinvehicle = false;
	else if(startinvehicle) 
	{
		if(getdvar("player_vehicle_dismountable") == "off")
			self makevehicleunusable();
	}
	self endon ("death");
	self endon ("stop_vehicle_wait");
	while (self.health > 0)
	{
		if(!(startinvehicle))
		 	self waittill ("trigger");
		else
		{
			startinvehicle = false;
			self useby(level.player);
		}
		owner = self getvehicleowner();
		if(isdefined(owner) && owner == level.player)
			self thread vehicle_enter();
		else
			self thread vehicle_exit();
		if(startinvehicle)
			break;
		wait 0.05;
	}
}

vehicle_exit()
{
	level.playeronvehicle = false;
	level.playervehicle = level.playervehiclenone;
	level notify ("player exited vehicle");


	if(isdefined(level.player.oldthreatbias))
	{
		level.player.threatbias = level.player.oldthreatbias;
		level.player.oldthreatbias = undefined;
	}
//	level.player.ignoreme = false;
	if (isdefined (level.vehicleHUD))
		level.vehicleHUD destroy();
	if (isdefined (level.vehicleHUD2))
		level.vehicleHUD2 destroy();
	if (isdefined (level.VehicleFireIcon))
		level.VehicleFireIcon destroy();
}

vehicle_enter()
{
	level.playeronvehicle = true;
	level.playervehicle = self;
		self thread vehicle_ridehandle();
	
// probably rethink this stuff	
//	self thread Protect_Player();
}

setup_vehicle_tank()
{
	self vehicle_giveHealth();
}

setup_vehicle_other()
{
	self vehicle_giveHealth();
}

vehicle_giveHealth()
{
	//GIVE THE VEHICLE HEALTH BASED ON SKILL LEVEL
	skill = getdifficulty();
	
	if(skill == ("easy"))
		self.health  = 3000;
	else if(skill == ("medium"))
		self.health = 2500;
	else if(skill == ("hard"))
		self.health = 2000;
	else if(skill == ("fu"))
		self.health = 1300;
	else
		self.health = 2000;

	if(isdefined(self.healthbuffer))
	{
		self.health += self.healthbuffer;  //restore healthbuffer
		self.currenthealth = self.health;
		self.maxhealth = self.health;
		
	}
}

Protect_Player()
{
	level endon ("player exited vehicle");
	self endon ("death");
	playerCurrentHealth = level.player.health;
	/*
	if(self.vehicletype == "flak88" || self.vehicletype == "flak88_forward")
	{
		if(!isdefined(level.player.oldthreatbias))
		{
			level.player.oldthreatbias = level.player.threatbias;
//			level.player.ignoreme = true;
		}
		level.player.threatbias = -3000;			

	}
	*/
	while(isalive(level.player))
	{
		level.player waittill ("damage",ammount);
/*
		if(self.vehicletype != "flak88" && self.vehicletype != "flak88_forward")
		{
			if(self.health <= 0)
				level.player DoDamage ( level.player.health + 50, (0,0,0) );
			else
				level.player.health = playerCurrentHealth;
		}
		else
		{
*/
			if(self.health <= 0)
				level.player DoDamage ( level.player.health + 50, (0,0,0) );
			level.player.health += int(ammount*.2);
//		}
	
	}
}

//handles varius Hudelements and health regeneration
vehicle_ridehandle()
{
	level endon ("player exited vehicle");
	self endon ("no_regen_health");
	self endon ("death");
	
// commenting out sound bit as it is too vehicle specific, these things should be defined in vehicle script not here	
//	self thread vehicle_reloadsound();
//	self thread vehicle_hud_tank_fireicon();
	self thread vehicle_kill_player_ondeath();
	self.maximumhealth = self.health;
	
	switch(getdifficulty())
	{
		case "gimp":
		health_regeninc = 100;
		health_regentimer = 2700;
		break;
		case "easy":
		health_regeninc = 75;
		health_regentimer = 2700;
		break;
		case "medium":
		health_regeninc = 50;
		health_regentimer = 2700;
		break;
		case "hard":
		health_regeninc = 30;
		health_regentimer = 3700;
		break;
		case "fu":
		health_regeninc = 20;
		health_regentimer = 4700;
		break;
		default:
		health_regeninc = 50;
		health_regentimer = 2700;
		break;
		
	}
	if(self.vehicletype == "crusader_player")
	{
		self setmodel ("vehicle_crusader2_viewmodel");
	}

	regentimer = gettime();
	if (getdvar("debug_vehiclegod") != "off")
	{
		while(1)
		{
			self waittill ("damage");
			self.health = self.maxhealth;
		}
	}
	thread vehicle_damageset();
	regeninctimer = gettime();
	while(1)
	{
		
		if(self.damaged)
		{
			if(getdvar("debug_vehicleplayerhealth") != "off")
				iprintlnbold("playervehicles health: ",self.health-self.healthbuffer);
			self.damaged = false;
			regentimer = gettime()+health_regentimer;
		}
		
		time = gettime();
		if(self.health < self.maximumhealth && time > regentimer && time > regeninctimer)
		{
			if(self.health+health_regeninc > self.maximumhealth)
				self.health = self.maximumhealth;
			else
				self.health+= health_regeninc;
			regeninctimer = gettime()+250;
			if(getdvar("debug_vehicleplayerhealth") != "off")
				iprintlnbold("playervehicles health: ",self.health-self.healthbuffer);
		}
			
		wait .05;
	}
}

vehicle_kill_player_ondeath()
{
	level endon ("player exited vehicle");
	self waittill ("death");
	level.player enablehealthshield(false);
	while(1)
	{
		level.player DoDamage ( level.player.health + 500, level.player.origin );
		wait .1;		
	}
	wait .5;
	level.player enablehealthshield(true);
}

vehicle_damageset()
{
	self.damaged = false;
	self endon ("death");
	while(1)
	{
		self waittill ("damage",ammount);
		println("damage ",ammount);
		self.damaged = true;
	}
}

vehicle_reloadsound()
{
	while (1)
	{
		self waittill ("turret_fire");
		wait .5;
		self playsound ("tank_reload");
	}	
}

vehicle_hud_tank_fireicon()
{
	if(getdvar("player_vehicle_dismountable") != "off")
		return;
	level endon ("player exited vehicle");
	level.player endon ("death");
	self endon ("death");
	if (isdefined (level.VehicleFireIcon))
		level.VehicleFireIcon destroy();
	
	level.VehicleFireIcon = newHudElem();
	level.VehicleFireIcon.x = -32;
	level.VehicleFireIcon.y = -64;
	level.VehicleFireIcon.alignX = "center";
	level.VehicleFireIcon.alignY = "middle";
	level.VehicleFireIcon.horzAlign = "right";
	level.VehicleFireIcon.vertAlign = "bottom";
	level.VehicleFireIcon setShader("tank_shell", 64, 64);
	
	icon = true;
	level.VehicleFireIcon.alpha = icon;
	while (1)
	{
		if(icon)
		{
			if(!self isTurretReady())
			{
				icon = false;
				level.VehicleFireIcon.alpha = icon;
			}
		}
		else
		{
			if(self isTurretReady())
			{
				icon = true;
				level.VehicleFireIcon.alpha = icon;
			}
			
		}
		wait .05;
	}
}

// sarah - remove this when the SP health overlay is moved back to code.
healthOverlay()
{
	self endon ("death");
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ("overlay_low_health", 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

//	wait (15000);
	maxHealth = self.health-self.healthbuffer;
	hurt = false;
	bonus = 0.3;
	for (;;)
	{
		healthRatio = (self.health-self.healthbuffer) / maxHealth;
		pulseTime = 0.5 + (0.5 * healthRatio);
		if (healthRatio < 0.75 || hurt)
		{
			if (!hurt)
			{
				hurt = true;
			}

			fullAlpha = (1.0 - healthRatio) + bonus;
			
			overlay fadeOverTime(0.05);
			overlay.alpha = fullAlpha;
			wait (0.1);
			overlay fadeOverTime(pulseTime*0.2);
			overlay.alpha = fullAlpha * 0.5;
			wait (pulseTime*0.2);
			overlay fadeOverTime(pulseTime*0.3);
			overlay.alpha = fullAlpha * 0.3;
			wait (pulseTime*0.3);


			healthRatio = (self.health-self.healthbuffer) / maxHealth;
			pulseTime = 0.3 + (0.7 * healthRatio);
			if (healthRatio > 0.9)
			{
				hurt = false;
				overlay fadeOverTime(0.5);
				overlay.alpha = 0;
				wait (pulseTime*0.5) - 0.1;
			}
			else
				wait (pulseTime*0.5) - 0.1;
		}
		else
			wait (0.05);
	}
}