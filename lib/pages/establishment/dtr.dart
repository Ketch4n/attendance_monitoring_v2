import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/style.dart';
import '../../widgets/camera.dart';


class dtr_estab extends StatefulWidget {
  const dtr_estab({super.key, required this.image, required this.name});
  final String image;
  final String name;
  @override
  State<dtr_estab> createState() => _dtr_estabState();
}

class _dtr_estabState extends State<dtr_estab> {
  List<Reference> _imageReferences = [];
  bool isLoading = true; // Track if data is loading
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _getImageReferences();
  }

  Future<void> _getImageReferences() async {
    final storage = FirebaseStorage.instance;
    final prefs = await SharedPreferences.getInstance();
    final section = widget.name;
    final storedUserId = prefs.getString('userId');
    final folderName =
        'face_data/$section/$storedUserId'; // Specify your folder name

    // List all files in the "face_data" folder
    try {
      final listResult = await storage.ref(folderName).listAll();
      setState(() {
        _imageReferences = listResult.items;
        isLoading = false; // Data has loaded
      });
    } catch (e) {
      print('Error listing files: $e');
      isLoading = false; // Data has failed to load
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: double.maxFinite,
          child: Image.asset(
            widget.image,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: ((context) => Camera(name: widget.name))),
              );
            },
            child: Container(
              height: 70,
              width: double.maxFinite,
              decoration:
                  Style.boxdecor.copyWith(borderRadius: Style.defaultradius),
              child: Align(
                alignment: Alignment.center,
                child: ListTile(
                  title: Row(
                    children: [
                      ClipRRect(
                        borderRadius: Style.borderRadius,
                        child: Image.asset(
                          "assets/images/admin.png",
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Upload dtr_estab (meta data)",
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.upload),
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (_imageReferences.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'No data available.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _imageReferences.length,
              itemBuilder: (context, index) {
                final imageRef = _imageReferences[index];
                final imageName = imageRef.name; // Get the image name
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Container(
                    height: 70,
                    width: double.maxFinite,
                    decoration: Style.boxdecor
                        .copyWith(borderRadius: Style.defaultradius),
                    child: ListTile(
                      title: Text(imageName),
                      subtitle: FutureBuilder(
                        future: imageRef.getMetadata(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              final metadata = snapshot.data as FullMetadata;
                              final location =
                                  metadata.customMetadata!['Location'] ?? 'N/A';
                              return Text('Location: $location');
                            }
                          }
                          return const Text('Fetching metadata...');
                        },
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Meta_Data(image: imageRef),
                        //   ),
                        // );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
