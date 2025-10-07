.PHONY: help clean format analyze test build-dev build-apk build-aab release version-patch version-minor version-major install run

# Цвета для вывода (работают в Unix терминалах)
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
NC := \033[0m # No Color

help: ## Показать это сообщение помощи
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  HydraCoach - Команды разработки$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(YELLOW)Команды сборки:$(NC)"
	@echo "  $(GREEN)make build-dev$(NC)     - Dev сборка APK (быстрая, без оптимизаций)"
	@echo "  $(GREEN)make build-apk$(NC)     - Release APK для тестирования"
	@echo "  $(GREEN)make build-aab$(NC)     - Release AAB для Google Play"
	@echo "  $(GREEN)make release$(NC)       - Полный релиз (APK + AAB + документация)"
	@echo ""
	@echo "$(YELLOW)Команды разработки:$(NC)"
	@echo "  $(GREEN)make run$(NC)           - Запустить на подключенном устройстве"
	@echo "  $(GREEN)make install$(NC)       - Установить последний APK на устройство"
	@echo "  $(GREEN)make clean$(NC)         - Очистить build кеши"
	@echo "  $(GREEN)make format$(NC)        - Форматировать код"
	@echo "  $(GREEN)make analyze$(NC)       - Статический анализ кода"
	@echo "  $(GREEN)make test$(NC)          - Запустить тесты"
	@echo ""
	@echo "$(YELLOW)Управление версией:$(NC)"
	@echo "  $(GREEN)make version-patch$(NC) - Версия +0.0.1 (2.1.4 → 2.1.5)"
	@echo "  $(GREEN)make version-minor$(NC) - Версия +0.1.0 (2.1.4 → 2.2.0)"
	@echo "  $(GREEN)make version-major$(NC) - Версия +1.0.0 (2.1.4 → 3.0.0)"
	@echo ""

clean: ## Очистка build кешей
	@echo "$(BLUE)🧹 Очистка build кешей...$(NC)"
	@flutter clean
	@cd android && ./gradlew clean && cd ..
	@echo "$(GREEN)✅ Готово!$(NC)"

format: ## Форматирование кода
	@echo "$(BLUE)📐 Форматирование кода...$(NC)"
	@dart format lib/ test/
	@echo "$(GREEN)✅ Готово!$(NC)"

analyze: ## Статический анализ кода
	@echo "$(BLUE)🔬 Статический анализ...$(NC)"
	@flutter analyze
	@echo "$(GREEN)✅ Готово!$(NC)"

test: ## Запуск тестов
	@echo "$(BLUE)🧪 Запуск тестов...$(NC)"
	@flutter test
	@echo "$(GREEN)✅ Готово!$(NC)"

build-dev: ## Dev сборка APK (быстрая)
	@echo "$(BLUE)🔨 Dev сборка APK...$(NC)"
	@flutter build apk --debug
	@echo "$(GREEN)✅ APK готов: build/app/outputs/flutter-apk/app-debug.apk$(NC)"

build-apk: ## Release APK для тестирования
	@echo "$(BLUE)🔨 Release APK...$(NC)"
	@flutter build apk --release
	@echo "$(GREEN)✅ APK готов: build/app/outputs/flutter-apk/app-release.apk$(NC)"

build-aab: ## Release AAB для Google Play
	@echo "$(BLUE)🔨 Release AAB...$(NC)"
	@flutter build appbundle --release
	@echo "$(GREEN)✅ AAB готов: build/app/outputs/bundle/release/app-release.aab$(NC)"

release: ## Полный релиз (APK + AAB + документация)
	@echo "$(BLUE)🚀 Создание полного релиза...$(NC)"
	@bash scripts/release.sh

install: ## Установить последний APK на устройство
	@echo "$(BLUE)📱 Установка APK на устройство...$(NC)"
	@if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then \
		adb install -r build/app/outputs/flutter-apk/app-release.apk; \
	elif [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then \
		adb install -r build/app/outputs/flutter-apk/app-debug.apk; \
	else \
		echo "$(YELLOW)⚠️  APK не найден. Сначала выполните: make build-dev$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✅ Установлено!$(NC)"

run: ## Запустить на подключенном устройстве
	@echo "$(BLUE)🚀 Запуск на устройстве...$(NC)"
	@flutter run

version-patch: ## Обновить patch версию (X.Y.Z+1)
	@echo "$(BLUE)📦 Обновление patch версии...$(NC)"
	@bash scripts/bump_version.sh patch

version-minor: ## Обновить minor версию (X.Y+1.0)
	@echo "$(BLUE)📦 Обновление minor версии...$(NC)"
	@bash scripts/bump_version.sh minor

version-major: ## Обновить major версию (X+1.0.0)
	@echo "$(BLUE)📦 Обновление major версии...$(NC)"
	@bash scripts/bump_version.sh major

# Дополнительные полезные команды

.PHONY: deps deps-upgrade logs stats git-status

deps: ## Установить зависимости
	@echo "$(BLUE)📦 Установка зависимостей...$(NC)"
	@flutter pub get
	@echo "$(GREEN)✅ Готово!$(NC)"

deps-upgrade: ## Обновить зависимости
	@echo "$(BLUE)📦 Обновление зависимостей...$(NC)"
	@flutter pub upgrade
	@echo "$(GREEN)✅ Готово!$(NC)"

logs: ## Показать логи с устройства
	@echo "$(BLUE)📝 Логи устройства (Ctrl+C для остановки):$(NC)"
	@adb logcat -s flutter

stats: ## Статистика проекта
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  📊 Статистика HydraCoach$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(YELLOW)Dart файлы:$(NC) $$(find lib -name '*.dart' | wc -l)"
	@echo "$(YELLOW)Строк кода:$(NC) $$(find lib -name '*.dart' -exec cat {} \; | wc -l)"
	@echo "$(YELLOW)Widgets:$(NC) $$(grep -r "class.*Widget" lib | wc -l)"
	@echo "$(YELLOW)Providers:$(NC) $$(find lib/providers -name '*.dart' 2>/dev/null | wc -l || echo 0)"
	@echo "$(YELLOW)Services:$(NC) $$(find lib/services -name '*.dart' 2>/dev/null | wc -l || echo 0)"
	@echo "$(YELLOW)Models:$(NC) $$(find lib/models -name '*.dart' 2>/dev/null | wc -l || echo 0)"
	@echo ""

git-status: ## Git статус с красивым выводом
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  🔀 Git Status$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════════════$(NC)"
	@echo ""
	@git status -sb

# По умолчанию показываем help
.DEFAULT_GOAL := help
