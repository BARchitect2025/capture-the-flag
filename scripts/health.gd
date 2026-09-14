extends TextureProgressBar


@onready var rigid_body = get_parent()

func _process(delta: float) -> void:
	if rigid_body:
		global_position = rigid_body.global_position + Vector2(-4, -6)
