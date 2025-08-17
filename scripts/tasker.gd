class_name Tasker
extends Node

enum PartCycle {
	MORNING, AFTERNOON, EVENING
}

enum Tasks {
	NONE,
	CROP_PLANTED, 
	CROP_HARVESTED,
	CALLED_OUTERCOM,
	BROWSED_OUTERCOM,
	FED_FRED,
	SLEPT
}

class CycleTasks:
	var morning: PackedInt32Array = [Tasks.NONE]
	var afternoon: PackedInt32Array = [Tasks.NONE]
	var evening: PackedInt32Array = [Tasks.NONE]
	
	static func arrays_equal(array1, array2) -> bool:
		if array1.size() != array2.size(): return false
		for item in array1:
			if !array2.has(item): return false
			if array1.count(item) != array2.count(item): return false
		return true
	
	func clear():
		morning.clear()
		afternoon.clear()
		evening.clear()
	
	func reassign(another: CycleTasks):
		morning = another.morning.duplicate()
		afternoon = another.afternoon.duplicate()
		evening = another.evening.duplicate()
	
	func equals(another: CycleTasks) -> bool:
		return arrays_equal(morning, another.morning) && \
				arrays_equal(afternoon, another.afternoon) && \
				arrays_equal(evening, another.evening)
	
	func is_null() -> bool: return morning.has(Tasks.NONE) && afternoon.has(Tasks.NONE) && evening.has(Tasks.NONE)

var current_part: int = PartCycle.MORNING
var current_progress: CycleTasks = CycleTasks.new()
var previous_progress: CycleTasks = CycleTasks.new()

var has_previous := false

const STREAK_FINISH = 4
var streak: int = 0
signal part_changed
signal cycle_ended
signal streak_changed
signal streak_ended
signal task_added

func addTask(task: Tasks):
	match(current_part):
		PartCycle.MORNING: current_progress.morning.append(task)
		PartCycle.AFTERNOON: current_progress.afternoon.append(task)
		PartCycle.EVENING: current_progress.evening.append(task)
	
	task_added.emit()

func endCycle():
	has_previous = true
	
	if(current_progress.equals(previous_progress) && !previous_progress.is_null()):
		streak += 1
	else:
		streak = 0
	
	streak_changed.emit(streak)
	
	previous_progress.reassign(current_progress)
	current_progress.clear()
	
	if(streak >= STREAK_FINISH):
		streak_ended.emit()

func nextPart() -> PartCycle:
	part_changed.emit()
	current_part += 1
	if(current_part > PartCycle.EVENING):
		cycle_ended.emit()
		current_part = PartCycle.MORNING
		endCycle()
	return current_part as PartCycle
