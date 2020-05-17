extends Area2D

class_name Checkpoint

var shape: Shape2D setget ,get_shape
var enabled: bool = false

func _ready() -> void:
  var _result = connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
  if (body.is_in_group(Game.birdGroup) && enabled):
    Game.increase_score()

func _on_game_started():
  activate()

func set_height(size: float) -> void:
  get_shape().extents = Vector2(get_shape().extents.x, size)

func get_shape() -> Shape2D:
  return get_node("CollisionShape").shape as Shape2D

func activate() -> void:
  enabled = true

func deactivate() -> void:
  enabled = false
