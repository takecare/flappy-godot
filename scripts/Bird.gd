extends RigidBody2D

class_name Bird, "res://sprites/bird_orange_0.png"

enum State { FLYING, JUMPING, HIT, GROUND }
signal bird_flying
signal bird_jumping
signal bird_hit
signal bird_grounded

export(float) var GRAVITY_SCALE: float = 5
export(float) var JUMP_Y_VELOCITY: float = -150
export(float) var HORIZONTAL_VELOCITY: float = 50
export(float) var ANGULAR_VELOCITY: float = 5
export(NodePath) var animationPlayerPath = null
export(NodePath) var animatedSpritePath = null
export(NodePath) var collisionShapePath = null

onready var animatedSprite: AnimatedSprite = get_node(animatedSpritePath) if animatedSpritePath != null else get_node("AnimatedSprite")
onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("AnimationPlayer")
onready var collisionShape: CollisionShape2D = get_node(collisionShapePath) if collisionShapePath != null else get_node("CollisionShape")
onready var currentState: BirdState = FlyingState.new(self, HORIZONTAL_VELOCITY)

func _ready() -> void:
  add_to_group(Game.birdGroup)
  var _result = connect("body_entered", self, "_on_body_entered")
  contact_monitor = true
  contacts_reported = 1

func _physics_process(delta: float):
  currentState.update(delta)

func _unhandled_input(event: InputEvent):
  currentState.handleInput(event)

func _integrate_forces(state):
  currentState.updateForces(state)

func _on_body_entered(body: Node):
  currentState.bodyEntered(body)

func set_state(state: int):
  currentState.exit()
  match state:
    State.FLYING:
      currentState = FlyingState.new(self, HORIZONTAL_VELOCITY)
      emit_signal("bird_flying")
    State.JUMPING:
      currentState = JumpingState.new(self, GRAVITY_SCALE, HORIZONTAL_VELOCITY, ANGULAR_VELOCITY, JUMP_Y_VELOCITY)
      emit_signal("bird_jumping")
    State.HIT:
      currentState = HitState.new(self, GRAVITY_SCALE, HORIZONTAL_VELOCITY/2)
      emit_signal("bird_hit")
    State.GROUND:
      currentState = GroundState.new(self, GRAVITY_SCALE)
      emit_signal("bird_grounded")

func isFlying() -> bool:
  return currentState is JumpingState or currentState is FlyingState

# base state
class BirdState:
  # used for debugging:
  var customPositionWasSet: bool = false
  var customPosition: Vector2 = Vector2(0,0)
  var bird: Bird = null

  func _init(brd: Bird = null, gravityScale: float = 0, linearVelocity: float = 0) -> void:
    bird = brd
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

  func bodyEntered(_body: Node) -> void:
    pass

  func exit() -> void:
    bird.animationPlayer.stop()
    bird.animatedSprite.position = Vector2(0, 0)

# bird is flying across the scene, no input expected
class FlyingState extends BirdState: # should this be FallingState?
  # we're forced by gdscript to have a default value of null
  # -> what if we remove this ctor and just have the parent one?
  func _init(bird, linearVelocity: float = 0).(bird, 0, linearVelocity) -> void:
    bird.animationPlayer.play("Flying")

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
    jump()

  func update(_delta: float) -> void:
    applyAngularVelocityWhenFalling()
    ensureRotationLimits()
    previousYVelocity = bird.linear_velocity.y

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

  func bodyEntered(body: Node):
    if body.is_in_group(Game.pipeGroup):
      bird.set_state(bird.State.HIT)
    elif body.is_in_group(Game.groundGroup):
      bird.set_state(bird.State.GROUND)

# bird hits pipes
class HitState extends BirdState:
  func _init(bird: Bird = null, gravityScale: float = 0, linearVelocity: float = 0).(bird, gravityScale, linearVelocity) -> void:
    bird.angular_velocity = 2
    bird.collisionShape.scale = Vector2(0.5, 0.5)
    bird.add_collision_exception_with(bird.get_colliding_bodies()[0])

  func bodyEntered(body: Node):
    if body.is_in_group(Game.pipeGroup):
      bird.set_state(bird.State.HIT)
    elif body.is_in_group(Game.groundGroup):
      bird.set_state(bird.State.GROUND)

# bird hits ground
class GroundState extends BirdState:
  func _init(bird: Bird = null, gravityScale: float = 0).(bird, gravityScale) -> void:
    # we change the scale to not make it obvious that the collision shape is
    # actually a bit higher than the sprite - cheeky
    bird.collisionShape.scale = Vector2(0.8, 0.5)
    bird.linear_velocity = Vector2(0, 0)
