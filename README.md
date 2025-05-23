# Система для скачивания и обновления движка MediaWiki, расширений и скинов через git

## Директории

* `core` — директория со скачанным движком MediaWiki.
* `extensions` — директория со скачанными расширениями.
* `skins` — директория со скачанными скинами (темами оформления).
* `installation-files` —  промежуточная директория, в неё во время обновления устанавливаются нужные версии компонентов, конфигурационный файл `LocalSettings.php` и т.д., структура этой директории соответствует структуре настоящей, действующей инсталляции движка.

## Скрипты

### `mediawiki-upgrade`

1. Обновляет *скачанные* версии всех компонентов, прописанных в списках. Если компонент ещё вообще не скачан, скрипт попытается скачать его из соответствующего git-репозитория на [gerrit.mediawiki.org](https://gerrit.mediawiki.org/).
2. Копирует компоненты в *промежуточную директорию*.
3. Туда же копирует конфигурацию (`LocalSettings.php`) из *директории с действующей инсталляцией*, запускает Composer.

### `mediawiki-target-install`

1. Делает бэкап *директории с действующей инсталляцией*.
2. Удаляет из неё всё кроме изображений.
3. Копирует туда содержимое *промежуточной директории*.
4. Выполняет скрипты автообновлений — `maintenance/update.php` и т.д, обновляет кэш локализации.

## Конфигурационные файлы

* `extension-list.txt` — список расширений. На каждой строке может быть указано имя расширения и, опционально, через символ `;`, URL git-репозитория с расширением и название git-ветки. Строки, начинающиеся на `#`, игнорируются.
* `skin-list.txt` — список скинов, аналогично.
* `mediawikirc` — файл, выполняемый перед работой скрипта, в нём рекомендуется задать переменные окружения для конфигурации.

Пример фрагмента списка расширений:

```
DynamicPageList;https://gitlab.com/hydrawiki/extensions/DynamicPageList.git;3.3.3
CheckUser
# Unused:
#Intersection
```

## Конфигурационные переменные окружения

* `CORE_ZIP_URL` — если значение задано, то вместо скачивания движка через git следует скачивать ZIP-архив по указаному URL.
* `CORE_ZIP_DIR` — путь к папке с движком в ZIP-архиве. Если значение `CORE_ZIP_URL` не установлено, то эта переменная необязательна и игнорируется.
* `BRANCH` — название git-ветки, из которой брать версии компонентов, например `REL1_35`.
* `MEDIAWIKI_DIR` — путь к директории с действующей инсталляцией MediaWiki.
* `PHP_EXECUTABLE` — путь к исполняемуму файлу PHP (по умолчанию — просто `php`).
* `COMPOSER_EXECUTABLE` — путь к файлу Composer'а (по умолчанию — `/usr/local/bin/composer`).
* `LOCALISATION_CACHE_LANG` — идентификаторы языков, для которых надо пересобирать кэш локализации.
* `NGINX_LOCATION_CURRENT` — путь к символьной ссылке на текущую конфигурацию nginx.
* `NGINX_LOCATION_MAIN` — имя файла основной конфигурации nginx.
* `NGINX_LOCATION_MAINTENANCE` — имя файла временной конфигурации nginx для техобслуживания.
* `PRESERVED_DIRECTORIES` — список имён директорий, которые нужно сохранить, скопировав из директории с действующей инсталляцией в промежуточную директорию, разделённых пробелом (по умолчанию — одна директория `maintenance_custom`).
* `PRESERVED_FILES` — список имён файлов, которые нужно сохранить, разделённых пробелом (по умолчанию — два файла: `LocalSettings.php` и `do_maintenance`).
* `DONT_PRESERVE_DIRECTORIES` — непустое значение, если директории не нужно сохранять.
* `DONT_PRESERVE_FILES` — непустое значение, если файлы не нужно сохранять.
* `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_DATABASE` — имя пользователя, пароль и имя базы данных MySQL для создания дампа.
* `MYSQL_HOST` — хост MySQL (по умолчанию — `localhost`).
* `FILE_BACKUP_DIRECTORY` — путь к директории с дампами файлов MediaWiki.
* `MYSQL_DUMP_DIRECTORY` — путь к директории с дампами MySQL.
* `DONT_SET_NGINX_LOCATIONS` — непустое значение, если файлы не нужно менять конфигурации nginx с помощью символьных ссылок. Если значение установлено, то переменные `NGINX_LOCATION_CURRENT`, `NGINX_LOCATION_MAIN` и `NGINX_LOCATION_MAINTENANCE` необязательны и игнорируются.
* `DONT_CHOWN_AND_CHMOD` — непустое значение, если не нужно делать `chown` и `chmod` в директории с действующей инсталляцией.
