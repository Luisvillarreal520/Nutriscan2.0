import 'package:flutter/material.dart';
import 'package:flutter_application_1/base_de_datos/maindata.dart';
class Login extends StatefulWidget{
    final VoidCallback alIniciarSesion;
  
  
  const Login({
    super.key,
    required this.alIniciarSesion,
    });
  
  @override
  State<Login> createState()=> LoginState();
}

class LoginState extends State<Login>{


  final TextEditingController campoUsuario = TextEditingController();
  final TextEditingController campoContrasena = TextEditingController();

  final MainData bd=MainData();

  //validar los datos de usuario y contraseña

  void iniciarSesion() async {
    bool acceso = await bd.validarUsuario(
      campoUsuario.text.trim(),
      campoContrasena.text,
    );

    if(!mounted) return;
    if(acceso){
      widget.alIniciarSesion();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre de usuario o la contraseña son incorrectos'), 
          ),
      );
    }
  }

@override
Widget build(BuildContext context){
  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            //campo de texto para digitar el nombre de usuario
            TextField(
              controller: campoUsuario,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_2)
                
              ),
            ),
            SizedBox(height: 20,),

            //campo de texto para digitar la contraseña
            TextField(
              controller: campoContrasena,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock)
                
              ),
            ),


            const SizedBox(height: 25),

            //Boton para iniciar sesion

            ElevatedButton(
              onPressed: iniciarSesion,
              child: const Text('Iniciar sesion'),
            ),
          ],
        ),
        
         ),
    ),
  );
}

@override
void dispose(){
  campoUsuario.dispose();
  campoContrasena.dispose();
  super.dispose();
}


}