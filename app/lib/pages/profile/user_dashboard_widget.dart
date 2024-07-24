import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteBooks;
  final List<Map<String, dynamic>> trackedBooks;
  final List<Map<String, dynamic>> booksHistory;

  final String username;
  final double carbonSavings;
  final double savedWater;
  final double savedTrees;
  final int booksBorrowed;
  final int booksGiven;

  const UserDashboard(
      {super.key,
      required this.favoriteBooks,
      required this.trackedBooks,
      required this.booksHistory,
      required this.username,
      required this.carbonSavings,
      required this.savedWater,
      required this.savedTrees,
      this.booksBorrowed = 0,
      this.booksGiven = 0});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        // allows you to build a list of elements that would be scrolled away till the body reached the top
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ProfileCard(
                    username: widget.username,
                    carbonSavings: widget.carbonSavings,
                    savedWater: widget.savedWater,
                    savedTrees: widget.savedTrees,
                    booksBorrowed: widget.booksBorrowed,
                    booksGiven: widget.booksGiven,
                  )
                ],
              ),
            ),
          ];
        },
        // You tab view goes here
        body: Column(
          children: <Widget>[
            TabBar(
              tabs: const [
                Tab(icon: Icon(Icons.favorite)),
                Tab(icon: Icon(Icons.change_circle)),
                Tab(icon: Icon(Icons.history))
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TabView(books: widget.favoriteBooks),
                  TabView(books: widget.trackedBooks),
                  TabView(books: widget.booksHistory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String username;
  final double carbonSavings;
  final double savedWater;
  final double savedTrees;
  final int booksBorrowed;
  final int booksGiven;

  const ProfileCard(
      {super.key,
      required this.username,
      required this.carbonSavings,
      required this.savedWater,
      required this.savedTrees,
      required this.booksBorrowed,
      required this.booksGiven});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 50,
                  // TODO: Add avatar
                  // backgroundImage: NetworkImage(avatar),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        _buildStatColumn('${carbonSavings}kg', 'Carbon Saving'),
                        SizedBox(width: 8),
                        _buildStatColumn('${savedWater}L', 'Saved Water'),
                        SizedBox(width: 8),
                        _buildStatColumn('$savedTrees', 'Saved Trees'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatColumn('$booksBorrowed', 'Books Borrowed'),
                        SizedBox(width: 8),
                        _buildStatColumn('$booksGiven', 'Books Given'),
                      ],
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              username,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Member since xx days ago',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Column _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class TabView extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const TabView({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(child: Text('No books'));
    }
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      children: books.map((book) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: EdgeInsets.only(bottom: 8.0, top: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        book['cover'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(book['title']),
              ],
            ));
      }).toList(),
    );
  }
}
