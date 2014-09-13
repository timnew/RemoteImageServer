debug = Debug('app:model:Pod')

fs = require('graceful-fs')
pathUtil = require('path')
glob = require('glob')

class Pod
  constructor: (@id, @localPath, @name) ->
    @name = pathUtil.basename(@localPath) unless @name?

  toJson: ->
    _.pick(this, 'id', 'name')

  refreshCache: (callback) =>
    listFiles = (ext, callback) =>
      glob('**' + ext, {cwd: @localPath}, callback)

    async.waterfall [
      (callback) ->
        async.concat Config.extensions, listFiles, callback

      (files, callback) =>
        fileFullNames = _.map files, (f) => pathUtil.join(@localPath, f)
        callback(null, fileFullNames)

      (files, callback) ->
        async.map files, Models.Image.create, callback

      (files, callback) =>
        @files = {}

        for file in files
          @files[file.name] = file

        setTimeout =>
            @files = null
          , Config.cache.expiration

        callback(null, @files)

    ],callback

  ensureCache: (callback) =>
    if @files?
      callback(@files)
    else
      @refreshCache(callback)

  listImages: (callback) ->
    async.waterfall [
      @ensureCache,
      (files, callback) ->
        callback(null, _.values(files))
    ],
    callback

  getImage: (name, callback) =>
    async.waterfall [
      @ensureCache,
      (files, callback) ->
        callback(null, files[name])
    ],
    callback

Pod.podsId = {}
Pod.podsName = {}

Pod.loadFile = (file) ->
  debug("Read pods from #{file}...")
  podsText = fs.readFileSync(file, encoding: 'utf8')
  podsList = podsText.split('\n')
  for podPath in podsList
    podPath = podPath.trim()
    @addPod(podPath) unless podPath == ''

Pod.getAll = ->
  _.values @podsId

Pod.get = (id) ->
  @podsId[id] ? @podsName[id]

Pod.addPod = (localPath, name) ->
  pod = new Pod(_.uniqueId(), localPath, name)
  @podsName[pod.name] = pod
  @podsId[pod.id] = pod
  debug "Add pod: #{inspect(pod)}"
  pod

Pod.removePod = (id) ->
  pod = @get(id)
  debug "Remove pod: #{inspect(pod)}"
  return unless pod?
  delete @podsName[pod.name]
  delete @podsId[pod.id]

Pod.count = ->
  @podsId.length

module.exports = Pod
