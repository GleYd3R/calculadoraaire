import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const Calendarios());
}

class Calendarios extends StatelessWidget {
  const Calendarios({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Air-e',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final TextEditingController _fechaAnte = TextEditingController();
  var fechaAnte = DateTime.now(); // aca se guarda la fecha 1
  final TextEditingController _fechaActu = TextEditingController();
  var fechaActu = DateTime.now(); // aca se guarda la fecha 2
  final _lecturaActu = TextEditingController();
  final _lecturaAnte = TextEditingController();
  final TextEditingController _precioKw = TextEditingController();
  var _dias;
  var _consumo;
  var _consuPromedio;

////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Calculadora Air-e')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            lecturaActual(),
            fechaActual(),
            lecturaAnterior(),
            fechaAnterior(),
            precioKw(),
            botonCalcular(),
          ]),
        ),
      ),
    );
  }

  ////////////// fecha anteior ////////////////
  Widget fechaAnterior() => TextField(
      keyboardType: TextInputType.none,
      controller: _fechaAnte,
      decoration: const InputDecoration(
          icon: Icon(Icons.calendar_month_sharp),
          helperText: 'Selecciona la fecha de la lectura anterior',
          labelText: 'Fecha de lectura anterior'),
      onTap: () async {
        DateTime? nuevafecha = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100));
        fechaAnte = nuevafecha!; // esto captura la fecha escogida
        if (nuevafecha == null) return;
        setState(() {
          _fechaAnte.text =
              '${nuevafecha.day}/${nuevafecha.month}/${nuevafecha.year}';
        });
      });

  ////////////// fecha actual /////////////////
  Widget fechaActual() => TextField(
      keyboardType: TextInputType.none,
      controller: _fechaActu,
      decoration: const InputDecoration(
          icon: Icon(Icons.calendar_month_sharp),
          helperText: 'Selecciona la fecha de la lectura actual',
          labelText: 'Fecha de lectura actual'),
      onTap: () async {
        DateTime? nuevafecha = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100));
        fechaActu = nuevafecha!; // esto captura la fecha escogida
        if (nuevafecha == null) return;
        setState(() {
          _fechaActu.text =
              '${nuevafecha.day}/${nuevafecha.month}/${nuevafecha.year}';
        });
      });

/////////////// Lectura Actual //////////////////
  Widget lecturaActual() => TextField(
        keyboardType: TextInputType.number,
        controller: _lecturaActu,
        decoration: const InputDecoration(
            icon: Icon(Icons.more_time),
            helperText: 'Digita la lectura actual',
            labelText: 'Lectura actual'),
      );

//////////// Lectura Anterior ///////////////
  Widget lecturaAnterior() => TextField(
        keyboardType: TextInputType.number,
        controller: _lecturaAnte,
        decoration: const InputDecoration(
            icon: Icon(Icons.more_time),
            helperText: 'Digita la lectura anterior',
            labelText: 'Lectura anterior'),
      );

  ////////// PrecioKw /////////////
  Widget precioKw() => TextField(
        keyboardType: TextInputType.number,
        controller: _precioKw,
        decoration: const InputDecoration(
          icon: Icon(Icons.attach_money),
          helperText: 'Digita el Precio del Kw',
          labelText: 'Precio Kw',
        ),
      );
/////// calcular ////////

  void calcular() {
    _consumo = int.parse(_lecturaActu.text) - int.parse(_lecturaAnte.text);
    _dias = fechaActu
        .difference(fechaAnte)
        .inDays; // esto calcula la dierencia entre las fechas
    _consuPromedio = _consumo / _dias;
  }

//////////// boton calcular ////////////
  Widget botonCalcular() => IconButton(
      iconSize: 70,
      onPressed: () {
        calcular();
        //print(consumido);
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Resuldatos'),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Consumo total: $_consumo Kw')),
                Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text('Consumo promedio por dia: $_consuPromedio Kw')),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Valor consumo total:  Pesos')),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Valor consumo diario:  Pesos')),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Dias calculados: $_dias dias')),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Salir'))
              ],
            ),
          ),
        );
      },
      icon: const Icon(Icons.calculate_rounded));
}
