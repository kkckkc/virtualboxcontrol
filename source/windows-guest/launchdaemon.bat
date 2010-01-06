@echo off

setLocal EnableDelayedExpansion

:start

VBoxControl -nologo guestproperty wait open | find "Value:" > output.txt
VBoxControl -nologo guestproperty get open1 | find "Value:" >> output.txt
VBoxControl -nologo guestproperty get open2 | find "Value:" >> output.txt
VBoxControl -nologo guestproperty get open3 | find "Value:" >> output.txt

type output.txt

set s=
for /F "tokens=1,* delims=: " %%g in (output.txt) do (
	set s=!s!%%h
)

echo "Running %s%"
start /B cmd /C "%s%"

VBoxControl -nologo guestproperty set open
VBoxControl -nologo guestproperty set open1
VBoxControl -nologo guestproperty set open2
VBoxControl -nologo guestproperty set open3

goto start

