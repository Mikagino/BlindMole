@tool
class_name ItemCraftPanel extends PanelContainer

@export var ingredientsDisplay: Array[ItemDisplay];
@export var result: ItemDisplay;
@export var activeItem: Item;
@export var craftingUI: CraftingUI

func SetItem(item: Item):
	activeItem = item
	queue_redraw()

func CraftItem():
	craftingUI.CollectItem(activeItem)

func _draw():
	if(activeItem == null): return;
	if(activeItem.craftingInput.is_empty()): modulate = Color.TRANSPARENT
	else: modulate = Color.WHITE
	for i in range(ingredientsDisplay.size()):
		if(i >= activeItem.craftingInput.size()):
			ingredientsDisplay[i].hide()
			continue
		ingredientsDisplay[i].SetItem(activeItem.craftingInput[i].item, activeItem.craftingInput[i].count)
		ingredientsDisplay[i].show()
	result.SetItem(activeItem, 1);