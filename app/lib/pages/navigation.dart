import 'package:flutter/material.dart';
import 'package:Lino_app/services/book_services.dart';
import 'book_details_page.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookService = BookService();

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: bookService.searchBookboxes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!['bookboxes'] == null) {
            return Center(child: Text('No bookboxes found.'));
          }

          // Extracting bookbox IDs
          final bookBoxes = List<Map<String, dynamic>>.from(
            snapshot.data!['bookboxes'].map((bookbox) => bookbox),
          );

          for (var bb in bookBoxes) {
            print(bb['books'][0]['title']);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                for (var bb in bookBoxes) ...[
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      bb['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bb['books'].length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookDetailsPage(book: bb['books'][index]),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                                bb['books'][index]['coverImage']
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}