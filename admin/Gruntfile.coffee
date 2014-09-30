module.exports = (grunt) ->
  grunt.initConfig

    # Ignored JS packages are being loaded through a public CDN.
    bower:
      compile:
        dest: '_public/admin/assets/'
        js_dest: '_public/dontuse/js/'
        css_dest: '_public/dontuse/css/'
        options:
          ignorePackages: ['angular',
                           'd3',
                           'fastclick',
                           'jquery',
                           'jquery-placeholder',
                           'jquery.cookie',
                           'modernizr',
                           'nvd3',
                           'showdown'
                          ]

    copy:
      assets:
        expand: true
        cwd: 'app/assets/'
        src: '**'
        dest: '_public/admin/assets/'

    concat:
      bowerjs:
        src: '_public/dontuse/js/**.js'
        dest: '_public/admin/js/bower.js'
      bowercss:
        src: '_public/dontuse/css/**.css'
        dest: '_public/admin/css/bower.css'
      vendorjs:
        src: 'vendor/**.js'
        dest: '_public/admin/js/vendor.js'
      vendorcss:
        src: 'vendor/**.css'
        dest: '_public/admin/css/vendor.css'

    coffee:
      compile:
        files:
          '_public/admin/js/app.js': ['app/wraith-auth.coffee',
                                      'app/app.coffee',
                                      'app/js/**/*.coffee',
                                      'app/ng/**/*.coffee']

    jade:
      index:
        src: 'app/index.jade'
        dest:'_public/admin/index.html'
      templates:
        expand: true
        cwd: 'app/templates/'
        src: '**/*.jade'
        dest: '_public/dontuse/'
        ext: '.html'

    ngtemplates:
      app:
        cwd: '_public/dontuse'
        src: '**/*.html'
        dest: '_public/admin/js/templates.js'
        options:
          module: 'templates'
          prefix: '/'
          standalone: true

    sass:
      compile:
        files:
          '_public/admin/css/app.css': 'app/css/**/*.sass'

    clean:
      templates: '_public/dontuse'

    watch:
      grunt:
        files: 'Gruntfile.coffee'
        tasks: ['newer:copy']
      coffee:
        files: 'app/**/*.coffee'
        tasks: ['newer:coffee']
      jade:
        files: 'app/**/*.jade'
        tasks: ['jade', 'ngtemplates', 'clean']
      sass:
        files: 'app/**/*.sass'
        tasks: ['newer:sass']

    connect:
      server:
        options:
          hostname: 'localhost'
          port: process.env.PORT || 5200
          base: '_public'
          middleware: (connect, options, middlewares) ->
            # Run the request through the proxy first
            middlewares.push require('grunt-connect-proxy/lib/utils').proxyRequest
            # Request was not filtered by proxy, respond with the index page
            middlewares.push (req, res, next) ->
              res.end(grunt.file.read('./_public/admin/index.html'))
            return middlewares
        proxies: [
          {
            context: '/__better_errors'
            host: 'localhost'
            port: 5100
          }
          {
            context: '/api'
            host: 'localhost'
            port: 5100
          }
          {
            context: '/omniauth'
            host: 'localhost'
            port: 5100
          }
          {
            context: '/uploads'
            host: 'localhost'
            port: 5100
          }
        ]

  grunt.loadNpmTasks('grunt-contrib-connect')
  grunt.loadNpmTasks('grunt-connect-proxy')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-concat')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-sass')
  grunt.loadNpmTasks('grunt-bower')
  grunt.loadNpmTasks('grunt-angular-templates')
  grunt.loadNpmTasks('grunt-newer')

  grunt.registerTask('build', ['bower', 'coffee', 'jade', 'copy', 'concat', 'ngtemplates', 'sass', 'clean'])
  grunt.registerTask('server', ['configureProxies:server', 'connect', 'watch'])
  grunt.registerTask('default', ['build', 'server'])