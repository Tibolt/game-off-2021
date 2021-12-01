extends Control

var hp = 4 setget set_hp
var max_hp = 4 setget set_max_hp

onready var heartFull = $heart_full
onready var heartBroken = $heart_broken

func set_hp(value):
	hp = clamp(value, 0, max_hp)
	if heartFull != null:
		heartFull.rect_size.x = hp * 20
	
func set_max_hp(value):
	max_hp = max(value, 1)
	self.hp = min(hp, max_hp)
	if heartBroken != null:
		heartBroken.rect_size.x = max_hp * 20
	
func _ready():
	self.max_hp = PlayerStats.max_health
	self.hp = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hp")
	PlayerStats.connect("max_health_changed",self, "set_max_hp")
