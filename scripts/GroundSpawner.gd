extends Node2D

const groundScene = preload("res://scenes/Ground.tscn")
export(NodePath) var containerPath = null

var container: Node = null

func _ready() -> void:
  print(typeof(groundScene))
  position.y = Utils.get_size().y
  if containerPath == null:
    container = get_node("Container")
  else:
    container = get_node(containerPath)
  spawn()

func spawn():
  var newGround = groundScene.instance()
  newGround.position = position
  container.add_child(newGround)
