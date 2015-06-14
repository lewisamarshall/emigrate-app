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
    @link = new Link('/usr/local/bin/emigrate', @draw)

    @concentration_chart = c3.generate(concentration_chart_properties)

    @properties_chart = c3.generate(properties_chart_properties)

  open_file: =>
    @close()
    @frame = 0
    file = dialog.showOpenDialog(
      properties: ['openFile']
      filters: [{name: 'JSON', extensions: ['json']},
        {name: 'HDF5', extensions: ['hdf5']}]
    )[0]
    @link.write('open '+file)
    @link.write('frame '+@frame)

  close: =>
    @concentration_chart.unload()
    @properties_chart.unload()
    @slider?.remove()
    @slider = null

  draw: (data) =>
    """Callback function to draw new frame data."""
    # If this is the first callback, create the slider
    if not @slider
      @frames = data.n_electrolytes
      @slider = new Slider(@frames, throttle(@go_to_frame, 100))
      # @slider = new Slider(@frames, @go_to_frame)


    @concentration_chart.load(json:data.concentrations)
    @properties_chart.load(json:data.properties)
    d3.select('#sliderframe').text(@frame)
    # d3.select('#slidertime').text(exporter.time[frame]+' s')

  go_to_frame: (frame) =>
    if (frame != @frame)
      @frame = frame
      @link.write('frame ' + @frame)

exporter.player = new Player