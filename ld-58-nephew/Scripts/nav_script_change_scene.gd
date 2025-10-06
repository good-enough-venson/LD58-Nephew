extends Area2D

@export var goto_scene = "MainMenu"

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("pointer_select"):
		SfxManager.on_nav_button()
		Running.load_scene(Running.Scenes[goto_scene])
