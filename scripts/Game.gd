extends Node

const birdGroup = "birdGroup"
const pipeGroup = "pipes"
const groundGroup = "grounds"

var score: int = 0 setget set_score,get_score

func increase_score() -> void:
    score = score + 1
    print("score: " + str(score))

func set_score(val) -> void:
    score = val
    print("score: " + str(score))

func get_score() -> int:
    return score
