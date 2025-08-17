extends Label

@export var delay := 1.0
var tween: Tween

func _ready():
	modulate.a = 0
	set_process(false)

func start():
	tween = create_tween()
	set_process(true)
	
	await tween.tween_interval(delay).finished
	
	tween.kill()
	tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	tween.tween_property(self, "visible_ratio", 1.0, 1.0)

func _process(_delta):
	if(Input.is_action_just_pressed("toggle_planting")):
		tween.kill()
		queue_free()
