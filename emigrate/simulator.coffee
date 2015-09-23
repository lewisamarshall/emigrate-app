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
  state: 'stop'

  constructor: ->
    @simulation_chart = c3.generate(simulation_chart_properties)
    @progressbar = document.getElementById('simulatorProgress')

  load: =>
    @stop()
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
  #
  # buttonPlayPress: =>
  #     if(state=='stop'){
  #       state='play';
  #       var button = d3.select("#button_play").classed('btn-success', true);
  #       button.select("i").attr('class', "fa fa-pause");
  #     }
  #     else if(state=='play' || state=='resume'){
  #       state = 'pause';
  #       d3.select("#button_play i").attr('class', "fa fa-play");
  #     }
  #     else if(state=='pause'){
  #       state = 'resume';
  #       d3.select("#button_play i").attr('class', "fa fa-pause");
  #     }
  #     console.log("button play pressed, play was "+state);
  #
  # function buttonStopPress(){
  #     state = 'stop';
  #     var button = d3.select("#button_play").classed('btn-success', false);
  #     button.select("i").attr('class', "fa fa-play");
  #     console.log("button stop invoked.");
  # }

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
