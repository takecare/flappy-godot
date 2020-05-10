extends RigidBody2D

export(float) var GRAVITY_SCALE: float = 5
export(float) var JUMP_Y_VELOCITY: float = -150
export(float) var HORIZONTAL_VELOCITY: float = 50
export(float) var ANGULAR_VELOCITY: float = 5

class_name Bird, "res://sprites/bird_orange_0.png"

onready var currentState: BirdState = JumpingState.new(self, ANGULAR_VELOCITY, JUMP_Y_VELOCITY)

func _ready() -> void:
  gravity_scale = GRAVITY_SCALE
  linear_velocity = Vector2(HORIZONTAL_VELOCITY, linear_velocity.y)

func _physics_process(delta: float):
  currentState.update(delta)

func _unhandled_input(event: InputEvent):
  currentState.handleInput(event)

func _integrate_forces(state):
  currentState.updateForces(state)



class BirdState:
  # used for debugging:
  var customPositionWasSet: bool = false
  var customPosition: Vector2 = Vector2(0,0)

  var bird: Bird = null
  func _init(b: Bird) -> void:
    bird = b

  func update(_delta: float) -> void:
    pass

  func updateForces(state: Physics2DDirectBodyState) -> void:
    if customPositionWasSet:
      var transform = state.get_transform()
      transform.origin.x = customPosition.x
      transform.origin.y = customPosition.y
      state.set_transform(transform)
      customPositionWasSet = false

  func moveRight() -> void:
    var pos = Vector2(bird.position.x + 5, bird.position.y)
    if forcesBeingApplied():
      customPosition = pos
      customPositionWasSet = true
    else:
      bird.position = pos

  # we're looking at velocity here as a proxy to forces being applied to the body,
  # the reasoning is, with our setup, if there are forces applied to this body,
  # they will affect its velocity. furthermore, _integrate_forces() doesn't seem
  # to be called if no forces are being applied to this body, we can't rely on it
  func forcesBeingApplied() -> bool:
    var velocity = bird.linear_velocity.abs()
    return velocity.x > 0 or velocity.y > 0

  func handleInput(event: InputEvent) -> void:
    if event is InputEventKey and event.is_pressed() and not event.is_echo():
      match event.scancode:
        KEY_R:
          bird.angular_velocity = -3
        KEY_E:
          bird.angular_velocity = 3
        KEY_S:
          bird.gravity_scale = 0
          bird.rotation_degrees = 0
          bird.set_linear_velocity(Vector2(0, 0))
        KEY_RIGHT:
          moveRight()
        KEY_DOWN:
          customPosition = Vector2(bird.position.x, bird.position.y + 5)
          customPositionWasSet = true

  func isFalling() -> bool:
    return bird.linear_velocity.y > 0

  func exit() -> void:
    pass




class FlyingState extends BirdState: # should this be FallingState?
  # we're forced by gdscript to have a default value of null
  # -> what if we remove this ctor and just have the parent one?
  func _init(bird: Bird = null).(bird) -> void:
    pass

  func update(delta: float) -> void:
    pass

  func updateForces(state: Physics2DDirectBodyState) -> void:
    pass

  func handleInput(event: InputEvent) -> void:
    pass

  func exit() -> void:
    pass



class JumpingState extends BirdState:
  # these are used to control the bird's rotation
  const MAX_ROTATION_DEG: int = 30
  var previousYVelocity: float = -1
  var resetToMaxUpwardsRotation: bool = false
  var resetToMaxDownwardsRotation: bool = false

  var angularVelocity: float
  var jumpVelocity: float

  # we cannot define the type of 'bird' otherwise we won't be able to instantiate this state
  func _init(bird = null, angVel: float = 0, jumpVel: float = 0).(bird) -> void:
    angularVelocity = angVel
    jumpVelocity = jumpVel

  func update(_delta: float) -> void:
    applyAngularVelocityWhenFalling()
    ensureRotationLimits()
    previousYVelocity = bird.linear_velocity.y
    pass

  func ensureRotationLimits() -> void:
    if bird.rotation_degrees < -MAX_ROTATION_DEG:
      resetToMaxUpwardsRotation = true
      bird.angular_velocity = 0
    elif bird.rotation_degrees > MAX_ROTATION_DEG:
      resetToMaxDownwardsRotation = true
      bird.angular_velocity = 0

  func applyAngularVelocityWhenFalling() -> void:
    if justStartedFalling():
      bird.angular_velocity = angularVelocity / 2

  func justStartedFalling() -> bool:
    return previousYVelocity < 0 and bird.linear_velocity.y >= 0

  func updateForces(state: Physics2DDirectBodyState) -> void:
    if resetToMaxUpwardsRotation:
      rotateBy(state, -MAX_ROTATION_DEG)
      resetToMaxUpwardsRotation = false
    elif resetToMaxDownwardsRotation:
      rotateBy(state, MAX_ROTATION_DEG)
      resetToMaxDownwardsRotation = false

  func rotateBy(state, degrees) -> void:
    state.set_transform(Transform2D(deg2rad(degrees), state.get_transform().get_origin()))

  func handleInput(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
      jump()

  func jump() -> void:
    bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x, jumpVelocity))
    bird.angular_velocity = -angularVelocity

  func exit() -> void:
    pass



class HitState:
  func _init() -> void:
    pass

  func update(delta: float) -> void:
    pass

  func updateForces(state: Physics2DDirectBodyState) -> void:
    pass

  func handleInput(event: InputEvent) -> void:
    pass

  func exit() -> void:
    pass
