extends Node

class_name Dungeon

const MIN_SIZE = 240

var is_leaf : bool = false
var left_subdungeon : Dungeon
var right_subdungeon : Dungeon
var split_horizontally : bool
var split_ratio : float

var root
var x : int
var y : int
var width : int
var height : int


func _init(root, x, y, width, height):
	randomize()
	self.root = root
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	
	self.add_child(create_color_rect())
	root.add_child(self)
	_split_subdungeon()
	
	print(self, x, " ", y, " ", width, " ", height, " ", split_ratio)
	return self


func _get_size() -> Vector2:
	return Vector2(width, height)


func _split_subdungeon():
	split_ratio = rand_range(0.2, 0.8)
	if width <= MIN_SIZE*1.5 || height <= MIN_SIZE*1.5:
		split_ratio = rand_range(0.4, 0.6)
	
	if width > MIN_SIZE && height > MIN_SIZE:
		# Horizontal = 1, Vertical = 0
		split_horizontally = randi() % 2
		if (height > width):
			split_horizontally = true
		elif (width > height):
			split_horizontally = false
		
		if split_horizontally:
			_split_subdungeon_horizontally()
		else:
			_split_subdungeon_vertically()
	elif width > MIN_SIZE && width >= (height*2):
		_split_subdungeon_vertically()
	elif height > MIN_SIZE && height >= (width*2):
		_split_subdungeon_horizontally()


func _split_subdungeon_horizontally():
	left_subdungeon = get_script().new(self, x, y, width, height * split_ratio)
	right_subdungeon = get_script().new(self, x, y + (height * split_ratio), width, height - (height * split_ratio))


func _split_subdungeon_vertically():
	left_subdungeon = get_script().new(self, x, y, width * split_ratio, height)
	right_subdungeon = get_script().new(self, x + (width * split_ratio), y, width - (width * split_ratio), height)


func create_color_rect() -> ColorRect:
	var rect = ColorRect.new()
	rect.set_position(Vector2(x, y))
	rect.set_size(Vector2(width, height))
	rect.color = Color(randf(), randf(), randf())
	return rect
