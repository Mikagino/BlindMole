@tool
class_name Item extends Resource

@export var itemName: String;
@export var description: String;
@export var icon: Texture2D;
@export var craftingInput: Array[CraftingInput];