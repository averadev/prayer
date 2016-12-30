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
function messageNoConnection()
    
    tools:setLoading( false, groupLoading )
    
    if not groupLoading then
        groupLoading = display.newGroup()
        screen:insert( groupLoading )
    end
    
    groupLoading.y =  70 + h
    
    local lblNoConnection = display.newText({
        text = "La aplicacion necesita conexion a internet",
        y = 110,
        x = midW, width = intW-100,
        font = fMonRegular, 
        fontSize = 20, align = "center"
    })
    lblNoConnection:setFillColor( unpack(cBlack) )
    groupLoading:insert(lblNoConnection)
    
    local btnNoConnection = display.newRoundedRect( midW, 250, intW - 50, 70, 5 )
    btnNoConnection:setFillColor( unpack(cPurple) )
    groupLoading:insert(btnNoConnection)
    btnNoConnection:addEventListener( 'tap', detectNetworkConnection )
    
    
    local lblRefresh = display.newText({
        text = "ACTUALIZAR",
        y = 250,
        x = midW, width = intW-100,
        font = fMonRegular, 
        fontSize = 20, align = "center"
    })
    lblRefresh:setFillColor( unpack(cWhite) )
    groupLoading:insert(lblRefresh)
    
end

function scene:create( event )
	screen = self.view
    
    local bgScr = display.newRect( midW, h, intW, intH )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cGrayL) )
    screen:insert(bgScr)
    
    -- Background
    tools:buildHeader()
    screen:insert(tools)
    
    scCalendar = widget.newScrollView(
    {
        top = h + 70,
		left = 0,
        width = intW,
        height = intH - (h + 70),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
    })
    local bgScr = display.newRect( midW, h, intW, 50 )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cPurple) )
    local lblRefresh = display.newText({
        text = "Eliminar Descargas",
        x = midW,
        y = h+30, width = intW-100,
        font = fMonRegular, 
        fontSize = 20, align = "center"
    })
    lblRefresh:setFillColor( unpack(cWhite) )
    scCalendar:insert(bgScr)
    scCalendar:insert(lblRefresh)
    screen:insert(scCalendar)
    
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
