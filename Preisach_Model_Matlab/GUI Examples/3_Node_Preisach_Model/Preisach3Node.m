function varargout = Preisach3Node(varargin)
% PREISACH3NODE MATLAB code for Preisach3Node.fig
%      PREISACH3NODE, by itself, creates a new PREISACH3NODE or raises the existing
%      singleton*.
%
%      H = PREISACH3NODE returns the handle to a new PREISACH3NODE or the handle to
%      the existing singleton*.
%
%      PREISACH3NODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREISACH3NODE.M with the given input arguments.
%
%      PREISACH3NODE('Property','Value',...) creates a new PREISACH3NODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Preisach3Node_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Preisach3Node_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Preisach3Node

% Last Modified by GUIDE v2.5 14-Oct-2014 21:57:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Preisach3Node_OpeningFcn, ...
                   'gui_OutputFcn',  @Preisach3Node_OutputFcn, ...
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


% --- The code in the section executes just before Preisach3Node is made visible.
function Preisach3Node_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Preisach3Node (see VARARGIN)

% Choose default command line output for Preisach3Node
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%initialize variables
handles.n=2;%number of hysterons per side
handles.N=handles.n*(handles.n+1)/2;%total number of hysterons
handles.a0=1;
handles.uNew(1)=-handles.a0;
handles.uNew(2)=-handles.a0;
handles.mu=generateMu(handles.n,handles.a0,1);
handles.f=NewDiscretePreisach(handles.uNew(1),handles.mu,handles.n);
handles.f(2)=handles.f;
handles.count=2;

%initialize slider
set(handles.slider,'Max',handles.a0);
set(handles.slider,'Min',-handles.a0);
set(handles.slider,'Value',-handles.a0);

%plot on hysteron graphs
handles=hysteronPlot(handles);

%plot on Preisach graph
handles=PreisachPlot(handles);

%plot on I/0 graph
handles=plotIOGraph(handles);

guidata(gcf,handles) %store variables



% --- Outputs from this function are returned to the command line.
function varargout = Preisach3Node_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press Refresh.
function Refresh_Callback(hObject, eventdata, handles)
% hObject    handle to Refresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Refresh Preisach Model
%do first computation
a0=handles.a0;
uNew=-a0;

handles.uNew=-a0;
handles.uNew(2)=-a0;
handles.mu=generateMu(handles.n,handles.a0,strcmp(get(handles.Distribution,'String'),'Random'));
handles.f=NewDiscretePreisach(uNew,handles.mu,handles.n);
handles.f(2)=handles.f;
set(handles.slider,'Max',a0);
set(handles.slider,'Min',-a0);
set(handles.slider,'Value',-a0);

%store data we will need in future
handles.count=2;
guidata(gcf,handles);
%plot on Preisach graph
hold(handles.PreisachGraph,'off')
handles=PreisachPlot(handles);

%plot on I/0 graph
hold(handles.IOGraph,'off')
handles=plotIOGraph(handles);

%plot on hysteron graphs
handles=hysteronPlot(handles);

guidata(gcf,handles); %save info


% --- Executes on slide ---
function slider_Callback(hObject,eventdata,handles)
% hObject    handle to pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Changes input, updates model
% get input from GUI slider
handles.count=handles.count+1;
handles.uNew(handles.count)=get(handles.slider,'Value');
%update model
[handles.f(handles.count),handles.mu]=DiscretePreisach(handles.count,handles.uNew,handles.mu,handles.n);
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
hold(handles.PreisachGraph,'on')
end
%plot line to let user see the input on Preisach Graph
if handles.uNew(handles.count)>handles.uNew(handles.count-1) %if input is increasing
plot([-a0 a0],[handles.uNew(handles.count) handles.uNew(handles.count)],'c','LineWidth',4) %horizontal line
else %if input decreasing
plot([handles.uNew(handles.count) handles.uNew(handles.count)],[-a0 a0],'c','LineWidth',4) %vertical line
end
plot([-1 1],[-1 1],'k')
plot(handles.PreisachGraph,handles.uNew(handles.count),handles.uNew(handles.count),'or','MarkerFaceColor','r','MarkerSize',7)
hold(handles.PreisachGraph,'off')
%plot on I/0 graph
handles=plotIOGraph(handles);

guidata(gcf,handles);

%plot hysteron graph
handles=hysteronPlot(handles);

guidata(gcf,handles); %save info

% --- Executes on button press Distribution (RANDOM or REGULAR).
function Distribution_Callback(hObject, eventdata, handles)
% hObject    handle to Distribution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a0=handles.a0;
str=get(handles.Distribution,'String');
if strcmp(str,'Regular')
    set(handles.Distribution,'String','Random')
    handles.mu=generateMu(handles.n,handles.a0,1);
end
if strcmp(str,'Random')
    set(handles.Distribution,'String','Regular')
    handles.mu=generateMu(handles.n,handles.a0,0);
end

handles.uNew=-a0;
handles.uNew(2)=-a0;
handles.count=2;
handles.f=NewDiscretePreisach(handles.uNew(1),handles.mu,handles.n);
handles.f(2)=handles.f;
set(handles.slider,'Max',a0);
set(handles.slider,'Min',-a0);
set(handles.slider,'Value',-a0);

%plot on Preisach graph
hold(handles.PreisachGraph,'off')
handles=PreisachPlot(handles);

%plot on I/0 graph
hold(handles.IOGraph,'off')
handles=plotIOGraph(handles);

%plot on hysteron graph
hold(handles.IOGraph,'off')
handles=hysteronPlot(handles);
guidata(gcf,handles);

%-----INTERNAL FUNCTIONS-----

function [handles]=hysteronPlot(handles)
%plot individual hysteron graphs
%plot 1
uNew=handles.uNew(handles.count);
uOld=handles.uNew(handles.count-1);
mu=handles.mu;
a0=handles.a0;
plot(handles.h1,[-a0 mu(1,1)],[-1 -1],'k',[mu(2,1) a0],[1 1],'k',[mu(1,1) mu(1,1)],[-1 1],'k',[mu(2,1) mu(2,1)],[-1 1],'k');
hold(handles.h1,'on')
if (uNew>=uOld && uNew>=mu(1,1))
plot(handles.h1,uNew,1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
elseif (uNew>=uOld && uNew<mu(1,1))
plot(handles.h1,uNew,-1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
elseif (uNew<uOld && uNew<=mu(2,1))
plot(handles.h1,uNew,-1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')       
else
plot(handles.h1,uNew,1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
end
ylim(handles.h1,[-a0-.3 a0+.3])
ylabel(handles.h1,'Output','FontSize',16)
hold(handles.h1,'off')
set(gca,'xtick',[])
%plot 2
plot(handles.h2,[-a0 mu(1,2)],[-1 -1],'k',[mu(2,2) a0],[1 1],'k',[mu(1,2) mu(1,2)],[-1 1],'k',[mu(2,2) mu(2,2)],[-1 1],'k');
hold(handles.h2,'on')
if (uNew>=uOld && uNew>=mu(1,2))
plot(handles.h2,uNew,1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
elseif (uNew>=uOld && uNew<mu(1,2))
plot(handles.h2,uNew,-1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
elseif (uNew<uOld && uNew<=mu(2,2))
plot(handles.h2,uNew,-1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')       
else
plot(handles.h2,uNew,1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
end
ylim(handles.h2,[-a0-.3 a0+.3])
ylabel(handles.h2,'Output','FontSize',16)
hold(handles.h2,'off')
set(gca,'xtick',[])
%plot 3
plot(handles.h3,[-a0 mu(1,3)],[-1 -1],'k',[mu(2,3) a0],[1 1],'k',[mu(1,3) mu(1,3)],[-1 1],'k',[mu(2,3) mu(2,3)],[-1 1],'k');
hold(handles.h3,'on')
if (uNew>=uOld && uNew>=mu(1,3))
plot(handles.h3,uNew,1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
elseif (uNew>=uOld && uNew<mu(1,3))
plot(handles.h3,uNew,-1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
elseif (uNew<uOld && uNew<=mu(2,3))
plot(handles.h3,uNew,-1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')       
else
plot(handles.h3,uNew,1,'MarkerSize',7,'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o')
end
ylim(handles.h3,[-a0-.3 a0+.3])
xlabel(handles.h3,'Input','FontSize',16)
ylabel(handles.h3,'Output','FontSize',16)
hold(handles.h3,'off')

function [handles]=PreisachPlot(handles)
%plot Preisach graph
a0=handles.a0;
mu=handles.mu;
plot(handles.PreisachGraph,mu(2,:),mu(1,:),'xr','MarkerSize',14)
hold(handles.PreisachGraph,'on')
axis(handles.PreisachGraph,[-a0 a0 -a0 a0]);
plot([-1 1],[-1 1],'k')
plot(handles.PreisachGraph,handles.uNew,handles.uNew,'or','MarkerFaceColor','r','MarkerSize',7)
xlabel(handles.PreisachGraph,'\beta','FontSize',16)
ylabel(handles.PreisachGraph,'\alpha','FontSize',16)
hold(handles.PreisachGraph,'off')

function [handles]=plotIOGraph(handles)
%plots input-output graph (hysteresis graph)
a0=handles.a0;
plot(handles.IOGraph,handles.uNew,handles.f,'k')
axis(handles.IOGraph,[-a0 a0 -handles.N-0.5 handles.N+0.5]);
xlabel(handles.IOGraph,'Input','FontSize',16)
ylabel(handles.IOGraph,'Output','FontSize',16)
hold(handles.IOGraph,'on')
