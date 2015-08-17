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
  panes: null
  table: null

  constructor: ->
    @link = new Link('emigrate', ['construct', '--io'], console.log)    # @set_panes()
    @constructor_chart = c3.generate(constructor_chart_properties)

  add_ion: (ion, concentration)->
    if not @table
      @table = document.getElementById('ion_table')


  set_panes: ->
    @panes = {
      'numerics': document.getElementById('numerics'),
      'solutions': document.getElementById('solutions'),
      'fields': document.getElementById('fields'),
    }
    @show('numerics')

  show: (item)->
    @panes[item].style.display = 'inline'

  hide: (item)->
    @panes[item].style.display = 'none'

  showonly: (item)->
    for own k,v of @panes
      if k==item
        @show(k)
      else
        @hide(k)

  showall: ->
    for own k,v of @panes
      @show(k)

exporter.constructor = new Constructor()


electrolyte = [
  {
    zone: 'Trailing Electrolyte',
    length: 1,
    solutions : [
      { ion: 'tris', concentration: 0.1},
      { ion: 'caproic acid', concentration: 0.2},
      { ion: 'hepes', concentration: 0.2},
    ]
  },{
    zone: 'Sample',
    length: 1,
    solutions : [
      { ion: 'alexa fluor 488', concentration: 0.001},
      { ion: 'tris', concentration: 0.02},
      { ion: 'hydrochloric acid', concentration: 0.01},
    ]
  },{
    zone: 'Leading Electrolyte',
    length: 1,
    solutions : [
      { ion: 'hydrochloric acid', concentration: 0.1},
      { ion: 'tris', concentration: 0.2},
    ]
  }
]

columns = [
  {
    name: 'zone',
    title: 'Zone'
  },{
    name: 'length',
    title: 'Length'
  },{
    name:'solutions',
    title:'Solution',
    cellTemplate: 'nestedTable',
    columns: [
      { name:'ion', title:'Ion'},
      { name:'concentration', title: 'Concentration'},
    ],
  }
]


window.addEventListener('polymer-ready', ->
  model = {
    data: electrolyte,
    columns: columns
  }
  document.getElementById('constructor_table').model = model
  electrolyte[0].zone='TE'
  electrolyte[1].zone='Sampsonite'
)
