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

	-- Background
	local bgAuthor = display.newRect( midW, h, intW, intH )
	bgAuthor.anchorY = 0
	bgAuthor:setFillColor( gradientGold )
	screen:insert( bgAuthor )

	-- icon Menu
	local iconMenu = display.newImage("img/iconMenu.png")
    iconMenu:translate(40, 50)
    iconMenu.screen = "Menu"
    iconMenu.animation = 'slideRight'
    iconMenu:addEventListener( 'tap', toScreen)
    screen:insert( iconMenu )

	-- Label Name Author
	local labelNameAuthor = display.newText({
		text = "Padre Evaristo Sada, LC",
		x = midW,
		y = h+95, width = intW-50,
		font = fMonRegular,
		fontSize = 20, align = "center"
	})
	labelNameAuthor:setFillColor( unpack(cWhite) )
	screen:insert( labelNameAuthor )

	-- Background
	tools:buildHeader()
	screen:insert( tools )

	scContainerScroll = widget.newScrollView({
		top = h + 130,
		left = 0,
		width = intW,
		height = intH - (h + 70),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
	})

	-- Label Description Author
	local labelDescAuthor = display.newText({
		text = "Lorem ipsum dolor sit amet, sint nostrud splendide in eam, laudem conclusionemque cu sea. Qui dolor posidonium et. Primis iuvaret nominati eos te, duo at nostro prompta consequuntur. Duis dolores ex quo.\n\nEu nisl mollis eripuit vim. Eum eu corrumpit intellegat. Nam dicat concludaturque ex, sea at affert congue. Te sit lorem dicat etiam, exerci nostro albucius sea ei. Te melius mentitum suscipiantur sed. Hinc assueverit ad usu.\n\nQuis ignota epicuri ei vim, te abhorreant constituam qui.\n\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
		x = midW, width = 420,
		y = 20,
		font = fMonRegular,
		fontSize = 16, align = "left"
	})
	labelDescAuthor.anchorY = 0
	local posY = 135 + labelDescAuthor.height
	scContainerScroll:setScrollHeight(labelDescAuthor.height + posY + 100)

	labelDescAuthor:setFillColor( unpack(cBlack) )
	scContainerScroll:insert( labelDescAuthor )
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