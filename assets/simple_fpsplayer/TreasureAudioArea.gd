extends Area3D

@export var audioPlayers: Array[AudioStreamPlayer3D];
@export var inactivePlayers: Array[AudioStreamPlayer3D];
@export var crystalAudio: AudioStream;
@export var crystalGroup: String;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# area_entered.connect(SetupAudioPlayer);
	# area_exited.connect(RemoveAudioPlayer);
	inactivePlayers = audioPlayers;
	#UpdateAudio();

func UpdateAudio():
	var treasures: Array[Area3D] = get_overlapping_areas();
	print(treasures.size(), " treasures are inside");
	for i in range(audioPlayers.size()):
		if(treasures.size() <= i):
			audioPlayers[i].stop();
			inactivePlayers.append(audioPlayers[i]);
			print(i, " audio player stopped");
			continue;
		SetupAudioPlayer(treasures[i]);

# only crystal so far
func SetupAudioPlayer(treasure: Area3D) -> void:
	if(inactivePlayers.size() == 0):
		return;
	print(treasure.name, " setup");
	var audioPlayer: AudioStreamPlayer3D = inactivePlayers.pop_front();
	audioPlayer.global_position = treasure.global_position;
	if(treasure.is_in_group(crystalGroup)):
		audioPlayer.stream = crystalAudio;
	audioPlayer.play();
	

func RemoveAudioPlayer(treasure: Area3D) -> void:
	print(treasure.name, " stop");
	for audioPlayer in audioPlayers:
		if(audioPlayer.global_position.is_equal_approx(treasure.global_position)):
			audioPlayer.stop();
			inactivePlayers.append(audioPlayer);
			break;
