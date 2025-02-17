# Отчет по лабораторной работе 1

### Автор: Шипилов Дементий, ИП-215

## Результат работы

Разработан *bash-скрипт* с поддержкой *мультипроцессорных* систем, *выводящий общую информацию* о POSIX-совместимой операционной системе.

## Скрипт

Скрипт состоит из пайплайнов, обрабатывающих исходные данные, которые, при этом, состоят из вызовов утилит *GNU*. Результаты работы пайплайнов сохраняются в переменные и  выводятся через стандартный поток вывода командной оболочки в удобном для последующей програмной обработки (парсинга) виде.

## Вывод скрипта

Пример вывода информации, полученной скриптом. Информация представлена в виде пары `ключ: значение` и представляет собой текст вида:

```text
$ bash script.sh
os name              : Debian GNU/Linux
os version           : 10 (buster)
kernel version       : 5.15.0-1050-azure
kernel architecture  : x86_64
cpu model            : Intel(R) Xeon(R) Processor @ 2.50GHz, AMD Ryzen 5 with Radeon Graphics
cpu MHz              : 2499.998, 2095.999
cpu cores            : 2, 6
cpu cache (per core) : 36608 KB, 512 KB
ram size             : 326Mi
used ram             : 50Mi
free ram             : 264Mi
host name            : 52715fbd65de
local ip addresses   : lo: 127.0.0.1/8, docker0: 172.17.0.1/16
mac                  : 02:42:a4:c3:b0:f3
adapter speed        : 10000Mb/s
system mount point   : /
partition size       : 1.5G
memory used          : 9.4M
free memory          : 1.4G
```

> Для проверки работы на мультипроцессорных системах, без доступа к ним, необходимо в скрипте *script.sh* заменить путь к `/proc/cpuinfo` на `cpuinfo_for_multiproc_system`.

## Использованные утилиты в скрипте

| Утилита | Описание                                                          |
| ------- | ----------------------------------------------------------------- |
| uname   | Информация об операционной системе                                |
| free    | Информация об использовании памяти системой                       |
| ip      | Информация о конфигурации сетей и адаптеров                       |
| df      | Информация о смонтированных файловых системах                     |
| grep    | Работа с данными с использованием регулярных выражений            |
| awk     | Обработка данных на основе шаблона                                |
| tr      | Удаление или сжатие символов из данных (аналог string.truncate()) |
| uniq    | Фильтрация уникальных данных                                      |
| sed     | Трансформация и фильтрация данных потока ввода                    |
| curl    | Передача данных с/на удаленный сервер                             |
