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
  disconnect_signal(bird, "bird_hit", gameOverContainer, "_on_bird_hit")
  disconnect_signal(bird, "bird_grounded", gameOverContainer, "_on_bird_grounded")

func _on_bird_grounded() -> void:
  disconnect_signal(bird, "bird_hit", gameOverContainer, "_on_bird_hit")
  disconnect_signal(bird, "bird_grounded", gameOverContainer, "_on_bird_grounded")

func disconnect_signal(emitter, signalName, target, method) -> void:
  if (emitter.is_connected(signalName, target, method)):
    emitter.disconnect(signalName, target, method)
