extends RayCast2D

var distance = 99999

func _physics_process(delta):
	var collider = get_collider()
	if collider is Node:
		if collider.is_in_group("Walls"):
			var origin = global_transform.origin
			var collision_point = get_collision_point()
			distance = origin.distance_to(collision_point)
		else:
			distance = 99999
	else:
		distance = 99999
