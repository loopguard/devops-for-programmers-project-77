### Hexlet tests and linter status:
[![Actions Status](https://github.com/loopguard/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/loopguard/devops-for-programmers-project-77/actions)

## Описание проекта

Этот проект автоматизирует развёртывание и настройку инфраструктуры для приложения Redmine с помощью Terraform и Ansible в облаке Yandex Cloud.

### Структура проекта
- **terraform/** — инфраструктурный код для создания облачных ресурсов (ВМ, сеть, балансировщик и т.д.)
- **ansible/** — автоматизация установки Docker, деплоя Redmine, настройки мониторинга Datadog
- **Makefile** — команды для полного цикла развёртывания и удаления инфраструктуры и приложения

---

## Быстрый старт

### 1. Установка зависимостей
- Установите [Terraform](https://www.terraform.io/downloads.html)
- Установите [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### 2. Настройка секретов
- Секреты и чувствительные переменные хранятся в `ansible/group_vars/all/vault.yml` и шифруются через Ansible Vault.
- Для редактирования секретов используйте:
  ```sh
  cd ansible
  make edit-secrets
  ```

### 3. Развёртывание инфраструктуры и приложения
В корне проекта выполните:
```sh
make all
```
Эта команда:
- Подгрузит секреты из vault
- Создаст инфраструктуру в Yandex Cloud через Terraform
- Получит внешний IP и создаст инвентори для Ansible
- Настроит серверы и развернёт Redmine через Ansible

#### Основные команды Makefile
- `make init` — инициализация Terraform
- `make plan` — просмотр плана изменений
- `make apply` — создание/обновление инфраструктуры
- `make ansible` — настройка серверов и деплой приложения
- `make destroy` — удаление инфраструктуры
- `make clean` — очистка временных файлов

#### Дополнительные команды
- В `ansible/Makefile` есть:
  - `make dependencies` — установка ansible-ролей
  - `make deploy` — запуск плейбука для деплоя
  - `make destroy` — удаление приложения
  - `make generate-terraform-vars` — генерация переменных для Terraform

- В `terraform/Makefile` есть:
  - `make init|plan|apply|destroy|reinit` — стандартные команды Terraform

---

## Мониторинг

В проект интегрирован Datadog Agent для мониторинга состояния приложения и инфраструктуры.

---

## Требования
- Аккаунт в Yandex Cloud
- Доступ к Ansible Vault паролю
- SSH-ключ для доступа к ВМ

---

## Лицензия

Проект создан в учебных целях (Hexlet).