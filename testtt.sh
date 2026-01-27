for /R %f in (*) do findstr /I /R "127\.0\.0\.1 192\.168\.0\.1 10\.0\.0\.1" "%f" >nul && echo %f
