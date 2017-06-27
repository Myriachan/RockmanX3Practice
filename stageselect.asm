//
// Stage select-related hacks.
//


// Go straight to stage select instead of the intro stage.
{savepc}
	{reorg $009A1F}
	bra $009A3D
{loadpc}


// Always show Doppler's Castle during stage select.
{savepc}
	{reorg $00C41D}
	sec
	rts
{loadpc}
