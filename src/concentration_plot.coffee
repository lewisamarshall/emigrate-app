# d3 = require('emigrate_visualizer/d3.min')
margin = {top: 30, right: 20, bottom: 30, left: 100}
width = 900 - margin.left - margin.right
height = 450 - margin.top - margin.bottom

# set the  ranges
x = d3.scale.linear().range([0, width])
y = d3.scale.linear().range([height, 0])


xAxis = d3.svg.axis()
          .scale(x)
          .orient("bottom")
          .ticks(5)

yAxis = d3.svg.axis()
          .scale(y)
          .orient("left")
          .ticks(5)

# Define the line
valueline = d3.svg.line()
              .x((d) -> x(d[0]) )
              .y((d) -> y(d[1]))

# Adds the svg canvas
svg = d3.select("body")
        .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

p = d3.scale.category10()

# Function for setting axis attributes
make_axes = (data2) ->
    # Scale the range of the data
        x.domain([0, d3.max(data2, (d)->d[0])])
        y.domain([0, 2*d3.max(data2, (d)->d[1])])
    # Add the X Axis
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)

    # Add the Y Axis
    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)

    # add xlabel
    svg.append("text")
        .attr("class", "x label")
        .attr("text-anchor", "end")
        .attr("x", width)
        .attr("y", height - 6)
        .text("length (m)")

    # add ylabel
    svg.append("text")
        .attr("class", "y label")
        .attr("text-anchor", "end")
        .attr("y", -50)
        .attr("dy", ".75em")
        .attr("transform", "rotate(-90)")
        .text("concentration (M)")


# Plot button info
frame = 0
window.lines = []
saved_data = null

clear_lines = () ->
    window.lines[i].remove() for i in [1...lines.length]


legend = (ions)->
    columns = ['ion', 'color']
    table = d3.select("body").append("table")
    thead = table.append("thead")
    tbody = table.append("tbody")

    # append the header row
    thead.append("tr")
        .selectAll("th")
        .data(columns)
        .enter()
        .append("th")
            .text((column)->column)

    # create a row for each object in the data
    rows = tbody.selectAll("tr")
                .data(ions)
                .enter()
                .append("tr")

    # create a cell in each row for each column
    cells = rows.selectAll("td")
        .data((row)->
            columns.map((column)->
                if(column == 'ion')
                    {column: column, value: row}
                else
                    {column: column, value: ions.indexOf(row)}))
        .enter()
        .append("td")
        .attr("style", "font-family: Courier")
            .html((d)->
                if(typeof(d.value) == 'string')
                    d.value
                else
                    d3.select(this).style({"background-color":  p(d.value%10)})
                )
    table


window.plot = ()->
    frame = 0
    # clear_lines()
    file = document.getElementById("file_input")
                   .value
                   .replace("C:\\fakepath\\", "")

    plotter = d3.json(file, (error, data)->
        saved_data = data
        for i in [0...data.electrolytes[frame][1].concentrations.length]

            # Add axes
            if i == 0
                make_axes(d3.zip(
                    data.electrolytes[frame][1].nodes,
                    data.electrolytes[frame][1].concentrations[i]))


            # Add the valueline path.
            window.lines[i] = svg.append("path")
                          .attr("class", "line")
                          .attr("d", valueline(d3.zip(
                            data.electrolytes[frame][1].nodes,
                            data.electrolytes[frame][1].concentrations[i])))
                          .attr("stroke", p(i%10))



        my_legend = legend(data.ions, ['name', 'pKa'])
    )

window.next = (time)->
    frame++
    update_lines(frame, time)

window.prev = (time)->
    frame--
    update_lines(frame, time)

update_lines = (frame, time)->
    for i in [0...saved_data.electrolytes[frame][1].concentrations.length]
        lines[i].transition().duration(time)
                .attr("d", valueline(d3.zip(
                    saved_data.electrolytes[frame][1].nodes,
                    saved_data.electrolytes[frame][1].concentrations[i])))

window.play = ()->
    while(frame<saved_data.electrolytes.length)
        next(1000)
