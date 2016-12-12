---------------------------------------------------------------------------------
-- Oraciones
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

local Sprites = {}

Sprites.loading = {
  source = "img/sprLoading.png",
  frames = {width=35, height=35, numFrames=12},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=1500, start = 1, count=12}
  }
}

Sprites.liked = {
  source = "img/sprFav.png",
  frames = {width=50, height=50, numFrames=2},
  sequences = {
      { name = "dislike", loopCount = 1, start = 1, count=1},
      { name = "like", time=1500, start = 2, count=1}
  }
}


return Sprites