extends CharacterBody3D

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var slide_val = 0.0
var jump_val = 0.0

enum {SPRINT, SLIDE, JUMP}
var current_animation = SPRINT

@export var blend_speed = 20

const LEFT = -3
const MIDDLE = 0
const RIGHT = 3
var positions = [LEFT, MIDDLE, RIGHT]

var curPos = 1

const JUMP_VEL = 7.0
var gravity = 11

var slide_timer = 0.0
const SLIDE_DURATION = 0.8

func _physics_process(delta: float) -> void:
	if not is_inside_tree():
		return
		
	handle_inputs()
	
	if current_animation == SLIDE:
		slide_timer -= delta
		if slide_timer <= 0.0 and is_on_floor():
			current_animation = SPRINT

	handle_animations(delta)
	update_tree()

	var target_z = positions[curPos]
	velocity.z = (target_z - position.z) * 20.0

	if not is_on_floor():
		velocity.y -= gravity * delta
		if velocity.y > 0:
			current_animation = JUMP
	else:
		if current_animation == JUMP:
			current_animation = SPRINT
		
	move_and_slide()

func handle_inputs():
	if Input.is_action_just_pressed("move_right"):
		if curPos < 2:
			curPos += 1
	elif Input.is_action_just_pressed("move_left"):
		if curPos > 0:
			curPos -= 1
			
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VEL
		current_animation = JUMP
		
	if Input.is_action_just_pressed("slide"):
		if is_on_floor() and current_animation == SPRINT:
			start_slide()
		elif not is_on_floor():
			velocity.y = gravity * -3
			start_slide()

func start_slide():
	current_animation = SLIDE
	slide_timer = SLIDE_DURATION

func handle_animations(delta):
	match current_animation:
		SPRINT:
			slide_val = lerpf(slide_val, 0.0, blend_speed * delta)
			jump_val = lerpf(jump_val, 0.0, blend_speed * delta)
		SLIDE:
			slide_val = lerpf(slide_val, 1.0, blend_speed * delta)
			jump_val = lerpf(jump_val, 0.0, blend_speed * delta)
		JUMP:
			jump_val = lerpf(jump_val, 1.0, blend_speed * delta)
			slide_val = lerpf(slide_val, 0.0, blend_speed * delta)

func update_tree():
	anim_tree["parameters/Slide/blend_amount"] = slide_val
	anim_tree["parameters/Jump/blend_amount"] = jump_val

func _reload_scene():
	get_tree().reload_current_scene()

func _on_area_3d_body_entered(_body: Node3D) -> void:
	call_deferred("_reload_scene")
