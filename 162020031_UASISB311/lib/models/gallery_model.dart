class GalleryModel {
   final String id;
   final String inspection_id;
   final String file_name;
   final String type;

   GalleryModel({
      required this.id,
      required this.inspection_id,
      required this.file_name,
      required this.type
   });

   factory GalleryModel.fromJson(Map<String, dynamic> data) {
      return GalleryModel(
         id: data['_id'],
         inspection_id: data['inspection_id'],
         file_name: data['file_name'],
         type: data['type']
      );
   }
}