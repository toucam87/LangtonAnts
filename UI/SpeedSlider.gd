extends HSlider


func _ready() -> void:
	call_deferred("signal_value_changed")
	

func signal_value_changed():
	value_changed.emit(value)

