extends Node

@onready var audio_stream_player = $"."


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("finished", _on_finished)

func _on_finished():
	audio_stream_player.play()
