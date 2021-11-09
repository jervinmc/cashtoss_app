// Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: Column(
//               children: [       
//                 Expanded(
//                     child: ListView(
//                   children: [
//                     path.length <= 0
//                         ? Container()
//                         : path.indexOf("http") >= 0
//                             ? Image.network(path,height: 10.0,)
//                             : Image.file(File(path),height: 200.0,fit: BoxFit.contain,),
//                     bload
//                         ? Column(children: [CircularProgressIndicator()])
//                         : Text(
//                             '$_ocrText',
//                           ),
//                   ],
//                 ))
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.black26,
//             child: bDownloadtessFile
//                 ? Center(
//                     child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(),
//                       Text('download Trained language files')
//                     ],
//                   ))
//                 : SizedBox(),
//           )
//         ],
//       ),