var connect = require('connect')
var serveStatic = require('serve-static')
var port = Number(process.env.PORT || 5000);

var app = connect()

app.use(serveStatic('.', {'index': ['index.html']}))
app.use(serveStatic('./build'))
app.listen(port)
