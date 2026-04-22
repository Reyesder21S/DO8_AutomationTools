## Part 1. Удаленное конфигурирование узла через Ansible
1. Создать с помощью Vagrant три машины: manager, node01, node02. Не устанавливать с помощью shell-скриптов docker при создании машин на Vagrant! Прокинуть порты node01 на локальную машину для доступа к пока еще не развернутому микросервисному приложению.

![](images/part_1.png)

![](images/part_1.1.1.png)


2. Подготовить manager как рабочую станцию для удаленного конфигурирования
- Сгенерировать ssh-ключ для подключения к node01 из manager:

![](images/part_1.1.png)

Изменил конфигурационный файл /etc/ssh/sshd_config на node01

![](images/part_1.2.png)

Добавляем сгенерированный ключ на node01:

![](images/part_1.3.png)

Вход по ssh работает:

![](images/part_1.4.png)

Скопировать на manager docker-compose файл и исходный код микросервисов

![](images/part_1.5.png)

Установить Ansible на менеджер и создать папку ansible, в которой создать inventory-файл.

![](images/part_1.6.png)
![](images/part_1.6.1.png)
![](images/part_1.7.png)

Использовать модуль ping для проверки подключения через Ansible

![](images/part_1.8.png)

3. Написать первый плейбук для Ansible, который выполняет apt update, устанавливает docker, docker-compose, копирует compose-файл из manager'а и разворачивает микросервисное приложение.

![](images/part_1.9.png)
![](images/part_1.10.png)

Запуск Playbook:
![](images/part_1.11.png)

Контенейры на node1
![](images/part_1.12.png)

4. Прогнать заготовленные тесты через postman и удостовериться, что все они проходят успешно.

![](images/part_1.13.png)

5. Сформировать три роли:
- роль application выполняет развертывание микросервисного приложения при помощи docker-compose;

![](images/part_1.14.png)
![](images/part_1.15.png)
![](images/part_1.16.png)

- apache устанавливает и запускает стандартный apache сервер;

![](images/part_1.17.png)

- postgres устанавливает и запускает postgres, создает базу данных с произвольной таблицей и добавляет в нее три произвольные записи.

![](images/part_1.18.png)
![](images/part_1.19.png)
![](images/part_1.20.png)

Playbook:

![](images/part_1.21.png)

inventory:

![](images/part_1.22.png)

Запуск с 3 ролями:

![](images/part_1.23.png)
![](images/part_1.24.png)

Проверка postman-тестами работоспособность микросервисного приложения

![](images/part_1.25.png)

Apache веб-страница:

![](images/part_1.26.png)

Подключение с локальной машины и отображение содержимого ранее созданной таблицы с данными

![](images/part_1.27.png)


## Part 2. Service Discovery
1. Написать два конфигурационных файла для consul:

consul_server.hcl:


![](images/part_2.png)


consul_client.hcl:


![](images/part_2.1.png)


2. Создать с помощью Vagrant четыре машины: consul_server, api, manager и db.

Прокинуть порт 8082 с api на локальную машину для доступа к пока еще не развернутому api.
Прокинуть порт 8500 с consul_server для доступа к ui consul.
![](images/part_2.2.png)
![](images/part_2.3.png)


3. Написать плейбук для ansible и четыре роли:

- install_consul_server, которая:
    - работает с consul_server;
    - копирует consul_server.hcl;
    - устанавливает consul и необходимые для consul зависимости;
    - запускает сервис consul;
![](images/part_2.4.png)
![](images/part_2.5.png)


- install_consul_client, которая:
    - работает с api и db;
    - копирует consul_client.hcl;
    - устанавливает consul, envoy и необходимые для consul зависимости;
    - запускает сервис consul и consul-envoy;
![](images/part_2.6.png)
![](images/part_2.7.png)


- install_db, которая:
    - работает с db;
    - устанавливает postgres и запускает его;
    - создает базу данных hotels_db;
![](images/part_2.8.png)
![](images/part_2.9.png)


- install_hotels_service, которая:
    - работает с api;
    - копирует исходный код сервиса;
    - устанавливает openjdk-8-jdk;
    - создает глобальные переменные окружения:
        - POSTGRES_HOST="127.0.0.1";
        - POSTGRES_PORT="5432";
        - POSTGRES_DB="hotels_db";
        - POSTGRES_USER="<имя пользователя>";
        - POSTGRES_PASSWORD="<пароль пользователя>";
    - запускает собранный jar-файл командой java -jar <путь до hotel-service>/hotel-service/target/<имя jar-файла>.jar.
![](images/part_2.10.png)
![](images/part_2.11.png)
![](images/part_2.12.png)


Playbook:

![](images/part_2.13.png)

inventory:

![](images/part_2.14.png)

Созданы 4 машины:

![](images/part_2.15.png)

Захожу в manager для запуска Playbook:
![](images/part_2.16.png)
![](images/part_2.17.png)


Ноды в кластере Consul:

![](images/part_2.18.png)


Интерфейс Consul с запущенными сервисами:

![](images/part_2.19.png)


4. Проверить работоспособность CRUD-операций над сервисом отелей. В отчете отобразить результаты тестирования.

Список отелей:

![](images/part_2.20.png)
![](images/part_2.21.png)

Создание нового отеля:

![](images/part_2.22.png)

Новый отель появился в списке:

![](images/part_2.23.png)

 Чтение отеля:

 ![](images/part_2.24.png)


 Поиск отеля по hotelUid:

 ![](images/part_2.25.png)

 Обновление отеля:

 ![](images/part_2.26.png)

 Удаление отеля:

 ![](images/part_2.27.png)

- API ожидает Integer как тип ID
- В URL параметр передается как Long
- Spring Data REST не может правильно конвертировать тип