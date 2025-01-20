# Author: Nazanin Ahmadi  
# Contact: Nazanin@brown.edu
# https://lucid.app/lucidchart/9dc3033f-dc34-41eb-a39b-a8ee824c090e/edit?viewport_loc=285%2C-23%2C2111%2C1164%2C0_0&invitationId=inv_74b05b9e-a6fd-460c-873c-089a1e4df0e4



#This program retrieves publications related to diabetes and heart failure from the NCBI PubMed database,
#then calculates the number of publications for each age group. 
#The search query can be modified to focus on Type 1 or Type 2 diabetes or specific type of Heart failure 

#    Infant: Birth to 23 months
#    Child: 2 to 12 years
#    Adolescent: 13 to 18 years
#    Young Adult: 19 to 24 years
#    Adult: 25 to 44 years
#    Middle Aged: 45 to 64 years
#    Aged: 65 years and older

using HTTP
using DataFrames
using CSV

function ncbi_mesh_search(pubmed_query, ncbi_key)

    retmax = 30000
    retstart = 0

    query_dict = Dict()
    age_group_dict = Dict(:Infant => 0, :Child => 0, :Adolescent => 0, :YoungAdult => 0, :Adult => 0, :MiddleAged => 0, :Aged => 0)

    while (retstart < retmax)
        base_search_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"
        println("hello. I will count the number of publications/each age_group for  $pubmed_query")

        query_dict["api_key"] = ncbi_key
        query_dict["db"] = "pubmed"
        query_dict["term"] = pubmed_query
        query_dict["retmax"] = retmax
        query_dict["retstart"] = retstart

        search_result = String(HTTP.post(base_search_query, body=HTTP.escapeuri(query_dict)))
        pmid_set = Set()

        for result_line in split(search_result, "\n")
            pmid_capture = match(r"<Id>(\d+)<\/Id>", result_line)
            if pmid_capture != nothing
                push!(pmid_set, pmid_capture[1])
            end
        end

        id_string = join(collect(pmid_set), ",")
        base_fetch_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
        query_dict["db"] = "pubmed"
        query_dict["api_key"] = ncbi_key
        query_dict["id"] = id_string
        query_dict["rettype"] = "medline"
        query_dict["retmode"] = "text"
        query_dict["retstart"] = 0

        success = false
        fetch_result = ""
        while (!success)
            try
                sleep(2)
                fetch_result = String(HTTP.post(base_fetch_query, body=HTTP.escapeuri(query_dict)))
                success = true
            catch e
                println("Encountered $e. Re-attempting E-Fetch query.")
            end
        end

        for fetch_line in split(fetch_result, "\n")
            age_capture = match(r"MH\s+-\s+(.*)", fetch_line)
            if age_capture != nothing
                age = lowercase(age_capture[1])

                if occursin("infant", age)
                    age_group_dict[:Infant] += 1
                elseif occursin("child", age)
                    age_group_dict[:Child] += 1
                elseif occursin("adolescent", age)
                    age_group_dict[:Adolescent] += 1
                elseif occursin("young adult", age)
                    age_group_dict[:YoungAdult] += 1
                elseif occursin("adult", age)
                    age_group_dict[:Adult] += 1
                elseif occursin("middle aged", age)
                    age_group_dict[:MiddleAged] += 1
                elseif occursin("aged", age)
                    age_group_dict[:Aged] += 1
                end
            end
        end

        retstart += 10000
        sleep(2)
    end

    total_publications = sum(values(age_group_dict))
    percentages = [(value / total_publications) * 100 for value in values(age_group_dict)]

    df = DataFrame(AgeGroup=collect(keys(age_group_dict)), Count=collect(values(age_group_dict)), Percentage=percentages)
    df.TotalPublications = fill(total_publications, size(df, 1))
    CSV.write("./Type2_HF_age_group.csv", df)
    println(df)
end

include("./api_keys.jl")

function main()
    println("Hello! I hope you are having a nice day!!")

    ncbi_key = api_key["ncbi"]

    pubmed_query = """ "Diabetes Mellitus, Type 2"[Mesh] AND "Heart Failure"[Mesh]"""
    # pubmed_query = """ "Diabetes Mellitus, Type 1"[Mesh] AND "Heart Failure"[Mesh]"""
    # pubmed_query = """ "Diabetes Mellitus"[Mesh] AND "Heart Failure"[Mesh]"""

    ncbi_mesh_search(pubmed_query, ncbi_key)

    println("... that was fun!")
end

main()

