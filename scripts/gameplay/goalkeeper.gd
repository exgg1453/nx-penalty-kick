extends Node2D

@onready var body: ColorRect = $Body

var resting_position_x: float = 0.0

func _ready() -> void:
	resting_position_x = position.x

func set_kit_color(kit_color: Color) -> void:
	body.color = kit_color

func dive_to(target_x: float, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:x", target_x, duration)

func reset_position(duration: float = 0.4) -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:x", resting_position_x, duration)
