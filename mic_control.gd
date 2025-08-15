extends Node2D

const MAX_SAMPLES: int = 10
var record_live_index: int
var volume_samples: Array = []

@onready var label: Label = $Label
@onready var devices: OptionButton = $OptionButton

func _ready() -> void:
	record_live_index = AudioServer.get_bus_index('Record')
	for device in AudioServer.get_input_device_list(): 
		devices.add_item(device)

func select_device(device_idx: int): 
	var device_name = AudioServer.get_input_device_list()[device_idx]
	AudioServer.set_input_device(device_name)

func _process(_delta: float) -> void:
	var sample = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
	volume_samples.push_front(sample)

	if volume_samples.size() > MAX_SAMPLES:
		volume_samples.pop_back()

	var sample_avg = average_array(volume_samples)
	label.text = 'Mic: %sdb' % round(linear_to_db(sample_avg))

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
