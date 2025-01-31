extends Node

func resolve_npc_state(npc : Node2D, check_value : String) -> void:
	#debug
	if check_value == "SecretSpilled":
		print(check_value)
	
	var npc_name = npc.name
	var current_state = npc.npc_state
	var new_state : String
	var emit : String
	var wait : float = 0
	var level = "Level" + String.num_int64(GameManager.current_level)
	if NpcStateResolverDict.has(level) == false:
		print("Level " + level + " not found in state resolver")
		return
		
	if NpcStateResolverDict[level].has(npc_name) == false:
		print("Npc name not found in state resolver")
		return
	
	var npc_states_dict = NpcStateResolverDict[level][npc_name]
	
	var state_changes
	if npc_states_dict.has(check_value) == false:
		return
	else:
		state_changes = npc_states_dict[check_value]
		
	if state_changes.has(current_state):
		new_state = state_changes[current_state]["NextState"]
		
		if state_changes[current_state].has("Emit"):
			emit = state_changes[current_state]["Emit"]
		
		if state_changes[current_state].has("Wait"):
			wait = state_changes[current_state]["Wait"]
	else:
		return
	
	await get_tree().create_timer(wait).timeout
	npc.apply_new_state(new_state, emit)
	
	
	
const NpcStateResolverDict : Dictionary = {
	"Level1": {
		"NpcName": {
			"Bubble_Check_Value": {
				"CurrentNpcState": {
					"NextState":"NpcStateToBeSwitchedToInThisSituation",
					"Emit":"ValueToBeEmittedWhenThisSwitchHappens"
				}
			}
		},
		"Rat": {
			
		},
		"PrisonMate": {
			"Nothing": {
				"BlockDoor": {
					"NextState":"Default",
					"Emit":"Move"
				}
			},
			"NeverGettingOut": {
				"Default": {
					"NextState":"BlockDoor",
					"Emit":"Move"
				}
			},
			"ComeHere": {
				"BlockDoor": {
					"NextState":"Default",
					"Emit":"Move"
				}
			}
		},
		"Guard": {
			"Nothing": {
				"OpenDoor": {
					"NextState":"CloseDoor",
					"Emit":"CloseDoor"
				}
			},
			"NeverGettingOut": {
				"OpenDoor": {
					"NextState":"CloseDoor",
					"Emit":"CloseDoor"
				}
			},
			"ComeHere": {
				"CloseDoor": {
					"NextState":"OpenDoor",
					"Emit":"OpenDoor"
				}
			}
		}
	},
	"Level2": {
		"CardPlayer1": {
			"YouAreLying": {
				"Default": {
					"NextState":"WhereHideIt",
					"Emit":"advance_dialog",
					"Wait":2.0
				}
			}
		},
		"CardPlayer2": {
			
		},
		"CardPlayer3": {
			
		},
		"Traitor": {
			"Nothing": {
				
			},
			"QuestionTraitor": {
				"Default": {
					"NextState":"NotTelling",
					"Emit":"advance_dialog"
				}
			},
			"DrinkDeliveredBottom": {
				"NotTelling": {
					"NextState":"InTheBank",
					"Emit":"advance_dialog",
					"Wait":2.0
				}
			},
			"SecretSpilled": {
				"InTheBank": {
					"NextState":"SecretSpilled",
					"Emit":"ObjectiveAchieved",
					"Wait":2.0
				}
			}
		},
		"Drunk": {
			"Nothing": {
				"WhereHideIt": {
					"NextState":"Default"
				},
				"RequestDrink": {
					"NextState":"Default"
				}
			},
			"WhereHideIt": {
				"Default": {
					"NextState":"WhereHideIt",
					"Emit":"QuestionTraitor",
					"Wait":2.0
				},
				"RequestDrink": {
					"NextState":"WhereHideIt",
					"Emit":"QuestionTraitor",
					"Wait":2.0
				}
			},
			"AnotherRound": {
				"Default": {
					"NextState":"RequestDrink",
					"Emit":"BringDrinkBottom",
					"Wait":1.0
				},
				"WhereHideIt": {
					"NextState":"RequestDrink",
					"Emit":"BringDrinkBottom",
					"Wait":1.0
				},
			}
		},
		"TavernKeep": {
			
		}
	},
	"Level3": {
		"Customer1": {
			"Nothing": {
				"Piratesson": {
					"NextState":"Default"
				}
			},
			"Piratesson": {
				"Default": {
					"NextState":"Piratesson",
					"Emit":"PiratessonName",
					"Wait":1.0
				}
			}
		},
		"Worker1": {
			"PiratessonName": {
				"Default": {
					"NextState":"PiratessonVaultNumber",
					"Emit":"advance_dialog",
					"Wait":1.0
				}
			}
		},
		"Customer2": {
			"Nothing": {
				"PiratessonVault": {
					"NextState":"Default"
				}
			},
			"Vault9999": {
				"Default": {
					"NextState":"PiratessonVault",
					"Emit":"PiratessonVault",
					"Wait":1.0
				}
			}
		},
		"Worker2": {
			"PiratessonVault": {
				"Default": {
					"NextState":"WithdrawTreasure",
					"Emit":"advance_dialog",
					"Wait":1.0
				}
			},
			"MoneyWithdrawn": {
				"WithdrawTreasure": {
					"NextState":"TreasureGiven",
					"Emit":"ObjectiveAchieved",
					"Wait":2.0
				}
			}
		},
		"Parrot": {
			
		}
	}
}
