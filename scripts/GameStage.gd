extends Node

export(NodePath) var birdPath = null
export(NodePath) var currentScorePath = null
export(NodePath) var gameOverContainerPath = null

onready var bird: Bird = get_node(birdPath) if birdPath != null else get_node("Bird")
onready var currentScore: Control = get_node(currentScorePath) if currentScorePath != null else get_node("HUD/CurrentScoreContainer")
onready var gameOverContainer: Control = get_node(gameOverContainerPath) if gameOverContainerPath != null else get_node("HUD/GameOverContainer")

func _enter_tree() -> void:
  Game.isDebug = false

func _ready() -> void:
  var _result
  _result = bird.connect("bird_hit", gameOverContainer, "_on_bird_hit")
  _result = bird.connect("bird_grounded", gameOverContainer, "_on_bird_grounded")
  _result = bird.connect("bird_hit", self, "_on_bird_hit")
  _result = bird.connect("bird_grounded", self, "_on_bird_grounded")
  _result = bird.connect("bird_hit", currentScore, "_on_bird_hit")
  _result = bird.connect("bird_grounded", currentScore, "_on_bird_grounded")

func _on_bird_flying() -> void:
  pass

func _on_bird_jumping() -> void:
  pass

func _on_bird_hit() -> void:
  disconnect_signal(bird, "bird_hit", gameOverContainer, "_on_bird_hit")
  disconnect_signal(bird, "bird_grounded", gameOverContainer, "_on_bird_grounded")
  disconnect_signal(bird, "bird_hit", self, "_on_bird_hit")
  disconnect_signal(bird, "bird_grounded", self, "_on_bird_grounded")
  disconnect_signal(bird, "bird_hit", currentScore, "_on_bird_hit")
  disconnect_signal(bird, "bird_grounded", currentScore, "_on_bird_grounded")

func _on_bird_grounded() -> void:
  disconnect_signal(bird, "bird_hit", gameOverContainer, "_on_bird_hit")
  disconnect_signal(bird, "bird_grounded", gameOverContainer, "_on_bird_grounded")
  disconnect_signal(bird, "bird_hit", self, "_on_bird_hit")
  disconnect_signal(bird, "bird_grounded", self, "_on_bird_grounded")
  disconnect_signal(bird, "bird_hit", currentScore, "_on_bird_hit")
  disconnect_signal(bird, "bird_grounded", currentScore, "_on_bird_grounded")

func disconnect_signal(emitter, signalName, target, method) -> void:
  if (emitter.is_connected(signalName, target, method)):
    emitter.disconnect(signalName, target, method)
