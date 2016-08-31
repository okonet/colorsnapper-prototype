var path = require("path");
var webpack = require("webpack");
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: "./src/index.coffee",
  output: {
    path: path.join(__dirname, "build"),
    publicPath: "/",
    filename: "[name].js",
    chunkFilename: "[name].[id].js"
  },
  plugins: [
    new HtmlWebpackPlugin({
      filename: "index.html",
      template: "./index.html"
    }),
    new webpack.ProvidePlugin({
      jQuery: "jquery",
      $: "jquery",
      _: "lodash"
    })
  ],
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" },
      { test: /\.html$/, loader: "html" },
      { test: /\.json$/, loader: "json" },
      { test: /\.css$/, loader: "style!css" },
      { test: /\.scss$/, loaders: [
          "style-loader",
          "css-loader",
          "autoprefixer-loader?browsers=last 2 version",
          "sass-loader"
        ]
      },
      { test: /\.(png|svg)$/, exclude: /bgs\//, loader: "url?limit=15000" },
      { test: /\.(png|jpg)$/, include: /bgs\//, loader: "file" },
      { test: /\.(ttf)$/, loader: "url?limit=15000" }
    ]
  },
  resolve: {
    root: path.join(__dirname, "src"),
    extensions: ["", ".js", ".coffee", ".scss"],
    alias: {}
  }
};
