extends Node2D

@export var origin_sprite:Sprite2D
@export var left_pigeon_sprite:Sprite2D
@export var right_pigeon_sprite:Sprite2D
@export var catalyst_sprite:Sprite2D
@export var product_sprite:Sprite2D

@export var origin_label:Label
@export var left_pigeon_label:Label
@export var right_pigeon_label:Label
@export var catalyst_label:Label
@export var product_label:Label

#@export var origin_stone:Stone = null
#@export var left_pigeon_stone:Stone = null
#@export var right_pigeon_stone:Stone = null
#@export var catalyst_stone:Stone = null
#@export var product_stone:Stone = null

func get_origin_stone() -> Stone: return TableInventory.distiller_stones[0]
func set_origin_stone(stone:Stone) -> void: TableInventory.distiller_stones[0] = stone

func get_left_pigeon_stone() -> Stone: return TableInventory.distiller_stones[1]
func set_left_pigeon_stone(stone:Stone) -> void: TableInventory.distiller_stones[1] = stone

func get_right_pigeon_stone() -> Stone: return TableInventory.distiller_stones[2]
func set_right_pigeon_stone(stone:Stone) -> void: TableInventory.distiller_stones[2] = stone

func get_catalyst_stone() -> Stone: return TableInventory.distiller_stones[3]
func set_catalyst_stone(stone:Stone) -> void: TableInventory.distiller_stones[3] = stone

func get_product_stone() -> Stone: return TableInventory.distiller_stones[4]
func set_product_stone(stone:Stone) -> void: TableInventory.distiller_stones[4] = stone

func updateGraphic(sprite: Sprite2D, label: Label, stone: Stone = null) -> void:
	if stone == null:
		label.text = Stone.nullGlyph
		label.modulate = Color.WHITE
		sprite.flip_h = true if randf() > 0.5 else false
		sprite.flip_h = true if randf() > 0.5 else false
		sprite.modulate = Color.WHITE
		sprite.visible = false
		
	else:
		sprite.visible = true
		sprite.modulate = stone.color
		label.text = stone.glyph
		label.modulate = stone.color

func UpdateUI() -> void:
	updateGraphic(origin_sprite, origin_label, get_origin_stone())
	updateGraphic(left_pigeon_sprite,left_pigeon_label,get_left_pigeon_stone())
	updateGraphic(right_pigeon_sprite,right_pigeon_label,get_right_pigeon_stone())
	updateGraphic(catalyst_sprite,catalyst_label,get_catalyst_stone())
	updateGraphic(product_sprite,product_label,get_product_stone())

func get_pigeons() -> Array[Stone]:
	var _pp:Array[Stone] = []
	if get_left_pigeon_stone(): _pp.append(get_left_pigeon_stone())
	if get_right_pigeon_stone(): _pp.append(get_right_pigeon_stone())
	return _pp

func try_alchemy() -> void:
	if !get_origin_stone() or !get_catalyst_stone() or !get_product_stone(): return
	var _valuesLib = Grimoire.TryAlchemy(get_origin_stone(),get_catalyst_stone(),get_pigeons())
	var _newStone:Stone = _valuesLib.product
	if _newStone != null:
		set_product_stone(Stone.new(_newStone.value))
		SfxManager.on_distillation()
		Running.check_new_stone(_newStone)
		UpdateUI()

func _ready() -> void:
	UpdateUI()

func _on_origin_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if get_origin_stone() == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			set_origin_stone(_stone)
			updateGraphic(origin_sprite, origin_label, get_origin_stone())
			SfxManager.on_set_stone_distiller()
			try_alchemy()
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(get_origin_stone()):
		set_origin_stone(null)
		updateGraphic(origin_sprite, origin_label, get_origin_stone())

func _on_pigeon_0_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if get_left_pigeon_stone() == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			set_left_pigeon_stone(_stone)
			updateGraphic(left_pigeon_sprite, left_pigeon_label, get_left_pigeon_stone())
			SfxManager.on_set_stone_distiller()
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(get_left_pigeon_stone()):
		set_left_pigeon_stone(null)
		updateGraphic(left_pigeon_sprite, left_pigeon_label, get_left_pigeon_stone())


func _on_pigeon_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if get_right_pigeon_stone() == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			set_right_pigeon_stone(_stone)
			updateGraphic(right_pigeon_sprite, right_pigeon_label, get_right_pigeon_stone())
			SfxManager.on_set_stone_distiller()
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(get_right_pigeon_stone()):
		set_right_pigeon_stone(null)
		updateGraphic(right_pigeon_sprite, right_pigeon_label, get_right_pigeon_stone())


func _on_catalyst_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if get_catalyst_stone() == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			set_catalyst_stone(_stone)
			updateGraphic(catalyst_sprite, catalyst_label, get_catalyst_stone())
			SfxManager.on_set_stone_distiller()
			try_alchemy()
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(get_catalyst_stone()):
		set_catalyst_stone(null)
		updateGraphic(catalyst_sprite, catalyst_label, get_catalyst_stone())


func _on_body_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !event.is_action_pressed("pointer_select"): return
	
	# Try to add a stone from the pocket inventory
	if get_product_stone() == null:
		var _stone = PocketInventory.pop_stone()
		if _stone:
			set_product_stone(_stone)
			updateGraphic(product_sprite, product_label, get_product_stone())
			SfxManager.on_set_stone_distiller()
			try_alchemy()
		return
	
	# Try to put the stone back into the pocket inventory
	if PocketInventory.add_stone(get_product_stone()):
		set_product_stone(null)
		updateGraphic(product_sprite, product_label, get_product_stone())
