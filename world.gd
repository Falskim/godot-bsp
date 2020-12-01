extends Node2D

const WORLD_SIZE = Vector2(800, 640)

var bsp = null


func _ready():
	create_bsp()
	

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		bsp.queue_free()
		create_bsp()


func create_bsp():
	randomize()
	bsp = Dungeon.new(self, 0, 0, WORLD_SIZE.x, WORLD_SIZE.y)
	
