extends RigidBody2D

export(float) var GRAVITY_SCALE: float = 5
export(float) var JUMP_Y_VELOCITY: float = -150
export(float) var HORIZONTAL_VELOCITY: float = 50
export(float) var ANGULAR_VELOCITY: float = 5

# used for debugging:
var customPositionWasSet: bool = false
var customPosition: Vector2 = Vector2(0,0)

# these are used to control the bird's rotation
const MAX_ROTATION_DEG: int = 30
var previousYVelocity: float = -1
var resetToMaxUpwardsRotation: bool = false
var resetToMaxDownwardsRotation: bool = false

func _ready() -> void:
  gravity_scale = GRAVITY_SCALE
  linear_velocity = Vector2(HORIZONTAL_VELOCITY, linear_velocity.y)

func _physics_process(_delta: float):
  applyAngularVelocityWhenFalling()
  ensureRotationLimits()
  previousYVelocity = linear_velocity.y

func applyAngularVelocityWhenFalling() -> void:
  if justStartedFalling():
    angular_velocity = ANGULAR_VELOCITY / 2

func justStartedFalling() -> bool:
    return previousYVelocity < 0 and linear_velocity.y >= 0

func ensureRotationLimits() -> void:
  if rotation_degrees < -MAX_ROTATION_DEG:
    resetToMaxUpwardsRotation = true
    angular_velocity = 0
  elif rotation_degrees > MAX_ROTATION_DEG:
    resetToMaxDownwardsRotation = true
    angular_velocity = 0

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

func moveRight() -> void:
  var pos = Vector2(position.x + 5, position.y)
  if forcesBeingApplied():
    customPosition = pos
    customPositionWasSet = true
  else:
    position = pos

# we're looking at velocity here as a proxy to forces being applied to the body,
# the reasoning is, with our setup, if there are forces applied to this body,
# they will affect its velocity. furthermore, _integrate_forces() doesn't seem
# to be called if no forces are being applied to this body
func forcesBeingApplied() -> bool:
  var velocity = linear_velocity.abs()
  return velocity.x > 0 or velocity.y > 0

func jump() -> void:
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

func rotateBy(state, degrees) -> void:
  state.set_transform(Transform2D(deg2rad(degrees), state.get_transform().get_origin()))

func isFalling() -> bool:
  return linear_velocity.y > 0
