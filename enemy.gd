extends RigidBody2D

var currentDir = -1
@onready var speed = 200
@onready var speed_max = 80

@onready var sprites = $sprites
@onready var rayright = $rayright
@onready var rayleft = $rayleft



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if abs(linear_velocity.x) < speed_max:
		apply_central_force(Vector2(currentDir,0) * speed)
	if rayleft.is_colliding():
		currentDir = 1
		$Node2D.scale.x = -1
	if rayright.is_colliding():
		currentDir = -1
		$Node2D.scale.x = 1


func _on_dam_area_body_entered(body):
	if body.name == "Player":
		body.health -= 1
		await get_tree().create_timer(5.0).timeout
