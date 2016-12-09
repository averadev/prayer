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

-- Variables
local scCalendar, bgSelected
local favDays = {}
---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
function favoriteDays( items )

    for i = 1, #items, 1 do
        local item = items[i]
        local liked = false
        if (item.fav == 1) then
            liked = true
        end
        print(item.day)
        favDays[i] = {
            id_day = item.id_day,
            day = item.weekday,
            noDate = item.day,
            month = item.month,
            date = item.day_date,
            title = item.day_shortdesc,
            subtitle = item.day_shortdesc,
            file = item.audio,
            fav = liked,
            detail = item.day_longdesc
        }
    end

    getDates(favDays)
    
end

-------------------------------------
-- getDates
-- @param items objeto evento
------------------------------------
function getDates(items)
    local z = 0
    local isLeft = true
    for i = 1, #items, 1 do 
        -- Contenedor del Reward
        local card = display.newContainer( 200, 230 )
        if isLeft then
            z = z + 1
            card:translate( 130, (250*z) - 120 )
        else
            card:translate( 355, (250*z) - 120 )
        end
        scCalendar:insert( card )

        local bg = display.newRect(0, -5, 200, 220 )
        bg:setFillColor( unpack(cWhite) )
        card:insert( bg )
        
        -- Contenido
        local lblNoDate = display.newText({
            text = items[i].noDate,
            y = -90, width = 160,
            font = fMonRegular, 
            fontSize = 35, align = "left"
        })
        lblNoDate:setFillColor( unpack(cPurple) )
        card:insert(lblNoDate)
        
        local lblMonth = display.newText({
            text = items[i].month,
            y = -65, width = 160,
            font = fMonRegular, 
            fontSize = 17, align = "left"
        })
        lblMonth:setFillColor( unpack(cPurple) )
        card:insert(lblMonth)
        
        local lblTitle = display.newText({
            text = items[i].title,
            y = 0, width = 160,
            font = fMonRegular, 
            fontSize = 19, align = "left"
        })
        lblTitle:setFillColor( unpack(cPurple) )
        card:insert(lblTitle)

        -- Boton de accion
        local bgB1 = display.newRoundedRect(0, 90, 200, 50, 7 )
        bgB1:setFillColor( unpack(cPurple) )
        bgB1.screen = "Card"
        bgB1.item = i
        bgB1.animation = 'slideLeft'
        bgB1:addEventListener( 'tap', toScreen)
        card:insert( bgB1 )

        local bgB2 = display.newRect(0, 70, 200, 10 )
        bgB2:setFillColor( unpack(cPurple) )
        card:insert( bgB2 )
        
        local lblAction = display.newText({
            text = 'IR A AUDIO',
            y = 90,
            font = fMonRegular, 
            fontSize = 18, align = "center"
        })
        lblAction:setFillColor( unpack(cWhite) )
        card:insert(lblAction)
        
        isLeft = not(isLeft)
    end
end
function messageNoFav()
    --bgSelected:removeSelf();
    tools:setLoading( false, groupLoading )
    
    if not groupLoading then
        groupLoading = display.newGroup()
        screen:insert( groupLoading )
    end
    
    groupLoading.y =  70 + h
    
    local lblNoConnection = display.newText({
        text = "No hay favoritos",
        y = 110,
        x = midW, width = intW-100,
        font = fMonRegular, 
        fontSize = 20, align = "center"
    })
    lblNoConnection:setFillColor( unpack(cBlack) )
    groupLoading:insert(lblNoConnection)
    
    
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
    screen:insert(scCalendar)
    
    -- bgSelected = display.newRoundedRect( 130, 130, 210, 240, 5 )
    -- bgSelected.alpha = .8
    -- bgSelected:setFillColor( unpack(cBlack) )
    -- scCalendar:insert(bgSelected)
    
    local favDays = DBManager.getAudiosFav()
    if not favDays then
        messageNoFav()
    elseif #favDays > 0 then
        favoriteDays(favDays)
        scCalendar:setScrollHeight(((250 * #favDays) / 2) + 10)
    end
    -- favoriteDays(getAudios)
    
    
    -- Set new scroll position
    
end	

-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then
        local res = idxC % 2
        local posY = (idxC + res) / 2
        posY = (250 * posY) - 120
        
        -- if res == 1 then
        --     bgSelected.x = 130
        -- else
        --     bgSelected.x = 355
        -- end
        -- bgSelected.y = posY
        
        local toY = (posY * -1) + 130
        scCalendar:scrollToPosition({
            y = toY,
            time = 0
        })
        
        if idxP > 0 then
            tools:getIcon()            
        end
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