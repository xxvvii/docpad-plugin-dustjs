fs = require 'fs'

loadFile = (dust, filename, name) ->
  fs.readFile filename, (err, data) ->
    if (err)
      console.log err
      return
    else
      try
        tmpl = dust.compile data.toString(), name
        dust.loadSource tmpl
        console.log name
      catch e
        console.log e
      return

module.exports = (dust, dir) ->
  walk = require('walk').walk
  path = require 'path'
  walk(dir).on 'file', (root, stat, next) ->
    filename = path.resolve(root + '/' + stat.name)
    basename = path.basename filename, '.dust'
    extname = path.extname filename
    prefix = path.relative dir, root

    # fix slash on windows platform
    prefix = prefix.replace /\\/g, '/'

    ## construct template partial name
    name = if prefix then prefix + '/' + basename else basename

    if (extname == '.dust')
      fs.watch filename, (event, file) ->
        if (event == 'change')
          console.log(file + ' has changed, reloading...')
          loadFile dust, filename, name
      loadFile dust, filename, name
    next()
  return