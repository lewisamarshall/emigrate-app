this.chart = c3.generate(
    bindto: '#chart',
    data:
        columns: ['x',0],
        types: {}
        x: 'x'

    legend:
        show: true
        position: 'right'

    axis:
        y:
            label: 'Concentration (M)',
        x:
            label: 'Length (m)'
            tick:
                count: 4,
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
