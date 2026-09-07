extends Control

signal aim_locked(direction: Vector2)

@export var max_distance: float = 80.0
@export var activation_radius: float = 100.0

@onready var base: Control = $Base
@onready var knob: Control = $Base/Knob

var is_enabled: bool = true
var is_dragging: bool = false
var active_touch_index: int = -1
var current_direction: Vector2 = Vector2.ZERO

func set_enabled(enabled: bool) -> void:
	is_enabled = enabled
	visible = enabled
	if not enabled and is_dragging:
		_release_joystick()

func _input(event: InputEvent) -> void:
	if not is_enabled:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			if not is_dragging and base.get_global_rect().grow(activation_radius).has_point(event.position):
				is_dragging = true
				active_touch_index = event.index
				_update_knob(event.position)
		else:
			if is_dragging and event.index == active_touch_index:
				_release_joystick()
	elif event is InputEventScreenDrag:
		if is_dragging and event.index == active_touch_index:
			_update_knob(event.position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not is_dragging and base.get_global_rect().grow(activation_radius).has_point(event.position):
				is_dragging = true
				_update_knob(event.position)
		else:
			if is_dragging:
				_release_joystick()
	elif event is InputEventMouseMotion:
		if is_dragging:
			_update_knob(event.position)

func _update_knob(global_touch_position: Vector2) -> void:
	var center: Vector2 = base.get_global_rect().get_center()
	var offset: Vector2 = global_touch_position - center
	var clamped_offset: Vector2 = offset.limit_length(max_distance)
	knob.position = base.size / 2.0 + clamped_offset - knob.size / 2.0
	current_direction = clamped_offset / max_distance

func _release_joystick() -> void:
	is_dragging = false
	active_touch_index = -1
	var direction_to_send: Vector2 = current_direction
	knob.position = base.size / 2.0 - knob.size / 2.0
	current_direction = Vector2.ZERO
	if direction_to_send.length() > 0.15:
		aim_locked.emit(direction_to_send)
