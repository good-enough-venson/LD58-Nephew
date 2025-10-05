extends Node2D

@export var sprite: Sprite2D
@export var label: Label

func update_graphic(stone:Stone = null, z:int = 0) -> void:
	if stone == null:
		visible = false
		label.text = Stone.nullGlyph
		label.modulate = Color.WHITE
		sprite.flip_h = true if randf() > 0.5 else false
		sprite.flip_h = true if randf() > 0.5 else false
		sprite.modulate = Color.WHITE
		
	else:
		visible = true
		#sprite.z_index = z
		#label.z_index = z
		sprite.modulate = stone.color
		label.text = stone.glyph
		label.modulate = stone.color
