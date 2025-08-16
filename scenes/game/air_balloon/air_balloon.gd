extends Area2D

var mouse_pos: Vector2
var diff: Vector2

@export var bounds: float
@export var speed: float

@onready var balloon_graphics: Node2D = $balloon
@onready var basket_graphics: Node2D = $basket
@onready var balloon_shader: TextureRect = $"balloon/balloon_graphics"
@onready var fire: Node2D = $basket/fire
@export var popped_tex: Texture
@onready var pop_sound: AudioStreamPlayer2D = $Pop

@onready var balloon_shadow_control: Node2D = $Shadow/balloon
@onready var balloon_shadow_graphics: TextureRect = $Shadow/balloon/balloon_graphics
@onready var basket_shadow: Node2D = $Shadow/basket

@onready var line_l: Line2D = $LineL
@onready var line_r: Line2D = $LineR

@onready var attach_l: Node2D = $"balloon/balloon_graphics/AttachL"
@onready var attach_r: Node2D = $"balloon/balloon_graphics/AttachR"
@onready var attach_l_2: Node2D = $basket/AttachL2
@onready var attach_r_2: Node2D = $basket/AttachR2

var game_lost: bool = false

func _ready() -> void:
	SignalBus.game_start.connect(pop_balloon)
	SignalBus.game_over.connect(fall_down)

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = get_global_mouse_position()
		diff = (mouse_pos - global_position).normalized()

func _process(delta: float) -> void:
	if GameManager.game_started:
		rotate_and_move(delta)
	set_visual_parameters()

func rotate_and_move(delta: float): 
	var blow_strength = MicControl.get_blow_strength()
	position.x -= diff.x * speed * delta * blow_strength
	position.x = clamp(position.x, -bounds, bounds)

	GameManager.vertical_blow = -diff.y * blow_strength + 1

	var rot_deg = abs(rad_to_deg(diff.angle())) - 90
	balloon_graphics.rotation_degrees = clamp(rot_deg, -110, 110)
	basket_graphics.rotation_degrees = clamp(rot_deg / 2, -65, 65)
	fire.rotation_degrees = basket_graphics.rotation_degrees * -1
	# And now, for the shadow
	basket_shadow.rotation_degrees = basket_graphics.rotation_degrees
	balloon_shadow_control.rotation_degrees = balloon_graphics.rotation_degrees

func set_visual_parameters(): 
	var default_wind = 20.0 if GameManager.game_started else 5.0
	balloon_shader.material.set_shader_parameter("speed", default_wind + abs(MicControl.get_blow_strength()))
	
	line_l.set_point_position(0, line_l.to_local(attach_l_2.global_position))
	line_r.set_point_position(0, line_r.to_local(attach_r_2.global_position))
	line_l.set_point_position(1, line_l.to_local(attach_l.global_position))
	line_r.set_point_position(1, line_r.to_local(attach_r.global_position))

func pop_balloon(): 
	balloon_shader.texture = popped_tex
	balloon_shadow_graphics.texture = popped_tex
	pop_sound.play()

func fall_down(): 
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 1000), 1.5)
	tween.set_ease(Tween.EASE_IN)
	balloon_graphics.rotation_degrees = 0
	basket_graphics.rotation_degrees = 0

func _on_body_entered(_body: Node2D) -> void:
	SignalBus.game_over.emit()
