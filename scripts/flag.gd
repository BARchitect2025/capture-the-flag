extends AnimatedSprite2D


@export var flag_type = 0


func _ready() -> void:
	frame = flag_type


func _process(delta: float) -> void:
	var dist = global_position.distance_to(get_parent().get_parent().get_child(5).get_child(0).global_position)
	
	if Input.is_action_just_pressed("pickup_flag") && dist < 8:
		queue_free()
