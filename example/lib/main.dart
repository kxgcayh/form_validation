import 'package:flutter/material.dart';
import 'package:form_floating_action_button/form_floating_action_button.dart';
import 'package:form_validation/form_validation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Validation Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = false;

  final TextEditingController requiredTextController = TextEditingController();
  final TextEditingController equalTextController = TextEditingController();

  void _onSubmit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 3));
    _loading = false;
    if (mounted == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (BuildContext context) => Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: requiredTextController,
                  decoration: const InputDecoration(
                    labelText: 'Required',
                  ),
                  validator: (value) {
                    final validator = Validator(
                      validators: [const RequiredValidator()],
                    );

                    return validator.validate(
                      label: 'Required',
                      value: value,
                    );
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    final validator = Validator(
                      validators: [
                        const RequiredValidator(),
                        const EmailValidator(),
                      ],
                    );

                    return validator.validate(
                      label: 'Email',
                      value: value,
                    );
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Min 3 / Max 5 Length',
                  ),
                  validator: (value) {
                    final validator = Validator(
                      validators: [
                        const MaxLengthValidator(length: 5),
                        const MinLengthValidator(length: 3),
                      ],
                    );

                    return validator.validate(
                      label: 'Min 3 / Max 5 Length',
                      value: value,
                    );
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: equalTextController,
                  decoration: const InputDecoration(
                    labelText: 'Equal',
                  ),
                  validator: (value) {
                    final validator = Validator(
                      validators: [EqualValidator(target: requiredTextController.text)],
                    );

                    return validator.validate(
                      label: 'Equal',
                      value: value,
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FormFloatingActionButton(
            loading: _loading,
            onSubmit: _onSubmit,
            onValidate: () async {
              var error = false;

              try {
                final form = Form.of(context);

                error = form.validate();
              } catch (e) {
                // no-op
              }
              return error;
            },
          ),
        ),
      ),
    );
  }
}
