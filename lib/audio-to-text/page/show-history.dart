// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/show_history/show_history_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/show_history/show_history_event.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/show_history/show_history_state.dart';
// import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';
// import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
// import 'package:new_wall_paper_app/res/app-icon.dart';
// import 'package:new_wall_paper_app/style/app-color.dart';
// import 'package:new_wall_paper_app/widget/common-text.dart';
// import 'package:new_wall_paper_app/helper/sqlite-helper.dart';

// import 'package:flutter/material.dart';

// class HistoryPage extends StatefulWidget {
//   const HistoryPage({Key? key}) : super(key: key);

//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   late Future<List<Document>> _savedDocuments;
//   bool _isMultiSelectMode = false;
//   final Set<int> _selectedItems = {};
//   String _selectedFilter = 'All';

//   @override
//   void initState() {
//     super.initState();
//     _savedDocuments = DatabaseHelper().getDocuments();
//   }

//   void _toggleMultiSelectMode() {
//     setState(() {
//       _isMultiSelectMode = !_isMultiSelectMode;
//       _selectedItems.clear();
//     });
//   }

//   Future<void> _deleteSelectedItems() async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Selected Documents"),
//         content: Text(
//             "Are you sure you want to delete ${_selectedItems.length} selected documents?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child: const Text("Delete"),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       for (var id in _selectedItems) {
//         await DatabaseHelper().deleteDocument(id);
//       }
//       setState(() {
//         _selectedItems.clear();
//         _isMultiSelectMode = false;
//         _savedDocuments = DatabaseHelper().getDocuments();
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Selected documents deleted")),
//         );
//       }
//     }
//   }

//   Future<void> _renameDocument(Document document) async {
//     final TextEditingController nameController =
//         TextEditingController(text: document.name);

//     final newName = await showDialog<String>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Rename Document"),
//         content: TextField(
//           controller: nameController,
//           decoration: const InputDecoration(
//             labelText: "New Name",
//             border: OutlineInputBorder(),
//           ),
//           autofocus: true,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(nameController.text),
//             child: const Text("Rename"),
//           ),
//         ],
//       ),
//     );

//     if (newName != null && newName.isNotEmpty && newName != document.name) {
//       final updatedDocument = Document(
//         id: document.id,
//         name: newName,
//         description: document.description,
//         pdfContent: document.pdfContent,
//         contentType: document.contentType,
//       );

//       await DatabaseHelper().updateDocument(updatedDocument);

//       setState(() {
//         _savedDocuments = DatabaseHelper().getDocuments();
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Document renamed to '$newName'")),
//         );
//       }
//     }
//   }

//   Future<void> _deleteDocument(Document document) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Document"),
//         content: Text("Are you sure you want to delete '${document.name}'?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             child:  Text("Delete"),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await DatabaseHelper().deleteDocument(document.id!);
//       setState(() {
//         _savedDocuments = DatabaseHelper().getDocuments();
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Document '${document.name}' deleted")),
//         );
//       }
//     }
//   }

//   List<Document> _filterDocuments(List<Document> documents) {
//     return documents.where((doc) {
//       if (_selectedFilter == 'All') return true;
//       return doc.contentType == _selectedFilter;
//     }).toList();
//   }

//   Widget _buildGroupedListView(List<Document> documents) {
//     final Map<String, List<Document>> groups = {
//       'Today': <Document>[],
//       'Yesterday': <Document>[],
//       'Other': <Document>[]
//     };

//     for (var doc in documents) {
//       if (groups['Today']!.length < 3) {
//         groups['Today']!.add(doc);
//       } else if (groups['Yesterday']!.length < 2) {
//         groups['Yesterday']!.add(doc);
//       } else {
//         groups['Other']!.add(doc);
//       }
//     }

//     return ListView(
//       children: groups.entries
//           .where((entry) => entry.value.isNotEmpty)
//           .map((entry) => _buildDateGroup(entry.key, entry.value))
//           .toList(),
//     );
//   }

//   Widget _buildDateGroup(String title, List<Document> documents) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: CommonText(
//             title: title,
//             color: Colors.grey,
//             size: 0.02,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         ...documents.map((doc) => _buildDocumentTile(doc)),
//       ],
//     );
//   }

//   Widget _buildDocumentTile(Document document) {
//     final isSelected = _selectedItems.contains(document.id);

//     return Container(
//       margin: EdgeInsets.symmetric(
//           vertical: 6, horizontal: MediaQuery.of(context).size.width * 0.02),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: AppColor.containerColor),
//       child: ListTile(
//         leading: _isMultiSelectMode
//             ? Checkbox(
//                 value: isSelected,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     if (value == true) {
//                       _selectedItems.add(document.id!);
//                     } else {
//                       _selectedItems.remove(document.id!);
//                     }
//                   });
//                 },
//               )
//             : Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: SvgPicture.asset(AppImage.show_history),
//               ),
//         title: Text(document.name ?? "No Name"),
//         subtitle: Text(
//           'Dec 10 Text • ${document.id}m',
//           style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
//         ),
//         trailing: _isMultiSelectMode
//             ? null
//             : PopupMenuButton<String>(
//                 icon: const Icon(Icons.more_vert),
//                 onSelected: (value) {
//                   switch (value) {
//                     case 'rename':
//                       _renameDocument(document);
//                       break;
//                     case 'delete':
//                       _deleteDocument(document);
//                       break;
//                   }
//                 },
//                 itemBuilder: (BuildContext context) => [
//                   const PopupMenuItem(
//                     value: 'rename',
//                     child: Row(
//                       children: [
//                         Icon(Icons.edit, size: 20),
//                         SizedBox(width: 8),
//                         Text('Rename'),
//                       ],
//                     ),
//                   ),
//                   const PopupMenuItem(
//                     value: 'delete',
//                     child: Row(
//                       children: [
//                         Icon(Icons.delete, color: Colors.red, size: 20),
//                         SizedBox(width: 8),
//                         Text('Delete'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//         onTap: _isMultiSelectMode
//             ? () {
//                 setState(() {
//                   if (isSelected) {
//                     _selectedItems.remove(document.id!);
//                   } else {
//                     _selectedItems.add(document.id!);
//                   }
//                 });
//               }
//             : () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => WriteAndTextPage(
//                       text: document.pdfContent,
//                       isText: false,
//                     ),
//                   ),
//                 );
//               },
//         selected: isSelected,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: CommonText(
//           title: 'History',
//           color: Colors.black,
//           size: 0.024,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(_isMultiSelectMode ? Icons.close : Icons.checklist),
//             onPressed: _toggleMultiSelectMode,
//             tooltip:
//                 _isMultiSelectMode ? 'Cancel Selection' : 'Select Multiple',
//           ),
//           if (_isMultiSelectMode && _selectedItems.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: _deleteSelectedItems,
//               tooltip: 'Delete Selected',
//             ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _savedDocuments = DatabaseHelper().getDocuments();
//               });
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Wrap(
//               alignment: WrapAlignment.spaceEvenly,
//               spacing: 8,
//               runSpacing: 8,
//               children: ['All', 'Chat', 'Documents', 'Images'].map((filter) {
//                 return ChoiceChip(
//                   backgroundColor: AppColor.containerColor,
//                   selectedColor: Colors.blue,
//                   label: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 2),
//                     child: Text(
//                       filter,
//                       style: TextStyle(
//                         color: _selectedFilter == filter
//                             ? Colors.white
//                             : Colors.black,
//                       ),
//                     ),
//                   ),
//                   selected: _selectedFilter == filter,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedFilter = selected ? filter : 'All';
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Document>>(
//               future: _savedDocuments,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No saved content found"));
//                 } else {
//                   final filteredDocuments = _filterDocuments(snapshot.data!);
//                   return _buildGroupedListView(filteredDocuments);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_wall_paper_app/model/store-pdf-sqlite-db-model.dart';
import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';
import 'package:new_wall_paper_app/res/app-icon.dart';
import 'package:new_wall_paper_app/style/app-color.dart';
import 'package:new_wall_paper_app/widget/common-text.dart';
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Document>> _savedDocuments;
  bool _isMultiSelectMode = false;
  final Set<int> _selectedItems = {};
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _savedDocuments = DatabaseHelper().getDocuments();
  }

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      _selectedItems.clear();
    });
  }

  Future<void> _deleteSelectedItems() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Selected Documents"),
        content: Text(
            "Are you sure you want to delete ${_selectedItems.length} selected documents?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete"),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (var id in _selectedItems) {
        await DatabaseHelper().deleteDocument(id);
      }
      setState(() {
        _selectedItems.clear();
        _isMultiSelectMode = false;
        _savedDocuments = DatabaseHelper().getDocuments();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Selected documents deleted")),
        );
      }
    }
  }

  Future<void> _renameDocument(Document document) async {
    final TextEditingController nameController =
        TextEditingController(text: document.name);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rename Document"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "New Name",
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(nameController.text),
            child: const Text("Rename"),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != document.name) {
      final updatedDocument = Document(
        id: document.id,
        name: newName,
        description: document.description,
        pdfContent: document.pdfContent,
        contentType: document.contentType,
      );

      await DatabaseHelper().updateDocument(updatedDocument);

      setState(() {
        _savedDocuments = DatabaseHelper().getDocuments();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Document renamed to '$newName'")),
        );
      }
    }
  }

  Future<void> _deleteDocument(Document document) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Document"),
        content: Text("Are you sure you want to delete '${document.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete"),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper().deleteDocument(document.id!);
      setState(() {
        _savedDocuments = DatabaseHelper().getDocuments();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Document '${document.name}' deleted")),
        );
      }
    }
  }

  List<Document> _filterDocuments(List<Document> documents) {
    return documents.where((doc) {
      if (_selectedFilter == 'All') return true;

      final filterMapping = {
        'Images': 'Image',
        'Documents': 'Document',
        'Chat': 'Chat'
      };

      return doc.contentType ==
          (filterMapping[_selectedFilter] ?? _selectedFilter);
    }).toList();
  }

  Widget _buildGroupedListView(List<Document> documents) {
    final Map<String, List<Document>> groups = {
      'Today': <Document>[],
      'Yesterday': <Document>[],
      'Other': <Document>[]
    };

    for (var doc in documents) {
      if (groups['Today']!.length < 3) {
        groups['Today']!.add(doc);
      } else if (groups['Yesterday']!.length < 2) {
        groups['Yesterday']!.add(doc);
      } else {
        groups['Other']!.add(doc);
      }
    }

    return ListView(
      children: groups.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => _buildDateGroup(entry.key, entry.value))
          .toList(),
    );
  }

  Widget _buildDateGroup(String title, List<Document> documents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CommonText(
            title: title,
            color: Colors.grey,
            size: 0.02,
            fontWeight: FontWeight.w600,
          ),
        ),
        ...documents.map((doc) => _buildDocumentTile(doc)),
      ],
    );
  }

  Widget _buildDocumentTile(Document document) {
    final isSelected = _selectedItems.contains(document.id);

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 6, horizontal: MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.containerColor),
      child: ListTile(
        leading: _isMultiSelectMode
            ? Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedItems.add(document.id!);
                    } else {
                      _selectedItems.remove(document.id!);
                    }
                  });
                },
              )
            : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(AppImage.show_history),
              ),
        title: Text(document.name ?? "No Name"),
        subtitle: Text(
          'Dec 10 Text • ${document.id}m',
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
        ),
        trailing: _isMultiSelectMode
            ? null
            : PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'rename':
                      _renameDocument(document);
                      break;
                    case 'delete':
                      _deleteDocument(document);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Rename'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
        onTap: _isMultiSelectMode
            ? () {
                setState(() {
                  if (isSelected) {
                    _selectedItems.remove(document.id!);
                  } else {
                    _selectedItems.add(document.id!);
                  }
                });
              }
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteAndTextPage(
                      isConvertable: false,
                      text: document.pdfContent,
                      isText: false,
                    ),
                  ),
                );
              },
        selected: isSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CommonText(
          title: 'History',
          color: Colors.black,
          size: 0.024,
        ),
        actions: [
          IconButton(
            icon: Icon(_isMultiSelectMode ? Icons.close : Icons.checklist),
            onPressed: _toggleMultiSelectMode,
            tooltip:
                _isMultiSelectMode ? 'Cancel Selection' : 'Select Multiple',
          ),
          if (_isMultiSelectMode && _selectedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteSelectedItems,
              tooltip: 'Delete Selected',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _savedDocuments = DatabaseHelper().getDocuments();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 8,
              runSpacing: 8,
              children: ['All', 'Images', 'Documents', 'PDF'].map((filter) {
                return ChoiceChip(
                  backgroundColor: AppColor.containerColor,
                  selectedColor: Colors.blue,
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: _selectedFilter == filter
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  selected: _selectedFilter == filter,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = selected ? filter : 'All';
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Document>>(
              future: _savedDocuments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No saved content found"));
                } else {
                  final filteredDocuments = _filterDocuments(snapshot.data!);
                  return filteredDocuments.isEmpty
                      ? const Center(
                          child: Text("No documents in this category"))
                      : _buildGroupedListView(filteredDocuments);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
