import 'package:flutter/material.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:intl/intl.dart';
import 'package:monitor_ia/src/models/my_reservations.dart';
import 'package:monitor_ia/src/providers/b2w_provider.dart';
import 'package:monitor_ia/src/shared_preferences/preferencias_usuario.dart';
import 'package:monitor_ia/src/widgets/separator_dash_line_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

const String path_asset = 'assets/img/profile.jpg';
const String reserva_de = 'Reserva de';
const String label_chekin = 'Check in';
const String label_chekout = 'Check out';
const String label_chekin_erroneo = 'CheckIn erróneo';
const String label_chekin_aun_no_disponible = 'CheckIn aun no disponible';
const String label_checkout_erroneo = 'CheckOut erróneo';

class ReservaInfoDialog extends StatefulWidget {
  final MyReservation myReservation;

  const ReservaInfoDialog(this.myReservation);

  @override
  _ReservaInfoDialogState createState() => _ReservaInfoDialogState();
}

class _ReservaInfoDialogState extends State<ReservaInfoDialog> {
  static const double padding = 20;
  static const double avatarRadius = 45;
  static const double radiusHolesTicket = 15.0;
  static const double borderRadiusTicket = 10.0;

  final prefs = new PreferenciasUsuario();
  final dataProvider = new B2WProvider();

  bool _isLoadingData = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context){
    return Stack(
      children: [
        _ticket(),
        _imagePositioned(),
      ],
    );
  }

  Widget _ticket(){
    DateTime reserva = DateTime.fromMillisecondsSinceEpoch(this.widget.myReservation.startDate);
    DateTime reservaFin = DateTime.fromMillisecondsSinceEpoch(this.widget.myReservation.endDate);
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.only(
            left: padding,
            top: avatarRadius,
            right: padding,
            bottom: padding
        ),
        margin: EdgeInsets.only(top: avatarRadius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ticket(
                innerRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(radiusHolesTicket),
                    bottomRight: Radius.circular(radiusHolesTicket)
                ),
                outerRadius: BorderRadius.all(Radius.circular(borderRadiusTicket)),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.37,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title(),
                        Container(
                          margin: EdgeInsets.only(left: 110, top: 5),
                          child: _bookDataContent(
                              'Reserva de ${this.widget.myReservation.description}'
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                _bookDataTitle(
                                    Icon(
                                        Icons.emoji_transportation,
                                        color: Colors.black,
                                        size: 20
                                    ),
                                    'Sede'
                                ),
                                _bookDataContent(prefs.empresa),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Column(
                                children: [
                                  _bookDataTitle(
                                      Icon(
                                          Icons.my_location_outlined,
                                          color: Colors.black,
                                          size: 20
                                      ),
                                      'Lugar'
                                  ),
                                  _bookDataContent(
                                      this.widget.myReservation.nameAsientoSala
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        _bookDataTitle(
                            Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                                size: 20
                            ),
                            'Fecha'
                        ),
                        _bookDataContent(DateFormat.yMMMMd('es_MX').format(DateTime.fromMillisecondsSinceEpoch(this.widget.myReservation.endDate))),
                        SizedBox(height: 15),
                        _bookDataTitle(
                            Icon(
                                Icons.watch_later_outlined,
                                color: Colors.black,
                                size: 20
                            ),
                            'Hora'
                        ),
                        _bookDataContent('${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(this.widget.myReservation.startDate))} a ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.myReservation.endDate))} hrs.'),
                      ],
                    ),
                  ),
                )
            ),
            Ticket(
                innerRadius: BorderRadius.only(
                    topLeft: Radius.circular(radiusHolesTicket),
                    topRight: Radius.circular(radiusHolesTicket)
                ),
                outerRadius: BorderRadius.all(Radius.circular(borderRadiusTicket)),

                child: Container(
                  height: MediaQuery.of(context).size.height * 0.36,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () async{
                        setState(() {
                          _isLoadingData = true;
                        });
                        if (this.widget.myReservation.status() ==
                            MyReservation.NO_INICIADA) {
                          if(reserva.isBefore(DateTime.now()) && reservaFin.isAfter(DateTime.now())) {
                            String result = await this.widget.myReservation.checkIn();
                            if (result == 'OK') {
                              Navigator.of(context, rootNavigator: false).pop('OK');
                            } else {
                              Navigator.of(context, rootNavigator: false).pop(label_chekin_erroneo);
                            }
                          }
                          else{
                            Navigator.of(context, rootNavigator: false).pop(label_chekin_aun_no_disponible);
                          }
                        } else {
                          String result = await this.widget.myReservation.checkOut();
                          if (result == 'OK') {
                            Navigator.of(context, rootNavigator: false).pop('OK');
                          } else {
                            Navigator.of(context, rootNavigator: false).pop(label_checkout_erroneo);
                          }
                        }
                        _isLoadingData = false;
                      },
                      child: Column(
                        children: [
                          const SeparatorDashLine(color: Colors.black),
                          _qrGenerator(),
                          _isLoadingData
                              ? CircularProgressIndicator()
                              : Align(
                            alignment: Alignment.center,
                            child: Text(this.widget.myReservation.status() == MyReservation.NO_INICIADA
                                ? 'Toca para $label_chekin'
                                : 'Toca para $label_chekout',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w900
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ],
        )
    );
  }

  Container _title() {
    return Container(
      margin: EdgeInsets.only(left: 120, top: 10),
      child: Text(this.widget.myReservation.description,
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _bookDataTitle(Icon icon, String text) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Row(
        children: [
          icon,
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookDataContent(String text) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Text(
        text,
        maxLines: 2,
        style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.normal
        ),
      ),
    );
  }

  Positioned _imagePositioned() {
    return Positioned(
      left: padding + 10,
      top: padding + avatarRadius + padding,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: avatarRadius,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: _imagen()
        ),
      ),
    );
  }

/*  Widget _imagenQR(){
    String pathAsset = 'assets/img/barcode.png';

    return Image.asset(pathAsset,fit: BoxFit.cover);
  }*/

  Widget _imagen(){
    String pathAsset = 'assets/img/desk.jpg';

    if(this.widget.myReservation.description == MyReservation.ESCRITORIO
        || this.widget.myReservation.description == MyReservation.ASIENTO )
      pathAsset = 'assets/img/desk.jpg';
    if(this.widget.myReservation.description == MyReservation.SALA
        || this.widget.myReservation.description == MyReservation.SALA_DE_JUNTAS)
      pathAsset = 'assets/img/sala.jpg';
    if(this.widget.myReservation.nameAsientoSala == MyReservation.COMEDOR)
      pathAsset = 'assets/img/comedor.jpg';
    if(this.widget.myReservation.nameAsientoSala == MyReservation.AREA_FUMAR)
      pathAsset = 'assets/img/area_de_fumar.jpg';

    return Image.asset(pathAsset,fit: BoxFit.cover, height: 100, width: 100);
  }

  Widget _qrGenerator() {
    return QrImage(
      data: jsonData(),
      version: QrVersions.auto,
      size: MediaQuery.of(context).size.height * 0.30,
      foregroundColor: Colors.black,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    );
  }

  String jsonData(){
    String jsonData;
    if(this.widget.myReservation.description == MyReservation.ESCRITORIO){
      jsonData = '{"idSeat": "${this.widget.myReservation.idAsientoSala}","idVenue": 1,"nombreSeat": "${this.widget.myReservation.nameAsientoSala}","idWorkArea": "${this.widget.myReservation.idWaVenue}","nombreWorkArea": "Piso 9","isActive": 1,"name": "C1","catSeatStatus": {"idCatSeatStatus": 1,"color": "Verde","name": "Verde"}}';
    }else{
      jsonData = '{"activeDays": "1,1,1,1,1,0,0","activeHours": "8:00,18:00","activeSeats": 6,"idMeetingRoom": "${this.widget.myReservation.idAsientoSala}","idVenue": 1,"nameVenue": "Global Hitss Corporativo","name": "${this.widget.myReservation.description}","totalSeats": 6}';
    }
    return jsonData;
  }
}
