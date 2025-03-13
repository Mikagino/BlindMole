class_name IngredientDisplay extends TextureRect

@export var label: Label;

func SetItem(item: Item, count: int):
    texture = item.icon;
    label.text = str(count);