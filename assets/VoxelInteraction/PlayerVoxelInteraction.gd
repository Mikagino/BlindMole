extends Node3D

@export var ball : PackedScene

@export var voxelTerrain : VoxelTerrain
@export var raycast : RayCast3D


var voxelTool : VoxelToolTerrain

var interactSpeed : float = 10

func _ready() -> void:
	voxelTool = voxelTerrain.get_voxel_tool()


func _process(delta: float) -> void:
	if not raycast.is_colliding():
		return
		
	var collider = raycast.get_collider()
	if collider is not VoxelTerrain:
		return
		
	var targetPos = raycast.get_collision_point()
	
	if Input.is_action_pressed("AddTerrain"):
		voxelTool.mode = VoxelTool.MODE_ADD
		voxelTool.grow_sphere(targetPos, 2, delta * interactSpeed)
		
	if Input.is_action_pressed("RemoveTerrain"):
		voxelTool.mode = VoxelTool.MODE_REMOVE
		voxelTool.grow_sphere(targetPos, 2, delta * interactSpeed)
		
