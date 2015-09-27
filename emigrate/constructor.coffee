exporter = this
# File dialog components
remote = require 'remote'
dialog = remote.require 'dialog'

console.log(process.env.PATH)
# Chart Components
d3 = require './bower_components/d3/d3.js'
c3 = require './bower_components/c3/c3.js'

# Custom Classes
Link = require('./helpers/link.js').Link
chart_properties = require('./chart_properties')
constructor_chart_properties = chart_properties.constructor_chart_properties

class Constructor

  constructor: ->
    @link = new Link('emigrate', ['construct', '--io'], @draw)    # @set_panes()
    # @link = new Link('emigrate', ['load', '--io', '/Users/lewis/Desktop/Untitled.hdf5'], @draw)
    # @link.write(1)

    @constructor_chart = c3.generate(constructor_chart_properties)

  update: =>
    serial =
      solutions: (@parse_solution(zone.solution) for zone in @data)
      lengths: (zone.length for zone in @data)
      n_nodes: parseInt(document.getElementById('grid_input').value, 10)
      current: parseFloat(document.getElementById('current_input').value)
      interface_length: parseFloat(document.getElementById('interface_input').value)

    console.log(serial)
    @link.write(JSON.stringify(serial))

  save: =>
    file = dialog.showSaveDialog(
      properties: ['openFile']
      filters: [{name: 'JSON', extensions: ['json']}]
    )
    serial =
      solutions: (@parse_solution(zone.solution) for zone in @data)
      lengths: (zone.length for zone in @data)
      n_nodes: parseInt(document.getElementById('grid_input').value, 10)
      current: parseFloat(document.getElementById('current_input').value)
      save: file
    console.log(JSON.stringify(serial))
    @link.write(JSON.stringify(serial))

  parse_solution: (solution)->
    serial =
      __solution__: true
      ions: (ion.ion for ion in solution)
      concentrations: (ion.concentration for ion in solution)

  draw: (data) =>
    """Callback function to draw new frame data."""
    console.log(data)
    # @constructor_chart.unload()
    concentrations = {'x': data.nodes.data}
    concentrations[data.ions[i].name] = c for c, i in data.concentrations.data
    @constructor_chart.load(json:concentrations)

  add_zone: =>
    @data.push(
      zone: 'New Zone',
      length: .005,
      solution : [
        { ion: 'hydrochloric acid', concentration: 0.001},
      ]
    )

  remove_zone: =>
    @data.pop()

  add_ion: (n)=>
    console.log(n)
    @data[n].solution.push({ ion: 'hydrochloric acid', concentration: 0.001})


exporter.constructor_obj = new Constructor()

window.addEventListener('polymer-ready', ->
  table = document.getElementById('constructor_table')
  exporter.constructor_obj.data = table.data
  table.data = exporter.constructor_obj.data
  exporter.constructor_obj.update()
)
