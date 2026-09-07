extends Control

signal power_locked(power_value: float)

@export var oscillation_speed: float = 2.6

@onready var background: ColorRect = $Background
@onready var fill_rect: ColorRect = $Background/Fill

var is_enabled: bool = false
var current_power: float = 0.0
var oscillation_time: float = 0.0

func _ready() -> void:
	background.gui_input.connect(_on_background_gui_input)
	set_process(false)

func set_enabled(enabled: bool) -> void:
	is_enabled = enabled
	set_process(enabled)
	if enabled:
		oscillation_time = 0.0
		current_power = 0.0
		_update_fill()

func _process(delta: float) -> void:
	oscillation_time += delta * oscillation_speed
	current_power = (sin(oscillation_time) + 1.0) / 2.0
	_update_fill()

func _update_fill() -> void:
	fill_rect.size.y = background.size.y * current_power
	fill_rect.position.y = background.size.y - fill_rect.size.y

func _on_background_gui_input(event: InputEvent) -> void:
	if not is_enabled:
		return
	var pressed: bool = false
	if event is InputEventScreenTouch:
		pressed = event.pressed
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pressed = event.pressed
	if pressed:
		var locked_power: float = current_power
		set_enabled(false)
		power_locked.emit(locked_power)
