express = require 'express'
http = require 'http'
request = require 'request'
app = express()
cookieSession = require 'cookie-session'

app.use cookieSession
  name: 'session'
  keys: ['baseUrl']

HOUR = 1000 * 60 * 60

app.get '/proxy/*', (req, res) ->
  url = req.originalUrl.substr 7
  console.log "url", url
  console.log "req.headers", req.headers
  req.session.baseUrl = url
  console.log 'proxying: ', url
  x = request(url)
  req.pipe x
  x.pipe res

app.get '/*', (req, res, next) ->
  if ~req.originalUrl.indexOf '/socket.io'
    return next()
  res.redirect '/proxy/' + req.session.baseUrl + req.originalUrl
  
app.listen 8080, ->
  console.log "listening"
