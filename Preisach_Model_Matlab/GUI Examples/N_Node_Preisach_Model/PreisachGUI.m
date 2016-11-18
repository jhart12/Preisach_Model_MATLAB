function varargout = PreisachGUI(varargin)
% PREISACHGUI MATLAB code for PreisachGUI.fig
%      PREISACHGUI, by itself, creates a new PREISACHGUI or raises the existing
%      singleton*.
%
%      H = PREISACHGUI returns the handle to a new PREISACHGUI or the handle to
%      the existing singleton*.
%
%      PREISACHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREISACHGUI.M with the given input arguments.
%
%      PREISACHGUI('Property','Value',...) creates a new PREISACHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PreisachGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PreisachGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PreisachGUI

% Last Modified by GUIDE v2.5 21-Sep-2014 17:57:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PreisachGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @PreisachGUI_OutputFcn, ...
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


% --- Executes just before PreisachGUI is made visible.
function PreisachGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PreisachGUI (see VARARGIN)

% Choose default command line output for PreisachGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PreisachGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%read in data from GUI
n=get(handles.nInput,'String');
a0=get(handles.InputMaxa,'String');
regular=get(handles.RegularButton,'Value');
n=str2double(n);
a0=str2double(a0);
%do first computation
uNew=-a0;
mu=generateMu(n,a0,regular);
f=NewDiscretePreisach(uNew,mu,n);
set(handles.OutputText,'String',f);
set(handles.slider,'Max',a0);
set(handles.slider,'Min',-a0);
set(handles.slider,'Value',-a0);
set(handles.InputBox,'String',-a0);

%store data we will need in future
handles.count=1;
handles=storeData(n,a0,regular,f,uNew,mu,handles);

%plot on Preisach graph
handles=PreisachPlot(handles);

%plot on I/0 graph
handles=plotIOGraph(handles);

% --- Outputs from this function are returned to the command line.
function varargout = PreisachGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press "REFRESH" ---
function RefreshButton_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Refresh Preisach Model
%read in data from GUI
n=get(handles.nInput,'String');
n=str2double(n);
a0=get(handles.InputMaxa,'String');
a0=str2double(a0);
regular=get(handles.RegularButton,'Value');
%do first computation
uNew=-a0;
mu=generateMu(n,a0,regular);
f=NewDiscretePreisach(uNew,mu,n);
set(handles.OutputText,'String',f);
set(handles.slider,'Max',a0);
set(handles.slider,'Min',-a0);
set(handles.slider,'Value',-a0);
set(handles.InputBox,'String',-a0);

%store data we will need in future
handles.count=1;
handles=storeData(n,a0,regular,f,uNew,mu,handles);

%plot on Preisach graph
hold(handles.PreisachGraph,'off')
handles=PreisachPlot(handles);

%plot on I/0 graph
hold(handles.IOGraph,'off')
handles=plotIOGraph(handles);

% --- Executes on slide ---
function slider_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes input, updates model
% get input from GUI slider
handles.count=handles.count+1;
handles.uNew(handles.count)=get(handles.slider,'Value');
set(handles.InputBox,'String',handles.uNew(handles.count));
%update model
[handles.f(handles.count),handles.mu]=DiscretePreisach(handles.count,handles.uNew,handles.mu,handles.n);
set(handles.OutputText,'String',handles.f(handles.count));
%update plots
%---plot on Preisach graph---
%sort mu
a0=handles.a0;
countOn=0;
countOff=0;
N=handles.n*(handles.n+1)/2;
mu=handles.mu;
for i=1:N
    if mu(3,i)==1
        countOn=countOn+1;
        muOn(1,countOn)=mu(1,i);
        muOn(2,countOn)=mu(2,i);
    else
        countOff=countOff+1;
        muOff(1,countOff)=mu(1,i);
        muOff(2,countOff)=mu(2,i);
    end
end
if exist('muOn','var') %if any hysterons are 'up' or 'on,' plot them
plot(handles.PreisachGraph,muOn(2,:),muOn(1,:),'xb','MarkerSize',14)
axis(handles.PreisachGraph,[-a0 a0 -a0 a0]);
hold(handles.PreisachGraph,'on')
end
if exist('muOff','var') %if any hysterons are 'down' or 'off,' plot them
plot(handles.PreisachGraph,muOff(2,:),muOff(1,:),'xr','MarkerSize',14)
axis(handles.PreisachGraph,[-a0 a0 -a0 a0]);
xlabel(handles.PreisachGraph,'\beta','FontSize',16)
ylabel(handles.PreisachGraph,'\alpha','FontSize',16)
xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') + [0 .01 0])
xlabh = get(gca,'YLabel');
set(xlabh,'Position',get(xlabh,'Position') + [.05 0 0])
hold(handles.PreisachGraph,'on')
end
%plot line to let user see the input on Preisach Graph
if handles.uNew(handles.count)>handles.uNew(handles.count-1) %if input is increasing
plot([-a0 a0],[handles.uNew(handles.count) handles.uNew(handles.count)],'c','LineWidth',4) %horizontal line
else %if input decreasing
plot([handles.uNew(handles.count) handles.uNew(handles.count)],[-a0 a0],'c','LineWidth',4) %vertical line
end
plot([-1 1],[-1 1],'k')
hold(handles.PreisachGraph,'off')
%plot on I/0 graph
handles=plotIOGraph(handles);

% --- Executes on button press "CLEAR GRAPH" ---
function ClearGraph_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Clear IO Graph (but keep current state of system stored)
hold(handles.IOGraph,'off')
handles.uNew=handles.uNew(handles.count);%store the current input
handles.f=handles.f(handles.count); %store the current output
handles.count=1; %reset the counter
handles=plotIOGraph(handles);

function [handles]=PreisachPlot(handles)
%plot Preisach graph
a0=handles.a0;
mu=handles.mu;
plot(handles.PreisachGraph,mu(2,:),mu(1,:),'xr','MarkerSize',14)
hold(handles.PreisachGraph,'on')
axis(handles.PreisachGraph,[-a0 a0 -a0 a0]);
plot([-1 1],[-1 1],'k')
xlabel(handles.PreisachGraph,'\beta','FontSize',16)
ylabel(handles.PreisachGraph,'\alpha','FontSize',16)
xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') + [0 .01 0])
xlabh = get(gca,'YLabel');
set(xlabh,'Position',get(xlabh,'Position') + [0.05 0 0])
hold(handles.PreisachGraph,'off')

function [handles]=storeData(n,a0,regular,f,uNew,mu,handles)
%store data we will need in future in GUI handle
handles.n=n;
handles.a0=a0;
handles.regular=regular;
handles.f=f;
handles.uNew=uNew;
handles.mu=mu;

function [handles]=plotIOGraph(handles)
%plots input-output graph (hysteresis graph)
a0=handles.a0;
N=handles.n*(handles.n+1)/2;
plot(handles.IOGraph,handles.uNew,handles.f,'k')
axis(handles.IOGraph,[-a0 a0 -N N]);
xlabel(handles.IOGraph,'Input','FontSize',14)
ylabel(handles.IOGraph,'Output','FontSize',14)
xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') + [0 .01 0])
xlabh = get(gca,'YLabel');
set(xlabh,'Position',get(xlabh,'Position') + [.05 0 0])
hold(handles.IOGraph,'on')
guidata(gcf,handles);