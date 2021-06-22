extends Node

signal score_changed
signal best_score_changed(bestScore)

const birdGroup = "birdGroup"
const skyGroup = "sky"
const pipeGroup = "pipes"
const groundGroup = "grounds"

var score: int = 0 setget set_score
var bestScore: int = 0 setget set_best_score

func _ready() -> void:
  pass

func increase_score() -> void:
  set_score(score + 1)
  emit_signal("score_changed", score)

func reset_score() -> void:
  set_score(0)

func set_score(val) -> void:
  score = val
  if score > bestScore:
    set_best_score(score)

func set_best_score(val) -> void:
  bestScore = val
  emit_signal("best_score_changed", bestScore)
