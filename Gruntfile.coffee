
module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        salt:
            options:
                textMarker : '#!'
                dryrun     : false
                verbose    : false
                refresh    : false
            coffee:
                files:
                    'asciiText'   : ['./lib/**/*.coffee']

        watch:
          scripts:
            files: ['lib/*.coffee']
            tasks: ['salt']
            options:
                spawn:     true
                interrupt: false

        open:
          atom:
            path: 'https://atom.io/packages/tree-view-filter'
            app: 'Firefox'

        shell:
            commit:
                command: 'git add . && git commit -m "`head -n 1 CHANGELOG.md`"'
            push:
                command: 'git push'
            apm:
                command: 'apm publish patch'

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-pepper'
    grunt.loadNpmTasks 'grunt-shell'
    grunt.loadNpmTasks 'grunt-open'

    grunt.registerTask 'default',   [ 'salt' ]
    grunt.registerTask 'push',      [ 'shell:commit', 'shell:push' ]
    grunt.registerTask 'publish',   [ 'push', 'shell:apm', 'open:atom' ]
