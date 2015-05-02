exporter=this

chart = document.getElementById('chart')

chart.ondragover = () -> false

chart.ondragleave = chart.ondragend = () -> false

chart.ondrop = (e) ->
    e.preventDefault()
    file = e.dataTransfer.files[0]
    console.log('File you dragged here is', file.path)
    window.load_data(file)
    false

window.load_data = (file)->
    exporter.frame = 0
    plotter = d3.json(file.path, (error, data)->
        exporter.data = data
        exporter.electrolytes = data.electrolytes
        exporter.ions = data.ions
        exporter.n_ions = data.ions.length
        exporter.n_electrolytes = data.electrolytes.length
        # exporter.slider.remove()
        exporter.slider = d3.slider().on("slide", (evt, value)->exporter.gotoframe(value))
                                  .axis(true)
                                  .min(0)
                                  .max(exporter.n_electrolytes)
                                  .step(1)
        d3.select('#slider1').call(exporter.slider)
        exporter.reset()
        )

exporter.draw_data = ->
    exporter.chart.load(
        columns: transform_data(exporter.frame)
        )

transform_data = (f)->
        x = ['x'].concat(exporter.electrolytes[f][1].nodes)
        c = [[exporter.ions[i]].concat(exporter.electrolytes[f][1].concentrations[i]) for i in [0...exporter.n_ions]]
        [x].concat(c[0])

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

exporter.slider = d3.slider().on("slide", (evt, value)->exporter.gotoframe(value))
                          .axis(true)
                          .min(0)
                          .max(1000)
                          .step(1)
