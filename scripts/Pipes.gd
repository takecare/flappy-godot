extends Node2D

class_name Pipes, "res://sprites/pipe_icon.png"

signal pipe_freed

var top: Node setget ,get_top
var bottom: Node setget ,get_bottom
var checkpoint: Node setget ,get_checkpoint
var rightmost: Vector2 setget ,get_rightmost_point

var camera: Camera2D # could be a CameraPositionProvider

func init(pos: Vector2, cam: Camera2D) -> void:
  position = pos
  camera = cam

func _ready() -> void:
  get_top().add_to_group(Game.pipeGroup)
  get_bottom().add_to_group(Game.pipeGroup)

func get_top() -> StaticBody2D:
  return get_node("Top") as StaticBody2D

func get_bottom() -> StaticBody2D:
  return get_node("Bottom") as StaticBody2D

func get_checkpoint() -> Checkpoint:
  return get_node("Checkpoint") as Checkpoint

func set_opening(opening: int):
  var spacing: int = opening / 2
  get_top().position.y -= spacing
  get_bottom().position.y += spacing
  get_checkpoint().set_height(opening)

func get_rightmost_point() -> Vector2:
  return get_node("Rightmost").global_position

func _process(_delta: float) -> void:
  if camera == null:
    return
  if cameraIsPastPipes():
    queue_free()
    emit_signal("pipe_freed")

func cameraIsPastPipes() -> bool:
  return camera.get_correct_position().x > get_rightmost_point().x

func activate() -> void:
  get_checkpoint().activate()
