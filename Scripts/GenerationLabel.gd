#GenerationLabel.gd
#Shows the Generation and Batch number while simulating, allowing other scripts to change the text

extends Label

func GenLabel(message):
	text = message

func _ready():
	KC.connect("GenLabel",self,"GenLabel")
