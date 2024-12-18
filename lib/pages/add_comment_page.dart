import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp1_flutter/models/post.dart' as models;
import 'package:tp1_flutter/providers/post_provider.dart';
import 'package:tp1_flutter/providers/user_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tp1_flutter/services/location_service.dart';
import 'package:tp1_flutter/services/weather_service.dart';

class AddCommentPage extends StatelessWidget {
  final models.Post post;
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  AddCommentPage({required this.post});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    TextEditingController commentController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    ValueNotifier<String?> imageUrlNotifier = ValueNotifier<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Répondre'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 50.0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'En réponse à ${post.owner.username}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(post.content ?? ''),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const Divider(color: Colors.grey, height: 10, thickness: 1, indent: 0, endIndent: 0,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre commentaire',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: imageUrlNotifier,
              builder: (context, imageUrl, child) {
                return imageUrl != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 120,
                              height: 60,
                              alignment: Alignment.centerLeft,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                imageUrlNotifier.value = null;
                              },
                            ),
                          ],
                        ),
                      )
                    : Container();
              },
            ),
            const Divider(color: Colors.grey, height: 0, thickness: 1, indent: 0, endIndent: 0,),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: const Text(
                          'Ajouter une URL d\'image',
                          style: TextStyle(color: Colors.black),
                        ),
                        content: TextField(
                          controller: imageController,
                          decoration: const InputDecoration(
                            hintText: 'Entrez l\'URL de l\'image',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Annuler',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              imageUrlNotifier.value = imageController.text;
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Ajouter',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, child) {
                  return isLoading
                      ? const CircularProgressIndicator()
                      : IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            if (commentController.text.isNotEmpty) {
                              _isLoading.value = true;
                              try {
                                Position position = await _locationService.getCurrentLocation();
                                String city = await _locationService.getCityFromCoordinates(position);
                                Map<String, dynamic> weatherData = await _weatherService.fetchWeatherData(city);
                                double temperature = weatherData['main']['temp'] - 273.15;

                                postProvider.addComment(
                                  post,
                                  models.Post(
                                    owner: currentUser!,
                                    content: commentController.text,
                                    image: imageController.text.isNotEmpty ? imageController.text : null,
                                    location: city,
                                    weather: '${temperature.toStringAsFixed(2)}°C',
                                  ),
                                );
                                Navigator.of(context).pop();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Impossible de récupérer la météo. RIP'),
                                  ),
                                );
                              } finally {
                                _isLoading.value = false;
                              }
                            }
                          },
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}