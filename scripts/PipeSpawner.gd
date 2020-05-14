extends Node2D

class_name PipeSpawner

export(NodePath) var cameraPath = null
export(NodePath) var containerPath = null
export(Resource) var pipeScene = preload("res://scenes/Pipes.tscn")

export(int) var initialPipes = 3
export(int) var hMinDistance = 60
export var hOffsetVariation = [0, 5, 10, 15, 20, 25, 30, 35, 40]
export var vOffsetVariation = [0, 10, 20, -20, -10]
export var openings = [50, 55, 60, 65]

onready var container: Node = get_node(containerPath) if containerPath != null else get_node("Container")
onready var camera: Camera2D = get_node(cameraPath) if cameraPath != null else Utils.get_main_camera()
onready var yBaseline: int = Utils.get_screen_size().y / 2

onready var currentState: PipeSpawnerState = SpawningState.new(pipeScene, self, 121, 121)

enum State { IDLE, SPAWNING, PLAYING }

func _ready() -> void:
  randomize()
  for _i in range(initialPipes):
    spawnNextPipe()

func spawnNextPipe() -> void:
  currentState.spawnNextPipe()

func set_state(state: int) -> void:
  currentState.exit()
  match state:
    State.IDLE:
      currentState = IdleState.new(pipeScene, self)
    State.SPAWNING:
      currentState = SpawningState.new(pipeScene, self, 121, 121)
    State.PLAYING:
      currentState = PlayingState.new(pipeScene, self, hMinDistance, hOffsetVariation, vOffsetVariation, yBaseline, openings)

# base state
class PipeSpawnerState:
  var pipeScene: PackedScene
  var pipeSpawner: PipeSpawner

  func _init(scene: PackedScene, spawner: PipeSpawner) -> void:
    pipeScene = scene
    pipeSpawner = spawner

  func spawnNextPipe():
    print("spawnNextPipe()")
    moveToNextPosition()
    spawnPipe()

  func moveToNextPosition():
    print("base moveToNextPosition")

  func spawnPipe():
    print("base spawnPipe")

  func exit():
    print("base exit")

# no pipes are spawned
class IdleState extends PipeSpawnerState:
  func _init(scene, spawner).(scene, spawner) -> void:
    pass

# spawns all pipes at a constant distance, position and with constant opening
class SpawningState extends PipeSpawnerState:
  const OPENING: float = 55.0
  var xDistance: float
  var yDistance: float

  func _init(
    scene,
    spawner,
    xDis: float,
    yDis: float
    ).(scene, spawner) -> void:
    xDistance = xDis
    yDistance = yDis

  func spawnPipe() -> void:
    var newPipes = pipeScene.instance()
    newPipes.init(pipeSpawner.position, pipeSpawner.camera)
    newPipes.set_opening(OPENING)

    # issue is here. when we change the state (e.g. from spawning to playing),
    # the pipes that are still in memory (i.e. the ones that have been spawned)
    # are connected to _this_ state (i.e. "spawning) that is no longer. this
    # means that when a pipe is freed the signal is delivered to a state that is
    # no longer active/no longer exists. one way to solve this is to add an
    # intermediate layer to which all signals are connected and to which all
    # states are connected too
    newPipes.connect("pipeFreed", self, "spawnNextPipe")

    pipeSpawner.container.add_child(newPipes)

  func moveToNextPosition() -> void:
    pipeSpawner.position.x = pipeSpawner.position.x + xDistance
    pipeSpawner.position.y = yDistance

# spawns pipes randomly within the limits set
class PlayingState extends PipeSpawnerState:
  var hMinDistance: float
  var hOffsetVariation: Array
  var vOffsetVariation: Array
  var yBaseline: float
  var openings: Array

  func _init(
    scene,
    spawner,
    hMinDis: float,
    hOffsetVar: Array,
    vOffsetVar: Array,
    yBase: float,
    opens: Array
    ).(scene, spawner) -> void:
    hMinDistance = hMinDis
    hOffsetVariation = hOffsetVar
    vOffsetVariation = vOffsetVar
    yBaseline = yBase
    openings = opens

  func spawnPipe() -> void:
    var newPipes = pipeScene.instance()
    newPipes.init(pipeSpawner.position, pipeSpawner.camera)
    newPipes.set_opening(openings[randi() % openings.size()])
    newPipes.connect("pipeFreed", self, "spawnNextPipe")
    pipeSpawner.container.add_child(newPipes)
    pass

  func moveToNextPosition() -> void:
    var hVariation = hOffsetVariation[randi() % hOffsetVariation.size()]
    var yVariation = vOffsetVariation[randi() % vOffsetVariation.size()]
    pipeSpawner.position.x = pipeSpawner.position.x + hMinDistance + hVariation
    pipeSpawner.position.y = yBaseline + yVariation
