# Final_project

[![Build Status](https://github.com/Zijiaa/amazing_final_project.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/Zijiaa/amazing_final_project.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This is a final project for econ 622 to replicate Hsieh, C.-T., Hurst, E., Jones, C.I. and Klenow, P.J. (2019), The Allocation of Talent and U.S. Economic Growth. Econometrica, 87: 1439-1474. https://doi.org/10.3982/ECTA11427

This project is used as a personal practice for julia

---Updated 2022-12-16---

The original project contains 23 main modules and nearly 300 self-created sub-functions.

So far, the calibration part, which corresponds to Section 3 in the paper, has been all done. 

The modules should be run in the following order:

Names67Occupations

SetParameters

ShowParameters

ReadCohortData

LookatCohortData ( ols(vdummy,packr) , fixmissig, chadminus)
