function [] = Enthalpy()
    promptCell = {'Component', ...
        'Reference Temp [°C]', ...
        'Solid(s), liquid(l) or gas(g)', ...
        'Temperature[°C]'};
    userInfoCell = inputdlg(promptCell, 'Enthalpy Inputs', [1 1 1 1]);
    fields = {'c', 'ref', 'state', 't'};
    userInfoStruct = cell2struct(userInfoCell, fields);
    component = userInfoStruct.c
    refTemp = str2double(userInfoStruct.ref)
    state = userInfoStruct.state
    temp = str2double(userInfoStruct.t)
    
    if strcmpi(component, 'water') && refTemp == 0.01
        % case to be worked on later
    else
        enthalpy = heatCapacity(refTemp, temp)
    end
end

function [enthalpy] = heatCapacity(refTemp, temp)
    enthalpy = 0;
    if refTemp == temp
        return
    end
    
end

