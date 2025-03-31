# Тестовое задание на позицию стажера iOS-разработчика

Реализованы все функции, требуемые в ТЗ, включая обработку лайков.

---

**АРХИТЕКТУРА**

Выбор был между **MVC** и **MVVM**, так как проект довольно маленький.
Сделал выбор в пользу **MVVM**, чтобы выделить ответственность за работу с сетью и БД из контроллера.

**Компоненты:**
- **Model**: Отвечает за хранение данных. Включает структуру `Post` и CoreData-сущности (`PostEntity`).
- **View**: Представление реализовано через `UICollectionView` и кастомные ячейки (`PostCell`). Интерфейс создан программно.
- **ViewModel**: Управляет данными и бизнес-логикой. Обеспечивает связь между `View` и `Model`.
- **CoreDataManager**: Отвечает за работу с **CoreData** (сохранение, загрузка и обновление данных).
- **PostsDataFetcher**: Отвечает за загрузку данных с API (используется **Alamofire**).

---

**СКРИНШОТЫ**


<img src="https://github.com/user-attachments/assets/21b1ef85-6233-44fb-bb1b-3a56883119a4" width="200" />

<img src="https://github.com/user-attachments/assets/9662b35e-fa47-478f-a5f8-895ba2e98d80" width="200" />

<img src="https://github.com/user-attachments/assets/76dfc42d-f16b-4ef7-9798-70968b95577a" width="200" />

---

**ИСПОЛЬЗОВАННЫЕ ТЕХНОЛОГИИ**

- **Swift** – Язык программирования для разработки iOS-приложений.
- **UIKit** – Фреймворк для создания пользовательского интерфейса.
- **CoreData** – Локальная база данных для хранения постов и состояния лайков.
- **Alamofire** – Библиотека для выполнения сетевых запросов.
- **MVVM** – Архитектурный паттерн для разделения логики и представления.
- **Network Framework** – Для отслеживания состояния интернет-соединения.
- **Programmatic UI** – Интерфейс создан полностью программно без использования `Storyboards`.

---

**ИНСТРУКЦИЯ ПО СБОРКЕ**

**Требования**
- **macOS** с установленной **Xcode** (версия 14 или выше).
- **Swift 5.7** или выше.

**Шаги для сборки**
1. Клонируйте проект
2. Откройте проект в **Xcode**.
3. Запустите проект, нажав **Run** (`Cmd + R`).
