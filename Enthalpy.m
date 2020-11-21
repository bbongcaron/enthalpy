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
end
