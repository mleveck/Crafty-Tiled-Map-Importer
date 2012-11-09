Crafty.c "TiledLevel",
    makeTiles : (ts, drawType) ->
        {image: tsImage, firstgid: tNum, imagewidth: tsWidth} =ts
        {imageheight: tsHeight, tilewidth: tWidth, tileheight: tHeight} = ts
        {tileproperties: tsProperties} = ts
        #console.log ts
        xCount = tsWidth/tWidth | 0
        yCount = tsHeight/tHeight | 0
        sMap = {}
        #Crafty.load [tsImage], ->
        for i in [0...yCount * xCount] by 1
            #console.log _ref
            posx = i % xCount
            posy = i / xCount | 0 
            sName = "tileSprite#{tNum}"
            tName = "tile#{tNum}"
            sMap[sName] = [posx, posy]
            components = "2D, #{drawType}, #{sName}, MapTile"
            if tsProperties
                if tsProperties[tNum - 1]
                    if tsProperties[tNum - 1]["components"]
                        components += ", #{tsProperties[tNum - 1]["components"]}"
            #console.log components
            Crafty.c tName,
                comp: components
                init: ->
                    @addComponent(@comp)
                    @
            tNum++ 
        #console.log sMap
        Crafty.sprite(tWidth, tHeight, tsImage, sMap)
        return null

    makeLayer : (layer) ->
        #console.log layer
        {data: lData, width: lWidth, height: lHeight} = layer
        for tDatum, i in lData
            if tDatum
                tile = Crafty.e "tile#{tDatum}"
                tile.x = (i % lWidth) * tile.w
                tile.y = (i / lWidth | 0) * tile.h
                #tile.attr({x: (i % lWidth) * tile.w, y: (i  / lWidth | 0) * tile.h})
                #console.log "#{tile.x} #{tile.y}"
        return null

    tiledLevel : (levelURL, drawType) ->
        $.ajax
            type: 'GET'
            url: levelURL
            dataType: 'json'
            data: {}
            async: false
            success: (level) =>
                #console.log level
                {layers: lLayers, tilesets: tss} = level
                drawType = drawType ? "Canvas"
                tsImages = for ts in tss
                    ts.image
                Crafty.load tsImages, =>
                    @makeTiles(ts, drawType) for ts in tss
                    @makeLayer(layer) for layer in lLayers
                    @trigger("TiledLevelLoaded")
                    return null
                return null
        return @
    init: -> @