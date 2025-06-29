import 'package:dio/dio.dart';
import 'package:flutter_caching/features/product/data/models/product_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'product_remote_data_source.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:3000/products")
abstract class ProductRemoteDataSource {
  factory ProductRemoteDataSource(Dio dio) = _ProductRemoteDataSource;

  @GET('')
  Future<List<ProductModel>> fetchProducts();

  @GET('/{id}')
  Future<ProductModel> fetchProductById(@Path("id") int id);

  @POST('')
  Future<void> addProduct(@Body() ProductModel product);

  @PUT('/{id}')
  Future<void> updateProduct(
      @Path("id") int id, @Body() ProductModel product);

  @DELETE('/{id}')
  Future<void> deleteProduct(@Path("id") int id);
}
