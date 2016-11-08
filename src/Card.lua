---------------------------------------------------------------------------------
-- Oraciones
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Audio')
require('src.Tools')
require('src.Globals')
local composer = require( "composer" )

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local idx
local audios = {}

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------


-------------------------------------
-- Tmp
-- @param event objeto evento
------------------------------------
function tmp(event)
    
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    idx = event.params.item
    
    local bgScr = display.newRect( midW, h, intW, intH )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cGrayL) )
    screen:insert(bgScr)
    
    -- Background
	tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
    
    local item = lstDays[idx]
    -- Navigation
    local bgScr = display.newRect( midW, h + 70, intW, 80 )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cWhite) )
    screen:insert(bgScr)
    if idx > 1 then
        local bgNavYes = display.newRect(midW - 150, h+100, 150, 50 )
        bgNavYes:setFillColor( unpack(cWhite) )
        bgNavYes.screen = "Card"
        bgNavYes.item = idx - 1
        bgNavYes.animation = 'slideLeft'
        bgNavYes:addEventListener( 'tap', toScreen)
        screen:insert( bgNavYes )

        local lblNavYes = display.newText({
            text = lstDays[idx - 1].day,
            y = h+100,
            x = midW - 180, width = 120,
            font = fMonRegular, 
            fontSize = 16, align = "right"
        })
        lblNavYes:setFillColor( unpack(cPurple) )
        screen:insert(lblNavYes)

        local imgNavLeft = display.newImage("img/iconArrow.png")
        imgNavLeft:translate(midW - 90, h+100)
        screen:insert( imgNavLeft )
    end

    local lblNavToday = display.newText({
        text = item.day,
        y = h+100,
        x = midW, width = 150,
        font = fMonRegular, 
        fontSize = 24, align = "center"
    })
    lblNavToday:setFillColor( unpack(cPurple) )
    screen:insert(lblNavToday)

    if idx < #lstDays then

        local bgNavTom = display.newRect(midW + 150, h+100, 150, 50 )
        bgNavTom:setFillColor( unpack(cWhite) )
        bgNavTom.screen = "Card"
        bgNavTom.item = idx + 1
        bgNavTom.animation = 'slideLeft'
        bgNavTom:addEventListener( 'tap', toScreen)
        screen:insert( bgNavTom )

        local lblNavTom = display.newText({
            text = lstDays[idx + 1].day,
            y = h+100,
            x = midW + 175, width = 120,
            font = fMonRegular, 
            fontSize = 16, align = "left"
        })
        lblNavTom:setFillColor( unpack(cPurple) )
        screen:insert(lblNavTom)

        local imgNavTom = display.newImage("img/iconArrow.png")
        imgNavTom:translate(midW + 85, h+100)
        imgNavTom.rotation = 180
        screen:insert( imgNavTom )
    end 
    
    audios[idx] = Audio:new()
    audios[idx]:build(item)
     
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