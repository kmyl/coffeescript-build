CoffeescriptBuildView = require './coffeescript-build-view'

module.exports =
  coffeescriptBuildView: null

  activate: (state) ->
    @coffeescriptBuildView = new CoffeescriptBuildView(state.coffeescriptBuildViewState)

  deactivate: ->
    @coffeescriptBuildView.destroy()

  serialize: ->
    coffeescriptBuildViewState: @coffeescriptBuildView.serialize()
