Тема "TLDR (Too long don't read)"
===============================

1. Собрать виртуальную машину Debian Linux v.12. Установить связь с машиной через SSH.
2. BASH скриптом инсталлировать TLDR. 
3. Печатать 3 команды из 100 установленных.
3. В Teams отправить копию SSH сессии. Пример.

настройка хоста:
----------------

Windows 11:

```
   Sätted -> Rakendused -> Valikulised funktsioonid ->
   Seostuvad sätted -> Veel Windowsi funktsioone -> @
```

Windows 10:

```
   Controll Panel -> Add/Remove programs -> Turn Windows Features on or Off
   
  + Hyper-V
  + Windowsi alamsüsteem Linuksile (WSL)
  + Virtual Machine Platform
```

   Reboot if necessary.
   
Автоматическая (unattended) установка
-------------------------------------

1. В WSL создать ISO имидж Debian-12 для автоматической установки:

   + скрипт deb12iuefi.sh

2. Создать Powershell скриптом виртуальную машину "AutoPig"

3. Запустить Autopig и дождаться конца установки с приглашением по IP адресу

4. Связаться командой

   `ssh it@<IP>`
   
5. Установить TLDR командой

   `apt install -y tldr`
   
   Заполнить базу данных командой
   
   `tldr -u`
   
6. Сделать запросы согласно вариантам

```
      1. adduser  27. gdb        53. mv         79. swapon    
      2. awk      28. grep       54. nice       80. sync      
      3. bg       29. gzip       55. nslookup   81. systemctl 
      4. cat      30. head       56. od         82. tail      
      5. cd       31. history    57. passwd     83. tar      
      6. chgrp    32. hostname   58. paste      84. tee      
      7. chmod    33. if         59. patch      85. test      
      8. chown    34. ifconfig   60. ping       86. time      
      9. chroot   35. ip         61. poweroff   87. top      
     10. clear    36. jobs       62. printf     88. touch     
     11. cp       37. kill       63. ps         89. tr      
     12. date     38. killall    64. pwd        90. traceroute
     13. dd       39. ldd        65. reboot     91. umount    
     14. df       40. ln         66. rm         92. uname     
     15. diff     41. ls         67. rmmod      93. uniq      
     16. dmesg    42. lsmod      68. route      94. useradd   
     17. du       43. lspci      69. sed        95. userdel   
     18. env      44. lsusb      70. seq        96. wc      
     19. expr     45. make       71. service    97. wget      
     20. fdisk    46. mkdir      72. shutdown   98. which     
     21. fg       47. mkfifo     73. sort       99. while     
     22. find     48. mkfs       74. ssh       100. who      
     23. for      49. mkswap     75. strip     101. whoami    
     24. free     50. modprobe   76. su        102. xxd     
     25. fsck     51. more       77. sudo     
     26. gcc      52. mount      78. swapoff 
```

```powershell
$x = 1..102 | Sort-Object {Get-Random}
1..30 | % { ':'+[string]($x[$_*3-2])+' '+`
            [string]($x[$_*3-1])+' '+`
            [string]($x[$_*3]) }
```

Nr|Name                   |Commands
--|-----------------------|---------------------------
 1|Vadim Andreev          |32 60 69
 2|Andrei Bedrinski       |66 23 96
 3|Anastasia Belova       |28 4 65
 4|Artjom Buzak           |59 16 79
 5|Rio Ennukson           |21 57 53
 6|Juri Falalejev         |33 84 2
 7|Artjom Gaskov          |72 86 88
 8|Dmitri Gavrjušin       |56 8 80
 9|Roman Gorski           |54 9 41
10|Dmitri Ivanov          |34 73 43
11|Marika Kipus           |25 18 85
12|Deevid Klimov          |22 97 74
13|Kristina Kovrova       |68 92 52
14|Andrei Kozlov          |20 30 31
15|Maksim Kuznetsov       |99 35 10
16|Juri Käär              |91 78 51
17|Vjatšeslav Lanberg     |87 63 7
18|Vladimir Lebedev       |46 24 14
19|Martin Rostislav Lõtšev|67 100 82
20|Juri Pavlov            |40 93 45
21|Eduard Pissarev        |38 76 47
22|Aryna Pritykina        |70 75 81
23|Sergei Prokopov        |49 12 39
24|Maksim Rusin           |94 11 71
25|Sofiia Skazheniuk      |102 55 6
26|Aleksandra Suvorova    |50 95 27
27|Polina Tšapkovskaja    |44 98 101
28|Anton Tšernobrivets    |3 83 62
29|Aleksei Tšistokletov   |26 1 17
30|Jelizaveta Vural       |5 90 64

Пример
------

На уроке..