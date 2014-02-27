{View} = require 'atom'
coffee = require 'coffee-script'
fs = require 'fs'
CoffeescriptBuildErrorView = require './coffeescript-build-error'

module.exports =
class CoffeescriptBuildView extends View
  @content: ->
    @div class: 'coffeescript-build overlay from-top', =>
      @div class: "message", =>
        @h1 "Compiled!"
        @div =>
          @p "CoffeeScript file compiled into current directory. "
          @span class: "filename"

  initialize: (serializeState) =>
    @self = this
    atom.workspaceView.command "coffeescript-build:build", => @build()
    atom.workspaceView.command "coffeescript-build:contextbuild", => @buildFromContext()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: =>
    @detach()

  buildFromContext: ->
    # Get selected item
    @buildFromFile atom.workspaceView.getActivePaneItem().getPath()

  build: =>
    # Read current file
    editor = atom.workspace.getActiveEditor()
    @buildFromFile editor.getPath()

  buildFromFile: (file) =>
    if file.indexOf(".coffee") > -1
      fs.readFile file, 'utf8', (err, data) =>
        compiled = coffee.compile data
        newPath = file.replace ".coffee", ".js"

        # Write to file
        fs.writeFile newPath, compiled, (err, data) =>
          # Change text in view
          @self.find(".filename").text "File path: " + newPath

          atom.workspaceView.append(@self)
          setTimeout(=>
            @self.destroy()
          , 3000);
    else
      # Show error
      errorView = new CoffeescriptBuildErrorView(text: "File `" + file + "` is not a CoffeeScript file")
      atom.workspaceView.append(errorView)
      setTimeout(=>
        errorView.detach()
      , 3000)
