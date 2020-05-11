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

func set_current_state(state: int) -> void:
  currentState.exit()
  match state:
    State.IDLE:
      currentState = IdleState.new(pipeScene, self)
    State.SPAWNING:
      currentState = IdleState.new(pipeScene, self)
    State.PLAYING:
      currentState = IdleState.new(pipeScene, self)

# base state
class PipeSpawnerState:
  var pipeScene: PackedScene
  var pipeSpawner: PipeSpawner

  func _init(scene: PackedScene, spawner: PipeSpawner) -> void:
    pipeScene = scene
    pipeSpawner = spawner
    pass

  func spawnNextPipe():
    moveToNextPosition()
    spawnPipe()

  func moveToNextPosition():
    pass
  
  func spawnPipe():
    pass

  func exit():
    pass

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
    newPipes.connect("pipeFreed", self, "spawnNextPipe")
    pipeSpawner.container.add_child(newPipes)

  func moveToNextPosition() -> void:
    pipeSpawner.position.x = pipeSpawner.position.x + xDistance
    pipeSpawner.position.y = yDistance

# spawns pipes randomly within the limits set
class PlayingState extends PipeSpawnerState:
  var initialPipes: int
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
