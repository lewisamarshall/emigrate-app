(function() {
  var clear_lines, frame, height, legend, make_axes, margin, p, saved_data, svg, update_lines, valueline, width, x, xAxis, y, yAxis;

  margin = {
    top: 30,
    right: 20,
    bottom: 30,
    left: 100
  };

  width = 900 - margin.left - margin.right;

  height = 450 - margin.top - margin.bottom;

  x = d3.scale.linear().range([0, width]);

  y = d3.scale.linear().range([height, 0]);

  xAxis = d3.svg.axis().scale(x).orient("bottom").ticks(5);

  yAxis = d3.svg.axis().scale(y).orient("left").ticks(5);

  valueline = d3.svg.line().x(function(d) {
    return x(d[0]);
  }).y(function(d) {
    return y(d[1]);
  });

  svg = d3.select("body").append("svg").attr("width", width + margin.left + margin.right).attr("height", height + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  p = d3.scale.category10();

  make_axes = function(data2) {
    x.domain([
      0, d3.max(data2, function(d) {
        return d[0];
      })
    ]);
    return y.domain([
      0, 2 * d3.max(data2, function(d) {
        return d[1];
      })
    ]);
  };

  svg.append("g").attr("class", "x axis").attr("transform", "translate(0," + height + ")").call(xAxis);

  svg.append("g").attr("class", "y axis").call(yAxis);

  svg.append("text").attr("class", "x label").attr("text-anchor", "end").attr("x", width).attr("y", height - 6).text("length (m)");

  svg.append("text").attr("class", "y label").attr("text-anchor", "end").attr("y", -50).attr("dy", ".75em").attr("transform", "rotate(-90)").text("concentration (M)");

  frame = 0;

  window.lines = [];

  saved_data = null;

  clear_lines = function() {
    var i, _i, _ref, _results;
    _results = [];
    for (i = _i = 1, _ref = lines.length; 1 <= _ref ? _i < _ref : _i > _ref; i = 1 <= _ref ? ++_i : --_i) {
      _results.push(window.lines[i].remove());
    }
    return _results;
  };

  legend = function(ions) {
    var cells, columns, rows, table, tbody, thead;
    columns = ['ion', 'color'];
    table = d3.select("body").append("table");
    thead = table.append("thead");
    tbody = table.append("tbody");
    thead.append("tr").selectAll("th").data(columns).enter().append("th").text(function(column) {
      return column;
    });
    rows = tbody.selectAll("tr").data(ions).enter().append("tr");
    cells = rows.selectAll("td").data(function(row) {
      return columns.map(function(column) {
        if (column === 'ion') {
          return {
            column: column,
            value: row
          };
        } else {
          return {
            column: column,
            value: ions.indexOf(row)
          };
        }
      });
    }).enter().append("td").attr("style", "font-family: Courier").html(function(d) {
      if (typeof d.value === 'string') {
        return d.value;
      } else {
        return d3.select(this).style({
          "background-color": p(d.value % 10)
        });
      }
    });
    return table;
  };

  window.plot = function() {
    var file, plotter;
    frame = 0;
    file = document.getElementById("file_input").value.replace("C:\\fakepath\\", "");
    return plotter = d3.json(file, function(error, data) {
      var i, my_legend, _i, _ref;
      saved_data = data;
      for (i = _i = 0, _ref = data.electrolytes[frame][1].concentrations.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        if (i === 0) {
          make_axes(d3.zip(data.electrolytes[frame][1].nodes, data.electrolytes[frame][1].concentrations[i]));
        }
        window.lines[i] = svg.append("path").attr("class", "line").attr("d", valueline(d3.zip(data.electrolytes[frame][1].nodes, data.electrolytes[frame][1].concentrations[i]))).attr("stroke", p(i % 10));
      }
      return my_legend = legend(data.ions, ['name', 'pKa']);
    });
  };

  window.next = function(time) {
    frame++;
    return update_lines(frame, time);
  };

  window.prev = function(time) {
    frame--;
    return update_lines(frame, time);
  };

  update_lines = function(frame, time) {
    var i, _i, _ref, _results;
    _results = [];
    for (i = _i = 0, _ref = saved_data.electrolytes[frame][1].concentrations.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      _results.push(lines[i].transition().duration(time).attr("d", valueline(d3.zip(saved_data.electrolytes[frame][1].nodes, saved_data.electrolytes[frame][1].concentrations[i]))));
    }
    return _results;
  };

  window.play = function() {
    var _results;
    _results = [];
    while (frame < saved_data.electrolytes.length) {
      _results.push(next(1000));
    }
    return _results;
  };

}).call(this);
