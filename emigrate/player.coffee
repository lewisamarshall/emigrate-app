exporter=this

# File dialog components
remote = require 'remote'
dialog = remote.require 'dialog'

# Chart Components
d3 = require './bower_components/d3/d3.js'
c3 = require './bower_components/c3/c3.js'

# Custom Classes
Slider = require('./slider.js').Slider
Link = require('./helpers/link.js').Link
chart_properties = require('./chart_properties')
concentration_chart_properties = chart_properties.concentration_chart_properties
properties_chart_properties = chart_properties.properties_chart_properties
throttle = require('./helpers/throttle').throttle

class Player

  # Connection to data file
  link: null
  file: null

  # Information from the open file
  frame: 0
  frames: null

  # Elements
  concentration_chart: null
  properties_chart: null
  slider: null

  constructor: () ->
    @concentration_chart = c3.generate(concentration_chart_properties)
    @properties_chart = c3.generate(properties_chart_properties)

  open_file: =>
    @link?.kill()
    @close()
    @frame = 0
    file = dialog.showOpenDialog(
      properties: ['openFile']
      filters: [{name: 'JSON', extensions: ['json']},
        {name: 'HDF5', extensions: ['hdf5']}]
    )[0]
    @link = new Link('emigrate', ['load', '--io', file], @draw)
    @link.write(@frame)

  close: =>
    @link?.kill()
    @concentration_chart.unload()
    @properties_chart.unload()
    @slider?.remove()
    @slider = null

  draw: (data) =>
    """Callback function to draw new frame data."""
    # If this is the first callback, create the slider
    console.log(data)
    if data.length?
      @frames = data.length
      @slider = new Slider(@frames, throttle(@go_to_frame, 100))

    if data.nodes?
      concentrations = {'x': data.nodes.data}
      concentrations[data.ions[i].name] = c for c, i in data.concentrations.data
      properties = {'x': data.nodes.data}
      properties[key] = data[key]?.data for key in ['pH', 'field']

      @concentration_chart.load(json:concentrations)
      @properties_chart.load(json:properties)
      d3.select('#sliderframe').text(@frame)
      d3.select('#slidertime').text(data.time)

    if data.error?
      console.log(data.error)

  go_to_frame: (frame) =>
    if (frame != @frame)
      @frame = frame
      @link.write(@frame)

exporter.player = new Player
