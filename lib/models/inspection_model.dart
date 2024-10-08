class InspectionModel {
   final String id;
   final String area;
   final String date_inspection;
   final String time_inspection;
   final String notes_inspection;
   final String user_id_inspection;
   final String user_name_inspection;
   final String date_fix;
   final String time_fix;
   final String notes_fix;
   final String user_id_fix;
   final String user_name_fix;
   final String status;

   InspectionModel({
      required this.id,
      required this.area,
      required this.date_inspection,
      required this.time_inspection,
      required this.notes_inspection,
      required this.user_id_inspection,
      required this.user_name_inspection,
      required this.date_fix,
      required this.time_fix,
      required this.notes_fix,
      required this.user_id_fix,
      required this.user_name_fix,
      required this.status
   });

   factory InspectionModel.fromJson(Map<String, dynamic> data) {
      return InspectionModel(
         id: data['_id'],
         area: data['area'],
         date_inspection: data['date_inspection'],
         time_inspection: data['time_inspection'],
         notes_inspection: data['notes_inspection'],
         user_id_inspection: data['user_id_inspection'],
         user_name_inspection: data['user_name_inspection'],
         date_fix: data['date_fix'],
         time_fix: data['time_fix'],
         notes_fix: data['notes_fix'],
         user_id_fix: data['user_id_fix'],
         user_name_fix: data['user_name_fix'],
         status: data['status']
      );
   }
}