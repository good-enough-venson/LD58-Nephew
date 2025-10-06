class_name SXFManager extends Node

func on_enter_court() -> void:
	print("SFX: on enter court as %s" % Running.get_title())
	pass

func on_dialogue() -> void:
	print("SFX: on dialogue")
	pass

func on_appraisal() -> void:
	print("SFX: on appraisal")
	pass

func on_congratulate() -> void:
	print("SFX: on congratulate")
	pass

func on_rank_up() -> void:
	print("SFX: on rank up to %s" % Running.get_title())
	pass

func on_pick_stone() -> void:
	print("SFX: on pick up stone")
	pass

func on_river_splash() -> void:
	print("SFX: on chuck stone in river")
	pass

func on_set_stone_table() -> void:
	print("SFX: on set stone on table")
	pass

func on_set_stone_shelf() -> void:
	print("SFX: on set stone on shelf")
	pass

func on_set_stone_distiller() -> void:
	print("SFX: on add stone to distiller")
	pass

func on_distillation() -> void:
	print("SFX: on distillation")
	pass

func on_stone_fracture() -> void:
	print("SFX: on stone fracture")
	pass

func on_new_unlock() -> void:
	print("SFX: on unlock rune or arcana")
	pass

func on_set_complete() -> void:
	print("SFX: on fulfil order")
	pass

func on_nav_button() -> void:
	print("SFX: on click nav button")
	pass

func on_decline() -> void:
	print("SFX: on decline action")
