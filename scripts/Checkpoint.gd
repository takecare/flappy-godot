extends Area2D

class_name Checkpoint

var shape: Shape2D setget ,get_shape

func _ready() -> void:
  var _result = connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node):
  if (body.is_in_group(Game.birdGroup)):
    Game.increase_score()

func set_height(size: float) -> void:
  shape.extents = Vector2(shape.extents.x, size)

func get_shape() -> Shape2D:
  return get_node("CollisionShape").shape as Shape2D
