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


// Disable interstage password screen.
{savepc}
	// Always use password screen state 3, which is used to exit to stage select.
	// States are offsets into a jump table, so they're multiplied by 2.
	{reorg $00EEF6}
	ldx.b #3 * 2
	// Disable fadeout, speeding this up.
	{reorg $00EFB1}
	nop
	nop
	nop
{loadpc}


// Disable stage intros.
{savepc}
	// bne 9597 -> bra 9A53
	{reorg $009A60}
	bra $009A53
{loadpc}
