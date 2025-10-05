// RedditP Node.js server with proper static file handling

var http = require('http');
var path = require('path');
var express = require('express');

var app = express();

app.set('port', process.env.PORT || 8080);

// CRITICAL: Static files MUST be registered BEFORE the catch-all route
const publicFolders = [
    '.well-known',
    'css',
    'images',
    'js'
];

// Serve static files - no special config needed, let Express handle it
for (let name of publicFolders) {
    app.use('/' + name, express.static(path.join(__dirname, name)));
}

// Catch-all route for the SPA - this MUST come AFTER static routes
app.get('/*', function (req, res) {
    res.sendFile(path.join(__dirname, 'index.html'));
});

var server = http.createServer(app);

server.listen(app.get('port'), function () {
    console.log("RedditP server listening at: http://localhost:" + app.get('port'));
});