extends Node2D

@export var tableCorners: Array[Node2D] = [null, null, null, null]
@export var stone_pool:PoolTable
@export var shadow: Node2D

# Four corner points of the quadrilateral in 2D space
func top_left() -> Vector2: return tableCorners[0].global_position
func top_right() -> Vector2: return tableCorners[1].global_position
func bottom_left() -> Vector2: return tableCorners[2].global_position
func bottom_right() -> Vector2: return tableCorners[3].global_position

# spool up the graphics for the table inventory
func _ready() -> void:
	stone_pool.release_all()
	var inventory = TableInventory.table_stones.duplicate()
	for key in inventory.keys():
		var pos = map_from_grid(key,TableInventory.GRID_WIDTH, TableInventory.GRID_HEIGHT) 
		stone_pool.get_stone_node(inventory[key], pos)

func _process(delta: float) -> void:
	var mousePos = get_global_mouse_position()
	var gridPos = map_to_grid(mousePos,TableInventory.GRID_WIDTH,TableInventory.GRID_HEIGHT)
	
	if Vector2i(gridPos) != Vector2i(-1,-1):
		gridPos = Vector2(round(gridPos.x), round(gridPos.y))
		gridPos = map_from_grid(gridPos, TableInventory.GRID_WIDTH, TableInventory.GRID_HEIGHT)
		shadow.global_position = gridPos
	else:
		shadow.global_position = Vector2.RIGHT*2000

func map_to_grid(point: Vector2, grid_width: float, grid_height: float) -> Vector2:
	# Maps a 2D point to grid coordinates using bilinear interpolation
	# grid_width and grid_height define the size of the grid (e.g., 10x10)
	
	# Find the relative position of the point within the quadrilateral
	# Solve for u, v where point = (1-u)(1-v)*top_left + u(1-v)*top_right + (1-u)v*bottom_left + u*v*bottom_right
	
	var A = top_left() - top_right() - bottom_left() + bottom_right()
	var B = top_right() - top_left()
	var C = bottom_left() - top_left()
	var D = top_left() - point
	
	# Coefficients for the quadratic equation to solve for u, v
	var a = A.x * C.y - A.y * C.x
	var b = B.x * C.y - B.y * C.x + A.x * D.y - A.y * D.x
	var c = B.x * D.y - B.y * D.x
	
	# Solve quadratic equation: a*v^2 + b*v + c = 0
	var discriminant = b * b - 4 * a * c
	if discriminant < 0:
		return Vector2(-1, -1) # Point is outside the grid or invalid
	
	var v = (-b + sqrt(discriminant)) / (2 * a)
	if abs(a) < 0.0001: # Avoid division by zero
		v = -c / b if abs(b) > 0.0001 else 0.0
	
	# Solve for u
	var denom_x = (1 - v) * (top_right().x - top_left().x) + v * (bottom_right().x - bottom_left().x)
	var u = 0.0
	if abs(denom_x) > 0.0001:
		u = (point.x - ((1 - v) * top_left().x + v * bottom_left().x)) / denom_x
	else:
		# Fallback to y-coordinate if x is degenerate
		var denom_y = (1 - v) * (top_right().y - top_left().y) + v * (bottom_right().y - bottom_left().y)
		if abs(denom_y) > 0.0001:
			u = (point.y - ((1 - v) * top_left().y + v * bottom_left().y)) / denom_y
	
	# Check if the point is inside the quadrilateral
	if u < 0.0 or u > 1.0 or v < 0.0 or v > 1.0:
		return Vector2(-1, -1) # Point is outside the grid
	
	# Scale to grid coordinates
	var grid_x = u * grid_width
	var grid_y = v * grid_height
	
	return Vector2(grid_x, grid_y)

func map_from_grid(grid_point: Vector2, grid_width: float, grid_height: float) -> Vector2:
	# Maps a grid point back to 2D space
	var u = grid_point.x / grid_width
	var v = grid_point.y / grid_height
	
	# Bilinear interpolation to find the corresponding 2D point
	var x = (1 - u) * (1 - v) * top_left().x + u * (1 - v) * top_right().x + (1 - u) * v * bottom_left().x + u * v * bottom_right().x
	var y = (1 - u) * (1 - v) * top_left().y + u * (1 - v) * top_right().y + (1 - u) * v * bottom_left().y + u * v * bottom_right().y
	
	return Vector2(x, y)


func _on_table_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var select = event.is_action_pressed("pointer_select")
	var deselect = event.is_action_pressed("pointer_deselect")
	
	if select or deselect:
		var mousePos = get_global_mouse_position()
		var gridPos = map_to_grid(mousePos,TableInventory.GRID_WIDTH,TableInventory.GRID_HEIGHT)
		#print("pos[%d, %d]" % [roundi(gridPos.x), roundi(gridPos.y)])
		var data = TableInventory.try_place_stone(Vector2i(roundi(gridPos.x), roundi(gridPos.y)), deselect)
		if data.dropped:
			var pos = map_from_grid(data.pos,TableInventory.GRID_WIDTH, TableInventory.GRID_HEIGHT) 
			stone_pool.get_stone_node(data.stone, pos)
			SfxManager.on_set_stone_table()
		elif data.picked:
			stone_pool.release_stone_node(data.stone)
