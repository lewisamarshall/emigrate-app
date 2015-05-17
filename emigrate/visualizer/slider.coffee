exporter = this
d3 = require '../bower_components/d3/d3.js'

class Slider
  margin: {top: 10, right: 50, bottom: 10, left: 50}
  width: 900 - @::margin.left - @::margin.right
  height: 50 - @::margin.bottom - @::margin.top

  x_scale: null
  brush: null
  svg: null
  slider: null
  handle: null
  brushed: null


  constructor: (my_domain, @brush_event)->
    @make_slider(my_domain)

  make_slider: (domain)->
    @x_scale = d3.scale.linear()
      .domain([0, domain])
      .range([0, @width])
      .clamp(true)

    @brush = d3.svg.brush()
      .x(@x_scale)
      .extent([0, 0])


    @svg = d3.select("#sliderbox").append("svg")
      .attr("width", @width + @margin.left + @margin.right)
      .attr("height", @height + @margin.top + @margin.bottom)
      .append("g")
      .attr("transform", "translate(" + @margin.left + "," + @margin.top + ")")

    @svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + @height / 2 + ")")
      .call(d3.svg.axis()
        .scale(@x_scale)
        .orient("bottom")
        .tickFormat((d)->return d )
        .tickSize(0)
        .tickPadding(12))
      .select(".domain")
      .select(()->return this.parentNode.appendChild(this.cloneNode(true)))
        .attr("class", "halo")

    @slider = @svg.append("g")
      .attr("class", "slider")
      .call(@brush)

    @slider.selectAll(".extent,.resize")
      .remove()

    @slider.select(".background")
      .attr("height", @height)

    @handle = @slider.append("circle")
      .attr("class", "handle")
      .attr("transform", "translate(0," + @height / 2 + ")")
      .attr("r", 9)

    that = @

    @brushed = ->
      value = d3.round(that.brush.extent()[0])

      if (d3.event.sourceEvent)
        thing = d3.mouse(this)[0]
        value = d3.round(that.x_scale.invert(thing))
        that.brush.extent([value, value])
      that.handle.attr("cx", that.x_scale(value))
      that.brush_event(value)

    @brush.on("brush", @brushed)

exporter.Slider = Slider