## This is the directory to place scripts or instructions in for recreating your experiment 

Four numerical experiments are designed to quantify how the canopy air temperature responds to a prescribed increase of anthropogenic heat flux. To modify the added anthropogenic heat flux into the urban canopy air heat budget, modify "Qanthro" in UrbanFluxesMod.F90 which is located in greenroof_version2.3.2.
In CTL case, Qanthro = 0;
In AH1 case, Qanthro = 1;
In AH10 case, Qanthro = 10;
In AH100 case, Qanthro = 100.

