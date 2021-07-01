extends Node

export(NodePath) var birdPath = null
export(NodePath) var gameOverContainerPath = null

onready var bird: Bird = get_node(birdPath) if birdPath != null else get_node("Bird")
onready var gameOverContainer: Control = get_node(gameOverContainerPath) if gameOverContainerPath != null else get_node("GameOverContainer")

func _ready() -> void:
  var _result
  _result = bird.connect("bird_hit", gameOverContainer, "_on_bird_hit")
  _result = bird.connect("bird_grounded", gameOverContainer, "_on_bird_grounded")
  _result = bird.connect("bird_hit", self, "_on_bird_hit")
  _result = bird.connect("bird_grounded", self, "_on_bird_grounded")

func _on_bird_flying() -> void:
  pass

func _on_bird_jumping() -> void:
  pass

func _on_bird_hit() -> void:
  bird.disconnect("bird_hit", gameOverContainer, "_on_bird_hit")
  bird.disconnect("bird_grounded", gameOverContainer, "_on_bird_grounded")
  pass

func _on_bird_grounded() -> void:
  bird.disconnect("bird_hit", gameOverContainer, "_on_bird_hit")
  bird.disconnect("bird_grounded", gameOverContainer, "_on_bird_grounded")
  pass
