@tool
extends Button

@export var item: Item;
@export var textureRect: TextureRect;

func _ready():
	SetItem(item);

func SetItem(newItem: Item):
	textureRect.texture = newItem.icon;
	item = newItem;