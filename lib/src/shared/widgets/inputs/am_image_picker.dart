import 'dart:io';
import 'dart:typed_data';

import 'package:adopte_un_matou/theme/palette.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class AmImagePicker extends StatefulWidget {
  const AmImagePicker({
    Key? key, 
    this.initialImage, 
    this.defaultPadding = const EdgeInsets.all(20.0), 
    this.onUpdated
  }) : super(key: key);

  final MemoryImage? initialImage;

  final EdgeInsets defaultPadding;

  final Function(Uint8List)? onUpdated;

  @override
  State<AmImagePicker> createState() => _AmImagePickerState();
}

class _AmImagePickerState extends State<AmImagePicker> {
  MemoryImage? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _image = widget.initialImage;
  }

  @override
  void didUpdateWidget(covariant AmImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    _image = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: _selectImage,
        child: Stack(
          children: [
            if (_isLoading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator(),)
              )
            else if (_image != null) 
              ..._buildImage()
            else 
              _buildEmptyImage()
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyImage() {
    return Positioned.fill(
      child: Padding(
        padding: widget.defaultPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Choisir une image", style: GoogleFonts.raleway(fontSize: 20, color: Palette.colorGrey3),),
            const SizedBox(height: 16,),
            const Icon(FeatherIcons.upload, size: 96, color: Palette.colorGrey3,)
          ],
        ),
      ),
    );
  }

  List<Widget> _buildImage() {
    return [
      Positioned.fill(
        child: Image(
          image: _image!,
          fit: BoxFit.cover,
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(FeatherIcons.edit2),
            onPressed: _selectImage,
          ),
        ),
      )
    ];
  }

  Future _selectImage() async {
    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );
    
    if (result != null) {
      Uint8List? bytes;

      if (kIsWeb) {
        bytes = result.files.single.bytes;
      }
      else {
        final File file = File(result.files.single.path!);
        bytes = await file.readAsBytes();
      }

      if (bytes == null) return;

      setState(() {
        _image = MemoryImage(bytes!);
      });

      if (widget.onUpdated != null) widget.onUpdated!(bytes);
    }

    setState(() {
      _isLoading = false;
    });
  }

}