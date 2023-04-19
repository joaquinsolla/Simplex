import 'package:simplex/common/all_common.dart';

import '../report.dart';

class ReportsStat {
  final String status;
  final int quantity;

  ReportsStat({
    required this.status,
    required this.quantity,
  });

}

class ReportHistory {
  final int year;
  int quantity;

  ReportHistory({
    required this.year,
    required this.quantity,
  });

}

List<ReportHistory> getReportHistoryItems(List<Report> reports) {
  List<ReportHistory> reportHistoryList = [];

  for (int i=2021; i<=yearToInt(DateTime.now()); i++){
    reportHistoryList.add(ReportHistory(year: i, quantity: 0));
  }

  for (Report report in reports) {
    int year = yearToInt(report.date);

    for (ReportHistory reportHistory in reportHistoryList){
      if (year == reportHistory.year) reportHistory.quantity = reportHistory.quantity+1;
    }
  }

  return reportHistoryList;
}
