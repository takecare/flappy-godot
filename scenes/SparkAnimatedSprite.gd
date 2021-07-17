extends AnimatedSprite

# has to be assigned via the editor. needed to calculate where the sparkle can move to
export(NodePath) var texturePath = null
export(float) var timeOffset = null
export(float) var scaleOffset = null # scale = [step, 1.0 - scaleStep]

onready var textureRect: TextureRect = null if texturePath == null else get_node(texturePath)
onready var textureSize = Vector2(0, 0) if textureRect == null else textureRect.texture.get_size()

onready var animationPlayer: AnimationPlayer = $"SparkAnimationPlayer"
onready var shineAnimation = animationPlayer.get_animation("Shine")

func _ready():
  hide()
  randomize()
  var _result = Game.connect("best_score_changed", self, "_show")
  _show(0,0) #debug

func _show(_bestScore, _medal):
  show()
  # hook our "move to random pos" animation into the pre-existing shine animation
  # p.s.: i've tried to create the frame animation via code as well but it doesn't
  #  work as it skips some frames (check previous commits) so we're hooking into
  # the animation created via editor
  add_move_track()
  $"SparkAnimationPlayer".play("Shine")
  
func random_scale(baseValue: float = 1.0) -> Vector2:
  # always start from a base value otherwise we'll build up on previous values
  var newScale = baseValue
  if scaleOffset != null:
    var randomSign = 1 if randi() % 2 == 0 else -1
    newScale = newScale + randomSign * scaleOffset
  return Vector2(newScale, newScale)
  
func random_time() -> float:
  # new time must be less than shineAnimation.length
  var moveTime = shineAnimation.length
  if timeOffset != null:
    var times = shineAnimation.length / timeOffset
    var random = ((randi() % int(times)) + 1) / float(10)
    moveTime = moveTime - random
  return moveTime

func add_move_track() -> void:
  var moveTime = random_time()
  var methodTrackIdx = shineAnimation.add_track(Animation.TYPE_METHOD)
  shineAnimation.track_set_path(methodTrackIdx, "../SparkAnimatedSprite")
  shineAnimation.track_insert_key(methodTrackIdx, moveTime, {"method": "move_to_random_pos", "args": []})
  shineAnimation.track_insert_key(methodTrackIdx, moveTime, {"method": "schedule_next_move", "args": [methodTrackIdx]})

func schedule_next_move(trackIdx: int) -> void:
  shineAnimation.remove_track(trackIdx)
  add_move_track()

func move_to_random_pos() -> void:
  var radius = textureSize.x / 2
  var randomAngle = deg2rad(rand_range(0, 360))
  var randomRadius = rand_range(0, radius)
  var x = randomRadius * cos(randomAngle)
  var y = randomRadius * sin(randomAngle)
  position = Vector2(x + radius, y + radius)
  scale = random_scale()
