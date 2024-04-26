const express = require('express');
const cors = require('cors');

var mysql = require('mysql');


// Create an Express application
const app = express();
app.use(cors());
app.use(express.json()); // Middleware to parse JSON request bodies
app.set('view engine', 'ejs');
app.use(express.urlencoded({ extended: true }));


var connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'strong_password%',
    database: 'drone_dispatch'
});

connection.connect();

connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
    if (error) throw error;
    console.log('The solution is: ', results[0].solution);
});






// Define a route handler for the root path
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

// Route handler for the '/customers' path
app.get('/customers', (req, res) => {

    res.sendFile(__dirname + '/customers.html');
});

app.get('/views', (req, res) => {

    res.sendFile(__dirname + '/views.html');
});

app.post('/add_customer', (req, res) => {
    const data = req.body;
    
    console.log(data)   // Assuming the request body contains 'name' and 'email' fields

  
    // Perform the MySQL query to insert the new customer
    connection.query('call add_customer (?, ?, ?, ?, ?, ?, ?)',
     [data.username, data.first_name, data.last_name, data.address, data.birthdate, data.rating, data.credit], (error, results, fields) => {
      if (error) {
        console.error('Error adding customer: ' + error);
        res.status(500).json({ error: 'Error adding customer' });
        return;
      }
      
      // Send a success response
    //   res.status(200).json({ message: 'Customer added successfully' });
    });


    res.sendFile(__dirname + '/customers.html');

  });



  app.get('/customer_credit_check', (req, res) => {
    // Query the database to get customer credit check data
    connection.query('SELECT * FROM customer_credit_check', (error, results, fields) => {
        if (error) {
            console.error('Error querying view: ' + error);
            res.status(500).send('Error querying view');
            return;
        }
        console.log('Results from view:');
        console.log(results);

        // Render the EJS template with the retrieved data
        res.render('customer_credit_check', { data: results });
    });
});

app.get('/drone_pilot_roster', (req, res) => {
    // Query the database to get customer credit check data
    connection.query('SELECT * FROM drone_pilot_roster', (error, results, fields) => {
        if (error) {
            console.error('Error querying view: ' + error);
            res.status(500).send('Error querying view');
            return;
        }
        console.log('Results from view:');
        console.log(results);

        // Render the EJS template with the retrieved data
        res.render('drone_pilot_roster', { data: results });
    });
});




// Define the port number
const port = process.env.PORT || 3000;

// Start the server and listen on the specified port
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});





