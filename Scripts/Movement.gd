extends KinematicBody2D

var acceleration = 5
var max_speed = 500
var friction = 0.1
var rotation_speed = 2

var speed_input = 0
var direction = 0
var velocity = Vector2.ZERO
var vellen = 1

func get_input():
	direction = 0
	speed_input = 0
	if Input.is_action_pressed("W"):
		speed_input += 1
	if Input.is_action_pressed("A"):
		direction -= rotation_speed
	if Input.is_action_pressed("S"):
		speed_input -= 1
	if Input.is_action_pressed("D"):
		direction += rotation_speed

func _ready():
	var car = self
	KC.emit_signal("add_to_car_list", car)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	rotation += direction * rotation_speed * delta
	velocity += transform.x * speed_input * acceleration
	if speed_input == 0:
		velocity.x = lerp(velocity.x, 0, friction)
		velocity.y = lerp(velocity.y, 0, friction)
	vellen = sqrt(velocity.x*velocity.x + velocity.y*velocity.y)
	if vellen > max_speed:
		velocity.x = velocity.x * max_speed/vellen
		velocity.y = velocity.y * max_speed/vellen
	velocity = move_and_slide(velocity)


func _on_DetectorArea_area_entered(area):
	if area.get_name() == "Walls":
		queue_free()
