@tool
extends MeshInstance3D
@export var meshes: Array[PackedScene];

func _ready():
	_enter_tree()

func _enter_tree() -> void:
	if(meshes.is_empty()): return;
	mesh = meshes.pick_random().instantiate();
	
