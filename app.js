const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

let employees = []; // in-memory storage
let nextId = 1;

// Home route
app.get('/', (req, res) => {
  res.send('Welcome to Employee Management Web App!');
});

// GET all employees
app.get('/employees', (req, res) => res.json(employees));

// GET employee by ID
app.get('/employees/:id', (req, res) => {
  const emp = employees.find(e => e.id == req.params.id);
  emp ? res.json(emp) : res.status(404).send('Employee not found');
});

// POST new employee
app.post('/employees', (req, res) => {
  const emp = { id: nextId++, ...req.body };
  employees.push(emp);
  res.status(201).json(emp);
});

// PUT update employee
app.put('/employees/:id', (req, res) => {
  const index = employees.findIndex(e => e.id == req.params.id);
  if (index !== -1) {
    employees[index] = { id: parseInt(req.params.id), ...req.body };
    res.json(employees[index]);
  } else res.status(404).send('Employee not found');
});

// DELETE employee
app.delete('/employees/:id', (req, res) => {
  employees = employees.filter(e => e.id != req.params.id);
  res.send('Employee deleted successfully');
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
