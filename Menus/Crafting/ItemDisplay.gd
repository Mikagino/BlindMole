@tool
class_name ItemDisplay extends TextureRect

@export var label: Label

func SetItem(newItem: Item, count: int = 1):
    texture = newItem.icon;
    label.text = str(count);