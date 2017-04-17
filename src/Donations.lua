---------------------------------------------------------------------------------
-- Oraciones
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Tools')
local widget = require( "widget" )
local composer = require( "composer" )
local Globals = require( "src.resources.Globals" )
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local screen
local tools = Tools:new()
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    
    local bgScr = display.newRect( midW, h, intW, intH )
    bgScr.anchorY = 0
    bgScr:setFillColor( gradientGold )
    screen:insert(bgScr)

    -- Label Donations
    local labelDonations = display.newText({
        text = "Hacer una donación",
        x = midW,
        y = h+95, width = intW-50,
        font = fMonRegular,
        fontSize = 20, align = "center"
    })
    labelDonations:setFillColor( unpack(cWhite) )
    screen:insert( labelDonations )
    
    -- Background
    tools:buildHeader()
    screen:insert(tools)
    
    -- Scrollview
    scCalendar = widget.newScrollView(
    {
        top = h + 130,
		left = 0,
        width = intW,
        height = intH - (h + 70),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
    })

    -- Label Description Donations
    local labelDescDonations = display.newText({
        text = "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas Letraset, las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejemplo Aldus PageMaker, el cual incluye versiones de Lorem Ipsum.",
        x = midW, width = 420,
        y = 20,
        font = fMonRegular,
        fontSize = 16, align = "left"
    })
    labelDescDonations.anchorY = 0
    local posY = 135 + labelDescDonations.height
    scCalendar:setScrollHeight( labelDescDonations.height + posY + 100 )

    labelDescDonations:setFillColor( unpack( cBlack ) )
    scCalendar:insert( labelDescDonations )

    screen:insert(scCalendar)
    local webView = native.newWebView( display.contentCenterX, display.contentCenterY, 480, 680 )
	webView:request( "https://www.paypal.com/" )
    
end	

-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then
    	
    end
end

-- Remove Listener
function scene:destroy( event )
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )


return scene
