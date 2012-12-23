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

    makeLayer : (layer, layerNum) ->
        #console.log layer
        {data: lData, width: lWidth, height: lHeight} = layer
        layerDetails = {tiles:[], width:lWidth, height:lHeight}

        for tDatum, i in lData
            if tDatum
                tile = Crafty.e "tile#{tDatum}"
                tile.x = (i % lWidth) * tile.w
                tile.y = (i / lWidth | 0) * tile.h
                #tile.attr({x: (i % lWidth) * tile.w, y: (i  / lWidth | 0) * tile.h})
                #console.log "#{tile.x} #{tile.y}"
                layerDetails.tiles[i] = tile

        @_layerArray[layerNum] = layerDetails;
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
                    @makeLayer(layer, layerNum) for layer, layerNum in lLayers
                    @trigger("TiledLevelLoaded", this)
                    return null
                return null
        return @
        
    getTile: (r,c,l=0)->
        layer = @_layerArray[l]
        return null if not layer? or r < 0 or r>=layer.height or c<0 or c>=layer.width
        tile = layer.tiles[c + r*layer.width]
        
        if tile
            return tile
        else
            return undefined

    init: -> 
        @_layerArray = []
        @
