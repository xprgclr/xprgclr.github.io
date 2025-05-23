it's a readme file
> [!abstract]- Популярные инструменты для управления конфигурацией и автоматизацией серверов
> 
> 
> 
> 🔹 **Ansible** — мощный инструмент автоматизации, работающий без агента, с простыми YAML-плейбуками. Используется для развертывания, управления конфигурацией и оркестрации.
> 🔹 **Chef** — инструмент для управления инфраструктурой через Ruby-код. Использует концепцию "рецептов" и "кухонь" для автоматизации конфигураций серверов.
> 🔹 **Puppet** — система управления конфигурацией, использующая декларативный язык и агент-серверную архитектуру. Отлично подходит для крупных инфраструктур.
> 🔹 **Salt (SaltStack)** — мощный инструмент для оркестрации и управления конфигурацией, работающий на основе событий. Ускоряет массовое управление серверами.
> 
> 💡 Они помогают автоматизировать администрирование серверов, упрощая их настройку, обновление и масштабирование!  

> [!info] Ansible
> **Ansible** — инструмент автоматизации, который позволяет управлять серверами, конфигурациями и развертыванием приложений без необходимости устанавливать агенты.
> 
> 🔹 **Простота** — всё описывается в YAML-плейбуках.  
> 🔹 **Без агента** — работает по SSH, без установки на удалённые узлы.  
> 🔹 **Идпемпотентность** — выполняет команды так, чтобы не менять уже настроенные параметры. 
> 🔹 **Масштабируемость** — управляет сотнями и тысячами серверов одновременно.
> 
> 🚀 Идеален для автоматизации инфраструктуры, обновлений и настройки серверов!  

> [!info]- Ссылки для ознакомления:
> - [Chef Software DevOps Automation Solutions | Chef](https://www.chef.io/)
> - [Ansible для начинающих / Хабр](https://habr.com/ru/companies/slurm/articles/714000/)
> - [Start automating with Ansible — Ansible Community Documentation](https://docs.ansible.com/ansible/latest/getting_started/get_started_ansible.html)
> 
> - [ma-ansible-automation-platform-beginners-guide-ebook-1090348-202404-en](attachments/ma-ansible-automation-platform-beginners-guide-ebook-1090348-202404-en.pdf)
> - [Automation tools (1)](attachments/ansible/Automation%20tools%20(1).txt)
> - [Ansible-labor 1 (1)](attachments/ansible/Ansible-labor%201%20(1).txt)

## Intro

Имеем 3 машины. На одну поставим ansible ( `apt install ansible` ), на двух других пусть крутиться nginx который позже поставим посредством ansible.

| IP            | Role                      |
| ------------- | ------------------------- |
| 192.168.0.205 | Ansible                   |
| 192.168.0.107 | Slave1 (nginx web-server) |
| 192.168.0.125 | Slave2 (nginx web-server) |

> [!tip]- Если нужен sudo
>
> ```bash
> su -
> apt install sudo
> usermod -aG sudo it
> exit
> ```
> - Перезаходим пользователем it ( снова `exit` )

- Для упрощения/тестов делаем всё под рутом (`su -` )
## 1. Предварительные настройки ( hostname , ssh )


- Меняем hostname через `hostnamectl set-hostname ansible`. Можно и через `hostname ansible`, но тогда hostname вернется обратно после перезагрузки, если не добавлять изменения в ***/etc/hostname*** и ***/etc/hosts***. Делаем релогин
![|500x307](attachments/ansible/Ansible-1746355342302.webp)

- Генерим ключи для root пользователя `ssh-keygen`

- Копируем содержимое публичного ключа с **ansible machine** - из ***/root/.ssh/id_rsa.pub*** на **slaves** - в ***/root/.ssh/authorized_keys***. Slaves machine's:
```
  mkdir /root/.ssh && chmod 700 /root/.ssh
  touch /root/.ssh/authorized_keys && chmod 600 /root/.ssh/authorized_keys
  nano  /root/.ssh/authorized_keys
```
P.S: если изначально возможен доступ по ssh рутом, то можно проще: `ssh-copy-id root@192.168.0.203`

![|500x307](attachments/ansible/Ansible-1746355594950.webp)

- Проверяем коннект `ssh root@192.168.0.107 / 125`
  
## 2. Настройки Ansible

- Создаем каталог и конфиг файл: `mkdir -p /etc/ansible && nano /etc/ansible/ansible.cfg`
```
[defaults]
host_key_checking=False
```

- Создаем файл инвентаря для ansible: `nano /etc/ansible/hosts`
```
[webservers]
192.168.0.107
192.168.0.125
```

- Либо же скриптом:
```
nano ansconf.sh
chmod +x ansconf.sh
./ansconf.sh
```

Содержимое:
```bash
#!/bin/bash

# Создание папки конфигурации Ansible
mkdir -p /etc/ansible

# Запись настроек в ansible.cfg
echo -e "[defaults]\nhost_key_checking=False" > /etc/ansible/ansible.cfg 

# Создание файла hosts и добавление серверов
echo -e "[webservers]\n192.168.0.107\n192.168.0.125" > /etc/ansible/hosts

echo "Настройки Ansible успешно применены!"
```

## 3. Ansible в работе

- Тестим команды
```
-- Check inventory list:
ansible-inventory --list

-- Check communication from "ansible" with slave linuxes:
ansible webservers -m ping
ansible all -m ping

-- Check device free status on each linux "ansible":
ansible all -a "df -h"

-- Show slave servers uptime
ansible webservers -a "uptime"
ansible all -a "uptime"
```

![|408x888](attachments/ansible/Ansible-1746355986348.webp)

- Создаем первый playbook - `nano firstplaybook.yml`. Содержимое:
```
- name: Update web servers
  hosts: webservers
  remote_user: root
  tasks:
  - name: Install aptitude
    apt:
      name: aptitude
      state: latest
      update_cache: true
  - name: Install mc
    apt:
      name: mc
      state: latest
      update_cache: true
  - name: Install net-tools
    apt:
      name: net-tools
      state: latest
      update_cache: true
```
[Ansible](attachments/Ansible.md)
- Запускаем, проверяем - `ansible-playbook firstplaybook.yml -l all`. Проверяем установленные пакеты на **slaves**: mc ,netstat -antp.
![|500x405](attachments/ansible/Ansible-1746356172360.webp)


- Делаем еще один playbook, `nano secondplaybook.yml`
```
- name: Install Nginx
  hosts: webservers
  tasks:
    - name: Update package cache
      apt:
        update_cache: yes
      when: ansible_distribution == 'Debian'
    - name: Install Nginx
      apt:
        name: nginx
        state: present
      when: ansible_distribution == 'Debian'
    - name: Start Nginx
      service:
        name: nginx
        state: started
      when: ansible_distribution == 'Debian'
```

- Запускаем его  `ansible-playbook secondplaybook.yml -l all`. Тестим на каждом клиенте, убеждаемся что nginx работает везде ( 80ый порт ).

```
-- On each slave linux check that nginx active and bind to port 80
lin1# nestat -antp 
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      6538/nginx: master
```

![|500x271](attachments/ansible/Ansible-1746356273103.webp)
- Заходим с браузера хостовой машины:
![|500x385](attachments/ansible/Ansible-1746356456736.webp)
## 4. Замена стартовой страницы nginx на обоих "клиентах"

- Создаем болванки для стартовой страницы каждого из "клиентов".
```
echo "<h1>CLIENT_1</h1>" > client1.html && echo "<h1>CLIENT_2</h1>" > client2.html
```

- Делаем еще один плейбук `nano thirdplaybook.yml`
```
- name: Настройка стартовой страницы Nginx
  hosts: webservers
  tasks:
    - name: Копируем index.html для 192.168.0.125
      copy:
        src: ./client1.html  # Локальный файл для первого сервера
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'
      when: inventory_hostname == "192.168.0.107"

    - name: Копируем index.html для 192.168.0.125
      copy:
        src: ./client2.html  # Локальный файл для второго сервера
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: '0644'
      when: inventory_hostname == "192.168.0.125"

    - name: Перезапускаем Nginx
      systemd:
        name: nginx
        state: restarted
```

![|500x315](attachments/ansible/Ansible-1746356549939.webp)


- Проверяем , всё ок:

![|500x385](attachments/ansible/Ansible-1746356558542.webp)

## Done
