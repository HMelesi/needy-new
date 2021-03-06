import 'package:flutter/material.dart';
import 'package:needy_new/authentication.dart';

class SignInSignUp extends StatefulWidget {
  SignInSignUp(
      {this.auth, this.loginCallback, this.onNameChange, this.addNewUser});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  final Function(String) onNameChange;
  final Function(String, String) addNewUser;

  @override
  State<StatefulWidget> createState() => _SignInSignUpState();
}

class _SignInSignUpState extends State<SignInSignUp> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _password;
  String _errorMessage;
  bool _isLoginForm;
  bool _isLoading;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = '';
      String name = '';
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          name = _name;
          widget.onNameChange(name);
          print('Signed in: $userId with name $name');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          name = _name;
          widget.addNewUser(userId, name);
          print('Signed up user: $userId with name $name');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (err) {
        print('Error: $err');
        setState(() {
          _isLoading = false;
          _errorMessage = err.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = '';
  }

  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        child: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 48.0,
              child: Image.asset('images/catgif.gif'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'KEEPER',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                color: Colors.yellow,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showNameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'name',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          filled: true,
          fillColor: Colors.grey,
        ),
        style: TextStyle(
          fontFamily: 'PressStart2P',
          color: Colors.black,
          fontSize: 16.0,
        ),
        validator: (value) => value.isEmpty ? 'name required' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'email',
          prefixIcon: Icon(Icons.mail),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          filled: true,
          fillColor: Colors.grey,
        ),
        style: TextStyle(
          fontFamily: 'PressStart2P',
          color: Colors.black,
          fontSize: 16.0,
        ),
        validator: (value) => value.isEmpty ? 'email required' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'password',
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          filled: true,
          fillColor: Colors.grey,
        ),
        style: TextStyle(
          fontFamily: 'PressStart2P',
          color: Colors.black,
          fontSize: 16.0,
        ),
        validator: (value) => value.isEmpty ? 'password required' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 10.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          textColor: Colors.yellow,
          color: Colors.pink,
          onPressed: validateAndSubmit,
          child: Text(
            _isLoginForm ? 'Sign In' : 'Create Account',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'PressStart2P',
            ),
          ),
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return FlatButton(
      textColor: Colors.pink,
      // color: Colors.yellow,
      onPressed: toggleFormMode,
      child: Text(
        _isLoginForm ? 'Create Account >' : '< Return to Sign In',
        style: TextStyle(
          fontSize: 15.0,
          fontFamily: 'PressStart2P',
        ),
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontFamily: 'PressStart2P',
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: (_isLoginForm)
          ? Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  showLogo(),
                  showEmailInput(),
                  showPasswordInput(),
                  showPrimaryButton(),
                  showSecondaryButton(),
                  showErrorMessage(),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  showLogo(),
                  showNameInput(),
                  showEmailInput(),
                  showPasswordInput(),
                  showPrimaryButton(),
                  showSecondaryButton(),
                  showErrorMessage(),
                ],
              ),
            ),
    );
  }
}
