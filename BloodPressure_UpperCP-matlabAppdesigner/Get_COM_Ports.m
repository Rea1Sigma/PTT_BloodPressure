function [COMS port] = get_com_ports()%获取串口号函数
    command = 'wmic path win32_pnpentity get caption /format:list | find "COM"';
    [status, cmdout] = system (command);
    cmdout = strread(cmdout,'%s','delimiter','='); %按分隔符拆分字符串数组
    if numel(cmdout)>0
        j=1;
        for i = 1:numel(cmdout)  %numel 返回元素个数
            if strcmp(cmdout{i}(1:7),'Caption')
                COMS{j} = cmdout{i+1};
                j=j+1;
            end
        end
        COMS_split=cell2mat(COMS);
        COMS_split=split(COMS_split,'(');%通过左括号将字符串分割
        j=1;
        for i = 1:numel(COMS_split)  %numel 返回元素个数
            if strcmp(COMS_split{i}(1:3),'COM')
                port_temp{j} = COMS_split{i};
                COMS_Final{j} = COMS{i-1};
                j=j+1;
            end
        end
        port_temp=split(port_temp,')');%通过右括号将字符串分割
        j=1;
        for i = 1:(numel(port_temp)-1)  %numel 返回元素个数
            if strcmp(port_temp{i}(1:3),'COM')
                port{j} = port_temp{i};
                j=j+1;
            end
        end
        COMS = COMS_Final;
    elseif numel(cmdout)==0
        COMS="没有搜索到串口";
        port="null";
        errordlg('没有搜索到任何可用端口');
    end
end