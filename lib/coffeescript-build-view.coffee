{View} = require 'atom'
coffee = require 'coffee-script'
fs = require 'fs'

module.exports =
class CoffeescriptBuildView extends View
  @content: ->
    @div class: 'coffeescript-build overlay from-top', =>
      @div class: "message", =>
        @h1 "Compiled!"
        @div =>
          @p "CoffeeScript file compiled into current directory. "
          @span class: "filename"

  initialize: (serializeState) ->
    atom.workspaceView.command "coffeescript-build:build", => @build()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: =>
    @detach()

  build: =>
    @self = this

    # Read current file
    editor = atom.workspace.getActiveEditor()
    fs.readFile editor.getPath(), 'utf8', (err, data) =>
      compiled = coffee.compile data
      newPath = editor.getPath().replace ".coffee", ".js"

      # Write to file
      fs.writeFile newPath, compiled, (err, data) =>
        # Change text in view
        @self.find(".filename").text "File path: " + newPath

        atom.workspaceView.append(@self)
        setTimeout(=>
          @self.destroy()
        , 4000);
