
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

        shell:
            commit:
                command: 'git add . && git commit -m "bumpup removed"'
            push:
                command: 'git push'
            apm:
                command: 'apm publish patch'
            

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-pepper'
    grunt.loadNpmTasks 'grunt-shell'

    grunt.registerTask 'default',   [ 'salt' ]
    grunt.registerTask 'push',      [ 'shell:commit', 'shell:push' ]
    grunt.registerTask 'publish',   [ 'push', 'shell:apm' ]
