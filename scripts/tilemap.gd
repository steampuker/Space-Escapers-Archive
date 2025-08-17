extends Node2D

@export var tilemap: TileMapLayer
@export var highlight_rect: Rect2

var lerp_progress = 0.0
var prev_map: Vector2i
var tween: Tween

func _ready():
	tween = create_tween().set_loops()
	tween.tween_property(self, "self_modulate:a", 0.5, 1.0).from(0.1)
	tween.tween_property(self, "self_modulate:a", 0.1, 1.0).from(0.5)

func _process(delta):
	var mouse_map = tilemap.local_to_map(tilemap.get_local_mouse_position())
	
	if(mouse_map == prev_map): 
		return
	
	if(tilemap.get_cell_atlas_coords(mouse_map).x != 1): 
		visible = false
		return
	
	visible = true
	highlight_rect.position = tilemap.map_to_local(mouse_map)
	highlight_rect.size = Vector2(tilemap.tile_set.tile_size)
	position += (highlight_rect.position - position) * 0.5
	scale = highlight_rect.size
	queue_redraw()
