extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var letterApparitionWaitTime = 0.1
export (float) var punctApparitionWaitTime = 0.3
export (float) var otherApparitionWaitTime = 0.1
export (float) var letterDisappearenceWaitTime = 0.05
export (float) var punctDisappearenceWaitTime = 0.05
export (float) var otherDisappearenceWaitTime = 0.05
const CHARS = "abcdefghijklmnopqrstuvwxyz"
const PUNCT = ",.:-?!"
const NONVIS = "\n\t "
var changing = false
var appearing = true
onready var timer = 0.1
var wait_time = 0
var count = 0
var is_visible_char =true
func _ready():
	visible_characters = 0
	wait_time = 0.1
	start_appear()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if changing:
		timer += delta
		if timer >= wait_time:
			timer = 0
			if is_visible_char:
				if appearing:
					visible_characters += 1
				else:
					visible_characters -= 1
			is_visible_char = true
			if visible_characters+count != text.length() and visible_characters != 0:
				if CHARS.find(text.substr(visible_characters + count-1, 1)) != -1:
					if appearing:
						wait_time = letterApparitionWaitTime
					else:
						wait_time = letterDisappearenceWaitTime
				elif PUNCT.find(text.substr(visible_characters + count-1, 1)) != -1:
					if appearing:
						wait_time = punctApparitionWaitTime
					else:
						wait_time = punctDisappearenceWaitTime
				else:
					if NONVIS.find(text.substr(visible_characters + count-1, 1)) != -1:
						if appearing:
							count += 1
						else:
							count -= 1
						is_visible_char = false
						if appearing:
							timer = otherApparitionWaitTime
						else:
							timer = otherDisappearenceWaitTime
					if appearing:
						wait_time = otherApparitionWaitTime
					else:
						wait_time = otherDisappearenceWaitTime
			else:
				changing = false
	if Input.is_action_just_pressed("text_appear"):
		start_appear()
	if Input.is_action_just_pressed("text_disappear"):
		start_disappear()

func start_appear():
	changing = true
	appearing = true

func start_disappear():
	changing = true
	appearing = false