# Development Route

Type: Documentation, Technical
Author: Leonardo García
Created by: Leonardo García
Created time: July 18, 2025 12:05 PM
Status: Draft

---

### Ajuste de Concepto: Incorporando Hábitos Fuera de Tiempo de Pantalla

**Concepto Vita - MVP Ajustado:**

**Vita: Transforma Hábitos en Recompensas Reales y Medibles.**

Vita es tu plataforma esencial para construir una vida más equilibrada. Te empodera para cultivar hábitos positivos en áreas clave como el **bienestar digital (tiempo de pantalla)** y la **actividad física**. Gana **VitaCoins** por tus esfuerzos y canjéalos por recompensas simples que te impulsan a mejorar día a día, o dona a causas que te importan. Vita es la herramienta directa y motivadora para convertir tu compromiso en valor tangible.

**Core Features (MVP Re-Aterrizado para 3 Semanas):**

1. **Autenticación Ultra-Rápida:**
    - **Registro e inicio de sesión con Google y Apple ID.** (Firebase Auth).
2. **Tracking de Hábitos (Dual Focus):**
    - **Tiempo de Pantalla (Redes Sociales):** Integración con APIs nativas (iOS Screen Time / Android UsageStats) para monitorear el tiempo de uso en apps clave de redes sociales. La meta es la reducción.
    - **Pasos (Actividad Física):** Integración con **Apple HealthKit** y **Google Fit** para leer el conteo de pasos. La meta es alcanzar un objetivo diario (ej. 5,000 o 10,000 pasos).
    - **Registro Manual Simplificado (Back-up):** Para cualquier hábito (o si las integraciones nativas complican), una opción manual sencilla de "marcar como hecho" o "ingresar valor".
3. **Sistema de Recompensas (VitaCoins Directas):**
    - **Cálculo de VitaCoins:** Basado en la consecución de metas de tiempo de pantalla y pasos. Una fórmula simple: `(reducir X mins de pantalla = Y coins)` y `(lograr Z pasos = W coins)`.
    - **Catálogo de Recompensas Inicial (100% Digital/Interno):**
        - **Contenido Educativo Exclusivo:** Acceso a "bits" de conocimiento (artículos, mini-guías, ejercicios de mindfulness) creados por ti o curados de fuentes gratuitas.
        - **Insignias y Logros Digitales:** Medallas virtuales por constancia o hitos.
        - **Donaciones Simplificadas:** El usuario "dona" VitaCoins, y la app muestra el impacto (ej. "Has ayudado a plantar X árboles virtuales"). La monetización real para ONG se maneja fuera de la app por ahora.
4. **Dashboard de Progreso Clave:**
    - Visualización de VitaCoins actuales.
    - Gráficos sencillos del progreso de **tiempo de pantalla** y **pasos**.
    - Metas diarias/semanales de ambos hábitos.
5. **Perfil de Usuario Básico:**
    - Ver VitaCoins, historial de canjes, y estadísticas generales de hábitos.

---

### Arquitectura de la App: Eficiencia y Bajo Costo (Microservicios Simplificados)

Tu idea de microservicios y multi-tenant es excelente para la escalabilidad a largo plazo, pero para un MVP de 3 semanas con presupuesto cero, necesitamos un enfoque más pragmático. Podemos simular algunos beneficios de los microservicios y la arquitectura multi-tenant utilizando Firebase.

La clave aquí es **"Serverless First"** con **Firebase**. Esto te da una infraestructura robusta sin preocuparte por servidores o complejos despliegues, y con un modelo de pago por uso que es casi nulo al principio.

### Arquitectura Propuesta: "Monolito Serverless Inteligente"

En lugar de microservicios completos (que implican despliegues, gestión y comunicaciones entre ellos), vamos a usar **Cloud Functions de Firebase** como si fueran "mini-microservicios" que se encargan de tareas específicas. Y la base de datos será **Firestore**, con un diseño que permita escalabilidad futura.

Fragmento de código

# 

```mermaid
graph TD
    A[Usuario Móvil] -- Flutter --> B(App Móvil: iOS & Android)
    B -- Autenticación --> C(Firebase Authentication)
    B -- Datos de Usuario & Hábitos --> D(Firestore Database)
    B -- Acciones de Usuario (Canje, Cálculo) --> E(Firebase Cloud Functions)
    E -- Escribe/Lee Datos --> D
    E -- Interactúa con APIs Externas (futuro) --> F[Stripe/Donately (Fase 2)]
    E -- Lee datos de APIs Nativas --> G(APIs Nativas: Screen Time / UsageStats / HealthKit / Google Fit)
    G -- Envía datos a --> B
    C -- Sincroniza --> D

    subgraph Backend Serverless
        C
        D
        E
    end

    subgraph Frontend Flutter
        B
        G
    end
```

**Explicación de Componentes:**

1. **Frontend (Flutter):**
    - Interfaz de usuario, lógica de presentación.
    - Maneja la interacción directa con las APIs nativas (Screen Time, UsageStats, HealthKit, Google Fit) para **leer los datos brutos** de los hábitos.
    - Envía estos datos brutos (y otras acciones del usuario) a **Firebase Cloud Functions** o los guarda directamente en **Firestore** (con las reglas de seguridad adecuadas).
    - Patrón de gestión de estado: **Provider** o **GetX** para eficiencia.
2. **Backend (Firebase - "Monolito Serverless"):**
    - **Firebase Authentication:** Gestiona registros, logins, sesiones de usuario. Súper rápido de implementar.
    - **Firestore Database:**
        - **Base de datos NoSQL basada en documentos.** Ideal para almacenar datos de usuario, hábitos diarios, VitaCoins, historial de canjes.
        - **Multi-tenant Simplificado:** Para el MVP, la "multi-tenancy" se logrará mediante la **estructura de datos y las reglas de seguridad de Firestore**. Cada usuario tendrá sus propios documentos y colecciones privadas (`users/{userId}/habits`, `users/{userId}/rewards_history`). Esto asegura que los datos de un usuario no sean visibles para otros y que la aplicación escale de forma inherente a nivel de usuario.
        - **Costo:** Extremadamente bajo para el MVP. Pagas por lecturas/escrituras/eliminaciones y almacenamiento, con un plan gratuito generoso.
    - **Firebase Cloud Functions:**
        - Aquí es donde reside la **lógica de negocio clave** que no debe estar en el cliente (para seguridad y eficiencia).
        - Actúan como tus "microservicios" ligeros. Cada función se encarga de una tarea específica:
            - `calcularVitaCoins`: Se activa cuando se registran nuevos datos de hábitos o periódicamente para calcular las monedas ganadas.
            - `canjearRecompensa`: Valida el canje de una recompensa (saldo de VitaCoins, disponibilidad) y actualiza el historial.
            - `validarHabitoManual`: Si usas registro manual, una función para validarlo.
        - **Costo:** Pagas por invocaciones y tiempo de ejecución. Muy eficiente para el MVP.

### ¿Por qué esta arquitectura es buena para 3 semanas?

- **Velocidad de Desarrollo:** Flutter y Firebase son increíblemente rápidos para desarrollar. No hay infraestructura que configurar o mantener.
- **Costo Mínimo:** El plan gratuito de Firebase cubre la mayoría de tus necesidades iniciales.
- **Escalabilidad Pasiva:** A medida que crezcas, Firebase escala automáticamente.
- **Seguridad:** Firebase Auth y Firestore Rules te permiten implementar seguridad robusta con poco esfuerzo.
- **Simula Microservicios:** Cloud Functions te permiten dividir la lógica sin la complejidad de gestionar múltiples servidores o contenedores. Puedes pensar en cada función como un "servicio" para una tarea específica.

---

### Ruta de Desarrollo Esquemática (¡3 Semanas Intensas!

**Objetivo:** MVP de Vita listo para lanzamiento Beta a finales de agosto (aproximadamente 3 semanas desde hoy, 18 de julio).

### **Fase Única: Construcción y Lanzamiento Rápido (3 Semanas)**

**Semana 1: Cimientos y Tracking Básico**

- **Días 1-2: Setup y Autenticación**
    - Configuración del proyecto Flutter y Firebase (incluyendo Firestore y Auth).
    - Diseño y desarrollo de Splash Screen, Login/Registro con Google y Apple.
    - Definición del modelo de datos de usuario en Firestore.
    - **Prioridad:** Autenticación fluida y funcional.
- **Días 3-5: Tracking de Hábitos - Tiempo de Pantalla y Pasos**
    - **Investigación y desarrollo de integración con APIs nativas (iOS Screen Time / Android UsageStats) para lectura de tiempo de pantalla de apps específicas (redes sociales).** Este es el cuello de botella más probable; asignar recursos dedicados.
    - **Investigación y desarrollo de integración con Apple HealthKit y Google Fit para lectura de pasos.**
    - Lógica para guardar los datos de hábitos diarios en Firestore (`users/{userId}/daily_habits/{date}`).
    - **Prioridad:** Obtener datos fiables de los hábitos desde las APIs nativas.
- **Días 6-7: Dashboard Básico y Almacenamiento de Hábitos**
    - Diseño y desarrollo de la estructura básica del Dashboard: VitaCoins actual, visualización simple del tiempo de pantalla y pasos (datos sin procesar aún).
    - Refinar el almacenamiento de los datos de hábitos en Firestore.

**Semana 2: Lógica Central de Recompensas y UX**

- **Días 8-10: Cálculo de VitaCoins (Cloud Functions)**
    - Desarrollo de las **Cloud Functions** para:
        - Calcular VitaCoins basándose en la **reducción de tiempo de pantalla** (vs. promedio o meta).
        - Calcular VitaCoins basándose en el **logro de pasos** diarios.
        - Estas funciones deben **actualizar el saldo de VitaCoins** del usuario en Firestore.
    - Lógica para establecer metas diarias/semanales (ej. reducir X tiempo, caminar Y pasos).
    - **Prioridad:** Las reglas de negocio para ganar VitaCoins deben ser claras y funcionales.
- **Días 11-12: Catálogo de Recompensas e Historial**
    - Desarrollo del catálogo de recompensas (solo contenido interno: artículos, insignias). Definir los "precios" en VitaCoins.
    - Lógica para canjear VitaCoins por recompensas (restar coins, registrar en historial).
    - Desarrollo de la pantalla de Historial de VitaCoins y recompensas.
    - **Prioridad:** Un sistema de canje funcional y un historial claro.
- **Días 13-14: Perfil de Usuario y Ajustes Mínimos**
    - Pantalla de Perfil: Ver VitaCoins, estadísticas básicas, posibilidad de editar nombre/foto (opcional).
    - Ajustes básicos (ej. definir meta de pasos).

**Semana 3: Refinamiento, Pruebas y Despliegue**

- **Días 15-17: Optimización y Reglas de Seguridad**
    - Revisión general de la UI/UX para fluidez y simplicidad.
    - **Configuración y prueba de Firestore Rules:** Crucial para la seguridad de los datos de usuario. Asegurarse de que cada usuario solo pueda leer/escribir sus propios datos.
    - **Pruebas exhaustivas manuales:** Enfocarse en la autenticación, el tracking de hábitos, el cálculo de coins y el canje. Probar en varios dispositivos iOS y Android.
    - Optimización de consultas a Firestore y Cloud Functions.
- **Días 18-20: Preparación para Despliegue y Beta**
    - Configuración de **GitHub Actions** para un CI/CD simple (build y despliegue a TestFlight/Play Store).
    - Implementación de **Firebase Crashlytics** para monitoreo de errores.
    - Preparación de los assets de la app (íconos, capturas de pantalla, descripción) para las tiendas.
    - **Despliegue a TestFlight (iOS) y Google Play Beta (Android)** para un grupo selecto de testers.
    - **Prioridad:** Una versión estable y funcional lista para ser probada por usuarios reales.

---

### Esquemático para un Orden Correcto del Desarrollo

Para mantener la disciplina y el ritmo, sugiero un enfoque **ágil muy comprimido**:

1. **Definición Clara del MVP (Ya lo hicimos):** Asegúrense de que todo el equipo entiende qué entra y qué no. Cualquier desvío significa retrasos.
2. **Preparación del Entorno:**
    - Configuración de repositorios en GitHub.
    - Acceso al proyecto Firebase para todos los desarrolladores.
    - Herramientas de desarrollo instaladas y funcionando (Flutter SDK, IDEs, emuladores/dispositivos).
3. **Roles y Asignación de Tareas:**
    - **Desarrollador Frontend (Flutter):** Se encarga de toda la UI/UX, integración de paquetes, y la lógica de interacción con las APIs nativas y Firebase.
    - **Desarrollador Backend/Cloud Functions (Node.js/TypeScript):** Se encarga de las Cloud Functions, la configuración de Firestore Rules, y el diseño de la base de datos en Firestore.
    - *Nota: En un equipo de alto rendimiento como el tuyo, es probable que se solapen los roles o que un desarrollador pueda cubrir ambos.*
4. **Desarrollo en Paralelo y Pruebas Continuas:**
    - Mientras uno trabaja en la UI de autenticación, otro puede empezar con la lógica de Cloud Functions para calcular VitaCoins.
    - **Integración diaria:** Fomentar `pull requests` pequeños y frecuentes con revisiones rápidas.
    - **Pruebas desde el día 1:** No esperen al final para probar. Cada componente funcional debe ser probado tan pronto como sea posible.
5. **Comunicación Constante:**
    - **Daily Standups (Cortos y al Punto):** 10-15 minutos cada mañana para discutir: ¿Qué hice ayer? ¿Qué haré hoy? ¿Hay impedimentos?
    - Usar un canal de comunicación (ej. Slack, Discord) para preguntas rápidas.
    - Documentación mínima esencial.
6. **Gestión de Versiones (Git):**
    - Una rama `main` (o `master`) para código listo para despliegue.
    - Ramificación por funcionalidad (`feature/auth`, `feature/screentime_tracking`) para cada tarea, y fusión a `develop` (o directamente a `main` si son solo 3 semanas y muy ágiles) tras revisión.
7. **Despliegue Iterativo:**
    - No esperen las 3 semanas para el primer despliegue. Una vez que la autenticación funciona, desplieguen una versión interna. Esto valida el CI/CD y los permisos.
    - Cada vez que una funcionalidad crítica esté lista, desplieguen una nueva versión interna para el equipo.