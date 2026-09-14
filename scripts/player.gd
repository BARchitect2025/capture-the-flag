extends CharacterBody2D


enum Weapon {
	PISTOL,
	SHOTGUN,
	SUBMACHINEGUN,
	SNIPER
}


const SPEED = 1600.0


var player_color = 0
var shooting = false
var weapon: Weapon = Weapon.PISTOL


@onready var light = $PointLight2D

func _ready() -> void:
	$Sprite.frame = player_color
	if not is_multiplayer_authority():
		light.visible = false
	
	set_multiplayer_authority(name.to_int())


func _physics_process(delta: float) -> void:
	#if not is_multiplayer_authority():
		#return
	
	if Input.is_action_pressed("left"):
		velocity.x -= SPEED * delta
		
	if Input.is_action_pressed("right"):
		velocity.x += SPEED * delta
		
	if Input.is_action_pressed("up"):
		velocity.y -= SPEED * delta
		
	if Input.is_action_pressed("down"):
		velocity.y += SPEED * delta
		
	if Input.is_action_just_pressed("next_weapon"):
		match weapon:
			Weapon.PISTOL: weapon = Weapon.SHOTGUN
			Weapon.SHOTGUN: weapon = Weapon.SUBMACHINEGUN
			Weapon.SUBMACHINEGUN: weapon = Weapon.SNIPER
			Weapon.SNIPER: weapon = Weapon.PISTOL
		$Gun.frame = weapon
	
	if Input.is_action_just_pressed("last_weapon"):
		match weapon:
			Weapon.SNIPER: weapon = Weapon.SUBMACHINEGUN
			Weapon.SUBMACHINEGUN: weapon = Weapon.SHOTGUN
			Weapon.SHOTGUN: weapon = Weapon.PISTOL
			Weapon.PISTOL: weapon = Weapon.SNIPER
		$Gun.frame = weapon
	
	if weapon == Weapon.SUBMACHINEGUN:
		$Gun/Smoke.explosiveness = 0.0
	else:
		$Gun/Smoke.explosiveness = 1.0
		
	look_at(get_global_mouse_position())
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && !shooting:
		$Gun/Smoke.emitting = true
		
		if weapon == Weapon.PISTOL:
			var target = $RayCast2D.get_collider()
			if target && target is not TileMapLayer && target.has_method("damage"):
				target.damage(40, global_position)
			$Timer.start(0.4)
		if weapon == Weapon.SHOTGUN:
			var targets = []
				
			for i in range(10):
				$RayCast2D.target_position = Vector2(256.0, 0.0).rotated(randf_range(-40.0, 40.0) * (PI / 180))
				$RayCast2D.force_raycast_update()
				targets.append($RayCast2D.get_collider())
				
			$RayCast2D.target_position = Vector2(256.0, 0.0)
				
			for target in targets:
				if target && target is not TileMapLayer && target.has_method("damage"):
					target.damage(20, global_position)
			$Timer.start(1.0)
		if weapon == Weapon.SUBMACHINEGUN:
			var target = $RayCast2D.get_collider()
			if target && target is not TileMapLayer && target.has_method("damage"):
				target.damage(10, global_position)
			$Timer.start(0.05)
		if weapon == Weapon.SNIPER:
			var target = $RayCast2D.get_collider()
			if target && target is not TileMapLayer && target.has_method("damage"):
				target.damage(100, global_position)
			$Timer.start(1.5)
		
		shooting = true
	
	#velocity = velocity.rotated(global_rotation + (PI / 2.0))

	move_and_slide()
	
	velocity = Vector2(0, 0)


func _on_timer_timeout() -> void:
	shooting = false
