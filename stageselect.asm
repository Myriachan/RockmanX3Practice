//
// Stage select-related hacks.
//


// Go straight to stage select instead of the intro stage.
{savepc}
	{reorg $009A1F}
	bra $009A3D
{loadpc}


// Set the game state to the intro stage when entering stage select, so that
// all bosses' icons appear active.
{savepc}
	{reorg $00C23E}
	jsl stage_select_init_hook
{loadpc}
stage_select_init_hook:
	// Load intro stage state, which has no bosses cleared.
	lda.b #2
	jsr load_state_table

	// We need to make sure that the "Zero already used this level"
	// flag is cleared when starting a level.
	lda.b #1
	trb.w {state_used_zero}

	// Jump to original code.  It will RTL for us.
	jml $038063


// Enable Doppler options in stage select.
{savepc}
	{reorg $838063}  // count_defeated_bosses_2
	jml count_defeated_bosses_hook
{loadpc}
count_defeated_bosses_hook:
	// Determine whether the current category has a Vile stage.
	jsr get_state_index_table
	tax
	sep #$20
	lda.l (state_bank_marker & 0xFF0000) + {index_offset_vile_flag}, x
	sep #$10
	// Hack: (flag & 1) ? 8 : 0.  8 is all 8 mavericks killed.
	and.b #$01
	asl
	asl
	asl

	// I believe it's a bug, but the count is written to both 7E002C and 7E1E84
	// because this is called with the direct page as two different values.
	// Just do the same write...
	sta.b $2C
	cmp.b #8
	rtl
	

// Never show Doppler Castle appearing animation.
{savepc}
	{reorg $00C41D}
	clc
	rts
{loadpc}


// Don't play Doppler stage select music.
// Also, don't make Doppler the starting cursor position.
{savepc}
	{reorg $00C2D0}
	nop
	nop
{loadpc}


// Get a pointer to the currently active index table.
// Returns result in A.  Returns with A/X=16-bit.  Destroys X.  RTS.
get_state_index_table:
	rep #$30

	// Look up category table pointer.
	lda.l {sram_config_category}
	and.w #$00FF
	asl
	tax
	lda.l state_category_table, x
	pha

	// Look up index table pointer.
	lda.l {sram_config_route}
	and.w #$00FF
	asl   // clears carry
	adc 1, s
	tax
	lda.l (state_bank_marker & 0xFF0000), x

	// Pop stack (dummy read) and return.
	plx
	rts


// Gets the state table for the current route and level A.
// Enter with A=8-bit level ID.  Set high bit of A if want revisit.
// Returns A=16-bit offset in state table bank.  Destroys X; X is set to 16-bit.
// Returns with RTS.
get_state_table_for_level:
	// Rotate A.  Cutely, this multiplies the level ID by 2, and adds 1 if a
	// revisit entry is wanted.
	asl
	adc.b #0

	// Save this index into the index table.
	rep #$30
	and.w #$00FF
	pha

	// Get the base pointer to the index table.	
	jsr get_state_index_table

	// Look up the index.
	adc 1, s
	plx  // dummy stack pop
	tax
	lda.l (state_bank_marker & 0xFF0000), x
	and.w #$00FF

	// Now that we have the index, get the raw pointer.
	// Multiply by state_entry_size.
	{static_assert {state_entry_size} == 64}
	asl
	asl
	asl
	asl
	asl
	asl  // clears carry; not enough shifts to carry
	// Add the base.
	adc.w #(state_table_base & 0xFFFF)
	rts


// Loads a particular state into state_vars.
// A (8-bit) = level index to load.  Set high bit for revisit.
// Returns with 8-bit A and X.  A/X/Y destroyed.
load_state_table:
	// Get pointer to state table.  This sets A and X to 16-bit.
	jsr get_state_table_for_level

	// memcpy(state_vars, A, state_entry_size);
	phb
	tax
	lda.w #{state_entry_size} - 1
	ldy.w #{state_vars}
	// Don't know why this doesn't work.
	//mvn state_bank_marker >> 16, {state_vars} >> 16  ??
	db $54, {state_vars} >> 16, state_bank_marker >> 16
	plb

	sep #$30
	rts


// Called to begin a level.  This is where we inject our state!
{savepc}
	{reorg $00C4B2}
	jml choose_stage_hook
{loadpc}
choose_stage_hook:
	// Entry state:
	// A (8-bit) = index 0-9 of which option was selected.
	// X (8-bit) = raw cursor value; we don't care.

	// Check whether the select button is being held.
	pha
	lda.w {controller_1_current} + 1
	and.b #$20

	// Move the select button bit into the high bit.
	asl
	asl
	ora 1, s
	plx  // dummy stack pop

	// Load the chosen state.
	jsr load_state_table

	// Load the level.
	sep #$30
	jml $00C4F5


// Modify level table so that they're simply indexes into our table instead of
// being level IDs.
{savepc}
	{reorg {rom_level_table} + (0 * 9) + 8}
	db $00
	{reorg {rom_level_table} + (1 * 9) + 8}
	db $01
	{reorg {rom_level_table} + (2 * 9) + 8}
	db $02
	{reorg {rom_level_table} + (3 * 9) + 8}
	db $03
	{reorg {rom_level_table} + (4 * 9) + 8}
	db $04
	{reorg {rom_level_table} + (5 * 9) + 8}
	db $05
	{reorg {rom_level_table} + (6 * 9) + 8}
	db $06
	{reorg {rom_level_table} + (7 * 9) + 8}
	db $07
	{reorg {rom_level_table} + (8 * 9) + 8}
	db $08
	{reorg {rom_level_table} + (9 * 9) + 8}
	db $09
{loadpc}
