---------------------------------------------------------------------------------
-- Oraciones
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
local composer = require( "composer" )
local Globals = require( "src.resources.Globals" )

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-------------------------------------
-- Tmp
-- @param event objeto evento
------------------------------------
function dayPray(event)
    composer.gotoScene("src.Card", { time = 400, effect = "slideLeft", params = { item = 8 } } )
end
function favoriteDays(event)
    composer.gotoScene("src.FavDays", { time = 400, effect = "slideLeft", params = { item = nil } } )
end

function setTapListener(posicion, elemento)
    if posicion == 1 then
        elemento:addEventListener( 'tap', dayPray)
    end
    if posicion == 2 then
        elemento:addEventListener( 'tap', favoriteDays)
    end
    if posicion == 3 then
        elemento:addEventListener( 'tap', dayPray)
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    
    local bgScr = display.newRect( midW, h, intW, intH )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cGrayL) )
    screen:insert(bgScr)
    
    local lblTitle = display.newText({
        text = 'MENÚ',
        y = h+40,
        x = midW, width = 150,
        font = fMonRegular, 
        fontSize = 24, align = "center"
    })
    lblTitle:setFillColor( unpack(cBlack) )
    screen:insert(lblTitle)
    
    local bgReturn = display.newRect( 410, h+40, 120, 30 )
    bgReturn:setFillColor( unpack(cGrayL) )
    bgReturn:addEventListener( 'tap', toPrevious)
    screen:insert(bgReturn)
    
    local lblRegresar = display.newText({
        text = 'REGRESAR',
        y = h+40,
        x = 460, width = 200,
        font = fMonRegular, 
        fontSize = 18, align = "right"
    })
    lblRegresar.anchorX = 1
    lblRegresar:setFillColor( unpack(cPurple) )
    screen:insert(lblRegresar)
    
    local menuY = h + 80
    local menuA = {
        {'iconDay','DayPray','Oración del Día'},
        {'iconConfig','DayPray','Favoritos'},
        {'iconHow','HowPray','¿Comó Orar?'},
        {'iconDonation','Donation','Donaciones'},
        {'iconConfig','Config','Configuración'}}
    
    for i = 1, #menuA, 1 do 
        local bgM1 = display.newRect( midW, menuY, 480, 80 )
        bgM1.anchorY = 0
        bgM1.alpha = .5
        bgM1:setFillColor( unpack(cPurple) )
        screen:insert(bgM1)
        
        local bgM2 = display.newRect( midW, menuY + 1, 480, 78 )
        bgM2.anchorY = 0
        bgM2:setFillColor( unpack(cWhite) )
        screen:insert(bgM2)
        
        local icon = display.newImage("img/"..menuA[i][1]..".png")
        icon:translate(90, menuY + 40)
        screen:insert( icon )
    
        local lblMenu = display.newText({
            text = menuA[i][3],
            y = menuY + 40,
            x = 330, width = 200,
            font = fMonRegular, 
            fontSize = 20, align = "left"
        })
        lblMenu.anchorX = 1
        lblMenu:setFillColor( unpack(cPurple) )
        screen:insert(lblMenu)
        
        setTapListener(i, bgM2)
        
        menuY = menuY + 110
    end
    
    -- Redes Sociales
    local lblSiguenos = display.newText({
        text = "Síguenos en:",
        y = intH - 83,
        x = midW, width = 200,
        font = fMonRegular, 
        fontSize = 20, align = "center"
    })
    lblSiguenos:setFillColor( unpack(cPurple) )
    screen:insert(lblSiguenos)
    
    local iconWeb = display.newImage("img/iconSWeb.png")
    iconWeb:translate(midW - 80, intH - 35)
    screen:insert( iconWeb )
    
    local iconSFB = display.newImage("img/iconSFB.png")
    iconSFB:translate(midW, intH - 35)
    screen:insert( iconSFB )
    
    local iconSTW = display.newImage("img/iconSTW.png")
    iconSTW:translate(midW + 80, intH - 35)
    screen:insert( iconSTW )
    
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