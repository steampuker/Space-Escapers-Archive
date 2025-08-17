extends CanvasLayer

@export var tasker: Tasker

var sanity: float = 0
var hunger: float = 100

const second: float = 0.01
var time: float = 0.0

static func strf(num: float) -> String:
	return str(roundf(num * 10) / 10)

func _ready():
	assert(tasker)
	tasker.streak_ended.connect(func(): print("The end!"))
	tasker.cycle_ended.connect(
		func():
			print("New cycle! - Streak: ", tasker.streak))

func _process(delta):
	
	if(Input.is_action_just_pressed("click")):
		taskerHandleTEMP()
	if(Input.is_action_just_pressed("right_click")):
		taskerHandleTEMP2()
		
func taskerHandleTEMP():
	const tasks := [Tasker.Tasks.CROP_PLANTED, Tasker.Tasks.CROP_HARVESTED]
	var action = 0 #randi_range(0, tasks.size() - 1)
	
	print("Commited: ", ["Crop Planting", "Crop Harvesting"][action])
	tasker.addTask(tasks[action])
	
func taskerHandleTEMP2():
	print("Next Part")
	#tasker.nextPart()
	
