extends RigidBody2D


var health = 200
var max_health = 200
var dying = false


func _ready() -> void:
	$Health.value = 100.0


func _process(delta: float) -> void:
	if dying: queue_free()

func damage(amount: int, attacker_pos: Vector2):
	if dying:
		return
	health -= amount
	
	if health <= 0:
		health = 0
		dying = true
		$Particles.emitting = true
		$Sprite.queue_free()
		$Timer.start(0.5)
	
	$Health.value = ((health * 100.0) / max_health)
	
	var push_dir = (global_position - attacker_pos).normalized()
	
	var total_impulse = push_dir * amount * 0.1
	
	apply_central_impulse(total_impulse)


func _on_timer_timeout() -> void:
	queue_free()
