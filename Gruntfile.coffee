
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

        bumpup:
            file: 'package.json'

    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-bumpup'
    grunt.loadNpmTasks 'grunt-pepper'

    grunt.registerTask 'default',   [ 'salt' ]
