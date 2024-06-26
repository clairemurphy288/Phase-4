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


// Define a route handler for the root path
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

// Route handler for the '/customers' path
app.get('/customers', (req, res) => {

    res.sendFile(__dirname + '/customers.html');
});

app.get('/drones', (req, res) => {

    res.sendFile(__dirname + '/drones.html');
});

app.get('/pilots', (req, res) => {

  res.sendFile(__dirname + '/pilots.html');
});

app.get('/products', (req, res) => {

    res.sendFile(__dirname + '/products.html');
});

app.get('/orders', (req, res) => {

  res.sendFile(__dirname + '/orders.html');
});

app.get('/views', (req, res) => {

    res.sendFile(__dirname + '/views.html');
});

app.post('/add_customer', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
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

  app.post('/increase_customer_credits', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Perform the MySQL query to insert the new customer
    connection.query('call increase_customer_credits (?, ?)',
     [data.uname, data.money], (error, results, fields) => {
      if (error) {
        console.error('Error increasing customer credits: ' + error);
        res.status(500).json({ error: 'Error increasing customer credits' });
        return;
      }
      
      // Send a success response
    //   res.status(200).json({ message: 'Customer added successfully' });
    });


    res.sendFile(__dirname + '/customers.html');

  });

  // Add drone pilot
  app.post('/add_drone_pilot', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Insert new drone pilot
    connection.query('call add_drone_pilot (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
     [data.username, data.first_name, data.last_name, data.address, data.birthdate, data.taxID, data.service, data.salary, data.licenseID, data.experience], (error, results, fields) => {
      if (error) {
        console.error('Error adding pilot: ' + error);
        res.status(500).json({ error: 'Error adding pilot' });
        return;
      }
      
    });


    res.sendFile(__dirname + '/pilots.html');

  });

  app.post('/add_drone', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Perform the MySQL query to insert the new customer
    connection.query('call add_drone (?, ?, ?, ?, ?)',
     [data.storeID, data.droneTag, data.capacity, data.remaining_trips, data.pilot], (error, results, fields) => {
      if (error) {
        console.error('Error adding drone: ' + error);
        res.status(500).json({ error: 'Error adding drone' });
        return;
      }
      
      // Send a success response
    //   res.status(200).json({ message: 'Customer added successfully' });
    });


    res.sendFile(__dirname + '/drones.html');

  });

  app.post('/swap_drone_control', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Swap drone control
    connection.query('call swap_drone_control (?, ?)',
     [data.incoming_pilot, data.outgoing_pilot], (error, results, fields) => {
      if (error) {
        console.error('Error swapping drone control: ' + error);
        res.status(500).json({ error: 'Error swapping drone control' });
        return;
      }
      
    });


    res.sendFile(__dirname + '/drones.html');

  });

  app.post('/repair_refuel_drone', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Repair refuel drone
    connection.query('call repair_refuel_drone (?, ?, ?)',
     [data.drone_store, data.drone_tag, data.refueled_trips], (error, results, fields) => {
      if (error) {
        console.error('Error repairing and refueling drone: ' + error);
        res.status(500).json({ error: 'Error repairing and refueling drone' });
        return;
      }
      
    });


    res.sendFile(__dirname + '/drones.html');

  });

  app.post('/begin_order', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    
    connection.query('call begin_order (?, ?, ?, ?, ?, ?, ?, ?)',
     [data.orderID, data.sold_on, data.purchased_by, data.carrier_store, data.carrier_tag, data.product_barcode, data.product_price, data.product_quantity], (error, results, fields) => {
      if (error) {
        console.error('Error beginning order: ' + error);
        res.status(500).json({ error: 'Error beginning order' });
        return;
      }
      
      // Send a success response
    //   res.status(200).json({ message: 'Customer added successfully' });
    });


    res.sendFile(__dirname + '/orders.html');

  });

  app.post('/add_order_line', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    
    connection.query('call add_order_line (?, ?, ?, ?)',
     [data.orderID, data.product_barcode, data.product_price, data.product_quantity], (error, results, fields) => {
      if (error) {
        console.error('Error adding order line: ' + error);
        res.status(500).json({ error: 'Error adding order line' });
        return;
      }
      
      // Send a success response
    //   res.status(200).json({ message: 'Customer added successfully' });
    });


    res.sendFile(__dirname + '/orders.html');

  });

  app.post('/deliver_order', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    
    connection.query('call deliver_order (?)',
     [data.orderID], (error, results, fields) => {
      if (error) {
        console.error('Error delivering order: ' + error);
        res.status(500).json({ error: 'Error delivering order' });
        return;
      }
      
      // Send a success response
    //   res.status(200).json({ message: 'Customer added successfully' });
    });


    res.sendFile(__dirname + '/orders.html');

  });

  app.post('/cancel_order', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    
    connection.query('call cancel_order (?)',
     [data.orderID], (error, results, fields) => {
      if (error) {
        console.error('Error cancelling order: ' + error);
        res.status(500).json({ error: 'Error cancelling order' });
        return;
      }
      
      // Send a success response
    //   res.status(200).json({ message: 'Customer added successfully' });
    });


    res.sendFile(__dirname + '/orders.html');

  });

  app.post('/add_product', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Insert new product
    connection.query('call add_product (?, ?, ?)',
     [data.barcode, data.name, data.weight], (error, results, fields) => {
      if (error) {
        console.error('Error adding product: ' + error);
        res.status(500).json({ error: 'Error adding product' });
        return;
      }
      
    });


    res.sendFile(__dirname + '/products.html');

  });

  app.post('/remove_customer', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Remove customer
    connection.query('call remove_customer (?)',
     [data.remove_username], (error, results, fields) => {
      if (error) {
        console.error('Error removing customer: ' + error);
        res.status(500).json({ error: 'Error removing customer' });
        return;
      }
      
    });


    res.sendFile(__dirname + '/customers.html');

  });

  app.post('/remove_drone_pilot', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Remove drone pilot
    connection.query('call remove_drone_pilot (?)',
     [data.remove_username], (error, results, fields) => {
      if (error) {
        console.error('Error removing drone pilot: ' + error);
        res.status(500).json({ error: 'Error removing drone pilot' });
        return;
      }
      
    });


    res.sendFile(__dirname + '/pilots.html');

  });

  app.post('/remove_drone', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Remove drone
    connection.query('call remove_drone (?, ?)',
     [data.remove_storeID, data.remove_droneTag], (error, results, fields) => {
      if (error) {
        console.error('Error removing drone: ' + error);
        res.status(500).json({ error: 'Error removing drone' });
        return;
      }
      
    });


    res.sendFile(__dirname + '/drones.html');

  });

  app.post('/remove_product', (req, res) => {
    const data = req.body;
    
    console.log(data)

  
    // Remove product
    connection.query('call remove_product (?)',
     [data.remove_barcode], (error, results, fields) => {
      if (error) {
        console.error('Error removing product: ' + error);
        res.status(500).json({ error: 'Error removing product' });
        return;
      }
      
    });


    res.sendFile(__dirname + '/products.html');

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
    // Query the database to get drone_pilot_roster data
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

app.get('/drone_traffic_control', (req, res) => {
    // Query the database to get drone_traffic_control data
    connection.query('SELECT * FROM drone_traffic_control', (error, results, fields) => {
        if (error) {
            console.error('Error querying view: ' + error);
            res.status(500).send('Error querying view');
            return;
        }
        console.log('Results from view:');
        console.log(results);

        // Render the EJS template with the retrieved data
        res.render('drone_traffic_control', { data: results });
    });
});

app.get('/most_popular_products', (req, res) => {
    // Query the database to get most_popular_product data
    connection.query('SELECT * FROM most_popular_products', (error, results, fields) => {
        if (error) {
            console.error('Error querying view: ' + error);
            res.status(500).send('Error querying view');
            return;
        }
        console.log('Results from view:');
        console.log(results);

        // Render the EJS template with the retrieved data
        res.render('most_popular_products', { data: results });
    });
});

app.get('/orders_in_progress', (req, res) => {
    // Query the database to get orders_in_progress data
    connection.query('SELECT * FROM orders_in_progress', (error, results, fields) => {
        if (error) {
            console.error('Error querying view: ' + error);
            res.status(500).send('Error querying view');
            return;
        }
        console.log('Results from view:');
        console.log(results);

        // Render the EJS template with the retrieved data
        res.render('orders_in_progress', { data: results });
    });
});

app.get('/role_distribution', (req, res) => {
    // Query the database to get role_distribution data
    connection.query('SELECT * FROM role_distribution', (error, results, fields) => {
        if (error) {
            console.error('Error querying view: ' + error);
            res.status(500).send('Error querying view');
            return;
        }
        console.log('Results from view:');
        console.log(results);

        // Render the EJS template with the retrieved data
        res.render('role_distribution', { data: results });
    });
});

app.get('/store_sales_overview', (req, res) => {
    // Query the database to get store_sales_overview data
    connection.query('SELECT * FROM store_sales_overview', (error, results, fields) => {
        if (error) {
            console.error('Error querying view: ' + error);
            res.status(500).send('Error querying view');
            return;
        }
        console.log('Results from view:');
        console.log(results);

        // Render the EJS template with the retrieved data
        res.render('store_sales_overview', { data: results });
    });
});

// Define the port number
const port = process.env.PORT || 3000;

// Start the server and listen on the specified port
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});





