class_name Grimoire extends Node

static func TryAlchemy(origin:Stone, catalyst:Stone, pigeons:Array[Stone]=[]) -> Dictionary:
	var results = {"origin":origin, "catalyst":catalyst, "pigeons":pigeons, "product":null}
	if !origin or !catalyst: return results
	
	var _val = roundi(catalyst.use_catalyst(origin, pigeons))
	var _log = "Tried Alchemizing %s with %s" % [origin.value, catalyst.catalyst.name]
	if pigeons.size() > 0: _log += " and %s" % pigeons[0].value
	if pigeons.size() > 1: _log += " and %s" % pigeons[1].value
	print(_log + ": %d" % _val)
	
	# Here is where we'd send our stones through a series of filters and checks
	#  to see if we need to break any of them. However, for now, we'll pass everything.
	results.product = Stone.new(_val)
	return results
