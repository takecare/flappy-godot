extends StaticBody2D

class_name Ground

onready var rightmostPoint = get_node("Rightmost").get_global_position()

func get_rightmost_point(): 
    return get_node("Rightmost").get_global_position()