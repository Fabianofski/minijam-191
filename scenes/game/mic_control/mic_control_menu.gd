extends Control

@export var gradient: Gradient

@onready var label: Label = $BlowStrenghtLabel
@onready var devices: OptionButton = $OptionButton
@onready var slider: HSlider = $HSlider

func _ready() -> void:
	for device in AudioServer.get_input_device_list(): 
		devices.add_item(device)

func _process(_delta: float) -> void:
	label.text = 'Blow Strength: %s%%' % (MicControl.get_blow_strength() * 100)
	slider.value =  MicControl.percent * 100.0
	slider.modulate = gradient.sample(MicControl.percent)

func select_device(device_idx: int): 
	var device_name = AudioServer.get_input_device_list()[device_idx]
	AudioServer.set_input_device(device_name)

func set_threshold(threshold: float): 
	MicControl.threshold = threshold 

func set_amplify(amplify: float): 
	MicControl.amplify = amplify
