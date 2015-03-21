{View} = require 'atom'
{EditorView} = require 'atom'
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

    if editor.getPath() != undefined
      @buildFromFile editor.getPath()
    else
      @buildFromText editor.buffer.getText()

  buildFromText: (text) =>
    compiled = coffee.compile text
    atom.workspace.getActiveEditor().setText compiled
    @buildFromFile editor.getPath()

  buildFromFile: (file) =>
    isCoffee = (file.indexOf(".coffee") > -1)
    isLiterateCoffee = (file.indexOf(".litcoffee") > -1)

    if isCoffee or isLiterateCoffee
      fs.readFile file, 'utf8', (err, data) =>
        compileOptions =
          literate: isLiterateCoffee
        
        compiled = coffee.compile data, compileOptions

        if isLiterateCoffee
          newPath = file.replace ".litcoffee", ".js"
        else
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
