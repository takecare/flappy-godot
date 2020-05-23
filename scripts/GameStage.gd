extends Node

export(NodePath) var birdPath = null
export(NodePath) var gameOverContainerPath = null

onready var bird: Bird = get_node(birdPath) if birdPath != null else get_node("Bird")
onready var gameOverContainer: Control = get_node(gameOverContainerPath) if gameOverContainerPath != null else get_node("GameOverContainer")

func _ready() -> void:
  var _result
  _result = bird.connect("bird_flying", gameOverContainer, "_on_bird_flying")
  _result = bird.connect("bird_jumping", gameOverContainer, "_on_bird_jumping")
  _result = bird.connect("bird_hit", gameOverContainer, "_on_bird_hit")
  _result = bird.connect("bird_grounded", gameOverContainer, "_on_bird_grounded")
