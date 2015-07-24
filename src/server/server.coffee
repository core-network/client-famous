{ json, log, p, pjson } = require 'lightsaber'
bs = require('browser-sync').create()
request = require 'request'
bs.init
  startPath: 'dist'
  files: 'dist/*'
  server:
    baseDir: './'
    middleware: (req, res, next) ->
      host = 'http://localhost:5001'
      req.headers.host = host
      req.headers.referer = "#{host}/ipfs/"
      # p req.headers
      pattern = /// ^/(ipfs|api)/.+$ ///
      if req.url.match(pattern)
        proxyPath = req.url.match(pattern)[0]
        proxyUrl = "#{host}#{proxyPath}"
        log 'Proxy to URL: ' + proxyUrl
        req.pipe request[req.method.toLowerCase()](proxyUrl)
          .pipe res
      else
        next()
