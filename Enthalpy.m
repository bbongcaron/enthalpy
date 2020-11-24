function [] = enthalpy()
    [component, refTemp, state, temp, pressure] = userInput();
    if strcmpi(component, 'water') && refTemp == 0.01
        % case to be worked on later
    else
        enthalpy = heatCapacity(component, refTemp, temp, state)
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

function [enthalpy] = heatCapacity(component, refTemp, temp, state)
    enthalpy = 0;
    A = 0; B = 0; C = 0; D = 0;
    if refTemp == temp
        return
    end
%% Read in heatCapacity.xlsx data
    [matComp, matState, matA, matB, matC, matD, tUnits, matLowT, matHighT] = ...
        readvars('heatCapacity.xlsx', 'Range', 'A2:I62');
%% Linear search for the correct component O(n)
    for i = 1:length(matA)
        if strcmpi(component, matComp(i)) && strcmpi(state, matState(i))
            A = matA(i);
            if (~isnan(matB(i))); B = matB(i); end
            if (~isnan(matC(i))); C = matC(i); end
            if (~isnan(matD(i))); D = matD(i); end
            % Kelvin conversion if necessary
            if strcmpi(tUnits(i), 'K')
                temp = temp + 273.15;
                refTemp = refTemp + 273.15;
            end
            % Check if refTemp and temp are in acceptable temperature range
            if refTemp < matLowT(i) || temp < matLowT(i) ...
                    || refTemp > matHighT(i) || temp > matHighT(i)
                enthalpy = NaN;
                line1 = "One or more temperatures are outside valid " + ...
                    "temperature range for " + component + " " + ...
                    state + ":";
                line2 = "Reference Temperature : " + refTemp + tUnits(i);
                line3 = "Temperature : " + temp + tUnits(i);
                line4 = "Temperature Range : " + matLowT(i) + tUnits(i) ...
                    + " <= T <= " + matHighT(i) + tUnits(i);
                msgbox({line1;line2;line3;line4}, "Outside Valid Temperature Range!");
            end
            break
        end
    end
 %% Create heat capacity equation, solve for enthalpy
    syms T
    heatCap = A*T + B*T^2 + C*T^3 + D*T^4;
    enthalpy = double(int(heatCap, T, refTemp, temp));
end

