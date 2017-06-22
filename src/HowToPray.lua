-- Includes
require( "src.Tools" )
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.resources.Globals" )
local DBManager = require( "src.resources.DBManager" )
local RestManager = require( "src.resources.RestManager" )

--
local screen
local tools = Tools:new()
local scene = composer.newScene()
local posY = 0

--
function scene:create( event )
	screen = self.view

	-- Background Toolbar
	tools:buildHeader()
	screen:insert( tools )

	-- Background
	local bgHowToPray = display.newRect( midW, h+70, intW, intH )
	bgHowToPray.anchorY = 0
	bgHowToPray:setFillColor( gradientGold )
	screen:insert( bgHowToPray )

	-- Label How To Pray
	local labelHowToPray = display.newText({
		text = "¿Comó Orar?",
		x = midW,
		y = h+95, width = intW-50,
		font = fMonRegular,
		fontSize = 20, align = "center"
	})
	labelHowToPray:setFillColor( unpack(cWhite) )
	screen:insert( labelHowToPray )

	scContainerScroll = widget.newScrollView({
		top = h + 130,
		left = 0,
		width = intW,
		height = intH - (h + 70),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
	})

	-- Label Description How To Pray
	local labelDescHowToPray = display.newText({
		text = "Lorem ipsum dolor sit amet, sint nostrud splendide in eam, laudem conclusionemque cu sea. Qui dolor posidonium et. Primis iuvaret nominati eos te, duo at nostro prompta consequuntur. Duis dolores ex quo.\n\nEu nisl mollis eripuit vim. Eum eu corrumpit intellegat. Nam dicat concludaturque ex, sea at affert congue. Te sit lorem dicat etiam, exerci nostro albucius sea ei. Te melius mentitum suscipiantur sed. Hinc assueverit ad usu.\n\nQuis ignota epicuri ei vim, te abhorreant constituam qui.\n\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
		x = midW, width = 420,
		y = 20,
		font = fMonRegular,
		fontSize = 16, align = "left"
	})
	labelDescHowToPray.anchorY = 0
	local posY = 135 + labelDescHowToPray.height
	scContainerScroll:setScrollHeight( labelDescHowToPray.height + posY + 100 )

	labelDescHowToPray:setFillColor( unpack( cBlack ) )
	scContainerScroll:insert( labelDescHowToPray )
	screen:insert( scContainerScroll )

end

function scene:show( event )
	if event.phase == "will" then
	end
end

-- Remove Listener Event
function scene:destroy( event )
	--
end

-- Listener Event
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )

-- Return variable scene
return scene