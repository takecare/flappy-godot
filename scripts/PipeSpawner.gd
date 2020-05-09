extends Node2D

export(NodePath) var cameraPath = null
export(NodePath) var containerPath = null
export(Resource) var pipeScene = preload("res://scenes/Pipes.tscn")

onready var container: Node = get_node(containerPath) if containerPath != null else get_node("Container")
onready var camera: Camera2D = get_node(cameraPath) if cameraPath != null else Utils.get_main_camera()
onready var yBaseline: int = Utils.get_screen_size().y / 2

export(int) var initialPipes = 3
export(int) var hMinDistance = 50
export var hOffsetVariation = [0, 5, 10, 15, 20, 25, 30, 35, 40]
export var vOffsetVariation = [0, 10, 20, -20, -10]
export var openings = [45, 50, 55, 60]

func _ready() -> void:
  randomize()
  for _i in range(initialPipes):
    spawnNextPipe()

func spawnNextPipe():
  moveToNextPosition()
  spawnPipe()

func spawnPipe() -> void:
  var newPipes = pipeScene.instance()
  newPipes.init(position, camera)
  newPipes.connect("pipeFreed", self, "spawnNextPipe")
  newPipes.set_opening(openings[randi() % openings.size()])
  container.add_child(newPipes)
  pass

func moveToNextPosition() -> void:
  var hVariation = hOffsetVariation[randi() % hOffsetVariation.size()]
  var yVariation = vOffsetVariation[randi() % vOffsetVariation.size()]
  position.x = position.x + hMinDistance + hVariation
  position.y = yBaseline + yVariation
