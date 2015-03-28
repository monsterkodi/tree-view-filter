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
                
        requirePackages('tree-view').then ([treeView]) =>
                        
            @subscriptions = new CompositeDisposable
            
            @tree = treeView
            @view = new TreeViewFilterView(@tree)

            @subscriptions.add atom.commands.add @view.editor.element, 'core:confirm': => @editorConfirmed()
            @subscriptions.add atom.commands.add @view.editor.element, 'core:cancel':  => @editorCanceled()

            @view.clear.addEventListener 'click', => @editorCleared()

            # hide or show the filter editor if the tree view is toggled

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view:toggle', =>
                if @tree.treeView?.is(':visible')
                    @view.hide()
                else
                    @view.show()

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view:show', =>
                @view.show()

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-filter:show': => @show()
            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-filter:toggle': => @toggle()
            
            # show and focus the filter editor if the tree-view is visible
            
            if @tree.treeView and state.treeViewFilterState?.visible
                @view.show()

    setFilterPattern: (patternText) ->
        @setFilterPatterns (p for p in patternText.split(' ') when p? and p.length)
        
    setFilterPatterns: (patterns) ->
        # console.log 'setFilterPatterns: ', patterns, @tree.treeView.element     
        fileEntries = @tree.treeView.element.querySelectorAll '.file.entry.list-item'
        # dirEntries = @tree.treeView.element.querySelectorAll '.directory.entry'
        # console.log dirEntries, fileEntries            
        for fileEntry in fileEntries

            span = fileEntry.querySelector 'span.name'
            fileName = span.getAttribute 'data-name'

            matches = not patterns.length
            for pattern in patterns
                if minimatch(fileName, pattern)
                    matches = true
            if not matches
                fileEntry.style.display = 'none'
            else
                fileEntry.style.display = 'inherit'

    clearFilter:     -> @setFilterPatterns []
    editorConfirmed: -> @setFilterPattern @view.editor.getText()
    editorCanceled:  -> console.log 'canceled'
    editorCleared:   -> 
        if @view?
            @view.editor.setText ""
            @clearFilter()
        
    deactivate: ->
        # console.log 'deactivate'
        @subscriptions.dispose()
        @view.destroy()

    serialize: ->
        # console.log 'serialize'
        treeViewFilterState: @view.serialize()

    show: ->
        @view.show()
        @view.focus()

    toggle: ->
        if @view.isVisible()
            @clearFilter()
            @view.hide()
        else
            @show()
