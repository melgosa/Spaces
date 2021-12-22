import 'package:flutter/material.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:intl/intl.dart';
import 'package:monitor_ia/src/models/my_reservations.dart';


class ItemReservasProgramadas extends StatefulWidget {
  final MyReservation myReservation;
  final VoidCallback onPressed;

  const ItemReservasProgramadas(this.myReservation, this.onPressed);

  @override
  State<ItemReservasProgramadas> createState() => _ItemReservasProgramadasState();
}

class _ItemReservasProgramadasState extends State<ItemReservasProgramadas> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
      Future.delayed(Duration( milliseconds: 300), () {
        if(mounted){
          setState(() {
            _animate = true;
          });
        }

      });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double radiusHolesTicket = 15.0;

    return GestureDetector(
      onTap: this.widget.onPressed,
      child: AnimatedOpacity(
        duration: _animate ? Duration(milliseconds: 1000) : Duration(milliseconds: 0),
        opacity: _animate ? 1 : 0,
        curve: Curves.easeInOutQuart,
        child: AnimatedPadding(
            duration: _animate ? Duration(milliseconds: 1500) : Duration(milliseconds: 0),
            padding: _animate
                ? const EdgeInsets.only(bottom: 20)
                : const EdgeInsets.only(top: 10),
          child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Ticket(
                    innerRadius: BorderRadius.only(
                        topRight: Radius.circular(radiusHolesTicket),
                        bottomRight: Radius.circular(radiusHolesTicket)
                    ),
                    outerRadius: BorderRadius.all(Radius.circular(10.0)),

                    child: _imagen(),
                  ),
                  Ticket(
                    innerRadius: BorderRadius.only(
                        topLeft: Radius.circular(radiusHolesTicket),
                        bottomLeft: Radius.circular(radiusHolesTicket)
                    ),
                    outerRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      height: 140,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _title(),
                                _iconStatus()
                              ],
                            ),
                            SizedBox(height: 8),
                            _bookDataInfo(
                                Icon(
                                    Icons.my_location_outlined,
                                    color: Colors.black,
                                    size: 20
                                ),
                                this.widget.myReservation.nameAsientoSala
                            ),
                            SizedBox(height: 8),
                            _bookDataInfo(
                                Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.black,
                                    size: 20
                                ),
                                DateFormat.yMMMMd('es_MX').format(DateTime.fromMillisecondsSinceEpoch(this.widget.myReservation.endDate))
                            ),
                            SizedBox(height: 8),
                            _bookDataInfo(
                                Icon(
                                    Icons.watch_later_outlined,
                                    color: Colors.black,
                                    size: 20
                                ),
                                '${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(this.widget.myReservation.startDate))} a ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.myReservation.endDate))} hrs.'
                            ),
                          ],
                        ),
                      ),
                    )
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

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

    return Image.asset(pathAsset,fit: BoxFit.cover, height: 140, width: 130);
  }

  Widget _title(){
    String title = '';
    if(this.widget.myReservation.description == MyReservation.ESCRITORIO
        || this.widget.myReservation.description == MyReservation.ASIENTO )
      title = 'Reserva de Escritorio';
    if(this.widget.myReservation.description == MyReservation.SALA
        || this.widget.myReservation.description == MyReservation.SALA_DE_JUNTAS)
      title = 'Reserva de Sala de juntas';
    if(this.widget.myReservation.nameAsientoSala == 'Comedor')
      title = 'Reserva de Comedor';
    if(this.widget.myReservation.nameAsientoSala == 'Area de fumar')
      title = 'Reserva de área de fumar';
    return Flexible(
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _bookDataInfo(Icon icon, String text){
    return Row(
      children: [
        icon,
        SizedBox(width: 10),
        Flexible(child: Text(text))
      ],
    );
  }

  Widget _iconStatus(){
    Icon iconTemp = Icon(Icons.calendar_today, size: 20, color: Colors.blueAccent);
    if(this.widget.myReservation.status() == MyReservation.EN_PROCESO)
      iconTemp = Icon(Icons.watch_later, size: 20, color: Colors.redAccent);

    return iconTemp;
  }
}
