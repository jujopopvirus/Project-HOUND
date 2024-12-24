extends Character_Stats

@onready var BASE_Actions = %Player_Base

var current_act : Character_Actions

func _ready():
	change_actions(BASE_Actions)

func change_actions(new_actions : Character_Actions):
	
	if new_actions != null:
		if current_act is Character_Actions:
			current_act.exit_actions()

		current_act = new_actions
		current_act.enter_actions()
	

func actions_process(delta):
	if current_act != null:
		current_act.actions_input_process(delta)
