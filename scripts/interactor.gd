extends Sprite2D

@export var action: Tasker.Tasks
@export var animation: StringName
@onready var area: Area2D = $Area
@onready var player_area := $Area2

@onready var animator: AnimationPlayer = $"../../Interactors"

var hover := false
var is_in_range := false 
var task_completed := false

func _ready():
	var tasker: Tasker = get_tree().get_first_node_in_group("Tasker")
	if(tasker): tasker.cycle_ended.connect(func(): task_completed = false)
	player_area.body_entered.connect(func(body): if(body is PlayerBody): is_in_range = true)
	player_area.body_exited.connect(func(body): if(body is PlayerBody): is_in_range = false)
	area.mouse_entered.connect(func(): hover = true)
	area.mouse_exited.connect(func(): hover = false)

func _process(_delta):
	if(is_in_range && hover && !task_completed): 
		modulate = Color.AQUA
		if(Input.is_action_just_pressed("click")):
			if(animator.is_playing()): return
			animator.play(animation)
			task_completed = true
	else: modulate = Color.WHITE
