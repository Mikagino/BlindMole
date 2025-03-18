@tool
extends Button

@export var item: Item;
@export var textureRect: TextureRect;
@export var craftPanel: ItemCraftPanel

func _ready():
	pressed.connect(craftPanel.SetItem.bind(item))

func _draw():
	textureRect.texture = item.icon;