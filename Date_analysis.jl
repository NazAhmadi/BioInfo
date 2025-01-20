# Author: Nazanin Ahmadi  
# Contact: Nazanin@brown.edu

#This code is a script that searches PubMed for publications related to specific MeSH (Medical Subject Heading) terms
#and visualizes the number of publications per year (starting from 2008). 

# load HTTP package
using HTTP
# load Plots package
using Plots

# function to perform pubmed search
function ncbi_mesh_search(pubmed_query, ncbi_key)
    # define base URL
    base_search_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"

    # tell user what search will be performed
    println("Hello! I will count the number of publications(>2007) per year for $pubmed_query ")

    # define query dictionary to send to the URL
    query_dict = Dict()
    query_dict["api_key"] = ncbi_key
    query_dict["db"] = "pubmed"
    query_dict["term"] = pubmed_query
    query_dict["retmax"] = 1000

    # send query to esearch
    search_result = String(HTTP.post(base_search_query, body=HTTP.escapeuri(query_dict)))

    # instantiate pmid_set
    pmid_set = Set()

    # parse through each result line
    for result_line in split(search_result, "\n")
        # use a regular expression to capture the PMIDs from 
        # lines that match the pattern
        pmid_capture = match(r"<Id>(\d+)<\/Id>", result_line)

        # only push pmids for lines that contain the pattern
        if pmid_capture != nothing
            push!(pmid_set, pmid_capture[1])
        end
    end

    # convert set to a comma list
    id_string = join(collect(pmid_set), ",")

    # update query dictionary for fetch query
    base_fetch_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi"
    query_dict["db"] = "pubmed"
    query_dict["api_key"] = ncbi_key
    query_dict["id"] = id_string
    query_dict["rettype"] = "medline"
    query_dict["retmode"] = "text"

    # send query dictionary to efetch
    fetch_result = String(HTTP.post(base_fetch_query, body=HTTP.escapeuri(query_dict)))

    # instantiate date dictionary
    date_dict = Dict()

    # pull out publication dates from efetch results
    for fetch_line in split(fetch_result, "\n")

        # define the date capture RegEx
        date_capture = match(r"DP\s+-\s+(\d{4})", fetch_line)

        # if the line has the pattern, extract the year
        # and store into date dictionary & tracking frequency
        if date_capture != nothing

            year = date_capture[1]

            # check if year is after 2007
            if parse(Int, year) > 2007
                # store publication dates, keeping track of occurrence 
                if haskey(date_dict, year)
                    date_dict[year] += 1
                else
                    date_dict[year] = 1
                end
            end
        end
    end

    # print out counts of publication dates
    for year in sort(collect(keys(date_dict)))
        if date_dict[year] > 1
            println("$year occurs $(date_dict[year]) times")
        end
    end

    # plot publication dates
    plot(sort(collect(keys(date_dict))), [date_dict[year] for year in sort(collect(keys(date_dict)))],
        xlabel="Year", ylabel="Number of Publications of type1_HF", title="Publications by Year",
        legend=false, seriestype=:bar)
    savefig("type1_HF.png")
end

include("./api_keys.jl")
function main()
    println("Hello! I hope you are having a nice day!!")

    ncbi_key = api_key["ncbi"]

    # pubmed_query = """ "Diabetes Mellitus, Type 2"[Mesh] AND "Heart Failure, Diastolic"[Mesh] """
    # pubmed_query = """"Diabetes Mellitus, Type 2"[Mesh] AND "Heart Failure, Systolic"[Mesh] """
    # pubmed_query = """ "Diabetes Mellitus, Type 1"[Mesh] AND "Heart Failure, Diastolic"[Mesh] """
    # pubmed_query = """"Diabetes Mellitus, Type 1"[Mesh] AND "Heart Failure, Systolic"[Mesh] """
    # pubmed_query = """"Diabetes Mellitus AND "Heart Failure, Systolic"[Mesh] """
    # pubmed_query = """"Diabetes Mellitus AND "Heart Failure, Diastolic"[Mesh] """
    # pubmed_query = """ "Diabetes Mellitus, Type 2"[Mesh] AND "Heart Failure"[Mesh]"""
    pubmed_query = """ "Diabetes Mellitus, Type 1"[Mesh] AND "Heart Failure"[Mesh]"""
    ncbi_mesh_search(pubmed_query, ncbi_key)

    println("... that was fun!")
end
main()