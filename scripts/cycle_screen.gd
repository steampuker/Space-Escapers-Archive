extends Control

@export var match_color: Color
@export var mismatch_color: Color

@onready var last := $"ColorRect/Last"
@onready var last_actions_alpha := $"ColorRect/Last/Margin/Parts/Alpha/Scroll/Text"
@onready var last_actions_beta :=  $"ColorRect/Last/Margin/Parts/Beta/Scroll/Text"
@onready var last_actions_gamma := $"ColorRect/Last/Margin/Parts/Gamma/Scroll/Text"
@onready var this := $"ColorRect/This"
@onready var this_actions_alpha := $"ColorRect/This/Margin/Parts/Alpha/Scroll/Text"
@onready var this_actions_beta :=  $"ColorRect/This/Margin/Parts/Beta/Scroll/Text"
@onready var this_actions_gamma := $"ColorRect/This/Margin/Parts/Gamma/Scroll/Text"

@export var tasker: Tasker

const actions = ["", "Crop Planted", "Crop Harvested", "Called Base", "Browsed Intercom", "Fed Fred", "Slept"]

func _ready():
	assert(tasker)
	last.self_modulate = match_color
	$Button.pressed.connect(func(): visible = false)

func cycle_ended():
	visible = true
	last.visible = tasker.has_previous
	
	if(tasker.current_progress.equals(tasker.previous_progress)):
		this.self_modulate = match_color
		$Star.visible = true
	else:
		this.self_modulate = mismatch_color
		$Star.visible = false
	
	if tasker.has_previous:
		last_actions_alpha.text = ""
		last_actions_beta.text = ""
		last_actions_gamma.text = ""
		for i in tasker.previous_progress.morning:
			last_actions_alpha.text += actions[i] + "\n"
		for i in tasker.previous_progress.afternoon:
			last_actions_beta.text += actions[i] + "\n"
		for i in tasker.previous_progress.evening:
			last_actions_gamma.text += actions[i] + "\n"
			
	this_actions_alpha.text = ""
	this_actions_beta.text = ""
	this_actions_gamma.text = ""
	for i in tasker.current_progress.morning:
		this_actions_alpha.text += actions[i] + "\n"
	for i in tasker.current_progress.afternoon:
		this_actions_beta.text += actions[i] + "\n"
	for i in tasker.current_progress.evening:
		this_actions_gamma.text += actions[i] + "\n"
