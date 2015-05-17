exporter = this
spawn = require('child_process').spawn
readline = require('readline')

class Link

  process: null
  callback: null
  reader: null

  constructor: (executable, callback)->
    @callback = callback
    @process = spawn('python', ['-u', executable])
    @reader = readline.createInterface(input: @process.stdout)
    @reader.on('line', @outlet)

  outlet: (json_data)=>
    data = JSON.parse(json_data)
    @callback(json_data)

  kill: ->
    @process.kill()

  write: (msg)=>
    @process.stdin.write(msg+'\n')

exporter.Link = Link
#
# link = new Link('emigrate/python/hdf5_viewer.py', console.log)
# link.write('2')
# link.write('10')
