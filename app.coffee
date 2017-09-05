# Data
items = [
	{ value: "1", active: true, color: "#1774FF" }, 
	{ value: "2", active: false, color: "#FF4858"}, 
	{ value: "3", active: false, color: "#FFBA00" }, 
	{ value: "4", active: false, color: "#00D800" },
	{ value: "5", active: false, color: "#1774FF" }
]

# Canvas setup
Screen.backgroundColor = "white"

# Methods
makeCircle = (width, height, backgroundColor) ->
	return new Layer
		width: width
		height: height
		borderRadius: width/2
		backgroundColor: item.color

circles = [  ]

for item, i in items
	if i == 0
		circle = makeCircle(200, 200, item.color)
		circle.centerX()
		circle.centerY()
		
		circleCenterX = circle.x
		circleCenterY = circle.y
		
		circle.draggable = true
		circle.draggable.vertical = true
		circle.draggable.momentum = true

		circle.draggable.constraints =
			x: circleCenterX
			y: circleCenterY

		circle.draggable.bounce = true

	else if i == 1
		circle2 = makeCircle(70, 70, item.color)
		
		circle2.centerX(70)
		circle2.centerY(90)
		
		circle2CenterX = circle2.x
		circle2CenterY = circle2.y
	
	else if i == 2
		circle3 = makeCircle(40, 40, item.color)
		
		circle3.centerX(30)
		circle3.centerY(150)
		
		circle3CenterX = circle3.x
		circle3CenterY = circle3.y
	
	else if i == 3
		circle4 = makeCircle(40, 40, item.color)
		circle4.opacity = 0
			
		circle4.centerX(0)
		circle4.centerY(200)
		
		circle4CenterX = circle4.x
		circle4CenterY = circle4.y
		
circle.on Events.DragEnd, ->
	circle.animate
		opacity: 0
		scale: 0
		x: -200
		y: 600
		options:
			time: 0.5
	
	circle2.animate
		width: 200
		height: 200
		borderRadius: 100
		x: circleCenterX
		y: circleCenterY
		options:
			time: 0.5
	
	circle3.animate
		width: 70
		height: 70
		borderRadius: 35
		x: circle2CenterX
		y: circle2CenterY
		options:
			time: 0.5

	circle4.animate
		opacity: 1
		x: circle3CenterX
		y: circle3CenterY
		options:
			delay: .2
			time: 1
			curve: Spring(damping: 0.5)

