extends Node2D

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scene/level 1.tscn")

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scene/lv_2.tscn")
