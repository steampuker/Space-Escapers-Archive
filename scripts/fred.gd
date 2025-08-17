extends Node2D

@onready var sprite: Sprite2D = $Sprite
@onready var sound_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var planter: PlantSpot;

var mouse_hover := false
var in_range := false

signal fed

func _ready():
	planter = get_node_or_null("../PlantSpot")

func blurp(vel_dir: Vector2):
	var tween = create_tween()
	var move_tween = create_tween()
	var pos = sprite.position
	
	sound_player.pitch_scale = 1.0 + randf_range(-0.05, 0.05)
	
	move_tween.tween_property(sprite, "position", pos + vel_dir, 0.1).set_delay(0.05)
	move_tween.tween_property(sprite, "position", pos, 0.1)
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.1).from(Vector2.ONE)
	tween.tween_callback(sound_player.play)
	
	tween.tween_property(sprite, "scale", Vector2(0.8, 1.2), 0.1)
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.1)

func _on_blurps_body_entered(body):
	if(body is not PlayerBody): return
	var vel_dir: Vector2 = body.player_velocity.normalized() * 2.0
	vel_dir.y = -vel_dir.y
	in_range = true
	blurp(vel_dir)

func _on_blurps_body_exited(body):
	if(body is not PlayerBody): return
	in_range = false

func _on_blurps_mouse_entered():
	mouse_hover = true


func _on_blurps_mouse_exited():
	mouse_hover = false

func _process(_delta):
	if(mouse_hover && in_range && planter.seeds > 0):
		modulate = Color.PALE_TURQUOISE
		if(Input.is_action_just_pressed("click")): 
			blurp(Vector2.ZERO)
			fed.emit()
	else:
		modulate = Color.WHITE
