debug = Debug('app:rotues:pods')
express = require('express')
router = express.Router()

router.get '/', (req, res) ->
  res.send _.invoke Models.Pod.getAll(), 'toJson'

router.post '/', (req, res) ->
  {localPath, name} = req.body

  if localPath?
    res.send Models.Pod.addPod(localPath, name).toJson()
  else
    res.status(400).end()

router.param 'podId', (req, res, next, podId) ->
  pod = Models.Pod.get(podId)

  if pod?
    req.model.pod = pod
    next()
  else
    res.status(404).end()

router.get '/:podId', (req, res) ->
  res.send req.model.pod.toJson()

router.use '/:podId/images', Routes.images

module.exports = router
