exporter=this

holder = document.getElementById('holder')

holder.ondragover = () -> false

holder.ondragleave = holder.ondragend = () -> false

holder.ondrop = (e) ->
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
        exporter.reset()
        )

exporter.draw_data = ->
    x = ['x'].concat(exporter.electrolytes[exporter.frame][1].nodes)
    c = [[exporter.ions[i]].concat(exporter.electrolytes[exporter.frame][1].concentrations[i]) for i in [0...exporter.n_ions]]
    # console.log(c)
    exporter.chart.load(
        columns: [x].concat(c[0])
        )

exporter.next = ->
    exporter.frame +=1
    exporter.draw_data()

exporter.prev = ->
    exporter.frame -=1
    exporter.draw_data()

exporter.reset = ()->
    exporter.frame = 0
    exporter.draw_data()

exporter.play = (frame_rate=100)->
    # while exporter.frame < exporter.data.electrolytes.length
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
    setTimeout(window.next(), frame_rate)
