extends RigidBody2D

class_name Bird, "res://sprites/bird_orange_0.png"

export(float) var GRAVITY_SCALE: float = 5
export(float) var JUMP_Y_VELOCITY: float = -150
export(float) var HORIZONTAL_VELOCITY: float = 50
export(float) var ANGULAR_VELOCITY: float = 5
export(NodePath) var animationPlayerPath = null
export(NodePath) var animatedSpritePath = null

enum State { FLYING, JUMPING, HIT }

onready var animatedSprite: AnimationPlayer = get_node(animatedSpritePath) if animatedSpritePath != null else get_node("AnimatedSprite")
onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("AnimationPlayer")
onready var currentState: BirdState = FlyingState.new(self, HORIZONTAL_VELOCITY) #JumpingState.new(self, GRAVITY_SCALE, HORIZONTAL_VELOCITY, ANGULAR_VELOCITY, JUMP_Y_VELOCITY)

func _ready() -> void:
  pass

func _physics_process(delta: float):
  currentState.update(delta)

func _unhandled_input(event: InputEvent):
  currentState.handleInput(event)

func _integrate_forces(state):
  currentState.updateForces(state)

func set_state(state: int):
  currentState.exit()
  match state:
    State.FLYING:
      currentState = JumpingState.new(self, HORIZONTAL_VELOCITY)
    State.JUMPING:
      currentState = JumpingState.new(self, GRAVITY_SCALE, HORIZONTAL_VELOCITY, ANGULAR_VELOCITY, JUMP_Y_VELOCITY)
    State.HIT:
      currentState = HitState.new(self)

# base state
class BirdState:
  # used for debugging:
  var customPositionWasSet: bool = false
  var customPosition: Vector2 = Vector2(0,0)
  var bird: Bird = null

  func _init(b: Bird = null, gravityScale: float = 0, linearVelocity: float = 0) -> void:
    bird = b
    bird.gravity_scale = gravityScale
    bird.linear_velocity = Vector2(linearVelocity, bird.linear_velocity.y)

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
    bird.animationPlayer.stop()
    bird.animatedSprite.position = Vector2(0, 0)
    pass

# bird is flying across the scene, no input expected
class FlyingState extends BirdState: # should this be FallingState?
  # we're forced by gdscript to have a default value of null
  # -> what if we remove this ctor and just have the parent one?
  func _init(bird, linearVelocity: float = 0).(bird, 0, linearVelocity) -> void:
    bird.animationPlayer.play("Flying")

  func exit() -> void: 
    .exit()

# in-play state
class JumpingState extends BirdState:
  # these are used to control the bird's rotation
  const MAX_ROTATION_DEG: int = 30
  var previousYVelocity: float = -1
  var resetToMaxUpwardsRotation: bool = false
  var resetToMaxDownwardsRotation: bool = false

  var angularVelocity: float
  var jumpVelocity: float

  # we cannot define the type of 'bird' otherwise we won't be able to instantiate this state
  func _init(
    bird = null,
    gravityScale: float = 0,
    linearVelocity: float = 0,
    angVel: float = 0,
    jumpVel: float = 0
  ).(bird, gravityScale, linearVelocity) -> void:
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
    bird.linear_velocity = Vector2(bird.get_linear_velocity().x, jumpVelocity)
    bird.angular_velocity = -angularVelocity
    bird.animationPlayer.play("Flap")

# bird hits pipes/ground
class HitState extends BirdState:
  func _init(bird: Bird = null).(bird) -> void:
    pass

  func update(delta: float) -> void:
    pass

  func updateForces(state: Physics2DDirectBodyState) -> void:
    pass

  func handleInput(event: InputEvent) -> void:
    pass

  func exit() -> void:
    .exit()
    pass
