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

    tooltip:
        format:
            title: (d)-> 'x='+d.toPrecision(3)
            value:  (value, ratio, id)-> Math.round(value*10000)/10 + ' mM'
                # format = id === 'data1' ? d3.format(',') : d3.format('$');
                # return format(value);
            # value: d3.format(',') // apply this format to both y and y2
    )
#
axis: {
        x: {
            type: 'timeseries',
            tick: {
                count: 4,
                format: '%Y-%m-%d'
            }
        }
    }
# window.plot = ()->
#     frame = 0
#     # clear_lines()
#     file = document.getElementById("file_input")
#                    .value
#                    .replace("C:\\fakepath\\", "")
#
#     plotter = d3.json(file, (error, data)->
#         saved_data = data
#         for i in [0...data.electrolytes[frame][1].concentrations.length]
#
#             # Add axes
#             if i == 0
#                 make_axes(d3.zip(
#                     data.electrolytes[frame][1].nodes,
#                     data.electrolytes[frame][1].concentrations[i]))
#
#
#             # Add the valueline path.
#             window.lines[i] = svg.append("path")
#                           .attr("class", "line")
#                           .attr("d", valueline(d3.zip(
#                             data.electrolytes[frame][1].nodes,
#                             data.electrolytes[frame][1].concentrations[i])))
#                           .attr("stroke", p(i%10))
#
#
#
#         my_legend = legend(data.ions, ['name', 'pKa'])
#     )
#
# window.next = (time)->
#     frame++
#     update_lines(frame, time)
#
# window.prev = (time)->
#     frame--
#     update_lines(frame, time)
#
# update_lines = (frame, time)->
#     for i in [0...saved_data.electrolytes[frame][1].concentrations.length]
#         lines[i].transition().duration(time)
#                 .attr("d", valueline(d3.zip(
#                     saved_data.electrolytes[frame][1].nodes,
#                     saved_data.electrolytes[frame][1].concentrations[i])))
#
# window.play = ()->
#     while(frame<saved_data.electrolytes.length)
#         next(1000)
