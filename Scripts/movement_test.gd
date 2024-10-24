extends CharacterBody2D


const SPEED = 200.0
const SPEED2 = 141.42
const JUMP_VELOCITY = -400.0

@onready var body: AnimatedSprite2D = $AnimatedSprite2D
@onready var dashTimer: Timer = $Timer

var dasheable = true

func _physics_process(delta):

	var updown = Input.get_axis("down", "up")
	var lefright = Input.get_axis("left", "rigth")
	var speed = 0
	
	if lefright and updown:
		speed = SPEED2
	else:
		speed = SPEED
		
	var dash = Input.is_action_just_pressed("dash")
	
	if dash and dasheable:
		speed = speed * 100
		dasheable = false
		dashTimer.start(6.0)
	
	if lefright:
		velocity.x = lefright * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if updown:
		velocity.y = -updown * speed
	else:
		velocity.y = move_toward(velocity.x, 0, speed)
	
	if body != null:
		if lefright > 0:
			if updown > 0:
				rotation = TAU * (-45.0/360.0)
			elif updown < 0:
				rotation = TAU * (45.0/360.0)
			else:
				rotation = 0
		elif lefright < 0:
			if updown > 0:
				rotation = TAU * (-135.0/360.0)
			elif updown < 0:
				rotation = TAU * (135.0/360.0)
			else:
				rotation = TAU * (180.0/360.0)
		elif updown > 0:
			rotation = TAU * (-90.0/360.0)
		elif updown < 0:
			rotation = TAU * (90.0/360.0)
	
	move_and_slide()


func _on_dash_timer_timeout():
	if dasheable == false:
		dasheable =  true
		print("dasheable")
