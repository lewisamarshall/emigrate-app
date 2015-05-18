exporter=this
# exporter.link = require('./link.js').link
remote = require 'remote'
dialog = remote.require 'dialog'
d3 = require '../bower_components/d3/d3.js'
c3 = require '../bower_components/c3/c3.js'
Slider = require('./slider.js').Slider
Link = require('./link.js').Link
# link = require('./link.js').link
viewer_file = '../python/hdf5_viewer.py'
chart_properties = require('./chart_properties')
concentration_chart_properties = chart_properties.concentration_chart_properties
properties_chart_properties = chart_properties.properties_chart_properties
python = '/usr/local/bin/python2.7'
viewer_file = '/Users/lewis/Documents/github/emigrate_app/emigrate/python/hdf5_viewer.py'

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
    @frame = 0

    @concentration_chart = c3.generate(concentration_chart_properties)

    @properties_chart = c3.generate(properties_chart_properties)

  open_file: =>
    file = dialog.showOpenDialog(
      properties: ['openFile']
      filters: [{name: 'JSON', extensions: ['json']},
        {name: 'HDF5', extensions: ['hdf5']}]
    )[0]
    @frame = 0
    @link = new Link(python, viewer_file, @draw)
    @link.write(@frame)

  draw: (data) =>
    """Callback function to draw new frame data."""
    # If this is the first callback, create the slider
    if not @slider
      @frames = data.n_electrolytes
      @slider = new Slider(@frames, @go_to_frame)

    @concentration_chart.load(json:data.concentrations)
    @properties_chart.load(json:data.properties)
    d3.select('#sliderframe').text(@frame)
    # d3.select('#slidertime').text(exporter.time[frame]+' s')

  go_to_frame: (frame) =>
    if (frame != @frame)
      @frame = frame
      @link.write(@frame)

exporter.player = new Player
