extends Area2D

var mouse_pos: Vector2
var diff: Vector2

@export var bounds: float
@export var speed: float

@onready var balloon_graphics: Node2D = $balloon
@onready var basket_graphics: Node2D = $basket
@onready var balloon_shader: AnimatedSprite2D = $"balloon/balloon_graphics"
@onready var fire: Node2D = $basket/fire
@onready var pop_sound: AudioStreamPlayer2D = $Pop
@onready var burner_sound: AudioStreamPlayer2D = $Burner
@onready var die_sound: AudioStreamPlayer2D = $Die

@onready var balloon_shadow_control: Node2D = $Shadow/balloon
@onready var balloon_shadow_graphics: AnimatedSprite2D = $Shadow/balloon/balloon_graphics
@onready var wind_graphics: Node2D = $wind
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
	balloon_shadow_control.rotation_degrees = balloon_graphics.rotation_degrees

	basket_graphics.rotation_degrees = clamp(rot_deg / 2, -65, 65)
	basket_shadow.rotation_degrees = basket_graphics.rotation_degrees

	fire.rotation_degrees = basket_graphics.rotation_degrees * -1

	wind_graphics.rotation_degrees = rad_to_deg(diff.angle()) - 90 
	wind_graphics.visible = blow_strength > 0

func set_visual_parameters(): 
	line_l.set_point_position(0, line_l.to_local(attach_l_2.global_position))
	line_r.set_point_position(0, line_r.to_local(attach_r_2.global_position))
	line_l.set_point_position(1, line_l.to_local(attach_l.global_position))
	line_r.set_point_position(1, line_r.to_local(attach_r.global_position))

	if GameManager.game_started:
		var blow = MicControl.get_blow_strength()
		burner_sound.volume_linear = blow
		fire.scale = Vector2(blow, blow)
	else:
		burner_sound.volume_linear = 0.1

func pop_balloon(): 
	balloon_shader.play("popped")
	balloon_shadow_graphics.play("popped")
	balloon_shader.material.set_shader_parameter("speed", 20.0)
	pop_sound.play()

func fall_down(): 
	die_sound.play()
	balloon_shader.material.set_shader_parameter("speed", 2.0)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", Vector2(position.x, 1000), 1.5)
	var rot_tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BOUNCE)
	rot_tween.tween_property(balloon_graphics, "rotation_degrees", 0, 0.25)
	rot_tween.tween_property(basket_graphics, "rotation_degrees", 0, 0.25)

func _on_body_entered(_body: Node2D) -> void:
	if game_lost: 
		return 
	if not GameManager.game_started: 
		return
	SignalBus.game_over.emit()
