//
// Game state data for where the player wants to go.
//

// Places an entry in the index table that has no revisit.
macro state_index_single label
	db ({label} - state_table_base) / {state_entry_size}
	db ({label} - state_table_base) / {state_entry_size}
endmacro

// Places an entry in the index table that has a revisit.
macro state_index_revisit label1, label2
	db ({label1} - state_table_base) / {state_entry_size}
	db ({label2} - state_table_base) / {state_entry_size}
endmacro


// Label used to denote the bank.
state_bank_marker:

// Top-level table, mapping categories to route tables.
state_category_table:
	dw state_route_table_anyp

// Mid-level table for Any% category, mapping routes to index tables.
state_route_table_anyp:
	dw state_indexes_table_anyp

// Index table for Any%.
state_indexes_table_anyp:
	{state_index_revisit state_data_anyp_hornet, state_data_anyp_doppler1}
	{state_index_single state_data_anyp_buffalo}
	{state_index_single state_data_anyp_intro}
	{state_index_single state_data_anyp_beetle}
	{state_index_revisit state_data_anyp_seahorse, state_data_anyp_doppler2}
	{state_index_revisit state_data_anyp_catfish, state_data_anyp_doppler3}
	{state_index_single state_data_anyp_crawfish}
	{state_index_single state_data_anyp_vile}
	{state_index_single state_data_anyp_rhino}
	{state_index_revisit state_data_anyp_tiger, state_data_anyp_doppler4}
	db 1  // Flag: Yes, there is a Vile stage.


// Base address for representing index table addresses.
state_table_base:

//
// Any% state table
//
state_data_anyp_intro:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$02,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $DC,$00,$10,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
state_data_anyp_buffalo:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00
	db $00,$00,$00,$00,$02,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $DC,$00,$10,$01,$00,$00,$09,$00,$00,$00,$00,$00,$00,$00,$00,$00
state_data_anyp_seahorse:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00
	db $00,$00,$00,$00,$02,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$DC,$00,$00,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$00,$24,$00,$00,$00,$00,$00,$00,$00,$00,$00
state_data_anyp_rhino:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$07,$00
	db $40,$00,$00,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$DC,$00,$00,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$00,$48,$00,$00,$00,$00,$00,$00,$00,$00,$00
state_data_anyp_tiger:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00
	db $40,$00,$04,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$00,$51,$00,$01,$07,$00,$00,$00,$00,$00,$00
state_data_anyp_catfish:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00
	db $40,$00,$04,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$00,$00
	db $00,$00,$00,$00,$DC,$00,$00,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$00,$2D,$00,$01,$07,$00,$00,$00,$00,$00,$00
state_data_anyp_crawfish:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$00
	db $40,$00,$04,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$00,$00
	db $DC,$00,$00,$00,$DC,$00,$00,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$00,$36,$00,$01,$07,$00,$00,$00,$00,$00,$00
state_data_anyp_vile:  // Crush Crawfish stage
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$00
	db $40,$00,$0C,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$00,$00
	db $DC,$00,$00,$00,$DC,$00,$00,$00,$DC,$00,$57,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$00,$36,$00,$05,$67,$00,$00,$00,$00,$00,$00
state_data_anyp_beetle:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$00
	db $40,$00,$1C,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$00,$00
	db $DC,$00,$DC,$00,$DC,$00,$00,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$00,$1B,$00,$35,$67,$00,$00,$00,$00,$00,$00
state_data_anyp_hornet:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00
	db $40,$00,$1C,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$00,$00
	db $DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$00,$00,$00,$35,$67,$00,$00,$00,$00,$00,$00
state_data_anyp_doppler1:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0A,$00
	db $E0,$00,$3C,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$DC,$00
	db $DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$01,$3F,$00,$35,$67,$00,$00,$00,$00,$00,$00
state_data_anyp_doppler2:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0B,$01
	db $E0,$00,$3C,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$DC,$00
	db $DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$01,$3F,$00,$35,$67,$00,$00,$00,$00,$00,$00
state_data_anyp_doppler3:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0C,$02
	db $E0,$00,$FC,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$DC,$00
	db $DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$01,$3F,$00,$35,$67,$00,$00,$00,$00,$00,$00
state_data_anyp_doppler4:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0D,$03
	db $E0,$00,$FC,$00,$02,$00,$01,$00,$00,$00,$00,$00,$DC,$00,$DC,$00
	db $DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$DC,$00,$00,$00,$00,$00
	db $DC,$08,$10,$01,$00,$01,$3F,$00,$35,$67,$FF,$00,$00,$00,$00,$00
