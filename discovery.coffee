require('./initEnv')
debug = Debug('app:discovery')
dgram = require('dgram')

service = dgram.createSocket 'udp4', (buffer, remote) ->
  msg = buffer.toString('utf8')
  debug("Recieved #{msg} from #{inspect(remote)}")

  return unless msg is 'ImageServer'

  # socket.send(buf, offset, length, port, address, [callback])
  service.reply(remote.address, remote.port)

service.defaultPort = process.env.PORT || Config.port

response = new Buffer("ImageServer:#{Config.version}")
service.reply = (address = "255.255.255.255", port = @defaultPort) ->
  debug("Send to #{address}:#{port}")
  service.send response, 0, response.length, port, address

service.enableBroadcast = (interval = Config.discovery.interval) ->
  service.disableBroadcast()

  service.intervalToken = setInterval service.sendBroadcast, interval

service.disableBroadcast = ->
  return unless service.intervalToken?
  clearInterval(service.intervalToken)
  service.intervalToken = undefined

service.on 'listening', ->
  service.setBroadcast(true)
  service.unref()

module.exports = service
