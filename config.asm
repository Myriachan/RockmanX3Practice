//
// Configuration hacks
//


// Returns whether configuration is saved in the zero flag.
// Must be called with 16-bit A!
is_config_saved:
	// Check magic values.
	lda.l {sram_config_valid}
	cmp.w #{magic_config_tag_lo}
	bne .not_saved
	lda.l {sram_config_valid} + 2
	cmp.w #{magic_config_tag_hi}
	bne .not_saved

	// Check for bad extra configuration.
	// Loads both route and category since A is 16-bit.
	lda.l {sram_config_category}  // also sram_config_route
	sep #$20
	// Validate category.  XBA will get the route.
	cmp.b {num_categories}
	beq .category_anyp
	bra .not_saved

.category_anyp:
	xba
	cmp.b #{num_routes_anyp}
	bcc .not_saved
	bra .routing_ok

.routing_ok:
	// These are simple Boolean flags.
	rep #$20
	lda.l {sram_config_midpointsoff}  // also sram_config_keeprng
	and.w #~($0101)
	bne .not_saved
	lda.l {sram_config_musicoff}  // also sram_config_godmode
	and.w #~($0101)
	beq .saved
.not_saved:
	rep #$22  // clear zero flag in addition to setting A = 16-bit again.
.saved:
	rts


// Hook the initialization of the configuration data, to provide saving
// the configuration in SRAM.
{savepc}
	{reorg $0082FA}
	// config_init_hook changes the bank.
	phb
	jsl config_init_hook
	plb
	bra $008307
{loadpc}
config_init_hook:
	// Check for L + R on the controller as a request to wipe SRAM.
	lda.l {controller_1_current}
	and.b #$30
	cmp.b #$30
	bne .dont_wipe_sram
	jsr config_wipe_sram
.dont_wipe_sram:

	// The controller configuration was not in RAM, so initialize it.
	// We want to use the data from SRAM in this case - if any.
	rep #$30
	jsr is_config_saved
	bne .not_saved

	// Config was saved, so load from SRAM.
	lda.w #({sram_config_game} >> 16)
	ldy.w #{sram_config_game}
	bra .initialize

.not_saved:
	// Config was not saved, so set to default.
	// Set our extra config to default.
	sep #$30
	lda.b #0
	ldx.b #0
.extra_default_loop:
	sta.l {sram_config_extra}, x
	inx
	cpx.b #{sram_config_extra_size}
	bne .extra_default_loop
	rep #$30

	// Copy from ROM's default config to game config.
	lda.w #({rom_default_config} >> 16)
	ldy.w #{rom_default_config}

.initialize:
	// Keep X/Y at 16-bit for now.
	sep #$20
	// Set bank as specified.
	pha
	plb
	// Copy configuration from either ROM or SRAM.
	ldx.w #0
.initialize_loop:
	lda $0000, y
	sta.l {config_data}, x
	iny
	inx
	cpx.w #{game_config_size}
	bcc .initialize_loop

	// Save configuration if needed.
	sep #$30
	bra maybe_save_config


// Save configuration if different or unset.
// Called with JSL.
maybe_save_config:
	php

	// If config not saved at all, save now.
	rep #$20
	jsr is_config_saved
	sep #$30
	bne .do_save

	// Otherwise, check whether different.
	// It's bad to continuously write to SRAM because an SD2SNES will then
	// constantly write to the SD card.
	ldx.b #0
.check_loop:
	// Ignore changes to the BGM and SE values.  The game resets them anyway.
	cpx.b #{config_bgm} - {config_data}
	beq .check_skip
	cpx.b #{config_se} - {config_data}
	beq .check_skip
	lda.l {config_data}, x
	cmp.l {sram_config_game}, x
	bne .do_save
.check_skip:
	inx
	cpx.b #{game_config_size}
	bcc .check_loop

.return:
	plp
	rtl

	// We should save.
.do_save:
	// Clear the magic value during the save.
	rep #$20
	lda.w #0
	sta.l {sram_config_valid} + 0
	sta.l {sram_config_valid} + 2
	// Copy config to SRAM.
	sep #$30
	ldx.b #0
.save_loop:
	lda.l {config_data}, x
	sta.l {sram_config_game}, x
	inx
	cpx.b #{game_config_size}
	bcc .save_loop

	// Set the magic value.
	rep #$20
	lda.w #{magic_config_tag_lo}
	sta.l {sram_config_valid} + 0
	lda.w #{magic_config_tag_hi}
	sta.l {sram_config_valid} + 2

	// Done.
	bra .return


// Wipe SRAM on request.
config_wipe_sram:
	php
	phb
	rep #$30
	lda.w #0
	ldx.w #({sram_start} >> 16) * $0101
.outer_loop:
	phx
	plb
	plb
	ldy.w #0
	tya
.inner_loop:
	sta 0, y
	iny
	iny
	bpl .inner_loop
	txa
	clc
	adc.w #$0101
	tax
	cmp.w #(({sram_start} >> 16) + {sram_banks}) * $0101
	bne .outer_loop
	plb
	plp
	rts
