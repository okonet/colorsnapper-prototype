var connect = require('connect')
var serveStatic = require('serve-static')

var app = connect()

app.use(serveStatic('.', {'index': ['index.html']}))
app.use(serveStatic('./build'))
app.listen(3000)
