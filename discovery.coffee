require('./initEnv')
debug = Debug('app:discovery')
dgram = require('dgram')

service = dgram.createSocket 'udp4', (buffer, remote) ->
  msg = buffer.toString('utf8')
  return unless msg is 'ImageServer'

  # socket.send(buf, offset, length, port, address, [callback])
  service.repply(remote.address, remote.port)

service.defaultPort = process.env.PORT || Config.port

response = new Buffer("ImageServer:#{Config.version}")
service.reply = (address = "255.255.255.255", port = @defaultPort) =>
  @send response, 0, response.length, port, address

service.enableBroadcast = (interval = Config.discovery.interval) ->
  @disableBroadcast()

  @intervalToken = setInterval @sendBroadcast, interval

service.disableBroadcast = ->
  return unless @intervalToken?
  clearInterval(@intervalToken)
  @intervalToken = undefined

service.on 'listening', ->
  service.setBroadcast(true)
  service.unref()

module.exports = service
