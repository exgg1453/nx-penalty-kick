extends Node2D

@onready var shape: Polygon2D = $Shape

var resting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	resting_position = position
	_build_circle(14.0)

func _build_circle(radius: float) -> void:
	var points: PackedVector2Array = PackedVector2Array()
	var segment_count: int = 20
	for index in range(segment_count):
		var angle: float = TAU * float(index) / float(segment_count)
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	shape.polygon = points

func shoot(target_position: Vector2, duration: float) -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", target_position, duration)
	tween.parallel().tween_property(self, "scale", Vector2(0.6, 0.6), duration)

func reset_position(duration: float = 0.4) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", resting_position, duration)
	tween.parallel().tween_property(self, "scale", Vector2(1.0, 1.0), duration)
