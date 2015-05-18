exporter=this
# d3 = require '../bower_components/d3/d3.js'

chart_properties ={
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
  transition:
    duration: 10
  point:
    show: true
    r: 1.5
  tooltip:
    format:
      title: (d)->'x='+d3.round(d*1000, 2)+' mm'
  }

exporter.concentration_chart_properties = Object.create(chart_properties)
exporter.concentration_chart_properties.bindto = '#concentration_chart'
exporter.concentration_chart_properties.axis = {
  x:
    label: 'Length'
    tick:
      fit: true
      count: 5
      format: (d)->d3.round(d*1000, 1)+' mm'
  y:
    label: 'Concentration'
    tick:
      count: 5
      format: (d)-> d3.round(d*1000)+' mM'
  }

exporter.properties_chart_properties = Object.create(chart_properties)
exporter.properties_chart_properties.bindto = '#property_chart'
exporter.properties_chart_properties.axis = {
  x:
    label: 'Length'
    tick:
      fit: true
      count: 5
      format: (d)->d3.round(d*1000, 1)+' mm'
  y:
    label: 'Properties'
    tick:
      count: 5
      format: (d)-> d3.round(d)
  }
