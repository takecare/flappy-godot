extends Node

signal score_changed
signal best_score_changed(bestScore, medal)

const birdGroup = "birdGroup"
const skyGroup = "sky"
const pipeGroup = "pipes"
const groundGroup = "grounds"

enum Medals {
  NONE,
  BRONZE = 10,
  SILVER = 20,
  GOLD = 30,
  PLATINUM = 40
}

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
  var medal = Medals.NONE
  if bestScore >= Medals.PLATINUM:
    medal = Medals.PLATINUM
  elif bestScore >= Medals.GOLD:
    medal = Medals.GOLD
  elif bestScore >= Medals.SILVER:
    medal = Medals.SILVER
  elif bestScore >= Medals.BRONZE:
    medal = Medals.BRONZE
  emit_signal("best_score_changed", bestScore, medal)
