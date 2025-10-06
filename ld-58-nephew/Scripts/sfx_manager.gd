class_name SXFManager extends Node

func on_enter_court() -> void:
	print("SFX: on enter court as %s" % Running.get_title())
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_door_01.ogg"))
	pass

func on_dialogue() -> void:
	print("SFX: on dialogue")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_dialog_01.ogg"))
	pass

func on_appraisal() -> void:
	print("SFX: on appraisal")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_appraisal_01.ogg"))
	pass

func on_congratulate() -> void:
	print("SFX: on congratulate")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_admire_01.ogg"))
	pass

func on_rank_up() -> void:
	print("SFX: on rank up to %s" % Running.get_title())
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_rankup_01.ogg"))
	pass

func on_pick_stone() -> void:
	print("SFX: on pick up stone")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_pickup_01.ogg"))
	pass

func on_river_splash() -> void:
	print("SFX: on chuck stone in river")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_splash_01.ogg"))
	pass

func on_set_stone_table() -> void:
	print("SFX: on set stone on table")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_set_shelf_01.ogg"))
	pass

func on_set_stone_shelf() -> void:
	print("SFX: on set stone on shelf")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_set_table_01.ogg"))
	pass

func on_set_stone_distiller() -> void:
	print("SFX: on add stone to distiller")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_set_distiller_01.ogg"))
	pass

func on_distillation() -> void:
	print("SFX: on distillation")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_distill_01.ogg"))
	pass

func on_stone_fracture() -> void:
	print("SFX: on stone fracture")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_crumble_01.ogg"))
	pass

func on_new_unlock() -> void:
	print("SFX: on unlock rune or arcana")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_new_stone_unlocked_01.ogg"))
	pass

func on_set_complete() -> void:
	print("SFX: on fulfil order")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_set_complete_01.ogg"))
	pass

func on_nav_button() -> void:
	print("SFX: on click nav button")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_nav_button_01.ogg"))
	pass

func on_decline() -> void:
	print("SFX: on decline action")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_decline_01.ogg"))

func on_game_over() -> void:
	print("SFX: on graduation")
	AudioManager.play_sfx(load("res://Audio/SFX/sfx_game_over_01.ogg"))
