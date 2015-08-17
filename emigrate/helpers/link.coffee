exporter = this
spawn = require('child_process').spawn
readline = require('readline')

class Link

  process: null
  caller: null
  reader: null
  err_reader: null

  constructor: (process, args, callback)->
    @process = spawn(process, args)

    # Call the callback through the outlet for each returned item.
    @reader = readline.createInterface(input: @process.stdout)
    @reader.on('line', (d)->callback(JSON.parse(d)))

    # Catch the errors
    @err_reader = readline.createInterface(input: @process.stderr)
    @err_reader.on('line', console.log)

  kill: =>
    @process.kill()

  write: (msg)=>
    # msg = JSON.stringify(msg)+'\n'
    msg = msg+'\n'
    @process.stdin.write(msg)

exporter.Link = Link
# #
# call = (d)=>console.log(d)
# link = new Link('/usr/local/bin/emigrate', call)
# link.write('open /Users/lewis/Documents/github/emigrate/example_1.hdf5')
# link.write('frame 10')
#
# exporter.link = link
