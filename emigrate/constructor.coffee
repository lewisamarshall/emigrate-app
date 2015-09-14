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
constructor_chart_properties = chart_properties.constructor_chart_properties

class Constructor
  data: [
    {
      zone: 'Trailing Electrolyte',
      length: .005,
      solution : [
        { ion: 'tris', concentration: 0.1},
        { ion: 'caproic acid', concentration: 0.2},
        { ion: 'hepes', concentration: 0.2},
      ]
    },{
      zone: 'Sample',
      length: .005,
      solution : [
        { ion: 'alexa fluor 488', concentration: 0.001},
        { ion: 'tris', concentration: 0.02},
        { ion: 'hydrochloric acid', concentration: 0.01},
      ]
    },{
      zone: 'Leading Electrolyte',
      length: .005,
      solution : [
        { ion: 'hydrochloric acid', concentration: 0.1},
        { ion: 'tris', concentration: 0.2},
      ]
    }
  ]

  columns: [
    {name: 'remove', title:''}
    {name: 'zone', title: 'Zone'},
    {name: 'length',title: 'Length'},
    {
      name: 'solution',
      title: 'Solution',
      cellTemplate: 'nestedTable',
      columns: [
          { name:'ion', title:'Ion'},
          { name:'concentration', title: 'Concentration'},
        ],
    }
  ]


  model:
    data: @data
    columns: @columns

  constructor: ->
    @model =
      data: @data
      columns: @columns
    @link = new Link('emigrate', ['construct', '--io'], @draw)    # @set_panes()
    @constructor_chart = c3.generate(constructor_chart_properties)
    @update()

  update: =>
    serial =
      solutions: (@parse_solution(zone.solution) for zone in @data)
      lengths: (zone.length for zone in @data)
      n_nodes: 151
    @link.write(JSON.stringify(serial))

  save: =>
    file = dialog.showSaveDialog(
      properties: ['openFile']
      filters: [{name: 'JSON', extensions: ['json']}]
    )
    serial =
      solutions: (@parse_solution(zone.solution) for zone in @data)
      lengths: (zone.length for zone in @data)
      n_nodes: 151
      save: file
    @link.write(JSON.stringify(serial))

  parse_solution: (solution)->
    serial =
      __solution__: true
      ions: (ion.ion for ion in solution)
      concentrations: (ion.concentration for ion in solution)

  draw: (data) =>
    """Callback function to draw new frame data."""
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


exporter.constructor = new Constructor()

window.addEventListener('polymer-ready', ->
  table = document.getElementById('constructor_table')
  table.model = exporter.constructor.model
)
