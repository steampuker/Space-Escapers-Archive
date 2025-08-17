extends Control

@export var part_interval := 120.0
@onready var tasker: Tasker = $"../../Tasker"

@onready var arrow = $Arrow
@onready var bars: Array[Sprite2D] = [$Alpha, $Beta, $Gamma]

@onready var scene_changer := $"../SceneChanger"

var arrow_scale: Vector2
var progress = 0

func _ready():
	arrow_scale = arrow.scale
	tasker.task_added.connect(on_task)
	tasker.cycle_ended.connect(on_cycle_end)
	tasker.streak_changed.connect(func(streak): print(streak); $Label.text = str(streak))
	tasker.streak_ended.connect(func(): scene_changer.changeScene())

func on_task():
	bars[int(tasker.current_part)].texture = preload("res://assets/gui/cycle completion2.png")
	progress += 1
	
	if(progress >= 2):
		progress = 0
		moveToNextPart()
	

func on_cycle_end():
	$"../Control2".cycle_ended()
	for bar in bars:
		bar.texture  = preload("res://assets/gui/cycle completion.png")

func moveToNextPart():
	tasker.nextPart()
	
	var profile: Dictionary = [
		{
			"arrow_texture" : preload("res://assets/gui/select.png"),
			"should_flip" : true,
			"modulation" : [1.0, 0.1, 0.1]
		},
		{
			"arrow_texture" : preload("res://assets/gui/select2.png"),
			"should_flip" : false,
			"modulation" : [0.1, 1.0, 0.1]
		},
		{
			"arrow_texture" : preload("res://assets/gui/select.png"),
			"should_flip" : false,
			"modulation" : [0.1, 0.1, 1.0]
		}
	][int(tasker.current_part)]
	
	var tween = create_tween().set_parallel()
	var arrow_tween = create_tween()
	
	arrow_tween.tween_property(arrow, "scale", arrow_scale * Vector2(1.2, 1.2), 0.1)
	arrow_tween.tween_property(arrow, "scale", arrow_scale * Vector2(0.9, 0.9), 0.1)
	arrow_tween.tween_property(arrow, "scale", arrow_scale, 0.1)
	
	for i in range(bars.size()):
		tween.tween_property(bars[i], "self_modulate:a", profile["modulation"][i], 0.1).set_delay(0.1)
	
	await create_tween().tween_interval(0.2).finished
	$AudioStreamPlayer.play()
	arrow.texture = profile["arrow_texture"]
	arrow.flip_h = profile["should_flip"]
