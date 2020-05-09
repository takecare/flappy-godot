extends Node2D

const NUM_OF_GROUND_INSTANCES = 3

export(NodePath) var containerPath = null
export(NodePath) var cameraPath = null
export(Resource) var groundScene = preload("res://scenes/Ground.tscn")

var nextPosition: Vector2 = Vector2()
var container: Node = null
var groundPool: Array = []
var camera: Camera2D = null

func _ready() -> void:
  position.y = Utils.get_screen_size().y
  nextPosition = position
  if containerPath == null:
    container = get_node("Container")
  else:
    container = get_node(containerPath)
  if cameraPath == null:
    camera = Utils.get_main_node().get_node("Camera")
  else:
    camera = get_node(cameraPath)
  for i in range(NUM_OF_GROUND_INSTANCES):
    groundPool.append(instantiateGroundAt(i))

func instantiateGroundAt(pos: int) -> Node2D:
  var newGround = groundScene.instance()
  var node = newGround.get_node("Sprite") # bad: tightly coupled to the ground scene's internals
  newGround.position.x = node.texture.get_size().x * pos
  container.add_child(newGround)
  return newGround

func _process(_delta: float) -> void:
  if camera == null:
    return
  updateGroundInstances()

var lastMoved = groundPool.size() - 1

func updateGroundInstances() -> void:
  for i in range(0, groundPool.size()):
    if cameraIsPastGround(groundPool[i]):
      groundPool[i].position.x = groundPool[lastMoved].get_rightmost_point().x
      lastMoved = i

func cameraIsPastGround(ground: Node2D) -> bool:
  return ground.get_rightmost_point().x < camera.get_correct_position().x
