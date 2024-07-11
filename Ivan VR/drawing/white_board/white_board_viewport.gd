class_name WhiteBoardViewport
extends SubViewport


# Sprite step-size for erasing
const ERASE_STEP_SIZE := 30.0

# Sprite step-size for marking
const MARK_STEP_SIZE := 4.0


@onready var _clear : ColorRect = $Clear
@onready var _line : Line2D = $Line
@onready var _erase : ColorRect = $Erase
@onready var _erase_material : ShaderMaterial = $Erase.material


func clear(color: Color):
	_clear.color = color
	_clear.position = Vector2.ZERO
	_clear.size = size
	
	_clear.visible = true
	_line.visible = false
	_erase.visible = false

	render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
	render_target_update_mode = SubViewport.UPDATE_ONCE


func mark(from: Vector2, to: Vector2, color: Color, radius: float):
	var dir := (to - from).normalized()
	var head := dir * radius
	_line.width = radius * 2
	_line.points = PackedVector2Array([ from - head, to + head ])
	_line.default_color = color
	
	_clear.visible = false
	_line.visible = true
	_erase.visible = false
	render_target_update_mode = SubViewport.UPDATE_ONCE


func erase(_from: Vector2, to: Vector2, color: Color, radius: float):
	_erase.color = color
	_erase.position = to - Vector2(radius, radius)
	_erase.size = Vector2(radius*2, radius*2)
	
	_clear.visible = false
	_line.visible = false
	_erase.visible = true
	render_target_update_mode = SubViewport.UPDATE_ONCE
