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

signal last_score_count_finished

export(float) var lerpDuration = 1.5 # seconds
export(NodePath) var animationPlayerPath = null

onready var animationPlayer: AnimationPlayer = get_node(animationPlayerPath) if animationPlayerPath != null else get_node("../../AnimationPlayer")

func _ready() -> void:
  set_score(Game.score)
  yield(animationPlayer, "animation_finished")
  count_to_score()
  # i can't figure out why connecting the signal doesn't work so we're using yield
  #var _result = animationPlayer.connect("animation_finished", self, "count_to_score")

func count_to_score():
  var lerpTime = 0
  while lerpTime < lerpDuration:
    lerpTime += get_process_delta_time()  
    var score = lerp(0, Game.score, lerpTime / lerpDuration)
    set_score(int(score))
    yield(get_tree(), "idle_frame")
  emit_signal("last_score_count_finished")

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
