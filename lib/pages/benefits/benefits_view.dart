import 'dart:convert';
import 'package:fluffychat/pages/benefits/qr_code_image.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BenefitsView extends StatefulWidget {
  @override
  _BenefitsViewState createState() => _BenefitsViewState();
}

class _BenefitsViewState extends State<BenefitsView> {
  List<Map<String, dynamic>> benefits = [];

  @override
  void initState() {
    super.initState();
    fetchBenefits();
  }

  Future<void> fetchBenefits() async {
    final apiKey = dotenv.env['WEPOC_API_KEY'];
    final apiUrl = dotenv.env['WEPOC_API_URL'];
    final url = Uri.parse('$apiUrl/api/benefits?populate=*');

    print('fetching $url');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    print('response $response, ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print(data);

      setState(() {
        benefits = (data['data'] as List).map((item) {
          print('item $item');
          return {
            'title': item['Title'] ?? 'No title',
            'description': item['Description'] ?? 'No description',
            'link': item['link'] ?? '',
          };
        }).toList();

        print(benefits);
      });
    } else {
      print('Failed to fetch benefits: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Matrix.of(context).client.userID ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription Benefits'),
        leading: Center(
          child: CloseButton(
            onPressed: () {
              context.push('/rooms');
            },
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exclusive Benefits',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: benefits.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: benefits.length,
                      itemBuilder: (context, index) {
                        final benefit = benefits[index];
                        return GestureDetector(
                          onTap: () async {
                            final link = benefit['link'] ?? '';

                            print('benefit $benefit');
                            if (link == '' || userId == '') return;

                            await showDialog(
                              context: context,
                              builder: (_) => QRCodeImage(
                                userId: userId,
                                link: link,
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.star,
                                  color: Theme.of(context).colorScheme.primary),
                              title: Text(
                                benefit['title']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              subtitle: Text(benefit['description']!),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
