extends RigidBody2D

# Declare member variables here. Examples:
export var min_speed = 50   # Minimum speed range.
export var max_speed = 150  # Maximum speed range.
var mob_types = ["ship1", "ship2", "ship3"]
var hit_counters = [1,2,3]
var mob_type = 'ship1'
var hit_counter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    var ri = randi() % mob_types.size()
    mob_type = mob_types[ri]
    hit_counter = hit_counters[ri]
    $AnimatedSprite.animation = mob_type
    

func _on_Visibility_screen_exited():
    queue_free()


func _on_MobArea2D_area_entered(area):
    if 'Bullet' in area.name:
        var main_scn = self.get_parent()
        main_scn.score += 1
        main_scn.get_node('HUD').update_score(main_scn.score)
        
        hit_counter -= 1
        if hit_counter == 0:
            queue_free()