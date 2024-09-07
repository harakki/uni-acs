#!/bin/sh

random_name=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)

# --- Изоляция пространства имен идентификаторов процессов (PID) ---

# Запуск контейнера с ожиданием в 3 минуты
docker run -q --rm --privileged --name $random_name -d alpine sleep 300

# Получение PID программы контейнера
host=$(docker inspect --format '{{.State.Pid}}' $random_name)
container=$(docker exec -it $random_name ps aux | grep 'sleep' | awk '{print $1}')

# Сравнение PID
echo "--- PID ---"
echo "host: $host, container: $container"

# --- Изоляция пространства имен межпроцессного взаимодейстия (IPC) ---
# обмен сообщениями, синхронизация, разделение памяти
# https://ru.wikipedia.org/wiki/Межпроцессное_взаимодействие

echo "--- IPC ---"
# Если 'host', то именное пространство IPC разделено с контейнером
docker inspect --format '{{.HostConfig.IpcMode}}' $random_name

# --- Изоляция пространства имен сетей (Network) ---

host=$(hostname -I)
container=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $random_name)

echo "--- Network ---"
echo "host: $host, container: $container"

# --- Изоляция пространства имен ID пользователей (Users) ---
tmphost=$(mktemp)
tmpcont=$(mktemp)

cat /etc/passwd > $tmphost
docker exec -u 1000:1000 $random_name cat /etc/passwd > $tmpcont

echo "--- Users ---"
diff -y -W 60 $tmphost $tmpcont

# --- Изоляция точкек монтирования файловых систем (Mount) ---
# https://ru.wikipedia.org/wiki/Пространство_имён_(Linux)#Файловая_система_(Mount)

ls -l /proc/ | grep '^dr-' | awk '{print $9}' > $tmphost
docker exec -i $random_name ls -l /proc/ | grep '^dr-' | awk '{print $9}' > $tmpcont

echo "--- Mount ---"
diff -y -W 60 $tmphost $tmpcont

# --- Изоляция пространства имен UTS (Unix Time Sharing) ---
# https://ru.wikipedia.org/wiki/Пространство_имён_(Linux)#UTS
host=$(hostname)
container=$(docker exec $random_name hostname)

echo "--- UTS ---"
echo "host: $host, container: $container"

# Остановка контейнера и очистка после завершения скрипта
docker stop $random_name
# rm $tmphost
# rm $tmpcont
