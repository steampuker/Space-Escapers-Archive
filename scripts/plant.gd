extends Node2D

@export var growth_time := 10.0
@onready var sprite: Sprite2D = $Plant
@onready var area: Area2D = $Area2D

var tile_data: Array[Vector2i]
var occupied_rect: Rect2i

var harvest_ready := false
var mouse_hover := false
var in_range := false

var progress := 0.0

var player_distance: Node2D

signal harvested

func _ready():
	$Area2D2.body_entered.connect(func(body): 
		if body is PlayerBody: 
			if(mouse_hover && harvest_ready): highlight() 
			in_range = true)
	$Area2D2.body_exited.connect(func(body): 
		if body is PlayerBody:
			if(mouse_hover): highlight(false) 
			in_range = false)
	area.mouse_entered.connect(on_enter)
	area.mouse_exited.connect(on_exit)

func _enter_tree():
	get_tree().create_timer(growth_time).timeout.connect(stage_increased)

func on_enter():
	if(CursorHandler.current_shape != CursorHandler.FINGER_PLANT): 
		mouse_hover = true;
		if(harvest_ready && in_range): 
			highlight()

func on_exit():
	if(CursorHandler.current_shape != CursorHandler.FINGER_PLANT):
		highlight(false)
		mouse_hover = false; 

func highlight(enabled := true):
	if(enabled):
		CursorHandler.select(CursorHandler.FINGER)
		sprite.modulate = Color.AQUA
	else:
		CursorHandler.select(CursorHandler.ARROW)
		sprite.modulate = Color.WHITE
	
func stage_increased():
	progress += 1
	sprite.frame = clampi(int(progress), 0, 2)
	
	if(sprite.frame >= 2):
		if(in_range && mouse_hover):
			highlight()
		harvest_ready = true
	else:
		get_tree().create_timer(growth_time).timeout.connect(stage_increased)

func _process(_delta):
	if(in_range && harvest_ready && mouse_hover && Input.is_action_just_pressed("click")):
		highlight(false)
		harvested.emit(occupied_rect, tile_data)
		queue_free()
