class_name WhiteBoardEraser
extends XRToolsPickable


## Eraser draw-radius
@export var draw_radius := 0.03


# Private fields
var _is_drag := false
var _last_point := Vector2.ZERO

# Node references
@onready var _eraser_ray_cast: RayCast3D = $EraserRayCast


func _process(_delta: float):
	# Skip if not colliding
	if !_eraser_ray_cast.is_colliding():
		_is_drag = false
		return

	# Skip if not colliding a white-board
	var white_board := _eraser_ray_cast.get_collider() as WhiteBoard
	if !white_board:
		_is_drag = false
		return

	# Get the white-board point
	var collision_point := _eraser_ray_cast.get_collision_point()
	var image_point := white_board.to_image(collision_point)

	# If dragging, mark the white-board
	if _is_drag:
		white_board.erase(_last_point, image_point, draw_radius)

	# Update the marker data
	_is_drag = true
	_last_point = image_point


func pick_up(by):
	# Call base
	super.pick_up(by)

	# Turn on the ray-caster and enable process
	_eraser_ray_cast.enabled = true
	set_process(true)


func let_go(by: Node3D, p_linear_velocity = Vector3(), p_angular_velocity = Vector3()):
	# Call base
	super.let_go(by, p_linear_velocity, p_angular_velocity)

	# Turn off the ray-caster and disable processing
	_eraser_ray_cast.enabled = false
	set_process(false)
