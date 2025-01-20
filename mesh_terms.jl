
# load HTTP package
using HTTP

# function to perform pubmed search
function ncbi_mesh_search(pubmed_query, ncbi_key)
    # define base URL
    base_search_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"

    # tell user what search will be performed
    println("hello. I will search PubMed for $pubmed_query")

    # define query dictionary to send to the URL
    query_dict = Dict()
    query_dict["api_key"] = ncbi_key
    query_dict["db"] = "pubmed"
    query_dict["term"] = pubmed_query    
    query_dict["retmax"] = 1000

    # send query to esearch
    search_result = String(HTTP.post(base_search_query, body=HTTP.escapeuri(query_dict)))

    #print(search_result)

    # instantiate pmid_set
    pmid_set = Set()

    # parse through each result line
    for result_line in split(search_result, "\n")
        # println("\$\$\$\$\$ $result_line")

        # use a regular expression to capture the PMIDs from 
        # lines that match the pattern
        pmid_capture = match(r"<Id>(\d+)<\/Id>", result_line)

        # only push pmids for lines that contain the pattern
        if pmid_capture != nothing
            push!(pmid_set, pmid_capture[1])
        end

    end


    # for pmid in pmid_set
    #     println("captured pmid is: $pmid")
    # end

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

    # instantiate mesh dictionary
    mesh_dict = Dict()

    # pull out MeSH descriptors from efetch results
    for fetch_line in split(fetch_result, "\n")

        # println("\$\$\$\$\$ $fetch_line")

        # define the mesh capture RegEx
        mesh_capture = match(r"MH  - \*?([^/]+)", fetch_line)

        # if the line has the pattern, extract the MeSH descriptor
        # and store into MeSH dictionary & tracking frequency
        if mesh_capture != nothing

            # store MeSH descriptors, keeping track of occurence 
            if haskey(mesh_dict, mesh_capture[1])
                mesh_dict[mesh_capture[1]] += 1
            else
                mesh_dict[mesh_capture[1]] = 1
            end

        end


    end

    # print out counts of MeSH descriptors
    for mesh_descriptor in keys(mesh_dict)
        if mesh_dict[mesh_descriptor] > 30
            println("$mesh_descriptor occurs $(mesh_dict[mesh_descriptor]) times")
        end
    end


end

#####################################################################################################
############# function for affiliation and journal title with counts #################################
#######################################################################################################

# function to perform pubmed search
function ncbi_mesh_search(pubmed_query, ncbi_key)
    # define base URL
    base_search_query = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"

    # tell user what search will be performed
    println("hello. I will search PubMed for $pubmed_query")

    # define query dictionary to send to the URL
    query_dict = Dict()
    query_dict["api_key"] = ncbi_key
    query_dict["db"] = "pubmed"
    query_dict["term"] = pubmed_query    
    query_dict["retmax"] = 1000

    # send query to esearch
    search_result = String(HTTP.post(base_search_query, body=HTTP.escapeuri(query_dict)))

    #print(search_result)

    # instantiate pmid_set
    pmid_set = Set()

    # parse through each result line
    for result_line in split(search_result, "\n")
        # println("\$\$\$\$\$ $result_line")

        # use a regular expression to capture the PMIDs from 
        # lines that match the pattern
        pmid_capture = match(r"<Id>(\d+)<\/Id>", result_line)

        # only push pmids for lines that contain the pattern
        if pmid_capture != nothing
            push!(pmid_set, pmid_capture[1])
        end

    end


    # for pmid in pmid_set
    #     println("captured pmid is: $pmid")
    # end

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
    
    # instantiate mesh dictionary
    affiliation_dict = Dict()

    # pull out MeSH descriptors from efetch results
    for fetch_line in split(fetch_result, "\n")

        # println("\$\$\$\$\$ $fetch_line")

        # define the mesh capture RegEx
        affiliation_capture = match(r"MH  - \*?([^/]+)", fetch_line)

        # if the line has the pattern, extract the MeSH descriptor
        # and store into MeSH dictionary & tracking frequency
        if affiliation_capture != nothing

            # store MeSH descriptors, keeping track of occurence 
            if haskey(affiliation_dict, affiliation_capture[1])
                affiliation_dict[affiliation_capture[1]] += 1
            else
                affiliation_dict[affiliation_capture[1]] = 1
            end

        end


    end

    # print out counts of MeSH descriptors
    for affiliation_descriptor in keys(affiliation_dict)
        if affiliation_dict[affiliation_descriptor] > 30
            println("$affiliation_descriptor occurs $(affiliation_dict[affiliation_descriptor]) times")
        end
    end


end





# for loop for affiliation and count
# for loop for journal title and count

###### separate file ########
# for loop for date of publication, filter for after 2007 
# publication type and count
# place of publication and count

# load file that contains api keys
include("./api_keys.jl") 

function main()

    ncbi_key = api_key["ncbi"]
    pubmed_query =  """  "heart failure"[mh] and "diabetes mellitus"[mh] """

    #println(ncbi_key)

    ncbi_mesh_search(pubmed_query, ncbi_key)


    println("... that was fun!")


end


main()

#"heart failure"[mh] or "heart failure, systolic"[mh] or "heart failure, diastolic"[mh] 
#   or "cardiomyothpathy, diabetic" [mh] or "diabetes mellitus, type 2"[mh] or "diabetes mellitus, type 1"[mh]) and 
#   "diabetes mellitus"[mh]