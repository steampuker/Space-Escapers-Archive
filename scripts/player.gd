extends CharacterBody2D
class_name PlayerBody

@onready var mouse_area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: Vector2 = Vector2.ONE
@export var player_velocity := Vector2.ZERO

enum Direction {DOWN, UP, LEFT, RIGHT}
var direction: Direction = Direction.DOWN

func _process(delta):
	player_velocity.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	player_velocity.y = Input.get_action_strength("up") - Input.get_action_strength("down")
	player_velocity *= speed * delta * 30.0
	
	if(player_velocity.y > 0.0): direction = Direction.UP
	elif(player_velocity.y < 0.0): direction = Direction.DOWN
	elif(player_velocity.x > 0.0): direction = Direction.RIGHT
	elif(player_velocity.x < 0.0): direction = Direction.LEFT
	
	move()
	animate()

func move():
	if(move_and_collide(player_velocity * Vector2.RIGHT)): player_velocity.x = 0.0
	if(move_and_collide(player_velocity * Vector2.UP)): player_velocity.y = 0.0
		

func animate():
	var act_string: StringName
	var dir_string: StringName = ["_front", "_back", "_side", "_side"][int(direction)]
	sprite.flip_h = direction == Direction.RIGHT
	
	if(player_velocity.length_squared() > 0.1): act_string = "walk"
	else: act_string = "idle"
	
	sprite.play(act_string + dir_string)

func set_frame(animation: String, frame: int, flip_h: bool):
	sprite.play(animation)
	sprite.frame = frame
	sprite.flip_h = flip_h
