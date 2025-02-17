# ACS5

Запустить реализацию *k8s* на базе *Minikube* (допускается другие варианты реализации k8s)

## Задание

### DoD на 3

- Запустить в *k8s* контейнер сетевого приложения (для приложения можно использовать Docker-образ `nginx:latest`);

- Для развертывания использовать сущность *Deployment*;

- Должна быть возможность открыть приложение в браузере;

- Для этого потребуется (в случае с *Minikube*) включить расширение *ingress*;

- Так же для приложения потребуется создать сущности *service* и *ingress*;

- Продемонстрировать работу, показать на основе чего определяются контейнеры, к которым направляется трафик (*Deployment-replicaset managed pods*).

### DoD на 4

- DoD на 3, но: используя *helm* создать новый чарт, задача которого - развернуть "релиз" приложения. Для примера можно так же использовать образ *nginx*;

    - Использование готового *helm*-чарта допускается, но при полном понимании что это и как это сделано.

- Запустить приложение;

- Продемонстрировать работу, показать на основе чего определяются контейнеры, к которым направляется трафик (*Deployment-replicaset managed pods*);

- Что такое helm релиз? Где хранится, что содержит. Необходимо показать информацию о релизе.

### DoD на 5

- DoD на 4, также необходимо иметь работоспособный helm-чарт;

- Используя *helmfile*, развернуть несколько экземпляров приложения (для нескольких релизов через один *helmfile* можно использовать `environment` функционал);

- Продемонстрировать работу - каждый релиз должен быть на своём домене, продемонстрировать, что запросы ведут к ожидаемым релизам приложения;

- *Env* подразумевает, что там находятся переменные, которые отличаются между окружениями. *Values* это то, что будет отдано в чарт как *values*. Так, в результате, *env* должен содержать по одной-две переменные (например, домен), а в *values* - шаблон для их использования, генерирующий *values* для чарта.
