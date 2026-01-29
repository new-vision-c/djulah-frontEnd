//
// class QueryFilter {
//   final String? status;
//   final String? pageNumber;
//   final String? pageSize;
//   final DateTime? startDate;
//   final DateTime? endDate;
//   final double? montantMin;
//   final double? montantMax;
//   final String? globalSearch;
//
//
//   const QueryFilter({
//     this.status,
//     this.pageNumber,
//     this.pageSize,
//     this.startDate,
//     this.endDate,
//     this.montantMin,
//     this.montantMax,
//     this.globalSearch,
//   });
//
//   Map<String, dynamic> toJson() {
//     final Map<String, String> filters = {};
//
//     if (status != null) filters['status'] = status!;
//     if (startDate != null) {
//       filters['startDate'] = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(startDate!);
//     }
//     if (endDate != null) {
//       filters['endDate'] = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(endDate!);
//     }
//     if (montantMin != null) filters['montantMin'] = montantMin!.toString();
//     if (montantMax != null) filters['montantMax'] = montantMax!.toString();
//     if (globalSearch != null && globalSearch!.isNotEmpty) filters['globalSearch'] = globalSearch!;
//
//
//     String queryFilter = filters.entries.map((e) => '${e.key}=${e.value}').join('&');
//
//     return {
//       'queryFilter': queryFilter,
//       'pageNumber': pageNumber ?? "0",
//       'pageSize': pageSize ?? "10",
//     };
//   }
//
//   factory QueryFilter.fromMap(Map<String, dynamic> map) {
//     Map<String, String> queryParams = {};
//     if (map['queryFilter'] != null) {
//       List<String> pairs = (map['queryFilter'] as String).split('&');
//       for (var pair in pairs) {
//         List<String> keyValue = pair.split('=');
//         if (keyValue.length == 2) {
//           queryParams[keyValue[0]] = keyValue[1];
//         }
//       }
//     }
//
//     return QueryFilter(
//       status: queryParams['status'],
//       pageNumber: map['pageNumber'] as String?,
//       pageSize: map['pageSize'] as String?,
//       startDate: queryParams['startDate'] != null ? DateTime.parse(queryParams['startDate']!) : null,
//       endDate: queryParams['endDate'] != null ? DateTime.parse(queryParams['endDate']!) : null,
//       montantMin: queryParams['montantMin'] != null ? double.tryParse(queryParams['montantMin']!) : null,
//       montantMax: queryParams['montantMax'] != null ? double.tryParse(queryParams['montantMax']!) : null,
//       globalSearch: queryParams['globalSearch'],
//     );
//   }
// }

