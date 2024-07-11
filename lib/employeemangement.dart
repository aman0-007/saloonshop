import 'package:flutter/material.dart';

class Employee {
  String email;
  String password;
  String name;
  String mobileNumber;
  String profileImage;

  Employee({
    required this.email,
    required this.password,
    required this.name,
    required this.mobileNumber,
    required this.profileImage,
  });

  // Method to update employee details
  void updateDetails({
    required String email,
    required String password,
    required String name,
    required String mobileNumber,
    required String profileImage,
  }) {
    this.email = email;
    this.password = password;
    this.name = name;
    this.mobileNumber = mobileNumber;
    this.profileImage = profileImage;
  }
}


class Employeemangement extends StatefulWidget {
  const Employeemangement({Key? key}) : super(key: key);

  @override
  State<Employeemangement> createState() => _EmployeemangementState();
}

class _EmployeemangementState extends State<Employeemangement> {
  late PageController _pageController;
  int _selectedTabIndex = 0; // Track the selected section index

  // Sample data for demonstration
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedTabIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Manage Employees',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Icon color set to white
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'My Employees',
                        style: TextStyle(
                          color: _selectedTabIndex == 0
                              ? Colors.blueAccent
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                        width: 100, // Expanded width for the underline
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 0
                                ? Colors.blueAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'Manage Employees',
                        style: TextStyle(
                          color: _selectedTabIndex == 1
                              ? Colors.blueAccent
                              : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                        width: 150, // Expanded width for the underline
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: _selectedTabIndex == 1
                                ? Colors.blueAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              children: [
                MyEmployeesSection(employees: employees),
                ManageEmployeesSection(
                  employees: employees,
                  onAddEmployee: _addNewEmployee,
                  onDeleteEmployee: _deleteEmployee,
                  onEditEmployee: _editEmployeeDetails,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNewEmployee(Employee newEmployee) {
    setState(() {
      employees.add(newEmployee);
      _pageController.jumpToPage(0); // Switch to My Employees page after adding
    });
  }

  void _editEmployeeDetails(Employee employee) {
    // Implement logic to edit employee details
    // For simplicity, we can just print employee details here
    print('Editing details of ${employee.name}');
  }

  void _deleteEmployee(Employee employee) {
    // Implement logic to delete employee
    setState(() {
      employees.remove(employee);
    });
  }
}

class MyEmployeesSection extends StatelessWidget {
  final List<Employee> employees;

  MyEmployeesSection({required this.employees});

  @override
  Widget build(BuildContext context) {
    return employees.isEmpty
        ? Center(
      child: Text(
        'No Employees',
        style: TextStyle(color: Colors.white),
      ),
    )
        : ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(employees[index].profileImage),
          ),
          title: Text(employees[index].name),
          subtitle: Text(employees[index].email),
        );
      },
    );
  }
}

class ManageEmployeesSection extends StatefulWidget {
  final List<Employee> employees;
  final Function(Employee) onAddEmployee;
  final Function(Employee) onDeleteEmployee;
  final Function(Employee) onEditEmployee;

  ManageEmployeesSection({
    required this.employees,
    required this.onAddEmployee,
    required this.onDeleteEmployee,
    required this.onEditEmployee,
  });

  @override
  _ManageEmployeesSectionState createState() => _ManageEmployeesSectionState();
}

class _ManageEmployeesSectionState extends State<ManageEmployeesSection> {
  TextEditingController _searchController = TextEditingController();
  List<Employee> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    filteredEmployees = widget.employees;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5.0),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: Colors.blueAccent.withOpacity(0.5)),
                onPressed: () {
                  _searchController.clear();
                  _filterEmployees('');
                },
              )
                  : null,
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              _filterEmployees(value);
            },
          ),
        ),



        Expanded(
          child: ListView.builder(
            itemCount: filteredEmployees.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(filteredEmployees[index].profileImage),
                  ),
                  title: Text(filteredEmployees[index].name),
                  subtitle: Text(filteredEmployees[index].email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditEmployeeDialog(context, filteredEmployees[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          widget.onDeleteEmployee(filteredEmployees[index]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0,bottom: 9),
              child: FloatingActionButton(
                onPressed: () {
                  _showAddEmployeeDialog(context);
                },
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _filterEmployees(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredEmployees = widget.employees
            .where((employee) =>
        employee.name.toLowerCase().contains(query.toLowerCase()) ||
            employee.email.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredEmployees = widget.employees;
      });
    }
  }

  void _showAddEmployeeDialog(BuildContext context) {
    Employee newEmployee = Employee(
      email: '',
      password: '',
      name: '',
      mobileNumber: '',
      profileImage: 'assets/profile_image.jpg', // Example image path
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add New Employee',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.blueAccent), // Border color here
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    newEmployee.name = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    newEmployee.email = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    newEmployee.mobileNumber = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Profile Image',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    newEmployee.profileImage = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onAddEmployee(newEmployee);
                Navigator.of(context).pop();
              },
              child: Text('Add', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );

  }

  void _showEditEmployeeDialog(BuildContext context, Employee employee) {
    Employee updatedEmployee = Employee(
      email: employee.email,
      password: employee.password,
      name: employee.name,
      mobileNumber: employee.mobileNumber,
      profileImage: employee.profileImage,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Employee',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: TextEditingController(text: updatedEmployee.name),
                  onChanged: (value) {
                    updatedEmployee.name = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: TextEditingController(text: updatedEmployee.email),
                  onChanged: (value) {
                    updatedEmployee.email = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: TextEditingController(text: updatedEmployee.mobileNumber),
                  onChanged: (value) {
                    updatedEmployee.mobileNumber = value;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Profile Image',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: TextEditingController(text: updatedEmployee.profileImage),
                  onChanged: (value) {
                    updatedEmployee.profileImage = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onEditEmployee(updatedEmployee);
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
