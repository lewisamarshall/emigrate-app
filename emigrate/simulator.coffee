exporter = this

Link = require('./helpers/link').Link


class Constructor
  panes: null

  constructor: ->
    @set_panes()

  set_panes: ->
    @panes = {
      'numerics': document.getElementById('numerics'),
      'solutions': document.getElementById('solutions'),
      'fields': document.getElementById('fields'),
    }
    @show('numerics')

  show: (item)->
    @panes[item].style.display = 'inline'

  hide: (item)->
    @panes[item].style.display = 'none'

  showonly: (item)->
    for own k,v of @panes
      if k==item
        @show(k)
      else
        @hide(k)

  showall: ->
    for own k,v of @panes
      @show(k)

exporter.my_constructor = new Constructor()
