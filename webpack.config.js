var path = require("path");
var webpack = require("webpack");

module.exports = {
  name: "ColorSnapper",
  entry: "./src/index.coffee",
  output: {
    path: path.join(__dirname, "build"),
    publicPath: "build/",
    filename: "[name].js",
    chunkFilename: "[name].[id].js"
  },
  plugins: [
    new webpack.ProvidePlugin({
      jQuery: "jquery",
      $: "jquery",
      _: "lodash"
    }),
    new webpack.HotModuleReplacementPlugin()
  ],
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" },
      { test: /\.json$/, loader: "json" },
      { test: /\.css$/, loader: "style!css" },
      { test: /\.scss$/, loaders: [
          "style-loader",
          "css-loader",
          "autoprefixer-loader?browsers=last 2 version",
          "sass-loader?imagePath=../"
        ]
      },
      { test: /\.(png|svg)$/, exclude: /bgs\//, loader: "url?limit=15000" },
      { test: /\.(png|jpg)$/, include: /bgs\//, loader: "file" },
      { test: /\.(ttf)$/, loader: "url?limit=15000" }
    ]
  },
  resolve: {
    root: path.join(__dirname, "src"),
    modulesDirectories: ["node_modules", "web_modules"],
    extensions: ["", ".webpack.js", ".js", ".coffee", ".scss"],
    alias: {}
  }
};
