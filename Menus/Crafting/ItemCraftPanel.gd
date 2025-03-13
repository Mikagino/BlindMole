extends PanelContainer

@export var ingredientsDisplay: Array[IngredientDisplay];
@export var result: IngredientDisplay;

func SetItem(item: Item):
    for i in range(item.craftingInput.size()):
        ingredientsDisplay[i].SetItem(item, item.count[i]);