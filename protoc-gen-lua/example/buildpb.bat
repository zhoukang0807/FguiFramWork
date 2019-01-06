del /a /f /q ..\example\pb\  
for %%i in (*.proto) do (    
echo %%i  
 protoc.exe     --descriptor_set_out=./pb/%%i   %%i  
)  
cd ./pb
ren *.proto *.pb
echo end  
pause