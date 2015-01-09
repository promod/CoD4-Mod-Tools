// combat_say.gsc
// Determines when to talk during combat.

// Plays miscellaneous combat lines sometimes during combat
generic_combat()
{
	self animscripts\battlechatter::playBattleChatter();
}

// Plays vaguely context-sensitive combat lines sometimes during combat
specific_combat(dialogueLine)
{
	self animscripts\battlechatter::playBattleChatter();
}

