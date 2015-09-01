#!/usr/bin/env coffee

{ json, log, p, pjson } = require 'lightsaber'
request = require 'request'
browserSync = require('browser-sync').create()

IPFS = 'http://localhost:5001'

devServer = ->
  checkProxiedServer startBrowserSync

checkProxiedServer = (callback) ->
  url = "#{IPFS}/"
  request url, (error, response, body) ->
    if error
      console.error "Could not connect to #{url} -- make sure the server is running"
      process.exit 1
    else
      callback()

startBrowserSync = ->
  browserSync.init
    startPath: 'dist'
    files: 'dist/*'
    server:
      baseDir: './'
      middleware: proxyIpfsCalls

proxyIpfsCalls = (req, res, next) ->
  # req.headers.host = IPFS
  # req.headers.referer = "#{IPFS}/ipfs/"
  pattern = /// ^/(ipfs|api)/.+$ ///
  if req.url.match pattern
    proxyPath = req.url.match(pattern)[0]
    proxyUrl = "#{IPFS}#{proxyPath}"
    # log "Attemptimng to proxy to URL: #{proxyUrl}..."
    proxyRequest = request[req.method.toLowerCase()](proxyUrl)
    req.pipe(proxyRequest).pipe res
  else
    next()

devServer()
