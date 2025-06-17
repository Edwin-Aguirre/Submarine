extends TextureProgressBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	value = Global.oxygen_level
