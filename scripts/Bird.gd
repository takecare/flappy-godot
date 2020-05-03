extends RigidBody2D

export (float) var GRAVITY_SCALE = 5
export (float) var JUMP_Y_VELOCITY = -150
const ANGULAR_VELOCITY = 1.5

# used for debugging:
var customPositionWasSet = false
var customPosition = Vector2(0,0)

# these are used to control the bird's rotation
const MAX_ROTATION_DEG = 30
var previousYVelocity = -1
var resetToMaxUpwardsRotation = false
var resetToMaxDownwardsRotation = false

func _ready():
  gravity_scale = GRAVITY_SCALE

func isFalling():
  return linear_velocity.y > 0

func justStartedFalling():
  return previousYVelocity < 0 and linear_velocity.y >= 0

# warning-ignore:unused_argument
func _physics_process(delta):
  if justStartedFalling():
    angular_velocity = ANGULAR_VELOCITY

  if rotation_degrees < -MAX_ROTATION_DEG:
    resetToMaxUpwardsRotation = true
    angular_velocity = 0
  elif rotation_degrees > MAX_ROTATION_DEG:
    resetToMaxDownwardsRotation = true
    angular_velocity = 0

  previousYVelocity = linear_velocity.y

func _unhandled_input(event):
  if event is InputEventKey and event.is_pressed() and not event.is_echo():
    match event.scancode:
      KEY_R:
        angular_velocity = -3
      KEY_E:
        angular_velocity = 3
      KEY_S:
        gravity_scale = 0
        rotation_degrees = 0
        set_linear_velocity(Vector2(0, 0))
      KEY_RIGHT:
        moveRight()
      KEY_DOWN:
        customPosition = Vector2(position.x, position.y + 5)
        customPositionWasSet = true

  if event.is_action_pressed("jump"):
    jump()

func moveRight():
  var pos = Vector2(position.x + 5, position.y)
  if forcesBeingApplied():
    customPosition = pos
    customPositionWasSet = true
  else:
    position = pos

func jump():
  set_linear_velocity(Vector2(get_linear_velocity().x, JUMP_Y_VELOCITY))
  angular_velocity = -ANGULAR_VELOCITY

func _integrate_forces(state):
  if resetToMaxUpwardsRotation:
    rotateBy(state, -MAX_ROTATION_DEG)
    resetToMaxUpwardsRotation = false
  elif resetToMaxDownwardsRotation:
    rotateBy(state, MAX_ROTATION_DEG)
    resetToMaxDownwardsRotation = false
  if customPositionWasSet:
    var transform = state.get_transform()
    transform.origin.x = customPosition.x
    transform.origin.y = customPosition.y
    state.set_transform(transform)
    customPositionWasSet = false

func rotateBy(state, degrees):
  state.set_transform(Transform2D(deg2rad(degrees), state.get_transform().get_origin()))

# we're looking at velocity here as a proxy to forces being applied to the body,
# the reasoning is, with our setup, if there are forces applied to this body,
# they will affect its velocity. furthermore, _integrate_forces() doesn't seem
# to be called if no forces are being applied to this body
func forcesBeingApplied():
  var velocity = linear_velocity.abs()
  return velocity.x > 0 or velocity.y > 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
