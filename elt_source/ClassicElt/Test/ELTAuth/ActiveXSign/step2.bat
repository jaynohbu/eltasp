signcode -v ELTcert.pvk -spc ELTcert.spc FreightEasyNet.cab
setreg -q 1 TRUE
chktrust FreightEasyNet.cab
pause