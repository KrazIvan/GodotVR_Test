class_name WhiteBoard
extends StaticBody3D


@export var image_size: Vector2: get = _get_image_size, set = _set_image_size
@export var image_scale: float: get = _get_image_scale, set = _set_image_scale 
@export var initial_color: Color: get = _get_initial_color, set = _set_initial_color

var _is_ready := false
var _image_size := Vector2(1000.0, 1000.0)
var _image_scale := 0.0001
var _initial_color := Color.WHITE

@onready var _collision: CollisionShape3D = $WhiteBoardCollision
@onready var _mesh: MeshInstance3D = $WhiteBoardMesh
@onready var _viewport: WhiteBoardViewport = $WhiteBoardViewport



func _ready():
	_is_ready = true
	_update_whiteboard_geometry()

func mark(from: Vector2, to: Vector2, color: Color, width: float):
	
	_viewport.mark(from, to, color, width / _image_scale)


func erase(from: Vector2, to: Vector2, width: float):
	_viewport.erase(from, to, _initial_color, width / _image_scale)


# Convert world-coordinates to image coordinates
func to_image(position: Vector3) -> Vector2:
	var local_position : Vector3 = (position) * global_transform

	var image_position := Vector2(local_position.x, local_position.y)
	image_position /= _image_scale;
	image_position += _image_size * 0.5
	
	#invert y coordinates to fix bug, but there might be a deeper issue still somewhere
	image_position.y = _image_size.y - image_position.y
	
	return image_position


func _update_whiteboard_geometry():
	if !_is_ready:
		return

	# Set the viewport size
	_viewport.size = _image_size
	_viewport.clear(_initial_color)

	# Update the box shape
	var shape := _collision.shape as BoxShape3D
	if shape:
		shape.extents = Vector3(
				_image_size.x * _image_scale * 0.5,
				_image_size.y * _image_scale * 0.5,
				0.001)

	# Update the mesh shape
	var mesh := _mesh.mesh as QuadMesh
	if mesh:
		mesh.size = _image_size * _image_scale


func _set_image_size(value: Vector2):
	_image_size = value
	_update_whiteboard_geometry()


func _get_image_size() -> Vector2:
	return _image_size


func _set_image_scale(value: float):
	_image_scale = value
	_update_whiteboard_geometry()

func _get_image_scale() -> float:
	return _image_scale


func _set_initial_color(value: Color):
	_initial_color = value
	_update_whiteboard_geometry()


func _get_initial_color() -> Color:
	return _initial_color
