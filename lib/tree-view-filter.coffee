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
    config:
        liveUpdate:
            type: 'boolean'
            default: false
            title: 'Live Update: update the tree view while entering patterns'
        globalFilter:
            type: 'string'
            default: ""
            title: 'Global Filter: pattern that is used while the package is active'

    activate: (state) ->
                
        requirePackages('tree-view').then ([treeView]) =>
                        
            @subscriptions = new CompositeDisposable
            
            @tree = treeView
            @view = new TreeViewFilterView(@tree)

            @subscriptions.add atom.commands.add @view.editor.element, 'core:confirm': => @editorConfirmed()
            @subscriptions.add atom.commands.add @view.editor.element, 'core:cancel':  => @editorCanceled()

            @view.clear.addEventListener 'click', => @editorCleared()
            @view.editor.getModel().onDidChange => @editorChanged()

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
            
            @subscriptions.add atom.config.onDidChange 'tree-view-filter.globalFilter', => @updateGlobalFilter()

            # show the filter editor if the tree-view is visible
            
            if @tree.treeView and state.treeViewFilterState?.visible
                @view.show()

    setFilterPattern: (patternText) ->
        @setFilterPatterns (p for p in patternText.split(' ') when p? and p.length)
                
    setFilterPatterns: (patterns) ->
        pats = patterns.concat @globalPatterns()
        
        @include = (p for p in pats when p[0] != '!')
        @exclude = (p.substring(1) for p in pats when p[0] == '!')
        
        fileEntries = @tree.treeView.element.querySelectorAll '.file.entry.list-item'
        for fileEntry in fileEntries

            span = fileEntry.querySelector 'span.name'
            fileName = span.getAttribute 'data-name'                
            fileEntry.style.display = @isFileNameFiltered(fileName) and 'none' or 'inherit'

        @showClearButton patterns.length > 0

    updateGlobalFilter: () -> @editorConfirmed()
    globalPatterns: () -> (p for p in atom.config.get('tree-view-filter.globalFilter').split(' ') when p? and p.length)
        
    isFileNameFiltered: (filePath) ->
        if @exclude?
            for pattern in @exclude
                if minimatch(filePath, pattern)
                    return true
        if not @include? or @include.length == 0
            return false
        matches = false
        for pattern in @include
            if minimatch(filePath, pattern)
                matches = true
        not matches
        
    showClearButton: (visible) -> @view.clear.style.display = visible and 'inherit' or 'none'

    clearFilter:     -> @setFilterPatterns []
    editorConfirmed: -> @setFilterPattern @view.editor.getText()
    editorCanceled:  -> @view.editor.setText ""; @clearFilter()
    editorChanged:   -> 
        if atom.config.get('tree-view-filter.liveUpdate')
            @editorConfirmed()
        else
            @showClearButton @view.editor.getText().trim().length
            
    editorCleared: -> 
        if @view?
            @view.editor.setText ""
            @clearFilter()
        
    deactivate: ->
        @clearFilter()
        @subscriptions.dispose()
        @view.destroy()

    serialize: ->
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
        
        
