-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Set up display groups
local backGroup = display.newGroup()  -- Display group for the background image
local mainGroup = display.newGroup()  -- Display group for the ship, planets, etc.
local uiGroup = display.newGroup()    -- Display group for UI objects like the score

local physics = require( "physics" )
physics.start()
physics.setGravity(0,0)

local background = display.newImageRect( backGroup, "spaceBackground.png", 1080, 1920)

local ship = display.newImageRect( mainGroup, "spaceShip.png", 35, 70)
ship.x = display.contentCenterX
ship.y = display.contentCenterY

physics.addBody(ship, "dynamic", {radius=70})

ship.myName = "ship"

local function moveShip( event )
    ship:applyLinearImpulse( 0, -0.003, ship.x, ship.y )

    print(ship.y)
end

local needToMove = false
local function handleEnterFrame( event )
    if ( needToMove == true ) then
        moveShip()
    end
end
Runtime:addEventListener( "enterFrame", handleEnterFrame )

local function moveShipListener(event)
    local ship = event.target
    local phase = event.phase
 
    if ( "began" == phase ) then
        needToMove = true
    elseif ( "ended" == phase or "cancelled" == phase ) then
        needToMove = false
    end
    return true
end

background:addEventListener("touch", moveShipListener)