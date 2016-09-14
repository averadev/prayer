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
require('src.Globals')
local widget = require( "widget" )
local composer = require( "composer" )

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
function tmp(event)
    
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    local idx = event.params.item
    local item = lstDays[idx]
    
    local bgScr = display.newRect( midW, h, intW, intH )
    bgScr.anchorY = 0
    bgScr:setFillColor( unpack(cGrayL) )
    screen:insert(bgScr)
    
    -- Background
	tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
    
     -- Navigation
    local bgScr = display.newRect( midW, h+70, intW, 80 )
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
    
    local sc = widget.newScrollView(
    {
        top = h + 130,
		left = 0,
        width = intW,
        height = intH - (h + 70),
		horizontalScrollDisabled = true,
		backgroundColor = { unpack(cGrayL) }
    })
    screen:insert(sc)
    
    -- Actions
    local bgAct = display.newRect( midW, 0, intW, 70 )
    bgAct.anchorY = 0
    bgAct:setFillColor( unpack(cPurpleH) )
    sc:insert(bgAct)
    
    local iconADown = display.newImage("img/iconADown.png")
    iconADown:translate(intW - 120, 35)
    sc:insert( iconADown )
    
    local iconAFav = display.newImage("img/iconAFav.png")
    iconAFav:translate(intW - 45, 35)
    sc:insert( iconAFav )
    
    -- Desc Section
    local bgDesc = display.newRect( midW, 70, intW, 170 )
    bgDesc.anchorY = 0
    bgDesc:setFillColor( unpack(cPurple) )
    sc:insert(bgDesc)
    
    local lblDescDate = display.newText({
        text = item.noDate..' de '..item.month,
        y = 110,
        x = midW, width = 400,
        font = fMonRegular, 
        fontSize = 30, align = "left"
    })
    lblDescDate:setFillColor( unpack(cWhite) )
    sc:insert(lblDescDate)
    
    local lblDescTitle = display.newText({
        text = item.title,
        y = 155,
        x = midW, width = 400,
        font = fMonRegular, 
        fontSize = 30, align = "left"
    })
    lblDescTitle:setFillColor( unpack(cWhite) )
    sc:insert(lblDescTitle)
    
    local lblDescSubTitle = display.newText({
        text = item.subtitle,
        y = 200,
        x = midW, width = 400,
        font = fMonRegular, 
        fontSize = 22, align = "left"
    })
    lblDescSubTitle:setFillColor( unpack(cWhite) )
    sc:insert(lblDescSubTitle)
    
    -- Section Play
    local bgPlay = display.newRect( midW, 240, intW, 100 )
    bgPlay.anchorY = 0
    bgPlay:setFillColor( unpack(cWhite) )
    sc:insert(bgPlay)
    
    local iconHPlay = display.newImage("img/iconHPlay.png")
    iconHPlay:translate(midW, 290)
    sc:insert( iconHPlay )
    
    local iconPArrowL = display.newImage("img/iconPDArrow.png")
    iconPArrowL:translate(midW - 110, 290)
    sc:insert( iconPArrowL )
    
    local iconPArrowR = display.newImage("img/iconPDArrow.png")
    iconPArrowR:translate(midW + 110, 290)
    iconPArrowR.rotation = 180
    sc:insert( iconPArrowR )
   
    -- Progress Bar
    local bgBar = display.newRect( midW, 340, intW, 70 )
    bgBar.anchorY = 0
    bgBar:setFillColor( unpack(cPurpleH) )
    sc:insert(bgBar)
    
    local lblBarTCurrent = display.newText({
        text = '00.00',
        y = 375,
        x = midW-165, width = 100,
        font = fMonRegular, 
        fontSize = 18, align = "left"
    })
    lblBarTCurrent:setFillColor( unpack(cWhite) )
    sc:insert(lblBarTCurrent)
    
    local lblBarTTotal = display.newText({
        text = '45.00',
        y = 375,
        x = midW+165, width = 100,
        font = fMonRegular, 
        fontSize = 18, align = "right"
    })
    lblBarTTotal:setFillColor( unpack(cWhite) )
    sc:insert(lblBarTTotal)
    
    local bgBarT = display.newRect( midW, 375, 300, 1 )
    bgBarT.anchorY = 0
    bgBarT:setFillColor( unpack(cWhite) )
    sc:insert(bgBarT)
    
    local bgBarC = display.newRect( 90, 375, 120, 1 )
    bgBarC.anchorX = 0
    bgBarC.anchorY = 0
    bgBarC:setFillColor( unpack(cPurple) )
    sc:insert(bgBarC)
    
    -- Section Detail
    local lblDetail = display.newText({
        text = item.detail,
        y = 435,
        x = midW, width = 420,
        font = fMonRegular, 
        fontSize = 16, align = "left"
    })
    lblDetail.anchorY = 0
    lblDetail:setFillColor( unpack(cPurple) )
    sc:insert(lblDetail)
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