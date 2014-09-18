RemoteImageServer [![NPM version][npm-image]][npm-url] [![Dependency Status][depstat-image]][depstat-url]
=================

> RemoteImageServer is the server for [RemoteImagePicker]  
> RemoteImageServer publish your local image files for [RemoteImagePicker] to consume

## Install

Install using [npm][npm-url].

    $ npm install RemoteImageServer

## Start

    $ npm run start

For development

    $ npm run dev

## Configuration

### Server Configuration

Check `configuration.json` for detail

```json
{
  "extensions": [".jpg", ".png"],
  "cache": {
    "exipration": 60000
  },
  "port": 4000,
  "discovery": {
    "interval": 5000
  }
}

```

### Pods Configuration

Check `pods.txt` for detail

```
/Users/timnew/Pictures/HiFi
/Users/timnew/Pictures/Exported Photos/798
```

## License
MIT

[![NPM downloads][npm-downloads]][npm-url]

[homepage]: https://github.com/timnew/RemoteImageServer

[npm-url]: https://npmjs.org/package/RemoteImageServer
[npm-image]: http://img.shields.io/npm/v/RemoteImageServer.svg?style=flat
[npm-downloads]: http://img.shields.io/npm/dm/RemoteImageServer.svg?style=flat

[depstat-url]: https://gemnasium.com/timnew/RemoteImageServer
[depstat-image]: http://img.shields.io/gemnasium/timnew/RemoteImageServer.svg?style=flat

[RemoteImagePicker]: https://github.com/timnew/RemoteImagePicker
