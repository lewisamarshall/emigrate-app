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
    @err_reader.on('line', (d)->console.log('Link error: ' + d))

  kill: =>
    @process.kill()

  write: (msg)=>
    msg = msg+'\n'
    @process.stdin.write(msg)

exporter.Link = Link
