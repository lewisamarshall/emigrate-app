exporter = this

throttle = (fn, threshhold, scope) ->
  threshhold || (threshhold = 250)
  last = null
  deferTimer = null

  return ->
    context = scope || this
    now = +new Date
    # console.log('now: ' + now)
    # console.log('last: ' + last)
    args = arguments

    if (last && now < last + threshhold)
      new_thresh = last + threshhold - now
      clearTimeout(deferTimer)
      deferTimer = setTimeout(->
        last = now
        fn.apply(context, args)
      , new_thresh)
    else
      clearTimeout(deferTimer)
      last = now
      fn.apply(context, args)

exporter.throttle = throttle
