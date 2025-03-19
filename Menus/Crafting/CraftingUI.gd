class_name CraftingUI extends Panel

@export var itemContainers: Array[HFlowContainer]

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	Close()

func Open():
	EnableMouse()
	show()
	get_tree().paused = true

func Close():
	DisableMouse()
	hide()
	get_tree().paused = false

func ClickedOutside(event: InputEvent):
	if(event.is_pressed()):
		Close();

func ToggleVisibility():
	if(visible):
		Close()
	else:
		Open()

func EnableMouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func DisableMouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func CollectItem(item: Item):
	print("coll:", item.itemName)
	var itemB: ItemButton = CheckForItem(item)
	itemB.count += 1
	# itemD.label.text = str(itemD.label.text.to_int() + 1) 
	queue_redraw()

func CheckForItem(item: Item) -> ItemButton:
	for c in itemContainers:
		for i in c.get_children():
			var itemD: ItemButton = i as ItemButton
			print(itemD.item.itemName)
			if (itemD.item == item):
				return itemD
	return null
