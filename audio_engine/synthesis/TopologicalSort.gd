class_name TopologicalSort

enum VisitState {
	UNVISITED,
	VISITING,
	VISITED
}

static var _states: Dictionary
static var _result: Array[Module]

static func sort(modules: Array[Module]) -> Array[Module]:
	_states = {}
	_result = []

	for m in modules:
		_states[m] = VisitState.UNVISITED

	# run DFS
	for m in modules:
		if _states[m] == VisitState.UNVISITED:
			_visit(m)

	_result.reverse()
	return _result


static func _visit(m: Module) -> void:
	if _states[m] == VisitState.VISITING:
		push_error("Cycle at: ", str(m))
		return

	if _states[m] == VisitState.VISITED:
		return

	_states[m] = VisitState.VISITING

	# dependencies: input.source → this module
	for input in m.inputs:
		var source: Module = input.source
		if source != null:
			_visit(source)

	_states[m] = VisitState.VISITED
	_result.append(m)
