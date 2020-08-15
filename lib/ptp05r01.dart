import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'constantes.dart';
import 'package:sprintf/sprintf.dart';
import 'dart:convert';
import 'package:SSI/POCOs/empresa.dart';
import 'package:SSI/POCOs/provincia.dart';
import 'package:SSI/POCOs/canton.dart';
import 'package:SSI/POCOs/distrito.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:SSI/POCOs/objPtp05r01.dart';
import 'package:SSI/listaregistros.dart';

class PTP05R01 extends StatefulWidget{
  @override
  State createState() => PTP05R01State();

}

class PTP05R01State extends State<PTP05R01> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _usuario = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _funcionario = new TextEditingController();

  var _keyScaffold = new GlobalKey<ScaffoldState>();

  DateTime _date;
  TimeOfDay _startTime;
  TimeOfDay _finishTime;
  TextEditingController startTimeController;
  TextEditingController finishTimeController;
  TextEditingController dateInputController;

  /* Valores para enviar al ws */

  /* End Valores para enviar al ws */

  int _cantidadPasos = 4;

  final List<DropdownMenuItem> _empresas = [];
  final List<DropdownMenuItem> _provincias = [];
  final List<DropdownMenuItem> _cantones = [];
  final List<DropdownMenuItem> _distritos = [];

  int currStep = 0;
  static var _focusNode = new FocusNode();
  static ObjPtp05r01 datosRegistro = new ObjPtp05r01( '', -1 , '', '', '', '', -1, -1, -1, -1, '', '', '', -1, '', false, '', false, '', false,
      '', -1, false, false, false, false, false, false, false, false, false, false, false, false, false, false, '', '');

  final List<DropdownMenuItem> _tipoMuestreo = [];

  Future<String> getEmpresas() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapListaEmpresas,
          "Host": Constantes.host
        },
        body: Constantes.envelopeListaEmpresas);

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.listaEmpresasMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    this.setState(() {

      var _lista = parsedJson["Objeto"] as List;

      _lista.map((i)=>Empresa.fromJson(i)).toList().forEach((empresa) => {
        _empresas.add(DropdownMenuItem(
          child: Text(empresa.nombre),
          value: empresa.id,
        ))
      });

    });

    return "Success!";
  }

  Future<String> getProvincias() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapListaProvincias,
          "Host": Constantes.host
        },
        body: Constantes.envelopeListaProvincias);

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.listaProvinciasMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    this.setState(() {

      var _lista = parsedJson["Objeto"] as List;

      _lista.map((i)=>Provincia.fromJson(i)).toList().forEach((provincia) => {
        _provincias.add(DropdownMenuItem(
          child: Text(provincia.nombre),
          value: provincia.id,
        ))
      });

    });

    return "Success!";
  }

  Future<String> getCantones() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapListaCantones,
          "Host": Constantes.host
        },
        body: sprintf(Constantes.envelopeListaCantones, [ datosRegistro.idProvincia ] ));

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.listaCantonesMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    this.setState(() {

      var _lista = parsedJson["Objeto"] as List;

      _lista.map((i)=>Canton.fromJson(i)).toList().forEach((canton) => {
        _cantones.add(DropdownMenuItem(
          child: Text(canton.nombre),
          value: canton.id,
        ))
      });

    });

    return "Success!";
  }

  Future<String> getDistritos() async {

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapListaDistritos,
          "Host": Constantes.host
        },
        body: sprintf(Constantes.envelopeListaDistritos, [ datosRegistro.idProvincia, datosRegistro.idCanton ] ));

    var _response = response.body;
    var _document = xml.parse(_response);
    String resultado = _document.findAllElements(sprintf( "%sResult", [Constantes.listaDistritosMethod])).elementAt(0).text;

    var parsedJson = json.decode(resultado);

    this.setState(() {

      var _lista = parsedJson["Objeto"] as List;

      _lista.map((i)=>Distrito.fromJson(i)).toList().forEach((distrito) => {
        _distritos.add(DropdownMenuItem(
          child: Text(distrito.nombre),
          value: distrito.id,
        ))
      });

    });

    return "Success!";
  }


  Future<String> saveData() async {

    String bodyResponse = sprintf(Constantes.envelopeGuardaPTP05R01, [
      'PT-P05-R01',
      Constantes.idEmpresa,
      datosRegistro.fechaMuestra,
      datosRegistro.horaInicial,
      datosRegistro.horaFinal,
      'jmartinez',
      datosRegistro.idCliente,
      datosRegistro.idProvincia,
      datosRegistro.idCanton,
      datosRegistro.idDistrito,
      datosRegistro.funcionarioAutEmpresa,
      datosRegistro.descripcionMuestreo,
      datosRegistro.idTipoMuestreo,
      datosRegistro.horasVertido,
      datosRegistro.puntoMedicionCaudal,
      ( datosRegistro.cuerpoReceptor != null ? 1 : 0 ),
      datosRegistro.detalleCuerpoReceptor,
      (datosRegistro.alcantarilladoSanitario != null ? 1 : 0),
      datosRegistro.detalleAlcantarilladoSanitario,
      (datosRegistro.reusoTipo != null ? 1 : 0),
      datosRegistro.detalleReusoTipo,
      datosRegistro.volumenRecipiente,
      (datosRegistro.dbo != null ? 1 : 0),
      (datosRegistro.dqo != null ? 1 : 0),
      (datosRegistro.sst != null ? 1 : 0),
      (datosRegistro.ssed != null ? 1 : 0),
      (datosRegistro.gya != null ? 1 : 0),
      (datosRegistro.ph != null ? 1 : 0),
      (datosRegistro.temp != null ? 1 : 0),
      (datosRegistro.saam != null ? 1 : 0),
      (datosRegistro.color != null ? 1 : 0),
      (datosRegistro.metp != null ? 1 : 0),
      (datosRegistro.fenoles != null ? 1 : 0),
      (datosRegistro.coliformes != null ? 1 : 0),
      (datosRegistro.nematodos != null ? 1 : 0),
      (datosRegistro.plaguicidas != null ? 1 : 0),
      datosRegistro.otros,
      datosRegistro.observaciones
    ] );

    http.Response response =
    await http.post(Constantes.ulrWebService,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
          "SOAPAction": Constantes.urlSoapGuardaPTP05R01,
          "Host": Constantes.host
        },
        body: bodyResponse);

    var _response = response.body;
    var _document = xml.parse(_response);

    if (_response.toString().indexOf("faultcode") < 0) {
      String resultado = _document
          .findAllElements(
          sprintf("%sResult", [Constantes.guardaPTP05R01Method]))
          .elementAt(0)
          .text;

      var parsedJson = json.decode(resultado);


      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Details"),
            //content: new Text("Hello World"),
            content: Center(
              child: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Icon(
                        parsedJson["Error"] ? Icons.error : Icons.check_circle,
                        color: parsedJson["Error"] ? Colors.red : Colors.green),
                    new Text("Resultado : " + parsedJson["Mensaje"]),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  if (!parsedJson["Error"]) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ListaRegistros()),
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ));
    } else
    {
      _keyScaffold.currentState.showSnackBar(SnackBar(content: Text(_document.findAllElements('faultstring').elementAt(0).text, style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
    }
    return "Success!";
  }

  @override
  void initState(){

    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });

    this.getEmpresas();
    this.getProvincias();

    /* Inicializa tipo Muestreo */
    _tipoMuestreo.add(DropdownMenuItem(
      child: Text("Simple"),
      value: "S",
    ));

    _tipoMuestreo.add(DropdownMenuItem(
      child: Text("Compuesto"),
      value: "C",
    ));

    _tipoMuestreo.add(DropdownMenuItem(
      child: Text("Compuesto Proporcional"),
      value: "P",
    ));

    /* Fin Inicializa tipo Muestreo */
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        _keyScaffold.currentState.showSnackBar(SnackBar(content: Text('Por favor ingrese todos los datos requeridos', style: TextStyle( color: Colors.black),), backgroundColor: Colors.white));
      } else {
        formState.save();
        print("Fecha: ${datosRegistro.fechaMuestra}");
        print("Inicio: ${datosRegistro.horaInicial}");
        print("Fin: ${datosRegistro.horaFinal}");
        print("Descripción: ${datosRegistro.descripcionMuestreo}");

        saveData();
      }
    }

    return Scaffold(
      key: _keyScaffold,
      appBar: AppBar(title: Text('Registro PT-P05-R01'), backgroundColor: Constantes.colorPrimario,),
      body: Container(
          child: Form(
            key: _formKey,
            child: new Theme(
              data: new ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Constantes.colorPrimario,
                  inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: new TextStyle(
                        color: Constantes.colorEtiquetaInput,
                        fontSize: 20.0,
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constantes.colorBorderInputLogin),
                        borderRadius: BorderRadius.circular(15.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Constantes.colorBorderInputLogin),
                        borderRadius: BorderRadius.circular(15.7),
                      )
                  )
              ),
              child: new ListView(children: <Widget>[
                new Stepper(
                  physics: ClampingScrollPhysics(),
                  type: StepperType.vertical,
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                    return Row(
                        children: <Widget>[
                          Expanded(
                            child: (
                                FlatButton(
                                  child: Column(
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget> [
                                              Text("Siguiente"),
                                              Padding(padding: const EdgeInsets.only(left:10.0),),
                                              Icon(Icons.skip_next)
                                            ]
                                        )
                                      ]
                                  ),
                                  onPressed: onStepContinue,
                                  shape: RoundedRectangleBorder(side: BorderSide(color: Constantes.colorBoton)),
                                )
                            ),
                          ),
                          Expanded(
                            child: (
                                FlatButton(
                                  child: Column(
                                      children: <Widget>[
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget> [
                                              Icon(Icons.skip_previous),
                                              Padding(padding: const EdgeInsets.only(left:10.0),),
                                              Text("Regresar"),
                                            ]
                                        )
                                      ]
                                  ),
                                  onPressed: onStepCancel,
                                  shape: RoundedRectangleBorder(side: BorderSide(color: Constantes.colorSplashBoton)),
                                )
                            ),
                          ),

                        ]
                    );
                  },
                  steps: [
                    new Step(
                      title: const Text('Encabezado'),
                      //subtitle: const Text('Enter your name'),
                      isActive: true,
                      //state: StepState.error,
                      state: StepState.indexed,
                      content:
                      new Wrap(
                        children:<Widget>[
                          Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Card(
                                elevation: 3,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Encargado: ", style: TextStyle( fontWeight: FontWeight.bold ),),
                                        Text("Jonathan Martinez")
                                      ],
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              print("onTap dateInput");
                                              _showDatePicker();
                                            },
                                            child: Icon(Icons.date_range),
                                          ),
                                        ),
                                        Container(
                                          child: new Flexible(
                                              child: new TextField(
                                                  decoration: InputDecoration(
                                                      labelText: "Fecha Muestreo",
                                                      hintText: "Fecha Muestreo",
                                                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                                  maxLines: 1,
                                                  readOnly: true,
                                                  controller: dateInputController)),
                                        ),
                                      ],
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              print("onTap start");
                                              _showStartTimeDialog();
                                            },
                                            child: Icon(Icons.access_time),
                                          ),
                                        ),
                                        Container(
                                          child: new Flexible(
                                              child: new TextField(
                                                  decoration: InputDecoration(
                                                      labelText: "Hora Inicio",
                                                      hintText: "Hora Inicio",
                                                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                                  maxLines: 1,
                                                  readOnly: true,
                                                  controller: startTimeController)),
                                        ),

                                      ],
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              print("onTap start");
                                              _showFinalTimeDialog();
                                            },
                                            child: Icon(Icons.access_time),
                                          ),
                                        ),
                                        Container(
                                          child: new Flexible(
                                              child: new TextField(
                                                  decoration: InputDecoration(
                                                      labelText: "Hora Fin",
                                                      hintText: "Hora Fin",
                                                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                                  maxLines: 1,
                                                  readOnly: true,
                                                  controller: finishTimeController)),
                                        ),
                                      ],
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    SearchableDropdown.single(
                                      isExpanded: true,
                                      items: _empresas,
                                      value: datosRegistro.idCliente,
                                      hint: sprintf("Seleccione %s %s", [Constantes.prefijoEmpresa, Constantes.descripcionEmpresa.toLowerCase()]),
                                      searchHint: sprintf("Seleccione %s %s", [ Constantes.prefijoEmpresa, Constantes.descripcionEmpresa.toLowerCase() ]),
                                      onChanged: (value) {
                                        setState(() {
                                          print(value);
                                          datosRegistro.idCliente = value;
                                        });
                                      },
                                      validator: (value) {
                                        if  (value == null){
                                          return sprintf('Debe seleccionar %s %s', [Constantes.prefijoEmpresa, Constantes.descripcionEmpresa.toLowerCase()]);
                                        }
                                        return null;
                                      },
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    SearchableDropdown.single(
                                      isExpanded: true,
                                      items: _provincias,
                                      value: datosRegistro.idProvincia,
                                      hint: "Seleccione la provincia",
                                      searchHint: "Seleccione la provincia",
                                      onChanged: (value) {
                                        setState(() {
                                          print(value);
                                          datosRegistro.idProvincia = value;
                                          getCantones();
                                        });
                                      },
                                      validator: (value) {
                                        if  (value == null){
                                          return 'Debe seleccionar la provincia';
                                        }
                                        return null;
                                      },
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    SearchableDropdown.single(
                                      isExpanded: true,
                                      items: _cantones,
                                      value: datosRegistro.idCanton,
                                      hint: "Seleccione el cantón",
                                      searchHint: "Seleccione el cantón",
                                      onChanged: (value) {
                                        setState(() {
                                          print(value);
                                          datosRegistro.idCanton = value;
                                          getDistritos();
                                        });
                                      },
                                      validator: (value) {
                                        if  (value == null){
                                          return 'Debe seleccionar el cantón';
                                        }
                                        return null;
                                      },
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    SearchableDropdown.single(
                                      isExpanded: true,
                                      items: _distritos,
                                      value: datosRegistro.idDistrito,
                                      hint: "Seleccione el distrito",
                                      searchHint: "Seleccione el distrito",
                                      onChanged: (value) {
                                        setState(() {
                                          print(value);
                                          datosRegistro.idDistrito = value;
                                        });
                                      },
                                      validator: (value) {
                                        if  (value == null){
                                          return 'Debe seleccionar la provincia';
                                        }
                                        return null;
                                      },
                                    ),
                                    new Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                    ),
                                    new TextFormField(
                                      autocorrect: false,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      controller: _funcionario,
                                      decoration: new InputDecoration(
                                        labelText: "Funcionario Autoriza",
                                        hintText: 'Funcionario Autoriza',
                                        icon: const Icon(Icons.account_box),
                                        labelStyle:
                                        new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                      ),
                                      keyboardType: TextInputType.text,
                                      maxLength: 200,
                                      validator: (value) {
                                        if  (value.isEmpty){
                                          return 'Debe digitar el funcionario que autoriza';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        datosRegistro.funcionarioAutEmpresa = value;
                                      },
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    new Step(
                      title: const Text('Muestreo'),
                      //subtitle: const Text('Subtitle'),
                      isActive: true,
                      //state: StepState.editing,
                      state: StepState.indexed,
                      content:
                      new Wrap(
                        children:<Widget>[
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              elevation: 3,
                              child: Column(
                                children: <Widget>[
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    controller: _usuario,
                                    decoration: new InputDecoration(
                                      labelText: "Punto de muestreo",
                                      hintText: 'Punto de muestreo',
                                      icon: const Icon(Icons.assignment),
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLength: 100,
                                    validator: (value) {
                                      if  (value.isEmpty){
                                        return 'Debe digitar el punto de muestreo';
                                      }
                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.descripcionMuestreo = value;
                                    },
                                    maxLines: 1,
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                  ),
                                  SearchableDropdown.single(
                                    isExpanded: true,
                                    items: _tipoMuestreo,
                                    value: datosRegistro.idTipoMuestreo,
                                    hint: "Seleccione el tipo de muestreo",
                                    searchHint: "Seleccione el tipo de muestreo",
                                    onChanged: (value) {
                                      setState(() {
                                        print(value);
                                        datosRegistro.idTipoMuestreo = value;
                                      });
                                    },
                                    validator: (value) {
                                      if  (value == null){
                                        return 'Debe seleccionar seleccionar el tipo de muestreo';
                                      }
                                      return null;
                                    },
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                  ),
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: new InputDecoration(
                                      labelText: "Horas vertido",
                                      hintText: 'Horas vertido',
                                      icon: const Icon(Icons.query_builder),
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 2,
                                    validator: (value) {
                                      if  (value.isEmpty){
                                        return 'Debe digitar las horas de vertido';
                                      }

                                      var horas = int.parse(value, onError: (source) => -1);
                                      if (horas<0){
                                        return 'Las horas de vertido debe ser numérico';
                                      }

                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.horasVertido = int.parse(value);
                                    },
                                    maxLines: 1,
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                  ),
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: new InputDecoration(
                                      labelText: "Punto Medición Caudal",
                                      hintText: 'Punto Medición Caudal',
                                      icon: const Icon(Icons.low_priority),
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLength: 500,
                                    validator: (value) {
                                      if  (value.isEmpty){
                                        return 'Debe digitar el punto de medición del caudal';
                                      }

                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.puntoMedicionCaudal = value;
                                    },
                                    maxLines: 1,
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 20,
                                    thickness: 2,
                                    indent: 20,
                                    endIndent: 0,
                                  ),
                                  Text('Destino del efluente'),
                                  CheckboxListTile(
                                    title: Text("Cuerpo Receptor"),
                                    value: ( datosRegistro.cuerpoReceptor == null ? false : datosRegistro.cuerpoReceptor),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.cuerpoReceptor = newValue;

                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabled: ( datosRegistro.cuerpoReceptor == null ? false : datosRegistro.cuerpoReceptor),
                                    decoration: new InputDecoration(
                                      labelText: "Detalle cuerpo receptor",
                                      hintText: 'Detalle cuerpo receptor',
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLength: 500,
                                    validator: (value) {
                                      if  (datosRegistro.cuerpoReceptor && value.isEmpty){
                                        return 'Debe digitar el detalle cuerpo receptor';
                                      }

                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.detalleCuerpoReceptor = value;
                                    },
                                    maxLines: 1,
                                  ),
                                  CheckboxListTile(
                                    title: Text("Alcantarillado Sanitario"),
                                    value: ( datosRegistro.alcantarilladoSanitario == null ? false : datosRegistro.alcantarilladoSanitario),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.alcantarilladoSanitario = newValue;

                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabled: ( datosRegistro.alcantarilladoSanitario == null ? false : datosRegistro.alcantarilladoSanitario),
                                    decoration: new InputDecoration(
                                      labelText: "Detalle alcantarillado sanitario",
                                      hintText: 'Detalle alcantarillado sanitario',
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLength: 500,
                                    validator: (value) {
                                      if  (datosRegistro.alcantarilladoSanitario && value.isEmpty){
                                        return 'Debe digitar el detalle alcantarillado sanitario';
                                      }

                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.detalleAlcantarilladoSanitario = value;
                                    },
                                    maxLines: 1,
                                  ),
                                  CheckboxListTile(
                                    title: Text("Reuso / Tipo"),
                                    value: ( datosRegistro.reusoTipo == null ? false : datosRegistro.reusoTipo),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.reusoTipo = newValue;

                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    enabled: ( datosRegistro.reusoTipo == null ? false : datosRegistro.reusoTipo),
                                    decoration: new InputDecoration(
                                      labelText: "Detalle reuso / tipo",
                                      hintText: 'Detalle reuso / tipo',
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLength: 500,
                                    validator: (value) {
                                      if  (datosRegistro.reusoTipo && value.isEmpty){
                                        return 'Debe digitar el detalle de reuso / tipo';
                                      }

                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.detalleReusoTipo = value;
                                    },
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Step(
                      title: const Text('Mediciones Caudal'),
                      // subtitle: const Text('Subtitle'),
                      isActive: true,
                      state: StepState.indexed,
                      // state: StepState.disabled,
                      content:
                      new Wrap(
                        children:<Widget>[
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              elevation: 3,
                              child: Column(
                                children: <Widget>[
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: new InputDecoration(
                                      labelText: "Volumen Recipiente",
                                      hintText: 'Volumen Recipiente',
                                      icon: const Icon(Icons.more),
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 5,
                                    validator: (value) {
                                      if  (value.isEmpty){
                                        return 'Debe digitar el volumen de recipiente';
                                      }

                                      var horas = int.parse(value, onError: (source) => -1);
                                      if (horas<0){
                                        return 'El volumne de recipiente debe ser numérico';
                                      }

                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.volumenRecipiente = int.parse(value);
                                    },
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Step(
                      title: const Text('Análisis solicitados'),
                      // subtitle: const Text('Subtitle'),
                      isActive: true,
                      state: StepState.indexed,
                      content:
                      new Wrap(
                        children:<Widget>[
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Card(
                              elevation: 3,
                              child: Column(
                                children: <Widget>[
                                  CheckboxListTile(
                                    title: Text("DQO"),
                                    value: ( datosRegistro.dqo == null ? false : datosRegistro.dqo),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.dqo = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("DBO"),
                                    value: ( datosRegistro.dbo == null ? false : datosRegistro.dbo),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.dbo = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("SST"),
                                    value: ( datosRegistro.sst == null ? false : datosRegistro.sst),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.sst = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Ssed"),
                                    value: ( datosRegistro.ssed == null ? false : datosRegistro.ssed),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.ssed = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("GyA"),
                                    value: ( datosRegistro.gya == null ? false : datosRegistro.gya),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.gya = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("pH"),
                                    value: ( datosRegistro.ph == null ? false : datosRegistro.ph),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.ph = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Temp"),
                                    value: ( datosRegistro.temp == null ? false : datosRegistro.temp),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.temp = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("SAAM"),
                                    value: ( datosRegistro.saam == null ? false : datosRegistro.saam),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.saam = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Color"),
                                    value: ( datosRegistro.color == null ? false : datosRegistro.color),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.color = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Met. P"),
                                    value: ( datosRegistro.metp == null ? false : datosRegistro.metp),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.metp = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Fenoles"),
                                    value: ( datosRegistro.fenoles == null ? false : datosRegistro.fenoles),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.fenoles = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Coliformes"),
                                    value: ( datosRegistro.coliformes == null ? false : datosRegistro.coliformes),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.coliformes = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Nematodos"),
                                    value: ( datosRegistro.nematodos == null ? false : datosRegistro.nematodos),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.nematodos = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  CheckboxListTile(
                                    title: Text("Plaguicidas"),
                                    value: ( datosRegistro.plaguicidas == null ? false : datosRegistro.plaguicidas),
                                    onChanged: (newValue) {
                                      setState(() {
                                        datosRegistro.plaguicidas = newValue;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                  ),
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: new InputDecoration(
                                      labelText: "Otros",
                                      hintText: 'Otros',
                                      icon: const Icon(Icons.assignment),
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLength: 500,
                                    validator: (value) {
                                      /*if  (value.isEmpty){
                                                return 'Debe digitar el volumen de recipiente';
                                              }*/
                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.otros = value;
                                    },
                                    maxLines: 1,
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                  ),
                                  new TextFormField(
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: new InputDecoration(
                                      labelText: "Observaciones, Cálculos, Otros",
                                      hintText: 'Observaciones, Cálculos, Otros',
                                      icon: const Icon(Icons.chat),
                                      labelStyle:
                                      new TextStyle(decorationStyle: TextDecorationStyle.solid),
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLength: 1000,
                                    validator: (value) {
                                      /*if  (value.isEmpty){
                                                return 'Debe digitar el volumen de recipiente';
                                              }*/
                                      return null;
                                    },
                                    onSaved: (String value) {
                                      datosRegistro.observaciones = value;
                                    },
                                    maxLines: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                  currentStep: this.currStep,
                  onStepContinue: () {
                    setState(() {
                      if (currStep < _cantidadPasos - 1) {
                        currStep = currStep + 1;
                      } else {
                        currStep = 0;
                      }
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (currStep > 0) {
                        currStep = currStep - 1;
                      } else {
                        currStep = 0;
                      }
                    });
                  },
                  onStepTapped: (step) {
                    setState(() {
                      currStep = step;
                    });
                  },
                ),
                new RaisedButton(
                  child: new Text(
                    'Guardar Registro',
                    style: new TextStyle(color: Colors.white),
                  ),
                  onPressed: _submitDetails,
                  color: Constantes.colorBoton,
                ),
              ]),
            ),
          )
      ),
    );
  }


  Future<Null> _showDatePicker() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now()
            .year - 1, 1),
        lastDate: DateTime(DateTime
            .now()
            .year, 12));

    if (picked != null) {
      setState(() {
        _date = picked;
        dateInputController =
        new TextEditingController(text:
        "${picked.day}/${picked.month}/${picked.year}");

        datosRegistro.fechaMuestra = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<Null> _showStartTimeDialog() async {
    final TimeOfDay picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _startTime = picked;
        startTimeController =
        new TextEditingController(text:
        "${picked.hour}:${picked.minute}");
        datosRegistro.horaInicial = "${picked.hour}:${picked.minute}";
      });
    }
  }

  Future<Null> _showFinalTimeDialog() async {
    final TimeOfDay picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        _finishTime = picked;
        finishTimeController =
        new TextEditingController(text:
        "${picked.hour}:${picked.minute}");
        datosRegistro.horaFinal = "${picked.hour}:${picked.minute}";
      });
    }
  }

}