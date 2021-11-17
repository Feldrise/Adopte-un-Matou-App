import 'dart:convert';
import 'dart:io';

import 'package:adopte_un_matou/models/application.dart';
import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/applications_service.dart';
import 'package:adopte_un_matou/src/provider/controller/applications_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/cats_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/shared/widgets/inputs/am_textinput.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplicationForm extends ConsumerStatefulWidget {
  const ApplicationForm({
    Key? key,
    this.application,
    this.cat,
    this.user,
    this.isEditing = true,
  }) : super(key: key);

  final Application? application;
  final Cat? cat;
  final User? user;

  final bool isEditing;

  @override
  ConsumerState<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends ConsumerState<ApplicationForm> {
  Cat? _cat;
  User? _user;

  bool _isLoading = false;
  String _errorMessage = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _adultsNumberController = TextEditingController();
  final TextEditingController _adultsAgeController = TextEditingController();
  final TextEditingController _childrenNumberController = TextEditingController();
  final TextEditingController _childrenAgeController = TextEditingController();

  final Map<String, ApplicationQuestion> _questions = {
    "title1": const ApplicationQuestion(
      id: "title1",
      type: ApplicationFieldTypes.title,
      question: "Expérience avec les chats",
    ),
    "q1": const ApplicationQuestion(
      id: "q1",
      type: ApplicationFieldTypes.radio,
      question: "Avez-vous déjà eu un chat dans votre vis ? *",
      attributes: ["Oui", "Non"],
      value: 0
    ),
    "q2": const ApplicationQuestion(
      id: "q2",
      type: ApplicationFieldTypes.radio,
      question: "Si non, vous êtes-vous renseigné auprès des possesseurs de chats sur leurs habitudes et modes de vie ? *",
      attributes: ["Oui", "Non", "Je suis déjà au courant"],
      value: 2
    ),
    "q3": const ApplicationQuestion(
      id: "q3",
      type: ApplicationFieldTypes.radio,
      question: "Tous les membres de votre foyer sont-ils d'accord pour adopter un chat ? *",
      attributes: ["Oui", "Non"],
      value: 0
    ),
    "q4": const ApplicationQuestion(
      id: "q4",
      type: ApplicationFieldTypes.radio,
      question: "Est-ce qu'un membre de votre foyer possède un terrain allergène, notamment par rapport aux chats ? *",
      attributes: ["Oui", "Non"],
      value: 0
    ),
    "q5": const ApplicationQuestion(
      id: "q5",
      type: ApplicationFieldTypes.radio,
      question: "Avez-vous d’autres animaux ? *",
      attributes: ["Oui", "Non"],
      value: 0
    ),
    "q6": ApplicationQuestion(
      id: "q6",
      type: ApplicationFieldTypes.text,
      question: "Si oui, lesquels et combien ? *",
      attributes: "Exemple : 0",
      mandatory: true,
      value: TextEditingController()
    ),
    "q7": const ApplicationQuestion(
      id: "q7",
      type: ApplicationFieldTypes.radio,
      question: "Avez-vous pensé à qui confier votre chat lors de vos vacances ? *",
      attributes: ["Oui", "Non"],
      value: 0
    ),
    "q8": const ApplicationQuestion(
      id: "q8",
      type: ApplicationFieldTypes.radio,
      question: "Etes-vous conscient des changements que va engendrer la présence d'un chat chez vous et êtes-vous prêt à modifier si nécessaire votre environnement pour l'adapter à vos besoins ? *",
      attributes: ["Oui", "Non"],
      value: 0
    ),
    "q9": const ApplicationQuestion(
      id: "q9",
      type: ApplicationFieldTypes.radio,
      question: "Avez-vous connaissance du budget que représente un chat (nourriture, litière, jeux, soins, vétérinaire…) ?  *",
      attributes: ["Oui", "Non"],
      value: 0
    ),
    "title2": const ApplicationQuestion(
      id: "title2",
      type: ApplicationFieldTypes.title,
      question: "Logement",
    ),
    "q10": const ApplicationQuestion(
      id: "q10",
      type: ApplicationFieldTypes.radio,
      question: "Vivez vous... : *",
      attributes: [
        "En appartement",
        "En maison de ville",
        "En maison avec cour",
        "En maison avec jardin",
      ],
      value: 0
    ),
    "q11": ApplicationQuestion(
      id: "q11",
      type: ApplicationFieldTypes.text,
      question: "A quel étage ? *",
      attributes: "0",
      mandatory: true,
      value: TextEditingController()
    ),
    "q12": const ApplicationQuestion(
      id: "q12",
      type: ApplicationFieldTypes.radio,
      question: "Fenêtres à oscillo-battant ? *",
      attributes: ["Oui", "Non"],
      value: 1
    ),
    "q13": const ApplicationQuestion(
      id: "q13",
      type: ApplicationFieldTypes.checkbox,
      question: "Avec accès à l'extérieur ? *",
      attributes: [
        "Cour", "Balcon", "Jardin", "Terasse", "Aucun"
      ],
      value: '4'
    ),
    "q14": const ApplicationQuestion(
      id: "q14",
      type: ApplicationFieldTypes.radio,
      question: "Les extérieurs sont-ils sécurisés ? *",
      attributes: ["Oui", "Non", "Pas d'exterieur"],
      value: 2
    ),
    "q15": ApplicationQuestion(
      id: "q15",
      type: ApplicationFieldTypes.text,
      question: "Si oui, de quelle façon ?",
      attributes: 'Exemple : de la meilleure façon possible',
      value: TextEditingController()
    ),
    "q16": const ApplicationQuestion(
      id: "q16",
      type: ApplicationFieldTypes.photo,
      question: 'Envoyez une photo de votre extérieur sécurisé (10MB max):',
      value: ''
    ),
    "q17": const ApplicationQuestion(
      id: "q17",
      type: ApplicationFieldTypes.radio,
      question: "Si non, êtes-vous prêt à les sécuriser ? *",
      attributes: [
        "Oui",
        "Non",
        "Ils sont sécurisés",
        "Pas d'accès extérieur",
      ],
      value: 3
    ),
    "q18": ApplicationQuestion(
      id: "q18",
      type: ApplicationFieldTypes.text,
      question: "Superficie de l'habitat ? *",
      attributes: 'Exemple : 40m²',
      value: TextEditingController()
    ),
    "q19": ApplicationQuestion(
      id: "q19",
      type: ApplicationFieldTypes.text,
      question: "Combien de pièces ? *",
      attributes: 'Exemple : 3',
      value: TextEditingController()
    ),
    "title3": const ApplicationQuestion(
      id: "title3",
      type: ApplicationFieldTypes.title,
      question: "Autres questions",
    ),
    "q20": const ApplicationQuestion(
      id: "q20",
      type: ApplicationFieldTypes.radio,
      question: "Dans le cas de l’arrivée d’un bébé dans votre foyer, si vous n’êtes pas immunisé toxoplasmose, pensez-vous garder le chat ? *",
      attributes: [
        'Oui',
        'Non',
        'Je ne compte pas avoir un enfant'
      ],
      value: 0
    ),
    "q21": ApplicationQuestion(
      id: "q21",
      type: ApplicationFieldTypes.text,
      question: "Combien de temps envisagez-vous de consacrer au jeu avec votre chat ? *",
      attributes: 'Exemple : 2 heures par jours',
      value: TextEditingController(),
    ),
    "q22": const ApplicationQuestion(
      id: "q22",
      type: ApplicationFieldTypes.radio,
      question: "Etes-vous conscient que l’espérance de vie d’un chat est en moyenne de 12 à 15 ans voire 21 ans ? *",
      attributes: ['Oui', 'Non'],
      value: 0
    ),
    "q23": const ApplicationQuestion(
      id: "q23",
      type: ApplicationFieldTypes.radio,
      question: "Etes-vous au fait des textes en vigueur sur les droits des animaux et la déclaration universelle des droits des animaux ? *",
      attributes: ['Oui', 'Non'],
      value: 0
    ),
    "q24": const ApplicationQuestion(
      id: "q24",
      type: ApplicationFieldTypes.radio,
      question: "Etes-vous d’accord pour vous engager à nous communiquer des nouvelles régulièrement (avec photos) du chat adopté ? *",
      attributes: ['Oui', 'Non'],
      value: 0
    )
    // "q13": const ApplicationQuestion(
    //   id: "q13",
    //   type: ApplicationFieldTypes.radio,
    //   question: ""
    // )
  };

  @override
  void initState() {
    super.initState();

    _cat = ref.read(catsControllerProvider).cats.asData?.value[widget.application?.catId] ?? widget.cat;
    // _user = widget.application?.user ?? ref.read(appUserControllerProvider).user;
    if (widget.user != null) {
      _user = widget.user;
    }
    else {
      _user = ref.read(appUserControllerProvider).user;
    }

    for (final question in _questions.values) {
      if (question.type == ApplicationFieldTypes.radio) {
        _questions[question.id] = question.copyWith(
          value: int.tryParse(widget.application?.questions[question.id]?.value as String? ?? 'Unknown') ?? question.value
        );
      }
      else if (question.type == ApplicationFieldTypes.checkbox) {
        _questions[question.id] = question.copyWith(
          value: widget.application?.questions[question.id]?.value as String? ?? question.value,
        );
      }
      else if (question.type == ApplicationFieldTypes.photo) {
        _questions[question.id] = question.copyWith(
          value: widget.application?.questions[question.id]?.value as String? ?? question.value,
        );
      }
      else if (question.type == ApplicationFieldTypes.text) {
        _questions[question.id] = question.copyWith(
          value: TextEditingController(text: ((widget.application?.questions[question.id]?.value as String?) ?? ""))
        );
      }
    }

    _firstNameController.text = _user?.firstName ?? "";
    _lastNameController.text = _user?.lastName ?? "";
    _phoneController.text = widget.application?.phone ?? "";
    _emailController.text = _user?.email ?? "";
    _addressController.text = widget.application?.address ?? "";
    _adultsNumberController.text = widget.application?.adultsNumber ?? "";
    _adultsAgeController.text = widget.application?.adultsAge ?? "";
    _childrenNumberController.text = widget.application?.childrenNumber ?? "";
    _childrenAgeController.text = widget.application?.childrenAge ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final bool userLoggedIn = ref.watch(appUserControllerProvider).user != null;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
      key: _formKey,
      child: Column( 
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_errorMessage.isNotEmpty)
            AmStatusMessage(
              title: "Erreur",
              message: _errorMessage,
            ),
          // General part
          Text("Identité", style: Theme.of(context).textTheme.headline5,),
          const SizedBox(height: 12,),
          _buildRow(
            _buildTextField(
              controller: _lastNameController, 
              question: "Nom", 
              hintText: "Exemple : DENIS",
              mandatory: true,
              readOnly: userLoggedIn
            ),
            _buildTextField(
              controller: _firstNameController,
              question: "Prénom",
              hintText: "Exemple : Victor",
              mandatory: true,
              readOnly: userLoggedIn
            )
          ),
          const SizedBox(height: 12),
          _buildRow(
            _buildTextField(
              controller: _phoneController,
              question: "Numéro de téléphone",
              hintText: "Exemple : 0652809335",
              mandatory: true
            ),
            _buildTextField(
              controller: _emailController,
              question: "Adresse de messagerie",
              hintText: "Exemple : admin@feldrise.com",
              readOnly: userLoggedIn,
              mandatory: true
            )
          ),
          const SizedBox(height: 12,),
          _buildTextField(
            controller: _addressController,
            question: "Adresse",
            hintText: "Exemple : 15 rue de Paris - 75000 Paris",
            mandatory: true
          ),
          const SizedBox(height: 12,),
          _buildRow(
            _buildTextField(
              controller: _adultsNumberController,
              question: "Nombre d'adultes",
              hintText: "Exemple : 1",
              // inputType: TextInputType.number,
              mandatory: true
            ),
            _buildTextField(
              controller: _adultsAgeController,
              question: "Age des adultes",
              hintText: "Exemple : 25",
              // inputType: TextInputType.number,
              mandatory: true
            )
          ),
          const SizedBox(height: 12,),
          _buildRow(
            _buildTextField(
              controller: _childrenNumberController,
              question: "Nombre d'enfants",
              hintText: "Exemple : 0",
              // inputType: TextInputType.number,
              mandatory: true
            ),
            _buildTextField(
              controller: _childrenAgeController,
              question: "Age des enfants",
              hintText: "Exemple : 0",
              // inputType: TextInputType.number,
              mandatory: true
            )
          ),
          const SizedBox(height: 12,),
          for (final question in _questions.values) ...{
            if (question.type == ApplicationFieldTypes.title)
              Text(question.question, style: Theme.of(context).textTheme.headline5,),
            if (question.type == ApplicationFieldTypes.radio) 
              _buildRadioGroup(
                question: question.question,
                options: question.attributes as List<String>, 
                currentValue: question.value as int, 
                onStateChanged: (value) {
                  _questions[question.id] = question.copyWith(value: value);
                }
              )
            else if (question.type == ApplicationFieldTypes.checkbox) 
              _buildCheckboxGroup(
                question: question.question,
                options: question.attributes as List<String>,
                values: question.value as String,
                onStateChanged: (value) {
                  _questions[question.id] = question.copyWith(value: value);
                }
              )
            else if (question.type == ApplicationFieldTypes.photo) 
              _buildImagePicker(
                question: question.question,
                currentValue: question.value as String, 
                onStateChanged: (value) {
                  _questions[question.id] = question.copyWith(value: value);
                }
              )
            else if (question.type == ApplicationFieldTypes.text)
              _buildTextField(
                controller: question.value as TextEditingController,
                question: question.question,
                hintText: question.attributes as String,
                mandatory: question.mandatory,
              ),
            const SizedBox(height: 12,),
          },
          if (widget.isEditing)
            AmButton(
              text: "Valider",
              onPressed: _submitApplication
            ),
          const SizedBox(height: 24,)
        ],
      )
    );
  }

  Widget _buildRow(Widget input1, Widget input2) {
    return Flexible(
      child: Row(
        children: [
          input1,
          const SizedBox(width: 8,),
          input2
        ],
      ),
    );
  }

  Widget _buildRadioGroup({required String question, required List<String> options, required int currentValue, required Function(int) onStateChanged}) {
    if (widget.isEditing) {
      return Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question),
            for (int i = 0; i < options.length; ++i) 
              Flexible(
                child: Row(
                  children: [
                    Radio<int>(
                      visualDensity: VisualDensity.compact,
                      value: i,
                      activeColor: Theme.of(context).primaryColor,
                      groupValue: currentValue,
                      onChanged: (value) {
                        setState(() {
                          onStateChanged(value ?? i);
                        });
                      },
                    ),
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            onStateChanged(i);
                          });
                        },
                        child: Text(options[i])
                      ),
                    )
                  ],
                ),
              )
          ]
        ),
      );
    }

    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Text(question, style: GoogleFonts.raleway(fontWeight: FontWeight.bold,)),
          ),
          const SizedBox(height: 8,),
          Flexible(
            child: Text(options[currentValue]),
          )
        ],
      ),
    );
  }

  Widget _buildCheckboxGroup({required String question, required List<String> options, required String values, required Function(String) onStateChanged}) {
    final List<String> valuesString = values.split(',');
    final List<int> valuesList = [];
    
    for (final valueString in valuesString) {
      int? value = int.tryParse(valueString);

      if (value != null) valuesList.add(value);
    }

    if (widget.isEditing) {
      return Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question),
            for (int i = 0; i < options.length; ++i) 
              Flexible(
                child: Row(
                  children: [
                    Checkbox(
                      visualDensity: VisualDensity.compact,
                      value: valuesList.contains(i),
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (checked) {
                        setState(() {
                          if (checked ?? false) {
                            onStateChanged("$i,$values");
                          }
                          else {
                            onStateChanged(values.replaceAll('$i,', '').replaceAll('$i', ''));
                          }
                        });
                      },
                    ),
                    Flexible(
                      child: Text(options[i])
                    )
                  ],
                ),
              )
          ]
        ),
      );
    }

    String text = '';

    for (final value in valuesList) {
      text += "${options[value]}, ";
    }

    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Text(question, style: GoogleFonts.raleway(fontWeight: FontWeight.bold,)),
          ),
          const SizedBox(height: 8,),
          Flexible(
            child: Text(text),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String question, required String hintText, bool mandatory = false, bool readOnly = false}) {
    if (widget.isEditing) {
      return Flexible(
        child: AmTextInput(
          controller: controller,
          labelText: question,
          hintText: hintText,
          readOnly: readOnly,
          validator: mandatory ? (value) {
            if (value.isEmpty) return "Ce champs est requis";
            return null;
          } : null,
        )
      );
    }

      return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Text(question, style: GoogleFonts.raleway(fontWeight: FontWeight.bold,)),
          ),
          const SizedBox(height: 8,),
          Flexible(
            child: Text(controller.text),
          )
        ],
      ),
    );
  }

  Widget _buildImagePicker({required String question, required String currentValue, required Function(String) onStateChanged}) {
    if (widget.isEditing) {
      return Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question),
            const SizedBox(height: 8,),
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: AmButton(
                      text: "Choisir un fichier",
                      onPressed: () async {
                        final fileBytes = await _selectImage();

                        if (fileBytes != null) {
                          setState(() {
                            onStateChanged(fileBytes);
                          });
                        }
                      },
                    )
                  ),
                  const SizedBox(width: 8,),
                  Flexible(
                    child: Text(currentValue.isNotEmpty ? 'Fichier choisi' : "Aucun fichier n'a été choisi"),
                  )
                ],
              ),
            )
          ]
        ),
      );
    }

    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Text(question, style: GoogleFonts.raleway(fontWeight: FontWeight.bold,)),
          ),
          const SizedBox(height: 8,),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: currentValue.isEmpty ? const Text("Pas d'image") : Image.memory(base64Decode(currentValue)),
            ),
          )
        ],
      ),
    );
  }

  Future<String?> _selectImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image
    );

    if (result != null) {
      final PlatformFile file = result.files.first;
      if (file.bytes != null) {
        return base64Encode(file.bytes!);
      }
      else {
        File file = File(result.files.first.path!);
        final bytes = await file.readAsBytes();

        return base64Encode(bytes);
      }
    }
  }

  Future _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    // TODO: manage unconnected user
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      Application application = Application(widget.application?.id,
        userId: _user?.id ?? "Unknwon",
        catId: _cat!.id!,
        date: DateTime.now(),
        step: widget.application?.step ?? "Sent",
        phone: _phoneController.text,
        address: _addressController.text,
        adultsNumber: _adultsNumberController.text,
        adultsAge: _adultsAgeController.text,
        childrenNumber: _childrenNumberController.text,
        childrenAge: _childrenAgeController.text,
        questions: {
          for (final question in _questions.values)
            if (question.type != ApplicationFieldTypes.title) 
              question.id: ApplicationQuestion(
                id: question.id,
                question: question.question,
                type: question.type,
                value: question.type == ApplicationFieldTypes.text ? (question.value as TextEditingController).text : question.value
            )
        }
      );

      String authorization = ref.read(appUserControllerProvider).user!.authenticationHeader;

      if (widget.application == null) {
        await ApplicationsService.instance.createApplication(application, authorization: authorization);  
      }
      else {
        await ApplicationsService.instance.updateApplication(application, authorization: authorization);

        ref.read(applicationsControllerProvider.notifier).updateApplication(
          application.copyWith(questions: {})
        );
      }

      setState(() {
        _isLoading = false;
        _errorMessage = "";
      });

      Navigator.of(context).pop();
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Impossible d'envoyer ou mettre à jour la candidature : ${e.code} ; ${e.message}";
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