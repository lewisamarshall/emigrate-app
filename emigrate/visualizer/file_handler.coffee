exporter = this
spawn = require('child_process').spawn
$ = require('../bower_components/jquery/dist/jquery.js')

class Link

  process: null
  callback: null

  constructor: (executable, callback)->
    @callback = callback
    @process = spawn('python', ['-u', executable])
    @process.stdout.on('data', @outlet)

  outlet: (json_data)->
    data = $.parseJSON(json_data)
    @callback("stdout: " + data)

  close: ->
    @process.kill()

exporter.Link = Link
