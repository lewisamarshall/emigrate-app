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
                 format: (d)-> Math.round(d*1000)+' mM'
        x:
            label: 'Length'
            tick:
                 fit: true
                 count: 5
                 format: (d)-> Math.round(d*10000)/10+' mm'
    transition:
        duration: 10

    point:
        show: true
        r: 1.5

    tooltip:
        format:
            title: (d)-> 'x='+d.toPrecision(3)
            value:  (value, ratio, id)-> Math.round(value*10000)/10 + ' mM'
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
        x:
            label: 'Length'
            tick:
                 fit: true
                 count: 5
                 format: (d)-> Math.round(d*10000)/10+' mm'
    transition:
        duration: 10

    point:
        show: true
        r: 1.5

    tooltip:
        format:
            title: (d)-> 'x='+d.toPrecision(3)
            value:  (value, ratio, id)-> Math.round(value*100)/100
    )
