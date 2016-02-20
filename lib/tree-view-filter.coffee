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
            order: 2
        globalFilter:
            type: 'string'
            default: ""
            title: 'Global Filter: pattern that is used while the package is active'
            order: 1
        fuzzySearch:
            type: 'boolean'
            default: false
            title: 'Fuzzy search: always surround your search terms with *query*'
            order: 3
        caseInsensitive:
            type: 'boolean'
            default: false
            title: 'Case insensitive: make searches case insensitive'
            order: 4

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
                if @tree.treeView?.element? and @view.active
                    @view.show()
                else
                    @view.hide()

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view:show', =>
                if @view.active
                    @view.show()

            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-filter:activate': => @activateAndFocus()
            @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-filter:toggle': => @toggle()
            
            @subscriptions.add atom.config.onDidChange 'tree-view-filter.globalFilter', => @updateGlobalFilter()

            # show the filter editor if the tree-view is visible
            
            if state.treeViewFilterState?.active
                @view.activate()

    setFilterPattern: (patternText) ->
        @setFilterPatterns (p for p in patternText.split(' ') when p? and p.length)
                
    setFilterPatterns: (patterns=[]) ->
        pats = patterns.concat @globalPatterns()
        
        @include = (p for p in pats when p[0] != '!')
        @exclude = (p.substring(1) for p in pats when p[0] == '!')
        
        if atom.config.get('tree-view-filter.fuzzySearch')
            @include = @include.map (p) -> 
                if p.substr(0,1) != '*'
                    p = '*' + p
                if p.substr(p.length-1, 1) != '*'
                    p = p + '*'
                p
        
        fileEntries = @tree.treeView?.element?.querySelectorAll '.file.entry.list-item'
        if fileEntries?
            for fileEntry in fileEntries

                span = fileEntry.querySelector 'span.name'
                fileName = span.getAttribute 'data-name'     
                if fileName?           
                    fileEntry.style.display = @isFileNameFiltered(fileName) and 'none' or 'inherit'

        @showClearButton patterns.length > 0

    updateGlobalFilter: () -> @editorConfirmed()
    globalPatterns: () -> (p for p in atom.config.get('tree-view-filter.globalFilter').split(' ') when p? and p.length)
        
    isFileNameFiltered: (filePath) ->
        matchOptions = {}
        if atom.config.get('tree-view-filter.caseInsensitive')
            matchOptions['nocase'] = true
        if @exclude?
            for pattern in @exclude
                if minimatch(filePath, pattern, matchOptions)
                    return true
        if not @include? or @include.length == 0
            return false
        matches = false
        for pattern in @include
            if minimatch(filePath, pattern, matchOptions)
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

    activateAndFocus: ->
        @view.activate()
        @view.focus()

    toggle: ->
        if @view.active
            @clearFilter()
            @view.deactivate()
        else
            @activateAndFocus()
        
        
