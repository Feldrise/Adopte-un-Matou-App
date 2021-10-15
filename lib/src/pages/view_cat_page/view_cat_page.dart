import 'dart:typed_data';

import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/services/cats_service.dart';
import 'package:adopte_un_matou/src/provider/controller/cats_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/image_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/user_controller.dart';
import 'package:adopte_un_matou/src/provider/states/image_state.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/shared/widgets/inputs/am_dropdown.dart';
import 'package:adopte_un_matou/src/shared/widgets/inputs/am_image_picker.dart';
import 'package:adopte_un_matou/src/shared/widgets/inputs/am_textinput.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewCatPage extends ConsumerStatefulWidget {
  const ViewCatPage({
    Key? key, 
    this.cat,
    this.canEdit = false,
  }) : super(key: key);

  final Cat? cat;
  final bool canEdit;

  @override
  ConsumerState<ViewCatPage> createState() => _ViewCatPageState();
}

class _ViewCatPageState extends ConsumerState<ViewCatPage> {
  bool _isEditing = false;

  bool _isLoading = false;
  String _errorMessage = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Uint8List? _image;
  bool _imageUpdated = false;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _genre = "male";
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();


  @override
  void initState() {
    super.initState();

    if (widget.cat == null) _isEditing = true;

    _locationController.text = widget.cat?.location ?? "";
    _descriptionController.text = widget.cat?.description ?? "";
    _nameController.text = widget.cat?.name ?? "";
    _ageController.text = widget.cat?.age ?? "";
    _priceController.text = widget.cat?.price.toString() ?? "";
    if (widget.cat != null) {
      final ImageProvider? imageProvider = ref.read(widget.cat!.image).image?.asData?.value;

      if (imageProvider is MemoryImage) {
        _image = imageProvider.bytes;
      }
    }
  }

  @override
  void didUpdateWidget(covariant ViewCatPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.cat == null) _isEditing = true;

    _locationController.text = widget.cat?.location ?? "";
    _descriptionController.text = widget.cat?.description ?? "";
    _nameController.text = widget.cat?.name ?? "";
    _ageController.text = widget.cat?.age ?? "";
    _priceController.text = widget.cat?.price.toString() ?? "";
    if (widget.cat != null) {
      final ImageProvider? imageProvider = ref.read(widget.cat!.image).image?.asData?.value;

      if (imageProvider is MemoryImage) {
        _image = imageProvider.bytes;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AmAppBar(
        title: Text(widget.cat != null ? "Voir un chat - ${widget.cat!.name}" : "Ajouter un chat"),
        actions: [
          if (widget.canEdit && !_isLoading)
            IconButton(
              icon: Icon(_isEditing ? FeatherIcons.check : FeatherIcons.edit2),
              color: Theme.of(context).primaryColor,
              onPressed: _toggleEdit,
            )
        ],        
      ), 
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            if (_isLoading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator(),) 
              ,)
            else ...{
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= ScreenUtils.instance.breakpointPC) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 4,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(22),
                                      child: SizedBox(
                                        height: constraints.maxHeight - 200, 
                                        child: _buildCatImage()
                                      )
                                    ),
                                    const SizedBox(height: 16,),
                                    Flexible(child: _buildLocationButton())
                                  ],
                                ),
                              ),
                              const SizedBox(width: 48,),
                              Flexible(
                                flex: 6,
                                child: _buildMainColumn(),
                              )
                            ],
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 180,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22)),
                                    child: _buildCatImage()
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: _buildLocationButton(),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: _buildMainColumn(),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (_isEditing) 
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildBottomButtons(),
                  ),
                )
            }
          ],
        ),
      ),
    );
  }

  Widget _buildCatImage() {
    if (_isEditing) {
      return AmImagePicker(
        initialImage: _image != null ? MemoryImage(_image!) : null,
        onUpdated: (value) {
          _imageUpdated = true;
          _image = value;
        }
      );
    }

    if (widget.cat != null) {
      return ref.watch(widget.cat!.image).image!.when(
         data: (data) => Image(
          image: data,
          fit: BoxFit.cover,
        ),
        loading: (data) => const Center(child: CircularProgressIndicator(),),
        error: (error, stackTrace, data) => const Center(child: Icon(FeatherIcons.alertCircle),)
      );

    }

    return const Center(child: CircularProgressIndicator(),);
  }

  Widget _buildLocationButton() {
    if (_isEditing) {
      return SizedBox(
        // height: 80,
        width: 250,
        child: AmTextInput(
          controller: _locationController,
          labelText: "Location",
          hintText: "Rennes...",
          validator: (value) {
            if (value.isEmpty) return "Vous devez renter une location";

            return null;
          },
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Theme.of(context).primaryColor
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontWeight: FontWeight.w600,
          color: Palette.colorWhite
        ),
        child: Row(
          children: [
            const Icon(FeatherIcons.mapPin, size: 24, color: Palette.colorWhite,),
            const SizedBox(width: 4.0,),
            Text(widget.cat?.location ?? "Localisation"),
          ],
        ),
      ),
    );
  }

  Widget _buildMainColumn() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtils.instance.horizontalPadding, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_errorMessage.isNotEmpty)
            AmStatusMessage(
              title: "Erreur",
              message: _errorMessage
            ),
          // General informations
          if (_isEditing) ...{
            AmTextInput(
              controller: _nameController,
              labelText: "Nom",
              hintText: "Jack...",
              validator: (value) {
                if (value.isEmpty) return "Vous devez rentrer un nom";

                return null;
              },
            ),
            const SizedBox(height: 8.0,),
            AmDropdown<String>(
              currentValue: _genre,
              label: "Genre",
              items: const {
                'male': 'Male',
                'femmelle': 'Femmelle'
              },
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _genre = value;
                  });
                }
              },
            ),
            // ignore: equal_elements_in_set
            const SizedBox(height: 8.0,),
            AmTextInput(
              controller: _ageController,
              labelText: "Age",
              hintText: "7 mois...",
              validator: (value) {
                if (value.isEmpty) return "Vous devez rentrer un age";

                return null;
              },
            )
          }
          else 
            Text(
              "${widget.cat?.name ?? "Nom"} - ${widget.cat?.age ?? "âge"}",
              style: Theme.of(context).textTheme.headline2,
            ),
          const SizedBox(height: 8.0,),
          // Adoption price
          if (_isEditing) 
            AmTextInput(
              controller: _priceController,
              labelText: "Prix (en €)",
              hintText: "100...",
              validator: (value) {
                if (int.tryParse(value) == null) return "Vous devez rentrer un prix valide";

                return null;
              },
            )
          else
            Text(
              "${widget.cat?.price ?? "Prix d'adoption en "}€",
              style: Theme.of(context).textTheme.headline3,
            ),
          const SizedBox(height: 16.0,),
          if (_isEditing) 
            AmTextInput(
              controller: _descriptionController, 
              validator: (value) {
                if (value.isEmpty) return "Vous devez rentrer une description";

                return null;
              }, 
              labelText: "Description",
              maxLines: 5,
            )
          else 
            Text(widget.cat?.description ?? "Description")
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      runSpacing: 8,
      spacing: 16,
      children: [
        // The validation button
        AmButton(
          text: widget.cat != null ? "Valider les modification" : "Valider",
          onPressed: () async {
            if (widget.cat == null) {
              await _createCat();
            }
            else {
              await _updateCat();
            }
          },
        ),

        // The moving button
        if (widget.cat != null) 
          AmButton(
            text: "Déplacer dans les adoptés",
            onPressed: () {},
          )
      ],
    );
  }

  Future _toggleEdit() async {
    if (_isEditing && widget.cat == null) {
      await _createCat();
    }
    else if (_isEditing) {
      await _updateCat();
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future _createCat() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final Cat cat = Cat(null, 
      name: _nameController.text,
      image: StateNotifierProvider.autoDispose<ImageController, ImageState>((ref) {
          return ImageController(
            ImageState(
              imageUrl: "",
              image: _image == null ? 
                const AsyncValue.data(AssetImage("assets/icons/placeholderCatImage.png")) :
                AsyncValue.data(MemoryImage(_image!))
            )
          );
        }
      ),
      adoptionStatus: CatAdoptionStatus.waiting,
      genre: _genre,
      age: _ageController.text,
      price: int.parse(_priceController.text),
      location: _locationController.text,
      properties: const [],
      description: _descriptionController.text
    );

    try {
      final String? authorization = ref.read(userControllerProvider).user?.authenticationHeader;

      final String id = await CatsService.instance.createCat(_image, cat, authorization: authorization);

      ref.read(catsControllerProvider.notifier).addCat(cat.copyWith(id: id));
      Navigator.of(context).pop();
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Impossible de créer le chat ; ${e.code} ; ${e.message}";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";   
      });
    }
  }

   Future _updateCat() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final Cat cat = widget.cat!.copyWith( 
      name: _nameController.text,
      image: _imageUpdated ? StateNotifierProvider.autoDispose<ImageController, ImageState>((ref) {
          return ImageController(
            ImageState(
              imageUrl: "",
              image: _image == null ? 
                const AsyncValue.data(AssetImage("assets/icons/placeholderCatImage.png")) :
                AsyncValue.data(MemoryImage(_image!))
            )
          );
        }
      ) : null,
      genre: _genre,
      age: _ageController.text,
      price: int.parse(_priceController.text),
      location: _locationController.text,
      properties: const [],
      description: _descriptionController.text
    );

    try {
      final String? authorization = ref.read(userControllerProvider).user?.authenticationHeader;

      await CatsService.instance.updateCat(_imageUpdated ? _image : null, cat, authorization: authorization);

      ref.read(catsControllerProvider.notifier).updateCat(cat);
      Navigator.of(context).pop();
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Impossible de mettre à jour le chat ; ${e.code} ; ${e.message}";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";   
      });
    }
  }
}