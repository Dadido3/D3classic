local Size = 6
local W = "W"
local A = "_"
local Shapes = {
	{ --"costume1" |
		{ -- |
			W,W,W,W,W,W,
			W,W,W,W,W,W,
			A,A,A,A,A,A,
			A,A,A,A,A,A,
			W,W,W,W,W,W,
			W,W,W,W,W,W
		},
		{ -- _
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W,
	},
	{ --"costume2" L
		{ -- J
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			A,A,A,A,W,W,
			A,A,A,A,W,W,
			W,W,W,W,W,W,
			W,W,W,W,W,W
		},
		{ -- L
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,A,A,
			W,W,A,A,A,A,
			W,W,W,W,W,W,
			W,W,W,W,W,W
		},
		{ -- r
			W,W,W,W,W,W,
			W,W,W,W,W,W,
			W,W,A,A,A,A,
			W,W,A,A,A,A,
			W,W,A,A,W,W,
			W,W,A,A,W,W
		},
		{ -- 7
			W,W,W,W,W,W,
			W,W,W,W,W,W,
			A,A,A,A,W,W,
			A,A,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W
		},
	},
	{ --"costume3" T
		{
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			A,A,A,A,W,W,
			A,A,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W
		},
		{
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,A,A,
			W,W,A,A,A,A,
			W,W,A,A,W,W,
			W,W,A,A,W,W
		},
		{
			W,W,W,W,W,W,
			W,W,W,W,W,W,
			A,A,A,A,A,A,
			A,A,A,A,A,A,
			W,W,A,A,W,W,
			W,W,A,A,W,W
		},
		{
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			A,A,A,A,W,W,
			A,A,A,A,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W
		},
	},
	{ --"costume4" +
		{ --WHOO, ONLY 1!
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			A,A,A,A,A,A,
			A,A,A,A,A,A,
			W,W,A,A,W,W,
			W,W,A,A,W,W
		}
	},
	{ --"costume8" #
		{ --WHOO, ONLY 1!
			W,W,W,W,W,W,
			W,A,A,A,A,W,
			W,A,A,A,A,W,
			W,A,A,A,A,W,
			W,A,A,A,A,W,
			W,W,W,W,W,W
		}
	},
	{ --"costume9" #
		{ --WHOO, ONLY 1!
			W,W,W,W,W,W,
			W,A,A,A,A,W,
			A,A,A,A,A,W,
			A,A,A,A,A,W,
			W,A,A,A,A,W,
			W,W,W,W,W,W
		}
	},
	{ --"costume10" .
		{ --WHOO, ONLY 1!
			W,W,W,W,W,W,
			W,W,W,W,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,W,W,W,W,
			W,W,W,W,W,W
		}
	},
	{ --"costume12" .
		{ --WHOO, ONLY 1!
			W,W,W,W,W,W,
			W,W,W,W,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,W,W,W,W,
			W,W,W,W,W,W
		}
	},
	{ --"costume13" .
		{ --WHOO, ONLY 1!
			W,W,W,W,W,W,
			W,W,W,W,W,W,
			W,W,A,A,W,W,
			W,W,A,A,W,W,
			W,W,W,W,W,W,
			W,W,W,W,W,W
		}
	},
}
