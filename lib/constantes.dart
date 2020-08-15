import 'package:flutter/material.dart';
import 'package:sprintf/sprintf.dart';

class Constantes {

  static final Color colorPrimario = Colors.green;
  static final Color colorBoton = Colors.green;
  static final Color colorTextoBoton = Colors.white;
  static final Color colorSplashBoton = Colors.lightGreenAccent;
  static final Color colorEtiquetaInput = Colors.green;
  static final Color colorBorderInputLogin = Colors.white;

  static final String idEmpresa = "1";
  //Produccion
  /*static String host = "facturas.opuscr.com";
  static String ulrWebService = sprintf("https://%s/ssi/WSCRM/crm.asmx", [host]);*/

  //Pruebas
  static String host = "thanworld";
  static String ulrWebService = sprintf("http://%s/wsCRM/crm.asmx", [host]);

  static String soap = "http://tempuri.org/%s";

  /* Region Login */
  static String loginMethod = "login";
  static String urlSoapLogin = sprintf(soap, [loginMethod]);
  static String envelopeLogin =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <login xmlns=\"http://tempuri.org/\"> <usuario>%s</usuario> <contrasena>%s</contrasena></login></soap:Body></soap:Envelope>";

  /* Region Registros */
  static String listaRegistrosMethod = "getRegistros";
  static String urlSoapListaRegistros = sprintf(soap, [listaRegistrosMethod]);
  static String envelopeListaRegistros =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getRegistros xmlns=\"http://tempuri.org/\"> </getRegistros></soap:Body></soap:Envelope>";

  /* Region Empresas */
  static String listaEmpresasMethod = "getEmpresas";
  static String urlSoapListaEmpresas = sprintf(soap, [listaEmpresasMethod]);
  static String envelopeListaEmpresas =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getEmpresas xmlns=\"http://tempuri.org/\"> </getEmpresas></soap:Body></soap:Envelope>";

  /* Region Provincias */
  static String listaProvinciasMethod = "getProvincias";
  static String urlSoapListaProvincias = sprintf(soap, [listaProvinciasMethod]);
  static String envelopeListaProvincias =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getProvincias xmlns=\"http://tempuri.org/\"> </getProvincias></soap:Body></soap:Envelope>";

  /* Region Cantones */
  static String listaCantonesMethod = "getCantones";
  static String urlSoapListaCantones = sprintf(soap, [listaCantonesMethod]);
  static String envelopeListaCantones =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getCantones xmlns=\"http://tempuri.org/\"> <idProvincia>%s</idProvincia> </getCantones></soap:Body></soap:Envelope>";

  /* Region Distritos */
  static String listaDistritosMethod = "getDistritos";
  static String urlSoapListaDistritos = sprintf(soap, [listaDistritosMethod]);
  static String envelopeListaDistritos =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <getDistritos xmlns=\"http://tempuri.org/\"> <idProvincia>%s</idProvincia> <idCanton>%s</idCanton> </getDistritos></soap:Body></soap:Envelope>";

  /* Region Guarda PT-P05-R01 */
  static String guardaPTP05R01Method = "guardarPTP05R01";
  static String urlSoapGuardaPTP05R01 = sprintf(soap, [guardaPTP05R01Method]);
  static String envelopeGuardaPTP05R01 =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"> <soap:Body> <guardarPTP05R01 xmlns=\"http://tempuri.org/\"> <idregistro>%s</idregistro> <idempresa>%s</idempresa> <fechamuestreo>%s</fechamuestreo> <horainiciomuestreo>%s</horainiciomuestreo> <horafinmuestreo>%s</horafinmuestreo> <idusuariomuestreo>%s</idusuariomuestreo> <idcliente>%s</idcliente> <idprovincia>%s</idprovincia> <idcanton>%s</idcanton> <iddistrito>%s</iddistrito> <funcionarioautempresa>%s</funcionarioautempresa> <descripcionmuestreo>%s</descripcionmuestreo> <idtipomuestreo>%s</idtipomuestreo> <horasvertido>%s</horasvertido> <puntomedicioncaudal>%s</puntomedicioncaudal> <cuerporeceptor>%s</cuerporeceptor> <detallecuerporeceptor>%s</detallecuerporeceptor> <alcantarilladosanitario>%s</alcantarilladosanitario> <detallealcantarilladosanitario>%s</detallealcantarilladosanitario> <reusotipo>%s</reusotipo> <detallereusotipo>%s</detallereusotipo> <volumenrecipiente>%s</volumenrecipiente> <dqo>%s</dqo> <dbo>%s</dbo> <sst>%s</sst> <ssed>%s</ssed> <gya>%s</gya> <ph>%s</ph> <temp>%s</temp> <saam>%s</saam> <color>%s</color> <metp>%s</metp> <fenoles>%s</fenoles> <coliformes>%s</coliformes> <nematodos>%s</nematodos> <plaguicidas>%s</plaguicidas> <otros>%s</otros> <observaciones>%s</observaciones> </guardarPTP05R01></soap:Body></soap:Envelope>";

  /* Etiquetas */
  static String descripcionEmpresa = "Empresa";
  static String prefijoEmpresa = "la";
  /* Fin Etiquetas */


}