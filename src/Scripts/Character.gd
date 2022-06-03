extends KinematicBody

export var gravity = 9.8
export var jump = 8
export var speed = 5
export var cameramode  = "TPS"
var acceleration = 8
export var mouse_sensitivity = 0.1
var capncrunch = Vector3()
var direction = Vector3()
var velocity = Vector3()

onready var pivot = $Pivot
onready var camera = $Pivot/Camera
onready var camcollider = $Pivot/CamCollider

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg2rad(-90),deg2rad(90))
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
func _process(_delta):
	if cameramode == "TPS":
		if camcollider.is_colliding():
			camera.global_transform.origin = camcollider.get_collision_point()
		else:
			camera.translation = camcollider.cast_to
	velocity = move_and_slide(velocity, Vector3.UP)
	velocity = velocity.linear_interpolate(direction * speed, acceleration * _delta)
	direction = direction.normalized()
	move_and_slide(capncrunch, Vector3.UP)
func _physics_process(_delta):
	direction = Vector3()
	
	if not is_on_floor():
		capncrunch.y -= gravity * _delta
	if Input.is_action_pressed("jump") and is_on_floor():
		capncrunch.y = jump
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_just_pressed("change_cam_mode"):
		if cameramode == "TPS":
			cameramode = "FPS"
		elif cameramode == "FPS":
			cameramode = "TPS"
	if cameramode == "TPS":
		camera.translation = Vector3(0, 0, 5)
	if cameramode == "FPS":
		camera.translation = Vector3(-0.993, 0, -1.066)


