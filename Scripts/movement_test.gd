extends CharacterBody2D

var enemy_in_range = true
var enemy_in_attack_range = false
var enemy_cooldown = true

@onready var attack_cooldown: Timer = $attack_cooldown

var health = 200
var is_alive = true

const SPEED = 400.0
const ACCELERATION = 1500
const FRICTION = 1000

var current_direction = Vector2.ZERO
var current_animation = ""



func player_movement(input, delta):
	if input: velocity = velocity.move_toward(input * SPEED , delta * ACCELERATION)
	else: velocity = velocity.move_toward(Vector2(0,0), delta * FRICTION)

func _physics_process(delta):
	var input = Input.get_vector("left","rigth","up","down")
	player_movement(input, delta)
	play_direction_anim(input, delta)
	move_and_slide()
	enemy_attack(delta)
	
	if health <= 0:
		is_alive = false
		health = 0
		print("The Hero is death")
		self.queue_free()

func play_direction_anim(input, delta):
	var anim = $AnimatedSprite2D

	var new_animation = ""

	if input.x != 0 or input.y != 0:
		current_direction = input

	if current_direction.x > 0 and velocity.length() > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
	elif current_direction.x < 0 and velocity.length() > 0:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		current_animation = "run"
	elif current_direction.y > 0 and velocity.length() > 0:
		$AnimatedSprite2D.play("down_runing")
		current_animation = "down_runing"
	elif current_direction.y < 0 and velocity.length() > 0:
		$AnimatedSprite2D.play("up_runing")
		current_animation = "up_runing"

	else:
		if current_animation.ends_with("run") and velocity.length() == 0:
			$AnimatedSprite2D.play("default")
		elif current_animation.ends_with("down_runing") and velocity.length() == 0:
			$AnimatedSprite2D.play("down")
		elif current_animation.ends_with("up_runing") and velocity.length() == 0:
			$AnimatedSprite2D.play("up")

func  player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false # Replace with function body.

func enemy_attack(delta):
	if enemy_in_attack_range and enemy_cooldown == true:
		health -= 20
		enemy_cooldown = false
		attack_cooldown.start()
		print(health)
	
func _on_attack_cooldown_timeout() -> void:
	enemy_cooldown = true # Replace with function body.
