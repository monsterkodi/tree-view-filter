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
            title: 'Live Update: filter the tree view while entering patterns'

    activate: (state) ->
                
        requirePackages('tree-view').then ([treeView]) =>
                        
            @subscriptions = new CompositeDisposable
            
            @tree = treeView
            @view = new TreeViewFilterView(@tree)
            @patterns = []

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
            
            # show and focus the filter editor if the tree-view is visible
            
            if @tree.treeView and state.treeViewFilterState?.visible
                @view.show()

    setFilterPattern: (patternText) ->
        @setFilterPatterns (p for p in patternText.split(' ') when p? and p.length)
                
    setFilterPatterns: (patterns) ->
        @patterns = patterns
        @treeViewService.reload()
        @showClearButton @patterns.length > 0

    isFileNameFiltered: (filePath) ->
        if not @patterns?
            return false
        matches = not @patterns.length
        for pattern in @patterns
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

    consumeTreeViewService: (treeViewService) ->
        # console.log 'consume', @
        @treeViewService = treeViewService
        @treeViewService.addFileNameFilterFunction @isFileNameFiltered.bind(@)
        
        
