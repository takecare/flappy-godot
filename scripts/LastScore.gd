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

var lerpTime = 0
var lerpDuration = 3
var tempScore = 0

func _ready() -> void:
  set_score(Game.score)
  set_process(true)
  pass
  
func _process(delta):
  lerpTime += delta
  if lerpTime > lerpDuration:
    lerpTime = lerpDuration
  var score = int(lerp(0, 100, lerpTime / lerpDuration))
  if score != tempScore:
    tempScore = score
    set_score(score)

func set_score(score) -> void:
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
