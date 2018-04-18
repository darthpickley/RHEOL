# RHEOL
VERSION 1:
Matlab code for calculating strength profiles and their evolution

Rheologies dataset build by build_rock.m, store in matlab matrix
Driver code is StrengthProfile.m; calls other codes and datasets

Some features may be broken right now. Especially, multiphase mixing is not currently operating. Keep one rock per layer!

VERSION 2 features:

parse_script -- reads a model from text file (input_file.txt)
save_script  -- outputs the current model to text file (out_file.txt)

layeredit -- graphical user interface

VERSION 3 features:

layeredit has full functionality
graphical interface for displaying the current rheological profile
