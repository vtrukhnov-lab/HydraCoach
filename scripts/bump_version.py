#!/usr/bin/env python3
"""
Автоматическое обновление версии HydraCoach в ТРЕХ местах

Использование:
  python scripts/bump_version.py patch      # 2.1.4 -> 2.1.5
  python scripts/bump_version.py minor      # 2.1.4 -> 2.2.0
  python scripts/bump_version.py major      # 2.1.4 -> 3.0.0
  python scripts/bump_version.py 2.1.5      # Явно указать версию
  python scripts/bump_version.py --validate # Только проверка синхронности

Обновляет:
  1. pubspec.yaml - version: X.X.X+YY
  2. android/app/build.gradle.kts - versionCode/versionName
  3. lib/main.dart - app_version в analytics
"""
import re
import sys
from pathlib import Path
from typing import Tuple


class Colors:
    """ANSI color codes для красивого вывода"""
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    BOLD = '\033[1m'
    END = '\033[0m'


class VersionBumper:
    def __init__(self, root_dir: str = '.'):
        self.root = Path(root_dir)
        self.pubspec = self.root / "pubspec.yaml"
        self.gradle = self.root / "android" / "app" / "build.gradle.kts"
        self.main_dart = self.root / "lib" / "main.dart"

        # Проверка существования файлов
        if not self.pubspec.exists():
            raise FileNotFoundError(f"Не найден файл: {self.pubspec}")
        if not self.gradle.exists():
            raise FileNotFoundError(f"Не найден файл: {self.gradle}")
        if not self.main_dart.exists():
            raise FileNotFoundError(f"Не найден файл: {self.main_dart}")

    def get_current_version(self) -> Tuple[str, int]:
        """Читает текущую версию из pubspec.yaml"""
        content = self.pubspec.read_text(encoding='utf-8')
        match = re.search(r'version:\s*(\d+\.\d+\.\d+)\+(\d+)', content)
        if not match:
            raise ValueError("Не найдена версия в pubspec.yaml (ожидается формат: version: X.Y.Z+BUILD)")
        return match.group(1), int(match.group(2))

    def bump_version(self, bump_type: str) -> Tuple[str, int]:
        """Инкрементирует версию согласно semantic versioning"""
        version, build = self.get_current_version()
        major, minor, patch = map(int, version.split('.'))

        if bump_type == 'major':
            major += 1
            minor = 0
            patch = 0
        elif bump_type == 'minor':
            minor += 1
            patch = 0
        elif bump_type == 'patch':
            patch += 1
        else:
            # Явно указана версия (например "2.1.5")
            try:
                parts = bump_type.split('.')
                if len(parts) != 3:
                    raise ValueError()
                major, minor, patch = map(int, parts)
            except (ValueError, AttributeError):
                raise ValueError(f"Неверный формат версии: {bump_type}. Ожидается X.Y.Z или patch/minor/major")

        new_version = f"{major}.{minor}.{patch}"
        new_build = build + 1
        return new_version, new_build

    def update_pubspec(self, version: str, build: int) -> None:
        """Обновляет pubspec.yaml"""
        content = self.pubspec.read_text(encoding='utf-8')
        old_version_line = re.search(r'version:.*', content).group(0)

        new_content = re.sub(
            r'version:\s*\d+\.\d+\.\d+\+\d+',
            f'version: {version}+{build}',
            content
        )

        if content == new_content:
            print(f"{Colors.YELLOW}⚠️  pubspec.yaml не изменен{Colors.END}")
            return

        self.pubspec.write_text(new_content, encoding='utf-8')
        print(f"{Colors.GREEN}✅ pubspec.yaml:{Colors.END} version: {version}+{build}")

    def update_gradle(self, version: str, build: int) -> None:
        """Обновляет android/app/build.gradle.kts"""
        content = self.gradle.read_text(encoding='utf-8')

        # Обновляем versionCode
        content = re.sub(
            r'versionCode\s*=\s*\d+',
            f'versionCode = {build}',
            content
        )

        # Обновляем versionName
        content = re.sub(
            r'versionName\s*=\s*"[\d.]+"',
            f'versionName = "{version}"',
            content
        )

        self.gradle.write_text(content, encoding='utf-8')
        print(f"{Colors.GREEN}✅ build.gradle.kts:{Colors.END} versionCode={build}, versionName=\"{version}\"")

    def update_main_dart(self, version: str) -> None:
        """Обновляет lib/main.dart (app_version в analytics)"""
        content = self.main_dart.read_text(encoding='utf-8')

        # Ищем 'app_version': 'X.X.X',
        content = re.sub(
            r"'app_version':\s*'[\d.]+'",
            f"'app_version': '{version}'",
            content
        )

        self.main_dart.write_text(content, encoding='utf-8')
        print(f"{Colors.GREEN}✅ lib/main.dart:{Colors.END} app_version: '{version}'")

    def validate_sync(self) -> bool:
        """Проверяет что версии синхронизированы во всех файлах"""
        print(f"\n{Colors.BLUE}🔍 Проверка синхронности версий...{Colors.END}\n")

        # 1. Читаем pubspec.yaml
        pubspec_content = self.pubspec.read_text(encoding='utf-8')
        pubspec_match = re.search(r'version:\s*(\d+\.\d+\.\d+)\+(\d+)', pubspec_content)
        if not pubspec_match:
            print(f"{Colors.RED}❌ Не найдена версия в pubspec.yaml{Colors.END}")
            return False
        pubspec_ver = pubspec_match.group(1)
        pubspec_build = int(pubspec_match.group(2))

        # 2. Читаем build.gradle.kts
        gradle_content = self.gradle.read_text(encoding='utf-8')
        gradle_ver_match = re.search(r'versionName\s*=\s*"([\d.]+)"', gradle_content)
        gradle_build_match = re.search(r'versionCode\s*=\s*(\d+)', gradle_content)

        if not gradle_ver_match or not gradle_build_match:
            print(f"{Colors.RED}❌ Не найдена версия в build.gradle.kts{Colors.END}")
            return False

        gradle_ver = gradle_ver_match.group(1)
        gradle_build = int(gradle_build_match.group(1))

        # 3. Читаем main.dart
        main_content = self.main_dart.read_text(encoding='utf-8')
        main_ver_match = re.search(r"'app_version':\s*'([\d.]+)'", main_content)

        if not main_ver_match:
            print(f"{Colors.RED}❌ Не найдена app_version в lib/main.dart{Colors.END}")
            return False

        main_ver = main_ver_match.group(1)

        # 4. Проверяем соответствие
        errors = []

        print(f"📄 pubspec.yaml:        {pubspec_ver}+{pubspec_build}")
        print(f"🤖 build.gradle.kts:   {gradle_ver} (build {gradle_build})")
        print(f"🎯 lib/main.dart:       {main_ver}")
        print()

        if pubspec_ver != gradle_ver:
            errors.append(f"Версия не совпадает: pubspec ({pubspec_ver}) != gradle ({gradle_ver})")

        if pubspec_ver != main_ver:
            errors.append(f"Версия не совпадает: pubspec ({pubspec_ver}) != main.dart ({main_ver})")

        if pubspec_build != gradle_build:
            errors.append(f"Build number не совпадает: pubspec ({pubspec_build}) != gradle ({gradle_build})")

        if errors:
            for error in errors:
                print(f"{Colors.RED}❌ {error}{Colors.END}")
            return False

        print(f"{Colors.GREEN}✅ Все версии синхронизированы: {pubspec_ver}+{pubspec_build}{Colors.END}")
        return True


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    try:
        bumper = VersionBumper()

        # Режим валидации
        if sys.argv[1] == '--validate':
            success = bumper.validate_sync()
            sys.exit(0 if success else 1)

        # Получаем текущую версию
        old_version, old_build = bumper.get_current_version()

        print(f"\n{Colors.BOLD}📦 HydraCoach Version Bumper{Colors.END}")
        print(f"{Colors.BLUE}═{'═' * 50}{Colors.END}\n")
        print(f"Текущая версия: {Colors.YELLOW}{old_version}+{old_build}{Colors.END}")

        # Вычисляем новую версию
        bump_type = sys.argv[1]
        new_version, new_build = bumper.bump_version(bump_type)

        print(f"Новая версия:   {Colors.GREEN}{Colors.BOLD}{new_version}+{new_build}{Colors.END}\n")
        print(f"{Colors.BLUE}═{'═' * 50}{Colors.END}\n")

        # Обновляем файлы
        bumper.update_pubspec(new_version, new_build)
        bumper.update_gradle(new_version, new_build)
        bumper.update_main_dart(new_version)

        # Валидация после обновления
        print(f"\n{Colors.BLUE}═{'═' * 50}{Colors.END}")
        if bumper.validate_sync():
            print(f"\n{Colors.GREEN}{Colors.BOLD}🎉 Версия успешно обновлена до {new_version}+{new_build}!{Colors.END}")
            print(f"\n{Colors.YELLOW}💡 Следующие шаги:{Colors.END}")
            print(f"   1. Проверьте изменения: git diff")
            print(f"   2. Закоммитьте: git commit -am \"chore: Bump version to {new_version}\"")
            print(f"   3. Создайте тег: git tag v{new_version}")
            sys.exit(0)
        else:
            print(f"\n{Colors.RED}⚠️  Обнаружены несоответствия! Проверьте файлы вручную.{Colors.END}")
            sys.exit(1)

    except Exception as e:
        print(f"\n{Colors.RED}❌ Ошибка: {e}{Colors.END}")
        sys.exit(1)


if __name__ == '__main__':
    main()
