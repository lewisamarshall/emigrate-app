chart_size = {
        height: 300
        width: 600
        }
chart_padding= {
        top: 0,
        right: 150,
        bottom: 0,
        left: 50,
    }
this.chart = c3.generate(
    bindto: '#concentration_chart',
    # size: chart_size
    padding: chart_padding
    data:
        columns: ['x',0],
        types: {}
        x: 'x'

    legend:
        show: true
        position: 'right'
        x: 30,
        y: 0,

    axis:
        y:
            label: 'Concentration'
            tick:
                 values: [0, .05, .1, .15, .2, .25, .3, .35, .4, .45, .5]
                 count: 5
                 format: (d)-> d3.round(d*1000)+' mM'
        x:
            label: 'Length'
            tick:
                 fit: true
                 count: 5
                 format: (d)-> d3.round(d*1000,1)+' mm'
    transition:
        duration: 10

    point:
        show: true
        r: 1.5

    tooltip:
        format:
            title: (d)-> 'x='+d3.round(d*1000,2)+' mm'
            value:  (value, ratio, id)-> d3.round(value*1000,2) + ' mM'
    )

this.property_chart = c3.generate(
    bindto: '#property_chart',
    # size: chart_size
    padding: chart_padding

    data:
        columns: ['x',0],
        types: {}
        x: 'x'

    legend:
        show: true
        position: 'right'
        x: 30,
        y: 0,

    axis:
        y:
            label: ''
            tick:
                 fit: true
                 count: 5
                 format: (d)-> d3.round(d, 2)
        x:
            label: 'Length'
            tick:
                 fit: true
                 count: 5
                 format: (d)-> d3.round(d*1000, 1)+' mm'
    transition:
        duration: 10

    point:
        show: true
        r: 1.5

    tooltip:
        format:
            title: (d)-> 'x='+d3.round(d*1000,2)+' mm'
            value:  (value, ratio, id)-> d3.round(value, 2)
    )
