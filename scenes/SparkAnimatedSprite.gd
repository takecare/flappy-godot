extends AnimatedSprite

# has to be assigned via the editor
export(NodePath) var texturePath = null

onready var textureRect: TextureRect = null if texturePath == null else get_node(texturePath)
onready var textureSize = Vector2(0, 0) if textureRect == null else textureRect.texture.get_size()

onready var animationPlayer: AnimationPlayer = $"SparkAnimationPlayer"

func _ready():
  hide()
  # TODO: add a new sparkle but it can't move to a new pos at the same time
  # 1. get "Shine" animation from SparkAnimationPlayer
  # 2. get duration of Shine animation
  # 3. create new animation of the same duration
  # 4. add method track
  # 5. add key at random position (0..duration)
  
  randomize()
  var _result = Game.connect("best_score_changed", self, "_show")
  _show(0, 0)

func _show(_bestScore, _medal):
  show()
  var animation = create_animation()
  var _result = animationPlayer.add_animation("shine1", animation)
  animationPlayer.playback_speed  = 1.0
  animationPlayer.play("shine1")
  #$"SparkAnimationPlayer".play("Shine")

func create_animation() -> Animation:
  var animation = Animation.new()
  animation.loop = true
  animation.length = 0.8
  
  var methodTrackIdx = animation.add_track(Animation.TYPE_METHOD)
  animation.track_set_path(methodTrackIdx, "../SparkAnimatedSprite")
  animation.track_insert_key(methodTrackIdx, 0.8, {"method": "test", "args": []})
  
  var frameTrackIdx = animation.add_track(Animation.TYPE_VALUE)
  animation.track_set_path(frameTrackIdx, "../SparkAnimatedSprite:frame")
  
  animation.track_insert_key(frameTrackIdx, 0.0, 0, 0.250)
  var frameKey0Idx = animation.track_find_key(frameTrackIdx, 0.0)
  animation.track_set_key_transition(frameTrackIdx, frameKey0Idx, 0.250)
  
  animation.track_insert_key(frameTrackIdx, 0.2, 1, 1.250)
  var frameKey1Idx = animation.track_find_key(frameTrackIdx, 0.2)
  animation.track_set_key_transition(frameTrackIdx, frameKey1Idx, 1.250)
  
  animation.track_insert_key(frameTrackIdx, 0.4, 2, 0.800)
  var frameKey2Idx = animation.track_find_key(frameTrackIdx, 0.4)
  animation.track_set_key_transition(frameTrackIdx, frameKey2Idx, 0.800)
  
  animation.track_insert_key(frameTrackIdx, 0.6, 1, 1.0)
  var frameKey3Idx = animation.track_find_key(frameTrackIdx, 0.6)
  animation.track_set_key_transition(frameTrackIdx, frameKey3Idx, 1.0)
  
  return animation

func test():
  pass #print("hello")

func move_to_random_pos() -> void:
  pass
