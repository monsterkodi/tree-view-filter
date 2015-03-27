TreeViewFilterView    = require './tree-view-filter-view'
{requirePackages}     = require 'atom-utils'
{CompositeDisposable} = require 'atom'

module.exports = TreeViewFilter =
    treeViewFilterView: null
    subscriptions: null

    activate: (state) ->
        
        console.log 'activate'
        
        requirePackages('tree-view').then ([treeView]) =>
            
            console.log 'got tree-view package'
            
            @subscriptions = new CompositeDisposable
            
            @treeViewFilterView = new TreeViewFilterView(treeView) #(state.treeViewFilterState, treeView)

            console.log 'tree-view-filter', @treeViewFilterView

            if treeView.treeView
                console.log 'treeview visible -> show'
                @treeViewFilterView.show()
            else
                console.log 'treeview not visible!'

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view:toggle', =>
                console.log 'tree-view:toggle'
                if treeView.treeView?.is(':visible')
                    @treeViewFilterView.show()
                else
                    @treeViewFilterView.hide()

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view:show', =>
                console.log 'tree-view:show'
                @treeViewFilterView.show()

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-filter:toggle': => @toggle()
            
            console.log 'end tree-view package'

    # createViews: ->
    #     return if @treeViewFilterView?
    #     @treeViewFilterView = new TreeViewFilterView()

    deactivate: ->
        console.log 'deactivate'
        @subscriptions.dispose()
        @treeViewFilterView.destroy()

    serialize: ->
        console.log 'serialize'
        treeViewFilterState: @treeViewFilterView.serialize()

    toggle: ->
        console.log 'toggle'
        if @treeViewFilterView.isVisible()
            @treeViewFilterView.hide()
        else
            @treeViewFilterView.show()
