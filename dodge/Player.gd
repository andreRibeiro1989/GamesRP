extends Area2D
signal hit

# Declare member variables here. Examples:
export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    hide()

var direction = Vector2(0.0, 0.0)
onready var player = $AnimatedSprite.get_parent()

func _input(event):
    if (event is InputEventScreenTouch) or (event is InputEventMouseButton):
        print("catched event!!!")
        if event.is_pressed():
            if player:
                direction = player.to_local(event.position).normalized()
                print(direction)
        else:
            direction = Vector2(0.0, 0.0)
    elif event is InputEventScreenDrag:
        direction = player.to_local(event.position).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var velocity = Vector2()  # The player's movement vector.
    #if Input.is_action_pressed("ui_right"):
    #    velocity.x += 1
    #if Input.is_action_pressed("ui_left"):
    #    velocity.x -= 1
    #if Input.is_action_pressed("ui_down"):
    #    velocity.y += 1
    #if Input.is_action_pressed("ui_up"):
    #    velocity.y -= 1
    
    velocity = direction * speed * delta
    position = position + velocity
    
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()
    
    #position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

    if velocity.x != 0:
        $AnimatedSprite.animation = "right"
        $AnimatedSprite.flip_v = false
        # See the note below about boolean assignment
        $AnimatedSprite.flip_h = velocity.x < 0
    elif velocity.y != 0:
        $AnimatedSprite.animation = "up"
        $AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
    hide()  # Player disappears after being hit.
    emit_signal("hit")
    $CollisionShape2D.call_deferred("set_disabled", true)

func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
