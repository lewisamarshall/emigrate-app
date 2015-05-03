exporter=this
remote = require 'remote'
dialog = remote.require 'dialog'

chart = document.getElementById('concentration_chart')

chart.ondragover = () -> false

chart.ondragleave = chart.ondragend = () -> false

chart.ondrop = (e) ->
    e.preventDefault()
    file = e.dataTransfer.files[0]
    console.log('File you dragged here is', file.path)
    window.load_data(file.path)
    false

exporter.slider = d3.slider().on("slide", (evt, value)->exporter.gotoframe(value))
exporter.slider_axis = exporter.slider.axis(true)
                                .min(0)
                                .max(1)
                                .step(1)
d3.select('#sliderbox').append('div').attr('id', 'existing_slider').call(exporter.slider)

window.load_data = (file)->
    exporter.frame = 0
    exporter.d3.select('#existing_slider').remove()
    plotter = d3.json(file, (error, data)->
        exporter.data = data
        exporter.time = data.time
        exporter.electrolytes = data.electrolytes
        exporter.ions = data.ions
        exporter.n_ions = data.ions.length
        exporter.n_electrolytes = data.electrolytes.length
        exporter.slider = d3.slider().on("slide", (evt, value)->exporter.gotoframe(value))
        exporter.slider_axis = exporter.slider.axis(true)
                                        .min(0)
                                        .max(exporter.n_electrolytes)
                                        .step(1)
        d3.select('#sliderbox').append('div').attr('id', 'existing_slider').call(exporter.slider)

        exporter.reset()
        )

exporter.draw_data = ->
    exporter.chart.load(
        columns: transform_data(exporter.frame)
        )
    exporter.property_chart.load(
        columns: transform_property_data(exporter.frame)
    )


transform_data = (f)->
        x = ['x'].concat(exporter.electrolytes[f].nodes)
        c = [[exporter.ions[i]].concat(exporter.electrolytes[f].concentrations[i]) for i in [0...exporter.n_ions]]
        [x].concat(c[0])

transform_property_data = (f)->
    x = ['x'].concat(exporter.electrolytes[f].nodes)
    p = [['pH'].concat(exporter.electrolytes[f].pH)]
    [x].concat(p)

exporter.next = ->
    exporter.frame +=1
    exporter.draw_data()

exporter.prev = ->
    exporter.frame -=1
    exporter.draw_data()

exporter.reset = ()->
    exporter.chart.unload()
    exporter.frame = 0
    exporter.draw_data()

flow_next = ->
    if exporter.frame<exporter.electrolytes.length
        exporter.frame +=1
        exporter.chart.flow(
            columns: transform_data(exporter.frame)
            done: flow_next
            )

exporter.play = ()->
    flow_next()

exporter.gotoframe = (n)->
    exporter.frame = n
    exporter.draw_data()
    d3.select('#sliderframe').text(n)
    d3.select('#slidertime').text(exporter.time[n]+' s')

# exporter.slider = d3.slider().on("slide", (evt, value)->exporter.gotoframe(value))
#                           .axis(true)
#                           .min(0)
#                           .max(1000)
#                           .step(1)

exporter.open_file = ()->
    console.log('pressed')
    files = dialog.showOpenDialog(
        properties: [ 'openFile']
        filters: [
            name: 'JSON',
            extensions: ['json']
            ]
    )
    # console.log(files[0])
    window.load_data(files[0])
