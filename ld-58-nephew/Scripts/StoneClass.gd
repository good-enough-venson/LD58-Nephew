class_name Stone extends Resource

static var MINSTONE = 1
static var MAXSTONE = 100

static var stoneFamilies = {11:4,7:3,5:2,3:1,2:0}
static var stoneGlyphs = "IN1LQVUHTZY2AFCKJxGO34567890RBSEPMD"
static var nullGlyph = "@"

static func get_root_stone(fromValue) -> int:
	for p in stoneFamilies.keys():
		if int(fromValue)%p == 0:
			return(p)
	return -1

static func get_stone_family(fromValue:int) -> int:
	for p in stoneFamilies.keys():
		if int(fromValue)%p == 0:
			return(stoneFamilies[p])
	return -1
	
static func get_stone_sibId(fromValue:int) -> int:
	if fromValue < MINSTONE or fromValue > MAXSTONE: return -1
	var f = get_root_stone(fromValue)
	if f < 0: return fromValue
	return roundi(float(fromValue)/f)

static func get_stone_glyph(fromValue:int) -> String:
	var _sibID = get_stone_sibId(fromValue)
	return nullGlyph if _sibID < 1 else stoneGlyphs.substr(_sibID-1, 1)

static func get_stone_catalyst(fromValue:int) -> Dictionary:
	var f = get_stone_family(fromValue)
	var c = Catalyst[Catalyst.find_custom(func(_c) -> bool: return _c.family == f)]
	return c

# We're getting stones that are impossible to render, which is causing issues at higher levels.
static func check_stone_is_valid(fromValue:int) -> bool:
	if fromValue < MINSTONE: return false
	if fromValue > MAXSTONE: return false
	if get_stone_family(fromValue) < 0: return false
	if get_stone_sibId(fromValue) >= stoneGlyphs.length(): return false
	return true

static var Catalyst = [
	{
		"family":-1, "name":"rock","color":Color.DARK_GRAY,
		"note":"is not recommended for use as catalyst",
		"description":"produces only rocks, and pigeons have no effect",
		"function": func(o: float, _p: Array) -> float: return -1
	},
	
	#{
		#"family":0, "name":"Plus","color":Color.DARK_ORANGE, 
		#"function": func(o: float, p: Array) -> float:
			#for _p in p: o+=_p
			#return o
			#,
	#},
	
	#{
		#"family":1, "name":"Plus","color":Color.DARK_ORANGE, 
		#"function": func(o: float, p: Array) -> float:
			#for _p in p: o+=_p
			#return o
			#,
	#},

	{
		"family":0, "name":"anaithnid","color":Color.DARK_ORANGE, 
		"note":"yields unpredictable results",
		"description":"increases unpredictability with pigeons' power",
		"function": func(o: float, p: Array) -> float:
			var offset = 3 	
			for _p in p: offset += get_stone_sibId(_p)
			return o + (randi() % offset) - floori(float(offset)/2),
	},
	{
		"family":1, "name":"comhar","color":Color.FOREST_GREEN,
		"note":"produces runestones closely related in power",
		"description":"utilizes pigeons' arcanae and base power levels",
		"function": func(o: float, p: Array) -> float: 
			var _sign = 1
			var _offset = 1
			for _p in p:
				_offset += _p
				if get_root_stone(_p) != get_root_stone(o): 
					_sign = -1
			return o + (_sign * _offset)
			
			
			#match p.size():
				#2: match get_stone_family(p[0]):
					#0: return o - p[1]
					#1: return o + p[1]
					#_: return -1
				#1: match get_stone_family(p[0]):
					#0: return o - 1
					#_: return -1
				#_: return o + 1
			,
	},
	{
		"family":2, "name":"iolraigh","color":Color.DEEP_SKY_BLUE,
		"note":"is useful for working within arcanae",
		"description":"scales power level within arcanum based on pigeons' power",
		"function": func(o: float, p: Array) -> float:
			var _factors = get_stone_sibId(o)
			for _p in p:
				if get_root_stone(_p) == get_root_stone(o):
					_factors += get_stone_sibId(_p)
				else: _factors -= get_stone_sibId(_p)
			return get_root_stone(o) * _factors
			
			#match p.size():
				#2: match get_stone_family(p[0]):
					#2: return o / p[1]
					#3: return o * p[1]
					#_: return -1
				#1: match get_stone_family(p[0]):
					#2: return o / 2
					#_: return -1
				#_: return o * 2
			,
	},
	{
		"family":3, "name":"comhdhuil","color":Color.CRIMSON,
		"note":"builds fundamental runestones based on arcanae",
		"description":"combines arcanae, building on the origin stone's power",
		"function": func(o: float, p: Array) -> float: 
			var product = get_root_stone(o)
			for pigeon in p:
				product *= get_root_stone(pigeon)
			return product * get_stone_sibId(o),
	},
	{
		"family":4, "name":"caenn","color":Color.MEDIUM_ORCHID,
		"note":"takes pigeons very seriously.",
		"description":"can change arcana, keeping power level if stablized",
		"function": func(o: float, p: Array) -> float: 
			var _val = get_stone_sibId(o)
			var _bas = -1
			var _stb = false
			
			for _p in p:
				if _stb == false and get_root_stone(_p) == get_root_stone(o):
					_stb = true
					_bas = get_root_stone(0)
				else: _bas = get_root_stone(_p)
			
			if _stb: return _val * _bas
			else: return _val
			
			#var base = get_root_stone(o)
			#match p.size():
				#2: match get_stone_family(p[0]):
					#3: return pow(o, 1 / float(get_stone_family(p[1]) + 1))
					#4: return pow(base, get_stone_family(p[1]) + 1)
					#_: return -1
				#1: match get_stone_family(p[0]):
					#3: return pow(base, 0.5)
					#4: return pow(base, 2)
					#_: return -1
				#_: return base
			,
	}
]

@export var name: String
@export var glyph: String
@export var color: Color

@export var value: int
@export var family: int
@export var catalyst: Dictionary
@export var sibId: int
var sort_id_fam_sib: float

func _init(p_value: int):
	p_value = clampi(p_value, MINSTONE, MAXSTONE)
	p_value = 1 if get_stone_family(p_value) == -1 else p_value 
	
	value = p_value
	family = get_stone_family(p_value)
	sibId = get_stone_sibId(p_value)
	catalyst = get_stone_catalyst(p_value)
	name = "%d.%d(%d)" % [family, sibId, value]
	glyph = get_stone_glyph(value)
	color = catalyst.color.lerp(Color.WHITE_SMOKE, float(sibId-1)/50)
	
	# This should give a number like 2.03, which will allow for sorting
	#  by class mainly, and then subclass.
	sort_id_fam_sib = float(family) + (float(sibId) / 100)

func get_catalyst() -> Dictionary:
	return get_stone_catalyst(value)

func get_catalyst_function() -> Callable:
	return get_catalyst().function

func use_catalyst(originStone:Stone, pigeons:Array[Stone]=[]) -> float:
	var _pigeons = []
	for _p in pigeons: if _p: _pigeons.append(_p.value)
	return get_catalyst_function().call(originStone.value, _pigeons)
