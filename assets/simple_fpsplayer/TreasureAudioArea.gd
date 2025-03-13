extends Area3D

@export var audioPlayers: Array[AudioStreamPlayer3D];
var inactivePlayers: Array[AudioStreamPlayer3D];
@export var crystalAudio: AudioStream;
@export var crystalGroup: String;
@export var stromsteinAudio: AudioStream;
@export var stromsteinGroup: String;
@export var playerRaycast: RayCast3D;

var treasures: Array[Node3D];

func _ready() -> void:
	for player in audioPlayers:
		inactivePlayers.append(player);

func _process(delta):
	pass;

func UpdateObstruction():
	for treasure in treasures:
		CheckObstruction(treasure);

# only crystal so far
func SetupAudioPlayer(treasure: Node3D) -> void:
	if(inactivePlayers.size() == 0):
		return;
	var audioPlayer: AudioStreamPlayer3D = inactivePlayers.pop_front();
	audioPlayer.global_position = treasure.global_position;
	
	if(treasure.is_in_group(crystalGroup)):
		audioPlayer.stream = crystalAudio
	elif(treasure.is_in_group(stromsteinGroup)):
		audioPlayer.stream = stromsteinAudio;
	audioPlayer.play();
	treasures.append(treasure);

func CheckObstruction(treasure: Node3D):
	var soundSource : AudioStreamPlayer3D = GetTreasureSoundSource(treasure);
	if(soundSource == null):
		print("No sound source found...");
		return;

	var treasureRaycast: RayCast3D = soundSource.get_child(0) as RayCast3D;
	treasureRaycast.target_position = treasure.to_local(global_position);
	treasureRaycast.force_raycast_update();

	var treasureLocal = to_local(treasure.global_position);
	playerRaycast.target_position = treasureLocal;
	playerRaycast.global_position = global_position;
	playerRaycast.force_raycast_update();

	var isObstructed: bool = treasureRaycast.is_colliding() && playerRaycast.is_colliding();
	AudioServer.set_bus_effect_enabled(GetTreasureBusIndex(treasure), 0, isObstructed);
	if not isObstructed:
		return;
	
	var treasurePoint: Vector3 = treasureRaycast.get_collision_point();
	var playerPoint: Vector3 = playerRaycast.get_collision_point();
	var depth = treasurePoint.distance_to(playerPoint);

	var effect: AudioEffectLowPassFilter = GetTreasureLowpass(treasure);
	effect.cutoff_hz = CalculateCutoffFromDepth(depth);

func GetTreasureBusIndex(treasure: Node3D) -> int:
	var busName: StringName = GetTreasureSoundSource(treasure).bus;
	return AudioServer.get_bus_index(busName);

func GetTreasureLowpass(treasure: Node3D) -> AudioEffectLowPassFilter:
	var busIndex = GetTreasureBusIndex(treasure);
	return AudioServer.get_bus_effect(busIndex, 0);

func CalculateCutoffFromDepth(depth: float) -> float:
	return -100 * depth + 2500;
	#return 1100.0 * pow(-depth+10.0, 1.0/3.0); # alt but not so good function

func RemoveAudioPlayer(treasure: Node3D) -> void:
	var audioPlayer: AudioStreamPlayer3D = GetTreasureSoundSource(treasure);
	if(audioPlayer == null): return;
	audioPlayer.stop();
	inactivePlayers.append(audioPlayer);
	treasures.remove_at(treasures.find(treasure));

func GetTreasureSoundSource(treasure: Node3D) -> AudioStreamPlayer3D:
	for audioPlayer in audioPlayers:
		var distance = audioPlayer.global_position.distance_to(treasure.global_position);
		if(distance < 0.1):
			return audioPlayer;
	return null;
