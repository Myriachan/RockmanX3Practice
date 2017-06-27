//
// Gameplay-related hacks.
//


// Make "EXIT" always work.
{savepc}
	{reorg $00CEF4}
	// Nothing fancy here; just return 40 and make sure zero flag is clear.
	lda.b #$40
	and.b #$40
	rts
{loadpc}
