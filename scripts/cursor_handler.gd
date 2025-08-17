class_name CursorHandler
enum {ARROW, FINGER, FINGER_PLANT}
const cursor_array: Array[Texture2D] = [preload("res://assets/gui/arrow.png"), preload("res://assets/gui/finger.png"), preload("res://assets/gui/finger.png")]
static var cursor_images: Array[Image]
static var current_shape = int(ARROW)

static func setScale(scale: float):
	cursor_images.resize(cursor_array.size())
	
	for i in range(cursor_images.size()):
		var scaled: Image = cursor_array[i].get_image().duplicate()
		var size := Vector2i(scale * scaled.get_size())
		scaled.resize(size.x, size.y, Image.INTERPOLATE_NEAREST)
		cursor_images[i] = scaled
	

static func init(scale: float):
	if(scale != 1.0): setScale(scale)
	
	DisplayServer.cursor_set_custom_image(cursor_images[ARROW], DisplayServer.CURSOR_ARROW)

static func select(cursor: int):
	current_shape = cursor
	DisplayServer.cursor_set_custom_image(cursor_images[cursor], DisplayServer.CURSOR_ARROW)
