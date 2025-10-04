extends Node2D

# Catalysts as defined: o = origin, p = array of pigeon values
var catalysts = {
	"Blank": func(o: float, p: Array) -> float: return o,

	"Random": func(o: float, p: Array) -> float:
		match p.size():
			2: 
				var _o = o
				for i in range(get_prime_family(p[1])):
					var _f = get_prime_family(p[0])
					_o += (randi() % (2 * _f + 1)) - _f
				return _o
			1: 
				var _f = get_prime_family(p[0])
				return o + (randi() % (2 * _f + 1)) - _f
			_: return o + (randi() % 3) - 1
		,
	"Add": func(o: float, p: Array) -> float: 
		match p.size():
			2: match get_prime_family(p[0]):
				0: return o - p[1]
				1: return o + p[1]
				_: return -1
			1: match get_prime_family(p[0]):
				0: return o - 1
				_: return -1
			_: return o + 1
		,
	"Multiply": func(o: float, p: Array) -> float:
		match p.size():
			2: match get_prime_family(p[0]):
				2: return o / p[1]
				3: return o * p[1]
				_: return -1
			1: match get_prime_family(p[0]):
				2: return o / 2
				_: return -1
			_: return o * 2
		,
	"Factor": func(o: float, p: Array) -> float: 
		var product = get_prime(o)
		for pigeon in p:
			product *= get_prime(pigeon)
		return product,
		
	"Raise": func(o: float, p: Array) -> float: 
		var base = get_prime(o)
		match p.size():
			2: match get_prime_family(p[0]):
				3: return pow(o, 1 / (get_prime_family(p[1]) + 1))
				4: return pow(base, get_prime_family(p[1]) + 1)
				_: return -1
			1: match get_prime_family(p[0]):
				3: return pow(base, 0.5)
				4: return pow(base, 2)
				_: return -1
			_: return base
		,
}

var filters = {
	"NoDuplicates": func(_v:float, _vv:Array) -> bool: return _vv.has(_v) == false,
	#"NotEvens": func(_v:float, _vv:Array) -> bool: return int(_v) % 2 == 1,
	"NotSmall": func(_v:float, _vv:Array) -> bool: return _v > 0,
	"NotLarge": func(_v:float, _vv:Array) -> bool: return _v < 1000
}

# Origin numbers
var origins = [3.0, 6.0, 9.0]
#var origins = [3, 7, 9, 13, 15, 17, 21, 35, 49]

var primes = [2,3,5,7,9]

func get_prime(value) -> int:
	var i = get_prime_family(value)
	if i < 0: return -1
	return primes[i]

func get_prime_family(value:int) -> int:
	for i in primes.size():
		var p = primes[i]
		if value%p == 0:
			return(i)
	return -1

# Calculate all possible stone values
func calculate_all_combinations() -> Array:
	var results = []
	
	# For each origin
	for o in origins:
		# For each catalyst
		for cat_name in catalysts.keys():
			var catalyst = catalysts[cat_name]
			
			# Case 1: No pigeons
			var result = catalyst.call(o, [])
			results.append({"origin": o, "pigeons": [], "catalyst": cat_name, "value": result})
			
			# Case 2: One pigeon (from origins)
			for p1 in origins:
				result = catalyst.call(o, [p1])
				results.append({"origin": o, "pigeons": [p1], "catalyst": cat_name, "value": result})
			
			# Case 3: Two pigeons (all combinations, including duplicates)
			for p1 in origins:
				for p2 in origins:
					result = catalyst.call(o, [p1, p2])
					results.append({"origin": o, "pigeons": [p1, p2], "catalyst": cat_name, "value": result})
	
	# Extract unique values, Apply filters, and Sort
	var values = []
	var stones = []
	for res in results:
		# Squash to Integer
		var _val = round(res.value)
		
		# Apply Filters
		var gonogo = true
		for _key in filters.keys():
			if filters[_key].call(_val, values) == false:
				#print(str(_val)+" failed "+_key)
				gonogo = false
				break
		
		# If it passes all of the filters, add it to the list.
		if gonogo:
			values.append(_val)
			stones.append(res)
	
	#values.sort()
	stones.sort_custom(func(a,b) -> bool: return a.value < b.value)
	
	return stones

func sum(values:Array) -> float:
	var _sum = 0
	for v in values: _sum += v 
	return max(_sum, 0)

func mean(values:Array) -> float:
	return div(sum(values), values.size())
	
func div(o:float, p:float) -> float:
	if p == 0: 
		return 0
	return o/p

# Print results (call this to test)
func _ready():
	for i in range(1,50):
		var _s = str(i) + " -> "
		var p = get_prime(i)
		print(_s + str(p) + "." + str(i/p) if p >= 0 else _s + "dormant")
	
	return
	
	var results = calculate_all_combinations()
	#print("All possible stone values: ", results)
	
	var secondOrder = []
	
	for stone in results:
		secondOrder.append(stone.value)
		if stone.pigeons.size() == 0:
			print(str(stone.origin) + " -> " + stone.catalyst + " = " + str(stone.value))
		elif stone.pigeons.size() == 1:
			print(str(stone.origin) + " and " + str(stone.pigeons[0]) +
				" -> " + stone.catalyst + " = " + str(stone.value))
		elif stone.pigeons.size() == 2:
			print(str(stone.origin) + " and (" + str(stone.pigeons[0])+ ", " + str(stone.pigeons[0]) +
				") -> " + stone.catalyst + " = " + str(stone.value))
	
	print(secondOrder)
