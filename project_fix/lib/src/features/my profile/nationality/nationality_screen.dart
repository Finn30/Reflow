import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class NationalityScreen extends StatefulWidget {
  @override
  _NationalityScreenState createState() => _NationalityScreenState();
}

class _NationalityScreenState extends State<NationalityScreen> {
  Country? selectedCountry;
  TextEditingController searchController = TextEditingController();
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    allCountries = CountryService().getAll();
    filteredCountries = allCountries;
  }

  void _filterCountries(String query) {
    setState(() {
      filteredCountries = allCountries
          .where((country) =>
              country.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.search, color: Colors.black54),
              ),
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search Country",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  style: TextStyle(color: Colors.black87),
                  onChanged: _filterCountries,
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.separated(
        itemCount: filteredCountries.length,
        separatorBuilder: (context, index) => Divider(height: 0, thickness: 1),
        itemBuilder: (context, index) {
          final country = filteredCountries[index];
          return ListTile(
            leading: Text(country.flagEmoji, style: TextStyle(fontSize: 20)),
            title: Row(
              children: [
                Expanded(
                    child: Text(country.name, style: TextStyle(fontSize: 14))),
                Text("+${country.phoneCode}", style: TextStyle(fontSize: 14)),
              ],
            ),
            onTap: () {
              setState(() {
                selectedCountry = country;
              });
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          );
        },
      ),
    );
  }
}
