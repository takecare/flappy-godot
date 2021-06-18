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

func _ready() -> void:
  var _result = Game.connect("score_changed", self, "_on_score_changed")
  _on_score_changed(Game.score)
  pass

func _on_score_changed(score) -> void:
  for child in get_children():
    child.queue_free()
  var scoreStr = str(score)
  var digits = []
  print(scoreStr)
  for i in range(scoreStr.length()):
    digits.append(scoreStr[i].to_int())
  for digit in digits:
    var texture = TextureRect.new()
    texture.set_texture(sprites[digit])
    add_child(texture)
