extends AnimatedSprite

# has to be assigned via the editor
export(NodePath) var texturePath = null

onready var textureRect: TextureRect = null if texturePath == null else get_node(texturePath)
onready var textureSize = Vector2(0, 0) if textureRect == null else textureRect.texture.get_size()

func _ready():
  hide()
  randomize()
  var _result = Game.connect("best_score_changed", self, "_show")

func _show(_bestScore, _medal):
  show() 
  $"SparkAnimationPlayer".play("Shine")

func move_to_random_pos() -> void:
  var radius = textureSize.x / 2
  var randomAngle = deg2rad(rand_range(0, 360))
  var randomRadius = rand_range(0, radius)
  var x = randomRadius * cos(randomAngle)
  var y = randomRadius * sin(randomAngle)
  position = Vector2(x + radius, y + radius)
