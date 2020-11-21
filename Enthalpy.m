function [] = Enthalpy()
    [component, refTemp, state, temp, pressure] = userInput();
    if strcmpi(component, 'water') && refTemp == 0.01
        % case to be worked on later
    else
        enthalpy = heatCapacity(component, refTemp, temp)
    end
end

function [component, refTemp, state, temp, pressure] = userInput()   
    % may be inefficient run-time wise to grab component column twice, 
    % however big O is still O(n), where
    % n is number of components in heatCapacity.xlsx
    matComp = readvars('heatCapacity.xlsx', 'Range', 'A2:A62');
    len = length(matComp);
    i = 1;
%% remove duplicate names, state will be asked later
    while i < len
        if strcmpi(matComp(i), matComp(i+1))
            matComp(i+1) = [];
            len = len - 1;
        end
        i = i + 1;
    end
 %% Listdlg to choose component
    componentIndex = listdlg('ListString', matComp, ...
        'PromptString', 'Select a component:', ...
        'ListSize', [400,400], 'SelectionMode', 'single');
    component = matComp{componentIndex};
    refTemp = 0.01;
    temp = NaN;
    pressure = NaN;
    if strcmpi(component, 'water')
        promptCell = {['For steam tables, Reference Temp = 0.01°C.  ', ...
            '   Leave unknown/unecessary quantities blank. ', ...
            'Temperature[°C]'], 'Pressure [kPa]'...
             "Type 'liquid' or 'gas' (without quotes)"};
        cell = inputdlg(promptCell, 'State Variables', [1 50]);
        temp = str2double(cell{1});
        pressure = str2double(cell{2});
        state = cell{3};
    else
        promptCell = {'Reference Temp [°C]', ...
                    'Temperature[°C]',...
                    "Type 'solid', 'liquid' or 'gas' (without quotes)"};
        tempCell = inputdlg(promptCell, 'Temperature', [1 40]);
        refTemp = str2double(tempCell{1});
        temp = str2double(tempCell{2});
        state = tempCell{3};
    end
end

function [enthalpy] = heatCapacity(component, refTemp, temp)
    enthalpy = 0;
    if refTemp == temp
        return
    end
    [matA, matB, matC, matD] = readvars('heatCapacity.xlsx', 'Range', 'C2:F62');
    
end

