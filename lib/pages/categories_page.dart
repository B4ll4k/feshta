import 'package:feshta/size_config.dart';
import 'package:feshta/widgets/event_detail_widget.dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../widgets/categories.dart';

class CategoriesPage extends StatefulWidget {
  static const String route = '/categories';

  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _categoryId = '';
  @override
  void initState() {
    _categoryId = Provider.of<EventProvider>(context, listen: false)
        .eventCategories[0]
        .id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Categories',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildCategoriesList(context),
              const SizedBox(
                height: 20,
              ),
              _buildEventWithCategoryGrid(),
            ],
          ),
        ));
  }

  Widget _buildCategoriesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 110,
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: Provider.of<EventProvider>(context, listen: false)
                .eventCategories
                .length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, index) => GestureDetector(
              onTap: () {
                setState(() {
                  _categoryId =
                      Provider.of<EventProvider>(context, listen: false)
                          .eventCategories[index]
                          .id;
                });
              },
              child: CategoriesWidget(
                id: Provider.of<EventProvider>(context, listen: false)
                    .eventCategories[index]
                    .id,
                name: Provider.of<EventProvider>(context, listen: false)
                    .eventCategories[index]
                    .name,
                image: Provider.of<EventProvider>(context, listen: false)
                    .eventCategories[index]
                    .image,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEventWithCategoryGrid() {
    //return GridView.count(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5, children: List<Widget>.generate(Provider.of<EventProvider>(context).events.where((element) => element.categoryIds[0] == _categoryId).length, (index) => null),);
    final events = Provider.of<EventProvider>(context, listen: false)
        .events
        .where((element) => element.categoryIds[0] == _categoryId)
        .toList();
    return events.isEmpty
        ? Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                width: SizeConfig.screenWidth - 30,
                height: SizeConfig.screenHeight / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/error.jpg'),
                  ),
                ),
              ),
              const Text(
                'No Events in this Category!',
                style: TextStyle(fontSize: 18),
              ),
            ],
          )
        : GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            padding: const EdgeInsets.all(5.0),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EventsDetailWidget(id: events[index].id)));
                },
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(events[index].image),
                        fit: BoxFit.cover),
                  ),
                ),
              );
            });
    //return Container();
  }
}
