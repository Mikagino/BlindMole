extends Button

@export var craftingUI: CraftingUI

func _ready():
	pressed.connect(craftingUI.Open)

func _input(_event: InputEvent):
	if(Input.is_action_just_pressed("Inventory")):
		craftingUI.ToggleVisibility()
