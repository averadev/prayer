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
local composer = require( "composer" )
local Globals = require( "src.resources.Globals" )
local Sprites = require('src.resources.Sprites')

-- Grupos y Contenedores
local screen
local scene = composer.newScene()

-- Variables
local curPlay, btnPlay, curTime, curLblTime, cntTime, tmrPlaying, jumpProgress
local grpProgress, progressBar, progressFil, progressLine, lblCurTime
local iconP = {}
local isSeek = false


---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-------------------------------------
-- Play audio event
-- @param event objeto evento
------------------------------------
function tapPlay(event)
    -- Change design
    btnPlay:removeEventListener( 'tap', tapPlay)
    btnPlay.alpha = .5
    iconP["play"].alpha = 0
    iconP["loading"].alpha = 1
    iconP["loading"]:setSequence("play")
    iconP["loading"]:play()
    
    -- Listener on Ready
    local function videoListener( event )
        if event.phase == 'ready' then
            -- Change design
            iconP["pause"].alpha = 1
            iconP["loading"].alpha = 0
            iconP["loading"]:setSequence("play")
            -- Init and Call timer
            --[[
            cntTime = 0
            curTime = curPlay.totalTime
            jumpProgress = 300/ curTime
            curLblTime = secondsToClock(curTime)
            lblCurTime.text = '00:00 / '..curLblTime
            grpProgress.alpha = 1
            tmrPlaying = timer.performWithDelay( 1000, lstPlaying, 0 ) 
            ]]
        end
    end

    -- Load a remote audio
    curPlay = native.newVideo( display.contentCenterX, display.contentCenterY, 50, 50 )
    curPlay:load( "http://geekbucket.com.mx/angry_cockroaches.mp3", media.RemoteSource )
    curPlay:addEventListener( "video", videoListener )
    curPlay:play()
    return true
end

-------------------------------------
-- Jump on track
-- @param event objeto evento
------------------------------------
function touchSeek(event)
    if event.phase == "began" then
        isSeek = true
        progressLine.x = event.x
    elseif event.phase == "moved" and isSeek then
        progressLine.x = event.x
    elseif event.phase == "ended" then
        isSeek = false
    end
end

-------------------------------------
-- Calling every second
-- @param event objeto evento
------------------------------------
function lstPlaying(event)
    cntTime = cntTime + 1
    lblCurTime.text = secondsToClock(cntTime)..' / '..curLblTime
    if not(isSeek) then 
        progressLine.x = 125 + (jumpProgress*cntTime)
    end
    progressFil.width = 50 + (jumpProgress*cntTime)
    if curTime == cntTime then
        timer.cancel(tmrPlaying)
    end
end

-------------------------------------
-- Change seconds to clock format
-- @param event objeto evento
------------------------------------
function secondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00:00:00";
    elseif curTime < 3600 then
        mins = string.format("%02.f", math.floor(seconds/60));
        secs = string.format("%02.f", math.floor(seconds - mins *60));
        return mins..":"..secs
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours..":"..mins..":"..secs
    end
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:create( event )
	screen = self.view
    
    -- Background
	tools = Tools:new()
    tools:buildHeader()
    screen:insert(tools)
    
    grpProgress = display.newGroup()
    grpProgress.alpha = 0
    screen:insert(grpProgress)
    
    progressBar = display.newRoundedRect( 80, h+150, intW - 130, 80, 10 )
    progressBar.anchorX = 0
    progressBar.alpha = .3
    progressBar:setFillColor( .5 )
    grpProgress:insert(progressBar)
    grpProgress:addEventListener( 'touch', touchSeek)
    
    progressFil = display.newRect( 80, h+150, 50, 80 )
    progressFil.anchorX = 0
    progressFil.alpha = .5
    progressFil:setFillColor( .5 )
    grpProgress:insert(progressFil)
    
    progressLine = display.newRect( 125, h+150, 5, 80 )
    progressLine.anchorX = 0
    progressLine:setFillColor( .2 )
    grpProgress:insert(progressLine)
    
    lblCurTime = display.newText({
        text = '00:00 / 00:00',
        y = h+205,
        x = 350, width = 150,
        font = fMonRegular, 
        fontSize = 14, align = "right"
    })
    lblCurTime:setFillColor( unpack(cBlack) )
    grpProgress:insert(lblCurTime)
    
    btnPlay = display.newImage("img/btnCircle.png")
    btnPlay:translate(80, h + 150)
    screen:insert( btnPlay )
    btnPlay:addEventListener( 'tap', tapPlay)
    
    iconP["play"] = display.newImage("img/iconPlay.png")
    iconP["play"]:translate(85, h+150)
    screen:insert( iconP["play"] )
    
    iconP["pause"] = display.newImage("img/iconPause.png")
    iconP["pause"]:translate(80, h+150)
    iconP["pause"].alpha = 0
    screen:insert( iconP["pause"] )
    
    local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
    iconP["loading"] = display.newSprite(sheet, Sprites.loading.sequences)
    iconP["loading"].x = 80
    iconP["loading"].y = h+150
    iconP["loading"].alpha = 0
    screen:insert(iconP["loading"])
    
    cntTime = 0
    curTime = 230
    grpProgress.alpha = 1
    jumpProgress = 300/ curTime
    curLblTime = secondsToClock(curTime)
    lblCurTime.text = '00:00 / '..curLblTime
    tmrPlaying = timer.performWithDelay( 1000, lstPlaying, 0 )
    
end	

-- Called immediately after scene has moved onscreen:
function scene:show( event )
    if event.phase == "will" then
        Globals.scenes[#Globals.scenes + 1] = composer.getSceneName( "current" ) 
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