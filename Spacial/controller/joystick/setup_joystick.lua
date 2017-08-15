local SetupJoystick = {}

function SetupJoystick:createController()
   factory = require("controller.joystick.virtual_controller_factory")
   controller = factory:newController()

  function moveShip(self, x, y)
	   ship:setLinearVelocity(x, y)
  end
end

function SetupJoystick:setupController(displayGroup)
   local jsProperties = {
       nToCRatio = 0.5,
       radius = 30,
       x = display.contentWidth - 50,
       y = display.contentHeight - 10,
       restingXValue = 0,
       restingYValue = 0,
       rangeX = 600,
       rangeY = 600,
       touchHandler = {onTouch = moveShip}
    }
    local jsName = "js"
    js = controller:addJoystick(jsName, jsProperties)
    controller:displayController(displayGroup)
  end

return SetupJoystick
