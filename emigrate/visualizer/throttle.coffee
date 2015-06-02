throttle = (fn, threshhold, scope) ->
  threshhold || (threshhold = 250)
  last = null
  deferTimer = null

  return ->
    context = scope || this
    now = +new Date
    args = arguments

    if (last && now < last + threshhold)
      clearTimeout(deferTimer)
      deferTimer = setTimeout(->
        last = now
        fn.apply(context, args)
      , threshhold)
    else
      last = now
      fn.apply(context, args)

exporter = this
exporter.throttle = throttle
