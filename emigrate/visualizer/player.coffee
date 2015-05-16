exporter=this
remote = require 'remote'
dialog = remote.require 'dialog'
d3 = require '../bower_components/d3/d3.js'
c3 = require '../bower_components/c3/c3.js'
# Slider = require 'slider.js'.Slider


class Player

  data: null
  ions: null
  time: null
  electrolytes: null
  n_ions: null
  n_electrolytes: null

  frame: 0
  file: null
  slider: null
  chart_properties = require('./chart_properties').chart_properties
  concentration_chart: null
  properties_chart: null

  constructor: () ->
    frame = 0

    chart_properties.bindto='#concentration_chart'
    @concentration_chart = c3.generate(chart_properties)

    chart_properties.bindto='#property_chart'
    @properties_chart = c3.generate(chart_properties)

    @slider = new Slider

  open_file: =>
    file = dialog.showOpenDialog(
      properties: ['openFile']
      filters: [
        name: 'JSON',
        extensions: ['json']
        ]
    )[0]
    @load_json(file)

  parsed: (data)=>
    @data = data
    @time = data.time
    @electrolytes = data.electrolytes
    @ions = data.ions
    @n_ions = @ions.length
    @n_electrolytes = @electrolytes.length

  load_json: (filename) =>
    that = this
    d3.json(filename,
      (error, data)->
        that.parsed(data)
        that.draw()
      )

  draw: ->
    @concentration_chart.load(
      columns: @transform(@frame)
    )
    # @property_chart.load(
    #   columns: @transform_property_data(@frame)
    # )

  transform: (frame)->
    x = ['x'].concat(@electrolytes[frame].nodes)
    c = [[@ions[i]].concat(@electrolytes[frame].concentrations[i]) for i in [0...@n_ions]]
    [x].concat(c[0])

  update_slider: ->
    null

exporter.player = new Player
