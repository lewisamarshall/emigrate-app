exporter=this

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
    duration: 0
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
      fit: false
      culling:
        max: 5
      count: 10
      format: (d)->d3.round(d*1000, 1)+' mm'
  y:
    label: 'Concentration'
    tick:
      fit: false
      culling:
        max: 5
      count: 5
      format: (d)-> d3.round(d*1000, 1)+' mM'
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
      format: (d)-> d3.round(d, 2)
  }

exporter.simulation_chart_properties = Object.create(chart_properties)
exporter.simulation_chart_properties.bindto = '#simulation_chart'
exporter.simulation_chart_properties.axis = {
  x:
    label: 'Length'
    tick:
      fit: true
      count: 5
      format: (d)->d3.round(d*1000, 1)+' mm'
  y:
    label: 'Concentration'
    tick:
      fit: false
      culling:
        max: 5
      count: 5
      format: (d)-> d3.round(d*1000, 1)+' mM'
  }


exporter.constructor_chart_properties = Object.create(chart_properties)
exporter.constructor_chart_properties.bindto = '#constructor_chart'
exporter.constructor_chart_properties.axis = {
  x:
    label: 'Length'
    tick:
      fit: true
      count: 5
      format: (d)->d3.round(d*1000, 1)+' mm'
  y:
    label: 'Concentration'
    tick:
      fit: false
      culling:
        max: 5
      count: 5
      format: (d)-> d3.round(d*1000, 1)+' mM'
  }
