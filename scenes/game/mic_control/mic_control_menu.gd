extends Control

@export var gradient: Gradient

@onready var label: Label = $BlowStrenghtLabel
@onready var devices: OptionButton = $OptionButton
@onready var slider: HSlider = $OutputSlider
@onready var threshold_slider: HSlider = $ThresholdSlider
@onready var amplify_slider: HSlider = $AmpliSlider 

func _ready() -> void:
	update_device_list()

func _process(_delta: float) -> void:
	label.text = 'Blow Strength: %s%%' % roundf(MicControl.get_blow_strength() * 100)
	slider.value =  MicControl.percent * 100.0
	slider.modulate = gradient.sample(MicControl.percent)

func update_device_list(): 
	devices.clear()
	for device in AudioServer.get_input_device_list(): 
		devices.add_item(device)

	threshold_slider.value = MicControl.threshold
	amplify_slider.value = MicControl.amplify

func select_device(device_idx: int): 
	var device_name = AudioServer.get_input_device_list()[device_idx]
	AudioServer.set_input_device(device_name)

func set_threshold(threshold: float): 
	MicControl.threshold = threshold 

func set_amplify(amplify: float):
	if amplify <= 0.0:
		MicControl.amplify = (amplify + 1.0) * 1.0
	else:
		MicControl.amplify = 1.0 + amplify * 5.0
