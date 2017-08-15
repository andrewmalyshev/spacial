local ScreenTouchController={}

function ScreenTouchController:createController()
local  _W = display.contentWidth; -- Get the width of the screen
local  _H = display.contentHeight; -- Get the height of the screen
local  _MAX_FORCE = 20
local  _FORCE_FACTOR = 4
local force = 0
local side = 0
local needToMove = false
local touchCount = 0

function moveShip( event )
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

function handleEnterFrame( event )
    if ( needToMove == true ) then
        moveShip( event )
    end
end

function moveShipListener(event)
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
end
  return ScreenTouchController
