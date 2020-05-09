extends StaticBody2D

class_name Ground

# these do not work because "onready" runs when the node to which this script is
# attached to is added to the scene tree.
# onready var rightmostPoint: Position2D = get_node("Rightmost")
# onready var sprite: Node2D = get_node("Sprite")

func get_size() -> Node2D:
    return get_node("Sprite").texture.get_size()

func get_rightmost_point() -> Vector2:
    return get_node("Rightmost").get_global_position()
