// Karma configuration

module.exports = function(karma) {
  karma.set({

    // base path, that will be used to resolve files and exclude
    basePath: '../',


    // frameworks to use
    frameworks: ['jasmine'],


    // list of files / patterns to load in the browser
    files: [
      // External files
      'http://cdnjs.cloudflare.com/ajax/libs/jquery/2.0.3/jquery.min.js',
      'http://cdnjs.cloudflare.com/ajax/libs/foundation/5.1.1/js/foundation.min.js',
      'http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular.js',
      'http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular-route.js',
      'http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular-resource.js',
      'http://cdnjs.cloudflare.com/ajax/libs/angular.js/1.2.10/angular-cookies.js',
      'http://cdnjs.cloudflare.com/ajax/libs/d3/3.4.2/d3.min.js',
      'http://cdnjs.cloudflare.com/ajax/libs/holder/2.3.1/holder.js',

      // Program files
      '_public/js/templates.js',
      '_public/js/app.js',

      // Specs

      // Load mocks directly from bower
      'bower_components/angular-mocks/angular-mocks.js',

      'test/app/**/*.spec.*'
    ],


    // list of files to exclude
    exclude: [
    ],


    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress'],


    // web server port
    port: 9876,


    // cli runner port
    runnerPort: 9100,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: karma.LOG_DISABLE || karma.LOG_ERROR || karma.LOG_WARN || karma.LOG_INFO || karma.LOG_DEBUG
    logLevel: karma.LOG_ERROR,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],


    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 60000,


    // Plugins to load
    plugins: [
      'karma-jasmine',
      'karma-coffee-preprocessor',
      'karma-phantomjs-launcher'
    ],


    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: true
  });
};
