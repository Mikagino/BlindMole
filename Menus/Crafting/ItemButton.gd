@tool
class_name ItemButton extends Button

@export var item: Item;
@export var textureRect: TextureRect;
@export var craftPanel: ItemCraftPanel
@export var count: int
@export var label: Label

func _ready():
	pressed.connect(craftPanel.SetItem.bind(item))

func _draw():
	if(count == 0):
		hide()
		return
	if(!visible): show()
	textureRect.texture = item.icon;
	label.text = str(count)