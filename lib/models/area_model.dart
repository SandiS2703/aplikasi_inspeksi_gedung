class AreaModel {
   final String id;
   final String area;

   AreaModel({
      required this.id,
      required this.area
   });

   factory AreaModel.fromJson(Map<String, dynamic> data) {
      return AreaModel(
         id: data['_id'],
         area: data['area']
      );
   }
}