import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/book_services.dart';
import '../../services/user_services.dart';
import '../../utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestsSection extends StatefulWidget {
  const RequestsSection({super.key});

  @override
  RequestsSectionState createState() => RequestsSectionState();
}

class RequestsSectionState extends State<RequestsSection> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;
  String? currentUsername;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    fetchRequests();
  }

  Future<void> fetchCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      var us = UserService();
      final user = await us.getUser(token);
      setState(() {
        currentUsername = user['user']['username'];
      });
    }
  }

  Future<void> fetchRequests() async {
    try {
      var bs = BookService();
      final List<dynamic> requestList = await bs.getBookRequests();
      setState(() {
        requests = requestList.cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching requests: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LinoColors.primary,
      child: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final requestUsername = request['username'];
              final isOwner = requestUsername == currentUsername;
              return Card(
                color: Color(0xFFFFD6AB), // Set the background color of the card
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Add margin between cards
                child: ListTile(
                  title: Text(request['bookTitle'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: request['customMessage'] != null ? Text(request['customMessage']) : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (request['isFulfilled']) Icon(Icons.check_circle, color: Colors.green),
                      if (isOwner)
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final token = prefs.getString('token');
                            if (token != null) {
                              try {
                                var bs = BookService();
                                await bs.deleteBookRequest(token, request['_id']);
                                setState(() {
                                  requests.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Request deleted successfully!')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: ${e.toString()}')),
                                );
                              }
                            }
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
