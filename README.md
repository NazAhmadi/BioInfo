### team03_pace_makers
### Title: Heart Failure in Diabetic Patients: A Systematic Review of Publication Patterns on PubMed
###
| Table of Contents |
| ----------------- |
| [1. Introduction](#Introduction) |
| [2. General Installation](#General-Installation) |
| [3. UML diagram](#The-workflow-of-each-file-(UML-diagrams)) |
| [4. Getting Started](#Getting-Started) |
| [5. Contributing](#contributing) |
| [6. To Do](#To-Do) |
| [7. Contact](#Contact) |



## Introduction

This study systematically reviewed PubMed to analyze publication patterns of heart failure (HF) in  mellitus diabetic patients. Over 500 articles retrieved were included after applying inclusion and exclusion criteria (later discussed in the methods section), with one the first requirement being that each literature piece must include the mesh terms “heart failure AND Diabetes mellitus”. The majority of articles were original research studies, with the most common topic being the epidemiology of heart failure in diabetic patients, followed by management, and treatment.  This study underscores the need for further research to better understand HF mechanisms in diabetic patients and improve prevention and management strategies. We discovered that there seems to be a significant relation between heart failure being more persistent in patients who have Type 2 diabetes compared to other diabetes.





## General Installation

You need to install [Julia](https://julialang.org/).



## The workflow of each file (UML diagrams)
- [Final Diabetic Heart Failure Diagram](https://lucid.app/lucidchart/7d0e51b5-1879-4b23-9d92-8b58466dc15b/edit?invitationId=inv_718ded91-ae21-4cb8-9ff4-047b24b08c64&page=zmIYr3Bxl.j0#)
- [Age_group_analysis](https://lucid.app/lucidchart/9dc3033f-dc34-41eb-a39b-a8ee824c090e/edit?viewport_loc=285%2C-23%2C2111%2C1164%2C0_0&invitationId=inv_74b05b9e-a6fd-460c-873c-089a1e4df0e4)
- [Date_analysis](https://lucid.app/lucidchart/0566af0a-340b-4b9e-9388-27745033a754/edit?viewport_loc=-542%2C78%2C2730%2C1319%2C0_0&invitationId=inv_8953cd29-74ba-49ef-b0a3-3349a6e3caff)
- [Statistical_age_analysis](https://lucid.app/lucidchart/1f382ed2-4d1c-430e-9230-3408f2be46a0/edit?viewport_loc=-743%2C-233%2C2940%2C1420%2C0_0&invitationId=inv_1982f4d4-1845-4121-bf19-4771bdd90846)
-[Date and mesh analysis](https://lucid.app/lucidchart/2c5276b8-afb0-4078-94d6-acf869f0bbc3/edit?viewport_loc=-126%2C25%2C2260%2C1181%2C0_0&invitationId=inv_639c7916-b1a0-469a-8726-bc6dbf2a0d0c)
-[treatment mesh term count](https://lucid.app/lucidchart/086c4775-b663-4da9-9935-24c4e8328450/edit?viewport_loc=86%2C494%2C2260%2C1181%2C0_0&invitationId=inv_f00b3a33-b2ef-4432-ac4d-ceea1f8bf498)
- [Affiliation Occurences](https://lucid.app/lucidchart/702c3cff-f62b-4371-8c63-f6ba76103788/edit?view_items=DwW4I2DslUAN&invitationId=inv_182b2fbf-53bf-4bd5-b8f1-eb0944d84f2d)
- [Publication, Journal Type, and Place Analysis](https://lucid.app/lucidchart/659e5760-c602-4d98-b2c9-72545cc3cb27/edit?viewport_loc=-775%2C-23%2C4326%2C2023%2C0_0&invitationId=inv_eccd658e-0c65-4117-9f4f-9d8bbaac5eea)


## Getting Started
Get NCBI API Key:
- Create NCBI Account (sign in with Google): https://www.ncbi.nlm.nih.gov/account/
- Go to NCBI Account Setting (click on your username in upper right corner)
- Go to API Key Management and click “Create an API Key”
- Use this key by passing it with api_key=API_KEY parameter. Refer to documentation for more.
- Create file called api_keys.jl in your directory, with the following lines (where “<APIKEYHERE>” is the API Key that you copy from the NCBI website:
api_key = Dict()
api_key["ncbi"] = "<APIKEYHERE>"

Installing the libraries:
- HTTPS
- Plots
- DataFrames
- Statistics
- HypothesisTests
- CSV
- PlotlyJS
  
Running it:
Katelin's Code: 
treatment_mesh_term_count.jl and date_and_mesh_analysis.jl are on Oscar and Github. After creating API key, just type julia treatment_mesh_term_count.jl followed julia date_and_mesh_analysis.jl. One output file Mesh2_HF.png will lead to the plot. 
 
 Victoria's Code:
  
 placeofpub.jl, journal_type.jl, and pubtypefiler.jl are only on Oscar due to permission denial to push to Github. After creating API key, the files above should lead you to the following plots: placeofpub.png, pubtype_count.png, journaltype_count.png
  
 Destiny's Code:
affiliations.jl.txt and affiliationcount.txt are on Github. affiliations.jl and affiliation.txt are on Oscar. After creating  After creating API key, just type julia affiliations.jl. There will be two output files including the affiliations2.png file that displays the bar graph visual and the affiliations.txt file which includes the affiliations and the number of occurences.


## Contributing
Nazanin :
- [Date_analysis.jl](https://github.com/methods2023/team03_pace_makers/blob/d1a8af72350e5bf825747972ee98f71bbb5bc82e/Date_analysis.jl)
- [Age_group_analysis.jl](https://github.com/methods2023/team03_pace_makers/blob/d1a8af72350e5bf825747972ee98f71bbb5bc82e/age_group_analysis.jl)
- [Statistical_age_analysis.jl](https://github.com/NazAhmadi/BioInfo/statistical_age_analysis.jl)

Destiny:
- [Affiliation.jl](https://github.com/methods2023/team03_pace_makers/blob/master/affiliations.jl.txt)
- [Affiliation Counts](https://github.com/methods2023/team03_pace_makers/blob/master/affiliationcount.txt)
  

Victoria: (See above for contributions)
- [Mesh Terms.jl](https://github.com/methods2023/team03_pace_makers/blob/master/mesh_terms.jl)
  
Katelin:
- [Date and mesh analysis]( https://github.com/methods2023/team03_pace_makers/blob/master/date_and_mesh_analysis.jl)
- [treatment mesh term count](https://github.com/methods2023/team03_pace_makers/blob/master/treatment_mesh_term_count.jl)

Thank you Nazanin, Katelin, Destiny and Victoria
  
  
## To Do
-Next steps
  -Apply real clinical and patient information to future studies
  
  -Focus on specifically Type 2 Diabetes and heart failure relationship

-Known bugs (shortlist)
  -Filtering publications after 2007 year in addition to other element analysis
  
  -Great Bias
  
  -Limited Informmation
  
## Contact
Email addresses: 
- Nazanin@Brown.edu 
- katelin_ferreira@brown.edu
- victoria_grase@brown.edu
- destiny_rankins@brown.edu

