%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Inicializa a porta serie para as especificacoes do Pioneer
% Joao Sequeira, 2003
% Ricardo Ferreira, 2004
% Rodrigo Ventura, 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sp = serial_port_start(varargin)

global read_buffer;
read_buffer=[];

if isempty(varargin)
    if strcmp(computer,'GLNX86')
        port_name = '/dev/ttyS0';
    else
        port_name = 'COM1';
    end
else
    port_name = varargin{1};
end

sp = serial(port_name, 'BaudRate', 9600, 'Parity', 'none', 'StopBits', 1, 'DataBits', 8);

out = instrfind;
[m,n] = size(out);
for i=1:n,
    if strcmp(out(i).Status,'open') & (~isempty(strfind(out(i).Name,port_name)))
        fclose(out(i));
        disp(['Old connection at index ', num2str(i), ' closed']);
    end
end

%sp.Timeout                  = 1; 
%sp.ReadAsyncMode            = 'continuous';

%sp.BytesAvailableFcn        = @serial_port_read_bulk;
%sp.BytesAvailableFcnMode    = 'byte';
%sp.BytesAvailableFcnCount   = 1;

% 100KB of input buffer, just to be on the safe side...
sp.InputBufferSize = 102400;

fopen(sp)

disp(['Trying a new connection to serial port ', port_name, ' ...']);

if strcmp(get(sp,'Status'),'closed')
    disp('... impossible to establish connection - Check the available COM ports');
    delete(sp);
    clear sp;
    return
else
    disp('...established');
end
return 