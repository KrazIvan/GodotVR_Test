extends Node

@onready var animation_player = $AnimationPlayer
@onready var teleportation_sounds = $TeleportationSounds

@export var silent : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("black_screen_fade_out", teleport_black_screen_fade_out)

func teleport_black_screen_fade_out():
	animation_player.play("fade_out")
	if !silent:
		teleportation_sounds.play()
