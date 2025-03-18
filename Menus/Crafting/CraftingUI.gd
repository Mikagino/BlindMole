extends Panel

func Open():
	show()

func Close():
	hide()

func ClickedOutside(event: InputEvent):
	if(event.is_pressed()):
		Close();
