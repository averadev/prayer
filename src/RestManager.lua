---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
    local DBManager = require('src.DBManager')
    local dbConfig = DBManager.getSettings()

    local site = "http://localhost/prayer_ws/"
    --local site = "http://mytuki.com/api/"
	
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end

    function reloadConfig()
        dbConfig = DBManager.getSettings()
    end

    RestManager.getAudios = function()
		local url = site.."mobile/getAudios/format/json"
        local deviceID = system.getInfo( "deviceID" )
        url = url.."/idDevice/"..urlencode(deviceID)
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                --data.items
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	
return RestManager