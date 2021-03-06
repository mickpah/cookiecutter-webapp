module.exports = (grunt) ->

  grunt.initConfig {

    pkg: grunt.file.readJSON 'package.json'

    # compile coffee source files
    coffee:
      app:
        expand: true
        src: ['**/*.coffee']
        cwd: '{{ cookiecutter.app_name }}/frontend/client/coffee'
        dest: '{{ cookiecutter.app_name }}/frontend/static/js/'
        ext: '.js'
        options:
          bare: false
          preserve_dirs: true
          base_path: '{{ cookiecutter.app_name }}/frontend/client/coffee'

    # compile coffee-react source files
    cjsx:
      app:
        expand: true
        src: ['**/*.cjsx']
        cwd: '{{ cookiecutter.app_name }}/frontend/client/coffee'
        dest: '{{ cookiecutter.app_name }}/frontend/static/js'
        ext: '.js'
        options:
          base: false
          preserve_dirs: true
          base_path: '{{ cookiecutter.app_name }}/frontend/client/coffee'

    # watch for file changes and react
    watch:
      app:
        files: [
          '{{ cookiecutter.app_name }}/frontend/client/coffee/**/*.coffee',
          '{{ cookiecutter.app_name }}/frontend/client/coffee/**/*.cjsx',
        ]
        tasks: ['coffee:app', 'cjsx:app']

    # copy bower components to the frontend's static directory
    bowercopy:
      options:
        srcPrefix: 'bower_components'
        destPrefix: '{{ cookiecutter.app_name }}/frontend/static'
      scripts:
        files:
          'js/vendor/backbone.js': 'backbone/backbone.js'
          'js/vendor/bootstrap.js': 'bootstrap/dist/js/bootstrap.js'
          'js/vendor/html5shiv.js': 'html5shiv/dist/html5shiv.js'
          'js/vendor/lodash.js': 'lodash/dist/lodash.js'
          'js/vendor/jquery.js': 'jquery/dist/jquery.js'
          'js/vendor/modernizr.js': 'modernizr/modernizr.js'
          'js/vendor/plugins.js': 'html5-boilerplate/js/plugins.js'
          'js/vendor/pjax.js': 'pjax/src/pjax.js'
          'js/vendor/react.js': 'react/react-with-addons.js'
          'js/vendor/require.js': 'requirejs/require.js'
          'js/vendor/respond.js': 'respond/dest/respond.src.js'
          'js/vendor/zeroclipboard.js': 'zeroclipboard/dist/ZeroClipboard.js'
      stylesheets:
        files:
          'css/vendor/bootstrap.css': 'bootstrap/dist/css/bootstrap.css'
          'css/vendor/font-awesome.css': 'font-awesome/css/font-awesome.css'
      fonts:
        files:
          'fonts': 'font-awesome/fonts'
      flash:
        files:
          'swf/zeroclipboard.swf': 'zeroclipboard/dist/ZeroClipboard.swf'
  }

  grunt.loadNpmTasks 'grunt-bowercopy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffee-react'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['bowercopy', 'coffee', 'cjsx']
  grunt.registerTask 'develop', ['default, watch:app']

