
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Menu {
  String name;
  String time;
  String price;
  

  Menu({
    required this.name,
    required this.time,
    required this.price,
  });

  // Method to update menu details
  void updateDetails({
    required String price,
    required String time,
    required String name,

  }) {
    this.time = time;
    this.price = price;
    this.name = name;
  }
}


class Menumanagement extends StatefulWidget {
  const Menumanagement({super.key});

  @override
  State<Menumanagement> createState() => _MenumanagementState();
}

class _MenumanagementState extends State<Menumanagement> {
  late PageController _pageController;
  int _selectedTabIndex = 0; // Track the selected section index

  // Sample data for demonstration
  List<Menu> menus = [];

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
          'Manage Menu',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Icon color set to white
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
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'My Menu',
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
                          duration: const Duration(milliseconds: 300),
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
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'Manage Menu',
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
                        width: 150,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
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
                MyMenuSection(menus: menus),
                ManageMenuSection(
                  menus: menus,
                  onAddMenu: _addNewMenu,
                  onDeleteMenu: _deleteEmployee,
                  onEditMenu: _editMenuDetails,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNewMenu(Menu newMenu) {
    setState(() {
      menus.add(newMenu);
      _pageController.jumpToPage(0); // Switch to My menus page after adding
    });
  }

  void _editMenuDetails(Menu menu) {
    // Implement logic to edit menu details
    // For simplicity, we can just print menu details here
    print('Editing details of ${menu.name}');
  }

  void _deleteEmployee(Menu menu) {
    // Implement logic to delete menu
    setState(() {
      menus.remove(menu);
    });
  }
}

class MyMenuSection extends StatelessWidget {
  final List<Menu> menus;

  const MyMenuSection({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    return menus.isEmpty
        ? const Center(
      child: Text(
        'No menus',
        style: TextStyle(color: Colors.white),
      ),
    )
        : ListView.builder(
      itemCount: menus.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            //backgroundImage: AssetImage(menus[index].profileImage),
          ),
          title: Text(menus[index].name),
        );
      },
    );
  }
}

class ManageMenuSection extends StatefulWidget {
  final List<Menu> menus;
  final Function(Menu) onAddMenu;
  final Function(Menu) onDeleteMenu;
  final Function(Menu) onEditMenu;

  const ManageMenuSection({super.key, 
    required this.menus,
    required this.onAddMenu,
    required this.onDeleteMenu,
    required this.onEditMenu,
  });

  @override
  _ManageMenuSectionState createState() => _ManageMenuSectionState();
}

class _ManageMenuSectionState extends State<ManageMenuSection> {
  final TextEditingController _menuNameController = TextEditingController();
  final TextEditingController _menuPriceController = TextEditingController();
  final TextEditingController _menuTimeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Menu> filteredMenu = [];
  final ImagePicker _picker = ImagePicker();
  bool _isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();
    filteredMenu = widget.menus;
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
          padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 2.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
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
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              _filterEmployees(value);
            },
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: filteredMenu.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListTile(
                  title: Text(filteredMenu[index].name),
                  subtitle: Row(children: [Text(filteredMenu[index].time),Text(filteredMenu[index].price),],),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditEmployeeDialog(context, filteredMenu[index]);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          widget.onDeleteMenu(filteredMenu[index]);
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
                child: const Icon(Icons.add, color: Colors.white),
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
        filteredMenu = widget.menus
            .where((menu) =>
        menu.name.toLowerCase().contains(query.toLowerCase()) ||
            menu.price.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredMenu = widget.menus;
      });
    }
  }

  void _showAddEmployeeDialog(BuildContext context) {
    Menu newMenu = Menu(
      name: '',
      price: '',
      time: '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add New Menu',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.blueAccent), // Border color here
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Divider(
                    color: Colors.blueAccent.withOpacity(0.5),
                    thickness: 1.5,
                  ),
                ),
                TextFormField(
                  controller: _menuNameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(
                        color: Colors.blueAccent
                            .withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    labelStyle:
                    const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onTap: () {
                    setState(() {
                      _isTextFieldFocused = true;
                    });
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      _isTextFieldFocused = false;
                    });
                  },
                  onChanged: (value) {
                    // Handle text changes
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuPriceController,
                  decoration: InputDecoration(
                    hintText: 'Price',
                    hintStyle: TextStyle(
                        color: Colors.blueAccent
                            .withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    labelStyle:
                    const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onTap: () {
                    setState(() {
                      _isTextFieldFocused = true;
                    });
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      _isTextFieldFocused = false;
                    });
                  },
                  onChanged: (value) {
                    // Handle text changes
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuTimeController,
                  decoration: InputDecoration(
                    hintText: 'Time',
                    hintStyle: TextStyle(
                        color: Colors.blueAccent
                            .withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    labelStyle:
                    const TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onTap: () {
                    setState(() {
                      _isTextFieldFocused = true;
                    });
                  },
                  onFieldSubmitted: (value) {
                    setState(() {
                      _isTextFieldFocused = false;
                    });
                  },
                  onChanged: (value) {
                    // Handle text changes
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onAddMenu(newMenu);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

  }

  void _showEditEmployeeDialog(BuildContext context, Menu menu) {
    Menu updateMenu = Menu(
      name: menu.name,
      time: menu.time,
      price: menu.price,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit Menu',
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
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: const TextStyle(color: Colors.white),
                  controller: TextEditingController(text: updateMenu.name),
                  onChanged: (value) {
                    updateMenu.name = value;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: const TextStyle(color: Colors.white),
                  controller: TextEditingController(text: updateMenu.price),
                  onChanged: (value) {
                    updateMenu.price = value;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Time',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    filled: true,
                    fillColor: Colors.black,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  style: const TextStyle(color: Colors.white),
                  controller: TextEditingController(text: updateMenu.time),
                  onChanged: (value) {
                    updateMenu.time = value;
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onEditMenu(updateMenu);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
