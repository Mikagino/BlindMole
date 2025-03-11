extends CanvasItem

@export var masterAudioSlider: Slider;
@export var treasureAudioSlider: Slider;
@export var inputKeyLabel: PackedScene;

func _ready():
	Close();

func Open():
	show();
	masterAudioSlider.value = AudioServer.get_bus_volume_db(0);
	treasureAudioSlider.value = AudioServer.get_bus_volume_db(1);
	
	# for inputName in InputMap.get_actions():
	# 	print(inputName)
	# 	var keyLabel : InputKeyLabel = inputKeyLabel.instantiate() as InputKeyLabel;
	# 	keyLabel.nameLabel.text = inputName;
	# 	keyLabel.keyLabel.text = InputMap.action_get_events(inputName)[0].to_string();
	pass;

func Close():
	hide();

func ClickedOutside(event: InputEvent):
	if(event.is_pressed()):
		Close();
