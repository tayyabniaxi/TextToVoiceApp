// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class GoogleDriveReaderScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Google Drive App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DriveFolderScreen(),
//     );
//   }
// }

// class DriveFolderScreen extends StatefulWidget {
//   @override
//   _DriveFolderScreenState createState() => _DriveFolderScreenState();
// }

// class _DriveFolderScreenState extends State<DriveFolderScreen> {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//       'https://www.googleapis.com/auth/drive.readonly',
//     ],
//   );

//   GoogleSignInAccount? _currentUser;
//   List<dynamic> _folders = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _signInAndFetchFolders();
//   }

//   // Sign in and fetch Drive folders
//   Future<void> _signInAndFetchFolders() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       if (account != null) {
//         _currentUser = account;
//         final auth = await _currentUser!.authentication;
//         final accessToken = auth.accessToken;
//         await _fetchFolders(accessToken!);
//       }
//     } catch (error) {
//       print('Error signing in: $error');
//     }
//   }

//   // Fetch Drive folders using the access token
//   Future<void> _fetchFolders(String accessToken) async {
//     setState(() {
//       isLoading = true;
//     });

//     final response = await http.get(
//       Uri.parse('https://www.googleapis.com/drive/v3/files?fields=files(id,name,mimeType,parents)'),
//       headers: {'Authorization': 'Bearer $accessToken'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         _folders = data['files'];
//         isLoading = false;
//       });
//     } else {
//       print('Failed to load folders: ${response.body}');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Drive Folders'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await _googleSignIn.signOut();
//               setState(() {
//                 _currentUser = null;
//                 _folders = [];
//               });
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _folders.length,
//               itemBuilder: (context, index) {
//                 final folder = _folders[index];
//                 return ListTile(
//                   title: Text(folder['name'] ?? 'Unknown Folder'),
//                   subtitle: Text(folder['id']),
//                   onTap: () {
//                     // Navigate to FileScreen with folder ID
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => FileScreen(
//                           folderId: folder['id'],
//                           accessToken: _currentUser!.authentication
//                               .then((auth) => auth.accessToken ?? ""),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

// class FileScreen extends StatefulWidget {
//   final String folderId;
//   final Future<String?> accessToken;

//   const FileScreen({Key? key, required this.folderId, required this.accessToken}) : super(key: key);

//   @override
//   _FileScreenState createState() => _FileScreenState();
// }

// class _FileScreenState extends State<FileScreen> {
//   List<dynamic> _files = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     widget.accessToken.then((token) {
//       if (token != null) {
//         _fetchFiles(token);
//       }
//     });
//   }

//   // Fetch files in the specified folder
//   Future<void> _fetchFiles(String accessToken) async {
//     setState(() {
//       isLoading = true;
//     });

//     final response = await http.get(
//       Uri.parse('https://www.googleapis.com/drive/v3/files?q=\'${widget.folderId}\' in parents&fields=files(id,name,mimeType)'),
//       headers: {'Authorization': 'Bearer $accessToken'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         _files = data['files'] ?? [];
//         isLoading = false;
//       });
//     } else {
//       print('Failed to load files: ${response.body}');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Files in Folder')),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: _files.length,
//               itemBuilder: (context, index) {
//                 final file = _files[index];
//                 return ListTile(
//                   title: Text(file['name'] ?? 'Unknown File'),
//                   subtitle: Text(file['id']),
//                   onTap: () {
//                     // Navigate to FileDetailScreen with file ID
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => FileDetailScreen(
//                           fileId: file['id'],
//                           accessToken: widget.accessToken,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

// class FileDetailScreen extends StatefulWidget {
//   final String fileId;
//   final Future<String?> accessToken;

//   const FileDetailScreen({Key? key, required this.fileId, required this.accessToken}) : super(key: key);

//   @override
//   _FileDetailScreenState createState() => _FileDetailScreenState();
// }

// class _FileDetailScreenState extends State<FileDetailScreen> {
//   Map<String, dynamic>? _fileDetails;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     widget.accessToken.then((token) {
//       if (token != null) {
//         _fetchFileDetails(token);
//       }
//     });
//   }

//   // Fetch file details using the file ID
//   Future<void> _fetchFileDetails(String accessToken) async {
//     setState(() {
//       isLoading = true;
//     });

//     final response = await http.get(
//       Uri.parse('https://www.googleapis.com/drive/v3/files/${widget.fileId}?fields=id,name,mimeType,description'),
//       headers: {'Authorization': 'Bearer $accessToken'},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         _fileDetails = data;
//         isLoading = false;
//       });
//     } else {
//       print('Failed to load file details: ${response.body}');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('File Details')),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('File Name: ${_fileDetails?['name'] ?? 'Unknown'}',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 8),
//                   Text('File ID: ${_fileDetails?['id'] ?? 'Unknown'}'),
//                   SizedBox(height: 8),
//                   Text('MIME Type: ${_fileDetails?['mimeType'] ?? 'Unknown'}'),
//                   SizedBox(height: 8),
//                   Text('Description: ${_fileDetails?['description'] ?? 'No description'}'),
//                 ],
//               ),
//             ),
//     );
//   }
// }


// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/gDrive/gDrive-bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/gDrive/gDrive-event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/gDrive/gDrive-state.dart';


class DriveFolderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DriveBloc>();
return Scaffold(
  appBar: AppBar(title: Text('Google Drive Folders')),
  body: BlocBuilder<DriveBloc, DriveState>(
    builder: (context, state) {
      if (state is DriveLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is DriveInitial) {
        return Center(
          child: ElevatedButton(
            onPressed: () => context.read<DriveBloc>().add(SignInEvent()),
            child: Text('Sign in to Google Drive'),
          ),
        );
      } else if (state is DriveSignedIn) {
        // Trigger FetchFoldersEvent
        context.read<DriveBloc>().add(FetchFoldersEvent(state.accessToken));
        return Center(child: CircularProgressIndicator()); // Loading UI
      } else if (state is DriveFoldersLoaded) {
        // Show list of folders
        return ListView.builder(
          itemCount: state.folders.length,
          itemBuilder: (context, index) {
            final folder = state.folders[index];
            return ListTile(
              title: Text(folder['name'] ?? 'Unknown Folder'),
              subtitle: Text(folder['id']),
              onTap: () => context.read<DriveBloc>().add(FetchFilesEvent(
                folder['id'],
                context.read<DriveBloc>().state is DriveSignedIn
                    ? (context.read<DriveBloc>().state as DriveSignedIn)
                        .accessToken
                    : '',
              )),
            );
          },
        );
      } else if (state is DriveFilesLoaded) {
        // Show list of files
        return ListView.builder(
          itemCount: state.files.length,
          itemBuilder: (context, index) {
            final file = state.files[index];
            final isSupported = file['mimeType'] == 'application/pdf' ||
                file['mimeType'] ==
                    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' ||
                file['mimeType'].startsWith('image/');

            return ListTile(
              title: Text(file['name'] ?? 'Unknown File'),
              subtitle: Text(file['mimeType']),
              trailing: isSupported ? Icon(Icons.text_fields) : Icon(Icons.block, color: Colors.grey),
              onTap: isSupported
                  ? () => context.read<DriveBloc>().add(ProcessFileEvent(
                        file['id'],
                        file['name'],
                        file['mimeType'],
                        context.read<DriveBloc>().state is DriveSignedIn
                            ? (context.read<DriveBloc>().state as DriveSignedIn)
                                .accessToken
                            : '',
                      ))
                  : null,
            );
          },
        );
      } else if (state is DriveFileTextExtracted) {
        // Show extracted text
        return TextDisplayScreen(
          fileName: state.fileName,
          content: state.extractedText,
        );
      } else if (state is DriveError) {
        // Show error
        return Center(child: Text(state.error));
      }
      return Center(child: Text('Unexpected state'));
    },
  ),
);

  }
}

class TextDisplayScreen extends StatelessWidget {
  final String fileName;
  final String content;

  const TextDisplayScreen({Key? key, required this.fileName, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fileName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(content, style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
