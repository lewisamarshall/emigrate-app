exporter=this
d3 = require '../bower_components/d3/d3.js'

exporter.chart_properties ={
  padding:
    top: 0
    right: 150
    bottom: 0
    left: 50
  data:
    columns:['x', 0]
    types: {}
    x: 'x'
  legend:
    show: true
    position: 'right'
    x: 30
    y: 0
  axis:
    x:
      label: 'Length'
      tick:
        fit: true
        count: 5
        format: (d)->d3.round(d*1000, 1)+' mm'
    y:
      label: 'Concentration'
      tick:
        #    values: [0, .05, .1, .15, .2, .25, .3, .35, .4, .45, .5]
        count: 5
        format: (d)-> d3.round(d*1000)+' mM'
  transition:
    duration: 10
  points:
    show: true
    r: 1
  tooltip:
    format:
      title: (d)->'x='+d3.round(d*1000, 2)+' mm'
  }
