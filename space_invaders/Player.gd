extends Area2D
signal hit

# Declare member variables here. Examples:
export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.
var bullet_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    hide()

var mouse_position = Vector2(0.0, 0.0)
onready var player = $AnimatedSprite.get_parent()

func _input(event):
    if (event is InputEventScreenTouch) or (event is InputEventMouseButton):
        if event.is_pressed():
            if player:
                mouse_position = event.position
    elif event is InputEventScreenDrag:
        mouse_position = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var velocity = Vector2()  # The player's movement vector.
    
    velocity = mouse_position - position
    position.x = position.x + velocity.x
    
    if velocity.length() > 0:
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()
    
    position.y = clamp(position.y, 0, screen_size.y)

    if velocity.y != 0:
        $AnimatedSprite.animation = "up"
        $AnimatedSprite.flip_v = false
    
    bullet_timer += delta
    if bullet_timer>0.25:
        bullet_timer = 0
        fire()
        #if Input.is_key_pressed(KEY_SPACE):
        
func _on_Player_body_entered(body):
    pass
    #print(body.name)
    #hide()  # Player disappears after being hit.
    #emit_signal("hit")
    #$CollisionShape2D.call_deferred("set_disabled", true)

func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false

func fire():
    var Bullet = load("res://Bullet.tscn")
    var bullet = Bullet.instance()
    self.get_parent().add_child(bullet)
    bullet.position = self.position
    bullet.position.y -= 30
