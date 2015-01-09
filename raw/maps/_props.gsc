#include maps\_anim;
#include maps\_utility;

add_smoking_notetracks( animname )
{
	addNotetrack_customFunction( animname, "attach cig", 		::attach_cig );
	addNotetrack_customFunction( animname, "detach cig", 		::detach_cig );
	addNotetrack_customFunction( animname, "puff", 				::smoke_puff );
	addNotetrack_customFunction( animname, "exhale", 			::smoke_exhale );

	level._effect[ "cigar_glow" ]    	  						= loadfx( "fire/cigar_glow_far" );
	level._effect[ "cigar_glow_puff" ] 							= loadfx( "fire/cigar_glow_puff" );
	level._effect[ "cigar_smoke_puff" ]							= loadfx( "smoke/cigarsmoke_puff_far" );
	level._effect[ "cigar_exhale" ]    							= loadfx( "smoke/cigarsmoke_exhale_far" );

	level.scr_model[ "cigar" ]									= "prop_price_cigar";
}

add_cellphone_notetracks( animname )
{
	addNotetrack_customFunction( animname, "attach phone", 		::attach_phone );
	addNotetrack_customFunction( animname, "detach phone", 		::detach_phone );

	level.scr_model[ "cellphone" ]								= "com_cellphone_off";
}

attach_phone( guy )
{
	guy notify( "new_phone_rotation" );	 // runs a thread to cleanup the cigar if the anim is cut off, this starts the thread over again

	phone = spawn( "script_model", (0,0,0) );
	phone linkto( guy, "tag_inhand", (0,0,0), (0,0,0) );
	phone setmodel( getModel( "cellphone" ) );
	guy.phone = phone;

	self thread prop_delete( phone, guy );
}

detach_phone( guy )
{	
	if ( isdefined( guy.phone ) )
		guy.phone delete();
}

attach_cig( guy )
{	
	guy notify( "new_cigar_rotation" );	 // runs a thread to cleanup the cigar if the anim is cut off, this starts the thread over again

	cigar = spawn( "script_model", (0,0,0) );
	cigar linkto( guy, "tag_inhand", (0,0,0), (0,0,0) );
	cigar setmodel( getModel( "cigar" ) );
	playfxontag( getfx( "cigar_glow" ), cigar, "tag_cigarglow" );
	guy.cigar = cigar;

	self thread prop_delete( cigar, guy );
}

detach_cig( guy )
{	
	if ( isdefined( guy.cigar ) )
		guy.cigar delete();
}

prop_delete( prop, guy )
{
	guy notify( "new_prop_rotation" + prop.model ); // kill the old prop
	guy endon( "new_prop_rotation" + prop.model );
	prop endon( "death" );
	
	guy add_endon( "new_prop_rotation" + prop.model ); // adds this endon to any of the waits, so we dont get thread leak
	prop add_endon( "death" ); // adds this endon to any of the waits, so we dont get thread leak
	self add_wait( ::waittill_msg, "stop_loop" );
	guy add_wait( ::waittill_msg, "death" );
	do_wait_any(); // waits for any of the above to occur
	
	prop delete();
}
	
smoke_puff( guy )
{
	if ( !isdefined( guy.cigar ) )
		return;

	guy endon( "death" );
	guy.cigar endon( "death" );
	playfxOnTag( getfx( "cigar_glow_puff" ), guy.cigar, "tag_cigarglow" );
	wait 1;
	playfxOnTag( getfx( "cigar_smoke_puff" ), guy, "tag_eye" );
}

smoke_exhale( guy )
{
	if ( !isdefined( guy.cigar ) )
		return;
	playfxOnTag( getfx( "cigar_exhale" ), guy, "tag_eye" );
}

ghillie_leaves()
{
	bones = [];
	bones[ bones.size ] = "J_MainRoot";
	bones[ bones.size ] = "J_CoatFront_LE";
	bones[ bones.size ] = "J_Hip_LE";
	bones[ bones.size ] = "J_CoatRear_RI";
	bones[ bones.size ] = "J_CoatRear_LE";
	bones[ bones.size ] = "J_CoatFront_RI";
	bones[ bones.size ] = "J_Cheek_RI";
	bones[ bones.size ] = "J_Brow_LE";
	bones[ bones.size ] = "J_Shoulder_RI";
	bones[ bones.size ] = "J_Head";
	bones[ bones.size ] = "J_ShoulderRaise_LE";
	bones[ bones.size ] = "J_Neck";
	bones[ bones.size ] = "J_Clavicle_RI";
	bones[ bones.size ] = "J_Ball_LE";
	bones[ bones.size ] = "J_Knee_Bulge_LE";
	bones[ bones.size ] = "J_Ankle_RI";
	bones[ bones.size ] = "J_Ankle_LE";
	bones[ bones.size ] = "J_SpineUpper";
	bones[ bones.size ] = "J_Knee_RI";
	bones[ bones.size ] = "J_Knee_LE";
	bones[ bones.size ] = "J_HipTwist_RI";
	bones[ bones.size ] = "J_HipTwist_LE";
	bones[ bones.size ] = "J_SpineLower";
	bones[ bones.size ] = "J_Hip_RI";
	bones[ bones.size ] = "J_Elbow_LE";
	bones[ bones.size ] = "J_Wrist_RI";

	self endon( "death" );
	for ( ;; )
	{	
		while ( self.movemode != "run" )
		{
			wait( 0.2 );
			continue;
		}

		playfxontag( level._effect[ "ghillie_leaves" ], self, random( bones ) );
		wait( randomfloatrange( 0.1, 2.5 ) );
	}
}

attach_cig_self()
{
	attach_cig( self );
}