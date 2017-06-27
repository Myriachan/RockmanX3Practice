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
	// beq 9A53 -> bra 9A53
	{reorg $009A60}
	bra $009A53
{loadpc}


// Disable weapon get screen.
{savepc}
	// Delete a conditional branch on skipping the "weapon get" scene.
	// beq 9DD5 -> bra 9DD5
	{reorg $009DD0}
	bra $009DD5
{loadpc}


// Disable several cutscenes.
// * Bit/Byte cutscene after beating two Mavericks.
// * Dr. Cain cutscene after beating all eight Mavericks.
// * Ending.
{savepc}
	// Skip over a bunch of checks and go to the simple case.
	{reorg $009DD8}
	bra $009E02
{loadpc}
