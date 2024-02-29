const session = require('express-session');

const { countAccess } = require('./src/metrics');
const { isUserLoggedIn, validateUser } = require('./src/login');


const express = require('express');
const app = express();

app.use(countAccess);
app.use(express.json());
app.use('/static', express.static('public'));
app.use(session({
  cookie: { maxAge: 5 * 60 * 1000 },
  saveUninitialized: false,
  secret: 'keboard cat',
  resave: false,
  name: 'sessionId',
  store: new session.MemoryStore()
}));
    
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

app.get('/login', (req, res) => {
  res.sendFile(__dirname + '/public/login.html');
});

app.post('/login', (req, res) => {
  const { username, password } = req.body;
  isValidUser = validateUser(username, password);

  if(isValidUser) {
    req.session.username = username;
    res.send({ success: true });
    return;
  }

  res.send({ success: false });
});

app.get('/me', isUserLoggedIn, (req, res) => {
  res.send(`Welcome, ${req.session.username}`);
  // res.sendFile(__dirname + '/public/me.html');
});

app.get('/health', (req, res) => {
  res.send('OK');
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
