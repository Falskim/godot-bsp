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
	
	split_subdungeon()
	if is_leaf:
		self.add_child(create_color_rect())
		self.add_child(create_center_dot())
	else:
		self.add_child(create_line_between_subdungeon())
	root.add_child(self)
	
	print_properties()
	return self


func split_subdungeon():
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
			split_subdungeon_horizontally()
		else:
			split_subdungeon_vertically()
	elif width > MIN_SIZE && width >= (height*2):
		split_subdungeon_vertically()
	elif height > MIN_SIZE && height >= (width*2):
		split_subdungeon_horizontally()
	else:
		is_leaf = true


func split_subdungeon_horizontally():
	left_subdungeon = get_script().new(self, x, y, width, height * split_ratio)
	right_subdungeon = get_script().new(self, x, y + (height * split_ratio), width, height - (height * split_ratio))


func split_subdungeon_vertically():
	left_subdungeon = get_script().new(self, x, y, width * split_ratio, height)
	right_subdungeon = get_script().new(self, x + (width * split_ratio), y, width - (width * split_ratio), height)


func create_color_rect() -> ColorRect:
	var rect = ColorRect.new()
	rect.set_position(Vector2(x, y))
	rect.set_size(Vector2(width, height))
	rect.color = Color(randf(), randf(), randf())
	return rect


func create_center_dot() -> ColorRect:
	var dot = ColorRect.new()
#	center position reduced by half dot size as an offset
	var center_position = Vector2(get_center_position().x - 5, get_center_position().y - 5)
	dot.set_position(center_position)
	dot.set_size(Vector2(10, 10))
	dot.color = Color(0, 0, 0)
	return dot


func create_line_between_subdungeon() -> Line2D:
	var line = Line2D.new()
	line.add_point(right_subdungeon.get_center_position())
	line.add_point(left_subdungeon.get_center_position())
	line.default_color = Color(0, 0, 0)
	line.set_width(1)
	return line


func get_size() -> Vector2:
	return Vector2(width, height)


func get_center_position() -> Vector2:
	return Vector2(x + width/2, y + height/2)


func print_properties() -> void:
	print(self)
	var format_string = "Position [%s, %s] Size [%s, %s]" % [x, y, width, height]
	print(format_string)
