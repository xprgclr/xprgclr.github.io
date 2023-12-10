# pwsh_tmp

## Почему не мог найти groupdel, а только через sudo

её не могло найти, потому что она не была уазана в путях. Чтобы что то найти надо юзать `find`
sudo find / -name groupdel -type f

    ищем от рута, будучи рутом
    - name groupdel: имя
    - type f : файл

env - показывает окружение
env | grep -P 'PATH'

    PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games

но groupdel лежит в sbin, у нас два варианта

1. добавить путь к себе но это мало чо даст, т.к это команды админа 
2. Посмотреть чо есть у админа

sudo -s vs sudo -a


Получаем админа с env текущего юзера
Должны были послать, но получили доступ к команде..

sudo env | grep -P 'PATH'

    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

## Сморим .bashrc / profile

ls -lф   Показать скрытые файлы



    it@bookworm-unattended:~$ cat .bashrc | grep -P 'PATH'
    it@bookworm-unattended:~$ cat .profile | grep -P 'PATH'
    # set PATH so it includes user's private bin if it exists
        PATH="$HOME/bin:$PATH"
    # set PATH so it includes user's private bin if it exists
        PATH="$HOME/.local/bin:$PATH"
    it@bookworm-unattended:~$

------








sudo apt install tree
tree / 
