extends Control

@export var gameScene: PackedScene;

func NewGame() -> void:
	get_tree().change_scene_to_packed(gameScene);

func Exit() -> void:
	get_tree().quit();