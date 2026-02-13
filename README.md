# 🎬 Movie Search App

A feature-rich Flutter movie search application built with **Clean Architecture** and **BLoC** state management. Powered by the [OMDB API](https://www.omdbapi.com/).

---

## ✨ Core Features

### 🔍 Movie Search
- Real-time search by movie title
- Grid-based results with poster thumbnails
- Result count display
- Search bar with clear functionality

### 📄 Movie Detail Page
- Full-screen hero poster with gradient overlay
- Genre chips (Action, Drama, Sci-Fi, etc.)
- Ratings row — **IMDB**, **Rotten Tomatoes**, **Metacritic**
- Plot synopsis
- Cast & crew list (Director, Writer, Actors)
- Runtime, release date, and box office info

### ❤️ Favorites System
- Add/remove movies from favorites with a heart icon
- Persistent local storage using SharedPreferences
- Dedicated Favorites tab with grid view
- Empty state with guidance text

### 🎨 Polished UI & UX
- Custom dark-accented theme with curated color palette
- Rounded card designs with subtle shadows
- Loading indicators on every async operation
- Error states with retry buttons
- Empty states with helpful messaging
- Smooth page transitions

---

## 🚀 Additional Features

### 🔥 Netflix-Style Trending Carousel
- Auto-scrolling horizontal carousel on the home screen
- Peek-next-card effect using `PageView` with `viewportFraction`
- Gradient overlays with movie title, year, and genre
- IMDB rating badges on each card
- Dot indicators for current position
- Manual swipe support with auto-scroll reset
- 15 curated blockbuster movies

### 🎭 Genre Sections
- Horizontally scrollable movie rows by genre
- **Horror** — The Conjuring, Alien, Psycho, Hereditary, The Exorcist, Get Out & more
- **Sci-Fi** — Blade Runner, The Martian, Back to the Future, Arrival, Terminator 2 & more
- **Action** — Inglourious Basterds, Guardians of the Galaxy, Batman Begins, Mad Max & more
- IMDB rating badges on poster cards
- Tap any movie to view full details

---

## 🏗️ Architecture

```
lib/
├── core/
│   ├── constants/       # API config & curated movie IDs
│   ├── error/           # Custom exceptions & failures
│   ├── models/          # Shared models (GenreSection)
│   ├── theme/           # App-wide theme & colors
│   └── widgets/         # Reusable widgets (MovieCard, SearchInput, TrendingCarousel, GenreMovieRow)
├── features/
│   └── movies/
│       ├── data/
│       │   ├── datasources/   # Remote (OMDB API) & Local (SharedPreferences)
│       │   ├── models/        # JSON serialization models
│       │   └── repositories/  # Repository implementations
│       ├── domain/
│       │   ├── entities/      # Movie, MovieDetail
│       │   ├── repositories/  # Abstract repository contracts
│       │   └── usecases/      # SearchMovies, GetMovieDetail, GetTrendingMovies
│       └── presentation/
│           ├── bloc/          # BLoCs for Search, Detail, Favorites, Trending, GenreSections
│           └── pages/         # HomePage, SearchResultsPage, MovieDetailPage, FavoritesPage
├── injection_container.dart   # GetIt dependency injection
└── main.dart                  # App entry point
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter |
| **State Management** | flutter_bloc |
| **HTTP Client** | Dio |
| **Dependency Injection** | get_it |
| **Image Caching** | cached_network_image |
| **Local Storage** | shared_preferences |
| **API** | OMDB API |

---

## 🚀 Getting Started

```bash
# Clone the repo
git clone https://github.com/Sajjad-26/movie-search-app.git
cd movie-search-app

# Install dependencies
flutter pub get

# Run the app
flutter run

# Build release APK
flutter build apk --release
```

---

## 📝 License

This project is for educational and internship purposes.
