import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventFilterPage extends StatefulWidget {
  static const route = '/filterPage';
  EventFilterPage({Key? key}) : super(key: key);

  @override
  State<EventFilterPage> createState() => _EventFilterPageState();
}

class _EventFilterPageState extends State<EventFilterPage> {
  List<bool> _isSelected = [];
  List<int> _isSelectedLocations = [];
  DateTime? _selectedDate;
  List<String> priceList = [
    'ETB 1 - ETB 500',
    'ETB 501 - ETB 1000',
    'ETB 1001 - ETB 1500',
    'ETB 1501 - ETB 2000',
    'ETB 2001 - ETB 2500',
    'ETB > 2500'
  ];
  List<String> locationList = [
    'Bole Medhanialem',
    'Bole',
    'Bisrate Gebriel',
    'Gurd Shola',
    'Kazanchis'
  ];
  int? _selectedLocationIndex;
  int? _selectedPriceIndex;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    int categoriesLength = Provider.of<EventProvider>(context, listen: false)
        .eventCategories
        .length;
    for (var i = 0; i < categoriesLength; i++) {
      setState(() {
        _isSelected.add(false);
      });
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Filter Events',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          Consumer<EventProvider>(
            builder: (context, eventProvider, _) => Container(
              height: 170,
              width: SizeConfig.screenWidth - 20,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 5,
                    mainAxisExtent: 45),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: eventProvider.eventCategories.length,
                itemBuilder: (context, index) => ActionChip(
                  onPressed: () {
                    setState(() {
                      _isSelected[index] = !_isSelected[index];
                      _isSelectedLocations.add(index);
                    });
                  },
                  elevation: 20,
                  padding: const EdgeInsets.all(8),
                  backgroundColor: _isSelected[index]
                      ? Theme.of(context).primaryColor
                      : Colors.blue[50],
                  shadowColor: Colors.white10,
                  avatar: _isSelected[index]
                      ? CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: AssetImage('assets/images/tick.png'),
                        )
                      : null, //CircleAvatar
                  label: Text(
                    eventProvider.eventCategories[index].name,
                    style: TextStyle(
                        fontSize: 15,
                        color: _isSelected[index]
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                  ), //Text
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(fontSize: 17),
                ),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : _selectedDate!.toIso8601String().substring(0, 10),
                    style: const TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ticket Price',
                  style: TextStyle(fontSize: 17),
                ),
                TextButton(
                  onPressed: () {
                    _showPriceList();
                  },
                  child: Text(_selectedPriceIndex == null
                      ? 'Select Ticket Price'
                      : priceList[_selectedPriceIndex!]),
                ),
              ],
            ),
          ),
          const Divider(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 17),
                ),
                TextButton(
                  onPressed: () {
                    _showLocationList();
                  },
                  child: Text(_selectedLocationIndex == null
                      ? 'Select Location'
                      : locationList[_selectedLocationIndex!]),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: 49,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<EventProvider>(context, listen: false).filterEvents(
                    _isSelectedLocations,
                    _selectedDate,
                    _selectedPriceIndex,
                    _selectedLocationIndex == null
                        ? ''
                        : locationList[_selectedLocationIndex!]);
                Navigator.pushNamed(context, '/filteredEventsPage');
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).primaryColor)),
              child: const Text(
                'Filter',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2024),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  void _showPriceList() {
    scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        color: Colors.white,
        height: 200,
        child: SingleChildScrollView(
          physics: const PageScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.red, fontSize: 17),
                  ),
                ),
              ),
              ListView.builder(
                physics: const PageScrollPhysics(),
                itemCount: priceList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  title: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedPriceIndex = index;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      priceList[index],
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.9)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationList() {
    scaffoldKey.currentState!.showBottomSheet(
      (context) => Container(
        color: Colors.white,
        height: 200,
        child: SingleChildScrollView(
          physics: const PageScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.red, fontSize: 17),
                  ),
                ),
              ),
              ListView.builder(
                physics: const PageScrollPhysics(),
                itemCount: locationList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  title: TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedLocationIndex = index;
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      locationList[index],
                      style: TextStyle(
                          fontSize: 20,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.9)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
