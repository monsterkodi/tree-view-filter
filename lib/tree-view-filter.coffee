TreeViewFilterView    = require './tree-view-filter-view'
{requirePackages}     = require 'atom-utils'
{CompositeDisposable} = require 'atom'

module.exports = TreeViewFilter =
    view: null
    subscriptions: null

    activate: (state) ->
        
        console.log 'activate'
        
        requirePackages('tree-view').then ([treeView]) =>
            
            # console.log 'got tree-view package'
            
            @subscriptions = new CompositeDisposable
            
            @tree = treeView
            @view = new TreeViewFilterView(@tree) #(state.treeViewFilterState, treeView)

            # console.log 'tree-view-filter', @view

            @subscriptions.add atom.commands.add @view.editor.element, 'core:confirm': => @editorConfirmed()
            @subscriptions.add atom.commands.add @view.editor.element, 'core:cancel': => @editorCanceled()

            # hide or show the filter editor if the tree view is toggled

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view:toggle', =>
                console.log 'tree-view:toggle', @tree.treeView?.is(':visible')
                if @tree.treeView?.is(':visible')
                    @view.hide()
                else
                    @view.show()

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view:show', =>
                console.log 'tree-view:show'
                @view.show()

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-filter:showAndFocus': => @showAndFocus()
            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-filter:toggle': => @toggle()
            
            # show and focus the filter editor if the tree-view is visible
            
            if @tree.treeView
                console.log 'treeview visible -> show and focus'
                @showAndFocus()
            else
                console.log 'treeview not visible!'

            console.log 'end tree-view package'

    editorConfirmed: ->
        console.log 'editor confirmed'
        @setFilterPattern @view.editor.getText()
        console.log @tree
        @tree?.treeView?.show?()

    editorCanceled: ->
        console.log 'canceled'
        
    setFilterPattern: (patternText) ->
        console.log 'setFilterPattern: ', patternText

    deactivate: ->
        console.log 'deactivate'
        @subscriptions.dispose()
        @view.destroy()

    serialize: ->
        console.log 'serialize'
        treeViewFilterState: @view.serialize()

    showAndFocus: ->
        @view.show()
        @view.focus()

    toggle: ->
        console.log 'toggle', @view.isVisible()
        if @view.isVisible()
            @view.hide()
        else
            @showAndFocus()
