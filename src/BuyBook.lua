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
	local bgBuyBook = display.newRect( midW, h, intW, intH )
	bgBuyBook.anchorY = 0
	bgBuyBook:setFillColor( gradientGold )
	screen:insert( bgBuyBook )

	-- Label Buy Book
	local labelBuyBook = display.newText({
		text = "Comprar Libro",
		x = midW,
		y = h+95, width = intW-50,
		font = fMonRegular,
		fontSize = 20, align = "center"
	})
	labelBuyBook:setFillColor( unpack(cWhite) )
	screen:insert( labelBuyBook )

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

	-- Label Description Buy Book
	local labelDescHowToPray = display.newText({
		text = "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas Letraset, las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejemplo Aldus PageMaker, el cual incluye versiones de Lorem Ipsum.",
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