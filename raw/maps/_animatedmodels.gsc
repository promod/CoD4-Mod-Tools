#include common_scripts\utility;
#include maps\_utility;

#using_animtree( "animated_props" );
main()
{
	// wait until the end of the frame so that maps can init their trees
	// in their _anim instead of only above _load
	waittillframeend;
	
	if ( getdvar( "animated_trees_enabled" ) == "" )
		setdvar( "animated_trees_enabled", "1" );
	
	level.wind = spawnstruct();
	level.wind.rate = 0.4;
	level.wind.weight = 1;
	level.wind.variance = 0.2;
	level.init_animatedmodels_dump = false;
	
	level.anim_prop_models_animtree = #animtree;
	
	if( !isdefined( level.anim_prop_models ) )
	{
		// this is what the LD puts in their map
		level.anim_prop_models = [];  
	}
	
	level.init_animatedmodels = [];
	
	animated_models = getentarray( "animated_model", "targetname" );
	if ( getdvar( "animated_trees_enabled" ) == "1" )
	{
		array_thread( animated_models, ::model_init );
	}
	else
	{
		array_thread( animated_models, ::model_disable );
		return;
	}
	
	// one or more of the models initialized by model_init() was not setup by the map
	// so print this helpful note so the designer can see how to add it ot their level
	if ( level.init_animatedmodels_dump )
	{
		keys = getarraykeys( level.init_animatedmodels );
		println( "" );
		println( "" );
		println( "------animed prop model dump ----" );
		println( "Put this line into the _anim file for your level: " );	
		println( "" );
		println( "animated_model_setup();" );
		println( "" );
		println( "Paste this include and function at the bottom of the _anim for your level:" );	
		println( "" );
		println( "#using_animtree( \"animated_props\" );" );
		println( "animated_model_setup()" );
		println( "{" );

		for( i=0; i < keys.size; i++ )
		{
			print_modellist_bykey( keys[ i ] );
		}
		println( "}" );
		println( "" );
		println( "make sure these are in your <level>.csv" );
		println( "" );
		
		for( i=0; i < keys.size; i++ )
		{
			print_modelcsv_bykey( keys[ i ] );
		}
		println( "" );
		println( "" );
		assertmsg( "anims not cached for animated prop model, see console" );
		return;
	}
	
	array_thread( animated_models, ::animated_model );
	
	level.init_animatedmodels = undefined;
}

print_modellist_bykey( key )
{
	anima = level.init_animatedmodels[ key ];
	
	if ( isdefined( anima[ "still" ] ) )
	{
		println( "\tlevel.anim_prop_models[ \"" + key + "\" ][ " + "\"still\"" + " ] = %" + anima[ "still" ] + ";" );
	}
	
	if( isdefined( anima[ "strong" ] ) )
	{
		println( "\tlevel.anim_prop_models[ \"" + key + "\" ][ " + "\"strong\"" + " ] = %" + anima[ "strong" ] + ";" );
	}

}

print_modelcsv_bykey( key )
{
	anima = level.init_animatedmodels[ key ];
	
	if( isdefined( anima[ "still" ] ) )
		println( "xanim," + anima[ "still" ] );
		
	if( isdefined( anima[ "strong" ] ) )
		println( "xanim," + anima[ "strong" ] );
}

model_init()
{
	anima = [];
	switch( self.model )
	{
		case "foliage_tree_desertpalm01_animated":
			anima[ "still" ] = "tree_desertpalm01_still";
			anima[ "strong" ]= "tree_desertpalm01_strongwind";
			break;
		case "foliage_tree_desertpalm02_animated":
			anima[ "still" ] = "tree_desertpalm02_still";
			anima[ "strong" ] = "tree_desertpalm02_strongwind";
			break;
		case "foliage_tree_desertpalm03_animated":
			anima[ "still" ] = "tree_desertpalm03_still";
			anima[ "strong" ] = "tree_desertpalm03_strongwind";
			break;
		case "foliage_tree_palm_tall_1":
			anima[ "still" ] = "palmtree_tall1_still";
			anima[ "strong" ] = "palmtree_tall1_sway";
			break;
		case "foliage_tree_palm_tall_2":
			anima[ "still" ] = "palmtree_tall2_still";
			anima[ "strong" ] = "palmtree_tall2_sway";
			break;
		case "foliage_tree_palm_tall_3":
			anima[ "still" ] = "palmtree_tall3_still";
			anima[ "strong" ] = "palmtree_tall3_sway";
			break;
		case "foliage_tree_palm_bushy_1":
			anima[ "still" ] = "palmtree_bushy1_still";
			anima[ "strong" ] = "palmtree_bushy1_sway";
			break;
		case "foliage_tree_palm_bushy_2":
			anima[ "still" ] = "palmtree_bushy2_still";
			anima[ "strong" ] = "palmtree_bushy2_sway";
			break;
		case "foliage_tree_palm_bushy_3":
			anima[ "still" ] = "palmtree_bushy3_still";
			anima[ "strong" ] = "palmtree_bushy3_sway";
			break;
		case "foliage_tree_palm_med_1":
			anima[ "still" ] = "palmtree_med1_still";
			anima[ "strong" ] = "palmtree_med1_sway";
			break;
		case "foliage_tree_palm_med_2":
			anima[ "still" ] = "palmtree_med2_still";
			anima[ "strong" ] = "palmtree_med2_sway";
			break;
		default:
			println("");
			println("not setup:"+self.model);
			println("");
			assertmsg("animated propmodel not setup, see console");
			break;
	}

	level.init_animatedmodels[ self.model ] = anima;  // add to write-to-script list.

	if( !isdefined( level.anim_prop_models[ self.model ] ) )
		level.init_animatedmodels_dump = true;
}

model_disable()
{
	switch( self.model )
	{
		case "foliage_tree_desertpalm01_animated":
			self setModel( "foliage_tree_desertpalm01" );
			break;
		case "foliage_tree_desertpalm02_animated":
			self setModel( "foliage_tree_desertpalm02" );
			break;
		case "foliage_tree_desertpalm03_animated":
			self setModel( "foliage_tree_desertpalm03" );
			break;
		case "foliage_tree_palm_tall_1":
			self setModel( "foliage_tree_palm_tall_1_static" );
			break;
		case "foliage_tree_palm_tall_2":
			self setModel( "foliage_tree_palm_tall_2_static" );
			break;
		case "foliage_tree_palm_tall_3":
			self setModel( "foliage_tree_palm_tall_3_static" );
			break;
		case "foliage_tree_palm_bushy_1":
			self setModel( "foliage_tree_palm_bushy_1_static" );
			break;
		case "foliage_tree_palm_bushy_2":
			self setModel( "foliage_tree_palm_bushy_2_static" );
			break;
		case "foliage_tree_palm_bushy_3":
			self setModel( "foliage_tree_palm_bushy_3_static" );
			break;
		case "foliage_tree_palm_med_1":
			self setModel( "foliage_tree_palm_med_1_static" );
			break;
		case "foliage_tree_palm_med_2":
			self setModel( "foliage_tree_palm_med_2_static" );
			break;
		default:
			println("");
			println("not setup:"+self.model);
			println("");
			assertmsg("animated propmodel not setup, see console");
			break;
	}
}

animated_model()
{
	self UseAnimTree( #animtree );
	wind = "strong";
	while(1)
	{
		thread tree_animates( wind );
		level waittill( "windchange", wind );
	}
}

tree_animates( animate )
{
	level endon( "windchange" );
	windweight = level.wind.weight;
	windrate = level.wind.rate + randomfloat( level.wind.variance );
	self setAnim( level.anim_prop_models[ self.model ][ "still" ], 1, self getanimtime( level.anim_prop_models[ self.model ][ "still" ] ), windrate );
	self setAnim( level.anim_prop_models[ self.model ][ animate ], windweight, self getanimtime( level.anim_prop_models[ self.model ][ animate ] ), windrate );
}