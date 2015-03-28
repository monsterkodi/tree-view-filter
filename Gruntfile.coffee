
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
                command: 'git add . && git commit -m "screencast"'
            push:
                command: 'git push'
            

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-bumpup'
    grunt.loadNpmTasks 'grunt-pepper'
    grunt.loadNpmTasks 'grunt-shell'

    grunt.registerTask 'default',   [ 'salt' ]
    grunt.registerTask 'publish',   [ 'bumpup', 'shell:commit', 'shell:push' ]
