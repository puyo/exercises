var path = require('path');
var webpack = require('webpack');

module.exports = {
  //choose a dev tool to enhance debugging. "eval" means that each module will be executed with eval.
  //eval takes module and stringify it - build/rebuild speed very fast
  devtool: 'eval',

  //entry points on modules that are loaded on the start, they all bundle together in 1 file
  entry: [
    'webpack-dev-server/client?http://0.0.0.0:8080',    //path to js files (client)
    'webpack/hot/only-dev-server',                        //path to js files (server) with our plugin it ll send pieces of changed code
    './scripts/main.js'
  ],

  //the output of the app
  output: {
    path: path.resolve('build'),    //the name of folder where bundle.js ll live
    filename: 'bundle.js',
    publicPath: '/static/'
  },

  //add additional plugins to the compiler
  plugins: [
    new webpack.HotModuleReplacementPlugin()    //hot-module replacement. the updated module is replaced and via socket shown up on the page
  ],

  //when we require or import files we don't need to tell the extension of the files .js and .jsx
  resolve: {
    extensions: ['', '.js', '.jsx']
  },

  module: {
    //options that can affect normal modules
    //tells webpack how to handle different extensions(automaticaly applies loaders)
    loaders: [
      {
        test: /\.jsx?$/,         //is commonly used to match the file extension
        loaders: ['react-hot', 'babel?presets[]=es2015&presets[]=react'],      //'react-hot' goes here as well, name of the loader that handles this condition
        include: [path.resolve('scripts')]   //is commonly used to match the directories
        //or we might have an exclude: [/node_module/] - if we don't have a scripts folder and our jsx files in the root of the app
        // "exclude" should be used to exclude exceptions
        // try to prefer "include" when possible
      },
      {
        test: /\.css$/,
        loader: 'style!css?sourceMap&modules',
        include: [path.resolve('scripts')]
      }
    ]
  },
  stats: {
    colors: true
  },
  devServer: {
    hot: true,
    stats: {
      chunkModules: false,
      colors: true
    }
  }
};
