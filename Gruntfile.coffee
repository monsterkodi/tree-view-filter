
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

        bumpup:
            file: 'package.json'

        shell:
            commit:
                command: 'git add . && git commit -m "filter"'
            push:
                command: 'git push'
            apm:
                command: 'apm publish minor'
            

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-bumpup'
    grunt.loadNpmTasks 'grunt-pepper'
    grunt.loadNpmTasks 'grunt-shell'

    grunt.registerTask 'default',   [ 'salt' ]
    grunt.registerTask 'push',      [ 'shell:commit', 'shell:push' ]
    grunt.registerTask 'publish',   [ 'bumpup',  'push', 'shell:apm' ]
