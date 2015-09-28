exporter = this

# File dialog components
remote = require 'remote'
dialog = remote.require 'dialog'

# Chart Components
d3 = require './bower_components/d3/d3.js'
c3 = require './bower_components/c3/c3.js'

# Custom Classes
Link = require('./helpers/link.js').Link
chart_properties = require('./chart_properties')
simulation_chart_properties = chart_properties.simulation_chart_properties


class Simulator
  panes: null
  table: null
  state: 'stop'

  constructor: ->
    @simulation_chart = c3.generate(simulation_chart_properties)
    @progressbar = document.getElementById('simulatorProgress')

  load: =>
    @stop()
    @simulation_chart.unload()
    @initial_condition = dialog.showOpenDialog(
      properties: ['openFile']
      filters: [{name: 'JSON', extensions: ['json']}]
    )[0]
    @link = new Link('emigrate', ['load', @initial_condition, 'echo'], @draw)
    @link.write(0)

  run: =>
    file = dialog.showSaveDialog(
      properties: ['openFile']
      filters: [{name: 'HDF5', extensions: ['hdf5']}]
    )
    @maxtime = parseFloat(document.getElementById('time_input').value)
    dt = parseFloat(document.getElementById('dt_input').value)
    @link = new Link('emigrate', ['load', @initial_condition,
                                  'solve', '--io', '-t', @maxtime, '-d', dt,
                                  '--output', file], @draw)
    @progressbar.classList.add('active')

  stop: =>
    @link?.kill()
    @progressbar.classList.remove('active')


  draw: (data) =>
    """Callback function to draw new frame data."""
    # If this is the first callback, create the slider
    if data.nodes?
      concentrations = {'x': data.nodes.data}
      concentrations[data.ions[i].name] = c for c, i in data.concentrations.data
      @simulation_chart.load(json:concentrations)
      d3.select('#simulationTime').text(data.time + ' s')

      @progressbar.style.width = data.time/@maxtime * 100 + '%'
      @progressbar.ariaValuenow = data.time/@maxtime * 100 + '%'
      if data.time == @maxtime
        @progressbar.classList.remove('active')

    if data.error?
      console.log(data.error)

  buttonPlayPress: =>
    if @state=='stop'
      @state='play'
      button = d3.select("#button_run").classed('btn-success', true)
      button.select("span").attr('class', "glyphicon glyphicon-stop")
      @run()

    else if @state=='play'
      @state = 'stop'
      button = d3.select("#button_run").classed('btn-success', false)
      button.select("span").attr('class', "glyphicon glyphicon-play")
      @stop()

exporter.simulator = new Simulator()
