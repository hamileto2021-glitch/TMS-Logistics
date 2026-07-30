import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/report_summary.dart';

class PdfReportService {

  Future<void> generateExecutiveReport(
      ReportSummary report,
      String period,
      ) async {

    print("STEP 1");

    final pdf = pw.Document();

    print("STEP 2");

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [

          pw.Header(
            level: 0,
            child: pw.Text(
              "TMS Logistics",
              style: pw.TextStyle(
                fontSize: 26,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.Text(
            "Executive Dashboard Report",
            style: const pw.TextStyle(fontSize: 18),
          ),

          pw.SizedBox(height: 8),

          pw.Text("Report Period : $period"),

          pw.Text(
            "Generated : ${DateTime.now()}",
          ),

          pw.Divider(),

          _section(
            "Fleet Summary",
            {
              "Total Vehicles": report.totalVehicles,
              "Available": report.availableVehicles,
              "Busy": report.busyVehicles,
              "Maintenance": report.maintenanceVehicles,
            },
          ),

          _section(
            "Driver Summary",
            {
              "Total Drivers": report.totalDrivers,
              "Available": report.availableDrivers,
              "Assigned": report.assignedDrivers,
            },
          ),

          _section(
            "Shipment Summary",
            {
              "Total Shipments": report.totalShipments,
              "Pending": report.pendingShipments,
              "Delivered": report.deliveredShipments,
            },
          ),

          _section(
            "Dispatch Summary",
            {
              "Total Dispatches": report.totalDispatches,
              "Active Dispatches": report.activeDispatches,
            },
          ),

          _section(
            "Trip Summary",
            {
              "Total Trips": report.totalTrips,
              "Active Trips": report.activeTrips,
              "Completed Trips": report.completedTrips,
            },
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  pw.Widget _section(
      String title,
      Map<String, int> values,
      ) {

    return pw.Column(

      crossAxisAlignment:
      pw.CrossAxisAlignment.start,

      children: [

        pw.SizedBox(height: 15),

        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.Divider(),

        ...values.entries.map(

              (e) => pw.Row(

            mainAxisAlignment:
            pw.MainAxisAlignment.spaceBetween,

            children: [

              pw.Text(e.key),

              pw.Text(
                e.value.toString(),
                style: pw.TextStyle(
                  fontWeight:
                  pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}