debug = Debug('app:model:Image')

pathUtil = require('path')
fs = require('graceful-fs')

class Image
  constructor: (@localPath, @name, @size) ->
  toJson: ->
    _.pick this, 'name', 'size'

Image.create = (fullname, callback) ->
  fs.stat fullname, (err, stat) ->
    return callback(err) if err?
    name = pathUtil.basename(fullname)
    image = new Image(fullname, name, stat.size)
    callback null, image

module.exports = Image
