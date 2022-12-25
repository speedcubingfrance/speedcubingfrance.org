const { webpackConfig, merge } = require('shakapacker')
const webpack = require('webpack');
const customConfig = {
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
        exclude: /node_modules/,
        enforce: "pre",
        loader: "rails-erb-loader"
      }
    ]
  }
}

module.exports = merge(webpackConfig, customConfig)
