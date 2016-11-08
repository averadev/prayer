---------------------------------------------------------------------------------
-- Oraciones
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------


display.setStatusBar( display.DarkStatusBar )
display.setDefault( "background", 1, 1, 1 )


require('src.Globals')
local composer = require( "composer" )

-- Temporal
local tmpDay = -4
local DAY = 86400
local now = os.time()
local curTime = 0
-- Dias de la semana
for i = 1, #lstDays, 1 do 
    curTime = now + (DAY * tmpDay)
    lstDays[i].day = lstDay[os.date( '%w', curTime ) + 1]
    lstDays[i].noDate = os.date( '%d', curTime )
    lstDays[i].month = lstMonth[tonumber(os.date( '%m', curTime ))]
    if tmpDay == 0 then lstDays[i].day = 'Hoy' end 
    tmpDay = tmpDay + 1
end


--composer.gotoScene("src.Calendar")
composer.gotoScene("src.Card", {params = { item = 5 }} )

--[[
local systemFonts = native.getFontNames()
for i, fontName in ipairs( systemFonts ) do
     print( "Font Name = " .. tostring( fontName ) )
end
]]