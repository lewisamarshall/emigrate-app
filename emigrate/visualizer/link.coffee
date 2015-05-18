exporter = this
spawn = require('child_process').spawn
readline = require('readline')

class Link

  process: null
  caller: null
  reader: null
  err_reader: null

  constructor: (process, executable, callback)->
    @process = spawn(process, ['-u', executable])

    # Call the callback through the outlet for each returned item.
    @reader = readline.createInterface(input: @process.stdout)
    @reader.on('line', (d)->callback(JSON.parse(d)))

    # Catch the errors
    @err_reader = readline.createInterface(input: @process.stderr)
    @err_reader.on('line', console.log)

  kill: =>
    @process.kill()

  write: (msg)=>
    msg = JSON.stringify(msg)+'\n'
    @process.stdin.write(msg)

  outlet: (json_data)=>
    data = JSON.parse(json_data)
    @caller.call(window,'hi')
    @caller(json_data)

exporter.Link = Link
# #
# call = (d)=>console.log(d)
# link = new Link('/usr/local/bin/python2.7', '/Users/lewis/Documents/github/emigrate_app/emigrate/python/hdf5_viewer.py', call)
# link.write(3)
# link.write(10)
#
# exporter.link = link
