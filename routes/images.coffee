debug = Debug('app:routes:images')
express = require('express')
router = express.Router()

router.get '/', (req, res) ->
  debug("List Images #{req.model.pod}")
  req.model.pod.listImages (err, images) ->
    if err?
      debug("List Image Error: #{inspect(err)}")
      return res.status(500).end()

    res.send _.invoke images, 'toJson'

router.get '/:imageId', (req, res) ->
  debug("getImage #{req.model.pod} -> req.params.imageId")
  req.model.pod.getImage req.params.imageId, (err, image) ->
    if err?
      debug("Get Image Error: #{inspect(err)}")
      return res.status(500).end()
    debug("Image: #{image}")
    res.download image.localPath, image.name

module.exports = router
