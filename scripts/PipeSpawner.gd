extends Node2D

export(NodePath) var cameraPath = null
export(NodePath) var containerPath = null
export(Resource) var pipeScene = preload("res://scenes/Pipes.tscn")

onready var container: Node = get_node(containerPath) if containerPath != null else get_node("Container")

func _ready() -> void:
  spawnPipe()
  pass

func _process(_delta: float) -> void:
  pass

func spawnPipe() -> void:
  var newPipes = pipeScene.instance()
  newPipes.position = position
  container.add_child(newPipes)
  pass

func moveToNextSpawnPoint() -> void:
  pass
