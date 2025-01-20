# Author: Nazanin Ahmadi  
# Contact: Nazanin@brown.edu

# This script calculates descriptive statistics and performs a two-sample t-test for the percentage
# of age groups in Type 1 and Type 2 diabetes. The input data is read from CSV files, and the
# results are written to a text file named "statistical_age_analysis.txt".

#

using CSV
using DataFrames
using Statistics
using HypothesisTests

# Read the CSV files (you may need to change the address )
type1_data = CSV.read("./Type1_HF_age_group.csv", DataFrame)
type2_data = CSV.read("./Type2_HF_age_group.csv", DataFrame)

# Open the file to write results
open("statistical_age_analysis.txt", "w") do io
    # Descriptive statistics
    println(io, "Type 1 Diabetes Descriptive Statistics:")
    println(io, "Mean: ", mean(type1_data[:, :Percentage]))
    println(io, "Median: ", median(type1_data[:, :Percentage]))
    println(io, "Standard Deviation: ", std(type1_data[:, :Percentage]))
    println(io, "Minimum: ", minimum(type1_data[:, :Percentage]))
    println(io, "Maximum: ", maximum(type1_data[:, :Percentage]))

    println(io, "\nType 2 Diabetes Descriptive Statistics:")
    println(io, "Mean: ", mean(type2_data[:, :Percentage]))
    println(io, "Median: ", median(type2_data[:, :Percentage]))
    println(io, "Standard Deviation: ", std(type2_data[:, :Percentage]))
    println(io, "Minimum: ", minimum(type2_data[:, :Percentage]))
    println(io, "Maximum: ", maximum(type2_data[:, :Percentage]))

    # Hypothesis testing (two-sample t-test)
    t_test_result = EqualVarianceTTest(type1_data.Percentage, type2_data.Percentage)
    println(io, "\nT-test result:")
    println(io, t_test_result)
end
