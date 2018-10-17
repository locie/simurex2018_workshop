#%% These are some imports and function we will need
import numpy as np
from scipy.linalg import expm
from numpy.linalg import inv

def dot3(A,B,C):
    return np.dot(A, np.dot(B,C))
    
def stack4(A,B,C,D):
    return np.vstack((np.hstack((A,B)), np.hstack((C,D))))

#%% Importing the data
"""
In this example, data is contained in a file called data.csv with labeled columns
You should of course adapt this section to your case
"""
import pandas
dataset = pandas.read_csv('ArmadilloData.csv')

time_ = np.array(dataset['Time'])
T_in  = np.array(dataset['T_int'])  # indoor temperature
T_ext = np.array(dataset['T_ext'])  # outdoor temperature
P_hea = np.array(dataset['P_hea'])  # indoor prescribed heat (W)
I_sol = np.array(dataset['I_sol'])  # solar irradiance  (W/m2)

delta_t = time_[1] - time_[0]       # time step size
u = np.vstack([T_ext ,P_hea, I_sol]).T
y = T_in

#%% Definition of a simple deterministic model
"""
This is the simulation function of the very simple 2R2C model
This class is extendable to any other RC model structure
"""
def RC_model_deterministic(u, R1, R2, C1, C2, k1, k2, xe_0):
    
    # Matrices of the system in continuous form
    Ac = np.array([[-1/(C1*R1)-1/(C1*R2), 1/(C1*R2)],
                   [1/(C2*R2), -1/(C2*R2)]])
    Bc = np.array([[1/(C1*R1), 0, k1/C1],
                   [0, 1/C2, k2/C2]])
    n = 2   # number of states
    # Matrices of the discretized state-space model
    F = expm(Ac*delta_t)
    G = dot3(inv(Ac), F-np.eye(n), Bc)
    H = np.array([[0, 1]])
    
    # Initialisation of the states
    x = np.zeros((len(u), n))
    x[0] = np.array((xe_0, T_in[0]))
    
    # Simulation
    for i in range(1,len(u)):
        x[i] = np.dot(F, x[i-1]) + np.dot(G, u[i-1])
    
    # This function returns the second simulated state only
    return np.dot(H, x.T).flatten()

#%% Curve fitting
"""
This section evaluates the parameters of the model using observations T_int
Note that the initial condition on the unobserved state is an unknown parameter

You should provide an initial guess for the parameters
initial guess for resistances R1 and R2: 1e-2 W/K
initial guess for capacitances C1 and C2: 1e7 J/K
initial guess for solar coefficients k1 and k2: 0.5 m2
initial guess for the initial envelope temperature: 20 C
"""    

from scipy.optimize import curve_fit

theta_init = [1e-2, 1e-2, 1e7, 1e7, 0.5, 0.5, 20]
popt, pcov = curve_fit(RC_model_deterministic,
                       xdata = u,
                       ydata = T_in,
                       p0 = theta_init,
                       method='lm')

# Calculating the indoor temperature predicted with the optimal parameters
T_in_det = RC_model_deterministic(u, popt[0], popt[1], popt[2], popt[3], popt[4], popt[5], popt[6])
# Least square criterion for the optimal parameters
r_opt = np.sum((T_in_det-T_in)**2)


#%% Test for parameter significance and correlation

# Standard deviation of the parameter estimates
stdev = np.diag(pcov)**0.5
# Correlation matrix
R = dot3( np.linalg.inv(np.diag(stdev)), pcov, np.linalg.inv(np.diag(stdev)))
# t-statistic
t_stat = popt / stdev

#%% Plotting curve fitting results

import matplotlib.pyplot as plt
plt.rc('font', **{'family' : 'serif', 'size'   : 14 })

plt.figure()
plt.plot(time_/24/3600, T_in, '-k', linewidth=1.5, label='Observation')
plt.plot(time_/24/3600, T_in_det, '-r', linewidth=1.5, label='Fitted deterministic model')
plt.xlabel('Time (days)')
plt.ylabel('Indoor temperature')
plt.legend()
plt.show()

#%% Now let's try with a stochastic model and a Kalman filter

def RC_model_stochastic(u, R1, R2, C1, C2, k1, k2, xe_0, q1, q2, r):

    # Matrices of the continuous model
    Ac = np.array([[-1 / (C1 * R1) - 1 / (C1 * R2), 1 / (C1 * R2)],
                   [1 / (C2 * R2), -1 / (C2 * R2)]])
    Bc = np.array([[1 / (C1 * R1), 0, k1 / C1],
                   [0, 1 / C2, k2 / C2]])

    n = 2       # number of states
    t = len(u)  # number of data points

    # Matrices of the discretized state-space model
    F = expm(Ac * delta_t)
    G = dot3(inv(Ac), F - np.eye(n), Bc)
    H = np.array([[0, 1]])

    # Discretized system noise
    Qc = np.diag([q1 ** 2, q2 ** 2])
    foo = expm(stack4(-Ac, Qc, np.zeros(np.shape(Ac)), Ac.T) * delta_t)
    Q = np.dot(foo[n:2 * n, n:2 * n].T, foo[0:n, n:2 * n])

    # Discretized measurement noise
    Rc = np.array([[r ** 2]])
    R = Rc / delta_t

    # Initialisation
    x_0 = np.array((xe_0, T_in[0]))
    P_0 = np.eye(2)

    # Initialisation of blank arrays to save states, errors, etc.
    x_predict = np.zeros((t, n))
    P_predict = np.zeros((t, n, n))
    x_predict[0] = x_0
    P_predict[0] = P_0

    x_update = np.zeros((t, n))
    P_update = np.zeros((t, n, n))
    x_update[0] = x_0
    P_update[0] = P_0

    epsilon = np.zeros(t)  # prediction errors (innovations)
    Sigma = np.zeros(t)  # innovation covariances

    for i in range(1, t):

        # Predict
        x_predict[i] = np.dot(F, x_update[i - 1]) + np.dot(G, u[i - 1])
        P_predict[i] = dot3(F, P_update[i - 1], F.T) + Q

        # Residuals and Kalman gain
        epsilon[i] = y[i] - np.dot(H, x_predict[i])
        foo = dot3(H, P_predict[i], H.T) + R
        Sigma[i] = foo
        K = dot3(P_predict[i], H.T, np.linalg.inv(foo))

        # Update
        x_update[i] = x_predict[i] + np.dot(K, y[i] - np.dot(H, x_predict[i]))
        P_update[i] = P_predict[i] - dot3(K, H, P_predict[i])

    X = np.dot(H, x_predict.T).flatten()
    S = Sigma

    return X

theta_init = [1e-2, 1e-2, 1e7, 1e7, 0.5, 0.5, 20, 0.1, 0.1, 0.1]
popt2, pcov2 = curve_fit(RC_model_stochastic,
                         xdata = u,
                         ydata = T_in,
                         p0 = theta_init,
                         method='lm')

#%% Now let's compare the two models

T_in_sto = RC_model_stochastic(u, popt2[0], popt2[1], popt2[2], popt2[3], popt2[4], popt2[5], popt2[6], popt2[7], popt2[8], popt2[9])

plt.figure()
plt.plot(time_/24/3600, T_in, '-k', linewidth=1.5, label='Observation')
plt.plot(time_/24/3600, T_in_sto, '-b', linewidth=1.5, label='Fitted stochastic model')
plt.xlabel('Time (days)')
plt.ylabel('Indoor temperature')
plt.legend()
plt.show()

#%% Let's compare both models (deterministic vs stochastic)

# First we can visualize parameter estimates and their error bar
parameter_list = ['R1', 'R2', 'C1', 'C2', 'k1', 'k2', 'x_0']

ind = [1, 2]    # the x locations for the groups
width = 0.3       # the width of the bars: can also be len(x) sequence

plt.figure()
plt.title('Estimation of R1 and R2')
# plt.bar(ind, [theta_det, theta_sto], width, yerr=[theta_det_std, theta_sto_std])
p1 = plt.bar(ind, [popt[0], popt2[0]], width, yerr=[pcov[0,0]**0.5*2, pcov2[0,0]**0.5*2])
p2 = plt.bar(ind, [popt[1], popt2[1]], width, bottom = [popt[0], popt2[0]], yerr=[pcov[1,1]**0.5*2, pcov2[1,1]**0.5*2])
plt.xticks(ind, ['Deterministic', 'Stochastic'])
plt.legend((p1[0], p2[0]), ('R1', 'R2'))
plt.show()

#%% We can also compare residuals

plt.figure()
plt.plot(T_in-T_in_det, '-r', linewidth=1.5, label='Deterministic')
plt.plot(T_in-T_in_sto, '-b', linewidth=1.5, label='Stochastic')
plt.show()