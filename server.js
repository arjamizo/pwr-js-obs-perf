var express = require('express');
var app = express();

app.use(express.static(__dirname + '/js/'));

app.get('/', function (req, res) {
    res.sendFile('./js/index.html', {root: __dirname});
});

app.listen(process.env.PORT || 3000);

