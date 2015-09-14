exporter = this

# File dialog components
remote = require 'remote'
dialog = remote.require 'dialog'

# Chart Components
d3 = require './bower_components/d3/d3.js'
c3 = require './bower_components/c3/c3.js'

# jQuery
$ = jquery = require './bower_components/jquery/dist/jquery.js'

# Custom Classes
Link = require('./helpers/link.js').Link
chart_properties = require('./chart_properties')
simulation_chart_properties = chart_properties.simulation_chart_properties


class Simulator
  panes: null
  table: null

  constructor: ->
    @simulation_chart = c3.generate(simulation_chart_properties)

  load: =>
    @stop()
    @initial_condition = dialog.showOpenDialog(
      properties: ['openFile']
      filters: [{name: 'JSON', extensions: ['json']}]
    )[0]
    @link = new Link('emigrate', ['load', '--io', @initial_condition], @draw)
    @link.write(0)

  run: =>
    console.log(@initial_condition)
    file = dialog.showSaveDialog(
      properties: ['openFile']
      filters: [{name: 'HDF5', extensions: ['hdf5']}]
    )
    @stop()
    @link = new Link('emigrate', ['load', @initial_condition,
                                  'solve', '--io', '-t', '10.0', '-d', '1.0',
                                  '--output', file], @draw)

  stop: =>
    @link?.kill()

draw: (data) =>
  """Callback function to draw new frame data."""
  # If this is the first callback, create the slider
  console.log(data)
  if data.nodes?
    concentrations = {'x': data.nodes.data}
    concentrations[data.ions[i].name] = c for c, i in data.concentrations.data
    @simulation_chart.load(json:concentrations)


  if data.error?
    console.log(data.error)

  # @set_panes()
  # add_ion: (ion, concentration)->
  #   if not @table
  #     @table = document.getElementById('ion_table')
  #
  # set_panes: ->
  #   @panes = {
  #     'numerics': document.getElementById('numerics'),
  #     'solutions': document.getElementById('solutions'),
  #     'fields': document.getElementById('fields'),
  #   }
  #   @show('numerics')
  #
  # show: (item)->
  #   @panes[item].style.display = 'inline'
  #
  # hide: (item)->
  #   @panes[item].style.display = 'none'
  #
  # showonly: (item)->
  #   for own k,v of @panes
  #     if k==item
  #       @show(k)
  #     else
  #       @hide(k)
  #
  # showall: ->
  #   for own k,v of @panes
  #     @show(k)

exporter.simulator = new Simulator()
