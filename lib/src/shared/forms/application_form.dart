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