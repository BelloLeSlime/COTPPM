extends CanvasLayer

@onready var fade_rect: ColorRect = $ColorRect

func fade_in(duration: float = 0.5):
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
	await tween.finished

func fade_out(duration: float = 0.5):
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	await tween.finished
