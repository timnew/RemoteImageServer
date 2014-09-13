debug = Debug('app:routes:images')
express = require('express')
router = express.Router()

router.get '/', (req, res) ->
  req.model.pod.listImages (err, images) ->
    if err?
      debug("List Image Error: #{inspect(err)}")
      return res.status(500).end()

    res.send _.invoke images, 'toJson'

router.get '/:imageId', (req, res) ->
  pod.getImage req.prarms.imageId, (err, image) ->
    if err?
      debug("Get Image Error: #{inspect(err)}")
      return res.status(500).end()

    res.download image.localPath, image.name

module.exports = router
