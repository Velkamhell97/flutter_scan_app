import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({Key? key}) : super(key: key);

  static const _style = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.warning, color: Colors.deepPurple, size: 50),
          SizedBox(height: 10),
          Text('Eliminar registros', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 10),
          Text('Estas seguro que deseas eliminar todos los registros disponibles ?'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), 
          child: const Text('Cancelar', style: _style),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), 
          child: const Text('Aceptar', style: _style),
        )
      ],
    );
  }
}