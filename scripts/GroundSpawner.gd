extends Node2D

class_name GroundSpawner

const NUM_OF_GROUND_INSTANCES = 3

export(NodePath) var containerPath = null
export(NodePath) var cameraPath = null
export(Resource) var groundScene = preload("res://scenes/Ground.tscn")

onready var container: Node = get_node(containerPath) if containerPath != null else get_node("Container")
onready var camera: Camera2D = get_node(containerPath) if containerPath != null else Utils.get_main_camera()

var groundPool: Array = []
var nextPosition: Vector2 = Vector2()
var lastMoved: int = NUM_OF_GROUND_INSTANCES - 1 # assumes array size is NUM_OF_GROUND_INSTANCES

func _ready() -> void:
  position.y = Utils.get_screen_size().y
  nextPosition = position
  for i in range(NUM_OF_GROUND_INSTANCES):
    groundPool.append(instantiateGroundAt(i))

func instantiateGroundAt(pos: int) -> Node2D:
  var newGround = groundScene.instance()
  newGround.position.x = newGround.get_size().x * pos
  container.add_child(newGround)
  return newGround

func _process(_delta: float) -> void:
  if camera == null: # enables us to run the GroundSpawner scene independently
    return
  updateGroundInstances()

func updateGroundInstances() -> void:
  for i in range(0, groundPool.size()):
    if cameraIsPastGround(groundPool[i]):
      groundPool[i].position.x = groundPool[lastMoved].get_rightmost_point().x
      lastMoved = i

func cameraIsPastGround(ground: Node2D) -> bool:
  return ground.get_rightmost_point().x < camera.get_correct_position().x
