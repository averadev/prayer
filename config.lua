---------------------------------------------------------------------------------
-- Oraciones
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local mediaRes = display.pixelWidth  / 480

application = {
	content = {
		width = display.pixelWidth / mediaRes,
        height = display.pixelHeight / mediaRes
	}
}
settings =
{
   android =
   {
      usesPermissions =
      {
         "android.permission.INTERNET",
      },
   },
}