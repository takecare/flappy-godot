extends StaticBody2D

class_name SkyLimit, "res://sprites/background_day.png"

export(NodePath) var cameraPath = null

onready var camera: Camera2D = get_node(cameraPath) if cameraPath != null else get_node("Camera")
onready var extents: Vector2 = get_node("CollisionShape").shape.extents

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  add_to_group(Game.skyGroup)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
  if camera != null:
    position.x = camera.position.x - extents.x / 2
  else:
    push_error("Missing Camera in Sky scene.")
