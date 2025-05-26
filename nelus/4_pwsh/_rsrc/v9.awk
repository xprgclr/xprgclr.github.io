# echo false | awk -f 9.awk
{
  x=$0;
  x=x=="true"?1:x; x=x=="false"?0:x;
  print x~/^(0|1)$/?"Ok":"NaB",x
}