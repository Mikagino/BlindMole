@tool
extends PanelContainer

@export var ingredientsDisplay: Array[ItemDisplay];
@export var result: ItemDisplay;
@export var activeItem: Item;

func _ready():
	SetItem(activeItem);

func SetItem(item: Item):
	if(item == null): return;
	for i in range(item.craftingInput.size()):
		ingredientsDisplay[i].SetItem(item.craftingInput[i].item, item.craftingInput[i].count);
	result.SetItem(item, 1);
