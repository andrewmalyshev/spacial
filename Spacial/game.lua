-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
local physics = require( "physics" )
system.activate( "multitouch" )

-- Set Variables
 _W = display.contentWidth; -- Get the width of the screen
 _H = display.contentHeight; -- Get the height of the screen
 _MAX_FORCE = 20
 _FORCE_FACTOR = 4

physics.start()
physics.setGravity(0,0)

-- VIRTUAL CONTROLLER CODE
----------------------------------------------------------------------------------------
-- This line brings in the controller which basically acts like a class
-- local factory = require("controller.virtual_controller_factory")
-- local controller = factory:newController()
--
-- local function setupController(displayGroup)
-- 	local jsProperties = {
-- 		nToCRatio = 0.5,
-- 		radius = 30,
-- 		x = display.contentWidth - 50,
-- 		y = display.contentHeight - 10,
-- 		restingXValue = 0,
-- 		restingYValue = 0,
-- 		rangeX = 600,
-- 		rangeY = 600,
-- 		touchHandler = {
-- 			onTouch = moveShip
-- 		}
-- 	}
-- 	local jsName = "js"
-- 	js = controller:addJoystick(jsName, jsProperties)
-- 	controller:displayController(displayGroup)
-- end
--
-- function moveShip(self, x, y)
-- 	ship:setLinearVelocity(x, y)
-- end
----------------------------------------------------------------------------------------
-- END VIRTUAL CONTROLLER CODE

-- -----------------------------------------------------------------------------------
-- Ship control
-- -----------------------------------------------------------------------------------
local force = 0
local side = 0
local needToMove = false
local touchCount = 0

local function moveShip( event )
    force = force + _FORCE_FACTOR
    if force >= _MAX_FORCE then
      force = _MAX_FORCE
    end

    ship:rotate(side * 2)

    local rotation = math.rad(ship.rotation)
    local xPart = math.sin(rotation)
    local yPart = math.cos(rotation)
    print( "x: " .. xPart .. " y: " .. yPart )
    -- ship:applyLinearImpulse( force * xPart, -force * yPart, ship.x, ship.y )
    ship:applyForce(force * xPart, -force * yPart, ship.x, ship.y)
end

local function handleEnterFrame( event )
    if ( needToMove == true ) then
        moveShip( event )
    end
end

local function moveShipListener(event)
    local ship = event.target
    local phase = event.phase

    if (event.x >= _W/2) then
      side = 1
    else
      side = -1
    end

    if ( "began" == phase ) then
        needToMove = true
        touchCount = touchCount + 1
    elseif ( "ended" == phase or "cancelled" == phase ) then
        needToMove = false
        force = 0
        touchCount = touchCount - 1
    end

    if (touchCount >= 2) then side = 0 end

    return true
  end

-- -----------------------------------------------------------------------------------
-- Gravity
-- -----------------------------------------------------------------------------------
local function collideWithField( self, event )
    local objectToPull = event.other

    if ( event.phase == "began" and objectToPull.touchJoint == nil ) then
        -- Create touch joint after short delay (10 milliseconds)
        timer.performWithDelay( 10,
            function()
                -- Create touch joint
                objectToPull.touchJoint = physics.newJoint( "touch", objectToPull, objectToPull.x, objectToPull.y )
                -- Set physical properties of touch joint
                objectToPull.touchJoint.frequency = fieldPower
                objectToPull.touchJoint.dampingRatio = 0.0
                -- Set touch joint "target" to center of field
                objectToPull.touchJoint:setTarget( self.x, self.y )
            end
        )
    elseif ( event.phase == "ended" and objectToPull.touchJoint ~= nil ) then
        objectToPull.touchJoint:removeSelf()
        objectToPull.touchJoint = nil
    end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, planets, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group


  -- setupController(uiGroup)
	-- Load the background
	background = display.newImageRect( backGroup, "spaceBackground.png", 1080, 1920)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

  -- Load the ship
  ship = display.newImageRect( mainGroup, "spaceShip.png", 17, 35)
  ship.x = display.contentCenterX
  ship.y = display.contentCenterY + 200
  physics.addBody(ship,  "dynamic", {radius=17, density = 10})
  ship.myName = "ship"

 -- Load planet
  planet = display.newImageRect( mainGroup, "planetImage.png", 65, 65)
  planet.x = display.contentCenterX
  planet.y = display.contentCenterY
  physics.addBody(planet, "static", {radius = 32})
  planet.myName = "planet"

  fieldPower = 0.2
  field = display.newCircle(mainGroup, planet.x, planet.y, 100)
  field.alpha = 0.2
  -- Add physical body (sensor) to field
  physics.addBody( field, "static", { isSensor=true, radius=fieldRadius } )
  field.collision = collideWithField
  field:addEventListener( "collision" )

  background:addEventListener("touch", moveShipListener)
  Runtime:addEventListener("enterFrame", handleEnterFrame)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
    Runtime:addEventListener( "enterFrame", handleEnterFrame )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		physics.pause()
    Runtime:removeEventListener( "enterFrame", handleEnterFrame )
		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  -- controller = nil
end
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
return scene
