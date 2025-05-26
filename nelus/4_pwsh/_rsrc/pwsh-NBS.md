INSTALL POWERSHELL ON DEBIAN LINUX
----------------------------------

```bash
#! /bin/bash

if test `id -u` -ne 0
then
  echo "ur not root bro"
  exit 1
fi

batcat $0

apt-get update
apt-get install -y wget
wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.0//powershell_7.4.0-1.deb_amd64.deb
dpkg -i powershell_7.4.0-1.deb_amd64.deb
apt-get install -f
rm powershell_7.4.0-1.deb_amd64.deb
```

--------------------------------

### 1. PRINT BINARY NUMBERS WITH LEADING ZEROES, LIKE SO:
---------------------------------------------------------

```
  0  00 
  1  01
  2  10 
  3  11
  ..
```
awk:

```awk
# awk -f 1.awk
BEGIN {
  N=3; # number of bits
  n=1; a[0]="";
  for(i=0;i<3;i++) {
    for(j=0;j<n;j++) { 
      a[n+j]="1"a[j]; 
      a[j]="0"a[j]; 
    }
    n+=j;
  }
  for(i=0;i<n;i++) 
    print i," ", a[i];
}
```
pwsh:

```powershell
0..7|%{"$_  $([convert]::ToString($_,2).PadLeft(3,'0'))"}
```

result:
```
0  000
1  001
2  010
3  011
4  100
5  101
6  110
7  111
```

### 2. PRINT BINARY NUMBERS WITH LEADING ZEROES, LIKE SO:
-----------------------------------------------------
```
  00 01 10 11
```
awk

```bash
# gawk -f 2.awk
BEGIN {
  ORS=" "; # the output record separator
  N=3;     # number of bits
  n=1; a[0]="";
  for(i=0;i<3;i++) {
    for(j=0;j<n;j++) { 
      a[n+j]="1"a[j]; 
      a[j]="0"a[j]; 
    }
    n+=j;
  }
  for(i=0;i<n;i++) 
    print a[i];
  ORS="\n"; print;
}
```
result:
```
000 001 010 011 100 101 110 111
```

pwsh:

```bash
$ pwsh 2.ps1
```
result"
```
000 001 010 011 100 101 110 111
```
```powershell
$ batcat 2.ps1 -l powershell
──┬───────────────────────────────────────────────────────────
  │ File: 2.ps1
──┼───────────────────────────────────────────────────────────
1 │ $r="";
2 │ 0..7|%{$r+="$([convert]::ToString($_,2).PadLeft(3,'0'))"};
3 │ $r
──┴───────────────────────────────────────────────────────────
```

### 3. PRINT TRUTH TABLE FOR NOT, OR, XOR, AND
----------------------------------------------

```
# gawk -f 3.awk
BEGIN {
  n=1; a[0]="";
  for(i=0;i<2;i++) {
    for(j=0;j<n;j++) {
      a[n+j]="1"a[j];
      a[j]="0"a[j];
    }
    n+=j;
  }
  print "n","ab","!a","!b","OR","XOR","AND"
  for(i=0;i<n;i++)
    print i, a[i], "",
    xor(rshift(and(i,2),1),1), "",
    xor(and(i,1),1), "",
    or(and(i,1),rshift(and(i,2),1)), "",
    xor(and(i,1),rshift(and(i,2),1)), "",
    and(and(i,1),rshift(and(i,2),1));
}

$ gawk -f 3.awk
n ab !a !b OR XOR AND
0 00  1  1  0  0  0
1 01  1  0  1  1  0
2 10  0  1  1  1  0
3 11  0  0  1  0  1
```
powershell:

```powershell
"n ab !a !b OR XOR AND"
0..3 | % {
  $u=[math]::floor($_/2)%2;
  $l=$_%2;
  "$_ $u$l $([int]!$u)  $([int]!$l)  "+
  "$([int]([bool]$u -or [bool]$l))  " +
  "$([int]([bool]$u -xor [bool]$l))   " +
  "$([int]([bool]$u -and [bool]$l))"
}
```
```
n ab !a !b OR XOR AND
0 00 1  1  0  0   0
1 01 1  0  1  1   0
2 10 0  1  1  1   0
3 11 0  0  1  0   1
```

### 4. PRINT CYRILLIC ALPHABET
------------------------------

```
# awk -f 4.awk
function chr(c) {
  return sprintf("%c",c+0)
}

BEGIN {
  ORS=""
  for (x=0x410;x<=0x44f;x++) {
    if(x==0x430) print "\n";
    print chr(x);
  }
  ORS="\n"; print;
}

АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ
абвгдежзийклмнопрстуфхцчшщъыьэюя
```

```powershell
$az=""; "А".."Я" | % { $az+=$_ }; $az
$az=""; "а".."я" | % { $az+=$_ }; $az
```
```
АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ
абвгдежзийклмнопрстуфхцчшщъыьэюя
```

### 5. ALFRED VAIL'S CODE (MORSE CODE)
--------------------------------------

```
# awk -f 5.awk
BEGIN {
  si="ABCDEFGHIJKLMNOPQRSTUVWXYZ ";
  s=".-:-...:-.-.:-..:.:..-.:--.:....:..:.---:-.-:.-..:--:";
  s=s"-.:---:.--.:--.-:.-.:...:-:..-:...-:.--:-..-:-.--:--..: ";
  split(si,idx,"");
  split(s,cipher,":");
  for(i in idx) ci[idx[i]]=i;
  splain="HELLO WORLD";
  split(splain,plain,"");
  for(i in plain) printf("%s ", cipher[ci[plain[i]]]);
  print;
}
```
```powershell
$vail = @{
 "A" = ".-"; "B" = "-..."; "C" = "-.-."; "D" = "-..";
 "E" = "."; "F" = "..-."; "G" = "--."; "H" = "....";
 "I" = ".."; "J" = ".---"; "K" = "-.-"; "L" = ".-..";
 "M" = "--"; "N" = "-."; "O" = "---"; "P" = ".--.";
 "Q" = "--.-"; "R" = ".-."; "S" = "..."; "T" = "-";
 "U" = "..-"; "V" = "...-"; "W" = ".--"; "X" = "-..-";
 "Y" = "-.--"; "Z" = "--..";
}
$msg="HELLO WORLD"

$out=""
0..($msg.length-1) | % { $out+=$vail[[string]$msg[$_]]+" "}
$out
```
```
.... . .-.. .-.. ---  .-- --- .-. .-.. -..
```
### 6. SIMPLE CALCULATOR
------------------------

```
# echo 2 + 3 | awk -f 6.awk
{
  z=0;
  switch ($2) {
    case "+" : z=$1+$3; break;
    case "-" : z=$1-$3; break;
    case "*" : z=$1*$3; break;
    case "/" : z=$1/$3; break;
    case "%" : z=$1%$3; break;
    default  : print "Illegal Operation",$2;
  }
  print $0," : ",$1,$2,$3,"=",z;
}
```
powershell **tip**

parse.ps1
```powershell
$input | % {$_.Split(" ") | % { $_ }}
```

```powershell
echo "A B C" | ./parse.ps1
A
B
C
```

### 7. MULTIPLICATION TABLE FOR BASE 10
---------------------------------------

```
# echo 10 | awk -f 7.awk
{
  printf("  :"); 
  for(y=1;y<=$1-1;y++) 
    printf("  %d",y); 
  printf("\n");
  printf("..."); 
  for(y=1;y<=$1-1;y++) 
    printf(" .."); 
  printf("\n");
  for(x=1;x<=$1-1;x++) {
    printf("%d : ",x);
    for(y=1;y<=$1-1;y++) 
      printf("%02d ",x*y); 
    printf("\n");
  }
}

$ echo 10 | awk -f 7.awk
  :  1  2  3  4  5  6  7  8  9
... .. .. .. .. .. .. .. .. ..
1 : 01 02 03 04 05 06 07 08 09
2 : 02 04 06 08 10 12 14 16 18
3 : 03 06 09 12 15 18 21 24 27
4 : 04 08 12 16 20 24 28 32 36
5 : 05 10 15 20 25 30 35 40 45
6 : 06 12 18 24 30 36 42 48 54
7 : 07 14 21 28 35 42 49 56 63
8 : 08 16 24 32 40 48 56 64 72
9 : 09 18 27 36 45 54 63 72 81
```

`K>` *i need to translate following AWK script named 7.awk into powershell.*
```awk
 {
  printf("  :"); 
  for(y=1;y<=$1-1;y++) 
    printf("  %d",y); 
  printf("\n");
  printf("..."); 
  for(y=1;y<=$1-1;y++) 
    printf(" .."); 
  printf("\n");
  for(x=1;x<=$1-1;x++) {
    printf("%d : ",x);
    for(y=1;y<=$1-1;y++) 
      printf("%02d ",x*y); 
    printf("\n");
  }
}
```
using it like
```
echo 10 | awk -f 7.awk
```
gives me multiplication table for base 10
```
  :  1  2  3  4  5  6  7  8  9
... .. .. .. .. .. .. .. .. ..
1 : 01 02 03 04 05 06 07 08 09
2 : 02 04 06 08 10 12 14 16 18
3 : 03 06 09 12 15 18 21 24 27
4 : 04 08 12 16 20 24 28 32 36
5 : 05 10 15 20 25 30 35 40 45
6 : 06 12 18 24 30 36 42 48 54
7 : 07 14 21 28 35 42 49 56 63
8 : 08 16 24 32 40 48 56 64 72
9 : 09 18 27 36 45 54 63 72 81
```
**Copilot:** Here is a PowerShell script that will generate the multiplication table for base 10:   
...

`K>` Buggy..
```
ForEach-Object: /home/it/powershell/7.ps1:7
Line |
   7 |  … 1..($number-1) | ForEach-Object { '{0:D2}' -f ($_ * $i) } -join ' ')"
     |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | Cannot bind parameter 'RemainingScripts'. Cannot convert the "-join" value 
     | of type "System.String" to type "System.Management.Automation.ScriptBlock".
```

**Copilot:** I apologize for the error. The -join operator is not a valid parameter for the ForEach-Object cmdlet. Instead, you can use the -join operator outside of the ForEach-Object cmdlet to join the results of the pipeline into a single string. Here’s the corrected code:

```powershell
$number = Read-Host "Enter a number"
for ($i = 1; $i -le $number; $i++) {
    if ($i -eq 1) {
        Write-Host "  : $(1..($number-1) -join '  ')"
        Write-Host "... $(1..($number-1) -join '..')"
    }
    $row = (1..($number-1) | ForEach-Object { '{0:D2}' -f ($_ * $i) })
    Write-Host "$i : $($row -join ' ')"
}
```
I hope this helps!

`K:` *That's OK, thanks!*

**Copilot** You’re welcome! If you have any more questions, feel free to ask.

Manual fix:

```powershell
PS /home/opilane/powershell> batcat ./7.ps1 -l powershell
───────┬────────────────────────────────────────────────────────
       │ File: ./7.ps1
───────┼────────────────────────────────────────────────────────
   1   │ $input | % {$n=$_}
   2   │ $x="L"
   3   │ for ($i = 1; $i -lt $n; $i++) {
   4   │     if ($i -eq 1) {
   5   │         "  : $(1..($n-1) -join '  ')"
   6   │         "... " + $(1..($n-1) | % {'..'})
   7   │     }
   8   │     $row = (1..($n-1) | % {'{0:D2}' -f ($_ * $i)})
   9   │     "$i : $($row -join ' ')"
  10   │ }
  11   │
───────┴────────────────────────────────────────────────────────
PS /home/opilane/powershell> echo 10 | ./7.ps1
  : 1  2  3  4  5  6  7  8  9
... .. .. .. .. .. .. .. .. ..
1 : 01 02 03 04 05 06 07 08 09
2 : 02 04 06 08 10 12 14 16 18
3 : 03 06 09 12 15 18 21 24 27
4 : 04 08 12 16 20 24 28 32 36
5 : 05 10 15 20 25 30 35 40 45
6 : 06 12 18 24 30 36 42 48 54
7 : 07 14 21 28 35 42 49 56 63
8 : 08 16 24 32 40 48 56 64 72
9 : 09 18 27 36 45 54 63 72 81
```

### 8. DELAY INTRODUCED
-----------------------

```bash
# echo 1010 1101 | awk -f this.awk

{
  print $1;
  system("sleep 3.2");
  print $2;
}
```

```powershell
PS > batcat ./8.ps1 -l powershell
───────┬────────────────────────────────────────────────────────
       │ File: ./8.ps1
───────┼────────────────────────────────────────────────────────
   1   │ $n=0; $a='',''
   2   │ $input | % {$_.Split(" ") | % { $a[$n++]=$_ }}
   3   │ $a[0]
   4   │ Start-Sleep -ms 3200
   5   │ $a[1]
───────┴────────────────────────────────────────────────────────
PS > echo "1010 1011" | ./8.ps1
1010
1011
```

### 10. VALIDATE INTEGER
------------------------

```bash
# echo -1074 | awk -f 10.awk
{
  print $0 ~ /^([+-]?[1-9][0-9]*|0)$/ ? "Ok" : "NaN",$0
}
```

```powershell
PS > batcat ./10.ps1 -l powershell
───────┬────────────────────────────────────────────────────────
       │ File: ./10.ps1
───────┼────────────────────────────────────────────────────────
   1   │ $input | % {$n=$_}
   2   │ ($n -match '^([+-]?[1-9][0-9]*|0)$') ?
   3   │    "OK, $n" : "NaN, $n"
   4   │
───────┴────────────────────────────────────────────────────────
PS > echo 12X4 | ./10.ps1
NaN, 12X4
PS > echo 1234 | ./10.ps1
OK, 1234
```
