extends Node2D

# const groundScene = preload("res://scenes/Ground.tscn")
export(NodePath) var containerPath = null
export(NodePath) var cameraPath = null
export(Resource) var groundScene = preload("res://scenes/Ground.tscn")

var nextPosition: Vector2 = Vector2()
var container: Node = null
var pool: Array = []
var camera: Node2D = null

func _ready() -> void:
  position.y = Utils.get_screen_size().y
  nextPosition = position

  # container = Utils.get_path_or_node("Container", containerPath)
  if containerPath == null:
    container = get_node("Container")
  else:
    container = get_node(containerPath)

  if cameraPath == null:
    camera = Utils.get_main_node().get_node("Camera")
  else:
    camera = get_node(cameraPath)

  for i in range(3):
    pool.append(instantiateGroundAt(i))
  # spawn()

func instantiateGroundAt(pos: int):
  # var ground = groundScene.instance()
  # ground.position.x = position
  var newGround = groundScene.instance()
  var node = newGround.get_node("Sprite")
  newGround.position.x = node.texture.get_size().x * pos
  container.add_child(newGround)
  return newGround

func spawn():
  var newGround = groundScene.instance()
  # newGround.position = nextPosition
  var node = newGround.get_node("Sprite")
  nextPosition.x = node.texture.get_size().x
  container.add_child(newGround)

func _process(_delta: float) -> void:
  updateGroundInstances()

func updateGroundInstances() -> void:
  for ground in pool:
    if ground.rightmostPoint.x < camera.get_correct_position().x:
      ground.position.x = pool[pool.size() - 1].rightmostPoint.x