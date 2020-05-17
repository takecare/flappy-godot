extends Node

signal score_changed
signal best_score_changed

const birdGroup = "birdGroup"
const pipeGroup = "pipes"
const groundGroup = "grounds"

var score: int = 0 setget set_score
var bestScore: int = 0 setget set_score

func _ready() -> void:
    pass

func increase_score() -> void:
    score = score + 1
    emit_signal("score_changed", score)

func set_score(val) -> void:
    score = val
    print("set")

func set_bestScore(val) -> void:
    bestScore = val
    emit_signal("best_score_changed", bestScore)
