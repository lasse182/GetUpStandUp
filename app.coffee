
background = new BackgroundLayer
    backgroundColor: "#ffffff"

circles = [
	{
		name: "first"
		value: "1"
		x: 0
		y: 0
		width: 200
		height: 200
		borderRadius: 100
		backgroundColor: "#1774FF"
		opacity: 1
		active: true
	},
	{
		name: "second"
		value: "2"
		x: 120
		y: 180
		width: 70
		height: 70
		borderRadius: 35
		backgroundColor: "#FF4858"
		opacity: 1
		active: false
	},
	{
		name: "third"
		value: "3"
		x: 100
		y: 250
		width: 40
		height: 40
		borderRadius: 20
		backgroundColor: "#FFBA00"
		opacity: 1
		active: false
	},
	{
		name: "fourth"
		value: "4"
		x: -200
		y: 600
		width: 40
		height: 40
		borderRadius: 20
		backgroundColor: "#00D800"
		opacity: 0
		active: false
	}
]

## FUNCTIONS ##

setDragable = (circle) =>
	circle.draggable = true
	circle.draggable.vertical = true
	circle.draggable.momentum = true
	circle.draggable.bounce = true

setUndragable = (circle) =>
	circle.draggable = false
	circle.draggable.vertical = false
	circle.draggable.momentum = false
	circle.draggable.bounce = false

resetCircles = () =>
	for circle, i in circles
		circleLayer = circleLayers[i]
		setUndragable(circleLayer)
		circleLayer.off(Events.DragEnd)

attachDragEvent = (index) =>
	direction = null
	circleLayers[index].onDrag (event, layer) =>
		direction = layer.draggable.direction
	
	circleLayers[index].onDragEnd (event, layer) =>
		if direction == "up" || direction == "left"
			for circle in circleLayers
				textLayer = circle.childrenWithName("text")
				textLayer[0].center()
				
			setNextActive(circles)
			setDragableCircle()
			nextState()
		else
			setPreviousActive(circles)
			setDragableCircle()
			previousState()	

changeActiveCircle = () =>
	for circle, i in circles
		if circle.active
			attachDragEvent(i)
			setDragable(circleLayers[i])

setDragableCircle = () =>
	resetCircles()
	changeActiveCircle()
	
setNextActive = (array) =>
	# Get the index of last element in array
	lastIndex = array.length-1
	
	for item, i in array
		
		# if item is active and not last element in array, set current item to inactive and next item to active
		if item.active and i < lastIndex
			nextItem = i+1
			item.active = false
			array[i+1].active = true
			return nextItem
		
		# if item is active and is the last element, set current item to false and first element to active
		else if item.active && i == lastIndex
			nextItem = 0
			item.active = false
			array[0].active = true
			return nextItem

setPreviousActive = (array) =>
	# Get the index of last element in array
	firstIndex = 0
	lastIndex = array.length-1
	
	for item, i in array
		
		# if item is active and not last element in array, set current item to inactive and next item to active
		if item.active && i > firstIndex
			previousItem = i-1
			item.active = false
			array[previousItem].active = true
			return previousItem
		
		# if item is active and is the last element, set current item to false and first element to active
		else if item.active && i == firstIndex
			previousItem = lastIndex
			item.active = false
			array[lastIndex].active = true
			return previousItem

nextState = () =>
	for circle, i in circleLayers
		if circle.states.previous.name == "default"
			if i == 0
				circle.stateCycle("fourth")
			if i == 1
				circle.stateCycle("first")
			if i == 2
				circle.stateCycle("second")
			if i == 3
				circle.stateCycle("third")
		else
			if circle.states.current.name == "first"
				circle.stateCycle("fourth")
			else if circle.states.current.name == "second"
				circle.stateCycle("first")
			else if circle.states.current.name == "third"
				circle.stateCycle("second")
			else if circle.states.current.name == "fourth"
				circle.stateCycle("third")
		
previousState = () =>
	for circle in circleLayers
		circle.stateCycle()	
	
omitKey = (array, value) =>
	states = []
	
	for item in array
		state = _.omit(item, value)
		states.push(state)
	
	return states

## CODE ##

circleLayers = []
states = omitKey(circles, "backgroundColor")

circleContainer = new Layer
	backgroundColor: "#ffffff"
	width: 200
	height: 290
	x: Align.center
	y: Align.center

for circle, i in circles
	circle = new Layer
		parent: circleContainer
		name: circle.name
		x: circle.x
		y: circle.y
		width: circle.width
		height: circle.height
		borderRadius: circle.borderRadius
		backgroundColor: circle.backgroundColor
		opacity: circle.opacity
	
	text = new TextLayer
		name: "text"
		text: circle.name
		parent: circle
		color: "#ffffff"
		fontSize: 14
	
	delete circle.states.default
	circle.states =
		first: states[0]
		second: states[1]
		third: states[2]
		fourth: states[3]
	
	if (i == 0)
		circle.stateSwitch(states[0].name)
	else if (i == 1)
		circle.stateSwitch(states[1].name)
	else if (i == 2)
		circle.stateSwitch(states[2].name)
	else if (i == 3)
		circle.stateSwitch(states[3].name)
	
	circleLayers.push(circle)

## Set first circle dragable		
setDragableCircle()