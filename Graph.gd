extends Sprite

onready var panel = get_parent().get_node("CanvasLayer/Panel")
onready var param_a = panel.get_node("Input_a")
onready var param_b = panel.get_node("Input_b")
onready var param_c = panel.get_node("Input_c")
onready var solve_btn = panel.get_node("Solve_btn")
onready var output_label = panel.get_node("Output")
onready var line = $Line

var resolution = 0.5
var points = []
var graph_exists = false

var a
var b
var c

func _on_Solve_btn_pressed():
	var params = params_correct(param_a.text, param_b.text, param_c.text)
	
	if params:
		a = params[0]
		b = params[1]
		c = params[2]
		var d = calculate_discriminant(params[0], params[1], params[2])
		var x = calculate_x(params[0], params[1], d)
		points = calculate_points(params[0], params[1], params[2])
		draw_graph(points)
		if x.size() == 2:
			output_label.text = "D: " + str(d) + " | X1: " + str(x[0]) + " | X2: " + str(x[1])
		else:
			output_label.text = "D: " + str(d) + " | X1: " + str(x[0])
	else:
		output_label.text = "ERROR"

func params_correct(aa, bb, cc):
	var params = []

	if aa.empty():
		return false
	elif bb.empty():
		return false
	elif cc.empty():	
		return false
	else:
		params.append(float(aa))
		params.append(float(bb))
		params.append(float(cc))
		return params

func calculate_discriminant(aa, bb, cc):
	var d
	d = pow(bb, 2) - (4 * aa * cc)
	return d

func calculate_x(aa, bb, d):
	var x = []
	if d > 0:
		var x1 = (-bb + sqrt(d)) / (2 * aa)
		var x2 = (-bb - sqrt(d)) / (2 * aa)
		x.append(x1)
		x.append(x2)
	elif d == 0:
		var x1 = -bb/(2 * aa)
		x.append(x1)
	elif d < 0:
		x.append(0)
	return x

func calculate_root(aa, bb, d):
	var root = Vector2.ZERO
	root.x = -bb / (2 * aa)
	root.y = d / (4 * aa)
	return root

func calculate_points(aa, bb, cc):
	var pnts = []
	var x = -10
	while x < 10:
		var y = aa * pow(x, 2) + bb * x + cc
		pnts.append(Vector2(x, -y))
		x += resolution
	return pnts

func draw_graph(pnts):
	graph_exists = true
	line.clear_points()
	for pos in pnts:
		line.add_point(pos * 10)
	# if x.size() == 2:
	# 	line.add_point(Vector2(x[1] * 20, -c))
	# 	line.add_point(root * 20)
	# 	line.add_point(Vector2(x[0] * 20, -c))
	# else:
	# 	line.add_point(root * 10)
	# 	line.add_point(Vector2(x[0] * -20, -c))


func _on_ResolutionSlider_value_changed(value:float):
	resolution = value
	if graph_exists:
		points = calculate_points(a, b, c)
		draw_graph(points)
