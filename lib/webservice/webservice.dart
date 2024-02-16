
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testnura/model/ProdectModel.dart';



class Webservice {
  final imageurl="https://fakestoreapi.com/products";
  final mainurl="https://fakestoreapi.com/products";





 Future<List<ProdectModel >?> fetchProducts()async{
try{
final response=await http.get(Uri.parse(mainurl));
if (response.statusCode==200){
  final parsed =json.decode(response.body).cast<Map<String,dynamic>>();

  return parsed
  .map<ProdectModel >((json)=>ProdectModel .fromJson(json)).toList();
}else{
  throw Exception("Failed load Category");
}
}catch(e){
print(e.toString());
}
  }



}