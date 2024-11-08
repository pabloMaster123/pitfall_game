extends CharacterBody2D

var SPEED = 30
var player_chase = false
var player = null

var health = 400
var player_inattack_zone = false

var attack_ip = false


func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/SPEED
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("default")
		


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy(delta):
	pass

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true# Replace with function body.

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false # Replace with function body.

func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		health -= 20
		print("enemy health -" , health)
		if health <= 0:
			self.queue_free()
		
		
