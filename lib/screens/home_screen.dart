import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../models/city_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../utils/weather_utils.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService  = WeatherService();
  final _locationService = LocationService();

  Weather?          _weather;
  List<ForecastDay> _forecast = [];
  bool              _loading  = false;
  String?           _error;
  bool              _showSearch = false;

  @override
  void initState() {
    super.initState();
    _loadByLocation();
  }

  Future<void> _loadByLocation() async {
    setState(() { _loading = true; _error = null; });
    try {
      final Position? pos = await _locationService.getCurrentLocation();
      if (pos != null) {
        await _loadWeather(pos.latitude, pos.longitude);
      } else {
        await _loadWeather(20.5234, -100.8147);
      }
    } catch (e) {
      setState(() => _error = 'No se pudo obtener el clima');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadWeather(double lat, double lon) async {
    final weather  = await _weatherService.getCurrentWeatherByCoords(lat, lon);
    final forecast = await _weatherService.getForecast(lat, lon);
    setState(() {
      _weather  = weather;
      _forecast = forecast;
    });
  }

  Future<void> _onCitySelected(City city) async {
    setState(() { _loading = true; _showSearch = false; _error = null; });
    try {
      await _loadWeather(city.lat, city.lon);
    } catch (e) {
      setState(() => _error = 'No se pudo obtener el clima');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _weather != null
        ? WeatherUtils.getBackgroundGradient(_weather!.main, _weather!.date)
        : [const Color(0xFF1a1a2e), const Color(0xFF16213e)];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
        ),
        child: Stack(
          children: [
            // Círculos decorativos de fondo
            Positioned(
              top: -80, right: -80,
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: 100, left: -60,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),

            // Contenido
            SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadByLocation,
                color: Colors.white,
                backgroundColor: Colors.black45,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildTopBar()),
                    if (_showSearch)
                      SliverToBoxAdapter(child: _buildSearchPanel()),
                    if (_loading)
                      const SliverFillRemaining(child: _LoadingView())
                    else if (_error != null)
                      SliverFillRemaining(child: _ErrorView(error: _error!, onRetry: _loadByLocation))
                    else if (_weather != null)
                      SliverToBoxAdapter(child: _buildContent()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WeatherApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                _getGreeting(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _TopBarButton(
                icon: _showSearch ? Icons.close : Icons.search,
                onTap: () => setState(() => _showSearch = !_showSearch),
              ),
              const SizedBox(width: 8),
              _TopBarButton(
                icon: Icons.my_location,
                onTap: _loadByLocation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días ☀️';
    if (hour < 18) return 'Buenas tardes 🌤️';
    return 'Buenas noches 🌙';
  }

  Widget _buildSearchPanel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SearchBarWidget(onCitySelected: _onCitySelected),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        WeatherCard(weather: _weather!),
        const SizedBox(height: 8),
        if (_forecast.isNotEmpty)
          ForecastCard(forecast: _forecast),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text('Obteniendo clima...', style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😕', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(error, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}