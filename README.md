# Actions для 1C на базе oscript CI/CD

[![Тестирование](https://github.com/Diversus23/actions1c/actions/workflows/testing.yml/badge.svg)](https://github.com/Diversus23/actions1c/actions/workflows/testing.yml)

## Что это такое и где будет полезно?

**Actions 1С** - это программная среда своеобразный аналог Github Actions для DevOps задач, в том числе CI/CD для платформы 1С. Так же прекрасно подойдет для использования в Gitlab Pipelines. Собственно и родилась эта разработка именно благодаря необходимости выполнять самые разные команды для сборки / тестирования / доставки конфигурации [Управление IT-отделом 8](https://softonit.ru/catalog/products/it/).

Система построена на базе [oscript](https://oscript.io) и представляет из себя пакет для oscript.

## Как работает?

Это программная среда, которая умеет кратко с параметрами из командной строки или сохраненными в файле выполнять различные операции в ОС. Ситаксис:

```bash
oscript src/actions.os Команда --Опция1 ЗначениеОпции1 --Опция2 ЗначениеОпции2
```

Где Команда может быть любой из доступных (работа с конфигурациями 1С, с сервером 1С, с обновлением и проверкой баз 1С, создание архивов, копирование на FTP, создание дистрибутивов, завершение процессов в ОС и т.д. и т.п.).

У каждой команды есть свои индивидуальные опции.

Создается файл `settings.json` в котором указываются обязательные и дополнительные настройки для работы с проектом, например, имя проекта, его названия, токены доступа куда устанавливать в рабочем контуре и т.д.

## Описание команд

С полным перечнем команд и их аргументами можно ознакомиться в файле [COMMAND.md](docs/COMMAND.md)

### GitLab

Создается файл `.gitlab-ci.yml` и в нем пишутся шаги для выполнения команд:

```yml
stages:
  - pre
  - test

before_script:
  - chcp 65001 

Подготовка:
    stage: pre
    script:
    # Копирование библиотеки CI/CD для работы
    - git config --local core.quotepath false
    - git clone https://github.com/Diversus23/actions.git
    # Добавление настроек в файл env.json
    - oscript -encoding=utf-8 "$CI_PROJECT_DIR/actions/src/actions.os" json write --key "defailt.connection" --string "/F /opt/1c/base"
    only:
        refs:
        - develop
        - master
        - merge_requests

Проверка конфигурации на ошибки:
    stage: test
    needs: [Подготовка]
    script:
    - oscript -encoding=utf-8 "$CI_PROJECT_DIR/actions/src/actions.os" infobase config check
    only:
        refs:
        - develop
        - merge_requests
```

Yaml-файл, который мы используем в реальной работе, можно посмотреть на странице [configuration.yml](yml/configuration.yml)

## ToDo

- [ ] Добавить в команду doctor проверку включенной защиты от опасных действий
