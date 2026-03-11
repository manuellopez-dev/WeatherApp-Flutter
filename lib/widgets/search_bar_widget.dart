import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../services/weather_service.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(City) onCitySelected;

  const SearchBarWidget({super.key, required this.onCitySelected});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _controller = TextEditingController();
  final _weatherService = WeatherService();
  List<City> _results = [];
  bool _loading = false;

  Future<void> _search(String query) async {
    if (query.length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    try {
      final results = await _weatherService.searchCities(query);
      setState(() => _results = results);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: TextField(
            controller: _controller,
            onChanged: _search,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Buscar ciudad...',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              suffixIcon: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white54),
                      ),
                    )
                  : _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _results = []);
                          },
                        )
                      : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        // Resultados
        if (_results.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.08), height: 1),
              itemBuilder: (context, i) {
                final city = _results[i];
                return ListTile(
                  leading: const Icon(Icons.location_city, color: Colors.white54, size: 18),
                  title: Text(city.displayName, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  onTap: () {
                    widget.onCitySelected(city);
                    _controller.clear();
                    setState(() => _results = []);
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}