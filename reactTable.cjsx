# coffeelint: disable=max_line_length
ReactTable = React.createClass
  getInitialState: ->
    data: [
      {zone: 'le', length: 5, solution: 'buffer1'},
      {zone: 'te', length: 10, solution: 'buffer2'},
      {zone: 'sample', length: 3, solution: 'buffer3'},
    ]
    columns: ['zone', 'length', 'solution']

  render: ->
    <table className="react-table" border="1">
      <TableHeader columns={@state.columns}/>
      <tbody>
        {for rowdata, i in @state.data
          <TableRow onRemove={@removeRow}
                    data={rowdata}
                    columns={@state.columns}
                    index={i}
                    key={i} />
        }
      </tbody>
      <tr><td><AddButton handleClick={@addRow}/></td></tr>
    </table>

  addRow: ->
    newData = @state.data.concat {zone: 'sample', length: 3, solution: 'buffer3'}

    @setState(
      data: newData
      )
  removeRow: (id)->
    newData = (row for row, i in @state.data when i isnt id)
    @setState(
      data: newData
      )

TableRow = React.createClass
  render: ->
    <tr>
      <td><RemoveButton rowId={@props.index} handleClick={@props.onRemove}/></td>
      {for column, i in @props.columns
        <td key={i}>{@props.data[column]}</td>
      }
      <td><IonSelector value='hi' options={['hi', 'lo', 'none']} /></td>
    </tr>

TableHeader = React.createClass
  render: ->
    <thead>
    <tr>
      <th></th>
      {for column, i in @props.columns
        <th key={i}>{column}</th>
      }
    </tr>
    </thead>

RemoveButton = React.createClass
  render: ->
    <button onClick={@clickHandler}>Remove</button>

  clickHandler: ->
    @props.handleClick(@props.rowId)

AddButton = React.createClass
  render: ->
    <button onClick={@props.handleClick}>Add</button>

IonSelector = React.createClass
  render: ->
    <select value={@props.value} onChange={@handleChange}>
      {for option, i in @props.options
        <option key={i} value={option}>{option}</option>
      }
    </select>

  handleChange: (event) ->
    value = event.target.value
    if @props.changeHandler?
      @props.changeHandler(value)
    else
      console.log(value)

React.render(<ReactTable/>, document.getElementById('content'))
