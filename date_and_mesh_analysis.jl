# load HTTP package
using HTTP


# function to perform pubmed search
function ncbi_mesh_search(pubmed_query, ncbi_key)
    # define base URL
    base_search_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"

    # tell user what search will be performed
    println("Hello! I will analyze the treatments for heart failure patients with diabetes ")

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
    mesh_dict = Dict()
    year = 1000
    year_hold = 1000
    # pull out publication dates from efetch results
    for fetch_line in split(fetch_result, "\n")

    # define the date and mesh capture RegEx
        Mesh_capture = match(r"MH  - \*?([^/]+)", fetch_line)
        date_capture = match(r"DP\s+-\s+(\d{4})", fetch_line)

    #Store date
        if date_capture != nothing
            year = date_capture[1]
            if year == 1000
                year = date_capture[1]
                
            else
                if year != date_capture[1]
                    year = date_capture[1]
                end
            end   
        end

    #
        if Mesh_capture != nothing
            Mesh_term = Mesh_capture[1]
            #println("year $year")
            if parse(Int, year) == 2018 || parse(Int, year) == 2019 || parse(Int, year) == 2020|| parse(Int, year) == 2021 || parse(Int, year) == 2022 || parse(Int, year) == 2023
                if year != 0 && Mesh_capture[1] != nothing
                    #println("Found> $year / $Mesh_term")        # if haskey(date_dict, year)
                    if haskey(mesh_dict, Mesh_capture[1])
                        mesh_dict[Mesh_capture[1]] += 1
                    else
                        mesh_dict[Mesh_capture[1]] = 1
                    end        
                    Mesh_term = "x"
                end
            end
        end

        if Mesh_capture != nothing
            if haskey(date_dict, Mesh_capture[1])
                #println("Here $(date_dict[Mesh_capture[1]])")
                if date_dict[Mesh_capture[1]] > year
                    #println("Year: $(date_dict[Mesh_capture[1]])")
                    date_dict[Mesh_capture[1]] = year
                end
            else
                #println("First Year $year")
                date_dict[Mesh_capture[1]] = year
            end
            #println("mesh year: $(date_dict[Mesh_capture[1]])")
            #println("Year: $year")
        end
    end

#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    count = 0
    high_count = 0

    for Mesh_term in sort(collect(keys(mesh_dict)))
        #if haskey(mesh_dict, Mesh_term)
        if mesh_dict[Mesh_term] > high_count
            high_count = mesh_dict[Mesh_term]
        end
    end

    #println("High Count $high_count")    
    # print out counts of publication dates
    for Mesh_term in sort(collect(keys(mesh_dict)))
        #if haskey(mesh_dict, Mesh_term)
        if mesh_dict[Mesh_term] >= 15
            println("$Mesh_term occurs $(mesh_dict[Mesh_term]) times from 2018-2023 and first occurred in the year $(date_dict[Mesh_term])")
        end
    end
    
end
    

include("./api_keys.jl")
function main()
    println("Hello! I hope you are having a nice day!!")

    ncbi_key = api_key["ncbi"]

    pubmed_query = """ "Diabetes Mellitus"[Mesh] AND "Heart Failure"[Mesh] and "Treatments" """
    ncbi_mesh_search(pubmed_query, ncbi_key)

    println("... that was fun!")

end
main()