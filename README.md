# Preisach_Model_MATLAB

This contains a MATLAB implementation of the discrete Preisach model of hysteresis. It includes two GUI based tutorial introductions, a direct implementation of the discrete Preisach model, and an implementation of the Preisach model in modeling a simple dynamical system: a driven iron pendulum in the presence of a magnetic field.

##Dependencies
MATLAB is the only required software. Most universities offer free student editions of MATLAB.

##Install
No installation is necessary. Simply open up the downloaded directory in MATLAB.

##GUI Tutorials
The GUI tutorials are done in MATLAB's GUIDE (GUI development environment).

#####1. Three Node Preisach Model
This is the simplest introductory tutorial to the Preisach model of hysteresis. It considers a Preisach model with only three hysterons. It is useful for introducing the very basics of how individual hysterons behave, and how a simple linear combination of hysterons can lead to more complicated hysteretic behavior. It also helps with understanding the geometrical interpretation of the Preisach model.

In order to open up the tutorial, first navigate to the directory in MATLAB: GUI Examples/Three_Node_Preisach_Model. Then right-click on Preisach3Node.fig and click Open in GUIDE. Finally, click on the "play" symbol (green triangle) in the figure window to run the GUI.

The left column of figures shows the input-output relations for 3 different hysterons. The red dot shows the current state of the hysteron.

The bottom-right figure is the alpha-beta plane from the geometrical interpretation of the Preisach model. Each 'X' indicates the alpha and beta values of a single hysteron. There are 3 'X's: one for each of the 3 input-output relations shown in the left column. A red 'X' indicates a hysteron in the '-1' state, while a blue 'X' denotes a hysteron in the '+1' state.

The top-right figure is a plot of the output vs. input for the Preisach model consisting of these 3 hysterons. 

The user can vary the input to the Preisach model using the slide bar. The input to all of the hysterons will change simultaneously, so the user can see that the hysterons change state at different values of input. In the geometric interpretation, the user can see the horizontal or vertical line that "turns on or off" the hysterons depending on whether the input is increasing or decreasing. The user can see a hysteresis loop form in the input-output figure as the input is cycled.

The RESET button can be pressed in order to clear the plots and reset to the original configuration.

The RANDOM button can be pressed in order to randomly choose the alpha and beta threshold values. Once pressed, the RANDOM button will change to REGULAR. This button will then return the hysterons to the original regularly spaced ones. Each time the RANDOM button is pressed, a new set of alpha and beta values will be chosen.

####2. N Node Preisach Model
This is a slightly more advanced GUI tutorial. It allows the user to input a number n, and it will generate a Preisach model with N=n*(n+1)/2 hysterons. This tutorial is similar to the previous tutorial, but it allows the user to test how changing the number of hysterons affects the resulting hysteresis loop. Since this tutorial allows for more than 3 hysterons, the user can see how the Preisach model generates memory and how the minor hysteresis loops work.

In order to open up the tutorial, first navigate to the directory in MATLAB: GUI Examples/N_Node_Preisach_Model. Then right-click on PreisachGUI.fig and click Open in GUIDE. Finally, click on the "play" symbol (green triangle) in the figure window to run the GUI.

##Functions
```
f = iteratePreisach(u,mu)
```
This function performs the Preisach operator corresponding to a given hysteron density mu for a given input value u. It remembers the previous input value. The scalar Preisach output f is returned.

####Inputs
u - the scalar input to the Preisach model
mu - 3 x N matrix. mu(1,i) is the beta value of the ith hysteron.
                   mu(2,i) is the alpha value of the ith hysteron.
                   mu(3,i) is the weight given to the ith hysteron.
                   N is the total number of hysterons.
                   
```
generateTestMu(n,a0,regular?)
```
Returns density function mu of regularly or randomly distributed hysterons.
The output mu matrix can then input to iteratePreisach.m. The function
normalizes mu so that the Preisach output is in the range [-1,1].

####Inputs
n - number of hysterons on a side; N=n*(n+1)/2
a0 - maximum value of a
regular? - boolean that determines whether user wants Regular or Random
          placement of hysterons in a and b
          
####Outputs  
mu - 3 x N matrix. mu(1,i) is the beta value of the ith hysteron.
                   mu(2,i) is the alpha value of the ith hysteron.
                   mu(3,i) is the weight given to the ith hysteron.
                   N is the total number of hysterons.
                   
```
[t,x] = ironPendulum(a,b,drive,T,dt,mu)
```
Simulates a damped, driven iron pendulum in the presence of a magnetic field.
The magnetic field is built in to the Preisach density function mu.

The equation we numerically integrate is: d2x/dt2 + a(dx/dt) + x = drive(t) + b*Px,
where P is the preisach model with input x

####Inputs
a - damping coefficient of pendulum
b - strength of the hysteresis nonlinearity
drive - vector representing the signal used to drive the pendulum
dt - the Euler time step (and also the time step of the drive signal vector)
T - the final time
mu - 3 x N matrix. mu(1,i) is the beta value of the ith hysteron.
                   mu(2,i) is the alpha value of the ith hysteron.
                   mu(3,i) is the weight given to the ith hysteron.
                   N is the total number of hysterons.

####Outputs
t - vector of times at which each x value occurs
x - vector of positions of the pendulum

                   
       



