TreeViewFilterView    = require './tree-view-filter-view'
minimatch             = require 'minimatch'
{requirePackages}     = require 'atom-utils'
{CompositeDisposable} = require 'atom'

###
00000000  000  000      000000000  00000000  00000000 
000       000  000         000     000       000   000
000000    000  000         000     0000000   0000000  
000       000  000         000     000       000   000
000       000  0000000     000     00000000  000   000
###

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

    setFilterPattern: (patternText) ->
        console.log 'setFilterPattern: ', patternText, @tree.treeView.element        
        fileEntries = @tree.treeView.element.querySelectorAll '.file.entry.list-item'
        dirEntries = @tree.treeView.element.querySelectorAll '.directory.entry'
        console.log dirEntries, fileEntries
        for fileEntry in fileEntries
            console.log fileEntry
            span = fileEntry.querySelector 'span.name'
            fileName = span.getAttribute 'data-name'
            console.log fileName
            if not minimatch(fileName, patternText)
                fileEntry.style.display = 'none'
        # li.file.entry.list-item

    editorConfirmed: ->
        console.log 'editor confirmed'
        @setFilterPattern @view.editor.getText()
        # console.log @tree
        @tree?.treeView?.show?()

    editorCanceled: ->
        console.log 'canceled'
        
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
