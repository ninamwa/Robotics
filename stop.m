function stop()
sp=serial_port_start();
pioneer_close(sp);
fclose(instrfind);
delete(instrfind);
end