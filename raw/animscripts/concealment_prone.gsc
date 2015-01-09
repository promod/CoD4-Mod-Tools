#using_animtree ("generic_human");

main()
{
    self trackScriptState( "Concealment Prone Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("concealment_prone");
	self animscripts\cover_prone::main();
}					
