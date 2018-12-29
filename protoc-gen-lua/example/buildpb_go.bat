for %%i in (*.proto) do (    
echo %%i  
 protoc.exe    --go_out=./go/ %%i
)  
echo end  
pause