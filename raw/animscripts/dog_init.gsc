#using_animtree( "dog" );

main()
{
	self useAnimTree( #animtree );
	
	initDogAnimations();
	animscripts\init::firstInit();
	
	self.ignoreSuppression = true;
	
	self.chatInitialized = false;
	self.noDodgeMove = true;
	self.root_anim = %root;

	self.meleeAttackDist = 0;
	self thread setMeleeAttackDist();

	self.a = spawnStruct();
	self.a.pose = "stand";					// to use DoNoteTracks()
	self.a.nextStandingHitDying = false;	// to allow dogs to use bullet shield
	self.a.movement = "run";

	animscripts\init::set_anim_playback_rate();

	self.suppressionThreshold = 1;
	self.disableArrivals = false;
	self.stopAnimDistSq = anim.dogStoppingDistSq;

	self thread animscripts\combat_utility::monitorFlash();

	self.pathEnemyFightDist = 512;
	self setTalkToSpecies( "dog" );

	self.health = int( anim.dog_health * self.health );
}


setMeleeAttackDist()
{
	self endon( "death" );

	while ( 1 )
	{
		if ( isdefined( self.enemy ) && self.enemy == level.player )
			self.meleeAttackDist = anim.dogAttackPlayerDist;
		else
			self.meleeAttackDist = anim.dogAttackAIDist;

		self waittill( "enemy" );
	}
}


initDogAnimations()
{
	if ( !isdefined( level.dogsInitialized ) )
	{
		level.dogsInitialized = true;
		precachestring( &"SCRIPT_PLATFORM_DOG_DEATH_DO_NOTHING" );
		precachestring( &"SCRIPT_PLATFORM_DOG_DEATH_TOO_LATE" );
		precachestring( &"SCRIPT_PLATFORM_DOG_DEATH_TOO_SOON" );
		precachestring( &"SCRIPT_PLATFORM_DOG_HINT" );		
	}
	
	// Initialization that should happen once per level
	if ( isDefined( anim.NotFirstTimeDogs ) )// Use this to trigger the first init
		return;
	precacheShader( "hud_dog_melee"	);
	anim.NotFirstTimeDogs = 1;
	anim.dogStoppingDistSq = lengthSquared( getmovedelta( %german_shepherd_run_stop, 0, 1 ) * 1.2 ) ;
	anim.dogStartMoveDist = length( getmovedelta( %german_shepherd_run_start, 0, 1 ) );
	
	// notetime = getNotetrackTimes( %german_shepherd_attack_player, "dog_melee" );
	// anim.dogAttackPlayerDist = length( getmovedelta( %german_shepherd_attack_player, 0, notetime[ 0 ] ) );
	anim.dogAttackPlayerDist = 102;// hard code for now, above is not accurate.

	offset = getstartorigin( ( 0, 0, 0 ), ( 0, 0, 0 ), %german_shepherd_attack_AI_01_start_a );
	anim.dogAttackAIDist = length( offset );
	
	anim.dogTraverseAnims = [];
	anim.dogTraverseAnims[ "wallhop" ]			 = %german_shepherd_run_jump_40;
	anim.dogTraverseAnims[ "window_40" ]		 = %german_shepherd_run_jump_window_40;
	anim.dogTraverseAnims[ "jump_down_40" ]		 = %german_shepherd_traverse_down_40;
	anim.dogTraverseAnims[ "jump_up_40" ]		 = %german_shepherd_traverse_up_40;
	anim.dogTraverseAnims[ "jump_up_80" ]		 = %german_shepherd_traverse_up_80;

	// Dog start move animations
	// number indexes correspond to keyboard number directions
	anim.dogStartMoveAngles[8] = 0;
	anim.dogStartMoveAngles[6] = 90;
	anim.dogStartMoveAngles[4] = -90;
	anim.dogStartMoveAngles[3] = 180;
	anim.dogStartMoveAngles[1] = -180;
	
	/*
	anim.dogStartMoveAnim[8] = %german_shepherd_run_start;
	anim.dogStartMoveAnim[6] = %german_shepherd_run_start_L;
	anim.dogStartMoveAnim[4] = %german_shepherd_run_start_R;
	anim.dogStartMoveAnim[3] = %german_shepherd_run_start_180_L;
	anim.dogStartMoveAnim[1] = %german_shepherd_run_start_180_R;
	*/

	anim.dogLookPose["attackIdle"][2] = %german_shepherd_attack_look_down;
	anim.dogLookPose["attackIdle"][4] = %german_shepherd_attack_look_left;
	anim.dogLookPose["attackIdle"][6] = %german_shepherd_attack_look_right;
	anim.dogLookPose["attackIdle"][8] = %german_shepherd_attack_look_up;	

	anim.dogLookPose["normal"][2] = %german_shepherd_look_down;
	anim.dogLookPose["normal"][4] = %german_shepherd_look_left;
	anim.dogLookPose["normal"][6] = %german_shepherd_look_right;
	anim.dogLookPose["normal"][8] = %german_shepherd_look_up;

	// effects used by dog
	level._effect[ "dog_bite_blood" ] = loadfx( "impacts/deathfx_dogbite" );
	level._effect[ "deathfx_bloodpool" ] = loadfx( "impacts/deathfx_bloodpool_view" );
	
	// setup random timings for dogs attacking the player
	slices = 5;
	array = [];
	for ( i = 0; i <= slices; i++ )
	{
		array[ array.size ] = i / slices;
	}
	level.dog_melee_index = 0;
	level.dog_melee_timing_array = maps\_utility::array_randomize( array );
	
	level.lastDogMeleePlayerTime = 0;
	level.dogMeleePlayerCounter = 0;
	
	setdvar( "friendlySaveFromDog", "0" );
}
