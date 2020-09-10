import 'dart:async';
import 'package:flutter/material.dart';

class SimpleForm extends StatefulWidget {
  final Widget child;
  final FutureOr Function() onSubmit;

  SimpleForm({
    @required Key key,
    @required this.child,
    @required this.onSubmit
  }): assert(key != null),
      assert(child != null),
      assert(onSubmit != null),
      super(key: key);

  @override
  SimpleFormState createState() => SimpleFormState();
}

class SimpleFormState extends State<SimpleForm> {
  var _validate = false;
  var _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: widget.child,
      autovalidate: _validate
    );
  }

  FutureOr submit() async {
    if (_key.currentState.validate()) {
      try {
        final result = await widget.onSubmit();

        return result;
      } catch (e) {
        // showDialog(
        //   context: context,
        //   builder: (context) => _Form
        // );
      }
    } else if (! _validate) {
      setState(() => _validate = true);
    }

    return null;
  }
}

// typedef Widget SimpleFormBuilder(BuildContext context, Function submitter);
//
// class SimpleForm extends Form {
//   final Function onSubmit;
//   final WidgetBuilder builder;
//
//   SimpleForm({this.onSubmit,this.builder})
//       : super(child: Builder(builder: builder));
//
//   static _SimpleFormState of(BuildContext context) {
//     return Form.of(context) as _SimpleFormState;
//   }
//
//   @override
//   _SimpleFormState createState() => _SimpleFormState();
// }
//
// class _SimpleFormState extends FormState {
//   FutureOr submit() async {
//     if (validate()) {
//       try {
//         var result = (widget as SimpleForm).onSubmit();
//         if (result is Future) await result;
//       } on Error catch (e) {
//         showDialog(
//           context: context,
//           builder: (context) => _FormErrorDialog(e)
//         );
//       }
//     }
//   }
// }
//
// class _FormErrorDialog extends Dialog {
//   _FormErrorDialog(Error e): super(
//     child: Text(e.runtimeType.toString())
//   );
// }