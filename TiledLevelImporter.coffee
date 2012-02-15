Crafty.c "TiledLevel",
    makeTiles : (ts, drawType) ->
        {image: tsImage, firstgid: tNum, imagewidth: tsWidth} =ts
        {imageheight: tsHeight, tilewidth: tWidth, tileheight: tHeight} = ts
        {tileproperties: tsProperties} = ts
        xCount = tsWidth/tWidth | 0
        yCount = tsHeight/tHeight | 0
        sMap = {}
        Crafty.load [tsImage], ->
        for posy in [0...yCount] by 1
            for posx in [0...xCount] by 1
                sName = "tileSprite#{tNum}"
                tName = "tile#{tNum}"
                sMap[sName] = [posx, posy]
                components = "2D, #{drawType}, #{sName}, MapTile"
                components += ", #{tsProperties[tNum - 1]["components"]}" if tsProperties[tNum - 1]?["components"]?
                Crafty.c tName,
                    comp: components
                    init: ->
                        @addComponent(@comp)
                        @
                tNum++ 
        Crafty.sprite(tWidth, tHeight, tsImage, sMap)
        return null

    makeLayer : (layer) ->
        {data: lData, width: lWidth, height: lHeight} = layer
        for tDatum, i in lData
            if tDatum
                tile = Crafty.e "tile#{tDatum}"
                tile.attr({x: (i % lWidth) * tile.w, y: (i  / lWidth | 0) * tile.h})
        return null

    tiledLevel : (levelURL, drawType) ->
        $.getJSON levelURL, (level) =>
            {layers: lLayers, tilesets: tss} = level
            drawType = drawType ? "Canvas"
            @makeTiles(ts, drawType) for ts in tss
            @makeLayer(layer) for layer in lLayers
            return null
        return @
    init: -> @