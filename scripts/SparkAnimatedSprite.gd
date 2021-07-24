extends AnimatedSprite

class_name Sparkle

# has to be assigned via the editor. needed to calculate where the sparkle can move to
# it should be the medal texture
export(NodePath) var texturePath = null
export(float) var speed: float = 1.0
export(float, 0, 0.8) var timeOffset = null
export(float) var scaleOffset = null # scale = [step, 1.0 - scaleStep]

onready var textureRect: TextureRect = null if texturePath == null else get_node(texturePath)
onready var textureSize = Vector2(0, 0) if textureRect == null else textureRect.texture.get_size()

onready var animationPlayer: AnimationPlayer = $"SparkAnimationPlayer"

func _ready():
  hide()
  randomize()
  animationPlayer.playback_speed = speed
  var shineAnimation: Animation = create_animation()
  var _result = animationPlayer.add_animation("Shine", shineAnimation)
  _result = Game.connect("best_score_changed", self, "_show")
  if Game.isDebug:
    _show(0,0)

func create_animation() -> Animation:
  var animation = Animation.new()
  animation.length = 0.8
  animation.loop = true
  add_move_track(animation)
  add_frame_track(animation)
  return animation
  
func add_frame_track(animation: Animation) -> void:
  var trackIdx = animation.add_track(Animation.TYPE_VALUE)
  animation.track_set_interpolation_type(trackIdx, 0)
  animation.track_set_path(trackIdx, "../" + name + ":frame")
  animation.track_insert_key(trackIdx, 0.0, 0, 0.25)
  animation.track_insert_key(trackIdx, 0.2, 1, 1.25)
  animation.track_insert_key(trackIdx, 0.4, 2, 0.8)
  animation.track_insert_key(trackIdx, 0.6, 1, 1.0)

func _show(_bestScore, _medal):
  show()
  animationPlayer.play("Shine")
  
func random_scale(baseValue: float = 1.0) -> Vector2:
  # always start from a base value otherwise we'll build up on previous values
  var newScale = baseValue
  if scaleOffset != null:
    var randomSign = 1 if randi() % 2 == 0 else -1
    newScale = newScale + randomSign * scaleOffset
  return Vector2(newScale, newScale)
  
func random_time(animation: Animation) -> float:
  # new time must be less than shineAnimation.length
  var moveTime = animation.length
  if timeOffset != null:
    var times = animation.length / timeOffset
    var random = ((randi() % int(times)) + 1) / float(10)
    moveTime = moveTime - random
  return moveTime

func add_move_track(animation: Animation) -> void:
  var moveTime = random_time(animation)
  var moveMethodTrackIdx = animation.add_track(Animation.TYPE_METHOD)
  var scheduleMethodTrackIdx = animation.add_track(Animation.TYPE_METHOD)
  animation.track_set_path(moveMethodTrackIdx, "../" + name)
  animation.track_set_path(scheduleMethodTrackIdx, "../" + name)
  animation.track_insert_key(moveMethodTrackIdx, moveTime, {"method": "move_to_random_pos", "args": []})
  animation.track_insert_key(scheduleMethodTrackIdx, moveTime, {"method": "schedule_next_move", "args": [scheduleMethodTrackIdx]})

func schedule_next_move(animation: Animation, trackIdx: int) -> void:
  animation.remove_track(trackIdx)
  add_move_track(animation)

func move_to_random_pos() -> void:
  var radius = textureSize.x / 2
  var randomAngle = deg2rad(rand_range(0, 360))
  var randomRadius = rand_range(0, radius)
  var x = randomRadius * cos(randomAngle)
  var y = randomRadius * sin(randomAngle)
  position = Vector2(x + radius, y + radius)
  scale = random_scale()
