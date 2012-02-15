var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Crafty.c("TiledLevel", {
  makeTiles: function(ts, drawType) {
    var components, posx, posy, sMap, sName, tHeight, tName, tNum, tWidth, tsHeight, tsImage, tsProperties, tsWidth, xCount, yCount, _ref;
    tsImage = ts.image, tNum = ts.firstgid, tsWidth = ts.imagewidth;
    tsHeight = ts.imageheight, tWidth = ts.tilewidth, tHeight = ts.tileheight;
    tsProperties = ts.tileproperties;
    xCount = tsWidth / tWidth | 0;
    yCount = tsHeight / tHeight | 0;
    sMap = {};
    Crafty.load([tsImage], function() {});
    for (posy = 0; posy < yCount; posy += 1) {
      for (posx = 0; posx < xCount; posx += 1) {
        sName = "tileSprite" + tNum;
        tName = "tile" + tNum;
        sMap[sName] = [posx, posy];
        components = "2D, " + drawType + ", " + sName + ", MapTile";
        if (((_ref = tsProperties[tNum - 1]) != null ? _ref["components"] : void 0) != null) {
          components += ", " + tsProperties[tNum - 1]["components"];
        }
        Crafty.c(tName, {
          comp: components,
          init: function() {
            this.addComponent(this.comp);
            return this;
          }
        });
        tNum++;
      }
    }
    Crafty.sprite(tWidth, tHeight, tsImage, sMap);
    return null;
  },
  makeLayer: function(layer) {
    var i, lData, lHeight, lWidth, tDatum, tile, _len;
    lData = layer.data, lWidth = layer.width, lHeight = layer.height;
    for (i = 0, _len = lData.length; i < _len; i++) {
      tDatum = lData[i];
      if (tDatum) {
        tile = Crafty.e("tile" + tDatum);
        tile.attr({
          x: (i % lWidth) * tile.w,
          y: (i / lWidth | 0) * tile.h
        });
      }
    }
    return null;
  },
  tiledLevel: function(levelURL, drawType) {
    $.getJSON(levelURL, __bind(function(level) {
      var lLayers, layer, ts, tss, _i, _j, _len, _len2;
      lLayers = level.layers, tss = level.tilesets;
      drawType = drawType != null ? drawType : "Canvas";
      for (_i = 0, _len = tss.length; _i < _len; _i++) {
        ts = tss[_i];
        this.makeTiles(ts, drawType);
      }
      for (_j = 0, _len2 = lLayers.length; _j < _len2; _j++) {
        layer = lLayers[_j];
        this.makeLayer(layer);
      }
      return null;
    }, this));
    return this;
  },
  init: function() {
    return this;
  }
});
