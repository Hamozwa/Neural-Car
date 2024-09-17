extends Label

func GenLabel(message):
	text = message

func _ready():
	KC.connect("GenLabel",self,"GenLabel")
