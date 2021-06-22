extends HBoxContainer

const sprites = [
  preload("res://sprites/number_middle_0.png"),
  preload("res://sprites/number_middle_1.png"),
  preload("res://sprites/number_middle_2.png"),
  preload("res://sprites/number_middle_3.png"),
  preload("res://sprites/number_middle_4.png"),
  preload("res://sprites/number_middle_5.png"),
  preload("res://sprites/number_middle_6.png"),
  preload("res://sprites/number_middle_7.png"),
  preload("res://sprites/number_middle_8.png"),
  preload("res://sprites/number_middle_9.png")
]

export(NodePath) var lastScorePath = null

onready var lastScore: Node = get_node(lastScorePath) if lastScorePath != null else get_node("../LastScore")

func _ready() -> void:
  var _result = lastScore.connect("last_score_count_finished", self, "update_best_score")
  set_score(Game.bestScore)

func update_best_score() -> void:
  set_score(Game.bestScore)

func set_score(score) -> void:
  for child in get_children():
    child.queue_free()
  var scoreStr = str(score)
  var digits = []
  for i in range(scoreStr.length()):
    digits.append(scoreStr[i].to_int())
  for digit in digits:
    var texture = TextureRect.new()
    texture.set_texture(sprites[digit])
    add_child(texture)
