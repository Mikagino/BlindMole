extends Area3D

@export var audioPlayers: Array[AudioStreamPlayer3D];
var inactivePlayers: Array[AudioStreamPlayer3D];
@export var crystalAudio: AudioStream;
@export var crystalGroup: String;
@export var playerRaycast: RayCast3D;

var treasures: Array[Area3D];

func _ready() -> void:
	for player in audioPlayers:
		inactivePlayers.append(player);

func _process(delta):
	for source in treasures:
		CheckObstruction(source);
	# for kek in audioPlayers:
	# 	print(kek.name, kek.global_position);

func UpdateAudio():
	treasures = get_overlapping_areas();
	# print(treasures.size(), " treasures are inside");
	for i in range(audioPlayers.size()):
		if(treasures.size() <= i):
			audioPlayers[i].stop();
			inactivePlayers.append(audioPlayers[i]);
			# print(i, " audio player stopped");
			continue;
		SetupAudioPlayer(treasures[i]);

# only crystal so far
func SetupAudioPlayer(treasure: Area3D) -> void:
	if(inactivePlayers.size() == 0):
		return;
	var audioPlayer: AudioStreamPlayer3D = inactivePlayers.pop_front();
	audioPlayer.global_position = treasure.global_position;
	# var distance = audioPlayer.global_position.distance_to(treasure.global_position);
	# print(treasure.name, " setup :::");
	# print("dist", distance);
	# print("audio:", audioPlayer.global_position, "treasure:", treasure.global_position);
	
	if(treasure.is_in_group(crystalGroup)):
		audioPlayer.stream = crystalAudio;
	audioPlayer.play();
	treasures.append(treasure);

func CheckObstruction(treasure: Area3D):
	var soundSource : AudioStreamPlayer3D = GetTreasureSoundSource(treasure);
	if(soundSource == null): return;
	var treasureRaycast: RayCast3D = soundSource.get_child(0) as RayCast3D;
	treasureRaycast.target_position = global_position - treasure.global_position;
	print("dir: ", treasureRaycast.target_position);
	treasureRaycast.force_raycast_update();

	if(!treasureRaycast.is_colliding()):
		AudioServer.set_bus_effect_enabled(GetTreasureBusIndex(treasure), 0, false);
		return;
	
	var treasurePoint: Vector3 = treasureRaycast.get_collision_point();
	AudioServer.set_bus_effect_enabled(GetTreasureBusIndex(treasure), 0, true);
	playerRaycast.target_position = treasure.global_position - global_position;
	playerRaycast.force_raycast_update();
	var playerPoint: Vector3 = playerRaycast.get_collision_point();

	var depth = treasurePoint.distance_to(playerPoint);
	print("depth:", depth);

	var effect: AudioEffectLowPassFilter = GetTreasureLowpass(treasure);
	effect.cutoff_hz = CalculateCutoffFromDepth(depth);
	print("cutoff: ", effect.cutoff_hz);

func GetTreasureBusIndex(treasure: Area3D) -> int:
	var busName: StringName = GetTreasureSoundSource(treasure).bus;
	return AudioServer.get_bus_index(busName);

func GetTreasureLowpass(treasure: Area3D) -> AudioEffectLowPassFilter:
	var busIndex = GetTreasureBusIndex(treasure);
	print("busIndex:", busIndex);
	return AudioServer.get_bus_effect(busIndex, 0);

func CalculateCutoffFromDepth(depth: float) -> float:
	return -100 * depth + 2500;

func RemoveAudioPlayer(treasure: Area3D) -> void:
	print(treasure.name, " stop");
	var audioPlayer: AudioStreamPlayer3D = GetTreasureSoundSource(treasure);
	if(audioPlayer == null): return;
	audioPlayer.stop();
	inactivePlayers.append(audioPlayer);
	treasures.remove_at(treasures.find(treasure));

func GetTreasureSoundSource(treasure: Area3D) -> AudioStreamPlayer3D:
	for audioPlayer in audioPlayers:
		var distance = audioPlayer.global_position.distance_to(treasure.global_position);
		#print(distance)
		if(distance < 0.1):
			return audioPlayer;
	return null;
