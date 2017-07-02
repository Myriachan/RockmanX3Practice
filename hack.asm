// Rockman X3 Practice ROM hack
// by Myria
//

arch snes.cpu

// LoROM org macro - see bass's snes-cpu.asm "seek" macro
macro reorg n
	org ((({n}) & 0x7f0000) >> 1) | (({n}) & 0x7fff)
	base {n}
endmacro

// Warn if the current address is greater than the specified value.
macro warnpc n
	{#}:
	if {#} > {n}
		warning "warnpc assertion failure"
	endif
endmacro

// Allows saving the current location and seeking somewhere else.
define savepc push origin, base
define loadpc pull base, origin

// Warn if the expression is false.
macro static_assert n
	if ({n}) == 0
		warning "static assertion failure"
	endif
endmacro


// Copy the original ROM to initialize the address space.
{reorg $008000}
incbin "RockmanX3-original.smc"


// Version tags
eval version_major 0
eval version_minor 8
eval version_revision 2
// Constants
eval stage_intro 0
eval stage_doppler1 9
eval stage_doppler2 10
eval stage_doppler3 11
eval stage_doppler4 12
eval game_config_size $1B
eval soundnum_cant_escape $5A
eval magic_sram_tag_lo $3358  // Combined, these say "X3PR"
eval magic_sram_tag_hi $5250
eval magic_config_tag_lo $3358  // Combined, these say "X3C1"
eval magic_config_tag_hi $3147
// RAM addresses
eval title_screen_option $7E003C
eval controller_1_current $7E00A8
eval controller_1_previous $7E00AA
eval controller_1_new $7E00AC
eval controller_2_current $7E00AE
eval controller_2_previous $7E00B0
eval controller_2_new $7E00B2
eval screen_control_shadow $7E00B4
eval nmi_control_shadow $7E00C3
eval hdma_control_shadow $7E00C4
eval rng_value $7E09D6
eval controller_1_disable $7E1F63
eval event_flags $7E1FB2
eval state_vars $7E1FA0
eval state_level_already_loaded $7E1FB6
//x3fixme eval current_level $7E1F7A
//x3fixme eval life_count $7E1F80
//x3fixme eval midpoint_flag $7E1F81
//x3fixme eval weapon_power $7E1F85
//x3fixme eval intro_completed $7E1F9B
eval config_selected_option $7EFF80
eval config_data $7EFFC0
eval config_shot $7EFFC0
eval config_jump $7EFFC1
eval config_dash $7EFFC2
eval config_select_l $7EFFC3
eval config_select_r $7EFFC4
eval config_menu $7EFFC5
eval config_bgm $7EFFC8   // unused in X2 and X3, but might as well reuse these
eval config_se $7EFFC9    // unused in X2 and X3, but might as well reuse these
eval config_sound $7EFFCA
eval spc_state_shadow $7EFFFE
// Temporary storage for load process.  Overlaps game use.
eval load_temporary_rng $7F0000
// ROM addresses
//x3fixme eval rom_play_music $80878B
eval rom_play_sound $01802B
//x3fixme eval rom_rtl_instruction $808798  // last instruction of rom_play_sound
//x3fixme eval rom_rts_instruction $8087D0  // last instruction of some part of rom_play_music
//x3fixme eval rom_nmi_after_pushes $808173
eval rom_nmi_after_controller $088621
eval ram_nmi_after_controller $7E2621  // RAM copy of rom_nmi_after_controller
//x3fixme eval rom_config_loop $80EAAA
//x3fixme eval rom_config_button $80EB55
//x3fixme eval rom_config_stereo $80EBE8
//x3fixme eval rom_config_bgm $80EC30
//x3fixme eval rom_config_se $80EC74
//x3fixme eval rom_config_exit $80ECC0
eval rom_default_config $06E0E4
eval rom_level_table $069C04
// SRAM addresses for saved states
eval sram_start $700000
eval sram_previous_command $700200
eval sram_wram_7E0000 $710000
eval sram_wram_7E8000 $720000
eval sram_wram_7F0000 $730000
eval sram_wram_7F8000 $740000
eval sram_vram_0000 $750000
eval sram_vram_8000 $760000
eval sram_cgram $772000
eval sram_oam $772200
eval sram_dma_bank $770000
eval sram_validity $774000
eval sram_saved_sp $774004
eval sram_saved_dp $774006
// SRAM addresses for general config.  These are at lower addresses to support
// emulators and cartridges that don't support 256 KB of SRAM.
eval sram_config_valid $700100
eval sram_config_game $700104   // Main game config.  game_config_size bytes.
eval sram_config_extra {sram_config_game} + {game_config_size}
eval sram_config_category {sram_config_extra} + 0
eval sram_config_route {sram_config_extra} + 1
eval sram_config_midpointsoff {sram_config_extra} + 2
eval sram_config_keeprng {sram_config_extra} + 3
eval sram_config_musicoff {sram_config_extra} + 4
eval sram_config_godmode {sram_config_extra} + 5
eval sram_config_extra_size 6   // adjust this as more are added
eval sram_banks $08
// Constants for categories and routing.
eval category_anyp 0
eval num_categories 1
eval route_anyp_default 0
eval num_routes_anyp 1
// State table index offsets for special data.
eval state_entry_size 64
eval index_offset_vile_flag (10 * 2) + 0


// Header edits
{savepc}
	// Change SRAM size to 256 KB
	{reorg $00FFD8}
	db $08
{loadpc}


// Init hook
{savepc}
	{reorg $00800E}
	jml init_hook
{loadpc}


// Start of primary data bank (2B8000-2BE1FF)
{reorg $2B8000}


// Gameplay hacks.
incsrc "gameplay.asm"
// Stage select hacks.
incsrc "stageselect.asm"
// Config code.
incsrc "config.asm"
// Saved state code.
incsrc "savedstates.asm"


// The state table for each level is in statetable.asm.
incsrc "statetable.asm"

// End of primary data bank (2B8000-2BE1FF)
{warnpc $2BE200}
