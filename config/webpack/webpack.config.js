const { webpackConfig, merge } = require('shakapacker')
const webpack = require('webpack');
const customConfig = {
  resolve: {
    extensions: ['.css']
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      Popper: ['popper.js', 'default'],
    }),
  ],
  module: {
    rules: [
      {
        test: /\.erb$/,
        enforce: "pre",
        loader: "rails-erb-loader"
      }
    ]
  }
}

module.exports = merge(webpackConfig, customConfig)
