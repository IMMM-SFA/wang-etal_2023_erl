_your zenodo badge here_

# wang-etal_2022_jc

**Decipher the sensitivity of urban canopy air temperature to anthropogenic heat flux with a forcing-feedback framework**

Linying Wang<sup>1\*</sup> and Dan Li<sup>1\*</sup>

<sup>1 </sup> Department of Earth and Environment, Boston University, 685 Commonwealth Avenue, Boston, MA 02215, USA 

\* corresponding author:  lidan@bu.edu

## Abstract
Energy consumption is increasing strikingly with population and economic development. The emitted aAnthropogenic heat flux is an important control of the urban thermal environmentA vital heating mechanism for the urban environment and can exacerbate the heat stress that threatens public health. Due to the intrinsic complexities of land-atmosphere interactions and feedback mechanisms, Although tthe sensitivity of urban canopy air temperature (T_a) warming to anthropogenic heat flux (i.e., ∆T_a/Q_AH) varies is known to vary greatly with space and time, and the key factors controlling such variabilities remains elusive. Based on the urban climate model CLMU simulations In this study, we employ develop a forcing-feedback framework based on the energy budget of the urban canopy layer (UCL) air to evaluate ∆T_a/Q_AHand apply it to diagnosing ∆T_a/∆Q_AH simulated by the Community Land Model Urban (CLMU), where ∆ represents a change and the involved feedback processes over the Contiguous United States. While the direct effect of Q_AH is to increase T_a, there are important This framework is developed based on the urban canopy layer (UCL) air energy budget, which is similar to the global climate sensitivity analysis based on top-of-atmosphere energy balance. Key feedbacks mechanisms are identified to be associated with changes in surface temperatures and the atmosphere-canopy air heat conductance (c_a). In summer, the positive feedbacks and negative feedbacks nearly cancel each other and hence the sensitivity ∆T_a/∆Q_AH is mostly controlled by the direct effect. In winter, hHowever, due to weakened negative feedback during wintertime, the total feedback effect enhances sensitivity ∆T_a/∆Q_AH is enhanced by 15% compared to the direct effect. We also find that the spatiotemporal variability of ∆T_a/∆Q_AH is highly related tocorrelated with the variability of c_a. A weaker solar radiation and a lower wind speed could decreasereduce the buoyancy flux effect and friction stressfriction velocity within UCL, leading a more stable conditionless turbulent transport of heat and thus a smaller c_a. As a result, ∆T_a/∆Q_AH is thus larger in the morning at diurnal scales and even enhanced by positive feedback effectsand in winter at seasonal scales. The results suggest that the framework may help improve our understanding of the physical processes involved in how anthropogenic heat influences urban climate and human health.

## Journal reference

## Code reference

## Data reference

### Input data

### Output data

## Contributing modeling software
| Model | Version | Repository Link | DOI |
|-------|---------|-----------------|-----|
| CESM2 | release-cesm2.0.1 | https://github.com/ESCOMP/CESM/releases/tag/release-cesm2.0.1 |  |
| CLM5 | release-cesm2.0.02 | https://github.com/ESCOMP/CTSM/tree/release-cesm2.0.02 |  |

## Reproduce my experiment

1. Install the software components required to conduct the experiement from [Contributing modeling software](#contributing-modeling-software)
2. Download and install the supporting input data required to conduct the experiement from [Input data](#input-data)
3. Run the following scripts in the `workflow` directory to re-create this experiment:

| Script Name | Description | How to Run |
| --- | --- | --- |
| `step_one.py` | Script to run the first part of my experiment | `python3 step_one.py -f /path/to/inputdata/file_one.csv` |
| `step_two.py` | Script to run the last part of my experiment | `python3 step_two.py -o /path/to/my/outputdir` |

4. Download and unzip the output data from my experiment [Output data](#output-data)
5. Run the following scripts in the `workflow` directory to compare my outputs to those from the publication

| Script Name | Description | How to Run |
| --- | --- | --- |
| `compare.py` | Script to compare my outputs to the original | `python3 compare.py --orig /path/to/original/data.csv --new /path/to/new/data.csv` |

## Reproduce my figures
Use the scripts found in the `figures` directory to reproduce the figures used in this publication.

| Script Name | Description | How to Run |
| --- | --- | --- |
| `generate_figures.py` | Script to generate my figures | `python3 generate_figures.py -i /path/to/inputs -o /path/to/outuptdir` |
