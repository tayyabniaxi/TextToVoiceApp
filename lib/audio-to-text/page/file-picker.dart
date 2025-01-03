
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-bloc-class.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-event.dart';
// import 'package:new_wall_paper_app/audio-to-text/bloc/file-picker/file-picker-state-class.dart';
// import 'package:new_wall_paper_app/audio-to-text/page/write-past-text.dart';

// class FileProcessorScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => FileProcessorBloc(),
//       child: FileProcessorView(),
//     );
//   }
// }

// class FileProcessorView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               final state = context.read<FileProcessorBloc>().state;
//               if (state is FileProcessorSuccess) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => WriteAndTextPage(
//                       text: state.extractedText,
//                       isText: false,
//                     ),
//                   ),
//                 );
//               }
//             },
//             child: const Text("Next"),
//           ),
//         ],
//       ),
//       // ignore: prefer_const_constructors
//       appBar: AppBar(title: Text('File Processor')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 context.read<FileProcessorBloc>().add(PickAndProcessFileEvent());
//               },
//               child: const Text('Pick and Process File'),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: BlocBuilder<FileProcessorBloc, FileProcessorState>(
//                 builder: (context, state) {
//                   if (state is FileProcessorLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (state is FileProcessorSuccess) {
//                     return SingleChildScrollView(
//                       child: Text(state.extractedText),
//                     );
//                   } else if (state is FileProcessorError) {
//                     return Center(child: Text(state.errorMessage));
//                   }
//                   return const Center(child: Text('No file processed yet'));
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
