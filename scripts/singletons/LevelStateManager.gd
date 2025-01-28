extends Node

const NpcStateResolverDict : Dictionary = {
	"Rat": {
		"Start": {
			"NeverGettingOut":"BlockDoor"
		},
		"BlockDoor": {
			"reset":"Start"
		},
	},
	"PrisonMate": {
		"Start": {
			"NeverGettingOut":"BlockDoor"
		},
		"BlockDoor": {
			"reset":"Start"
		},
	},
	"Guard": {
		"Start": {
			"NeverGettingOut":"BlockDoor"
		},
		"BlockDoor": {
			"ComeHere":"OpenDoor"
		},
		"OpenDoor": {
			"reset":"Start"
		},
	}
}
