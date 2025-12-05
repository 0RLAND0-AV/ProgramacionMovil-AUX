# Asistente Virtual con IA - Flutter App

Una aplicación móvil de chatbot inteligente desarrollada con Flutter que utiliza la API de Google Gemini para conversaciones naturales con IA. La aplicación mantiene un historial persistente de conversaciones y permite personalizar los nombres del asistente y del usuario.

## 🌟 Características

- 💬 **Chat en tiempo real** con IA powered by Google Gemini 2.5 Flash
- 📱 **Interfaz moderna** con Material Design 3
- 💾 **Historial persistente** de conversaciones usando SQLite
- 👤 **Personalización**: configura el nombre de tu IA y tu propio nombre
- 🧠 **Contexto inteligente**: mantiene memoria de las últimas conversaciones
- 🗑️ **Gestión de historial**: limpia conversaciones cuando quieras
- 🔒 **Seguridad**: API key almacenada en archivo `.env`

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Flutter SDK** (v3.9.0 o superior)
  - [Guía de instalación de Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (incluido con Flutter)
- **Android Studio** o **VS Code** con extensiones de Flutter/Dart
- **Git** para clonar el repositorio
- **Dispositivo Android/iOS** o emulador configurado
- **API Key de Google Gemini** (gratuita)
  - Obtén tu clave en: [Google AI Studio](https://makersuite.google.com/app/apikey)

### Verificar instalación de Flutter

```bash
flutter doctor
```

Asegúrate de que todos los checks estén en verde ✓

## 🚀 Instalación y Configuración

### 1. Clonar el Repositorio

```bash
git clone https://github.com/0RLAND0-AV/ProgramacionMovil-AUX.git
cd ProgramacionMovil-AUX
git checkout Practica
```

### 2. Crear archivo de configuración `.env`

Crea un archivo `.env` en la raíz del proyecto con tu API key de Gemini:

```bash
# En la raíz del proyecto (ProgramacionMovil-AUX/)
touch .env
```

Edita el archivo `.env` y agrega:

```env
GEMINI_API_KEY=TU_API_KEY_AQUI
```

> ⚠️ **IMPORTANTE**: 
> - Nunca subas tu archivo `.env` al repositorio (ya está en `.gitignore`)
> - Reemplaza `TU_API_KEY_AQUI` con tu API key real de Google Gemini
> - Obtén tu API key gratuita en: https://makersuite.google.com/app/apikey

### 3. Instalar Dependencias

```bash
flutter pub get
```

### 4. Verificar Dispositivos Conectados

```bash
flutter devices
```

Asegúrate de tener al menos un dispositivo disponible (emulador o físico).

### 5. Ejecutar la Aplicación

#### Opción A: Modo Debug (desarrollo)
```bash
flutter run
```

#### Opción B: Modo Release (optimizado)
```bash
flutter run --release
```

#### Opción C: Especificar dispositivo
```bash
# Listar dispositivos
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device-id>
```

## 📦 Dependencias Principales

El proyecto utiliza las siguientes dependencias clave:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0                    # Peticiones HTTP a la API
  sqflite: ^2.2.8                 # Base de datos SQLite local
  path_provider: ^2.0.14          # Acceso a directorios del sistema
  shared_preferences: ^2.1.1      # Almacenamiento de preferencias
  flutter_dotenv: ^5.0.2          # Manejo de variables de entorno
  path: ^1.8.3                    # Utilidades para rutas
  cupertino_icons: ^1.0.8         # Iconos iOS
```

## 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                      # Punto de entrada de la app
├── models/
│   └── chat_message.dart          # Modelo de mensajes
├── screens/
│   └── chatbot_screen.dart        # Pantalla principal del chat
└── services/
    ├── chat_db.dart               # Servicio de base de datos SQLite
    ├── gemini_service.dart        # Servicio de API Gemini
    └── settings_service.dart      # Servicio de configuración
```

### Descripción de Componentes

- **`chat_db.dart`**: Maneja la persistencia de mensajes con SQLite
  - Guarda todo el historial de conversaciones
  - Operaciones: insert, getAllMessages, getLastNMessages, clearMessages

- **`gemini_service.dart`**: Gestiona comunicación con Google Gemini API
  - Envía contexto reciente (últimos 6 mensajes)
  - Personaliza el prompt con nombres de IA y usuario
  - Maneja errores y respuestas

- **`settings_service.dart`**: Almacena preferencias con SharedPreferences
  - Nombre del asistente IA
  - Nombre del usuario

- **`chatbot_screen.dart`**: UI principal del chat
  - Carga historial al iniciar
  - Muestra burbujas de mensajes
  - Diálogo de ajustes
  - Manejo de estados de carga

## 💡 Uso de la Aplicación

### Primera vez

1. **Abre la app** y verás un mensaje de bienvenida de la IA
2. **Configura los nombres**:
   - Toca el ícono de ajustes ⚙️ en el AppBar
   - Ingresa el nombre que deseas para tu IA (ej: "Luna", "Jarvis", "AmigoIA")
   - Ingresa tu nombre
   - Guarda los cambios

3. **Comienza a chatear**:
   - Escribe cualquier mensaje en el campo de texto
   - La IA responderá considerando el contexto de la conversación

### Funciones Disponibles

| Ícono | Función | Descripción |
|-------|---------|-------------|
| ⚙️ | Ajustes | Cambiar nombre de IA y usuario |
| 🗑️ | Limpiar | Borrar todo el historial de conversaciones |
| ✉️ | Enviar | Enviar mensaje al chatbot |

### Pantallas de la aplicacion

![Home Inicial](/resources/screens/home.jpg)

<img src="/resources/screens/home.jpg" alt="Home" width="200" height="100">
<img src="/resources/screens/settings.jpg" alt="Settings" width="200" height="100">
<img src="/resources/screens/chat1.jpg" alt="Chat1" width="200" height="100">
<img src="/resources/screens/chat2.jpg" alt="Chat2" width="200" height="100">
<img src="/resources/screens/chat3.jpg" alt="Chat3" width="200" height="100">


## 🔧 Comandos Útiles de Flutter

```bash
# Limpiar build y caché
flutter clean

# Reinstalar dependencias
flutter pub get

# Actualizar dependencias
flutter pub upgrade

# Verificar problemas
flutter doctor -v

# Ver logs en tiempo real
flutter logs

# Crear APK (Android)
flutter build apk --release

# Crear AppBundle (Android)
flutter build appbundle --release

# Crear IPA (iOS)
flutter build ios --release
```

## 🐛 Solución de Problemas

### Error: "FileNotFoundError" con `.env`

**Causa**: El archivo `.env` no se encuentra o no está declarado como asset.

**Solución**:
1. Verifica que existe el archivo `.env` en la raíz del proyecto
2. Asegúrate de que `pubspec.yaml` incluye:
   ```yaml
   flutter:
     assets:
       - .env
   ```
3. Ejecuta `flutter clean && flutter pub get`

### Error: "API key no encontrada"

**Causa**: La API key no está configurada correctamente.

**Solución**:
1. Verifica que el archivo `.env` existe
2. Asegúrate de que tiene el formato correcto:
   ```
   GEMINI_API_KEY=tu_clave_aqui
   ```
3. Sin espacios ni comillas adicionales

### Error: HTTP 400 con la API

**Causa**: Formato incorrecto del JSON enviado a Gemini.

**Solución**: Ya corregido en la última versión. Si persiste:
1. Ejecuta `git pull origin Practica`
2. Haz hot reload con `r` en la terminal de Flutter

### Error de Base de Datos SQLite

**Causa**: Permisos o caché corrupta.

**Solución**:
```bash
flutter clean
flutter pub get
# Desinstala la app del dispositivo
flutter run
```

## 🔐 Seguridad y Buenas Prácticas

- ✅ El archivo `.env` está en `.gitignore` - **nunca lo subas al repo**
- ✅ No compartas tu API key públicamente
- ⚠️ Para producción, considera usar un backend proxy para ocultar la API key
- ✅ La base de datos SQLite es local y privada del dispositivo

## 🤝 Contribuir

Si deseas contribuir al proyecto:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Mejoras Futuras

- [ ] Export/Import de historial en JSON
- [ ] Resumen automático de conversaciones largas
- [ ] Búsqueda en el historial
- [ ] Temas personalizados (dark/light)
- [ ] Múltiples conversaciones (chats separados)
- [ ] Síntesis de voz
- [ ] Soporte multiidioma

## 📄 Licencia

Este proyecto es de código abierto y está disponible para fines educativos.

## 👨‍💻 Autor

**Orlando** - [@0RLAND0-AV](https://github.com/0RLAND0-AV)

## 🔗 Enlaces Útiles

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Google Gemini API](https://ai.google.dev/)
- [SQLite para Flutter](https://pub.dev/packages/sqflite)
- [Repositorio del Proyecto](https://github.com/0RLAND0-AV/ProgramacionMovil-AUX)

---

**Rama actual**: `Practica`

**Versión**: 1.0.0

**Última actualización**: Diciembre 2025
