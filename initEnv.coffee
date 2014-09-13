global.inspect = require('util').inspect
global.Debug = require('debug')
global._ = require('lodash')
global.async = require('async')

lazy = require('lazily-require')

global.appRoot = require('approot')(__dirname).consolidate();

global.Config = require appRoot('configuration.json')

global.Routes = lazy appRoot.routes()
global.Models = lazy appRoot.models()

Models.Pod.loadFile appRoot('pods.txt')
