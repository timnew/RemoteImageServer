var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Remote Image Picker Server' });
});

router.use(function(req, res, next) {
  req.model = {};
  next();
});

router.use('/pods', Routes.pods);
router.use('./images', Routes.images);

module.exports = router
