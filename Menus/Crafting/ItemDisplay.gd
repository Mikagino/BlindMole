@tool
class_name ItemDisplay extends TextureRect

@export var label: Label;

func SetItem(item: Item, count: int = 1):
    texture = item.icon;
    label.text = str(count);