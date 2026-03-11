# WeatherApp Flutter 🌤️

Aplicación móvil del clima desarrollada con Flutter como versión mobile de [WeatherApp](https://github.com/manuellopez-dev/WeatherApp). Demuestra la capacidad de llevar el mismo producto a múltiples plataformas.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=flat&logo=dart)
![Android](https://img.shields.io/badge/Android-API%2021+-3DDC84?style=flat&logo=android)
![OpenWeatherMap](https://img.shields.io/badge/API-OpenWeatherMap-orange?style=flat)

---

## Funcionalidades

- 📍 Geolocalización automática al abrir la app
- 🔍 Búsqueda de ciudades en tiempo real
- 🌡️ Clima actual con temperatura, sensación térmica, humedad, viento y presión
- 📅 Pronóstico de 5 días
- 🎨 Fondos dinámicos que cambian según la condición climática
- 🌙 Detección automática de día/noche
- 🔄 Pull to refresh para actualizar el clima

---

## Screenshots

| Clima actual | Pronóstico |
|---|---|
| Fondo dinámico según condición | Pronóstico de 5 días con emojis |

---

## Arquitectura

```
lib/
├── main.dart
├── models/
│   ├── weather_model.dart     # Weather y ForecastDay
│   └── city_model.dart        # City con displayName
├── services/
│   ├── weather_service.dart   # Llamadas a OpenWeatherMap API
│   └── location_service.dart  # GPS con geolocator
├── screens/
│   └── home_screen.dart       # Pantalla principal
├── widgets/
│   ├── weather_card.dart      # Card con clima actual
│   ├── forecast_card.dart     # Card con pronóstico 5 días
│   └── search_bar_widget.dart # Buscador con resultados
└── utils/
    └── weather_utils.dart     # Gradientes, emojis, formateo
```

---

## Instalación

### Prerrequisitos

- Flutter 3.x
- Dart 3.x
- Android SDK
- API Key de [OpenWeatherMap](https://openweathermap.org/api)

### Pasos

```bash
# Clonar el repositorio
git clone https://github.com/manuellopez-dev/WeatherApp-Flutter.git
cd WeatherApp-Flutter

# Crear archivo .env en la raíz
echo "OPENWEATHER_API_KEY=tu_api_key" > .env
echo "OPENWEATHER_BASE_URL=https://api.openweathermap.org" >> .env

# Instalar dependencias
flutter pub get

# Correr en dispositivo conectado
flutter run
```

---

## Variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
OPENWEATHER_API_KEY=tu_api_key_aqui
OPENWEATHER_BASE_URL=https://api.openweathermap.org
```

---

## Dependencias principales

| Paquete | Uso |
|---------|-----|
| `http` | Peticiones HTTP a OpenWeatherMap |
| `geolocator` | Obtener coordenadas GPS |
| `geocoding` | Convertir coordenadas a nombre de ciudad |
| `flutter_dotenv` | Variables de entorno desde `.env` |
| `permission_handler` | Solicitar permisos de ubicación |

---

## Endpoints utilizados

| Endpoint | Descripción |
|----------|-------------|
| `/data/2.5/weather` | Clima actual por coordenadas o ciudad |
| `/data/2.5/forecast` | Pronóstico 5 días cada 3 horas |
| `/geo/1.0/direct` | Búsqueda de ciudades por nombre |

---

## Fondos dinámicos

La app cambia el gradiente de fondo según la condición climática:

| Condición | Colores |
|-----------|---------|
| ☀️ Despejado | Azul cielo → Celeste |
| ⛅ Nublado | Azul → Marino |
| 🌧️ Lluvia | Azul oscuro → Índigo |
| ⛈️ Tormenta | Negro azulado → Morado |
| ❄️ Nieve | Blanco grisáceo → Azul hielo |
| 🌙 Noche | Negro → Morado oscuro |

---

## Relación con WeatherApp Web

Este proyecto es la versión mobile de [WeatherApp](https://github.com/manuellopez-dev/WeatherApp), demostrando que el mismo producto puede construirse en múltiples plataformas con diferentes tecnologías manteniendo la misma experiencia de usuario.

---

## Licencia

Proyecto de portafolio — uso libre para referencia y aprendizaje.
