function varargout = layeredit(varargin)
% LAYEREDIT MATLAB code for layeredit.fig
%      LAYEREDIT, by itself, creates a new LAYEREDIT or raises the existing
%      singleton*.
%
%      H = LAYEREDIT returns the handle to a new LAYEREDIT or the handle to
%      the existing singleton*.
%
%      LAYEREDIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAYEREDIT.M with the given input arguments.
%
%      LAYEREDIT('Property','Value',...) creates a new LAYEREDIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before layeredit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to layeredit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help layeredit

% Last Modified by GUIDE v2.5 20-Nov-2017 16:47:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @layeredit_OpeningFcn, ...
                   'gui_OutputFcn',  @layeredit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%% handles
% --- handles

% layerbox
% addbutton1
% rembutton1
%
% rocksbox
% addbutton2
% rembutton2
% 
% changebutton1
% rockmenu
% thickbox
% 
% pcheckbox
% ptextbox
% 
% togglebutton1
% rheolcheckbox
% rheolbox
% 
% gdepmenu
% gsizebox

%% gui functions
    %ICRaTH
% --- Executes just before layeredit is made visible.
function layeredit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to layeredit (see VARARGIN)

    load rock;
    load planet;
    
    parse_script;
    % model in memory
    handles.model = model;
    nlay = size(model,2);
    for i = 1:nlay
        lyrnom(i) = "Layer " + i;
    end
    
    set(handles.layerbox,'String',lyrnom);
    set(handles.rockmenu,'String',{rock.name});
    
    % initialize
    set(handles.rockmenu,'Value',model(1).irock);
    set(handles.thickbox,'String',model(1).thick);
    set(handles.gsizebox,'Value',model(1).rock(1).gs);
    set(handles.pcheckbox,'Value',(model(1).pf=='p'));
    
    irk = model(1).irock(1);
    nrhl = size(rock(irk).rheol,2);
    % active rheologies
    for ia = 1:model(1).rock(1).nrheol
        rhla = model(1).rock(1).irheol(ia);
        if (rhla < 0)
            ibrit = [ibrit,-rhla];
            nbrit = nbrit+1;
        else
            iduct = [iduct,rhla];
            nduct = nduct+1;
        end
        
    end
    
    for i = 1:nrhl
        rhlnom(i) = i+"- "+rock(irk).rheol(i).ref;
        contained = ~isempty(find(model(1).rock(1).irheol==i));
        rhlchk(i) = "O";
        if (contained)
            rhlchk(i) = "X";
        end
    end
    handles.rheolX = rhlchk;
    set(handles.rheolbox,'String',rhlnom);
    set(handles.rheolcheckbox,'String',rhlchk);
    set(handles.togglebutton1,'Value',(rhlchk(i)=="X"));
    set(handles.gdepmenu,'String',["input",{rock(irk).piezo.ref}]);
    set(handles.gdepmenu,'Value',model(1).rock(1).gc+1);

% Choose default command line output for layeredit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes layeredit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = layeredit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in layerbox.
function layerbox_Callback(hObject, eventdata, handles)
% hObject    handle to layerbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns layerbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from layerbox
ilay = handles.layerbox.Value;
model = handles.model;
set(handles.rockmenu,'Value',model(ilay).irock);
set(handles.thickbox,'String',model(ilay).thick);

load rock;
set(handles.pcheckbox,'Value',1*(model(ilay).pf=='p'));

irk = model(ilay).irock(1);
nrhl = size(rock(irk).rheol,2);

for i = 1:nrhl
    rhlnom(i) = i+"- "+rock(irk).rheol(i).ref;
    contained = ~isempty(find(model(ilay).rock(1).irheol==i));
    rhlchk(i) = "O";
    if (contained)
        rhlchk(i) = "X";
    end
end
handles.rheolX = rhlchk;
set(handles.rheolbox,'String',rhlnom);
set(handles.rheolcheckbox,'String',rhlchk);
set(handles.togglebutton1,'Value',(rhlchk(i)=="X"));
set(handles.gdepmenu,'String',["input",{rock(irk).piezo.ref}]);
set(handles.gdepmenu,'Value',model(ilay).rock(1).gc+1);

%disp(handles.rockmenu);


% --- Executes during object creation, after setting all properties.
function layerbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layerbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rockmenu.
function rockmenu_Callback(hObject, eventdata, handles)
% hObject    handle to rockmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rockmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rockmenu



guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rockmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rockmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

    % CHANGE

% --- Executes on button press in changebutton1.
function changebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to changebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ilay = handles.layerbox.Value;

handles.model(ilay).irock = handles.rockmenu.Value;
handles.model(ilay).thick = handles.thickbox.String;

guidata(hObject, handles);


function thickbox_Callback(hObject, eventdata, handles)
% hObject    handle to thickbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thickbox as text
%        str2double(get(hObject,'String')) returns contents of thickbox as a double


guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function thickbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thickbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addbutton1.
function addbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ix = handles.layerbox.Value;
lst = handles.layerbox.String;
n = size(lst,1);
disp(n);
%handles.layerbox.String = [lst,'NewLayer'+handles.layerbox.Value];
set(handles.layerbox,'String',[lst;"NewLayer"+n]);

% --- Executes on button press in rembutton1.
function rembutton1_Callback(hObject, eventdata, handles)
% hObject    handle to rembutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ix = handles.layerbox.Value;
lst = handles.layerbox.String;
n = size(lst,1);
%handles.layerbox.String = [lst(1:ix-1),lst(ix+1:end)];

set(handles.layerbox,'String',[lst(1:ix-1);lst(ix+1:end)]);
if (ix == n)
    set(handles.layerbox,'Value',n-1);
end
if (n == 1)
    set(handles.layerbox,'Value',1);
end


% --- Executes on button press in pcheckbox.
function pcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to pcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pcheckbox


guidata(hObject, handles);

function ptextbox_Callback(hObject, eventdata, handles)
% hObject    handle to ptextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ptextbox as text
%        str2double(get(hObject,'String')) returns contents of ptextbox as a double


% --- Executes during object creation, after setting all properties.
function ptextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ptextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rocksbox.
function rocksbox_Callback(hObject, eventdata, handles)
% hObject    handle to rocksbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns rocksbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rocksbox


% --- Executes during object creation, after setting all properties.
function rocksbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rocksbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rheolcheckbox.
function rheolcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to rheolcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ix = handles.rheolcheckbox.Value;
set(handles.rheolbox,'Value',ix);
set(handles.rheolcheckbox,'ListboxTop',handles.rheolbox.ListboxTop);

% Hints: contents = cellstr(get(hObject,'String')) returns rheolcheckbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rheolcheckbox


% --- Executes during object creation, after setting all properties.
function rheolcheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rheolcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in rheolbox.
function rheolbox_Callback(hObject, eventdata, handles)
% hObject    handle to rheolbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ix = handles.rheolbox.Value;
set(handles.rheolcheckbox,'Value',ix);
set(handles.rheolcheckbox,'ListboxTop',handles.rheolbox.ListboxTop);
rhlchk = handles.rheolX;
set(handles.togglebutton1,'Value',1*(rhlchk(ix)=="X"));


% Hints: contents = cellstr(get(hObject,'String')) returns rheolbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rheolbox


% --- Executes during object creation, after setting all properties.
function rheolbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rheolbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ix = handles.rheolbox.Value;
rhlchk = handles.rheolX;
disp(handles.togglebutton1.Value);


% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in addbutton2.
function addbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rembutton2.
function rembutton2_Callback(hObject, eventdata, handles)
% hObject    handle to rembutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in gdepmenu.
function gdepmenu_Callback(hObject, eventdata, handles)
% hObject    handle to gdepmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns gdepmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gdepmenu


% --- Executes during object creation, after setting all properties.
function gdepmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gdepmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gsizebox_Callback(hObject, eventdata, handles)
% hObject    handle to gsizebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gsizebox as text
%        str2double(get(hObject,'String')) returns contents of gsizebox as a double


% --- Executes during object creation, after setting all properties.
function gsizebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gsizebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% handles

%gsizebox
%gdepmenu
%addbutton1
%rembutton1
%addbutton2
%rembutton2
%changebutton1
%togglebutton1
%rheolbox
%rheolcheckbox
%pcheckbox
%ptextbox
%layerbox
%rockmenu
%rocksbox
%thickbox
