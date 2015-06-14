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


class SimTable
  data: []

  constructor: ->
    @table = document.getElementById('sim-table')

  add_item: (solution, length) ->
    data.push({solution: solution, length: length})
    @update_table()

  remove_item: (index) ->
    data.splice(index, 1)
    @update_table()

  update_table: ->
    @table.data = @data

class SolTable
  data: []

  constructor: ->

  add_item: (ion, concentration) ->
    data.push({ion: ion, concentration: concentration})
    @update_table

  remove_item: (index) ->
    data.splice(index, 1)
    @update_table()


class Simulator
  panes: null
  table: null

  constructor: ->
    # @set_panes()
    @simulation_chart = c3.generate(simulation_chart_properties)

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

exporter.simulator = new Simulator()
