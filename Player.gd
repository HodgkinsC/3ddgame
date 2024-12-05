extends RigidBody2D

var togdim = false
var canPick = true
var glitching = false
var stabbing = false

var health = 3

@onready var right_force = Vector2(600,0)
@onready var left_force = Vector2(-600,0)
@onready var jump_force = Vector2(0, -2500)
@onready var speed_max = 200

@onready var sprites = $sprites
@onready var rayright = $rayright
@onready var rayleft = $rayleft

var obj = 0

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	$Run.play()
	$Run.stream_paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if health == 3:
		$Heart1.frame = 0
		$Heart2.frame = 0
		$Heart3.frame = 0
	elif health == 2:
		$Heart1.frame = 0
		$Heart2.frame = 0
		$Heart3.frame = 1
	elif health == 1:
		$Heart1.frame = 0
		$Heart2.frame = 1
		$Heart3.frame = 1
	elif health <= 0:
		$Heart1.frame = 1
		$Heart2.frame = 1
		$Heart3.frame = 1

	if health <= 0:
		get_tree().reload_current_scene()
	
	if Input.is_action_pressed("right") and self.linear_velocity.x < speed_max:
		self.apply_impulse(right_force, Vector2(0,0))
		sprites.scale.x = 1
	if Input.is_action_pressed("left") and self.linear_velocity.x > -speed_max:
		self.apply_impulse(left_force, Vector2(0,0))
		sprites.scale.x = -1
	if Input.is_action_just_pressed("up") and (rayleft.is_colliding() or rayright.is_colliding()):
		self.apply_impulse(jump_force, Vector2(0,0))
	
	
	
	if linear_velocity.x != 0 and !glitching and !stabbing:
		$Run.stream_paused = false
		$AnimationPlayer.play("Run")
		$sprites/Idle.visible = false
		$sprites/Run.visible = true
	elif linear_velocity.x == 0 and !glitching and !stabbing:
		$Run.stream_paused = true
		$AnimationPlayer.play("Idle")
		$sprites/Idle.visible = true
		$sprites/Run.visible = false
	
	if Input.is_action_just_pressed("attack") and !glitching and !stabbing:
		stabbing = true
		$StabRadius/CollisionShape2D.disabled = false
		$sprites/Stab.visible = true
		$sprites/Idle.visible = false
		$sprites/Run.visible = false
		$AnimationPlayer.play("Stab")
		$StabAudio.play()
		await get_tree().create_timer(0.6).timeout
		$StabRadius/CollisionShape2D.disabled = true
		$sprites/Idle.visible = true
		$sprites/Stab.visible = false
		stabbing = false
	
	var bodies = $StabRadius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemies"):
			body.queue_free()
	
	if Input.is_action_just_pressed("switch") and !glitching and !stabbing:
		glitching = true
		togdim = !togdim
		if togdim == false:
			position = position + Vector2(0,1000)
		if togdim == true:
			position = position + Vector2(0,-1000)
		$sprites/Glitch.visible = true
		$sprites/Idle.visible = false
		$sprites/Run.visible = false
		$GlitchAudio.play()
		$AnimationPlayer.play("Tele")
		await get_tree().create_timer(0.2).timeout
		$sprites/Idle. visible = true
		$sprites/Glitch.visible = false
		glitching = false

