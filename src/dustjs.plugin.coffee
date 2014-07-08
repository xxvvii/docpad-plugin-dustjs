# Export Plugin
module.exports = (BasePlugin) ->
  class DustjsPlugin extends BasePlugin
    name: 'dustjs'
    dust: null,
    constructor: ->
      super
      config = @config
      @dust = require 'dustjs-linkedin'
      @loadPartials @dust, config.partials || './src/partials'

    loadPartials: require './lib/partials'
    render: (opts) ->
      if opts.inExtension == (@config.extensions ||'dust')
        dust = @dust
        try
          tmpl = dust.compileFn(opts.content)
        catch e
          console.log e
        if tmpl
          try
            tmpl opts.templateData, (err, out)->
              if (err)
                console.log err
              opts.content = out
              return
          catch e
            console.log e
        return

